local COLOUR_DEATHKNIGHT = "|cffc41f3b"
local COLOUR_DRUID = "|cffff7d0a"
local COLOUR_HUNTER = "|cffabd473"
local COLOUR_MAGE = "|cff69ccf0"
local COLOUR_PALADIN = "|cfff58cba"
local COLOUR_PRIEST = "|cffffffff"
local COLOUR_ROGUE = "|cfffff569"
local COLOUR_SHAMAN = "|cff0070de"
local COLOUR_WARLOCK = "|cff9482c9"
local COLOUR_WARRIOR = "|cffc79c6e"

local qcARaceFlags = 3149
local qcHRaceFlags = 946
local qcAHRaceFlags = 4095
local qcAHClassFlags = 1023

local function qcRound(num, idp)

	return tonumber(string.format("%." .. (idp or 0) .. "f", num))

end

--[[ MERGE CODE START ]]--

function qcWipeWorkingDB()

	wipe(qcWorkingDB)
	wipe(qcWorkingLog)

end
function qcCleanOldDatabase()

	local qcCleanedCount = 0
	wipe(qcWorkingDB)
	qcWorkingDB = qcCopyTable(qcQuestDBv2)
	for qcMapIndex, qcMapEntry in pairs(qcMapIcon) do
		for qcInitiatorIndex, qcInitiatorEntry in pairs(qcMapIcon[qcMapIndex]) do
			for qcInitiatorQuestIndex, qcInitiatorQuestEntry in pairs(qcMapIcon[qcMapIndex][qcInitiatorIndex][7]) do
				if not (qcWorkingDB[qcInitiatorQuestEntry] == nil) then
					qcCleanedCount = (qcCleanedCount + 1)
					qcWorkingDB[qcInitiatorQuestEntry] = nil
				end
			end
		end
	end

	print(string.format("%d quests cleaned from the old qcQuestDBv2 database.", qcCleanedCount))

end
function qcCheckForUnusedQuestCategories()

	for qcCategoryIndex, qcCategoryEntry in ipairs(qcQuestCategories) do
		local qcFound = false
		for qcQuestIndex, qcQuestEntry in pairs(qcQuestDatabase) do
			if (qcQuestEntry[4] == qcCategoryEntry[2]) then
				qcFound = true
				break
			end
		end
		if not (qcFound) then
			print("No quests found for quest category: " .. qcCategoryEntry[2])
		end
	end

end
function qcCheckMenuForMissingQuestCategories()

	for qcCategoryIndex, qcCategoryEntry in ipairs(qcQuestCategories) do
		local qcFound = false
		for qcMenuIndex, qcMenuEntry in pairs(qcCategoryMenu) do
			if (qcMenuEntry[3]) then
				for qcSubmenuIndex, qcSubmenuEntry in ipairs(qcMenuEntry[3]) do
					if (qcSubmenuEntry[1] == qcCategoryEntry[1]) then
						qcFound = true
						break
					end
				end
			end
		end
		if not (qcFound) then
			print("No menu item was found for: " .. qcCategoryEntry[2] .. " [" .. qcCategoryEntry[1] .. "]")
		end
	end

end
local function qcCorrectSeasonal()

	local tableinsert = table.insert
	local stringformat = string.format

	tableinsert(qcWorkingLog,"STARTED – qcCorrectSeasonal()...")

	for qcIndex, qcEntry in pairs(qcWorkingDB) do
		if (qcEntry[4] == "Brewfest") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Brewfest category ID and seasonal flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 4001
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 7 end
			qcWorkingDB[qcIndex][11] = 1
		elseif (qcEntry[4] == "Children's Week") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Children's Week category ID and seasonal flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 4002
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 7 end
			qcWorkingDB[qcIndex][11] = 2
		elseif (qcEntry[4] == "Day of the Dead") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Day of the Dead category ID and seasonal flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 4004
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 7 end
			qcWorkingDB[qcIndex][11] = 4
		elseif (qcEntry[4] == "Hallow's End") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Hallow's End category ID and seasonal flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 4005
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 7 end
			qcWorkingDB[qcIndex][11] = 16
		elseif (qcEntry[4] == "Harvest Festival") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Harvest Festival category ID and seasonal flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 4006
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 7 end
			qcWorkingDB[qcIndex][11] = 32
		elseif (qcEntry[4] == "Love is in the Air") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Love is in the Air category ID and seasonal flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 4007
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 7 end
			qcWorkingDB[qcIndex][11] = 64
		elseif (qcEntry[4] == "Lunar Festival") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Lunar Festival category ID and seasonal flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 4008
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 7 end
			qcWorkingDB[qcIndex][11] = 128
		elseif (qcEntry[4] == "Midsummer Fire Festival") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Midsummer Fire Festival category ID and seasonal flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 4009
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 7 end
			qcWorkingDB[qcIndex][11] = 256
		elseif (qcEntry[4] == "Noblegarden") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Noblegarden category ID and seasonal flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 4011
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 7 end
			qcWorkingDB[qcIndex][11] = 512
		elseif (qcEntry[4] == "Pilgrim's Bounty") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Pilgrim's Bounty category ID and seasonal flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 4012
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 7 end
			qcWorkingDB[qcIndex][11] = 1024
		elseif (qcEntry[4] == "Winter Veil") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Winter Veil category ID and seasonal flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 4015
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 7 end
			qcWorkingDB[qcIndex][11] = 8
		elseif (qcEntry[4] == "Seasonal") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Seasonal category ID and seasonal flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 4013
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 7 end
			--qcWorkingDB[qcIndex][11] = 2048
		end
	end

end
local function qcCorrectProfessions()

	local tableinsert = table.insert
	local stringformat = string.format

	tableinsert(qcWorkingLog,"STARTED – qcCorrectProfessions()...")

	for qcIndex, qcEntry in pairs(qcWorkingDB) do
		if (qcEntry[4] == "Alchemy") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Alchemy category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3001
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 1
		elseif (qcEntry[4] == "Blacksmithing") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Blacksmithing category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3003
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 2
		elseif (qcEntry[4] == "Enchanting") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Enchanting category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3005
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 4
		elseif (qcEntry[4] == "Engineering") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Engineering category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3006
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 8
		elseif (qcEntry[4] == "Inscription") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Inscription category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3010
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 16
		elseif (qcEntry[4] == "Jewelcrafting") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Jewelcrafting category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3011
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 32
		elseif (qcEntry[4] == "Leatherworking") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Leatherworking category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3012
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 64
		elseif (qcEntry[4] == "Tailoring") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Tailoring category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3015
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 128
		elseif (qcEntry[4] == "Herbalism") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Herbalism category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3009
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 256
		elseif (qcEntry[4] == "Mining") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Mining category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3013
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 512
		elseif (qcEntry[4] == "Skinning") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Skinning category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3014
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 1024
		elseif (qcEntry[4] == "Archaeology") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Archaeology category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3002
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 2048
		elseif (qcEntry[4] == "First Aid") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] First Aid category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3007
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 4096
		elseif (qcEntry[4] == "Cooking") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Cooking category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3004
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 8192
		elseif (qcEntry[4] == "Fishing") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Fishing category ID and profession flag corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 3008
			if (qcWorkingDB[qcIndex][6] == 1) then qcWorkingDB[qcIndex][6] = 6 end
			qcWorkingDB[qcIndex][10] = 16384
		end
	end

