-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- This file contains APIs related to items (itemLinks/itemStrings/etc)

local TSM = select(2, ...)
local Items = TSM:NewModule("Items", "AceEvent-3.0")
local private = {itemInfoCache=setmetatable({}, {__mode="kv"}), bonusIdCache=setmetatable({}, {__mode="kv"}), bonusIdTemp={}, scanTooltip=nil, pendingItems={}}
local PET_CAGE_ITEM_INFO = {isDefault=true, 0, "Battle Pets", "", 1, "", "", 0}
local WEAPON, ARMOR = GetAuctionItemClasses()
local BATTLE_PET_SUBCLASSES = {GetAuctionItemSubClasses(11)}



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

function TSMAPI.Item:ToItemString(item)
	if not item then return end
	TSMAPI:Assert(type(item) == "number" or type(item) == "string")
	local result = nil

	if tonumber(item) then
		-- assume this is an itemId
		return "i:"..item
	else
		item = item:trim()
	end

	-- test if it's already (likely) an item string or battle pet string
	if strmatch(item, "^p:([0-9%-:]*)$") then
		result = strjoin(":", strmatch(item, "^(p):(%d*:%d*:%d*)"))
		if result then
			return result
		end
		return item
	elseif strmatch(item, "^i:([0-9%-:]*)$") then
		item = gsub(gsub(item, ":0$", ""), ":0$", "") -- remove extra zeroes
		return private:FixItemString(item)
	end

	result = strmatch(item, "^\124cff[0-9a-z]+\124[Hh](.+)\124h%[.+%]\124h\124r$")
	if result then
		-- it was a full item link which we've extracted the itemString from
		item = result
	end

	-- test if it's an old style item string
	result = strjoin(":", strmatch(item, "^(i)tem:([0-9%-]*):[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:([0-9%-]*)$"))
	if result then
		result = gsub(gsub(result, ":0$", ""), ":0$", "") -- remove extra zeroes
		return private:FixItemString(result)
	end

	-- test if it's an old style battle pet string (or if it was a link)
	result = strjoin(":", strmatch(item, "^battle(p)et:(%d*:%d*:%d*)"))
	if result then
		return result
	end
	result = strjoin(":", strmatch(item, "^battle(p)et:(%d*)$"))
	if result then
		return result
	end
	result = strjoin(":", strmatch(item, "^(p):(%d*:%d*:%d*)"))
	if result then
		return result
	end

	-- test if it's a long item string
	result = strjoin(":", strmatch(item, "(i)tem:([0-9%-]*):[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:([0-9%-]*):[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:([0-9%-:]+)"))
	if result and result ~= "" then
		result = gsub(gsub(result, ":0$", ""), ":0$", "") -- remove extra zeroes
		return private:FixItemString(result)
	end

	-- test if it's a shorter item string (without bonuses)
	result = strjoin(":", strmatch(item, "(i)tem:([0-9%-]*):[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:([0-9%-]*)"))
	if result and result ~= "" then
		result = gsub(gsub(result, ":0$", ""), ":0$", "") -- remove extra zeroes
		return result
	end
end

function TSMAPI.Item:ToBaseItemString(itemString, doGroupLookup)
	-- make sure it's a valid itemString
	itemString = TSMAPI.Item:ToItemString(itemString)
	if not itemString then return end

	local baseItemString = strmatch(itemString, "([ip]:%d+)")

	if not doGroupLookup or (TSM.db.profile.items[baseItemString] and not TSM.db.profile.items[itemString]) then
		-- either we're not doing a group lookup, or the base item is in a group and the specific item is not, so return the base item
		return baseItemString
	end
	return itemString
end

--- Attempts to get the itemID from a given itemLink/itemString.
-- @param itemLink The link or itemString for the item.
-- @return Returns the itemID as the first parameter. On error, will return nil as the first parameter and an error message as the second.
function TSMAPI.Item:ToItemID(itemString)
	itemString = TSMAPI.Item:ToItemString(itemString)
	if type(itemString) ~= "string" then return end
	return tonumber(strmatch(itemString, "^i:(%d+)"))
