local E, L, V, P, G = unpack(select(2, ...))

local _G = _G
local tinsert, strmatch = tinsert, strmatch
local select, tonumber, format = select, tonumber, format
local next, max, wipe = next, max, wipe
local utf8sub = string.utf8sub

local UnitIsUnit = UnitIsUnit
local GetCVarBool = GetCVarBool
local GetItemInfo = GetItemInfo
local GetAverageItemLevel = GetAverageItemLevel
local GetInventoryItemLink = GetInventoryItemLink
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInspectSpecialization = GetInspectSpecialization
local RETRIEVING_ITEM_INFO = RETRIEVING_ITEM_INFO

local MATCH_ITEM_LEVEL = gsub(ITEM_LEVEL, "%%d", "(%%d+)")
local MATCH_ENCHANT = gsub(ENCHANTED_TOOLTIP_LINE, "%%s", "(.+)")

local X2_INVTYPES = {
	INVTYPE_2HWEAPON = true,
	INVTYPE_RANGEDRIGHT = true,
	INVTYPE_RANGED = true
}
local X2_EXCEPTIONS =
E.locale == "deDE" and "Zauberstäbe" or
E.locale == "ruRU" and "Жезлы" or
E.locale == "frFR" and "Baguettes" or
E.locale == "koKR" and "마법봉류" or
E.locale == "zhCN" and "魔杖" or
E.locale == "zhTW" and "魔杖" or
E.locale == "esES" and "Varitas" or
E.locale == "esMX" and "Varitas" or
E.locale == "ptBR" and "Varinhas" or
E.locale == "itIT" and "Bacchette" or
"Wands"

local ARMOR_SLOTS = {1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}

function E:InspectGearSlot(line, lineText, slotInfo)
	local enchant = strmatch(lineText, MATCH_ENCHANT)

	if enchant then
		slotInfo.enchantText = enchant
		slotInfo.enchantTextShort = utf8sub(enchant, 1, 18)

		local lr, lg, lb = line:GetTextColor()
		slotInfo.enchantColors[1] = lr
		slotInfo.enchantColors[2] = lg
		slotInfo.enchantColors[3] = lb
	end

	local itemLevel = lineText and strmatch(lineText, MATCH_ITEM_LEVEL)

	if itemLevel then
		slotInfo.iLvl = tonumber(itemLevel)

		local tr, tg, tb = ElvUI_ScanTooltipTextLeft1:GetTextColor()
		slotInfo.itemLevelColors[1] = tr
		slotInfo.itemLevelColors[2] = tg
		slotInfo.itemLevelColors[3] = tb
	end
end

function E:GetGearSlotInfo(unit, slot, deepScan)
	local tt = E.ScanTooltip
	tt:SetOwner(UIParent, "ANCHOR_NONE")
	tt:SetInventoryItem(unit, slot)
	tt:Show()

	if not tt.slotInfo then tt.slotInfo = {} else wipe(tt.slotInfo) end
	local slotInfo = tt.slotInfo

	if deepScan then
		slotInfo.gems = E:ScanTooltipTextures(true, true)

		if not tt.enchantColors then tt.enchantColors = {} else wipe(tt.enchantColors) end
		if not tt.itemLevelColors then tt.itemLevelColors = {} else wipe(tt.itemLevelColors) end

		slotInfo.enchantColors = tt.enchantColors
		slotInfo.itemLevelColors = tt.itemLevelColors

		for x = 1, tt:NumLines() do
			local line = _G["ElvUI_ScanTooltipTextLeft"..x]

			if line then
				local lineText = line:GetText()

				if x == 1 and lineText == RETRIEVING_ITEM_INFO then
					return "tooSoon"
				else
					E:InspectGearSlot(line, lineText, slotInfo)
				end
			end
		end
	else
		local firstLine = ElvUI_ScanTooltipTextLeft1:GetText()
		if firstLine == RETRIEVING_ITEM_INFO then
			return "tooSoon"
		end

		local colorblind = GetCVarBool("colorblindmode") and 4 or 3

		for x = 2, colorblind do
			local line = _G["ElvUI_ScanTooltipTextLeft"..x]
			if line then
				local lineText = line:GetText()
				local itemLevel = lineText and strmatch(lineText, MATCH_ITEM_LEVEL)

				if itemLevel then
					slotInfo.iLvl = tonumber(itemLevel)
				end
			end
		end
	end

	tt:Hide()

	return slotInfo
end

--Credit ls & Acidweb
function E:CalculateAverageItemLevel(iLevelDB, unit)
	local spec = GetInspectSpecialization(unit)
	local isOK, total, link = true, 0

	if not spec or spec == 0 then
		isOK = false
	end

	-- Armor
	for _, id in next, ARMOR_SLOTS do
		link = GetInventoryItemLink(unit, id)
		if link then
			local cur = iLevelDB[id]
			if cur and cur > 0 then
				total = total + cur
			end
		elseif GetInventoryItemTexture(unit, id) then
			isOK = false
		end
	end

	-- Main hand
	local mainItemLevel, mainQuality, mainEquipLoc, itemSubType, _ = 0
	link = GetInventoryItemLink(unit, 16)
	if link then
		mainItemLevel = iLevelDB[16]
		_, _, mainQuality, _, _, _, itemSubType, _, mainEquipLoc = GetItemInfo(link)
	elseif GetInventoryItemTexture(unit, 16) then
		isOK = false
	end

	-- Off hand
	local offItemLevel, offEquipLoc = 0
	link = GetInventoryItemLink(unit, 17)
	if link then
		offItemLevel = iLevelDB[17]
		_, _, _, _, _, _, _, _, offEquipLoc = GetItemInfo(link)
	elseif GetInventoryItemTexture(unit, 17) then
		isOK = false
	end

	if mainItemLevel and offItemLevel then
		if (mainQuality == 6) or (not offEquipLoc and X2_INVTYPES[mainEquipLoc] and itemSubType ~= X2_EXCEPTIONS and spec ~= 72) then
			mainItemLevel = max(mainItemLevel, offItemLevel)
			total = total + mainItemLevel * 2
		else
			total = total + mainItemLevel + offItemLevel
		end
	end

	-- at the beginning of an arena match no info might be available,
	-- so despite having equipped gear a person may appear naked
	if total == 0 then
		isOK = false
	end

	return isOK and format("%0.2f", E:Round(total / 16, 2))
end

function E:GetPlayerItemLevel()
	return format("%0.2f", E:Round((select(2, GetAverageItemLevel())), 2))
end

do
	local iLevelDB, tryAgain = {}, {}
	function E:GetUnitItemLevel(unit)
		if UnitIsUnit("player", unit) then
			return E:GetPlayerItemLevel()
		end

		if next(iLevelDB) then wipe(iLevelDB) end
		if next(tryAgain) then wipe(tryAgain) end

		for i = 1, 17 do
			if i ~= 4 then
				local slotInfo = E:GetGearSlotInfo(unit, i)
				if slotInfo == "tooSoon" then
					tinsert(tryAgain, i)
				else
					iLevelDB[i] = slotInfo.iLvl
				end
			end
		end

		if next(tryAgain) then
			return "tooSoon", unit, tryAgain, iLevelDB
		end

		return E:CalculateAverageItemLevel(iLevelDB, unit)
	end
end