end
local function qcCorrectClasses()

	local tableinsert = table.insert
	local stringupper = string.upper
	local stringformat = string.format

	tableinsert(qcWorkingLog,"STARTED – qcCorrectClasses()...")

	for qcIndex, qcEntry in pairs(qcWorkingDB) do
		if (stringupper(qcEntry[4]) == "WARRIOR") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Warrior category ID corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 2011
		elseif (stringupper(qcEntry[4]) == "PALADIN") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Paladin category ID corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 2006
		elseif (stringupper(qcEntry[4]) == "HUNTER") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Hunter category ID corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 2003
		elseif (stringupper(qcEntry[4]) == "ROGUE") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Rogue category ID corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 2008
		elseif (stringupper(qcEntry[4]) == "PRIEST") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Priest category ID corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 2007
		elseif (stringupper(qcEntry[4]) == "DEATH KNIGHT") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Deathknight category ID corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 2001
		elseif (stringupper(qcEntry[4]) == "SHAMAN") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Shaman category ID corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 2009
		elseif (stringupper(qcEntry[4]) == "MAGE") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Mage category ID corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 2004
		elseif (stringupper(qcEntry[4]) == "WARLOCK") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Warlock category ID corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 2010
		elseif (stringupper(qcEntry[4]) == "DRUID") then
			tableinsert(qcWorkingLog,stringformat("\t[%d] Druid category ID corrected.", qcIndex))
			qcWorkingDB[qcIndex][5] = 2002
		end
	end

end
local function qcCorrectInvalidCategoryIDs()

	local tableinsert = table.insert
	local stringformat = string.format

	tableinsert(qcWorkingLog,"STARTED – qcCorrectInvalidCategoryIDs()...")

	for qcIndex, qcEntry in pairs(qcWorkingDB) do
		local qcFound = false
		for qcCategoryIndex, qcCategoryEntry in ipairs(qcQuestCategories) do
			if (qcCategoryEntry[2] == qcEntry[4]) then
				tableinsert(qcWorkingLog, stringformat("\t[%d] Category ID changed from %d to %d (%s)", qcIndex, qcEntry[5], qcCategoryEntry[1],qcCategoryEntry[2]))
				qcEntry[5] = qcCategoryEntry[1]
				qcFound = true
				break
			end
		end
		if not (qcFound) then
			qcEntry[5] = 99999
		end
	end

	tableinsert(qcWorkingLog,"SUMMARY FOR – qcCorrectInvalidCategoryIDs()... The following categories do not have an ID")
	for qcIndex, qcEntry in pairs(qcWorkingDB) do
		if (qcEntry[5] == 99999) then
			tableinsert(qcWorkingLog, stringformat("\t[%d] %s",qcIndex,qcEntry[4]))
		end
	end

end
local function qcCleanQuestDatabaseEmptyTables()

	for qcIndex, qcEntry in pairs(qcWorkingDB) do
		if (qcWorkingDB[qcIndex][12] == nil) then qcWorkingDB[qcIndex][12] = {} end
		if (qcWorkingDB[qcIndex][13] == nil) then qcWorkingDB[qcIndex][13] = {} end

		local qcInitiatorCount = 0
		for qcInitiatorIndex, qcInitiatorEntry in pairs(qcWorkingDB[qcIndex][13]) do
			qcInitiatorCount = (qcInitiatorCount + 1)
		end
		if (qcInitiatorCount == 0) then qcWorkingDB[qcIndex][13] = nil end
		if (qcWorkingDB[qcIndex][13] == nil) then
			local qcRepCount = 0
			for qcRepIndex, qcRepEntry in pairs(qcWorkingDB[qcIndex][12]) do
				qcRepCount = (qcRepCount + 1)
			end
			if (qcRepCount == 0) then qcWorkingDB[qcIndex][12] = nil end
		end
	end

end
local function qcUpdateInitiatorData()

	for qcIndex, qcEntry in pairs(qcWorkingDB) do
		if (qcWorkingDB[qcIndex][12] == nil) then
			qcWorkingDB[qcIndex][12] = {}
		end
		if (qcWorkingDB[qcIndex][13] == nil) then
			qcWorkingDB[qcIndex][13] = {}
		else
			wipe(qcWorkingDB[qcIndex][13])
		end
	end

	for qcMapIndex, qcMapEntry in pairs(qcMapIcon) do
		for qcInitiatorIndex, qcInitiatorEntry in pairs(qcMapIcon[qcMapIndex]) do
			for qcInitiatorQuestIndex, qcInitiatorQuestEntry in pairs(qcMapIcon[qcMapIndex][qcInitiatorIndex][7]) do
				if (qcWorkingDB[qcInitiatorQuestEntry] == nil) then
					print("Quest not found:", qcInitiatorQuestEntry)
				else
					--local qcFloorName = _G["DUNGEON_FLOOR_" .. strupper(GetMapInfo() or "") .. (qcMapIcon[qcMapIndex][qcInitiatorIndex][1])] or 0
					--if (qcFloorName ~= 0) then print(qcFloorName) end
					table.insert(qcWorkingDB[qcInitiatorQuestEntry][13],{qcMapIcon[qcMapIndex][qcInitiatorIndex][3],qcMapIcon[qcMapIndex][qcInitiatorIndex][4],qcMapIndex,qcMapIcon[qcMapIndex][qcInitiatorIndex][1],qcRound(qcMapIcon[qcMapIndex][qcInitiatorIndex][5],1),qcRound(qcMapIcon[qcMapIndex][qcInitiatorIndex][6],1)})
				end
			end
		end
	end