end

function TSMAPI.Item:ToItemLink(itemString)
	itemString = TSMAPI.Item:ToItemString(itemString)
	if not itemString then return "?" end
	local link = select(2, TSMAPI.Item:GetInfo(itemString))
	if link then return link end
	if strmatch(itemString, "p:") then
		local _, speciesId, level, quality = (":"):split(itemString)
		return "|cffff0000|Hbattlepet"..strjoin(":", speciesId, level or 0, quality or 0, 0, 0, 0).."|h[Unknown Pet]|h|r"
	elseif strmatch(itemString, "i:") then
		return "|cffff0000|H"..gsub(itemString, "i:", "item:").."|h[Unknown Item]|h|r"
	end
	return "?"
end

function TSMAPI.Item:QueryInfo(itemString)
	tinsert(private.pendingItems, itemString)
end

function TSMAPI.Item:HasInfo(info)
	if type(info) == "string" then
		return TSMAPI.Item:GetInfo(info) and true
	elseif type(info) == "table" then
		TSMAPI:Assert(#info > 0)
		local result = true
		-- don't stop when we find one that doesn't have info so that we
		-- still query the info from the server for every item
		for _, itemString in ipairs(info) do
			if not TSMAPI.Item:HasInfo(itemString) then
				result = false
			end
		end
		return result
	else
		TSMAPI:Assert(false, "Invalid argument")
	end
end

function TSMAPI.Item:GetInfo(item)
	if not item then return end
	local itemString = TSMAPI.Item:ToItemString(item)
	if not itemString then return end

	if not private.itemInfoCache[itemString] then
		-- check if it's a new itemString
		if strmatch(itemString, "^i:") then
			local itemId = strmatch(itemString, "^i:([0-9]+)$")
			if itemId then
				-- just the itemId is specified, so simply extract that
				private.itemInfoCache[itemString] = {GetItemInfo(itemId)}
			else
				-- there is a random enchant or bonusId, so extract those (with a max of 10 bonuses
				local _, itemId, rand, numBonus = (":"):split(itemString)
				if numBonus then
					private.itemInfoCache[itemString] = {GetItemInfo(strjoin(":", "item", itemId, 0, 0, 0, 0, 0, rand, 0, 0, 0, 0, 0, select(4, (":"):split(itemString))))}
				elseif rand then
					private.itemInfoCache[itemString] = {GetItemInfo(strjoin(":", "item", itemId, 0, 0, 0, 0, 0, rand))}
				else
					private.itemInfoCache[itemString] = {GetItemInfo(itemId)}
				end
			end
		elseif strmatch(itemString, "^p:") then
			local _, speciesID, level, quality, health, power, speed, petID = strsplit(":", itemString)
			if not tonumber(speciesID) then return end
			level, quality, health, power, speed, petID = level or 0, quality or 0, health or 0, power or 0, speed or 0, petID or "0"

			local name, texture, petType = C_PetJournal.GetPetInfoBySpeciesID(tonumber(speciesID))
			local iSubType = petType and BATTLE_PET_SUBCLASSES[petType] or ""
			if not name or name == "" or tonumber(name) or not texture then return end
			level, quality = tonumber(level), tonumber(quality)
			petID = strsub(petID, 1, (strfind(petID, "|") or #petID) - 1)
			if not ITEM_QUALITY_COLORS[quality] then return end
			local itemLink = ITEM_QUALITY_COLORS[quality].hex .. "|Hbattlepet:" .. speciesID .. ":" .. level .. ":" .. quality .. ":" .. health .. ":" .. power .. ":" .. speed .. ":" .. petID .. "|h[" .. name .. "]|h|r"
			if PET_CAGE_ITEM_INFO.isDefault then
				local data = {select(5, GetItemInfo(82800))}
				if #data > 0 then
					PET_CAGE_ITEM_INFO = data
				end
			end
			local minLvl, iType, _, stackSize, _, _, vendorPrice = unpack(PET_CAGE_ITEM_INFO)
			private.itemInfoCache[itemString] = {name, itemLink, quality, level, minLvl, iType, iSubType, stackSize, "", texture, vendorPrice}
		else
			TSMAPI:Assert(false, format("Invalid item string: '%s'", tostring(itemString)))
		end
		if private.itemInfoCache[itemString] and #private.itemInfoCache[itemString] == 0 then private.itemInfoCache[itemString] = nil end
	end
	if not private.itemInfoCache[itemString] then return end
	return unpack(private.itemInfoCache[itemString])
end

function TSMAPI.Item:IsSoulbound(...)
	local numArgs = select('#', ...)
	if numArgs == 0 then return end
	local bag, slot, itemString, ignoreBOA
	local firstArg = ...
	if type(firstArg) == "string" then
		TSMAPI:Assert(numArgs <= 2, "Too many arguments provided with itemString")
		itemString, ignoreBOA = ...
		if strmatch(itemString, "^p:") then
			-- battle pets are not soulbound
			return
		end
	elseif type(firstArg) == "number" then
		bag, slot, ignoreBOA = ...
		TSMAPI:Assert(slot, "Second argument must be slot within bag")
		TSMAPI:Assert(numArgs <= 3, "Too many arguments provided with bag / slot")
	else
		TSMAPI:Assert(false, "Invalid arguments")
	end

	if not TSMScanTooltip then
		CreateFrame("GameTooltip", "TSMScanTooltip", UIParent, "GameTooltipTemplate")
	end
	TSMScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	TSMScanTooltip:ClearLines()

	local result = nil
	if itemString then
		-- it's an itemString
		TSMScanTooltip:SetHyperlink(private:ToWoWItemString(itemString))
	elseif bag and slot then
		local itemID = GetContainerItemID(bag, slot)
		local maxCharges
		if itemID then
			TSMScanTooltip:SetItemByID(itemID)
			maxCharges = private:GetTooltipCharges(TSMScanTooltip)
		end
		if bag == -1 then
			TSMScanTooltip:SetInventoryItem("player", slot + 39)
		else
			TSMScanTooltip:SetBagItem(bag, slot)
		end
		if maxCharges then
			if private:GetTooltipCharges(TSMScanTooltip) ~= maxCharges then
				result = true
			end
		end
	else
		TSMAPI:Assert(false) -- should never get here
	end

	if result then
		TSMScanTooltip:Hide()
		return result
	end
	for id=1, TSMScanTooltip:NumLines() do
		local text = _G["TSMScanTooltipTextLeft" .. id]
		text = text and text:GetText()
		if text then
			if (text == ITEM_BIND_ON_PICKUP and id < 4) or text == ITEM_SOULBOUND or text == ITEM_BIND_QUEST then
				result = true
			elseif not ignoreBOA and (text == ITEM_ACCOUNTBOUND or text == ITEM_BIND_TO_ACCOUNT or text == ITEM_BIND_TO_BNETACCOUNT or text == ITEM_BNETACCOUNTBOUND) then
				result = true
			end
		end
	end
	TSMScanTooltip:Hide()
	return result
end

function TSMAPI.Item:IsCraftingReagent(itemLink)
	if strmatch(itemLink, "battlepet:") or strmatch(itemLink, "^p:") then
		-- ignore battle pets
		return false
	end

	--workaround for recipes having the item info and crafting reagent in the tooltip
	if select(6, TSMAPI.Item:GetInfo(itemLink)) == select(7, GetAuctionItemClasses()) then
		return false
	end

	if not TSMScanTooltip then
		CreateFrame("GameTooltip", "TSMScanTooltip", UIParent, "GameTooltipTemplate")
	end
	TSMScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	TSMScanTooltip:ClearLines()
	TSMScanTooltip:SetHyperlink(itemLink)

	local result = nil
	for id = 1, TSMScanTooltip:NumLines() do
		local text = _G["TSMScanTooltipTextLeft" .. id]
		text = text and text:GetText()
		if text and (text == PROFESSIONS_USED_IN_COOKING) then
			result = true
			break
		end
	end
	TSMScanTooltip:Hide()
	return result
end

function TSMAPI.Item:IsSoulboundMat(itemString)
	return itemString and TSM.STATIC_DATA.soulboundMats[itemString]
end

function TSMAPI.Item:GetVendorCost(itemString)
	return itemString and TSM.db.global.vendorItems[itemString]
end

function TSMAPI.Item:IsDisenchantable(itemString)
	if not itemString or TSM.STATIC_DATA.notDisenchantable[itemString] then return end
	local quality, iType = TSMAPI.Util:Select({3, 6}, TSMAPI.Item:GetInfo(itemString))
	return quality and quality >= 2 and (iType == ARMOR or iType == WEAPON)
end



-- ============================================================================
-- Module Functions
-- ============================================================================

function Items:OnEnable()
	Items:RegisterEvent("MERCHANT_SHOW", "ScanMerchant")
	local itemString = next(TSM.db.global.vendorItems)
	if itemString and TSMAPI.Item:ToItemString(itemString) ~= itemString then
		-- they just upgraded to TSM3, so wipe the table
		wipe(TSM.db.global.vendorItems)
	end

	for itemString, cost in pairs(TSM.STATIC_DATA.preloadedVendorCosts) do
		TSM.db.global.vendorItems[itemString] = TSM.db.global.vendorItems[itemString] or cost
	end
	TSMAPI.Threading:Start(private.ItemInfoThread, 0.1)
end

function Items:ScanMerchant(event)
	for i=1, GetMerchantNumItems() do
		local itemString = TSMAPI.Item:ToItemString(GetMerchantItemLink(i))
		if itemString then
			local price, _, _, _, extendedCost = select(3, GetMerchantItemInfo(i))
			if price > 0 and not extendedCost then
				TSM.db.global.vendorItems[itemString] = price
			else
				TSM.db.global.vendorItems[itemString] = nil
			end
		end
	end
	if event then
		TSMAPI.Delay:AfterTime("scanMerchantDelay", 1, Items.ScanMerchant)
	end
end



-- ============================================================================
-- Item Info Thread
-- ============================================================================

function private.ItemInfoThread(self)
	self:SetThreadName("QUERY_ITEM_INFO")
	self:Sleep(10)
	local yieldPeriod = 10
	local targetItemInfo = {}
	while true do
		for i=#private.pendingItems, 1, -1 do
			if TSMAPI.Item:GetInfo(private.pendingItems[i]) then
				tremove(private.pendingItems, i)
			end
			if i % yieldPeriod == 0 then
				self:Yield(true)
				yieldPeriod = min(yieldPeriod + 10, 50)
			else
				self:Yield()
			end
		end
		self:Sleep(1)
	end
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private:GetTooltipCharges()
	for id=1, TSMScanTooltip:NumLines() do
		local text = _G["TSMScanTooltipTextLeft" .. id]
		if text and text:GetText() then
			local maxCharges = strmatch(text:GetText(), "^([0-9]+) Charges?$")
			if maxCharges then
				return maxCharges
			end
		end
	end
end

function private:ToWoWItemString(itemString)
	local itemId = strmatch(itemString, "^i:([0-9]+)$")
	if itemId then
		-- just the itemId is specified, so simply extract that
		return "item:"..itemId
	else
		-- there is a random enchant or bonusId, so extract those (with a max of 10 bonuses
		local _, itemId, rand, numBonus = (":"):split(itemString)
		if numBonus then
			return strjoin(":", "item", itemId, 0, 0, 0, 0, 0, rand, 0, 0, 0, 0, 0, select(4, (":"):split(itemString)))
		elseif rand then
			return strjoin(":", "item", itemId, 0, 0, 0, 0, 0, rand)
		else
			return "item:"..itemId
		end
	end
end

function private:FixItemString(itemString)
	-- make sure we have the correct number of bonusIds and remove the uniqueId from the end if necessary
	-- get the number of bonusIds (plus one for the count)
	local numParts = select("#", (":"):split(itemString)) - 3
	if numParts > 0 then
		-- get the number of extra parts we have
        local tmp = select(4, (":"):split(itemString))
        if tmp == '' then
            tmp = 0
        end
		local numExtraParts = numParts - 1 - tmp
		for i=1, numExtraParts do
			itemString = gsub(itemString, ":[0-9]*$", "")
		end
		itemString = gsub(gsub(itemString, ":0$", ""), ":0$", "") -- remove extra zeroes
		-- filter out bonusIds we don't care about
		return private:FilterImportantBonsuIds(itemString)
	end
	return itemString
end

function private:CorrectBonusId(bonusId)
	if bonusId >= 19 and bonusId <= 39 then -- Fireflash
		bonusId = 19
	elseif bonusId >= 45 and bonusId <= 65 then -- Peerless
		bonusId = 45
	elseif bonusId >= 66 and bonusId <= 86 then -- Savage
		bonusId = 66
	elseif bonusId >= 87 and bonusId <= 107 then -- Quickblade
		bonusId = 87
	elseif bonusId >= 108 and bonusId <= 128 then -- Feverflare
		bonusId = 108
	elseif bonusId >= 129 and bonusId <= 149 then -- Deft
		bonusId = 129
	elseif bonusId >= 150 and bonusId <= 170 then -- Aurora
		bonusId = 150
	elseif bonusId >= 175 and bonusId <= 195 then -- Merciless
		bonusId = 175
	elseif bonusId >= 196 and bonusId <= 216 then -- Harmonious
		bonusId = 196
	elseif bonusId >= 217 and bonusId <= 237 then -- Strategist
		bonusId = 217
	elseif bonusId >= 238 and bonusId <= 258 then -- Guileful
		bonusId = 238
	elseif bonusId >= 259 and bonusId <= 279 then -- Windshaper
		bonusId = 259
	elseif bonusId >= 280 and bonusId <= 300 then -- Noble
		bonusId = 280
	elseif bonusId >= 301 and bonusId <= 321 then -- Stormbreaker
		bonusId = 301
	elseif bonusId >= 322 and bonusId <= 342 then -- Stalwart
		bonusId = 322
	elseif bonusId >= 343 and bonusId <= 363 then -- Fanatic
		bonusId = 343
	elseif bonusId >= 364 and bonusId <= 384 then -- Zealot
		bonusId = 364
	elseif bonusId >= 385 and bonusId <= 405 then -- Diviner
		bonusId = 385
	elseif bonusId >= 406 and bonusId <= 426 then -- Herald
		bonusId = 406
	elseif bonusId >= 427 and bonusId <= 447 then -- Augur
		bonusId = 427
	end
	return bonusId
end

function private:FilterImportantBonsuIds(itemString)
	local itemId, rand, bonusIds = strmatch(itemString, "i:([0-9]+):([0-9%-]+):[0-9]+:(.+)$")
	if not bonusIds then return itemString end
	if not private.bonusIdCache[bonusIds] then
		wipe(private.bonusIdTemp)
		for id in gmatch(bonusIds, "[0-9]+") do
			id = private:CorrectBonusId(tonumber(id))
			if TSM.STATIC_DATA.importantBonusId[id] and not tContains(private.bonusIdTemp, id) then
				tinsert(private.bonusIdTemp, id)
			end
		end
		sort(private.bonusIdTemp)
		private.bonusIdCache[bonusIds] = { num = #private.bonusIdTemp, value = strjoin(":", unpack(private.bonusIdTemp)) }
	end
	if private.bonusIdCache[bonusIds].num == 0 then
		if tonumber(rand) == 0 then
			return strjoin(":", "i", itemId)
		else
			return strjoin(":", "i", itemId, rand)
		end
	else
		return strjoin(":", "i", itemId, rand, private.bonusIdCache[bonusIds].num, private.bonusIdCache[bonusIds].value)
	end
end
