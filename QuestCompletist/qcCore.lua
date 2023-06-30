--[[ Internal Tables ]]--
qcCompletedQuests = {}
qcMapQuests = {}
qcPins = {}
qcSparePins = {}
qcWorkingDB = {}
qcWorkingLog = {}

local qcL = qcLocalize

--[[ Map Icon Tables ]]--
local qcCurrentMapInitiators = {} --[[ Stores quest initiators for a single Map ID ]]--
local qcCurrentMapIcons = {} --[[ Stores the icons for a single Map ID ]]--
local qcSpareMapIcons = {} --[[ Stores icons that can be recycled ]]--

--[[ qcUpdateQuestList\qcGetCategoryQuests Variables ]]--
local qcCurrentCategoryID = 0
local qcCurrentCategoryQuestCount = 0
local qcCategoryQuests = {}

--[[ Search Variables ]]--
local qcSearchText = nil

--[[ Vars ]]--
local qcCurrentMapZone = -1
local qcCurrentScrollPosition = 1
local qcMap = nil
local qcMapTooltip = nil
local qcQuestReputationTooltip = nil
local qcQuestInformationTooltip = nil
local qcToastTooltip = nil
local qcNewDataAlertTooltip = nil
local qcMutuallyExclusiveAlertTooltip = nil

--[[ Constants ]]--
local QCADDON_VERSION = 99.7
local QCADDON_PURGE = true
local QCDEBUG_MODE = false
local QCTRIPLEPADDING = "   "
local QCADDON_CHAT_TITLE = "|CFF9482C9Quest Completist:|r "

local COLOUR_DEATHKNIGHT = "|cFFC41F3B"
local COLOUR_DRUID = "|cFFFF7D0A"
local COLOUR_HUNTER = "|cFFABD473"
local COLOUR_MAGE = "|cFF69CCF0"
local COLOUR_PALADIN = "|cFFF58CBA"
local COLOUR_PRIEST = "|cFFFFFFFF"
local COLOUR_ROGUE = "|cFFFFF569"
local COLOUR_SHAMAN = "|cFF0070DE"
local COLOUR_WARLOCK = "|cFF9482C9"
local COLOUR_WARRIOR = "|cFFC79C6E"

local QC_ICON_COORDS_NORMAL = {0,0.125,0,0.25}
local QC_ICON_COORDS_REPEATABLE = {0.125,0.25,0.25,0.50}
local QC_ICON_COORDS_DAILY = {0,0.125,0.25,0.50}
local QC_ICON_COORDS_SPECIAL = {0,0.125,0,0.25}
local QC_ICON_COORDS_WEEKLY = {0,0.125,0,0.25}
local QC_ICON_COORDS_SEASONAL = {0,0.125,0.5,0.75}
local QC_ICON_COORDS_PROFESSION = {0.625,0.75,0,0.25}
local QC_ICON_COORDS_PROGRESS = {0.25,0.375,0.25,0.5}
local QC_ICON_COORDS_READY = {0.125,0.25,0,0.25}
local QC_ICON_COORDS_COMPLETE = {0.125,0.25,0.5,0.75}
local QC_ICON_COORDS_UNATTAINABLE = {0.25,0.375,0.5,0.75}
local QC_ICON_COORDS_ITEMDROPSTANDARD = {0.375,0.5,0,0.25}
local QC_ICON_COORDS_ITEMDROPREPEATABLE = {0.375,0.5,0.25,0.5}
local QC_ICON_COORDS_CLASS = {0.5,0.625,0,0.25}
local QC_ICON_COORDS_KILL = {0.25,0.375,0,0.25}

--[[ Bitwise Values ]]--
qcFactionBits = {
	["ALLIANCE"]=1,["HORDE"]=2
}
qcRaceBits = {
	["HUMAN"]=1,["ORC"]=2,["DWARF"]=4,["NIGHTELF"]=8,
	["SCOURGE"]=16,["TAUREN"]=32,["GNOME"]=64,["TROLL"]=128,
	["GOBLIN"]=256,["BLOODELF"]=512,["DRAENEI"]=1024,["WORGEN"]=2048,
	["PANDAREN"]=4096
}
qcClassBits = {
	["WARRIOR"]=1,["PALADIN"]=2,["HUNTER"]=4,["ROGUE"]=8,["PRIEST"]=16,
	["DEATHKNIGHT"]=32,["SHAMAN"]=64,["MAGE"]=128,["WARLOCK"]=256,["DRUID"]=512,
	["MONK"]=1024
}
qcProfessionBits = {
	[171]=1,		-- Alchemy
	[164]=2,		-- Blacksmithing
	[333]=4,		-- Enchanting
	[202]=8,		-- Engineering
	[773]=16,		-- Inscription
	[755]=32,		-- Jewelcrafting
	[165]=64,		-- Leatherworking
	[197]=128,		-- Tailoring
	[182]=256,		-- Herbalism
	[186]=512,		-- Mining
	[393]=1024,		-- Skinning
	[794]=2048,		-- Archaeology
	[129]=4096,		-- First Aid
	[185]=8192,		-- Cooking
	[356]=16384,	-- Fishing
}
local qcHolidayDates = {
	[1]={"110920","111005"},		-- Brewfest 2011
	[2]={"120429","120505"},		-- Children's Week 2012
	[4]={"111101","111102"},		-- Day of the Dead 2011
	[8]={"111215","120102"},		-- Feast of Winter Veil 2011-2012
	[16]={"111018","111031"},		-- Hallow's End 2011
	[32]={"110906","110912"},		-- Harvest Festival TODO FOR 2012
	[64]={"120205","120218"},		-- Love is in the Air 2012
	[128]={"120122","120211"},		-- Lunar Festival 2012
	[256]={"120621","120704"},		-- Midsummer Fire Festival 2012
	[512]={"120408","120414"},		-- Noblegarden 2012
	[1024]={"111120","111126"},		-- Pilgrim's Bounty 2011
	[2048]={"120919","120919"},		-- Pirates' Day 2012
}

--[[ Constants for the Key Bindings & Slash Commands ]]--
BINDING_HEADER_QCQUESTCOMPLETIST = "Quest Completist";
BINDING_NAME_QCTOGGLEFRAME = "Toggle Frame";
SLASH_QUESTCOMPLETIST1 = "/qc"
SLASH_QUESTCOMPLETIST2 = "/questc"

SlashCmdList["QUESTCOMPLETIST"] = function(msg, editbox)
	ShowUIPanel(qcQuestCompletistUI)
end

function qcCopyTable(qcTable)

	if not (qcTable) then return nil end
	if not (type(qcTable) == "table") then return nil end

	local qcNewTable = {}
	for qcKey, qcValue in pairs(qcTable) do
		if (type(qcValue) == "table") then
			qcNewTable[qcKey] = qcCopyTable(qcValue)
		else
			qcNewTable[qcKey] = qcValue
		end
	end

	return qcNewTable

end

function qcUpdateCurrentCategoryText(qcCategoryID)

	qcQuestCompletistUI.qcSelectedCategory:SetText("#")
	for qcIndex, qcEntry in pairs(qcQuestCategories) do
		if (qcEntry[1] == qcCategoryID) then
			qcQuestCompletistUI.qcSelectedCategory:SetText(qcEntry[2])
			break
		end
	end

end

local function qcCollectUpdate()

	if not (qcCollectedQuests) then qcCollectedQuests = {} end

	local qcUpdateCount = 0
	for qcIndex, qcEntry in pairs(qcCollectedQuests) do
		qcUpdateCount = (qcUpdateCount + 1)
	end

	print(string.format("%sThanks for using Quest Completist. You have gathered %d updates so far. Every now and then, please consider sending me your Saved Variables file so that I can include these updates in the next version.",QCADDON_CHAT_TITLE,qcUpdateCount))
	print(string.format("%s%sLocalization has begun! Please help translate the addon by visiting QC's curseforge page.",QCADDON_CHAT_TITLE,COLOUR_PALADIN))

end

local function qcUpdateMutuallyExclusiveCompletedQuest(qcQuestID)

	if (qcMutuallyExclusive[qcQuestID]) then
		for qcMutuallyExclusiveIndex, qcMutuallyExclusiveEntry in pairs(qcMutuallyExclusive[qcQuestID]) do
			if (qcQuestDatabase[qcMutuallyExclusiveEntry]) then
				qcCompletedQuests[qcMutuallyExclusiveEntry] = {["C"]=1}
			end
		end
	end

end

local function qcUpdateSkippedBreadcrumbQuest(qcQuestID)

	if (qcBreadcrumbQuests[qcQuestID]) then
		for qcBreadcrumbIndex, qcBreadcrumbEntry in pairs(qcBreadcrumbQuests[qcQuestID]) do
			if (qcQuestDatabase[qcBreadcrumbEntry]) then
				qcCompletedQuests[qcBreadcrumbEntry] = {["C"]=1}
			end
		end
	end

end

local function qcGetSearchQuests(qcSearchText)

	local tableinsert = table.insert
	local stringupper = string.upper
	local tablesort = table.sort
	local stringfind = string.find

	wipe(qcSearchQuests)
	local qcHoldingTable = {}
	for qcIndex, qcEntry in pairs(qcQuestDatabase) do
		if (stringfind(stringupper(qcEntry[2]),qcSearchText,1,true)) then
			tableinsert(qcHoldingTable,qcEntry)
		end
	end
	qcSearchQuests = qcCopyTable(qcHoldingTable)
	wipe(qcHoldingTable)

end

local function qcGetCategoryQuests(qcCategoryID, qcSearch, qcSearchText)

	if (qcSearch) then
		local tableinsert = table.insert
		local stringupper = string.upper
		local tablesort = table.sort
		local stringfind = string.find

		wipe(qcCategoryQuests)
		local qcHoldingTable = {}
		for qcIndex, qcEntry in pairs(qcQuestDatabase) do
			if (stringfind(stringupper(qcEntry[2]),qcSearchText,1,true)) then
				tableinsert(qcHoldingTable,qcEntry)
			end
		end
		qcCategoryQuests = qcCopyTable(qcHoldingTable)
		wipe(qcHoldingTable)
		return nil
	end

	local tableinsert = table.insert
	local tableremove = table.remove
	local stringupper = string.upper
	local bitband = bit.band
	local tablesort = table.sort

	wipe(qcCategoryQuests)
	local qcHoldingTable = {}
	for qcIndex, qcEntry in pairs(qcQuestDatabase) do
		if (qcEntry[5] == qcCategoryID) then
			tableinsert(qcHoldingTable,qcEntry)
		end
	end
	qcCategoryQuests = qcCopyTable(qcHoldingTable)
	wipe(qcHoldingTable)

	if (qcSettings["QC_L_HIDE_COMPLETED"] == 1) then
		for qcCategoryQuestsIndex = #qcCategoryQuests, 1, -1 do
			if (qcCompletedQuests[qcCategoryQuests[qcCategoryQuestsIndex][1]]) then
				if (qcCompletedQuests[qcCategoryQuests[qcCategoryQuestsIndex][1]]["C"] == 1) or (qcCompletedQuests[qcCategoryQuests[qcCategoryQuestsIndex][1]]["C"] == 2) then
					tableremove(qcCategoryQuests,qcCategoryQuestsIndex)
				end
			end
		end
	end

	if (qcSettings["QC_ML_HIDE_FACTION"] == 1) then
		local qcCurrentPlayerFaction, _S = UnitFactionGroup("player")
		local qcCurrentFaction = qcFactionBits[stringupper(qcCurrentPlayerFaction)]
		for qcCategoryQuestsIndex = #qcCategoryQuests, 1, -1 do
			if (bitband(qcCategoryQuests[qcCategoryQuestsIndex][7], qcCurrentFaction) == 0) then
				tableremove(qcCategoryQuests,qcCategoryQuestsIndex)
			end
		end
	end

	if (qcSettings["QC_ML_HIDE_RACECLASS"] == 1) then
		local _S, qcCurrentPlayerRace = UnitRace("player")
		local qcCurrentRace = qcRaceBits[stringupper(qcCurrentPlayerRace)]
		local _S, qcCurrentPlayerClass = UnitClass("player")
		local qcCurrentClass = qcClassBits[stringupper(qcCurrentPlayerClass)]
		for qcCategoryQuestsIndex = #qcCategoryQuests, 1, -1 do
			if (bitband(qcCategoryQuests[qcCategoryQuestsIndex][8], qcCurrentRace) == 0) then
				tableremove(qcCategoryQuests,qcCategoryQuestsIndex)
			elseif (bitband(qcCategoryQuests[qcCategoryQuestsIndex][9], qcCurrentClass) == 0) then
				tableremove(qcCategoryQuests,qcCategoryQuestsIndex)
			end
		end
	end

	if (qcSettings["SORT"] == 1) then
		tablesort(qcCategoryQuests,function(a,b) return (a[3]<b[3] or (a[3] == b[3] and a[2]<b[2])) end)
	elseif (qcSettings["SORT"] == 2) then
		tablesort(qcCategoryQuests,function(a,b) return a[2]<b[2] end)
	else
		tablesort(qcCategoryQuests,function(a,b) return (a[3]<b[3] or (a[3] == b[3] and a[2]<b[2])) end)
	end