end
local function qcMergeSavedVariables()

	local tableinsert = table.insert
	local stringformat = string.format
	local stringsub = string.sub
	local bitband = bit.band
	local mathmax = math.max
	local qcDiscard = false

	qcWorkingDB = qcCopyTable(qcQuestDatabase)

	tableinsert(qcWorkingLog,"STARTED – qcMergeSavedVariables()...")

	for qcIndex, qcEntry in pairs(qcSVData) do
		local qcDiscard = false
		if (qcWorkingDB[qcIndex] == nil) then
			tableinsert(qcWorkingLog, stringformat("\t[%d] New quest detected: %s",qcIndex,qcEntry[2]))
			tableinsert(qcWorkingDB, qcIndex, qcEntry)
			if (qcWorkingDB[qcIndex][7] == 1) then
				tableinsert(qcWorkingLog, "\t\tAlliance only - Searching for a Horde submission within this batch...")
				local qcFound = false
				for qcSearchIndex, qcResult in pairs(qcSVData) do
					if (qcSearchIndex == qcIndex) then
						if (qcResult[7] == 2) or (qcResult[7] == 3) then
							qcFound = True
							break
						end
					end
				end
				if (qcFound) then
					tableinsert(qcWorkingLog, stringformat("\t\t - Seperate Alliance and Horde versions detected in qcSVData - Assuming Cross Faction: Race %d, Class %d",qcAHRaceFlags,qcAHClassFlags))
					qcWorkingDB[qcIndex][7] = 3
					qcWorkingDB[qcIndex][8] = qcAHRaceFlags
					qcWorkingDB[qcIndex][9] = qcAHClassFlags
				else
					tableinsert(qcWorkingLog, stringformat("\t\t - Confirmed Alliance Only: Race %d, Class %d",qcARaceFlags,qcAHClassFlags))
					qcWorkingDB[qcIndex][8] = qcARaceFlags
					qcWorkingDB[qcIndex][9] = qcAHClassFlags
				end
			elseif (qcWorkingDB[qcIndex][7] == 2) then
				tableinsert(qcWorkingLog, "\t\tHorde only - Searching for an Alliance submission within this batch...")
				local qcFound = false
				for qcSearchIndex, qcResult in pairs(qcSVData) do
					if (qcSearchIndex == qcIndex) then
						if (qcResult[7] == 1) or (qcResult[7] == 3) then
							qcFound = True
							break
						end
					end
				end
				if (qcFound) then
					tableinsert(qcWorkingLog, stringformat("\t\t - Seperate Horde and Alliance versions detected in qcSVData - Assuming Cross Faction: Race %d, Class %d",qcAHRaceFlags,qcAHClassFlags))
					qcWorkingDB[qcIndex][7] = 3
					qcWorkingDB[qcIndex][8] = qcAHRaceFlags
					qcWorkingDB[qcIndex][9] = qcAHClassFlags
				else
					tableinsert(qcWorkingLog, stringformat("\t\t - Confirmed Horde Only: Race %d, Class %d",qcHRaceFlags,qcAHClassFlags))
					qcWorkingDB[qcIndex][8] = qcHRaceFlags
					qcWorkingDB[qcIndex][9] = qcAHClassFlags
				end
			elseif (qcWorkingDB[qcIndex][7] == 3) then
				tableinsert(qcWorkingLog, stringformat("\t\tCross faction: Race %d, Class %d",qcAHRaceFlags,qcAHClassFlags))
				qcWorkingDB[qcIndex][7] = 3
				qcWorkingDB[qcIndex][8] = qcAHRaceFlags
				qcWorkingDB[qcIndex][9] = qcAHClassFlags
			else
				tableinsert(qcWorkingLog, stringformat("\t\tFACTION FLAG NOT KNOWN: &d",qcWorkingDB[qcIndex][7]))
			end
			tableinsert(qcWorkingLog, stringformat("\t\t - Category: %d, %s", qcWorkingDB[qcIndex][5], qcWorkingDB[qcIndex][4]))
		else
			--[[ Check for things which would suggest bad data, and flag for discard is required ]]--
			if (qcEntry[2] == nil) or (qcEntry[2] == "nil") then qcDiscard = true end
			if (qcEntry[4] == nil) or (qcEntry[4] == "<Category Unknown>") then qcDiscard = true end
			if not (qcDiscard) then
				-- ID
				qcWorkingDB[qcIndex][1] = qcIndex
				-- Name
				if not (qcWorkingDB[qcIndex][2] == qcEntry[2]) then
					if not (stringsub(qcEntry[2],1,1) == "[") then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Name changed from %s to %s",qcIndex,qcWorkingDB[qcIndex][2],qcEntry[2]))
						qcWorkingDB[qcIndex][2] = qcEntry[2]
					else
						tableinsert(qcWorkingLog, stringformat("\t[%d] Name change rejected due to leading bracket: %s",qcIndex,qcEntry[2]))
					end
				end
				-- Level
				if not (qcWorkingDB[qcIndex][3] == qcEntry[3]) then
					if not (qcWorkingDB[qcIndex][3] == -1) then
						if (math.abs(qcWorkingDB[qcIndex][3] - qcEntry[3]) > 5) then
							tableinsert(qcWorkingLog, stringformat("\t[%d] Level difference over threshold, assuming it needs locked. [%s]", qcIndex, qcWorkingDB[qcIndex][4]))
							qcWorkingDB[qcIndex][3] = -1
						else
							tableinsert(qcWorkingLog, stringformat("\t[%d] Level changed from %d to %d", qcIndex, qcWorkingDB[qcIndex][3], qcEntry[3]))
							qcWorkingDB[qcIndex][3] = qcEntry[3]
						end
					end
				end
				-- Category name
				if not (qcWorkingDB[qcIndex][4] == qcEntry[4]) then
					tableinsert(qcWorkingLog, stringformat("\t[%d] Category name changed from %s to %s", qcIndex, qcWorkingDB[qcIndex][4], qcEntry[4]))
					qcWorkingDB[qcIndex][4] = qcEntry[4]
				end
				-- Category ID
				if not (qcWorkingDB[qcIndex][5] == qcEntry[5]) then
					tableinsert(qcWorkingLog, stringformat("\t[%d] Category ID changed from %d to %d", qcIndex, qcWorkingDB[qcIndex][5], qcEntry[5]))
					qcWorkingDB[qcIndex][5] = qcEntry[5]
				end
				-- Quest Type?
				-- Faction
				do
					local qcEntryFaction = qcEntry[7]
					local qcExistingFaction = qcWorkingDB[qcIndex][7]
					local qcEntryAlliance, qcEntryHorde = 0, 0
					local qcExistingAlliance, qcExistingHorde = 0, 0
					local qcNewAlliance, qcNewHorde = 0, 0

					if not (bitband(qcEntryFaction, qcFactionBits["ALLIANCE"]) == 0) then qcEntryAlliance = qcFactionBits["ALLIANCE"] end
					if not (bitband(qcEntryFaction, qcFactionBits["HORDE"]) == 0) then qcEntryHorde = qcFactionBits["HORDE"] end
					if not (bitband(qcExistingFaction, qcFactionBits["ALLIANCE"]) == 0) then qcExistingAlliance = qcFactionBits["ALLIANCE"] end
					if not (bitband(qcExistingFaction, qcFactionBits["HORDE"]) == 0) then qcExistingHorde = qcFactionBits["HORDE"] end

					if (qcEntryAlliance > qcExistingAlliance) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Alliance flag added. It is likely Alliance race flags will also need updated.", qcIndex))
					end
					qcNewAlliance = mathmax(qcEntryAlliance, qcExistingAlliance)
					if (qcEntryHorde > qcExistingHorde) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Horde flag added. It is likely Horde race flags will also need updated.", qcIndex))
					end
					qcNewHorde = mathmax(qcEntryHorde, qcExistingHorde)
					qcWorkingDB[qcIndex][7] = (qcNewAlliance + qcNewHorde)
				end
				-- Race
				do
					local qcEntryRace = qcEntry[8]
					local qcExistingRace = qcWorkingDB[qcIndex][8]
					local qcEntryHuman, qcEntryOrc, qcEntryDwarf, qcEntryNightelf, qcEntryScourge, qcEntryTauren, qcEntryGnome, qcEntryTroll, qcEntryGoblin, qcEntryBloodelf, qcEntryDraenei, qcEntryWorgen = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
					local qcExistingHuman, qcExistingOrc, qcExistingDwarf, qcExistingNightelf, qcExistingScourge, qcExistingTauren, qcExistingGnome, qcExistingTroll, qcExistingGoblin, qcExistingBloodelf, qcExistingDraenei, qcExistingWorgen = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
					local qcNewHuman, qcNewOrc, qcNewDwarf, qcNewNightelf, qcNewScourge, qcNewTauren, qcNewGnome, qcNewTroll, qcNewGoblin, qcNewBloodelf, qcNewDraenei, qcNewWorgen = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

					if not (bit.band(qcEntryRace, qcRaceBits["HUMAN"]) == 0) then qcEntryHuman = qcRaceBits["HUMAN"] end
					if not (bit.band(qcEntryRace, qcRaceBits["ORC"]) == 0) then qcEntryOrc = qcRaceBits["ORC"] end
					if not (bit.band(qcEntryRace, qcRaceBits["DWARF"]) == 0) then qcEntryDwarf = qcRaceBits["DWARF"] end
					if not (bit.band(qcEntryRace, qcRaceBits["NIGHTELF"]) == 0) then qcEntryNightelf = qcRaceBits["NIGHTELF"] end
					if not (bit.band(qcEntryRace, qcRaceBits["SCOURGE"]) == 0) then qcEntryScourge = qcRaceBits["SCOURGE"] end
					if not (bit.band(qcEntryRace, qcRaceBits["TAUREN"]) == 0) then qcEntryTauren = qcRaceBits["TAUREN"] end
					if not (bit.band(qcEntryRace, qcRaceBits["GNOME"]) == 0) then qcEntryGnome = qcRaceBits["GNOME"] end
					if not (bit.band(qcEntryRace, qcRaceBits["TROLL"]) == 0) then qcEntryTroll = qcRaceBits["TROLL"] end
					if not (bit.band(qcEntryRace, qcRaceBits["GOBLIN"]) == 0) then qcEntryGoblin = qcRaceBits["GOBLIN"] end
					if not (bit.band(qcEntryRace, qcRaceBits["BLOODELF"]) == 0) then qcEntryBloodelf = qcRaceBits["BLOODELF"] end
					if not (bit.band(qcEntryRace, qcRaceBits["DRAENEI"]) == 0) then qcEntryDraenei = qcRaceBits["DRAENEI"] end
					if not (bit.band(qcEntryRace, qcRaceBits["WORGEN"]) == 0) then qcEntryWorgen = qcRaceBits["WORGEN"] end

					if not (bit.band(qcExistingRace, qcRaceBits["HUMAN"]) == 0) then qcExistingHuman = qcRaceBits["HUMAN"] end
					if not (bit.band(qcExistingRace, qcRaceBits["ORC"]) == 0) then qcExistingOrc = qcRaceBits["ORC"] end
					if not (bit.band(qcExistingRace, qcRaceBits["DWARF"]) == 0) then qcExistingDwarf = qcRaceBits["DWARF"] end
					if not (bit.band(qcExistingRace, qcRaceBits["NIGHTELF"]) == 0) then qcExistingNightelf = qcRaceBits["NIGHTELF"] end
					if not (bit.band(qcExistingRace, qcRaceBits["SCOURGE"]) == 0) then qcExistingScourge = qcRaceBits["SCOURGE"] end
					if not (bit.band(qcExistingRace, qcRaceBits["TAUREN"]) == 0) then qcExistingTauren = qcRaceBits["TAUREN"] end
					if not (bit.band(qcExistingRace, qcRaceBits["GNOME"]) == 0) then qcExistingGnome = qcRaceBits["GNOME"] end
					if not (bit.band(qcExistingRace, qcRaceBits["TROLL"]) == 0) then qcExistingTroll = qcRaceBits["TROLL"] end
					if not (bit.band(qcExistingRace, qcRaceBits["GOBLIN"]) == 0) then qcExistingGoblin = qcRaceBits["GOBLIN"] end
					if not (bit.band(qcExistingRace, qcRaceBits["BLOODELF"]) == 0) then qcExistingBloodelf = qcRaceBits["BLOODELF"] end
					if not (bit.band(qcExistingRace, qcRaceBits["DRAENEI"]) == 0) then qcExistingDraenei = qcRaceBits["DRAENEI"] end
					if not (bit.band(qcExistingRace, qcRaceBits["WORGEN"]) == 0) then qcExistingWorgen = qcRaceBits["WORGEN"] end

					if (qcEntryHuman > qcExistingHuman) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Human flag added.", qcIndex))
					end
					qcNewHuman = mathmax(qcEntryHuman, qcExistingHuman)
					if (qcEntryOrc > qcExistingOrc) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Orc flag added.", qcIndex))
					end
					qcNewOrc = mathmax(qcEntryOrc, qcExistingOrc)
					if (qcEntryDwarf > qcExistingDwarf) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Dwarf flag added.", qcIndex))
					end
					qcNewDwarf = mathmax(qcEntryDwarf, qcExistingDwarf)
					if (qcEntryNightelf > qcExistingNightelf) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Nightelf flag added.", qcIndex))
					end
					qcNewNightelf = mathmax(qcEntryNightelf, qcExistingNightelf)
					if (qcEntryScourge > qcExistingScourge) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Scourge flag added.", qcIndex))
					end
					qcNewScourge = mathmax(qcEntryScourge, qcExistingScourge)
					if (qcEntryTauren > qcExistingTauren) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Tauren flag added.", qcIndex))
					end
					qcNewTauren = mathmax(qcEntryTauren, qcExistingTauren)
					if (qcEntryGnome > qcExistingGnome) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Gnome flag added.", qcIndex))
					end
					qcNewGnome = mathmax(qcEntryGnome, qcExistingGnome)
					if (qcEntryTroll > qcExistingTroll) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Troll flag added.", qcIndex))
					end
					qcNewTroll = mathmax(qcEntryTroll, qcExistingTroll)
					if (qcEntryGoblin > qcExistingGoblin) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Goblin flag added.", qcIndex))
					end
					qcNewGoblin = mathmax(qcEntryGoblin, qcExistingGoblin)
					if (qcEntryBloodelf > qcExistingBloodelf) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Bloodelf flag added.", qcIndex))
					end
					qcNewBloodelf = mathmax(qcEntryBloodelf, qcExistingBloodelf)
					if (qcEntryDraenei > qcExistingDraenei) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Draenei flag added.", qcIndex))
					end
					qcNewDraenei = mathmax(qcEntryDraenei, qcExistingDraenei)
					if (qcEntryWorgen > qcExistingWorgen) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Worgen flag added.", qcIndex))
					end
					qcNewWorgen = mathmax(qcEntryWorgen, qcExistingWorgen)
					qcWorkingDB[qcIndex][8] = (qcNewHuman + qcNewOrc + qcNewDwarf + qcNewNightelf + qcNewScourge + qcNewTauren + qcNewGnome + qcNewTroll + qcNewGoblin + qcNewBloodelf + qcNewDraenei + qcNewWorgen)
				end
				-- Class
				do
					local qcEntryClass = qcEntry[9]
					local qcExistingClass = qcWorkingDB[qcIndex][9]
					local qcEntryWarrior, qcEntryPaladin, qcEntryHunter, qcEntryRogue, qcEntryPriest, qcEntryDeathknight, qcEntryShaman, qcEntryMage, qcEntryWarlock, qcEntryDruid = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
					local qcExistingWarrior, qcExistingPaladin, qcExistingHunter, qcExistingRogue, qcExistingPriest, qcExistingDeathknight, qcExistingShaman, qcExistingMage, qcExistingWarlock, qcExistingDruid = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
					local qcNewWarrior, qcNewPaladin, qcNewHunter, qcNewRogue, qcNewPriest, qcNewDeathknight, qcNewShaman, qcNewMage, qcNewWarlock, qcNewDruid = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

					if not (bit.band(qcEntryClass, qcClassBits["WARRIOR"]) == 0) then qcEntryWarrior = qcClassBits["WARRIOR"] end
					if not (bit.band(qcEntryClass, qcClassBits["PALADIN"]) == 0) then qcEntryPaladin = qcClassBits["PALADIN"] end
					if not (bit.band(qcEntryClass, qcClassBits["HUNTER"]) == 0) then qcEntryHunter = qcClassBits["HUNTER"] end
					if not (bit.band(qcEntryClass, qcClassBits["ROGUE"]) == 0) then qcEntryRogue = qcClassBits["ROGUE"] end
					if not (bit.band(qcEntryClass, qcClassBits["PRIEST"]) == 0) then qcEntryPriest = qcClassBits["PRIEST"] end
					if not (bit.band(qcEntryClass, qcClassBits["DEATHKNIGHT"]) == 0) then qcEntryDeathknight = qcClassBits["DEATHKNIGHT"] end
					if not (bit.band(qcEntryClass, qcClassBits["SHAMAN"]) == 0) then qcEntryShaman = qcClassBits["SHAMAN"] end
					if not (bit.band(qcEntryClass, qcClassBits["MAGE"]) == 0) then qcEntryMage = qcClassBits["MAGE"] end
					if not (bit.band(qcEntryClass, qcClassBits["WARLOCK"]) == 0) then qcEntryWarlock = qcClassBits["WARLOCK"] end
					if not (bit.band(qcEntryClass, qcClassBits["DRUID"]) == 0) then qcEntryDruid = qcClassBits["DRUID"] end

					if not (bit.band(qcExistingClass, qcClassBits["WARRIOR"]) == 0) then qcExistingWarrior = qcClassBits["WARRIOR"] end
					if not (bit.band(qcExistingClass, qcClassBits["PALADIN"]) == 0) then qcExistingPaladin = qcClassBits["PALADIN"] end
					if not (bit.band(qcExistingClass, qcClassBits["HUNTER"]) == 0) then qcExistingHunter = qcClassBits["HUNTER"] end
					if not (bit.band(qcExistingClass, qcClassBits["ROGUE"]) == 0) then qcExistingRogue = qcClassBits["ROGUE"] end
					if not (bit.band(qcExistingClass, qcClassBits["PRIEST"]) == 0) then qcExistingPriest = qcClassBits["PRIEST"] end
					if not (bit.band(qcExistingClass, qcClassBits["DEATHKNIGHT"]) == 0) then qcExistingDeathknight = qcClassBits["DEATHKNIGHT"] end
					if not (bit.band(qcExistingClass, qcClassBits["SHAMAN"]) == 0) then qcExistingShaman = qcClassBits["SHAMAN"] end
					if not (bit.band(qcExistingClass, qcClassBits["MAGE"]) == 0) then qcExistingMage = qcClassBits["MAGE"] end
					if not (bit.band(qcExistingClass, qcClassBits["WARLOCK"]) == 0) then qcExistingWarlock = qcClassBits["WARLOCK"] end
					if not (bit.band(qcExistingClass, qcClassBits["DRUID"]) == 0) then qcExistingDruid = qcClassBits["DRUID"] end

					if (qcEntryWarrior > qcExistingWarrior) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Warrior flag added.", qcIndex))
					end
					qcNewWarrior = mathmax(qcEntryWarrior, qcExistingWarrior)
					if (qcEntryPaladin > qcExistingPaladin) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Paladin flag added.", qcIndex))
					end
					qcNewPaladin = mathmax(qcEntryPaladin, qcExistingPaladin)
					if (qcEntryHunter > qcExistingHunter) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Hunter flag added.", qcIndex))
					end
					qcNewHunter = mathmax(qcEntryHunter, qcExistingHunter)
					if (qcEntryRogue > qcExistingRogue) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Rogue flag added.", qcIndex))
					end
					qcNewRogue = mathmax(qcEntryRogue, qcExistingRogue)
					if (qcEntryPriest > qcExistingPriest) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Priest flag added.", qcIndex))
					end
					qcNewPriest = mathmax(qcEntryPriest, qcExistingPriest)
					if (qcEntryDeathknight > qcExistingDeathknight) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Deathknight flag added.", qcIndex))
					end
					qcNewDeathknight = mathmax(qcEntryDeathknight, qcExistingDeathknight)
					if (qcEntryShaman > qcExistingShaman) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Shaman flag added.", qcIndex))
					end
					qcNewShaman = mathmax(qcEntryShaman, qcExistingShaman)
					if (qcEntryMage > qcExistingMage) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Mage flag added.", qcIndex))
					end
					qcNewMage = mathmax(qcEntryMage, qcExistingMage)
					if (qcEntryWarlock > qcExistingWarlock) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Warlock flag added.", qcIndex))
					end
					qcNewWarlock = mathmax(qcEntryWarlock, qcExistingWarlock)
					if (qcEntryDruid > qcExistingDruid) then
						tableinsert(qcWorkingLog, stringformat("\t[%d] Druid flag added.", qcIndex))
					end
					qcNewDruid = mathmax(qcEntryDruid, qcExistingDruid)
					qcWorkingDB[qcIndex][9] = (qcNewWarrior + qcNewPaladin + qcNewHunter + qcNewRogue + qcNewPriest + qcNewDeathknight + qcNewShaman + qcNewMage + qcNewWarlock + qcNewDruid)
				end
				-- Rep
				if not (qcEntry[12] == nil) then
					if (qcWorkingDB[qcIndex][12] == nil) then qcWorkingDB[qcIndex][12] = {} end
					for qcReputationIndex, qcReputationEntry in pairs(qcEntry[12]) do
						if (qcWorkingDB[qcIndex][12][qcReputationIndex] == nil) then
							--tableinsert(qcWorkingLog, stringformat("\t[%d] New reputation entry [%d] = %d", qcIndex, qcReputationIndex, qcReputationEntry))
							qcWorkingDB[qcIndex][12][qcReputationIndex] = qcReputationEntry
						else
							if not (qcWorkingDB[qcIndex][12][qcReputationIndex] == qcReputationEntry) then
								--tableinsert(qcWorkingLog, stringformat("\t[%d] Updated existing reputation entry from [%d] = %d to [%d] = %d", qcIndex, qcReputationIndex, qcWorkingDB[qcIndex][12][qcReputationIndex], qcReputationIndex, qcReputationEntry))
								qcWorkingDB[qcIndex][12][qcReputationIndex] = qcReputationEntry
							end
						end
					end
				end
			else
				tableinsert(qcWorkingLog, stringformat("\t[%d] Quest discarded due to suspected errors.", qcIndex))
			end
		end
	end

