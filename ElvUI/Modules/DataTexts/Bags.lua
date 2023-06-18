﻿local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local format, join = string.format, string.join

local ContainerIDToInventoryID = ContainerIDToInventoryID
local GetBackpackCurrencyInfo = GetBackpackCurrencyInfo
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetContainerNumSlots = GetContainerNumSlots
local GetItemInfo = GetItemInfo
local GetInventoryItemLink = GetInventoryItemLink
local GetItemQualityColor = GetItemQualityColor
local BACKPACK_TOOLTIP = BACKPACK_TOOLTIP
local CURRENCY = CURRENCY
local NUM_BAG_SLOTS = NUM_BAG_SLOTS
local MAX_WATCHED_TOKENS = MAX_WATCHED_TOKENS

local currencyString = "|T%s:12:12:0:0:64:64:4:60:4:60|t %s"
local displayString = ""
local lastPanel

local function OnEvent(self)
	local free, total = 0, 0
	for i = 0, NUM_BAG_SLOTS do
		local bagFreeSlots, bagType = GetContainerNumFreeSlots(i)
		local bagSlots = GetContainerNumSlots(i)

		if not bagType or bagType == 0 then
			free, total = free + bagFreeSlots, total + bagSlots
		end
	end
	self.text:SetFormattedText(displayString, L["Bags"], total - free, total)

	lastPanel = self
end

local function OnClick()
	ToggleAllBags()
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	local r, g, b
	local _, name, quality, link
	local free, total, used

	for i = 0, NUM_BAG_SLOTS do
		free, total = GetContainerNumFreeSlots(i), GetContainerNumSlots(i)
		used = total - free

		if i == 0 then
			DT.tooltip:AddLine(L["Bags"]..":")
			DT.tooltip:AddDoubleLine(join("", BACKPACK_TOOLTIP), format("%d / %d", used, total), 1, 1, 1)
		else
			link = GetInventoryItemLink("player", ContainerIDToInventoryID(i))
			if link then
				name, _, quality = GetItemInfo(link)
				r, g, b = GetItemQualityColor(quality)
				DT.tooltip:AddDoubleLine(join("", name), format("%d / %d", used, total), r, g, b)
			end
		end
	end

	local count, icon
	for i = 1, MAX_WATCHED_TOKENS do
		name, count, icon = GetBackpackCurrencyInfo(i)
		if name and i == 1 then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(CURRENCY..":")
		end

		if name and count then
			DT.tooltip:AddDoubleLine(format(currencyString, icon, name), count, 1, 1, 1)
		end
	end

	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayString = join("", "%s: ", hex, "%d/%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Bags", {"PLAYER_ENTERING_WORLD", "BAG_UPDATE"}, OnEvent, nil, OnClick, OnEnter, nil, L["Bags"])