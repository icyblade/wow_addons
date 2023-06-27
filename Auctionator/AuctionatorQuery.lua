-----------------------------------------

local addonName, addonTable = ...; 
local zc = addonTable.zc;
local zz = zc.md;

AtrQuery = {};
AtrQuery.__index = AtrQuery;

-----------------------------------------

function Atr_NewQuery ()

	local query = {};
	setmetatable (query, AtrQuery);

	query.prevPage			= nil;
	query.numDupPages		= 0;
	query.pagenum			= -1;
	
	return query;
end			

-----------------------------------------

function AtrQuery:CheckForDuplicatePage (pagenum)

	local numBatchAuctions = Atr_GetNumAuctionItems("list");

	local thisPage		= {};
	thisPage.numOnPage	= numBatchAuctions;
	thisPage.items		= {};
	thisPage.pagenum	= pagenum;


	if (self.prevPage) then
--		zc.msg_anm ("Comparing page ", pagenum, " to pge ", self.prevPage.pagenum);
	
		if (self.prevPage.pagenum == pagenum) then
			return false;
		end
	end
	
	if (numBatchAuctions == 0) then
		self.prevPage = thisPage;
		return false;
	end

	local x;
	local prevPage			= self.prevPage;
	local dupPageFound		= true;
	local numDupItems		= 0;
	local allItemsIdentical	= true;
	
	for x = 1, numBatchAuctions do
	
		local name, texture, count, quality, canUse, level, huh, minBid, minIncrement, buyoutPrice, bidAmount, highBidder, owner = GetAuctionItemInfo("list", x);

		thisPage.items[x] = self:BuildItemIDstr (name, count, minBid, buyoutPrice, bidAmount);

		if (prevPage == nil or (thisPage.items[x] ~= prevPage.items[x])) then
		
			dupPageFound = false;
		else
			numDupItems = numDupItems + 1;
		end

		if (x > 1 and allItemsIdentical and thisPage.items[x] ~= thisPage.items[x-1]) then		-- handle those numnuts who post 200 identical auctions
			allItemsIdentical = false;
		end
					

	end

	if (prevPage ~= nil and prevPage.numOnPage ~= thisPage.numOnPage) then
	
--		zz ("page is unique - numauctions didn't match");
		dupPageFound = false;
		
	elseif (dupPageFound and allItemsIdentical) then
	
--		zz ("Dup page found but all items identical: thisPage.numOnPage: ", thisPage.numOnPage);
		dupPageFound = false;
	
	elseif (not dupPageFound) then
	
--		zz ("page is unique");
	end
	
	
	if (dupPageFound) then
	
		self.numDupPages = self.numDupPages + 1;
		zz ("DUPLICATE PAGE FOUND: thisPage.numOnPage: ", thisPage.numOnPage, "  numDupItems: ", numDupItems);
	else
		self.prevPage = thisPage;
	end

	return dupPageFound;
end


-----------------------------------------

function AtrQuery:IsLastPage (pagenum)

	local _, totalAuctions = Atr_GetNumAuctionItems("list");

	return (((pagenum + 1) * 50) >= totalAuctions);
end

-----------------------------------------

function AtrQuery:BuildItemIDstr(name, count, minBid, buyoutPrice, bidAmount)

	if (name) then
		return name.."_"..count.."_"..minBid.."_"..buyoutPrice.."_"..bidAmount;
	end
		
	return "";
end