end

function qcUpdateQuestList(qcCategoryID, qcStartIndex, qcSearch, qcSearchText)

	local stringformat = string.format
	local qcQuestListRecordName = "qcMenuButton"
	local qcHash = "#"

	if (qcCategoryID) then
		qcCurrentCategoryID = qcCategoryID
		qcUpdateCurrentCategoryText(qcCategoryID)
		qcQuestCompletistUI.qcSearchBox:SetText("")
		qcGetCategoryQuests(qcCategoryID)
		qcCurrentCategoryQuestCount = (#qcCategoryQuests)
		qcQuestCompletistUI.qcCurrentCategoryQuestCount:SetText(stringformat("%d Quests Found",qcCurrentCategoryQuestCount))
		if (qcCurrentCategoryQuestCount < 16) then
			qcMenuSlider:SetMinMaxValues(1, 1)
		else
			qcMenuSlider:SetMinMaxValues(1, qcCurrentCategoryQuestCount - 15)
		end
		qcMenuSlider:SetValue(qcStartIndex)
	else
		if (qcSearch) then
			qcGetCategoryQuests(nil, true, qcSearchText)
			qcCurrentCategoryQuestCount = (#qcCategoryQuests)
			qcQuestCompletistUI.qcSelectedCategory:SetText("Search Results")
			qcQuestCompletistUI.qcCurrentCategoryQuestCount:SetText(stringformat("%d Quests Found",qcCurrentCategoryQuestCount))
			if (qcCurrentCategoryQuestCount < 16) then
				qcMenuSlider:SetMinMaxValues(1, 1)
			else
				qcMenuSlider:SetMinMaxValues(1, qcCurrentCategoryQuestCount - 15)
			end
			qcMenuSlider:SetValue(qcStartIndex)
		end
	end

	for qcQuestListIndex = 1, 16 do
		local qcOffset = ((qcQuestListIndex + qcStartIndex) - 1)
		local qcQuestListRecord = _G[qcQuestListRecordName .. qcQuestListIndex]
		if (qcCurrentCategoryQuestCount >= qcOffset) then
			local qcCategoryEntry = qcCategoryQuests[qcOffset]
			local qcQuestID = qcCategoryEntry[1]
			qcQuestListRecord.QuestName:SetText(stringformat("[%d] %s",qcCategoryEntry[3],qcCategoryEntry[2]))
			qcQuestListRecord.QuestID = qcQuestID
			qcQuestListRecord.QuestIcon:SetTexture("Interface\\Addons\\QuestCompletist\\Images\\QCIcons")
			local qcQuestType = qcCategoryEntry[6]
			if (qcQuestType == 1) then --[[ Normal ]]--
				qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_NORMAL))
				qcQuestListRecord.QuestName:SetTextColor(1.0, 1.0, 1.0, 1.0)
			elseif (qcQuestType == 2) then --[[ Repeatable ]]--
				qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_REPEATABLE))
				qcQuestListRecord.QuestName:SetTextColor(0.0941176470588235, 0.6274509803921569, 0.9411764705882353, 1.0)
			elseif (qcQuestType == 3) then --[[ Daily ]]--
				qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_DAILY))
				qcQuestListRecord.QuestName:SetTextColor(0.0941176470588235, 0.6274509803921569, 0.9411764705882353, 1.0)
			elseif (qcQuestType == 4) then --[[ Special TODO: USING NORMAL ICON ]]--
				qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_NORMAL))
				qcQuestListRecord.QuestName:SetTextColor(1.0, 0.6156862745098039, 0.0862745098039216, 1.0)
			elseif (qcQuestType == 5) then --[[ Weekly TODO: USING NORMAL ICON ]]--
				qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_NORMAL))
				qcQuestListRecord.QuestName:SetTextColor(1.0, 1.0, 1.0, 1.0)
			elseif (qcQuestType == 6) then --[[ Profession ]]--
				qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_PROFESSION))
				qcQuestListRecord.QuestName:SetTextColor(1.0, 1.0, 1.0, 1.0)
			elseif (qcQuestType == 7) then --[[ Seasonal ]]--
				qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_SEASONAL))
				qcQuestListRecord.QuestName:SetTextColor(1.0, 1.0, 1.0, 1.0)
			else
				qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_NORMAL))
				qcQuestListRecord.QuestName:SetTextColor(1.0, 1.0, 1.0, 1.0)
			end
			qcQuestListRecord.QuestIcon:Show()
			--[[ Set faction icon ]]--
			local qcQuestFaction = qcCategoryEntry[7]
			if (qcQuestFaction == 1) then
				qcQuestListRecord.FactionIcon:SetTexture("Interface\\Addons\\QuestCompletist\\Images\\AllianceIcon")
				qcQuestListRecord.FactionIcon:Show()
			elseif(qcQuestFaction == 2) then
				qcQuestListRecord.FactionIcon:SetTexture("Interface\\Addons\\QuestCompletist\\Images\\HordeIcon")
				qcQuestListRecord.FactionIcon:Show()
			elseif(qcQuestFaction == 3) then
				qcQuestListRecord.FactionIcon:Hide()
			else
				qcQuestListRecord.FactionIcon:Hide()
			end
			--[[ Check quest state ]]--
			if not (GetQuestLogIndexByID(qcQuestID) == 0) then
				local _S
				local qcIsComplete
				_S, _S, _S, _S, _S, _S, qcIsComplete, _S, _S = GetQuestLogTitle(GetQuestLogIndexByID(qcQuestID))
				if (qcIsComplete == nil) then --[[ Quest is yet to reach a conclusion ]]--
					qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_PROGRESS))
					qcQuestListRecord.QuestName:SetTextColor(0.5803921568627451, 0.5882352941176471, 0.5803921568627451, 1.0)
				elseif (qcIsComplete == 1) then --[[ Is completed ]]--
					qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_READY))
					qcQuestListRecord.QuestName:SetTextColor(1.0, 0.8196078431372549, 0.0, 1.0)
				elseif (qcIsComplete == -1) then --[[ Is failed or abandoned ]]--
					qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_NORMAL))
					qcQuestListRecord.QuestName:SetTextColor(0.9372549019607843, 0.1490196078431373, 0.0627450980392157, 1.0)
				end
			end
			--[[ Check completed state. Does not colour repeatables	or daily quests. ]]--
			if (qcCompletedQuests[qcQuestID]) then
				if not (qcCategoryEntry[6] == 2) or (qcCategoryEntry[6] == 3) then
					--[[ Quest is not repeatable or daily ]]--
					if (qcCompletedQuests[qcQuestID]["C"] == 1) then --[[ Quest is complete ]]--
						qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_COMPLETE))
						qcQuestListRecord.QuestName:SetTextColor(0.0, 1.0, 0.0, 1.0)
					elseif (qcCompletedQuests[qcQuestID]["C"] == 2) then --[[ Quest is unattainable ]]--
						qcQuestListRecord.QuestIcon:SetTexCoord(unpack(QC_ICON_COORDS_UNATTAINABLE))
						qcQuestListRecord.QuestName:SetTextColor(0.77, 0.12, 0.23, 1.0)
					end
				else
					--[[ Shouldn't need to do anything here? Should still be blue with correct icon. ]]--
				end
			end
			qcQuestListRecord:Show()
			qcQuestListRecord:Enable()
		else
			qcQuestListRecord.QuestName:SetText(qcHash)
			qcQuestListRecord:Hide()
			qcQuestListRecord:Disable()
		end
	end

end

function qcSearchBox_OnEditFocusLost(self)

	qcSearchText = string.upper(self:GetText())
	if not (qcSearchText == "") then
		qcUpdateQuestList(nil, 1, true, qcSearchText)
	else
		qcUpdateQuestList(qcCurrentCategoryID, 1)
	end

end

function qcSearchBox_OnTextChanged(self, qcUserInput)

	if (qcUserInput == true) then
		qcSearchText = string.upper(self:GetText())
		if not (qcSearchText == "") then
			qcUpdateQuestList(nil, 1, true, qcSearchText)
		else
			qcUpdateQuestList(qcCurrentCategoryID, 1)
		end
	end

end

function qcScrollUpdate(qcValue)

	if not (qcCurrentScrollPosition == qcValue) then
		qcCurrentScrollPosition = qcValue
		qcUpdateQuestList(nil, qcValue)
	end

end

local function qcQuestQueryCompleted()

	local qcRecievedQuestCount = 0
	local qcCompletedTable = {}

	GetQuestsCompleted(qcCompletedTable)

	for qcCompletedIndex, qcCompletedQuest in pairs(qcCompletedTable) do
		qcRecievedQuestCount = (qcRecievedQuestCount+1)
		if not (qcQuestDatabase[qcCompletedIndex] == nil) then
			if not ((qcQuestDatabase[qcCompletedIndex][6] == 2) or (qcQuestDatabase[qcCompletedIndex][6] == 3)) then
				qcCompletedQuests[qcCompletedIndex] = {["C"]=1}
			end
		end
		qcUpdateMutuallyExclusiveCompletedQuest(qcCompletedIndex)
		qcUpdateSkippedBreadcrumbQuest(qcCompletedIndex)
	end

	print(string.format("%sRetrieved %d quests from the server. These have now been flagged as completed.",QCADDON_CHAT_TITLE,qcRecievedQuestCount))
	qcUpdateQuestList(nil,qcMenuSlider:GetValue())

end

local function qcClearUpdateCache()

	--[[ Clear the caches ]]--
	wipe(qcCompletedQuests)
	print(string.format("%sCache Cleared.",QCADDON_CHAT_TITLE))

end

local function qcPurgeCollectedCache()

	if (qcCollectedQuests == nil) then qcCollectedQuests = {} end
	if (qcProgressComplete == nil) then qcProgressComplete = {} end
	wipe(qcCollectedQuests)
	wipe(qcProgressComplete)
	print(string.format("%sCollected Cache Purged.",QCADDON_CHAT_TITLE))

end

function qcMenuMouseWheel(self, delta)

	local qcCurrentPosition = qcMenuSlider:GetValue()

	if (delta < 0) and (qcCurrentPosition < qcCurrentCategoryQuestCount) then
		qcMenuSlider:SetValue(qcCurrentPosition + 2)
	elseif (delta > 0) and (qcCurrentPosition > 1) then
		qcMenuSlider:SetValue(qcCurrentPosition - 2)
	end

end

local function qcProcessMenuAction(button, arg1)

	if (arg1 == "PERFORMSERVERQUERY") then
		print(string.format("%s%s",QCADDON_CHAT_TITLE,qcL.QUERYREQUESTED))
		qcQuestCompletistUI:RegisterEvent("QUEST_QUERY_COMPLETE")
		QueryQuestsCompleted()
		CloseDropDownMenus()
	elseif (arg1 == "CLEARUPDATECACHE") then
		print(string.format("%s%s",QCADDON_CHAT_TITLE,"Clearing your update Cache..."))
		qcClearUpdateCache()
		CloseDropDownMenus()
	elseif (arg1 == "SORTLEVEL") then
		qcSettings.SORT = 1
		qcQuestCompletistUI.qcSearchBox:SetText("")
		qcUpdateQuestList(qcCurrentCategoryID, qcMenuSlider:GetValue())
		CloseDropDownMenus()
	elseif (arg1 == "SORTALPHA") then
		qcSettings.SORT = 2
		qcQuestCompletistUI.qcSearchBox:SetText("")
		qcUpdateQuestList(qcCurrentCategoryID, qcMenuSlider:GetValue())
		CloseDropDownMenus()
	end

end

function qcCategoryDropdown_Initialize(self, level)

	local stringformat = string.format
	local qcMenuData = {}

	if (level == 1) then
		for qcMenuIndex, qcMenuEntry in ipairs(qcCategoryMenu) do
			if (qcMenuEntry[3]) then
				qcMenuData = {text=stringformat("   %s",qcMenuEntry[2]),isTitle=false,notCheckable=true,hasArrow=true,value=qcMenuEntry[1]}
			else
				qcMenuData = {text=qcMenuEntry[2],isTitle=true,notCheckable=true,hasArrow=false}
			end
			UIDropDownMenu_AddButton(qcMenuData, level)
		end
	elseif (level == 2) then
		local qcParentValue = UIDROPDOWNMENU_MENU_VALUE
		for qcMenuIndex, qcMenuEntry in ipairs(qcCategoryMenu) do
			if (qcMenuEntry[1] == qcParentValue) then
				for qcSubmenuIndex, qcSubmenuEntry in ipairs(qcMenuEntry[3]) do
					if (tonumber(qcSubmenuEntry[1])) then
						qcMenuData = {text=qcSubmenuEntry[2],isTitle=false,notCheckable=false,hasArrow=false,value=qcSubmenuEntry[1],arg1=qcSubmenuEntry[1],func=function(button,arg1) qcQuestCompletistUI.qcSearchBox:SetText("");qcUpdateQuestList(arg1,1);CloseDropDownMenus();end}
					else
						qcMenuData = {text=qcSubmenuEntry[2],isTitle=false,notCheckable=false,hasArrow=false,value=qcSubmenuEntry[1],arg1=qcSubmenuEntry[1],func=function(button,arg1) qcProcessMenuAction(button,arg1);end}
					end
					UIDropDownMenu_AddButton(qcMenuData, level)
				end
				break
			end
		end
	end

end

function qcCategoryDropdownButton_OnClick(self, button, down)

	ToggleDropDownMenu(1, nil, qcCategoryDropdownMenu, self:GetName(), 0, 0)

end

function qcCategoryDropdown_OnLoad(self)

	UIDropDownMenu_Initialize(self, qcCategoryDropdown_Initialize)

end

local function qcGetZoneIDFromName(zoneName)

	for qcZoneIndex, qcZone in ipairs(qcQuestCategories) do
		if (qcZone[2] == zoneName) then
			return qcZone[1]
		end
	end

	return nil

end

local function qcZoneChangedNewArea()

	--[[local qcZoneName
	SetMapToCurrentZone()
	if (GetCurrentMapContinent() > 0) then
		local qcCurrentContinentZones = {GetMapZones(GetCurrentMapContinent())}
		qcZoneName = qcCurrentContinentZones[GetCurrentMapZone()]
	else
		qcZoneName = GetRealZoneText()
	end

	local qcZoneID = qcGetZoneIDFromName(qcZoneName)
	if (qcZoneID ~= nil) then
		qcUpdateQuestList(qcZoneID, 1)
	end]]--

	SetMapToCurrentZone()
	local qcMapID = GetCurrentMapAreaID()
	if (qcAreaIDToCategoryID[qcMapID]) then
		qcUpdateQuestList(qcAreaIDToCategoryID[qcMapID],1)
	end

end

function qcUpdateTooltip(qcButtonIndex)

	local stringformat = string.format
	local qcQuestListRecord = _G["qcMenuButton" .. qcButtonIndex]
	local qcQuestID = qcQuestListRecord.QuestID

	if not (qcQuestID == nil) then
		qcQuestInformationTooltip:SetOwner(qcQuestCompletistUI,"ANCHOR_BOTTOMRIGHT",-30,500)
		qcQuestInformationTooltip:ClearLines()
		qcQuestInformationTooltip:SetHyperlink(stringformat("quest:%d",qcQuestID))
		qcQuestInformationTooltip:AddLine(" ")
		qcQuestInformationTooltip:AddDoubleLine("Quest ID:", stringformat("%s%d",COLOUR_MAGE,qcQuestID))
		if not (qcQuestDatabase[qcQuestID][13] == nil) then
			for qcInitiatorIndex, qcInitiatorEntry in pairs(qcQuestDatabase[qcQuestID][13]) do
				local qcInitiatorID = qcInitiatorEntry[1]
				local qcInitiatorName = qcInitiatorEntry[2]
				local qcInitiatorMapID = qcInitiatorEntry[3]
				local qcInitiatorMapLevel = qcInitiatorEntry[4]
				local qcInitiatorX = qcInitiatorEntry[5]
				local qcInitiatorY = qcInitiatorEntry[6]
				if not (qcInitiatorID == 0) then
					if not (qcInitiatorName == nil) then
						qcQuestInformationTooltip:AddDoubleLine("Quest Giver:", stringformat("%s%s [%d]",COLOUR_HUNTER,qcInitiatorName,qcInitiatorID))
					else
						qcQuestInformationTooltip:AddDoubleLine("Quest Giver:", stringformat("%s%s [%d]",COLOUR_HUNTER,"Self-provided Quest",qcInitiatorID))
					end
				else
					if not (qcInitiatorName == nil) then
						qcQuestInformationTooltip:AddDoubleLine("Quest Giver:", stringformat("%s%s",COLOUR_HUNTER,qcInitiatorName))
					else
						qcQuestInformationTooltip:AddDoubleLine("Quest Giver:", stringformat("%s%s",COLOUR_HUNTER,"Self-provided Quest"))
					end
				end
				if not (qcInitiatorMapLevel == 0) then
					qcQuestInformationTooltip:AddDoubleLine("  - Location:", stringformat("%s%s, Floor %d @ %.1f,%.1f",COLOUR_HUNTER,tostring(GetMapNameByID(qcInitiatorMapID) or nil),qcInitiatorMapLevel,qcInitiatorX,qcInitiatorY),nil,nil,nil,true)
				else
					qcQuestInformationTooltip:AddDoubleLine("  - Location:", stringformat("%s%s @ %.1f,%.1f",COLOUR_HUNTER,tostring(GetMapNameByID(qcInitiatorMapID) or nil),qcInitiatorX,qcInitiatorY),nil,nil,nil,true)
				end
			end
		end
		qcQuestInformationTooltip:Show()
		qcQuestReputationTooltip:SetOwner(qcQuestInformationTooltip,"ANCHOR_BOTTOMRIGHT",-qcQuestInformationTooltip:GetWidth())
		qcQuestReputationTooltip:ClearLines()
		if not (qcQuestDatabase[qcQuestID][12] == nil) then
			qcReputationCount = 0
			qcQuestReputationTooltip:AddLine(GetText("COMBAT_TEXT_SHOW_REPUTATION_TEXT"))
			qcQuestReputationTooltip:AddLine(" ")
			for qcReputationIndex, qcReputationEntry in pairs(qcQuestDatabase[qcQuestID][12]) do
				qcReputationCount = (qcReputationCount+1)
				qcQuestReputationTooltip:AddDoubleLine(tostring(qcFactions[qcReputationIndex] or qcReputationIndex), stringformat("%s%d rep",COLOUR_DRUID,qcReputationEntry))
			end
			if (qcReputationCount > 0) then
				qcQuestReputationTooltip:Show()
			else
				qcQuestReputationTooltip:Hide()
			end
		end
	else
		qcQuestReputationTooltip:Hide()
	end

end

function qcQuestClick(qcButtonIndex)

	local qcQuestListRecord = "qcMenuButton"
	local qcQuestID = _G[qcQuestListRecord .. qcButtonIndex].QuestID

	if (IsLeftShiftKeyDown() == nil) and (IsLeftAltKeyDown() == nil) then
		if IsAddOnLoaded('TomTom') then
			if not (qcQuestDatabase[qcQuestID][13] == nil) then
				for qcInitiatorIndex, qcInitiatorEntry in pairs(qcQuestDatabase[qcQuestID][13]) do
					TomTom:AddMFWaypoint(qcInitiatorEntry[3], qcInitiatorEntry[4], qcInitiatorEntry[5]/100, qcInitiatorEntry[6]/100, {title=qcInitiatorEntry[2]})
				end
			end
			TomTom:SetClosestWaypoint()
		end
	elseif (IsLeftShiftKeyDown() ~= nil) then --[[ User wants to toggle the completed status of a quest ]]--
		if (qcCompletedQuests[qcQuestID] == nil) then
			qcCompletedQuests[qcQuestID] = {["C"] = 1}
		else
			if (qcCompletedQuests[qcQuestID]["C"] == nil) then
				qcCompletedQuests[qcQuestID]["C"] = 1
			else
				if (qcCompletedQuests[qcQuestID]["C"] == 1) then
					qcCompletedQuests[qcQuestID]["C"] = 0
				elseif (qcCompletedQuests[qcQuestID]["C"] == 0) then
					qcCompletedQuests[qcQuestID]["C"] = 1
				elseif (qcCompletedQuests[qcQuestID]["C"] == 2) then
					qcCompletedQuests[qcQuestID]["C"] = 1
				end
			end
		end
	elseif (IsLeftAltKeyDown() ~= nil) then --[[ User wants to toggle the unattainable status of a quest ]]--
		if (qcCompletedQuests[qcQuestID] == nil) then
			qcCompletedQuests[qcQuestID] = {["C"] = 2}
		else
			if (qcCompletedQuests[qcQuestID]["C"] == nil) then
				qcCompletedQuests[qcQuestID]["C"] = 2
			else
				if (qcCompletedQuests[qcQuestID]["C"] == 2) then
					qcCompletedQuests[qcQuestID]["C"] = 0
				elseif (qcCompletedQuests[qcQuestID]["C"] == 0) then
					qcCompletedQuests[qcQuestID]["C"] = 2
				elseif (qcCompletedQuests[qcQuestID]["C"] == 1) then
					qcCompletedQuests[qcQuestID]["C"] = 2
				end
			end
		end
	end

	qcUpdateQuestList(nil, qcMenuSlider:GetValue())

end

function qcCloseTooltip()

	qcQuestInformationTooltip:Hide()
	qcQuestReputationTooltip:Hide()

end

local function qcUpdateCompletedQuest(qcQuestID)

	if not (qcQuestDatabase[qcQuestID] == nil) then
		if (qcQuestDatabase[qcQuestID][6] == 2) or (qcQuestDatabase[qcQuestID][6] == 3) then
			return nil
		end
	end
	if (qcCompletedQuests[qcQuestID] == nil) then qcCompletedQuests[qcQuestID] = {["C"]=1} end

end

local function qcNewDataChecks(qcQuestID)

	if ((qcQuestID == nil) or (qcQuestID == 0)) then return nil end

	if (qcQuestDatabase[qcQuestID] == nil) then
		qcNewDataAlert.New = true
		qcNewDataAlert.Faction = false
		qcNewDataAlert.Race = false
		qcNewDataAlert.Class = false
		qcNewDataAlert:Show()
	else
		qcNewDataAlert:Hide()
		qcNewDataAlert.New = false
		qcNewDataAlert.Faction = false
		qcNewDataAlert.Race = false
		qcNewDataAlert.Class = false
		local qcFaction, qcRace, qcClass = 0, 0, 0
		--[[ Faction Checks ]]--
		local qcEFaction, _S = UnitFactionGroup("player")
		qcFaction = qcFactionBits[string.upper(qcEFaction)]
		if (bit.band(qcFaction,qcQuestDatabase[qcQuestID][7]) == 0) then
			qcNewDataAlert.Faction = true
			print(QCADDON_CHAT_TITLE, "QC did not know this quest could be completed by your faction. Please read the How To Contribute file in the addon folder to help fix this.")
			qcNewDataAlert:Show()
		end
		--[[ Race ]]--
		local _S, qcERace = UnitRace("player")
		qcRace = qcRaceBits[string.upper(qcERace)]
		if (bit.band(qcRace,qcQuestDatabase[qcQuestID][8]) == 0) then
			qcNewDataAlert.Race = true
			print(QCADDON_CHAT_TITLE, "QC did not know this quest could be completed by your race. Please read the How To Contribute file in the addon folder to help fix this.")
			qcNewDataAlert:Show()
		end
		--[[ Class ]]--
		local _S, qcEClass = UnitClass("player")
		qcClass = qcClassBits[string.upper(qcEClass)]
		if (bit.band(qcClass,qcQuestDatabase[qcQuestID][9]) == 0) then
			qcNewDataAlert.Class = true
			print(QCADDON_CHAT_TITLE, "QC did not know this quest could be completed by your class. Please read the How To Contribute file in the addon folder to help fix this.")
			qcNewDataAlert:Show()
		end
	end

end

local function qcBreadcrumbChecks(qcQuestID)

	if (qcQuestID == nil) or (qcQuestID == 0) then return nil end

	if (qcBreadcrumbQuests[qcQuestID] == nil) then
		qcToast.QuestID = nil
		qcToast:Hide()
	else
		qcToast.QuestID = qcQuestID
		local qcCount = 0
		for qcBreadcrumbIndex, qcBreadcrumbEntry in pairs(qcBreadcrumbQuests[qcQuestID]) do
			if (qcCompletedQuests[qcBreadcrumbEntry] == nil) then
				qcCount = (qcCount + 1)
			else
				if not (qcCompletedQuests[qcBreadcrumbEntry]["C"] == 1) then
					qcCount = (qcCount + 1)
				end
			end
		end
		if (qcCount == 0) then
			qcToast.QuestID = nil
			qcToast:Hide()
		else
			if (qcCount == 1) then
				qcToastText:SetText("1 Breadcrumb Available!")
			else
				qcToastText:SetText(string.format("%d Breadcrumbs Available!",qcCount))
			end
			qcToast:Show()
		end
	end

end

local function qcMutuallyExclusiveChecks(qcQuestID)

	if (qcQuestID == nil) or (qcQuestID == 0) then return nil end

	if (qcMutuallyExclusive[qcQuestID] == nil) then
		qcMutuallyExclusiveAlert.QuestID = nil
		qcMutuallyExclusiveAlert:Hide()
	else
		qcMutuallyExclusiveAlert.QuestID = qcQuestID
		qcMutuallyExclusiveAlert:Show()
	end

end

function qcMapTooltipSetup()

local qcFrame = CreateFrame("GameTooltip", "qcMapTooltip", WorldMapDetailFrame, "GameTooltipTemplate")

	qcFrame:SetFrameStrata("TOOLTIP")
	qcMapTooltip = qcFrame
	--[[ Hook to allow scale changes with the world map ]]--
	WorldMapDetailFrame:HookScript("OnSizeChanged", function(self)
	qcMapTooltip:SetScale(1/self:GetScale())
	end)

end

function qcQuestReputationTooltipSetup()

local qcFrame = CreateFrame("GameTooltip", "qcQuestReputationTooltip", qcQuestCompletistUI, "GameTooltipTemplate")

	qcFrame:SetFrameStrata("TOOLTIP")
	qcQuestReputationTooltip = qcFrame

end

function qcQuestInformationTooltipSetup()

local qcFrame = CreateFrame("GameTooltip", "qcQuestInformationTooltip", qcQuestCompletistUI, "GameTooltipTemplate")

	qcFrame:SetFrameStrata("TOOLTIP")
	qcQuestInformationTooltip = qcFrame

end

function qcToastTooltipSetup()

local qcFrame = CreateFrame("GameTooltip", "qcToastTooltip", qcToast, "GameTooltipTemplate")

	qcFrame:SetFrameStrata("TOOLTIP")
	qcToastTooltip = qcFrame

end

function qcNewDataAlertTooltipSetup()

local qcFrame = CreateFrame("GameTooltip", "qcNewDataAlertTooltip", qcNewDataAlert, "GameTooltipTemplate")

	qcFrame:SetFrameStrata("TOOLTIP")
	qcNewDataAlertTooltip = qcFrame

end

function qcMutuallyExclusiveAlertTooltipSetup()

local qcFrame = CreateFrame("GameTooltip", "qcMutuallyExclusiveAlertTooltip", qcMutuallyExclusiveAlert, "GameTooltipTemplate")

	qcFrame:SetFrameStrata("TOOLTIP")
	qcMutuallyExclusiveAlertTooltip = qcFrame

end

function qcGetToastQuestInformation(qcQuestID)

	if (qcQuestID) then
		if not (qcQuestDatabase[qcQuestID] == nil) then
			local qcQuestName = tostring(qcQuestDatabase[qcQuestID][2] or nil)
			return qcQuestName
		end
	end

end

function qcToast_OnEnter(self)

	if (self.QuestID == nil) then
		qcToastTooltip:Hide()
	else
		qcToastTooltip:SetOwner(qcToast, "ANCHOR_CURSOR")
		qcToastTooltip:ClearLines()
		qcToastTooltip:AddLine("Breadcrumb Quests")
		for qcBreadcrumbIndex, qcBreadcrumbEntry in pairs(qcBreadcrumbQuests[self.QuestID]) do
			if (qcCompletedQuests[qcBreadcrumbEntry] == nil) then
				local qcQuestName = qcGetToastQuestInformation(qcBreadcrumbEntry)
				if (qcQuestName and qcBreadcrumbEntry) then qcToastTooltip:AddLine(tostring(COLOUR_DRUID .. qcQuestName .. COLOUR_MAGE .. " [" .. qcBreadcrumbEntry .. "]")) end
			else
				if not (qcCompletedQuests[qcBreadcrumbEntry]["C"] == 1) then
				local qcQuestName = qcGetToastQuestInformation(qcBreadcrumbEntry)
				if (qcQuestName and qcBreadcrumbEntry) then qcToastTooltip:AddLine(tostring(COLOUR_DRUID .. qcQuestName .. " [" .. qcBreadcrumbEntry .. "]")) end
				end
			end
		end
		qcToastTooltip:Show()
	end

end

function qcToast_OnLeave(self)

	qcToastTooltip:Hide()

end

function qcNewDataAlert_OnEnter(self)

	qcNewDataAlertTooltip:SetOwner(qcNewDataAlert, "ANCHOR_CURSOR")
	qcNewDataAlertTooltip:ClearLines()
	qcNewDataAlertTooltip:AddLine("Quest Completist")
	qcNewDataAlertTooltip:AddLine(COLOUR_HUNTER .. "Quest Completist was not aware of the following information. Please help improve the addon by reading the 'How To Contribute' file in the addon folder, and submitting your saved variable data.", nil, nil, nil, true)
	if (qcNewDataAlert.New == true) then
		qcNewDataAlertTooltip:AddLine(COLOUR_MAGE .. " - Quest does not exist in the database.", nil, nil, nil, true)
		qcNewDataAlertTooltip:Show()
	end
	if (qcNewDataAlert.Faction == true) then
		qcNewDataAlertTooltip:AddLine(COLOUR_MAGE .. " - QC was not aware your FACTION could complete this quest.", nil, nil, nil, true)
		qcNewDataAlertTooltip:Show()
	end
	if (qcNewDataAlert.Race == true) then
		qcNewDataAlertTooltip:AddLine(COLOUR_MAGE .. " - QC was not aware your RACE could complete this quest.", nil, nil, nil, true)
		qcNewDataAlertTooltip:Show()
	end
	if (qcNewDataAlert.Class == true) then
		qcNewDataAlertTooltip:AddLine(COLOUR_MAGE .. " - QC was not aware your CLASS could complete this quest.", nil, nil, nil, true)
		qcNewDataAlertTooltip:Show()
	end

end

function qcNewDataAlert_OnLeave(self)

	qcNewDataAlertTooltip:Hide()

end

function qcMutuallyExclusiveQuestInformation(qcQuestID)

	if (qcQuestID) then
		if (qcQuestDatabase[qcQuestID]) then
			local qcQuestName = tostring(qcQuestDatabase[qcQuestID][2] or nil)
			return qcQuestName
		end
	end

	return nil

end

function qcMutuallyExclusiveAlert_OnEnter(self)

	if (self.QuestID == nil) then
		qcMutuallyExclusiveAlertTooltip:Hide()
	else
		qcMutuallyExclusiveAlertTooltip:SetOwner(qcMutuallyExclusiveAlert, "ANCHOR_BOTTOMRIGHT")
		qcMutuallyExclusiveAlertTooltip:ClearLines()
		qcMutuallyExclusiveAlertTooltip:AddLine("Quest Completist")
		qcMutuallyExclusiveAlertTooltip:AddLine(COLOUR_MAGE .. "This quest is mutually exclusive with others, meaning you can only complete one of them. The other quests are:", nil, nil, nil, true)
		for qcMutuallyExclusiveIndex, qcMutuallyExclusiveEntry in pairs(qcMutuallyExclusive[self.QuestID]) do
			if (qcQuestDatabase[qcMutuallyExclusiveEntry] == nil) then
				qcMutuallyExclusiveAlertTooltip:AddLine(string.format("%s<Quest Not Found In DB> [%d]|r",COLOUR_DRUID,qcMutuallyExclusiveEntry))
			else
				local qcQuestName = qcMutuallyExclusiveQuestInformation(qcMutuallyExclusiveEntry)
				if (qcQuestName and qcMutuallyExclusiveEntry) then qcMutuallyExclusiveAlertTooltip:AddLine(string.format("%s%s [%d]|r",COLOUR_DRUID,qcQuestName,qcMutuallyExclusiveEntry)) end
			end
		end
		qcMutuallyExclusiveAlertTooltip:Show()
	end
end

function qcMutuallyExclusiveAlert_OnLeave(self)

	qcMutuallyExclusiveAlertTooltip:Hide()

end

local function qcPreparePin(qcQuestType, qcQuestID, qcQuestName)

local qcNewPin

	if (#qcSparePins > 0) then
		qcNewPin = qcSparePins[1]
		table.remove(qcSparePins, 1)
		--print("Reusing pin: " .. tostring(qcNewPin))
	end

	if (not qcNewPin) then
		qcNewPin = CreateFrame("Frame", nil, WorldMapDetailFrame)
		qcNewPin.Texture = qcNewPin:CreateTexture()

		--[[ Tooltip Hooks ]]--
		qcNewPin:HookScript("OnEnter", function(self)
		qcMapTooltip:SetOwner(self, "ANCHOR_RIGHT")
		qcMapTooltip:ClearLines()
		if (self.QuestID ~= nil) then qcMapTooltip:SetHyperlink("quest:" .. self.QuestID) end
		qcMapTooltip:AddLine(" ")
		qcMapTooltip:AppendText(" [" .. (self.QuestID or "ID_ERROR") .. "]")
		if (self.QuestID ~= nil) and (qcQuestDBv2[self.QuestID][3][2] ~= nil) and (qcQuestDBv2[self.QuestID][3][1] ~= nil) then qcMapTooltip:AddDoubleLine("Starts from:", tostring(COLOUR_DRUID .. qcQuestDBv2[self.QuestID][3][2] .. " [" .. qcQuestDBv2[self.QuestID][3][1]  .. "]")) end
		if (self.QuestID ~= nil) and (qcQuestDBv2[self.QuestID][1][4] ~= nil) then qcMapTooltip:AddDoubleLine("Category:", tostring(COLOUR_DRUID .. qcQuestDBv2[self.QuestID][1][4])) end
		if (self.QuestID ~= nil) and (qcQuestDBv2[self.QuestID][5][1] ~= nil) then qcMapTooltip:AddLine(COLOUR_HUNTER .. (qcQuestDBv2[self.QuestID][5][1] or ""), nil, nil, nil, true) end
		qcMapTooltip:AddLine(COLOUR_MAGE .. "Please report errors to me on Curse.com")
		qcMapTooltip:Show()
		end)
		qcNewPin:HookScript("OnLeave", function(self)
		qcMapTooltip:ClearLines()
		qcMapTooltip:Hide()
		end)

		qcNewPin.Texture:SetTexture("Interface\\Addons\\QuestCompletist\\Images\\QCIcons")
		if (qcQuestType == 3) then --[[ Daily ]]--
			qcNewPin.Texture:SetTexCoord(0,0.125,0.25,0.5)
			qcNewPin.Texture:SetAllPoints()
			qcNewPin:SetWidth(16)
			qcNewPin:SetHeight(16)
			qcNewPin:EnableMouse(true)
		elseif (qcQuestType == 2) then --[[ Repeatable ]]--
			qcNewPin.Texture:SetTexCoord(0.125,0.25,0.25,0.5)
			qcNewPin.Texture:SetAllPoints()
			qcNewPin:SetWidth(16)
			qcNewPin:SetHeight(16)
			qcNewPin:EnableMouse(true)
		else
			qcNewPin.Texture:SetTexCoord(0,0.125,0,0.25)
			qcNewPin.Texture:SetAllPoints()
			qcNewPin:SetWidth(16)
			qcNewPin:SetHeight(16)
			qcNewPin:EnableMouse(true)
		end
		table.insert(qcPins, qcNewPin)
	else
		qcNewPin.Texture:SetTexture("Interface\\Addons\\QuestCompletist\\Images\\QCIcons")
		if (qcQuestType == 3) then --[[ Daily ]]--
			qcNewPin.Texture:SetTexCoord(0,0.125,0.25,0.5)
			qcNewPin.Texture:SetAllPoints()
			qcNewPin:SetWidth(16)
			qcNewPin:SetHeight(16)
			qcNewPin:EnableMouse(true)
		elseif (qcQuestType == 2) then --[[ Repeatable ]]--
			qcNewPin.Texture:SetTexCoord(0.125,0.25,0.25,0.5)
			qcNewPin.Texture:SetAllPoints()
			qcNewPin:SetWidth(16)
			qcNewPin:SetHeight(16)
			qcNewPin:EnableMouse(true)
		else
			qcNewPin.Texture:SetTexCoord(0,0.125,0,0.25)
			qcNewPin.Texture:SetAllPoints()
			qcNewPin:SetWidth(16)
			qcNewPin:SetHeight(16)
			qcNewPin:EnableMouse(true)
		end
		qcNewPin.QuestID = qcQuestID
		qcNewPin.QuestName = qcQuestName
		table.insert(qcPins, qcNewPin)
	end

	return qcNewPin

end

local function qcShowPin(x, y, qcQuestType, qcQuestID, qcQuestName)

local qcPin = qcPreparePin(qcQuestType, qcQuestID, qcQuestName)

	qcPin:ClearAllPoints()
	qcPin:SetFrameLevel(WorldMapPOIFrame:GetFrameLevel()-1)
	qcPin:SetPoint("CENTER", WorldMapDetailFrame, "TOPLEFT", (x/100)*WorldMapDetailFrame:GetWidth(), (-y/100)*WorldMapDetailFrame:GetHeight())
	qcPin:Show()

end

local function qcHidePin(qcPinID, qcEntry)

	if (qcPinID) then
		qcEntry:Hide()
		table.insert(qcSparePins, qcEntry)
		table.remove(qcPins, qcPinID)
	end

end

local function qcHideAllPins()

	for qcIndex = #qcPins, 1, -1 do
		qcHidePin(qcIndex, qcPins[qcIndex])
	end

end

local function qcRefreshPins(qcMapID)

	qcHideAllPins()
	wipe(qcMapQuests)

	if (qcSettings["QC_M_SHOW_ICONS"] == 0) then
		return nil
	end

	--[[ Pull all quests related to this map from the database ]]--
	for qcIndex, qcEntry in pairs(qcQuestDBv2) do
		if (qcEntry[3][6] == qcMapID) then
			if (qcEntry[3][8] == 0) then
				table.insert(qcMapQuests, qcEntry)
			end
		end
	end

	--[[ Completed filtering - regardless of user filtering options ]]--
	for qcMapQuestsIndex = #qcMapQuests, 1, -1 do
		if (qcCompletedQuests[qcMapQuests[qcMapQuestsIndex][1][1]] ~= nil) then
			if (qcCompletedQuests[qcMapQuests[qcMapQuestsIndex][1][1]]["C"] == 1) or (qcCompletedQuests[qcMapQuests[qcMapQuestsIndex][1][1]]["C"] == 2) then
				if (qcMapQuests[qcMapQuestsIndex][1][5] == 1) or (qcMapQuests[qcMapQuestsIndex][1][5] == 4) then --[[ Normal quest or special quest ]]--
					--print("Removing completed quest: " .. qcMapQuests[qcMapQuestsIndex][1][2])
					table.remove(qcMapQuests, qcMapQuestsIndex)
				end
			end
		end
	end

	--[[ Faction filtering - regardless of user filtering options ]]--
	do
		local qcCurrentPlayerFaction, _S = UnitFactionGroup("player")
		local qcCurrentFaction = qcFactionBits[string.upper(qcCurrentPlayerFaction)]
		for qcMapQuestsIndex = #qcMapQuests, 1, -1 do
			if (bit.band(qcMapQuests[qcMapQuestsIndex][4][1], qcCurrentFaction) == 0) then
				--print("Removing opposing faction quest: " .. qcMapQuests[qcMapQuestsIndex][1][2])
				table.remove(qcMapQuests, qcMapQuestsIndex)
			end
		end
	end

	--[[ Class\Race filtering - regardless of user filtering options ]]--
	do
		local _S, qcCurrentPlayerClass = UnitClass("player")
		local qcCurrentClass = qcClassBits[string.upper(qcCurrentPlayerClass)]
		local _S, qcCurrentPlayerRace = UnitRace("player")
		local qcCurrentRace = qcRaceBits[string.upper(qcCurrentPlayerRace)]
		for qcMapQuestsIndex = #qcMapQuests, 1, -1 do
			if (bit.band(qcMapQuests[qcMapQuestsIndex][4][3], qcCurrentClass) == 0) then
				--print("Removing other class quest.")
				table.remove(qcMapQuests, qcMapQuestsIndex)
			elseif (bit.band(qcMapQuests[qcMapQuestsIndex][4][2], qcCurrentRace) == 0) then
				--print("Removing other races quest.")
				table.remove(qcMapQuests, qcMapQuestsIndex)
			end
		end
	end

	--[[ Add pins to the map ]]--
	do
		for qcMapQuestsIndex = #qcMapQuests, 1, -1 do
			--print("Creating pin to show incomplete quest: " .. qcMapQuests[qcMapQuestsIndex][1][2])
			qcShowPin(qcMapQuests[qcMapQuestsIndex][3][4], qcMapQuests[qcMapQuestsIndex][3][5], qcMapQuests[qcMapQuestsIndex][1][5], qcMapQuests[qcMapQuestsIndex][1][1], qcMapQuests[qcMapQuestsIndex][1][2])
		end
	end

end

--[[ ##### MAP ICONS START ##### ]]--

local function qcColouredQuestName(qcQuestID)

	if not (qcQuestID) then return nil end
	if (qcQuestDatabase[qcQuestID] == nil) then return nil end

	--[[ Order by most likely first, always leaving completed until the end ]]--
	if (qcQuestDatabase[qcQuestID][6] == 3) then
		return string.format("|cff178ed5%s|r",qcQuestDatabase[qcQuestID][2])
	elseif (qcQuestDatabase[qcQuestID][6] == 2) then
		return string.format("|cff178ed5%s|r",qcQuestDatabase[qcQuestID][2])
	elseif (qcCompletedQuests[qcQuestID] == nil) then
		return string.format("|cffffffff%s|r",qcQuestDatabase[qcQuestID][2])
	elseif (qcCompletedQuests[qcQuestID]["C"] == 1) or (qcCompletedQuests[qcQuestID]["C"] == 2) then
		return string.format("|cff00ff00%s|r",qcQuestDatabase[qcQuestID][2])
	else --[[ Not handled ]]--
		return nil
	end

end

local function qcPrepareIcon(qcIconType)

	local qcNewIcon = nil
	local tableinsert = table.insert
	local tostring = tostring
	local stringformat = string.format

	if (#qcSpareMapIcons > 0) then
		qcNewIcon = qcSpareMapIcons[1]
		table.remove(qcSpareMapIcons, 1)
	end

	if not (qcNewIcon) then
		qcNewIcon = CreateFrame("Frame", "qcIcon", WorldMapDetailFrame)
		qcNewIcon:SetWidth(16)
		qcNewIcon:SetHeight(16)
		qcNewIcon.Texture = qcNewIcon:CreateTexture()
		qcNewIcon.Texture:SetTexture("Interface\\Addons\\QuestCompletist\\Images\\QCIcons")
		qcNewIcon.Texture:SetAllPoints()
		qcNewIcon:EnableMouse(true)

		--[[ Tooltip Hooks ]]--
		qcNewIcon:HookScript("OnEnter", function(self, motion)
		local qcFrames = {}
		local qcFrame = EnumerateFrames()
		while (qcFrame) do
			if (qcFrame:IsVisible() and MouseIsOver(qcFrame) and (qcFrame:GetName() == "qcIcon")) then
				tableinsert(qcFrames, qcFrame)
			end
			qcFrame = EnumerateFrames(qcFrame)
		end
		qcMapTooltip:SetOwner(self, "ANCHOR_RIGHT")
		qcMapTooltip:ClearLines()
		for qcFrameIndex, qcFrameEntry in pairs(qcFrames) do -- Possible ipairs?
			local qcInitiatorsIndex = qcFrameEntry.InitiatorsIndex
			if (qcCurrentMapInitiators[qcInitiatorsIndex][3] == 0) then
				qcMapTooltip:AddLine(qcCurrentMapInitiators[qcInitiatorsIndex][4] or stringformat("%s %s",UnitName("player"),"|cff69ccf0<Yourself>|r"))
			else
				qcMapTooltip:AddDoubleLine(qcCurrentMapInitiators[qcInitiatorsIndex][4] or stringformat("%s %s",UnitName("player"),"|cff69ccf0<Yourself>|r"), stringformat("|cffff7d0a[%d]|r",qcCurrentMapInitiators[qcInitiatorsIndex][3]))
			end
			for qcIndex, qcEntry in ipairs(qcCurrentMapInitiators[qcInitiatorsIndex][7]) do
				qcMapTooltip:AddDoubleLine(tostring(qcColouredQuestName(qcEntry)), stringformat("|cffff7d0a[%d]|r",tostring(qcEntry)))
				if (#qcCurrentMapInitiators[qcInitiatorsIndex][7] <= 10) then
					--[[ Order by most likely first, always leaving completed until the end ]]--
					--[[ TODO: Create a texture object and use in-game texture with SetTexCoord ]]--
					if (qcQuestDatabase[qcEntry]) then
						if (qcQuestDatabase[qcEntry][6] == 3) then
							qcMapTooltip:AddTexture("Interface\\Addons\\QuestCompletist\\Images\\DailyQuestIcon")
						elseif (qcQuestDatabase[qcEntry][6] == 2) then
							qcMapTooltip:AddTexture("Interface\\Addons\\QuestCompletist\\Images\\DailyActiveQuestIcon")
						elseif (qcCompletedQuests[qcEntry] ~= nil) and (qcCompletedQuests[qcEntry]["C"] == 1 or qcCompletedQuests[qcEntry]["C"] == 2) then
							qcMapTooltip:AddTexture("Interface\\Addons\\QuestCompletist\\Images\\QuestCompleteIcon")
						else
							qcMapTooltip:AddTexture("Interface\\Addons\\QuestCompletist\\Images\\AvailableQuestIcon")
						end
					end
				end
			end
			if (qcCurrentMapInitiators[qcInitiatorsIndex][8]) then
				qcMapTooltip:AddLine(stringformat("|cffabd473%s|r",qcCurrentMapInitiators[qcInitiatorsIndex][8]),nil,nil,nil,true)
			end
		end
		qcMapTooltip:Show()
		end)
		qcNewIcon:HookScript("OnLeave", function(self)
		qcMapTooltip:Hide()
		end)

		if (qcIconType == 1) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_NORMAL))
		elseif (qcIconType == 3) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_DAILY))
		elseif (qcIconType == 2) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_REPEATABLE))
		elseif (qcIconType == 5) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_SEASONAL))
		elseif (qcIconType == 6) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_PROFESSION))
		elseif (qcIconType == 7) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_ITEMDROPSTANDARD))
		elseif (qcIconType == 8) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_ITEMDROPREPEATABLE))
		elseif (qcIconType == 9) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_CLASS))
		elseif (qcIconType == 10) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_KILL))
		else
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_NORMAL))
		end
	else
		if (qcIconType == 1) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_NORMAL))
		elseif (qcIconType == 3) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_DAILY))
		elseif (qcIconType == 2) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_REPEATABLE))
		elseif (qcIconType == 5) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_SEASONAL))
		elseif (qcIconType == 6) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_PROFESSION))
		elseif (qcIconType == 7) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_ITEMDROPSTANDARD))
		elseif (qcIconType == 8) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_ITEMDROPREPEATABLE))
		elseif (qcIconType == 9) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_CLASS))
		elseif (qcIconType == 10) then
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_KILL))
		else
			qcNewIcon.Texture:SetTexCoord(unpack(QC_ICON_COORDS_NORMAL))
		end
	end
	
	tableinsert(qcCurrentMapIcons, qcNewIcon)
	return qcNewIcon

