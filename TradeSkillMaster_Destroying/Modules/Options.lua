-- ------------------------------------------------------------------------------ --
--                           TradeSkillMaster_Destroying                          --
--           http://www.curse.com/addons/wow/tradeskillmaster_destroying          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- load the parent file (TSM) into a local variable and register this file as a module
local TSM = select(2, ...)
local Options = TSM:NewModule("Options")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Destroying")
local private = {ignoreSTCreated=nil}



function Options:Load(container)
	local tabGroup = AceGUI:Create("TSMTabGroup")
	tabGroup:SetLayout("Fill")
	tabGroup:SetTabs({{text=L["Destroying Log"], value=1}, {text=L["Averages"], value=2}, {text=L["Ignored Items"], value=3}})
	tabGroup:SetCallback("OnGroupSelected", function(self, _, value)
		tabGroup:ReleaseChildren()
		if value == 1 then
			-- load Destroying log
			Options:LoadLog(self)
		elseif value == 2 then
			-- load Destroying log
			Options:LoadAverages(self)
		elseif value == 3 then
			-- load ignored items list
			Options:LoadIgnored(self)
		end
		tabGroup.children[1]:DoLayout()
	end)
	container:AddChild(tabGroup)
	tabGroup:SelectTab(1)
end

function Options:GetFormattedTime(rTime)
	if TSM.db.global.timeFormat == "ago" then
		if time() == rTime then
			return format(L["now"])
		end
		return format("%s ago", SecondsToTime(time()-rTime) or "?")
	elseif TSM.db.global.timeFormat == "usdate" then
		return date("%m/%d/%y %H:%M", rTime)
	elseif TSM.db.global.timeFormat == "eudate" then
		return date("%d/%m/%y %H:%M", rTime)
	elseif TSM.db.global.timeFormat == "aidate" then
		return date("%y/%m/%d %H:%M", rTime)
	end
end

function Options:UpdateLogST()
	-- clear old data
	for spell, entries in pairs(TSM.db.global.history) do
		for i=#entries, 1, -1 do
			if (entries[i].time + TSM.db.global.logDays*24*60*60) < time() then
				tremove(entries, i)
			end
		end
	end
	
	local stData = {}
	for spell, entries in pairs(TSM.db.global.history) do
		for _, entry in ipairs(entries) do
			local result = {}
			for itemString, quantity in pairs(entry.result) do
				local link = select(2, TSMAPI.Item:GetInfo(itemString)) or itemString
				tinsert(result, format("%sx%d", link, quantity))
			end
			sort(result, function(a,b) return a > b end)
			local name, link = TSMAPI.Item:GetInfo(entry.item)
			name = name or entry.item
			link = link or entry.item
			local resultStr = table.concat(result, ", ") or ""
			local row = {
				cols = {
					{
						value = spell,
						sortArg = spell,
					},
					{
						value = link,
						sortArg = spell,
					},
					{
						value = resultStr,
						sortArg = resultStr,
					},
					{
						value = Options:GetFormattedTime(entry.time),
						sortArg = entry.time or 0,
					},
				},
			}
			tinsert(stData, row)
		end
	end
	TSMAPI.GUI:UpdateTSMScrollingTableData("TSM_DESTROYING_LOG", stData)
end

function Options:LoadLog(container)
	local stCols = {
		{
			name = L["Spell"],
			width = 0.08,
		},
		{
			name = L["Destroyed Item"],
			width = 0.2,
		},
		{
			name = L["Result"],
			width = 0.56,
		},
		{
			name = L["Time"],
			width = 0.14,
		}
	}
	
	local page = {
		{
			type = "SimpleGroup",
			fullHeight = true,
			layout = "Fill",
			children = {
				{
					type = "ScrollingTable",
					tag = "TSM_DESTROYING_LOG",
					colInfo = stCols,
					defaultSort = -4,
				},
			},
		},
	}

	TSMAPI.GUI:BuildOptions(container, page)
	Options:UpdateLogST()
end