end
function qcMergeCycle()

-- Update collection code to add something like NPC name and map ID. Then use this during merge to see if a similar entry exists. If not then provide an alert to highlight the possible issue.
-- Where are quest categories stored for quest log? Global vars?

	qcMergeSavedVariables()				--[[ Main quest data merge ]]--
	qcUpdateInitiatorData()				--[[ Updates initiators based on data within qcMapIcons ]]--
	qcCleanQuestDatabaseEmptyTables()	--[[ Removes empty tables from the data to reduce size ]]--
	qcCorrectInvalidCategoryIDs()		--[[ Corrects 99999 category IDs using qcQuestCategories, and reports unknowns ]]--
	qcCorrectClasses()					--[[ Corrects class category IDs based on category name ]]--
	qcCorrectProfessions()				--[[ Corrects profession category ID and profession flag based on category name ]]--
	qcCorrectSeasonal()					--[[ Corrects seasonal category ID and seasonal flag based on category name ]]--

-- Then clean old database;

end

--[[ UTILITY CODE START ]]--

function qcBuildSkeletonQuest()

	local qcMapID = GetCurrentMapAreaID()
	local qcQuestID = GetQuestID()
	local qcQuestName = GetTitleText()
	local qcQuestLevel = "LEVEL"
	local qcQuestCategory = "CATEGORY"
	local qcQuestCategoryID = "CATEGORY_ID"
	local qcQuestType = "TYPE"

	local qcFaction = 0
	do
		local qcEFaction, _S = UnitFactionGroup("player")
		qcFaction = qcFactionBits[string.upper(qcEFaction)]
	end

	local qcRace = 0
	do
		local _S, qcERace = UnitRace("player")
		qcRace = qcRaceBits[string.upper(qcERace)]
	end

	local qcClass = 0
	do
		local _S, qcEClass = UnitClass("player")
		qcClass = qcClassBits[string.upper(qcEClass)]
	end

	local qcProfessionFlags = 0
	local qcSeasonalFlags = 0

	print(string.format("[%d] = [%d]={%d,%q,%s,%s,%s,%s,%d,%d,%d,%d,%d,},",qcMapID,qcQuestID,qcQuestID,qcQuestName,qcQuestLevel,qcQuestCategory,qcQuestCategoryID,qcQuestType,qcFaction,qcRace,qcClass,qcProfessionFlags,qcSeasonalFlags))