end

local function qcShowIcon(qcCurrentMapInitiatorsIndex, qcX, qcY, qcIconType)

	local qcIcon = qcPrepareIcon(qcIconType)

	qcIcon:SetFrameLevel(WorldMapPOIFrame:GetFrameLevel()-1)
	qcIcon:SetPoint("CENTER", WorldMapDetailFrame, "TOPLEFT", (qcX/100)*WorldMapDetailFrame:GetWidth(), (-qcY/100)*WorldMapDetailFrame:GetHeight())
	qcIcon.InitiatorsIndex = qcCurrentMapInitiatorsIndex
	qcIcon:Show()

end

local function qcHideAllMapIcons()

	local tableinsert = table.insert
	local tableremove = table.remove

	for qcIndex = #qcCurrentMapIcons, 1, -1 do
		qcCurrentMapIcons[qcIndex]:Hide()
		tableinsert(qcSpareMapIcons, qcCurrentMapIcons[qcIndex])
		tableremove(qcCurrentMapIcons, qcIndex)
	end

end

local function qcRefreshMapIcons(qcMapID, qcMapLevel)

	qcHideAllMapIcons()
	wipe(qcCurrentMapInitiators)

	if (qcSettings["QC_M_SHOW_ICONS"] == 0) then return nil end
	if not (qcMapIcon[qcMapID]) then return nil end

	local tableremove = table.remove
	local bitband = bit.band

	qcCurrentMapInitiators = qcCopyTable(qcMapIcon[qcMapID])

	--[[ Map level ]]--
	for qcCurrentMapInitiatorsIndex = #qcCurrentMapInitiators, 1, -1 do
		if not (qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][1] == qcMapLevel) then
			tableremove(qcCurrentMapInitiators, qcCurrentMapInitiatorsIndex)
		end
	end

	--[[ Low level quests ]]--
	if (qcSettings["QC_M_HIDE_LOWLEVEL"] == 1) then
		for qcCurrentMapInitiatorsIndex = #qcCurrentMapInitiators, 1, -1 do
			for qcQuestIndex = #qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], 1, -1 do
				local qcQuestID = qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7][qcQuestIndex]
				if (qcQuestDatabase[qcQuestID]) then
					local qcQuestLevel = qcQuestDatabase[qcQuestID][3] or 0 -- Account for -1 quests???
					local qcQuestCutoff = (UnitLevel("player") - GetQuestGreenRange())
					if (qcQuestLevel < qcQuestCutoff) then
						tableremove(qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], qcQuestIndex)
					end
				else
					tableremove(qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], qcQuestIndex)
				end
			end
			if (#qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7] == 0) then
				tableremove(qcCurrentMapInitiators, qcCurrentMapInitiatorsIndex)
			end
		end
	end

	--[[ Completed quests ]]--
	if (qcSettings["QC_M_HIDE_COMPLETED"] == 1) then
		for qcCurrentMapInitiatorsIndex = #qcCurrentMapInitiators, 1, -1 do
			for qcQuestIndex = #qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], 1, -1 do
				local qcQuestID = qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7][qcQuestIndex]
				if (qcCompletedQuests[qcQuestID]) and ((qcCompletedQuests[qcQuestID]["C"] == 1) or (qcCompletedQuests[qcQuestID]["C"] == 2)) then
					tableremove(qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], qcQuestIndex)
				end
			end
			if (#qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7] == 0) then
				tableremove(qcCurrentMapInitiators, qcCurrentMapInitiatorsIndex)
			end
		end
	end

	--[[ Faction ]]--
	if (qcSettings["QC_ML_HIDE_FACTION"] == 1) then
		for qcCurrentMapInitiatorsIndex = #qcCurrentMapInitiators, 1, -1 do
			for qcQuestIndex = #qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], 1, -1 do
				local qcQuestID = qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7][qcQuestIndex]
				local qcCurrentPlayerFaction, _S = UnitFactionGroup("player")
				local qcCurrentFaction = qcFactionBits[string.upper(qcCurrentPlayerFaction)]
				if (qcQuestDatabase[qcQuestID]) and (bitband(qcQuestDatabase[qcQuestID][7], qcCurrentFaction) == 0) then
					tableremove(qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], qcQuestIndex)
				end
			end
			if (#qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7] == 0) then
				tableremove(qcCurrentMapInitiators, qcCurrentMapInitiatorsIndex)
			end
		end
	end

	--[[ Race\Class ]]--
	if (qcSettings["QC_ML_HIDE_RACECLASS"] == 1) then
		for qcCurrentMapInitiatorsIndex = #qcCurrentMapInitiators, 1, -1 do
			for qcQuestIndex = #qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], 1, -1 do
				local qcQuestID = qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7][qcQuestIndex]
				local _S, qcCurrentPlayerRace = UnitRace("player")
				local qcCurrentRace = qcRaceBits[string.upper(qcCurrentPlayerRace)]
				local _S, qcCurrentPlayerClass = UnitClass("player")
				local qcCurrentClass = qcClassBits[string.upper(qcCurrentPlayerClass)]
				if (qcQuestDatabase[qcQuestID]) and (bitband(qcQuestDatabase[qcQuestID][8], qcCurrentRace) == 0) then
					tableremove(qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], qcQuestIndex)
				elseif (qcQuestDatabase[qcQuestID]) and (bitband(qcQuestDatabase[qcQuestID][9], qcCurrentClass) == 0) then
					tableremove(qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], qcQuestIndex)
				end
			end
			if (#qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7] == 0) then
				tableremove(qcCurrentMapInitiators, qcCurrentMapInitiatorsIndex)
			end
		end
	end

	--[[ Seasonal ]]--
	if (qcSettings["QC_M_HIDE_SEASONAL"] == 1) then
		local qcToday = date("%y%m%d")
		for qcCurrentMapInitiatorsIndex = #qcCurrentMapInitiators, 1, -1 do
			for qcQuestIndex = #qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], 1, -1 do
				local qcQuestID = qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7][qcQuestIndex]
				if (qcQuestDatabase[qcQuestID]) and (qcQuestDatabase[qcQuestID][11] > 0) then
					if not ((qcToday >= qcHolidayDates[qcQuestDatabase[qcQuestID][11]][1]) and (qcToday <= qcHolidayDates[qcQuestDatabase[qcQuestID][11]][2])) then
						tableremove(qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], qcQuestIndex)
					end
				end
			end
			if (#qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7] == 0) then
				tableremove(qcCurrentMapInitiators, qcCurrentMapInitiatorsIndex)
			end
		end
	end

	--[[ Professions ]]--
	if (qcSettings["QC_M_HIDE_PROFESSION"] == 1) then
		local qcProfessionBitwise = 0
		local qcProfessions = {GetProfessions()}
		for qcIndex, qcEntry in pairs(qcProfessions) do
			local qcName, qcTexture, _S, _S, _S, _S, qcProfessionID, _S = GetProfessionInfo(qcEntry)
			qcProfessionBitwise = (qcProfessionBitwise + qcProfessionBits[qcProfessionID])
		end
		for qcCurrentMapInitiatorsIndex = #qcCurrentMapInitiators, 1, -1 do
			for qcQuestIndex = #qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], 1, -1 do
				local qcQuestID = qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7][qcQuestIndex]
				if (qcQuestDatabase[qcQuestID]) and (qcQuestDatabase[qcQuestID][10] > 0) then
					if (bitband(qcQuestDatabase[qcQuestID][10], qcProfessionBitwise) == 0) then
						tableremove(qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], qcQuestIndex)
					end
				end
			end
			if (#qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7] == 0) then
				tableremove(qcCurrentMapInitiators, qcCurrentMapInitiatorsIndex)
			end
		end
	end

	--[[ In progress ]]--
	if (qcSettings["QC_M_HIDE_INPROGRESS"] == 1) then
		for qcCurrentMapInitiatorsIndex = #qcCurrentMapInitiators, 1, -1 do
			for qcQuestIndex = #qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], 1, -1 do
				local qcQuestID = qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7][qcQuestIndex]
				if (GetQuestLogIndexByID(qcQuestID) ~= 0) then
					tableremove(qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7], qcQuestIndex)
				end
			end
			if (#qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7] == 0) then
				tableremove(qcCurrentMapInitiators, qcCurrentMapInitiatorsIndex)
			end
		end
	end

	--[[ Empty quest sub-tables ]]--
	for qcCurrentMapInitiatorsIndex = #qcCurrentMapInitiators, 1, -1 do
		if (#qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7] == 0) then
			tableremove(qcCurrentMapInitiators, qcCurrentMapInitiatorsIndex)
		end
	end

	--[[ Check if only 1 quest remains for each initiator, and customize icon for that final quest ]]--
	for qcCurrentMapInitiatorsIndex = #qcCurrentMapInitiators, 1, -1 do
		local qcIconType = qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][2]
		if (#qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7] == 1) then
			local qcQuestID = qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][7][1]
			if ((qcQuestDatabase[qcQuestID]) and (qcIconType == 1)) then
				if (qcQuestDatabase[qcQuestID][6] == 1) then
					qcIconType = 1
				elseif (qcQuestDatabase[qcQuestID][6] == 3) then
					qcIconType = 3
				elseif (qcQuestDatabase[qcQuestID][6] == 2) then
					qcIconType = 2
				end
			end
		end
		qcShowIcon(qcCurrentMapInitiatorsIndex, qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][5], qcCurrentMapInitiators[qcCurrentMapInitiatorsIndex][6], qcIconType)
	end

