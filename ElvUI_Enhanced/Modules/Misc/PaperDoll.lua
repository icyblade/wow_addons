local E, L, V, P, G = unpack(ElvUI)
local PD = E:NewModule("Enhanced_PaperDoll", "AceEvent-3.0", "AceTimer-3.0")
local LSM = E.Libs.LSM

local _G = _G
local pairs, select = pairs, select
local find, format, match = string.find, string.format, string.match

local CanInspect = CanInspect
local GetInventoryItemDurability = GetInventoryItemDurability
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInventorySlotInfo = GetInventorySlotInfo
local GetItemQualityColor = GetItemQualityColor
local GetItemInfo = GetItemInfo
local InCombatLockdown = InCombatLockdown
local UnitLevel = UnitLevel

local originalInspectFrameUpdateTabs
local updateTimer

local slots = {
	["HeadSlot"] = true,
	["NeckSlot"] = false,
	["ShoulderSlot"] = true,
	["BackSlot"] = false,
	["ChestSlot"] = true,
	["WristSlot"] = true,
	["HandsSlot"] = true,
	["WaistSlot"] = true,
	["LegsSlot"] = true,
	["FeetSlot"] = true,
	["Finger0Slot"] = false,
	["Finger1Slot"] = false,
	["Trinket0Slot"] = false,
	["Trinket1Slot"] = false,
	["MainHandSlot"] = true,
	["SecondaryHandSlot"] = true
}

local levelAdjust = {
	["0"]	= 0,	["1"]	= 8,	["373"] = 4,	["374"] = 8,	["375"] = 4,
	["376"] = 4,	["377"] = 4,	["379"] = 4,	["380"] = 4,	["445"] = 0,
	["446"] = 4,	["447"] = 8,	["451"] = 0,	["452"] = 8,	["453"] = 0,
	["454"] = 4,	["455"] = 8,	["456"] = 0,	["457"] = 8,	["458"] = 0,
	["459"] = 4,	["460"] = 8,	["461"] = 12,	["462"] = 16,	["465"] = 0,
	["466"] = 4,	["467"] = 8,	["468"] = 0,	["469"] = 4,	["470"] = 8,
	["471"] = 12,	["472"] = 16,	["491"] = 0,	["492"] = 4,	["493"] = 8,
	["494"] = 0,	["495"] = 4,	["496"] = 8,	["497"] = 12,	["498"] = 16,
	["504"] = 12,	["505"] = 16,
}

local levelColors = {
	[0] = "|cffff0000",
	[1] = "|cff00ff00",
	[2] = "|cffffff88"
}

local heirlooms = {
	[80] = {
		44102, 42944, 44096, 42943, 42950, 48677, 42946, 42948, 42947, 42992, 
		50255, 44103, 44107, 44095, 44098, 44097, 44105, 42951, 48683, 48685,
		42949, 48687, 42984, 44100, 44101, 44092, 48718, 44091, 42952, 48689,
		44099, 42991, 42985, 48691, 44094, 44093, 42945, 48716
	}
}

function PD:HeirLoomLevel(unit, itemLink)
	local level = UnitLevel(unit)

	if level > 85 then level = 85 end
	if level > 80 then
		local _, _, _, _, itemId = find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
		itemId = tonumber(itemId)
		for _, id in pairs(heirlooms[80]) do
			if id == itemId then
				level = 80
				break
			end
		end
	end

	if level > 80 then
		return ((level - 81) * 12.2) + 272
	elseif level > 67 then
		return ((level - 68) * 6) + 130
	elseif level > 59 then
		return ((level - 60) * 3) + 85
	else
		return level
	end
end

function PD:GetItemLevel(unit, itemLink)
	local rarity, itemLevel = select(3, GetItemInfo(itemLink))
	if rarity == 7 then
		itemLevel = self:HeirLoomLevel(unit, itemLink)
	end

	local upgrade = match(itemLink, ":(%d+)\124h%[")
	if itemLevel and upgrade and levelAdjust[upgrade] then
		itemLevel = itemLevel + levelAdjust[upgrade]
	end

	return itemLevel
end

