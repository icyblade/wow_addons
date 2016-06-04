-- ------------------------------------------------------------------------------ --
--                            TradeSkillMaster_Mailing                            --
--            http://www.curse.com/addons/wow/tradeskillmaster_mailing            --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- register this file with Ace Libraries
local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TSM_Mailing", "AceEvent-3.0", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillMaster_Mailing") -- loads the localization table

TSM.SPELLING_WARNING = "|cffff0000"..L["BE SURE TO SPELL THE NAME CORRECTLY!"].."|r"
local private = {lootIndex=1, recheckTime=1, allowTimerStart=true}

local settingsInfo = {
	version = 1,
	global = {
		defaultMailTab = { type = "boolean", default = true, lastModifiedVersion = 1 },
		autoCheck = { type = "boolean", default = true, lastModifiedVersion = 1 },
		displayMoneyCollected = { type = "boolean", default = true, lastModifiedVersion = 1 },
		sendItemsIndividually = { type = "boolean", default = false, lastModifiedVersion = 1 },
		deleteEmptyNPCMail = { type = "boolean", default = false, lastModifiedVersion = 1 },
		inboxMessages = { type = "boolean", default = true, lastModifiedVersion = 1 },
		sendMessages = { type = "boolean", default = true, lastModifiedVersion = 1 },
		showReloadBtn = { type = "boolean", default = true, lastModifiedVersion = 1 },
		resendDelay = { type = "number", default = 1, lastModifiedVersion = 1 },
		sendDelay = { type = "number", default = 0.5, lastModifiedVersion = 1 },
		defaultPage = { type = "number", default = 1, lastModifiedVersion = 1 },
		keepMailSpace = { type = "number", default = 0, lastModifiedVersion = 1 },
		deMaxQuality = { type = "number", default = 2, lastModifiedVersion = 1 },
		openMailSound = { type = "string", default = TSMAPI:GetNoSoundKey(), lastModifiedVersion = 1 },
		helpPlatesShown = { type = "table", default = { inbox = nil, groups = nil, quickSend = nil, other = nil }, lastModifiedVersion = 1 },
	},
	factionrealm = {
		deMailTarget = { type = "string", default = "", lastModifiedVersion = 1 },
	},
	char = {
		goldMailTarget = { type = "string", default = "", lastModifiedVersion = 1 },
		goldKeepAmount = { type = "number", default = 1000000, lastModifiedVersion = 1 },
	},
}
local operationDefaults = {
	maxQtyEnabled = nil,
	maxQty = 10,
	target = "",
	restock = nil, -- take into account how many the target already has
	restockSources = {guild=nil, bank=nil},
	keepQty = 0,
}

function TSM:OnEnable()
	-- load settings
	TSM.db = TSMAPI.Settings:Init("TradeSkillMaster_MailingDB", settingsInfo)
	
	for moduleName, module in pairs(TSM.modules) do
		TSM[moduleName] = module
	end
	
	-- register this module with TSM
	TSM:RegisterModule()
	
	-- TSM3 conversions
	for _ in TSMAPI:GetTSMProfileIterator() do
		for _, operation in pairs(TSM.operations) do
			if not operation.restockSources then
				operation.restockSources = {guild=operation.restockGBank}
				operation.restockGBank = nil
			end
		end
	end
end

-- registers this module with TSM by first setting all fields and then calling TSMAPI:NewModule().
function TSM:RegisterModule()
	TSM.operations = { maxOperations = 30, callbackOptions = "Options:GetOperationOptionsInfo", callbackInfo = "GetOperationInfo", defaults = operationDefaults }
	TSM.moduleOptions = {callback="Options:ShowOptions"}
	TSM.moduleAPIs = {
		{key="mailItems", callback="AutoMail:SendItems"},
	}
	TSM.bankUiButton = { callback = "BankUI:createTab" }
	
	TSMAPI:NewModule(TSM)
end

function TSM:GetOperationInfo(operationName)
	local operation = TSM.operations[operationName]
	if not operation then return end
	if operation.target == "" then return end
	
	if operation.maxQtyEnabled then
		return format(L["Mailing up to %d to %s."], operation.maxQty, operation.target)
	else
		return format(L["Mailing all to %s."], operation.target)
	end
end