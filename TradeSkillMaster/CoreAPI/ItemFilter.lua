-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- This file contains APIs for advanced item filtering

local TSM = select(2, ...)
local private = {classLookup={}, subClassLookup={}, inventoryTypeLookup={}}



-- ============================================================================
-- TSMAPI Functions
-- ============================================================================

function TSMAPI.ItemFilter:Parse(str)
	local filterInfo = {}
	for i, part in ipairs({("/"):split(str)}) do
		part = part:trim()
		if i == 1 then
			-- first part must be a filter string
			filterInfo.str = part
		elseif part == "" then
			-- ignore an empty part
		elseif tonumber(part) then
			if filterInfo.maxLevel then
				-- already have min / max level
				return
			elseif filterInfo.minLevel then
				filterInfo.maxLevel = tonumber(part)
			else
				filterInfo.minLevel = tonumber(part)
			end
		elseif tonumber(strmatch(part, "^i(%d+)")) then
			if filterInfo.maxILevel then
				-- already have min / max item level
				return
			elseif filterInfo.minILevel then
				filterInfo.maxILevel = tonumber(strmatch(part, "^i(%d+)"))
			else
				filterInfo.minILevel = tonumber(strmatch(part, "^i(%d+)"))
			end
		elseif private:ItemClassToIndex(part) then
			filterInfo.class = private:ItemClassToIndex(part)
		elseif private:ItemSubClassToIndex(part, filterInfo.class) then
			filterInfo.subClass = private:ItemSubClassToIndex(part, filterInfo.class)
		elseif private:ItemInventoryTypeToIndex(part) then
			filterInfo.invType = private:ItemInventoryTypeToIndex(part)
		elseif private:ItemRarityToIndex(part) then
			filterInfo.rarity = private:ItemRarityToIndex(part)
		elseif TSMAPI:MoneyFromString(part) then
			if filterInfo.minPrice then
				filterInfo.maxPrice = TSMAPI:MoneyFromString(part)
			else
				filterInfo.minPrice = TSMAPI:MoneyFromString(part)
			end
		elseif strlower(str) == "usable" then
			if filterInfo.usableOnly then return end
			filterInfo.usableOnly = true
		elseif strlower(str) == "exact" then
			if filterInfo.exactOnly then return end
			filterInfo.exactOnly = true
		elseif strlower(str) == "even" then
			if filterInfo.evenOnly then return end
			filterInfo.evenOnly = true
		else
			-- invalid part
			return
		end
	end

	-- setup some defaults
	filterInfo.str = filterInfo.str or ""
	filterInfo.escapedStr = TSMAPI.Util:StrEscape(filterInfo.str)
	filterInfo.minLevel = filterInfo.minLevel or 0
	filterInfo.maxLevel = filterInfo.maxLevel or math.huge
	filterInfo.minILevel = filterInfo.minILevel or 0
	filterInfo.maxILevel = filterInfo.maxILevel or math.huge
	filterInfo.minPrice = filterInfo.minPrice or 0
	filterInfo.maxPrice = filterInfo.maxPrice or math.huge
	return filterInfo
end

function TSMAPI.ItemFilter:MatchesFilter(filterInfo, item, price)
	local name, _, iRarity, ilvl, lvl, class, subClass, _, equipSlot = TSMAPI.Item:GetInfo(item)

	-- check the name
	if not strfind(strlower(name), filterInfo.escapedStr) then
		return
	elseif filterInfo.exactOnly and name ~= filterInfo.str then
		return
	end

	-- check the rarity
	if filterInfo.rarity and iRarity ~= filterInfo.rarity then
		return
	end

	-- check the item level
	if ilvl < filterInfo.minILevel or ilvl > filterInfo.maxILevel then
		return
	end

	-- check the required level
	if lvl < filterInfo.minLevel or lvl > filterInfo.maxLevel then
		return
	end

	-- check the item class
	class = private:ItemClassToIndex(class) or 0
	if filterInfo.class and class ~= filterInfo.class then
		return
	end

	-- check the item subclass
	subClass = private:ItemSubClassToIndex(subClass, class) or 0
	if filterInfo.subClass and subClass ~= filterInfo.subClass then
		return
	end

	-- check the equip slot
	local invType = private:ItemInventoryTypeToIndex(_G[equipSlot])
	if filterInfo.invType and invType ~= filterInfo.invType then
		return
	end

	-- check the price
	price = price or 0
	if price < filterInfo.minPrice or price > filterInfo.maxPrice then
		return
	end

	-- it passed!
	return true
end



-- ============================================================================
-- Init Code
-- ============================================================================

do
	private.classLookup = {GetAuctionItemClasses()}
	private.subClassLookup = {}
	for i in pairs(private.classLookup) do
		private.subClassLookup[i] = {GetAuctionItemSubClasses(i)}
	end

	local auctionInvTypes = {GetAuctionInvTypes(2,1)}
	for i=1, #auctionInvTypes, 2 do
		TSMAPI:Assert(type(auctionInvTypes[i]) == "string")
		private.inventoryTypeLookup[strlower(_G[auctionInvTypes[i]])] = (i + 1) / 2
	end
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private:ItemInventoryTypeToIndex(str)
	if not str then return end
	str = strlower(str)
	return private.inventoryTypeLookup[str]
end

function private:ItemClassToIndex(str)
	for i, class in pairs(private.classLookup) do
		if strlower(str) == strlower(class) then
			return i
		end
	end
end

function private:ItemSubClassToIndex(str, class)
	if not class or not private.subClassLookup[class] then return end

	for i, subClass in pairs(private.subClassLookup[class]) do
		if strlower(str) == strlower(subClass) then
			return i
		end
	end
end

function private:ItemRarityToIndex(str)
	for i=0, 4 do
		local text =  _G["ITEM_QUALITY"..i.."_DESC"]
		if strlower(str) == strlower(text) then
			return i
		end
	end
end