end

--[[ ##### MAP ICONS END ##### ]]--

--[[ ##### INTERFACE OPTIONS START ##### ]]--

function qcInterfaceOptions_Okay(self)

	qcUpdateQuestList(qcCurrentCategoryID, 1)
	qcRefreshMapIcons(GetCurrentMapAreaID(), GetCurrentMapDungeonLevel())

end

function qcInterfaceOptions_Cancel(self)

end

function qcInterfaceOptions_OnShow(self)

	-- CreateFrame("frameType" [, "name" [, parent [, "template"]]])

	local qcL = qcLocalize

    qcConfigTitle = self:CreateFontString("qcConfigTitle", "ARTWORK", "GameFontNormalLarge")
    qcConfigTitle:SetPoint("TOPLEFT", 16, -16)
    qcConfigTitle:SetText(qcL.CONFIGTITLE)

    qcConfigSubtitle = self:CreateFontString("qcConfigSubtitle", "ARTWORK", "GameFontHighlightSmall")
    qcConfigSubtitle:SetHeight(22)
    qcConfigSubtitle:SetPoint("TOPLEFT", qcConfigTitle, "BOTTOMLEFT", 0, -8)
    qcConfigSubtitle:SetPoint("RIGHT", self, -32, 0)
    qcConfigSubtitle:SetNonSpaceWrap(true)
    qcConfigSubtitle:SetJustifyH("LEFT")
    qcConfigSubtitle:SetJustifyV("TOP")
    qcConfigSubtitle:SetText(qcL.CONFIGSUBTITLE)

    qcMapFiltersTitle = self:CreateFontString("qcMapFiltersTitle", "ARTWORK", "GameFontNormal")
    qcMapFiltersTitle:SetPoint("TOPLEFT", qcConfigSubtitle, "BOTTOMLEFT", 16, -4)
    qcMapFiltersTitle:SetText(qcL.MAPFILTERS)

	qcIO_M_SHOW_ICONS = CreateFrame("CheckButton", "qcIO_M_SHOW_ICONS", self, "InterfaceOptionsCheckButtonTemplate")
    qcIO_M_SHOW_ICONS:SetPoint("TOPLEFT", qcMapFiltersTitle, "BOTTOMLEFT", 16, -6)
	_G[qcIO_M_SHOW_ICONS:GetName().."Text"]:SetText(qcL.SHOWMAPICONS)
	qcIO_M_SHOW_ICONS:SetScript("OnClick", function(self)
		if (qcIO_M_SHOW_ICONS:GetChecked() == nil) then
			qcSettings.QC_M_SHOW_ICONS = 0
		else
			qcSettings.QC_M_SHOW_ICONS = 1
		end
	end)

	qcIO_M_HIDE_COMPLETED = CreateFrame("CheckButton", "qcIO_M_HIDE_COMPLETED", self, "InterfaceOptionsCheckButtonTemplate")
    qcIO_M_HIDE_COMPLETED:SetPoint("TOPLEFT", qcIO_M_SHOW_ICONS, "BOTTOMLEFT", 0, 0)
	_G[qcIO_M_HIDE_COMPLETED:GetName().."Text"]:SetText(qcL.HIDECOMPLETEDQUESTS)
	qcIO_M_HIDE_COMPLETED:SetScript("OnClick", function(self)
		if (qcIO_M_HIDE_COMPLETED:GetChecked() == nil) then
			qcSettings.QC_M_HIDE_COMPLETED = 0
		else
			qcSettings.QC_M_HIDE_COMPLETED = 1
		end
	end)

	qcIO_M_HIDE_LOWLEVEL = CreateFrame("CheckButton", "qcIO_M_HIDE_LOWLEVEL", self, "InterfaceOptionsCheckButtonTemplate")
    qcIO_M_HIDE_LOWLEVEL:SetPoint("TOPLEFT", qcIO_M_HIDE_COMPLETED, "BOTTOMLEFT", 0, 0)
	_G[qcIO_M_HIDE_LOWLEVEL:GetName().."Text"]:SetText(qcL.HIDELOWLEVELQUESTS)
	qcIO_M_HIDE_LOWLEVEL:SetScript("OnClick", function(self)
		if (qcIO_M_HIDE_LOWLEVEL:GetChecked() == nil) then
			qcSettings.QC_M_HIDE_LOWLEVEL = 0
		else
			qcSettings.QC_M_HIDE_LOWLEVEL = 1
		end
	end)

	qcIO_M_HIDE_PROFESSION = CreateFrame("CheckButton", "qcIO_M_HIDE_PROFESSION", self, "InterfaceOptionsCheckButtonTemplate")
    qcIO_M_HIDE_PROFESSION:SetPoint("TOPLEFT", qcIO_M_HIDE_LOWLEVEL, "BOTTOMLEFT", 0, 0)
	_G[qcIO_M_HIDE_PROFESSION:GetName().."Text"]:SetText(qcL.HIDEOTHERPROFESSIONQUESTS)
	qcIO_M_HIDE_PROFESSION:SetScript("OnClick", function(self)
		if (qcIO_M_HIDE_PROFESSION:GetChecked() == nil) then
			qcSettings.QC_M_HIDE_PROFESSION = 0
		else
			qcSettings.QC_M_HIDE_PROFESSION = 1
		end
	end)

	qcIO_M_HIDE_SEASONAL = CreateFrame("CheckButton", "qcIO_M_HIDE_SEASONAL", self, "InterfaceOptionsCheckButtonTemplate")
    qcIO_M_HIDE_SEASONAL:SetPoint("TOPLEFT", qcIO_M_HIDE_PROFESSION, "BOTTOMLEFT", 0, 0)
	_G[qcIO_M_HIDE_SEASONAL:GetName().."Text"]:SetText(qcL.HIDENONACTIVESEASONALQUESTS)
	qcIO_M_HIDE_SEASONAL:SetScript("OnClick", function(self)
		if (qcIO_M_HIDE_SEASONAL:GetChecked() == nil) then
			qcSettings.QC_M_HIDE_SEASONAL = 0
		else
			qcSettings.QC_M_HIDE_SEASONAL = 1
		end
	end)

	qcIO_M_HIDE_INPROGRESS = CreateFrame("CheckButton", "qcIO_M_HIDE_INPROGRESS", self, "InterfaceOptionsCheckButtonTemplate")
    qcIO_M_HIDE_INPROGRESS:SetPoint("TOPLEFT", qcIO_M_HIDE_SEASONAL, "BOTTOMLEFT", 0, 0)
	_G[qcIO_M_HIDE_INPROGRESS:GetName().."Text"]:SetText(qcL.HIDEINPROGRESSQUESTS)
	qcIO_M_HIDE_INPROGRESS:SetScript("OnClick", function(self)
		if (qcIO_M_HIDE_INPROGRESS:GetChecked() == nil) then
			qcSettings.QC_M_HIDE_INPROGRESS = 0
		else
			qcSettings.QC_M_HIDE_INPROGRESS = 1
		end
	end)

    qcListFiltersTitle = self:CreateFontString("qcListFiltersTitle", "ARTWORK", "GameFontNormal")
    qcListFiltersTitle:SetPoint("TOPLEFT", qcConfigSubtitle, "BOTTOMLEFT", 16, -185)
    qcListFiltersTitle:SetText(qcL.QUESTLISTFILTERS)

	qcIO_L_HIDE_COMPLETED = CreateFrame("CheckButton", "qcIO_L_HIDE_COMPLETED", self, "InterfaceOptionsCheckButtonTemplate")
    qcIO_L_HIDE_COMPLETED:SetPoint("TOPLEFT", qcListFiltersTitle, "BOTTOMLEFT", 16, -6)
	_G[qcIO_L_HIDE_COMPLETED:GetName().."Text"]:SetText(qcL.HIDECOMPLETEDQUESTS)
	qcIO_L_HIDE_COMPLETED:SetScript("OnClick", function(self)
		if (qcIO_L_HIDE_COMPLETED:GetChecked() == nil) then
			qcSettings.QC_L_HIDE_COMPLETED = 0
		else
			qcSettings.QC_L_HIDE_COMPLETED = 1
		end
	end)

	qcIO_L_HIDE_LOWLEVEL = CreateFrame("CheckButton", "qcIO_L_HIDE_LOWLEVEL", self, "InterfaceOptionsCheckButtonTemplate")
    qcIO_L_HIDE_LOWLEVEL:SetPoint("TOPLEFT", qcIO_L_HIDE_COMPLETED, "BOTTOMLEFT", 0, 0)
	_G[qcIO_L_HIDE_LOWLEVEL:GetName().."Text"]:SetText(qcL.HIDELOWLEVELQUESTS .. COLOUR_DEATHKNIGHT .. " (Not Yet Implemented)")
	qcIO_L_HIDE_LOWLEVEL:SetScript("OnClick", function(self)
		if (qcIO_L_HIDE_LOWLEVEL:GetChecked() == nil) then
			qcSettings.QC_L_HIDE_LOWLEVEL = 0
		else
			qcSettings.QC_L_HIDE_LOWLEVEL = 1
		end
	end)

	qcIO_L_HIDE_PROFESSION = CreateFrame("CheckButton", "qcIO_L_HIDE_PROFESSION", self, "InterfaceOptionsCheckButtonTemplate")
    qcIO_L_HIDE_PROFESSION:SetPoint("TOPLEFT", qcIO_L_HIDE_LOWLEVEL, "BOTTOMLEFT", 0, 0)
	_G[qcIO_L_HIDE_PROFESSION:GetName().."Text"]:SetText(qcL.HIDEOTHERPROFESSIONQUESTS .. COLOUR_DEATHKNIGHT .. " (Not Yet Implemented)")
	qcIO_L_HIDE_PROFESSION:SetScript("OnClick", function(self)
		if (qcIO_L_HIDE_PROFESSION:GetChecked() == nil) then
			qcSettings.QC_L_HIDE_PROFESSION = 0
		else
			qcSettings.QC_L_HIDE_PROFESSION = 1
		end
	end)

    qcCombinedFiltersTitle = self:CreateFontString("qcCombinedFiltersTitle", "ARTWORK", "GameFontNormal")
    qcCombinedFiltersTitle:SetPoint("TOPLEFT", qcConfigSubtitle, "BOTTOMLEFT", 16, -290)
    qcCombinedFiltersTitle:SetText(qcL.COMBINEDMAPANDQUESTFILTERS)

	qcIO_ML_HIDE_FACTION = CreateFrame("CheckButton", "qcIO_ML_HIDE_FACTION", self, "InterfaceOptionsCheckButtonTemplate")
    qcIO_ML_HIDE_FACTION:SetPoint("TOPLEFT", qcCombinedFiltersTitle, "BOTTOMLEFT", 16, -6)
	_G[qcIO_ML_HIDE_FACTION:GetName().."Text"]:SetText(qcL.HIDEOTHERFACTIONQUESTS)
	qcIO_ML_HIDE_FACTION:SetScript("OnClick", function(self)
		if (qcIO_ML_HIDE_FACTION:GetChecked() == nil) then
			qcSettings.QC_ML_HIDE_FACTION = 0
		else
			qcSettings.QC_ML_HIDE_FACTION = 1
		end
	end)

	qcIO_ML_HIDE_RACECLASS = CreateFrame("CheckButton", "qcIO_ML_HIDE_RACECLASS", self, "InterfaceOptionsCheckButtonTemplate")
    qcIO_ML_HIDE_RACECLASS:SetPoint("TOPLEFT", qcIO_ML_HIDE_FACTION, "BOTTOMLEFT", 0, 0)
	_G[qcIO_ML_HIDE_RACECLASS:GetName().."Text"]:SetText(qcL.HIDEOTHERRACEANDCLASSQUESTS)
	qcIO_ML_HIDE_RACECLASS:SetScript("OnClick", function(self)
		if (qcIO_ML_HIDE_RACECLASS:GetChecked() == nil) then
			qcSettings.QC_ML_HIDE_RACECLASS = 0
		else
			qcSettings.QC_ML_HIDE_RACECLASS = 1
		end
	end)

    self:SetScript("OnShow", qcConfigRefresh) 
    qcConfigRefresh(self)

end

function qcConfigRefresh(self)
	if not (self:IsVisible()) then return end
	--[[ Set control values here ]]--
end

function qcInterfaceOptions_OnLoad(self)

	self.name = "Quest Completist"
	self.okay = function(self) qcInterfaceOptions_Okay(self) end
	self.cancel = function(self) qcInterfaceOptions_Cancel(self) end
	InterfaceOptions_AddCategory(self)

end

--[[ ##### INTERFACE OPTIONS END ##### ]]--

local function qcCheckSettings()

	if (qcSettings == nil) then
		qcSettings = {}
	end

	if (qcSettings.SORT == nil) then --[[ 1:Level, 2:Alpha, 3:Quest Giver ]]--
		qcSettings.SORT = 1
	end
	if (qcSettings.PURGED == nil) then
		qcSettings.PURGED = 0
	end

	--[[ Interface Options ]]--

	if (qcSettings.QC_M_SHOW_ICONS == nil) then --[[ 0:No, 1:Yes ]]--
		qcSettings.QC_M_SHOW_ICONS = 1
	end
	if (qcSettings.QC_M_HIDE_COMPLETED == nil) then --[[ 0:No, 1:Yes ]]--
		qcSettings.QC_M_HIDE_COMPLETED = 0
	end
	if (qcSettings.QC_M_HIDE_LOWLEVEL == nil) then --[[ 0:No, 1:Yes ]]--
		qcSettings.QC_M_HIDE_LOWLEVEL = 0
	end
	if (qcSettings.QC_M_HIDE_PROFESSION == nil) then --[[ 0:No, 1:Yes ]]--
		qcSettings.QC_M_HIDE_PROFESSION = 1
	end
	if (qcSettings.QC_M_HIDE_SEASONAL == nil) then --[[ 0:No, 1:Yes ]]--
		qcSettings.QC_M_HIDE_SEASONAL = 1
	end
	if (qcSettings.QC_M_HIDE_INPROGRESS == nil) then --[[ 0:No, 1:Yes ]]--
		qcSettings.QC_M_HIDE_INPROGRESS = 0
	end
	if (qcSettings.QC_L_HIDE_COMPLETED == nil) then --[[ 0:No, 1:Yes ]]--
		qcSettings.QC_L_HIDE_COMPLETED = 0
	end
	if (qcSettings.QC_L_HIDE_LOWLEVEL == nil) then --[[ 0:No, 1:Yes ]]--
		qcSettings.QC_L_HIDE_LOWLEVEL = 0
	end
	if (qcSettings.QC_L_HIDE_PROFESSION == nil) then --[[ 0:No, 1:Yes ]]--
		qcSettings.QC_L_HIDE_PROFESSION = 1
	end
	if (qcSettings.QC_ML_HIDE_FACTION == nil) then --[[ 0:No, 1:Yes ]]--
		qcSettings.QC_ML_HIDE_FACTION = 1
	end
	if (qcSettings.QC_ML_HIDE_RACECLASS == nil) then --[[ 0:No, 1:Yes ]]--
		qcSettings.QC_ML_HIDE_RACECLASS = 1
	end

end

local function qcApplySettings()

	if (qcSettings.QC_M_SHOW_ICONS == 0) then
		qcIO_M_SHOW_ICONS:SetChecked(false)
	else
		qcIO_M_SHOW_ICONS:SetChecked(true)
	end
	if (qcSettings.QC_M_HIDE_COMPLETED == 0) then
		qcIO_M_HIDE_COMPLETED:SetChecked(false)
	else
		qcIO_M_HIDE_COMPLETED:SetChecked(true)
	end
	if (qcSettings.QC_M_HIDE_LOWLEVEL == 0) then
		qcIO_M_HIDE_LOWLEVEL:SetChecked(false)
	else
		qcIO_M_HIDE_LOWLEVEL:SetChecked(true)
	end
	if (qcSettings.QC_M_HIDE_PROFESSION == 0) then
		qcIO_M_HIDE_PROFESSION:SetChecked(false)
	else
		qcIO_M_HIDE_PROFESSION:SetChecked(true)
	end
	if (qcSettings.QC_M_HIDE_SEASONAL == 0) then
		qcIO_M_HIDE_SEASONAL:SetChecked(false)
	else
		qcIO_M_HIDE_SEASONAL:SetChecked(true)
	end
	if (qcSettings.QC_M_HIDE_INPROGRESS == 0) then
		qcIO_M_HIDE_INPROGRESS:SetChecked(false)
	else
		qcIO_M_HIDE_INPROGRESS:SetChecked(true)
	end
	if (qcSettings.QC_L_HIDE_COMPLETED == 0) then
		qcIO_L_HIDE_COMPLETED:SetChecked(false)
	else
		qcIO_L_HIDE_COMPLETED:SetChecked(true)
	end
	if (qcSettings.QC_L_HIDE_LOWLEVEL == 0) then
		qcIO_L_HIDE_LOWLEVEL:SetChecked(false)
	else
		qcIO_L_HIDE_LOWLEVEL:SetChecked(true)
	end
	if (qcSettings.QC_L_HIDE_PROFESSION == 0) then
		qcIO_L_HIDE_PROFESSION:SetChecked(false)
	else
		qcIO_L_HIDE_PROFESSION:SetChecked(true)
	end
	if (qcSettings.QC_ML_HIDE_FACTION == 0) then
		qcIO_ML_HIDE_FACTION:SetChecked(false)
	else
		qcIO_ML_HIDE_FACTION:SetChecked(true)
	end
	if (qcSettings.QC_ML_HIDE_RACECLASS == 0) then
		qcIO_ML_HIDE_RACECLASS:SetChecked(false)
	else
		qcIO_ML_HIDE_RACECLASS:SetChecked(true)
	end

	if (QCADDON_PURGE == true) then
		if not (qcSettings.PURGED == QCADDON_VERSION) then
			qcPurgeCollectedCache()
			qcSettings.PURGED = QCADDON_VERSION
		end
	end

end

local function qcEventHandler(self, event, ...)

	if (event == "WORLD_MAP_UPDATE") then

		qcRefreshMapIcons(GetCurrentMapAreaID(), GetCurrentMapDungeonLevel())
		qcRefreshPins(GetCurrentMapAreaID())

	elseif (event == "UNIT_QUEST_LOG_CHANGED") then

		if (... == "player") then qcUpdateQuestList(nil, qcMenuSlider:GetValue()) end

	elseif (event == "ZONE_CHANGED_NEW_AREA") then

		qcZoneChangedNewArea()

	elseif (event == "QUEST_ITEM_UPDATE") then

		if (QuestFrame:IsShown()) then QuestFrameNpcNameText:SetText(string.format("%s [%d]",UnitName("questnpc") or nil,GetQuestID())) end

	elseif (event == "QUEST_DETAIL") then

		local qcQuestID = GetQuestID()
		if (QuestFrame:IsShown()) then QuestFrameNpcNameText:SetText(string.format("%s [%d]",UnitName("questnpc") or nil,GetQuestID())) end
		qcBreadcrumbChecks(qcQuestID)
		qcNewDataChecks(qcQuestID)
		qcMutuallyExclusiveChecks(qcQuestID)
		qcDetectSharedQuestOnDetail(qcQuestID)
		if (QCDEBUG_MODE) then qcVerifyMapDataExists() end

	elseif (event == "QUEST_ACCEPTED") then

		qcCollectQuestOnAccept(...)
		qcUpdateQuestList(nil, qcMenuSlider:GetValue())

	elseif (event == "QUEST_PROGRESS") then

		local qcQuestID = GetQuestID()
		if (QuestFrame:IsShown()) then QuestFrameNpcNameText:SetText(string.format("%s [%d]",UnitName("questnpc") or nil,GetQuestID())) end
		if not (qcQuestID == 0) then
			qcCollectQuestOnProgressComplete(qcQuestID)
			qcBreadcrumbChecks(qcQuestID)
			qcNewDataChecks(qcQuestID)
			qcMutuallyExclusiveChecks(qcQuestID)
		end

	elseif (event == "QUEST_COMPLETE") then

		local qcQuestID = GetQuestID()
		if (QuestFrame:IsShown()) then QuestFrameNpcNameText:SetText(string.format("%s [%d]",UnitName("questnpc") or nil,GetQuestID())) end
		if not (qcQuestID == 0) then
			qcCollectQuestOnProgressComplete(qcQuestID)
			qcBreadcrumbChecks(qcQuestID)
			qcNewDataChecks(qcQuestID)
			qcMutuallyExclusiveChecks(qcQuestID)
			qcUpdateCompletedQuest(qcQuestID)
			qcUpdateMutuallyExclusiveCompletedQuest(qcQuestID)
			qcUpdateSkippedBreadcrumbQuest(qcQuestID)
			qcUpdateQuestList(nil, qcMenuSlider:GetValue())
		end

	elseif (event == "QUEST_QUERY_COMPLETE") then

		qcQuestQueryCompleted()
		qcQuestCompletistUI:UnregisterEvent("QUEST_QUERY_COMPLETE")

	elseif (event == "PLAYER_ENTERING_WORLD") then

		qcZoneChangedNewArea()

	elseif (event == "ADDON_LOADED") then

		if (... == "QuestCompletist") then
			qcCheckSettings()
			qcApplySettings()
			qcCollectUpdate()
		end

	end

end

function qcQuestBuilder_OnLoad(self)

	

end

function qcQuestCompletistUI_OnLoad(self)

	SetPortraitToTexture(self.qcPortrait, "Interface\\ICONS\\TRADE_ARCHAEOLOGY_DRAENEI_TOME")
	self.qcTitleText:SetText(string.format("Quest Completist v%s",QCADDON_VERSION))
	self.qcCategoryDropdownButton:SetText(GetText("CATEGORIES"))
	self.qcOptionsButton:SetText(GetText("FILTERS"))
	self:RegisterForDrag("LeftButton")

	self:RegisterEvent("QUEST_COMPLETE")
	self:RegisterEvent("QUEST_DETAIL")
	self:RegisterEvent("QUEST_PROGRESS")
	self:RegisterEvent("QUEST_ACCEPTED")
	self:RegisterEvent("QUEST_ITEM_UPDATE")
	self:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("WORLD_MAP_UPDATE")
	self:SetScript("OnEvent", qcEventHandler)

	qcQuestInformationTooltipSetup()
	qcQuestReputationTooltipSetup()
	qcMapTooltipSetup()
	qcToastTooltipSetup()
	qcNewDataAlertTooltipSetup()
	qcMutuallyExclusiveAlertTooltipSetup()

	for qcIndex, qcEntry in ipairs(qcCategoryMenu) do
		if (qcEntry[3]) then
			table.sort(qcEntry[3],function(a,b) return a[2]<b[2] end)
		end
	end

end