end
function qcVerifyMapDataExists()

	SetMapToCurrentZone()

	local qcQuestID = GetQuestID()
	local qcMapID = GetCurrentMapAreaID()

	if not (qcMapIcon[qcMapID]) then
		PlaySound("RaidWarning", "Master")
		print(string.format("|cFF9482C9Quest Completist DEBUG:|r [%d] |cffabd473Map ID %d [%s] does not yet exist.|r",qcQuestID,qcMapID,GetMapNameByID(qcMapID)))
		return nil
	end

	local X, Y = GetPlayerMapPosition("player")
	local qcX = tonumber(string.format("%.1f",X*100))
	local qcY = tonumber(string.format("%.1f",Y*100))
	local qcInitiatorFound
	local qcInitiatorIndex
	local qcQuestFound

	for qcIndex, qcEntry in pairs(qcMapIcon[qcMapID]) do
		if (qcEntry[4] == UnitName("questnpc")) then
			if (qcEntry[5] >= qcX-0.1) and (qcEntry[5] <= qcX+0.1) and (qcEntry[6] >= qcY-0.1) and (qcEntry[6] <= qcY+0.1) then
				qcInitiatorFound = true
				qcInitiatorIndex = qcIndex
				for qcQuestIndex, qcQuestEntry in pairs(qcEntry[7]) do
					if (qcQuestEntry == qcQuestID) then
						qcQuestFound = true
					end
				end
			end
		end
	end

	if not (qcQuestFound == true) then
		if (qcInitiatorFound == true) then
			PlaySoundFile("Interface\\AddOns\\QuestCompletist\\debug.mp3","Master")
			print(string.format("|cFF9482C9Quest Completist DEBUG:|r [%d:%d] |cffabd473Initiator exists in map data, but quest needs added.|r [Initiator Index: %d]",qcMapID,qcQuestID,qcInitiatorIndex))
		else
			PlaySound("RaidWarning","Master")
			print(string.format("|cFF9482C9Quest Completist DEBUG:|r [%d:%d] |cffabd473Neither initiator or quest found in map data. If initiator is stationary new map entry is likely needed.|r",qcMapID,qcQuestID))
		end
	end

