local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local PD = E:GetModule("Enhanced_PaperDoll")
local EE = E:GetModule("ElvUI_Enhanced")

local floor = math.floor
local join = string.join

local GetInventoryItemLink = GetInventoryItemLink
local GetInventorySlotInfo = GetInventorySlotInfo
local GetAverageItemLevel = GetAverageItemLevel
local GetItemInfo = GetItemInfo
local ITEM_LEVEL_ABBR = ITEM_LEVEL_ABBR
local STAT_AVERAGE_ITEM_LEVEL = STAT_AVERAGE_ITEM_LEVEL

local displayString = ""

local lastPanel

local slots = {
	{"HeadSlot", HEADSLOT},
	{"NeckSlot", NECKSLOT},
	{"ShoulderSlot", SHOULDERSLOT},
	{"BackSlot", BACKSLOT},
	{"ChestSlot", CHESTSLOT},
	{"WristSlot", WRISTSLOT},
	{"HandsSlot", HANDSSLOT},
	{"WaistSlot", WAISTSLOT},
	{"LegsSlot", LEGSSLOT},
	{"FeetSlot", FEETSLOT},
	{"Finger0Slot", FINGER0SLOT_UNIQUE},
	{"Finger1Slot", FINGER1SLOT_UNIQUE},
	{"Trinket0Slot", TRINKET0SLOT_UNIQUE},
	{"Trinket1Slot", TRINKET1SLOT_UNIQUE},
	{"MainHandSlot", MAINHANDSLOT},
	{"SecondaryHandSlot", SECONDARYHANDSLOT},
	{"RangedSlot", RANGEDSLOT},
}

local levelColors = {
	[0] = {1, 0, 0},
	[1] = {0, 1, 0},
	[2] = {1, 1, 0.5}
}

local function OnEvent(self, event)
	if event == "PLAYER_ENTERING_WORLD" then
		PD:ScheduleTimer("UpdateDataTextItemLevel", 5, self)
		return
	end
	PD:UpdateDataTextItemLevel(self)
end

function PD:UpdateDataTextItemLevel(self)
	local total, equipped = GetAverageItemLevel()

	self.text:SetFormattedText(displayString, ITEM_LEVEL_ABBR, floor(equipped), floor(total))
end

local function OnEnter(self)
	local total, equipped = GetAverageItemLevel()
	local color

	DT:SetupTooltip(self)
	DT.tooltip:AddLine(STAT_AVERAGE_ITEM_LEVEL)
	DT.tooltip:AddDoubleLine(L["Equipped"], floor(equipped), 1, 1, 1)
	DT.tooltip:AddDoubleLine(L["Total"], floor(total), 1, 1, 1)
	DT.tooltip:AddLine(" ")

	for i = 1, #slots do
		local item = GetInventoryItemLink("player", GetInventorySlotInfo(slots[i][1]))
		if item then
			local _, _, quality, iLevel = GetItemInfo(item)
			local r, g, b = GetItemQualityColor(quality)

			color = levelColors[(iLevel < equipped - 5 and 0 or (iLevel > equipped + 5 and 1 or 2))]
			DT.tooltip:AddDoubleLine(slots[i][2], iLevel, r, g, b, color[1], color[2], color[3])
		end
	end

	DT.tooltip:Show()
end

local function OnClick(self, btn)
	if btn == "LeftButton" then
		ToggleCharacter("PaperDollFrame")
	else
		OnEvent(self)
	end
end

local function ValueColorUpdate(hex)
	displayString = join("", "%s: ", hex, "%d/%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Item Level", {"PLAYER_ENTERING_WORLD", "PLAYER_EQUIPMENT_CHANGED", "UNIT_INVENTORY_CHANGED"}, OnEvent, nil, OnClick, OnEnter, nil, EE:ColorizeSettingName(STAT_AVERAGE_ITEM_LEVEL))