function Options:UpdateAverageST()
	local items = {}
	for spell, entries in pairs(TSM.db.global.history) do
		for _, entry in ipairs(entries) do
			items[entry.item] = items[entry.item] or {spell=spell, num=0}
			items[entry.item].num = items[entry.item].num + 1
			for itemString, quantity in pairs(entry.result) do
				items[entry.item][itemString] = items[entry.item][itemString] or {total=0}
				items[entry.item][itemString].total = items[entry.item][itemString].total + quantity
			end
		end
	end
	
	local stData = {}
	for destroyedItem, resultItems in pairs(items) do
		local spell = resultItems.spell
		resultItems.spell = nil
		local totalNum = resultItems.num
		resultItems.num = nil
		local result = {}
		for itemString, data in pairs(resultItems) do
			local link = select(2, TSMAPI.Item:GetInfo(itemString)) or itemString
			local average = floor((data.total/totalNum) * 100 + 0.5) / 100
			tinsert(result, format("%sx%.2f", link, average))
		end
		sort(result, function(a,b) return a > b end)
		local name, link = TSMAPI.Item:GetInfo(destroyedItem)
		name = name or destroyedItem
		link = link or destroyedItem
		local resultStr = table.concat(result, ", ") or ""
		local row = {
			cols = {
				{
					value = spell,
					sortArg = spell,
				},
				{
					value = totalNum,
					sortArg = totalNum,
				},
				{
					value = link,
					sortArg = name,
				},
				{
					value = resultStr,
					sortArg = resultStr,
				},
			},
		}
		tinsert(stData, row)
	end
	TSMAPI.GUI:UpdateTSMScrollingTableData("TSM_DESTROYING_AVERAGES", stData)
end

function Options:LoadAverages(container)
	local stCols = {
		{
			name = L["Spell"],
			width = 0.1,
		},
		{
			name = L["Times Destroyed"],
			width = 0.15,
		},
		{
			name = L["Destroyed Item"],
			width = 0.3,
		},
		{
			name = L["Average Result (per Destroy)"],
			width = 0.45,
		}
	}
	
	local page = {
		{
			type = "SimpleGroup",
			fullHeight = true,
			layout = "Fill",
			children = {
				{
					type = "ScrollingTable",
					tag = "TSM_DESTROYING_AVERAGES",
					colInfo = stCols,
					defaultSort = -2,
				},
			},
		},
	}

	TSMAPI.GUI:BuildOptions(container, page)
	Options:UpdateAverageST()
end

function Options:UpdateIgnoreST()
	if not private.ignoreSTCreated then return end
	local stData = {}
	for itemString in pairs(TSM.db.global.ignore) do
		local name, link = TSMAPI.Item:GetInfo(itemString)
		name = name or itemString
		link = link or itemString
		local row = {
			cols = {
				{
					value = link,
				},
			},
			name = name,
			link = link,
			itemString = itemString,
		}
		tinsert(stData, row)
	end
	sort(stData, function(a, b) return a.name < b.name end)
	TSMAPI.GUI:UpdateTSMScrollingTableData("TSM_DESTROYING_IGNORE", stData)
end

function Options:LoadIgnored(container)
	local stCols = {
		{
			name = L["Ignored Item"],
			width = 1,
		}
	}
	local stHandlers = {
		OnEnter = function(_, data, self)
			if not data.itemString then return end
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT")
			GameTooltip:AddLine(L["Right click on this row to remove this item from the permanent ignore list."], 1, 1, 1, true)
			GameTooltip:Show()
		end,
		OnLeave = function()
			GameTooltip:ClearLines()
			GameTooltip:Hide()
		end,
		OnClick = function(_, data, _, button)
			if not data.itemString then return end
			if button == "RightButton" then
				TSM.db.global.ignore[data.itemString] = nil
				TSM:Printf(L["Removed %s from the permanent ignore list."], data.link)
				Options:UpdateIgnoreST()
				TSM.GUI:UpdateST()
			end
		end
	}
	
	local page = {
		{
			type = "SimpleGroup",
			fullHeight = true,
			layout = "Fill",
			children = {
				{
					type = "ScrollingTable",
					tag = "TSM_DESTROYING_IGNORE",
					colInfo = stCols,
					handlers = stHandlers,
				},
			},
		},
	}

	TSMAPI.GUI:BuildOptions(container, page)
	private.ignoreSTCreated = true
	Options:UpdateIgnoreST()
