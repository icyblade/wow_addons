-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- This file contains code for scanning the auction house
local TSM = select(2, ...)
local private = {threadId=nil, db=nil, nameTemp={}}
local BATTLE_PET_CLASS = 11



-- ============================================================================
-- API Functions
-- ============================================================================

function TSMAPI.Auction:GenerateQueries(itemList, callback)
	-- kill any already-running thread
	TSMAPI.Threading:Kill(private.threadId)
	if private.threadId and private.callback then
		private.callback("INTERRUPTED")
	end
	
	-- start the new thread
	private.callback = callback
	private.threadId = TSMAPI.Threading:Start(private.GenerateQueriesThread, 0.5, private.ThreadDone, itemList)
end

function TSMAPI.Auction:GetItemQueryInfo(itemString)
	local name, quality, level, classStr, subClassStr = TSMAPI.Util:Select({1, 3, 5, 6, 7}, TSMAPI.Item:GetInfo(itemString))
	if not name then return end
	local class, subClass = private:LookupClassSubClass(classStr, subClassStr)
	return {name=name, minLevel=level, maxLevel=level, invType=0, class=class, subClass=subClass, quality=quality}
end



-- ============================================================================
-- Helper Tables
-- ============================================================================

local ITEM_CLASS_LOOKUP = {}
for i, class in ipairs({GetAuctionItemClasses()}) do
	ITEM_CLASS_LOOKUP[class] = {}
	ITEM_CLASS_LOOKUP[class].index = i
	for j, subClass in pairs({GetAuctionItemSubClasses(i)}) do
		ITEM_CLASS_LOOKUP[class][subClass] = j
	end
end

local AuctionCountDatabase = setmetatable({}, {
	__call = function(self)
		local new = setmetatable({}, getmetatable(self))
		new.data = {}
		if (TSMAPI:ModuleAPI("AuctionDB", "lastCompleteScanTime") or 0) > time() - 24 * 60 * 60 then
			new.lastScanData = TSMAPI:ModuleAPI("AuctionDB", "lastCompleteScan")
			if not next(new.lastScanData) then
				new.lastScanData = nil
			end
		end
		return new
	end,
	
	__index = {
		objType = "AuctionCountDatabase",
		INDEX_LOOKUP = {itemString=1, numAuctions=2, name=3, quality=4, level=5, class=6, subClass=7},
		
		PopulateData = function(self, threadObj)
			if self.isComplete or not self.lastScanData then return end
			if self.lastPopulateAttempt == time() then return end
			self.lastPopulateAttempt = time()
			self.isComplete = true
			wipe(self.data)
			for itemString, data in pairs(self.lastScanData) do
				if data.minBuyout > 0 then
					TSMAPI:Assert(data.numAuctions)
					local name, _, quality, _, level, class, subClass = TSMAPI.Item:GetInfo(itemString)
					if name then
						local classIndex = ITEM_CLASS_LOOKUP[class] and ITEM_CLASS_LOOKUP[class].index or 0
						local subClassIndex = ITEM_CLASS_LOOKUP[class] and ITEM_CLASS_LOOKUP[class][subClass] or 0
						tinsert(self.data, {itemString, data.numAuctions, strlower(name), quality, level, classIndex, subClassIndex})
					else
						self.isComplete = nil
					end
					threadObj:Yield()
				end
			end
			local sortKeys = {"class", "subClass", "quality", "level", "name"}
			local function SortHelper(a, b)
				for _, key in ipairs(sortKeys) do
					if a[self.INDEX_LOOKUP[key]] ~= b[self.INDEX_LOOKUP[key]] then
						return a[self.INDEX_LOOKUP[key]] < b[self.INDEX_LOOKUP[key]]
					end
				end
				return tostring(a) < tostring(b)
			end
			threadObj:Yield()
			sort(self.data, SortHelper)
		end,
		
		GetNumAuctions = function(self, query)
			TSMAPI:Assert(query.class)
			query.minLevel = query.minLevel or 0
			if not query.minLevel or query.minLevel < 1 then
				query.minLevel = 0
			end
			if not query.maxLevel or query.maxLevel < 1 then
				query.maxLevel = math.huge
			end
			query.quality = query.quality or 0
			local count = 0
			local startIndex = 1
			local function CompareFunc(row)
				if row[self.INDEX_LOOKUP.class] == query.class then
					if not query.subClass or row[self.INDEX_LOOKUP.subClass] == query.subClass then
						return 0
					else
						return row[self.INDEX_LOOKUP.subClass] - query.subClass
					end
				else
					return row[self.INDEX_LOOKUP.class] - query.class
				end
			end
			
			-- binary search for starting index
			local low, mid, high = 1, 0, #self.data
			while low <= high do
				mid = floor((low + high) / 2)
				local cmpValue = CompareFunc(self.data[mid])
				if cmpValue == 0 then
					if mid == 1 or CompareFunc(self.data[mid-1]) ~= 0 then
						-- we've found the row we want
						startIndex = mid
						break
					else
						-- we're too high
						high = mid - 1
					end
				elseif cmpValue < 0 then
					-- we're too low
					low = mid + 1
				else
					-- we're too high
					high = mid - 1
				end
			end
			
			for i=startIndex, #self.data do
				local row = self.data[i]
				if CompareFunc(row) ~= 0 then
					break
				end
				if row[self.INDEX_LOOKUP.quality] >= query.quality and row[self.INDEX_LOOKUP.class] == query.class and (not query.subClass or row[self.INDEX_LOOKUP.subClass] == query.subClass) and row[self.INDEX_LOOKUP.level] >= query.minLevel and row[self.INDEX_LOOKUP.level] <= query.maxLevel then
					count = count + row[self.INDEX_LOOKUP.numAuctions]
				end
			end
			return count
		end,
		
		GetNumAuctionsByItem = function(self, itemList)
			local counts = {}
			for _, itemString in ipairs(itemList) do
				counts[itemString] = 0
			end
			for _, row in ipairs(self.data) do
				local itemString = TSMAPI.Item:ToItemString(row[self.INDEX_LOOKUP.itemString])
				if counts[itemString] then
					counts[itemString] = counts[itemString] + row[self.INDEX_LOOKUP.numAuctions]
				end
			end
			return counts
		end,
	},
})