end
function qcNPCID()

	local qcInitiatorGUID = UnitGUID("target")
	local qcInitiatorID = 0
	do
		local qcGUIDTypeBits = tonumber(strsub(qcInitiatorGUID,3,5),16)
		local qcGUIDType = bit.band(qcGUIDTypeBits,0x00F)
		if (qcGUIDType == 3) then
			qcInitiatorID = tonumber(strsub(qcInitiatorGUID,7,10),16)
		else
			qcInitiatorID = 0
		end
	end

	print(qcInitiatorID)

end
function qcGenerateMapData()

	SetMapToCurrentZone()
	local qcQuestID = GetQuestID()
	local qcMapID = GetCurrentMapAreaID()
	local qcMapLevel = GetCurrentMapDungeonLevel()

	local qcIconType = 1
	if (QuestIsDaily()) then
		qcIconType = 3
	end

	local qcInitiatorGUID = UnitGUID("questnpc")
	local qcInitiatorID = 0
	do
		local qcGUIDTypeBits = tonumber(strsub(qcInitiatorGUID,3,5),16)
		local qcGUIDType = bit.band(qcGUIDTypeBits,0x00F)
		if (qcGUIDType == 3) then
			qcInitiatorID = tonumber(strsub(qcInitiatorGUID,7,10),16)
		else
			qcInitiatorID = 0
		end
	end

	local qcInitiatorName = UnitName("questnpc")
	if (qcInitiatorName == UnitName("player")) then
		qcInitiatorName = "CHANGE_TO_NIL"
	end

	local qcX = 0
	local qxY = 0
	do
		local X, Y = GetPlayerMapPosition("player")
		qcX = tonumber(string.format("%.1f",X*100))
		qcY = tonumber(string.format("%.1f",Y*100))
	end
	print(string.format("ZONE MAP:   [%d] = {%d,%d,%d,%q,%.1f,%.1f,{%d}},", qcMapID, qcMapLevel, qcIconType, qcInitiatorID, qcInitiatorName, qcX, qcY, qcQuestID))

	SetMapByID(14)
	local qcMapID = GetCurrentMapAreaID()
	local qcMapLevel = GetCurrentMapDungeonLevel()
	do
		local X, Y = GetPlayerMapPosition("player")
		qcX = tonumber(string.format("%.1f",X*100))
		qcY = tonumber(string.format("%.1f",Y*100))
	end
	if not ((qcX == 0) and (qcY ==0)) then
		print(string.format("EK MAP:   [%d] = {%d,%d,%d,%q,%.1f,%.1f,{%d}},", qcMapID, qcMapLevel, qcIconType, qcInitiatorID, qcInitiatorName, qcX, qcY, qcQuestID))
	end

	SetMapByID(13)
	local qcMapID = GetCurrentMapAreaID()
	local qcMapLevel = GetCurrentMapDungeonLevel()
	do
		local X, Y = GetPlayerMapPosition("player")
		qcX = tonumber(string.format("%.1f",X*100))
		qcY = tonumber(string.format("%.1f",Y*100))
	end
	if not ((qcX == 0) and (qcY ==0)) then
		print(string.format("KA MAP:   [%d] = {%d,%d,%d,%q,%.1f,%.1f,{%d}},", qcMapID, qcMapLevel, qcIconType, qcInitiatorID, qcInitiatorName, qcX, qcY, qcQuestID))
	end

	SetMapByID(485)
	local qcMapID = GetCurrentMapAreaID()
	local qcMapLevel = GetCurrentMapDungeonLevel()
	do
		local X, Y = GetPlayerMapPosition("player")
		qcX = tonumber(string.format("%.1f",X*100))
		qcY = tonumber(string.format("%.1f",Y*100))
	end
	if not ((qcX == 0) and (qcY ==0)) then
		print(string.format("NR MAP:   [%d] = {%d,%d,%d,%q,%.1f,%.1f,{%d}},", qcMapID, qcMapLevel, qcIconType, qcInitiatorID, qcInitiatorName, qcX, qcY, qcQuestID))
	end

	SetMapByID(466)
	local qcMapID = GetCurrentMapAreaID()
	local qcMapLevel = GetCurrentMapDungeonLevel()
	do
		local X, Y = GetPlayerMapPosition("player")
		qcX = tonumber(string.format("%.1f",X*100))
		qcY = tonumber(string.format("%.1f",Y*100))
	end
	if not ((qcX == 0) and (qcY ==0)) then
		print(string.format("OL MAP:   [%d] = {%d,%d,%d,%q,%.1f,%.1f,{%d}},", qcMapID, qcMapLevel, qcIconType, qcInitiatorID, qcInitiatorName, qcX, qcY, qcQuestID))
	end

end
function qcFindMappedNILQuests()

	for qcMapIndex, qcMapEntry in pairs(qcMapIcon) do
		for qcInitiatorIndex, qcInitiatorEntry in pairs(qcMapIcon[qcMapIndex]) do
			for qcInitiatorQuestIndex, qcInitiatorQuestEntry in pairs(qcMapIcon[qcMapIndex][qcInitiatorIndex][7]) do
				if (qcQuestDatabase[qcInitiatorQuestEntry] == nil) then
					print(qcInitiatorQuestEntry .. " - Given by: " .. tostring(qcMapIcon[qcMapIndex][qcInitiatorIndex][4]))
				end
			end
		end
	end