end

function Options:LoadOptions(container)
	local page = {
		{
			type = "ScrollFrame",
			layout = "Flow",
			fullHeight = true,
			children = {
				{
					type = "InlineGroup",
					title = L["General Options"],
					layout = "Flow",
					children = {
						{
							type = "CheckBox",
							label = L["Enable Automatic Stack Combination"],
							relativeWidth = 0.5,
							settingInfo = {TSM.db.global, "autoStack"},
							tooltip = L["If checked, partial stacks of herbs/ore will automatically be combined."],
						},
						{
							type = "CheckBox",
							label = L["Show Destroying Frame Automatically"],
							relativeWidth = 0.49,
							settingInfo = {TSM.db.global, "autoShow"},
							tooltip = L["If checked, the Destroying window will automatically be shown when there's items to destroy in your bags. Otherwise, you can open it up by typing '/tsm destroy'."],
						},
						{
							type = "Dropdown",
							label = L["Time Format"],
							relativeWidth = 0.5,
							list = {["ago"]=L["_ Hr _ Min ago"], ["usdate"]="MM/DD/YY HH:MM", ["aidate"]="YY/MM/DD HH:MM", ["eudate"]="DD/MM/YY HH:MM"},
							settingInfo = {TSM.db.global, "timeFormat"},
							tooltip = L["Select what format Destroying should use to display times in the Destroying log."],
						},
						{
							type = "Slider",
							label = L["Days of Log Data"],
							relativeWidth = 0.49,
							min = 0,
							max = 30,
							step = 1,
							settingInfo = {TSM.db.global, "logDays"},
							tooltip = L["The destroying log will throw out any data that is older than this many days."],
						}
					},
				},
				{
					type = "InlineGroup",
					title = L["Disenchanting Options"],
					layout = "Flow",
					children = {
						{
							type = "Dropdown",
							label = L["Maximum Disenchant Quality"],
							list = {[2]=ITEM_QUALITY2_DESC, [3]=ITEM_QUALITY3_DESC, [4]=ITEM_QUALITY4_DESC},
							relativeWidth = 0.5,
							settingInfo = {TSM.db.global, "deMaxQuality"},
							tooltip = L["Destroying will not list any items above this quality for disenchanting."],
							callback = function(self)
								TSM.GUI:UpdateST()
							end,
						},
						{
							type = "CheckBox",
							label = L["Include Soulbound Items"],
							relativeWidth = 0.49,
							settingInfo = {TSM.db.global, "includeSoulbound"},
							tooltip = L["If checked, soulbound items can be destroyed by TSM_Destroying. USE THIS WITH EXTREME CAUTION!"],
							callback = function(self)
								TSM.GUI:UpdateST()
							end,
						},
						{
							type = "EditBox",
							label = L["Above Custom Price ('0c' to disable)"],
							settingInfo = { TSM.db.global, "deAbovePrice" },
							relativeWidth = 0.5,
							acceptCustom = true,
							tooltip = L["Only disenchantable items which have a disenchant value ABOVE this custom price will be displayed in the destroying window."],
							callback = function(self)
								TSM.GUI:UpdateST()
							end,
						},
						{
							type = "CheckBox",
							label = L["Above Vendor Sell Price"],
							relativeWidth = 0.49,
							settingInfo = {TSM.db.global, "deAboveVendor"},
							tooltip = L["If checked, Only disenchantable items which have a disenchant value above the vendor sell price will be displayed in the destroying window."],
							callback = function(self)
								TSM.GUI:UpdateST()
							end,
						},
					},
				},
			},
		},
	}

	TSMAPI.GUI:BuildOptions(container, page)
end