-- nearby check yes/no? slowdown may be an isue if someone leaves the mod enabled and always replace node
local GatherMateData = LibStub("AceAddon-3.0"):NewAddon("GatherMate2_Data")
local GatherMate = LibStub("AceAddon-3.0"):GetAddon("GatherMate2")
GatherMateData.generatedVersion = "183"
local bcZones = {
	[464] = true,
	[476] = true,
	[471] = true,
	[462] = true,
	[463] = true,
	[499] = true,
	[480] = true,
	[475] = true,
	[465] = true,
	[477] = true,
	[479] = true,
	[473] = true,
	[481] = true,
	[478] = true,
	[467] = true,
}
-- FIX to new Zone numbers
local wrathZones = {
	[486] = true,
	[510] = true,
	[504] = true,
	[488] = true,
	[490] = true,
	[491] = true,
	[541] = true,
	[492] = true,
	[493] = true,
	[495] = true,
	[501] = true,
	[496] = true,
}

local cataZones = {
	[606] = true,
	[684] = true,
	[685] = true,
	[615] = true,
	[708] = true,
	[709] = true,
	[700] = true,
	[613] = true,
	[614] = true,
	[640] = true,
	[605] = true,
	[544] = true,
	[737] = true,
}

function GatherMateData:PerformMerge(dbs,style, zoneFilter)
	local filter = nil
	if zoneFilter and type(zoneFilter) == "string" then
		if zoneFilter == "TBC" then
			filter = bcZones
		elseif zoneFilter == "WRATH" then
			filter = wrathZones
		elseif zoneFilter == "CATACLYSM" then
			filter = cataZones
		end
	end
	if dbs["Mines"]    then self:MergeMines(style ~= "Merge",filter) end
	if dbs["Herbs"]    then self:MergeHerbs(style ~= "Merge",filter) end
	if dbs["Gases"]    then self:MergeGases(style ~= "Merge",filter) end
	if dbs["Fish"]     then self:MergeFish(style ~= "Merge",filter) end
	if dbs["Treasure"] then self:MergeTreasure(style ~= "Merge",filter) end
	if dbs["Archaeology"] then self:MergeArchaelogy(style ~= "Merge",filter) end
	self:CleanupImportData()
	GatherMate:SendMessage("GatherMateData2Import")
	--GatherMate:CleanupDB()
end
-- Insert mining data
function GatherMateData:MergeMines(clear,zoneFilter)
	if clear then GatherMate:ClearDB("Mining") end
	for zoneID, node_table in pairs(GatherMateData2MineDB) do
		if zoneFilter and zoneFilter[zoneID] or not zoneFilter then
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode(zoneID,coord,"Mining", nodeID)
			end
		else
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode(zoneID,coord,"Mining", nodeID)
			end			
		end
	end
end

-- herbs
function GatherMateData:MergeHerbs(clear,zoneFilter)
	if clear then GatherMate:ClearDB("Herb Gathering") end
	for zoneID, node_table in pairs(GatherMateData2HerbDB) do
		if zoneFilter and zoneFilter[zoneID] or not zoneFilter then
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode(zoneID,coord,"Herb Gathering", nodeID)
			end
		else
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode(zoneID,coord,"Herb Gathering", nodeID)
			end
		end
	end
end

-- gases
function GatherMateData:MergeGases(clear,zoneFilter)
	if clear then GatherMate:ClearDB("Extract Gas") end
	for zoneID, node_table in pairs(GatherMateData2GasDB) do
		if zoneFilter and zoneFilter[zoneID] or not zoneFilter then
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode(zoneID,coord,"Extract Gas", nodeID)
			end
		else
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode(zoneID,coord,"Extract Gas", nodeID)
			end			
		end
	end
end

-- fish
function GatherMateData:MergeFish(clear,zoneFilter)
	if clear then GatherMate:ClearDB("Fishing") end
	for zoneID, node_table in pairs(GatherMateData2FishDB) do
		if zoneFilter and zoneFilter[zoneID] or not zoneFilter then
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode(zoneID,coord,"Fishing", nodeID)
			end
		else
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode(zoneID,coord,"Fishing", nodeID)
			end			
		end
	end
end
function GatherMateData:MergeTreasure(clear,zoneFilter)
	if clear then GatherMate:ClearDB("Treasure") end
	for zoneID, node_table in pairs(GatherMateData2TreasureDB) do
		if zoneFilter and zoneFilter[zoneID] or not zoneFilter then
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode(zoneID,coord,"Treasure", nodeID)
			end
		else
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode(zoneID,coord,"Treasure", nodeID)
			end			
		end
	end
end
function GatherMateData:MergeArchaelogy(clear,zoneFilter)
	if clear then GatherMate:ClearDB("Archaeology") end
	for zoneID, node_table in pairs(GatherMateData2ArchaeologyDB) do
		if zoneFilter and zoneFilter[zoneID] or not zoneFilter then
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode(zoneID,coord,"Archaeology", nodeID)
			end
		else
			for coord, nodeID in pairs(node_table) do
				GatherMate:InjectNode(zoneID,coord,"Archaeology", nodeID)
			end			
		end
	end
end


function GatherMateData:CleanupImportData()
	GatherMateData2HerbDB = nil
	GatherMateData2MineDB = nil
	GatherMateData2GasDB = nil
	GatherMateData2FishDB = nil
	GatherMateData2TreasureDB = nil
	GatherMateData2ArchaeologyDB = nil
end