end
function qcFindQuestsWithNoMapData()

	local qcFound
	local qcCountFound = 0
	local qcCountNotFound = 0
	local qcQuestCount = 0
	for qcQuestIndex, qcQuestEntry in pairs(qcQuestDatabase) do
		qcFound = false
		qcQuestCount = (qcQuestCount + 1)
		for qcMapIndex, qcMapEntry in pairs(qcMapIcon) do
			for qcInitiatorIndex, qcInitiatorEntry in pairs(qcMapIcon[qcMapIndex]) do
				for qcInitiatorQuestIndex, qcInitiatorQuestEntry in pairs(qcMapIcon[qcMapIndex][qcInitiatorIndex][7]) do
					if (qcInitiatorQuestEntry == qcQuestIndex) then
						qcFound = true
						--break
					end
				end
			end
		end
		if not (qcFound) then
			print(qcQuestIndex)
			-- Log the quest details.
			-- Possibly log them by Map ID or zone or something similar?
			qcCountNotFound = (qcCountNotFound + 1)
		else
			qcCountFound = (qcCountFound + 1)
		end
	end
	print("Out of " .. qcQuestCount .. " quests, map data was found for " .. qcCountFound .. " (" .. qcRound(((qcCountFound/qcQuestCount)*100),2) .. "%), and " .. qcCountNotFound .. " (" .. qcRound(((qcCountNotFound/qcQuestCount)*100),2) .. "%) had no map data assosiated with it.")

end						
function qcQueryMapDataForQuest(qcQuestID)

	if not (qcQuestID) then return nil end
	local qcFound
	for qcMapIndex, qcMapEntry in pairs(qcMapIcon) do
		for qcInitiatorIndex, qcInitiatorEntry in pairs(qcMapIcon[qcMapIndex]) do
			for qcInitiatorQuestIndex, qcInitiatorQuestEntry in pairs(qcMapIcon[qcMapIndex][qcInitiatorIndex][7]) do
				if (qcInitiatorQuestEntry == qcQuestID) then
					if not (qcFound) then
						print("Quest: " .. qcInitiatorQuestEntry .. " - " .. qcQuestDatabase[qcInitiatorQuestEntry][2])
						print("   Given by: " .. tostring(qcMapIcon[qcMapIndex][qcInitiatorIndex][4]))
						print("      Located on Map ID: " .. qcMapIndex .. " @ " .. qcMapIcon[qcMapIndex][qcInitiatorIndex][5] .. ", " .. qcMapIcon[qcMapIndex][qcInitiatorIndex][6])
					else
						print("   Also given by: " .. tostring(qcMapIcon[qcMapIndex][qcInitiatorIndex][4]))
						print("      Located on Map ID: " .. qcMapIndex .. " @ " .. qcMapIcon[qcMapIndex][qcInitiatorIndex][5] .. ", " .. qcMapIcon[qcMapIndex][qcInitiatorIndex][6])
					end
					qcFound = true
				end
			end
		end
	end

end
function qcFindNonStandardRaceClassFlags()

	local stringformat = string.format

	for qcQuestIndex, qcQuestEntry in pairs(qcQuestDatabase) do
		if (qcQuestEntry[7] == qcFactionBits.ALLIANCE) then
			if not (qcQuestEntry[8] == qcARaceFlags) then
				print(stringformat("[%d] Alliance quest with non-standard race flags: %d - Quest category: %s",qcQuestIndex,qcQuestEntry[8],qcQuestEntry[4]))
			end
			if not (qcQuestEntry[9] == qcAHClassFlags) then
				print(stringformat("[%d] Alliance quest with non-standard class flags: %d - Quest category: %s",qcQuestIndex,qcQuestEntry[9],qcQuestEntry[4]))
			end
		elseif (qcQuestEntry[7] == qcFactionBits.HORDE) then
			if not (qcQuestEntry[8] == qcHRaceFlags) then
				print(stringformat("[%d] Horde quest with non-standard race flags: %d - Quest category: %s",qcQuestIndex,qcQuestEntry[8],qcQuestEntry[4]))
			end
			if not (qcQuestEntry[9] == qcAHClassFlags) then
				print(stringformat("[%d] Horde quest with non-standard class flags: %d - Quest category: %s",qcQuestIndex,qcQuestEntry[9],qcQuestEntry[4]))
			end
		elseif (qcQuestEntry[7] == (qcFactionBits.ALLIANCE + qcFactionBits.HORDE)) then
			if not (qcQuestEntry[8] == qcAHRaceFlags) then
				print(stringformat("[%d] Cross faction quest with non-standard race flags: %d - Quest category: %s",qcQuestIndex,qcQuestEntry[8],qcQuestEntry[4]))
			end
			if not (qcQuestEntry[9] == qcAHClassFlags) then
				print(stringformat("[%d] Cross faction quest with non-standard class flags: %d - Quest category: %s",qcQuestIndex,qcQuestEntry[9],qcQuestEntry[4]))
			end
		end
	end

end

--[[ COLLECTION CODE START ]]--

local function qcGetQuestCategory(qcQuestID)

	local _S, qcIsHeader, qcHeader
	local qcQuestIDIndex = GetQuestLogIndexByID(qcQuestID)

	if (qcQuestIDIndex == 0) then return nil end

	while (qcQuestIDIndex >= 1) do
		qcHeader, _S, _S, _S, qcIsHeader, _S, _S, _S, _S, _S, _S = GetQuestLogTitle(qcQuestIDIndex)
		if (qcIsHeader == 1) then return qcHeader end
		qcQuestIDIndex = (qcQuestIDIndex - 1)
	end

	return nil

end
function qcCollectQuestOnProgressComplete(qcQuestID)

	if (qcProgressComplete == nil) then qcProgressComplete = {} end

	if (GetLocale() == "enUS") or (GetLocale() == "enGB") then

		if (qcQuestID == 0) or (qcQuestID == nil) then return nil end
		if not (GetQuestLogIndexByID(qcQuestID) == 0) then return nil end

		local qcQuestName = GetTitleText()

		local qcFaction = 0
		do
			local qcEFaction, _S = UnitFactionGroup("player")
			qcFaction = qcFactionBits[string.upper(qcEFaction)]
		end

		local qcRace = 0
		do
			local _S, qcERace = UnitRace("player")
			qcRace = qcRaceBits[string.upper(qcERace)]
		end

		local qcClass = 0
		do
			local _S, qcEClass = UnitClass("player")
			qcClass = qcClassBits[string.upper(qcEClass)]
		end

		local qcMapID = GetCurrentMapAreaID()
		local qcInitiatorName = (UnitName("questnpc") or "<Unknown Initiator>")
		do
			if (qcInitiatorName == UnitName("player")) then
				qcInitiatorName = "<Player>"
			end
		end

		local qcX
		local qcY
		do
			qcX, qcY = GetPlayerMapPosition("player")
			qcX = qcRound((qcX*100), 1)
			qcY = qcRound((qcY*100), 1)
		end

		if (qcProgressComplete[qcQuestID] == nil) then
			qcProgressComplete[qcQuestID] = {true,true,true,true,true,true,true,true,true}
			qcProgressComplete[qcQuestID][1] = qcQuestID
			qcProgressComplete[qcQuestID][2] = qcQuestName
			qcProgressComplete[qcQuestID][3] = qcFaction
			qcProgressComplete[qcQuestID][4] = qcRace
			qcProgressComplete[qcQuestID][5] = qcClass
			qcProgressComplete[qcQuestID][6] = qcMapID
			qcProgressComplete[qcQuestID][7] = qcInitiatorName
			qcProgressComplete[qcQuestID][8] = qcX
			qcProgressComplete[qcQuestID][9] = qcY
		else
			qcProgressComplete[qcQuestID][1] = qcQuestID
			qcProgressComplete[qcQuestID][2] = qcQuestName
			if (bit.band(qcProgressComplete[qcQuestID][3], qcFaction) == 0) then
				qcProgressComplete[qcQuestID][3] = tonumber(qcProgressComplete[qcQuestID][3] + qcFaction)
			end
			if (bit.band(qcProgressComplete[qcQuestID][4], qcRace) == 0) then
				qcProgressComplete[qcQuestID][4] = tonumber(qcProgressComplete[qcQuestID][4] + qcRace)
			end
			if (bit.band(qcProgressComplete[qcQuestID][5], qcClass) == 0) then
				qcProgressComplete[qcQuestID][5] = tonumber(qcProgressComplete[qcQuestID][5] + qcClass)
			end
			qcProgressComplete[qcQuestID][6] = qcMapID
			qcProgressComplete[qcQuestID][7] = qcInitiatorName
			qcProgressComplete[qcQuestID][8] = qcX
			qcProgressComplete[qcQuestID][9] = qcY
		end

	end

