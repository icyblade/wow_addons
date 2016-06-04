-- ------------------------------------------------------------------------------ --
--                           TradeSkillMaster_Destroying                          --
--           http://www.curse.com/addons/wow/tradeskillmaster_destroying          --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TSM_Destroying", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Destroying") -- loads the localization table

--Professions--
TSM.spells = {
	milling = 51005,
	prospect = 31252,
	disenchant = 13262,
}

local settingsInfo = {
	version = 1,
	global = {
		autoStack = { type = "boolean", default = true, lastModifiedVersion = 1},
		includeSoulbound = { type = "boolean", default = false, lastModifiedVersion = 1},
		deAboveVendor = { type = "boolean", default = false, lastModifiedVersion = 1},
		autoShow = { type = "boolean", default = true, lastModifiedVersion = 1},
		logDays = { type = "number", default = 14, lastModifiedVersion = 1},
		deMaxQuality = { type = "number", default = 3, lastModifiedVersion = 1},
		deAbovePrice = { type = "string", default = "0c", lastModifiedVersion = 1},
		timeFormat = { type = "string", default = "ago", lastModifiedVersion = 1},
		history = { type = "table", default = {}, lastModifiedVersion = 1},
		ignore = { type = "table", default = {}, lastModifiedVersion = 1},
		helpPlatesShown = { type = "table", default = { destroyingFrame = nil }, lastModifiedVersion = 1},
	},
}

-- Called once the player has loaded WOW.
function TSM:OnInitialize()
	-- load settings
	TSM.db = TSMAPI.Settings:Init("TradeSkillMaster_DestroyingDB", settingsInfo)
	
	-- create shortcuts to all the modules
	for moduleName, module in pairs(TSM.modules) do
		TSM[moduleName] = module
	end

	-- register this module with TSM
	TSM:RegisterModule()

	-- update for TSM3
	for _, spellData in pairs(TSM.db.global.history) do
		for _, deInfo in ipairs(spellData) do
			deInfo.item = TSMAPI.Item:ToItemString(deInfo.item)
		end
	end
	local newIgnore = {}
	for itemString, value in pairs(TSM.db.global.ignore) do
		newIgnore[TSMAPI.Item:ToItemString(itemString)] = value
	end
	TSM.db.global.ignore = newIgnore

	-- request itemInfo for everything in the disenchant log
	local deSpellName = GetSpellInfo(TSM.spells.disenchant)
	if deSpellName and TSM.db.global.history[deSpellName] then
		for _, deInfo in ipairs(TSM.db.global.history[deSpellName]) do
			TSMAPI.Item:GetInfo(deInfo.item)
		end
	end
end

-- registers this module with TSM by first setting all fields and then calling TSMAPI:NewModule().
function TSM:RegisterModule()
	TSM.icons = {
		{ side = "module", desc = "Destroying", slashCommand = "destroying", callback = "Options:Load", icon = "Interface\\Icons\\INV_Gizmo_RocketBoot_Destroyed_02" },
	}
	TSM.moduleOptions = { callback = "Options:LoadOptions" }
	TSM.slashCommands = {
		{ key = "destroy", label = L["Opens the Destroying frame if there's stuff in your bags to be destroyed."], callback = "GUI:ShowFrame" },
	}

	TSMAPI:NewModule(TSM)
end

-- determines if an item is millable or prospectable
local destroyCache = {}
function TSM:IsDestroyable(itemString)
	if destroyCache[itemString] then
		return unpack(destroyCache[itemString])
	end

	-- disenchanting
	local quality, iType, iSubType = TSMAPI.Util:Select({ 3, 6, 7 }, TSMAPI.Item:GetInfo(itemString))
	if TSMAPI.Item:IsDisenchantable(itemString) and (quality >= 2 and quality <= TSM.db.global.deMaxQuality) then
		destroyCache[itemString] = { IsSpellKnown(TSM.spells.disenchant) and GetSpellInfo(TSM.spells.disenchant), 1 }
		return unpack(destroyCache[itemString])
	end

	local TRADE_GOODS = select(6, GetAuctionItemClasses())
	local METAL_AND_STONE, HERB = TSMAPI.Util:Select({ 4, 6 }, GetAuctionItemSubClasses(6))
	if iType ~= TRADE_GOODS or (iSubType ~= METAL_AND_STONE and iSubType ~= HERB) then
		destroyCache[itemString] = {}
		return unpack(destroyCache[itemString])
	end

	-- milling
	for _, targetItem in ipairs(TSMAPI.Conversions:GetTargetItemsByMethod("mill")) do
		local herbs = TSMAPI.Conversions:GetData(targetItem)
		if herbs[itemString] then
			local isKnown = IsSpellKnown(TSM.spells.milling) or TSMAPI.Inventory:GetBagQuantity("i:114942") > 0
			destroyCache[itemString] = { isKnown and GetSpellInfo(TSM.spells.milling), 5 }
			return unpack(destroyCache[itemString])
		end
	end

	-- prospecting
	for _, targetItem in ipairs(TSMAPI.Conversions:GetTargetItemsByMethod("prospect")) do
		local gems = TSMAPI.Conversions:GetData(targetItem)
		if gems[itemString] then
			destroyCache[itemString] = { IsSpellKnown(TSM.spells.prospect) and GetSpellInfo(TSM.spells.prospect), 5 }
			return unpack(destroyCache[itemString])
		end
	end

	return destroyCache[itemString] and unpack(destroyCache[itemString]) or nil
end

function TSM:HasDraenicEnchanting()
	local profession1, profession2 = GetProfessions()

	-- check first profession
	if profession1 then
		local skillName, _, level, maxLevel = GetProfessionInfo(profession1)
		if skillName == GetSpellInfo(7411) and level >= 600 and maxLevel == 700 then
			return true
		end
	end

	-- check second profession
	if profession2 then
		local skillName, _, level, maxLevel = GetProfessionInfo(profession2)
		if skillName == GetSpellInfo(7411) and level >= 600 and maxLevel == 700 then
			return true
		end
	end
end