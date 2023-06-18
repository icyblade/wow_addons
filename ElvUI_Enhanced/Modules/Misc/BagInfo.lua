local E, L, V, P, G = unpack(ElvUI)
local BI = E:NewModule("Enhanced_BagInfo", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local B = E:GetModule("Bags")

local _G = _G
local ipairs, pairs = ipairs, pairs
local byte, format = string.byte, format
local tinsert, wipe = tinsert, wipe

local GetNumEquipmentSets = GetNumEquipmentSets
local GetEquipmentSetInfo = GetEquipmentSetInfo
local GetEquipmentSetLocations = GetEquipmentSetLocations
local GetContainerNumSlots = GetContainerNumSlots

local updateTimer
local infoArray = {}
local equipmentMap = {}

local function Utf8Sub(str, start, numChars)
	local currentIndex = start
	while numChars > 0 and currentIndex <= #str do
		local char = byte(str, currentIndex)

		if char > 240 then
			currentIndex = currentIndex + 4
		elseif char > 225 then
			currentIndex = currentIndex + 3
		elseif char > 192 then
			currentIndex = currentIndex + 2
		else
			currentIndex = currentIndex + 1
		end

		numChars = numChars -1
	end

	return str:sub(start, currentIndex - 1)
end

local function MapKey(bag, slot)
	return format("%d_%d", bag, slot)
end

local quickFormat = {
	[0] = function(font, map) font:SetText() end,
	[1] = function(font, map) font:SetFormattedText("|cffffffaa%s|r", Utf8Sub(map[1], 1, 4)) end,
	[2] = function(font, map) font:SetFormattedText("|cffffffaa%s %s|r", Utf8Sub(map[1], 1, 4), Utf8Sub(map[2], 1, 4)) end,
	[3] = function(font, map) font:SetFormattedText("|cffffffaa%s %s %s|r", Utf8Sub(map[1], 1, 4), Utf8Sub(map[2], 1, 4), Utf8Sub(map[3], 1, 4)) end,
}

function BI:BuildEquipmentMap(clear)
	wipe(equipmentMap)

	if clear then return end

	local name, player, bank, bags, slot, bag, key

	for i = 1, GetNumEquipmentSets() do
		name = GetEquipmentSetInfo(i)
		GetEquipmentSetLocations(name, infoArray)
		for _, location in pairs(infoArray) do
			if location < -1 or location > 1 then
				_, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(location)
				if bank and slot then
					key = MapKey(-1, slot - 39)
					equipmentMap[key] = equipmentMap[key] or {}
					tinsert(equipmentMap[key], name)
				elseif bags and slot and bag then
					key = MapKey(bag, slot)
					equipmentMap[key] = equipmentMap[key] or {}
					tinsert(equipmentMap[key], name)
				end
			end
		end
	end
end

function BI:UpdateContainerFrame(frame, bag, slot)
	local db = E.db.enhanced.equipmentSet

	if not frame.equipmentinfo then
		frame.equipmentinfo = frame:CreateFontString(nil, "OVERLAY")
	end
	
	frame.equipmentinfo:ClearAllPoints()
	frame.equipmentinfo:SetWidth(frame:GetWidth())
	frame.equipmentinfo:SetPoint(db.position, frame, db.xOffset, db.yOffset)
	frame.equipmentinfo:FontTemplate(E.LSM:Fetch("font", db.font), db.fontSize, db.fontOutline)
	frame.equipmentinfo:SetWordWrap(true)

	local key = MapKey(bag, slot)
	if equipmentMap[key] then
		quickFormat[#equipmentMap[key] < 4 and #equipmentMap[key] or 3](frame.equipmentinfo, equipmentMap[key])
	else
		quickFormat[0](frame.equipmentinfo, nil)
	end
end

function BI:UpdateBagInformation(clear)
	updateTimer = nil

	self:BuildEquipmentMap(clear)
	for _, container in pairs(B.BagFrames) do
		for _, bagID in ipairs(container.BagIDs) do
			for slotID = 1, GetContainerNumSlots(bagID) do
				self:UpdateContainerFrame(container.Bags[bagID][slotID], bagID, slotID)
			end
		end
	end
end

function BI:DelayUpdateBagInformation(event)
	if not updateTimer then
		updateTimer = BI:ScheduleTimer("UpdateBagInformation", .01)
	end
end

function BI:ToggleSettings()
	if updateTimer then
		self:CancelTimer(updateTimer)
	end

	if E.db.enhanced.equipmentSet.enable then
		self:RegisterEvent("EQUIPMENT_SETS_CHANGED", "DelayUpdateBagInformation")
		self:RegisterEvent("BAG_UPDATE", "DelayUpdateBagInformation")
		self:RegisterEvent("PLAYERBANKSLOTS_CHANGED", "DelayUpdateBagInformation")
		self:RegisterEvent("BANKFRAME_OPENED", "DelayUpdateBagInformation")
		BI:UpdateBagInformation()
	else
		self:UnregisterEvent("EQUIPMENT_SETS_CHANGED")
		self:UnregisterEvent("BAG_UPDATE")
		self:UnregisterEvent("BANKFRAME_OPENED")
		self:UnregisterEvent("PLAYERBANKSLOTS_CHANGED")
		BI:UpdateBagInformation(true)
	end
end

function BI:Initialize()
	if not E.private.bags.enable then return end

	BI:ToggleSettings()
end

local function InitializeCallback()
	BI:Initialize()
end

E:RegisterModule(BI:GetName(), InitializeCallback)