end
function qcDetectSharedQuestOnDetail(qcQuestID)

	if not (qcSharedIDs) then qcSharedIDs = {} end

	local qcNPCName = UnitName("questnpc")
	if (UnitExists("questnpc")) then
		if (qcNPCName == UnitName("player")) then
			return nil
		elseif (UnitInParty(qcNPCName) == 1) then
			print("|cFF9482C9Quest Completist:|r This quest appears to be shared from someone in your party. Not recording the quest information.")
			table.insert(qcSharedIDs,qcQuestID,1)
		elseif (UnitInRaid(qcNPCName) == 1) then
			print("|cFF9482C9Quest Completist:|r This quest appears to be shared from someone in your raid. Not recording the quest information.")
			table.insert(qcSharedIDs,qcQuestID,1)
		end
	end

end
function qcCollectQuestOnAccept(...)

	if not (qcCollectedQuests) then qcCollectedQuests = {} end
	if ((GetLocale() == "enUS") or (GetLocale() == "enGB")) then

		local qcQuestLogIndex, qcQuestID = ...
		SelectQuestLogEntry(qcQuestLogIndex)

		if not (qcQuestID) or (qcQuestID == 0) then return nil end
		if (qcSharedIDs[qcQuestID]) then return nil	end

		local qcQuestName
		local qcQuestLevel = 0
		local qcQuestType = 1
		do
			local _S, qcName, qcLevel, qcTag, qcDaily
			qcName, qcLevel, qcTag, _S, _S, _S, _S, qcDaily, _S, _S, _S = GetQuestLogTitle(qcQuestLogIndex)
			if not ((qcName) or (tostring(qcName) == "nil")) then return nil end
			if not (qcTag) then qcQuestName = tostring(qcName) else qcQuestName = string.format("%s [%s]",qcName,qcTag) end
			if (qcLevel > 0) then qcQuestLevel = qcLevel end
			if (qcDaily == 1) then qcQuestType = 3 end
		end

		local qcQuestCategory = (qcGetQuestCategory(qcQuestID) or "<Category Unknown>")
		if (qcQuestCategory == "<Category Unknown>") then return nil end

		local qcCategoryID = 99999
		for qcIndex, qcEntry in ipairs(qcQuestCategories) do
			if (qcEntry[2] == qcQuestCategory) then
				qcCategoryID = qcEntry[1]
				break
			end
		end

		local qcFaction = 0
		do
			local qcEFaction, _S = UnitFactionGroup("player")
			qcFaction = qcFactionBits[string.upper(qcEFaction)]
		end

		local qcRace = 0
		do
			local _S, qcERace = UnitRace("player")
			qcRace = qcRaceBits[string.upper(qcERace)]
		end

		local qcClass = 0
		do
			local _S, qcEClass = UnitClass("player")
			qcClass = qcClassBits[string.upper(qcEClass)]
		end

		local qcProfession = 0
		local qcSeasonal = 0

		if not (qcCollectedQuests[qcQuestID]) then
			qcCollectedQuests[qcQuestID] = {true,true,true,true,true,true,true,true,true,true,true}
			qcCollectedQuests[qcQuestID][1] = qcQuestID
			qcCollectedQuests[qcQuestID][2] = qcQuestName
			qcCollectedQuests[qcQuestID][3] = qcQuestLevel
			qcCollectedQuests[qcQuestID][4] = qcQuestCategory
			qcCollectedQuests[qcQuestID][5] = qcCategoryID
			qcCollectedQuests[qcQuestID][6] = qcQuestType
			qcCollectedQuests[qcQuestID][7] = qcFaction
			qcCollectedQuests[qcQuestID][8] = qcRace
			qcCollectedQuests[qcQuestID][9] = qcClass
			qcCollectedQuests[qcQuestID][10] = qcProfession
			qcCollectedQuests[qcQuestID][11] = qcSeasonal
			SelectQuestLogEntry(qcQuestLogIndex)
			local qcReputationCount = GetNumQuestLogRewardFactions()
			if (qcReputationCount > 0) then
				qcCollectedQuests[qcQuestID][12] = {}
				local qcFactionName, qcReputationAmount, qcFactionID, qcIsHeader, qcHasRep, _S
				local qcIndex = 0
				local _S
				for qcReputationIndex = 1, qcReputationCount do
					qcFactionID, qcReputationAmount = GetQuestLogRewardFactionInfo(qcReputationIndex)
					qcFactionName, _S, _S, _S, _S, _S, _S, _S, qcIsHeader, _S, qcHasRep, _S, _S = GetFactionInfoByID(qcFactionID)
					if (qcFactionName) and (not qcIsHeader or qcHasRep) then
						qcIndex = (qcIndex+1)
						qcReputationAmount = floor(qcReputationAmount/100)
						qcCollectedQuests[qcQuestID][12][qcFactionID] = qcReputationAmount
					end
				end
			end
		else
			qcCollectedQuests[qcQuestID][1] = qcQuestID
			qcCollectedQuests[qcQuestID][2] = qcQuestName
			qcCollectedQuests[qcQuestID][3] = qcQuestLevel
			qcCollectedQuests[qcQuestID][4] = qcQuestCategory
			qcCollectedQuests[qcQuestID][5] = qcCategoryID
			qcCollectedQuests[qcQuestID][6] = qcQuestType
			if (bit.band(qcCollectedQuests[qcQuestID][7], qcFaction) == 0) then
				qcCollectedQuests[qcQuestID][7] = tonumber(qcCollectedQuests[qcQuestID][7] + qcFaction)
			end
			if (bit.band(qcCollectedQuests[qcQuestID][8], qcRace) == 0) then
				qcCollectedQuests[qcQuestID][8] = tonumber(qcCollectedQuests[qcQuestID][8] + qcRace)
			end
			if (bit.band(qcCollectedQuests[qcQuestID][9], qcClass) == 0) then
				qcCollectedQuests[qcQuestID][9] = tonumber(qcCollectedQuests[qcQuestID][9] + qcClass)
			end
			qcCollectedQuests[qcQuestID][10] = qcProfession
			qcCollectedQuests[qcQuestID][11] = qcSeasonal
			SelectQuestLogEntry(qcQuestLogIndex)
			local qcReputationCount = GetNumQuestLogRewardFactions()
			if (qcReputationCount > 0) then
				qcCollectedQuests[qcQuestID][12] = {}
				local qcFactionName, qcReputationAmount, qcFactionID, qcIsHeader, qcHasRep, _S
				local qcIndex = 0
				local _S
				for qcReputationIndex = 1, qcReputationCount do
					qcFactionID, qcReputationAmount = GetQuestLogRewardFactionInfo(qcReputationIndex)
					qcFactionName, _S, _S, _S, _S, _S, _S, _S, qcIsHeader, _S, qcHasRep, _S, _S = GetFactionInfoByID(qcFactionID)
					if (qcFactionName) and (not qcIsHeader or qcHasRep) then
						qcIndex = (qcIndex+1)
						qcReputationAmount = floor(qcReputationAmount/100)
						qcCollectedQuests[qcQuestID][12][qcFactionID] = qcReputationAmount
					end
				end
			end
		end

	end

end

--[[ DATA START ]]--

qcSVData = {

}