function PD:UpdatePaperDoll(unit)
	if not self.initialized then return end

	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", function(event) self:OnEvent(event, unit) end)
		return
 	end

	unit = (unit ~= "player" and InspectFrame) and InspectFrame.unit or unit
	if not unit then return end
	if unit and not CanInspect(unit, false) then return end

	local baseName = unit == "player" and "Character" or "Inspect"
	local frame, slotID, hasItem
	local itemLink, itemLevel, rarity, avgEquipItemLevel
	local current, maximum, r, g, b

	for slotName, durability in pairs(slots) do
		frame = _G[format("%s%s", baseName, slotName)]
		slotID = GetInventorySlotInfo(slotName)
		hasItem = GetInventoryItemTexture(unit, slotID)

		frame.ItemLevel:SetText()
		if E.db.enhanced.equipment.itemlevel.enable and (unit == "player" or (unit ~= "player" and hasItem)) then
			itemLink = GetInventoryItemLink(unit, slotID)

			if itemLink then
				rarity = select(3, GetItemInfo(itemLink))
				itemLevel = self:GetItemLevel(unit, itemLink)
				avgEquipItemLevel = select(2, GetAverageItemLevel())

				if itemLevel and avgEquipItemLevel then
					frame.ItemLevel:SetText(itemLevel)

					if E.db.enhanced.equipment.itemlevel.qualityColor then
						if rarity and rarity > 1 then
							frame.ItemLevel:SetTextColor(GetItemQualityColor(rarity))
						else
							frame.ItemLevel:SetTextColor(1, 1, 1)
						end
					else
						frame.ItemLevel:SetFormattedText("%s%d|r", levelColors[(itemLevel < avgEquipItemLevel - 10 and 0 or (itemLevel > avgEquipItemLevel + 10 and 1 or (2)))], itemLevel)
					end
				end
			end
		end

		if unit == "player" and durability then
			frame.DurabilityInfo:SetText()

			if E.db.enhanced.equipment.durability.enable then
				current, maximum = GetInventoryItemDurability(slotID)
				if current and maximum and (not E.db.enhanced.equipment.durability.onlydamaged or current < maximum) then
					r, g, b = E:ColorGradient((current / maximum), 1, 0, 0, 1, 1, 0, 0, 1, 0)
					frame.DurabilityInfo:SetFormattedText("%s%.0f%%|r", E:RGBToHex(r, g, b), (current / maximum) * 100)
				end
			end
		end
	end
end

function PD:UpdateInfoText(name)
	local db = E.db.enhanced.equipment

	for slotName, durability in pairs(slots) do
		local frame = _G[format("%s%s", name, slotName)]

		frame.ItemLevel:ClearAllPoints()
		frame.ItemLevel:Point(db.itemlevel.position, frame, db.itemlevel.position, db.itemlevel.xOffset, db.itemlevel.yOffset)
		frame.ItemLevel:FontTemplate(LSM:Fetch("font", db.itemlevel.font), db.itemlevel.fontSize, db.itemlevel.fontOutline)

		if name == "Character" and durability then
			frame.DurabilityInfo:ClearAllPoints()
			frame.DurabilityInfo:Point(db.durability.position, frame, db.durability.position, db.durability.xOffset, db.durability.yOffset)
			frame.DurabilityInfo:FontTemplate(LSM:Fetch("font", db.durability.font), db.durability.fontSize, db.durability.fontOutline)
		end
	end
end

function PD:BuildInfoText(name)
	for slotName, durability in pairs(slots) do
		local frame = _G[format("%s%s", name, slotName)]

		frame.ItemLevel = frame:CreateFontString(nil, "OVERLAY")

		if name == "Character" and durability then
			frame.DurabilityInfo = frame:CreateFontString(nil, "OVERLAY")
		end
	end

	self:UpdateInfoText(name)
end

function PD:OnEvent(event, unit)
	if event == "UPDATE_INVENTORY_DURABILITY" then
		self:UpdatePaperDoll("player")
	elseif event == "UNIT_INVENTORY_CHANGED" then
		self:UpdatePaperDoll(unit)
	elseif event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:UpdatePaperDoll(unit)
	end
end

function PD:DelayUpdateInfo(inspect)
	if updateTimer == 0 or PD:TimeLeft(updateTimer) == 0 then
		updateTimer = PD:ScheduleTimer("UpdatePaperDoll", 0.3, inspect)
	end
end

function PD:InspectFrame_UpdateTabsComplete()
	originalInspectFrameUpdateTabs()
	PD:DelayUpdateInfo(true)
end

function PD:InitialUpdatePaperDoll()
	if self.initialized then return end

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	LoadAddOn("Blizzard_InspectUI")

	self:BuildInfoText("Character")
	self:BuildInfoText("Inspect")

	originalInspectFrameUpdateTabs = _G.InspectFrame_UpdateTabs
	_G.InspectFrame_UpdateTabs = PD.InspectFrame_UpdateTabsComplete

	self:ScheduleTimer("UpdatePaperDoll", 5, false)

	self.initialized = true
end

function PD:ToggleState(init)
	if E.db.enhanced.equipment.enable then
		if not self.initialized then
			if init then
				self:RegisterEvent("PLAYER_ENTERING_WORLD", "InitialUpdatePaperDoll")
			else
				self:InitialUpdatePaperDoll()
			end
		end

		self:UpdatePaperDoll("player")
		self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "OnEvent")
		self:RegisterEvent("UNIT_INVENTORY_CHANGED", "OnEvent")
	elseif self.initialized then
		self:UnregisterAllEvents()

		for slotName, durability in pairs(slots) do
			_G["Character"..slotName].ItemLevel:SetText()
			_G["Inspect"..slotName].ItemLevel:SetText()

			if durability then
				_G["Character"..slotName].DurabilityInfo:SetText()
			end
		end
	end
end

function PD:Initialize()
	if not E.db.enhanced.equipment.enable then return end

	self:ToggleState(true)
end

local function InitializeCallback()
	PD:Initialize()
end

E:RegisterModule(PD:GetName(), InitializeCallback)