-- ============================================================================
-- Main Generate Queries Thread
-- ============================================================================

function private.GenerateQueriesThread(self, itemList)
	self:SetThreadName("GENERATE_QUERIES")
	private.db = private.db or AuctionCountDatabase()
	private.db:PopulateData(self)
	local queries = {}
	
	-- get all the item info into the game's cache
	self:Yield()
	local hasItemInfo = self:WaitForItemInfo(itemList, 30)
	
	-- convert to new itemStrings
	local itemStrings = {}
	for i=1, #itemList do
		local itemString = TSMAPI.Item:ToItemString(itemList[i])
		if TSMAPI.Item:HasInfo(itemString) then
			tinsert(itemStrings, itemString)
		end
	end
	
	if #itemStrings < #itemList then
		TSM:LOG_ERR("Only got item info for %d out of %d items", #itemStrings, #itemList)
	end
	
	-- if the DB is not fully populated, or we don't have all the item info, just do individual scans
	if not private.db.isComplete then
		TSM:LOG_ERR("Auction count database not complete")
		for _, itemString in ipairs(itemStrings) do
			local query = TSMAPI.Auction:GetItemQueryInfo(itemString)
			query.items = {TSMAPI.Item:ToItemString(itemString)}
			tinsert(queries, query)
		end
		private.callback("QUERY_COMPLETE", queries)
		return
	end
	self:Yield()
	
	-- get the number of auctions for all the individual items
	local itemNumAuctions = private.db:GetNumAuctionsByItem(itemStrings)
	self:Yield()
	
	-- organize by class
	local badItems = {}
	local itemListByClass = {}
	for _, itemString in ipairs(itemStrings) do
		local classIndex = private:LookupClassSubClass(select(6, TSMAPI.Item:GetInfo(itemString)))
		if classIndex and classIndex ~= BATTLE_PET_CLASS then
			itemListByClass[classIndex] = itemListByClass[classIndex] or {}
			tinsert(itemListByClass[classIndex], itemString)
		elseif TSMAPI.Item:HasInfo(itemString) then
			local query = TSMAPI.Auction:GetItemQueryInfo(itemString)
			query.items = {itemString}
			tinsert(queries, query)
		else
			TSMAPI:Assert(false, "Invalid item info for "..tostring(itemString))
		end
		self:Yield()
	end
	for classIndex, items in pairs(itemListByClass) do
		local totalPages = {raw=0, class=0, subClass=0}
		local tempQueries = {raw={}, class={}, subClass={}}
		local itemListBySubClass = {}
		-- get the number of pages for this class if we don't group on anything
		for _, itemString in ipairs(items) do
			local score = private:NumAuctionsToNumPages(itemNumAuctions[itemString])
			totalPages.raw = totalPages.raw + score
			local query = TSMAPI.Auction:GetItemQueryInfo(itemString)
			query.items = {itemString}
			tinsert(tempQueries.raw, query)
			-- group by subClass
			local subClassIndex = select(2, private:LookupClassSubClass(select(6, TSMAPI.Item:GetInfo(itemString)))) or 0
			itemListBySubClass[subClassIndex] = itemListBySubClass[subClassIndex] or {}
			tinsert(itemListBySubClass[subClassIndex], itemString)
			self:Yield()
		end
		if totalPages.raw > 0 then
			-- get the number of pages if we group by class
			local minQuality, minLevel, maxLevel = private:GetCommonInfo(items)
			totalPages.class = private:NumAuctionsToNumPages(private.db:GetNumAuctions({class=classIndex, quality=minQuality, minLevel=minLevel, maxLevel=maxLevel}))
			tinsert(tempQueries.class, {items=items, name="", class=classIndex, subClass=0, invType=0, quality=minQuality, minLevel=minLevel, maxLevel=maxLevel})
			self:Yield()
		end
		if totalPages.class > 0 then
			-- get the number of pages if we group by class+subClass
			for subClassIndex, items2 in pairs(itemListBySubClass) do
				if subClassIndex == 0 then
					for _, itemString in ipairs(items2) do
						local query = TSMAPI.Auction:GetItemQueryInfo(itemString)
						query.items = {itemString}
						tinsert(tempQueries.subClass, query)
						totalPages.subClass = totalPages.subClass + 1
					end
				else
					local minQuality, minLevel, maxLevel = private:GetCommonInfo(items2)
					local score = private:NumAuctionsToNumPages(private.db:GetNumAuctions({class=classIndex, subClass=subClassIndex, quality=minQuality, minLevel=minLevel, maxLevel=maxLevel}))
					totalPages.subClass = totalPages.subClass + score
					tinsert(tempQueries.subClass, {items=items2, name="", class=classIndex, subClass=subClassIndex, invType=0, quality=minQuality, minLevel=minLevel, maxLevel=maxLevel})
					self:Yield()
				end
			end
		end
		TSM:LOG_INFO("Scanning %d items by class (%d) would be %d pages and by subclass would be %d pages instead of %d", #items, classIndex, totalPages.class, totalPages.subClass, totalPages.raw)
		totalPages.raw = totalPages.raw > 0 and totalPages.raw or math.huge
		totalPages.class = totalPages.class > 0 and totalPages.class or math.huge
		totalPages.subClass = totalPages.subClass > 0 and totalPages.subClass or math.huge
		local minNumPages = min(totalPages.raw, totalPages.class, totalPages.subClass)
		if minNumPages == totalPages.raw then
			TSM:LOG_INFO("Shouldn't group by anything!")
			for _, query in ipairs(tempQueries.raw) do
				if query.name == "" then
					-- attempt to find a common name to filter by
					local commonStr = private:GetCommonName(query.items)
					if commonStr then
						TSM:LOG_INFO("Should group by filter: %s", commonStr)
						query.name = commonStr
					end
				end
				tinsert(queries, query)
			end
		elseif minNumPages == totalPages.class then
			TSM:LOG_INFO("Should group by class")
			for _, query in ipairs(tempQueries.class) do
				if query.name == "" then
					-- attempt to find a common name to filter by
					local commonStr = private:GetCommonName(query.items)
					if commonStr then
						TSM:LOG_INFO("Should group by filter: %s", commonStr)
						query.name = commonStr
					end
				end
				tinsert(queries, query)
			end
		elseif minNumPages == totalPages.subClass then
			TSM:LOG_INFO("Should group by subClass")
			for _, query in ipairs(tempQueries.subClass) do
				if query.name == "" then
					-- attempt to find a common name to filter by
					local commonStr = private:GetCommonName(query.items)
					if commonStr then
						TSM:LOG_INFO("Should group by filter: %s", commonStr)
						query.name = commonStr
					end
				end
				tinsert(queries, query)
			end
		else
			TSMAPI:Assert(false) -- should never happen
		end
		self:Yield()
	end
	
	-- do a final sanity check to make sure we didn't miss any items
	local haveItems = {}
	for _, itemString in ipairs(itemStrings) do
		haveItems[itemString] = 0
	end
	for _, query in ipairs(queries) do
		for _, itemString in ipairs(query.items) do
			haveItems[itemString] = haveItems[itemString] + 1
		end
	end
	for itemString, num in pairs(haveItems) do
		TSMAPI:Assert(num == 1)
	end
	-- convert back to old itemStrings
	for _, query in ipairs(queries) do
		for i=1, #query.items do
			query.items[i] = TSMAPI.Item:ToItemString(query.items[i])
		end
	end
	private.callback("QUERY_COMPLETE", queries)
end

function private:ThreadDone()
	private.threadId = nil
	private.callback = nil
end



-- ============================================================================
-- Helper Functions
-- ============================================================================

function private:LookupClassSubClass(classStr, subClassStr)
	if not classStr or not ITEM_CLASS_LOOKUP[classStr] then return end
	return ITEM_CLASS_LOOKUP[classStr].index, ITEM_CLASS_LOOKUP[classStr][subClassStr]
end

function private:NumAuctionsToNumPages(score)
	return max(ceil(score / 50), 1)
end

function private:GetCommonInfo(items)
	local minQuality, minLevel, maxLevel = nil, nil, nil
	for _, itemString in ipairs(items) do
		local name, quality, level = TSMAPI.Util:Select({1, 3, 5}, TSMAPI.Item:GetInfo(itemString))
		minQuality = min(minQuality or quality, quality)
		minLevel = min(minLevel or level, level)
		maxLevel = max(maxLevel or level, level)
	end
	return minQuality or 0, minLevel or 0, maxLevel or 0
end

function private:GetCommonName(items)
	-- check if we can also group the query by name
	wipe(private.nameTemp)
	for _, itemString in ipairs(items) do
		local name = TSMAPI.Item:GetInfo(itemString)
		if not name then return end
		TSMAPI:Assert(type(name) == "string", "Unexpected item name: "..tostring(name))
		tinsert(private.nameTemp, name)
	end
	if #private.nameTemp ~= #items or #private.nameTemp <= 2 then return end
	sort(private.nameTemp)
	
	-- find common substring with first and last name, and if it's
	-- at least one word long, try and apply it to the rest
	local str1 = private.nameTemp[1]
	local str2 = private.nameTemp[#private.nameTemp]
	local endIndex = 0
	local hasSpace = nil
	for i=1, min(#str1, #str2) do
		local c = strsub(str1, i, i)
		if c ~= strsub(str2, i, i) then
			break
		elseif c == " " then
			hasSpace = true
		end
		endIndex = i
	end
	-- make sure the common substring has at least one space and is at least 3 characters log
	if not hasSpace or endIndex < 3 then return end
	
	local commonStr = strsub(str1, 1, endIndex)
	for _, name in ipairs(private.nameTemp) do
		if strsub(name, 1, endIndex) ~= commonStr then
			return
		end
	end
	return commonStr
end