﻿local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")
local AB = E:GetModule("ActionBars")

local _G = _G
local tonumber, type = tonumber, type
local format, lower, split = string.format, string.lower, string.split

local InCombatLockdown = InCombatLockdown
local UIFrameFadeOut, UIFrameFadeIn = UIFrameFadeOut, UIFrameFadeIn
local EnableAddOn, DisableAllAddOns = EnableAddOn, DisableAllAddOns
local SetCVar = SetCVar
local ReloadUI = ReloadUI
local GuildControlGetNumRanks = GuildControlGetNumRanks
local GuildControlGetRankName = GuildControlGetRankName
local GetNumGuildMembers, GetGuildRosterInfo = GetNumGuildMembers, GetGuildRosterInfo
local GetGuildRosterLastOnline = GetGuildRosterLastOnline
local GuildUninvite = GuildUninvite
local SendChatMessage = SendChatMessage
local debugprofilestop = debugprofilestop
local UpdateAddOnCPUUsage, GetAddOnCPUUsage = UpdateAddOnCPUUsage, GetAddOnCPUUsage
local ResetCPUUsage = ResetCPUUsage
local GetAddOnInfo = GetAddOnInfo
local GetCVarBool = GetCVarBool
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT

function E:Grid(msg)
	msg = msg and tonumber(msg)
	if type(msg) == "number" and (msg <= 256 and msg >= 4) then
		E.db.gridSize = msg
		E:Grid_Show()
	elseif ElvUIGrid and ElvUIGrid:IsShown() then
		E:Grid_Hide()
	else
		E:Grid_Show()
	end
end

function E:LuaError(msg)
	msg = lower(msg)
	if msg == "on" then
		DisableAllAddOns()
		EnableAddOn("ElvUI")
		EnableAddOn("ElvUI_OptionsUI")
		SetCVar("scriptErrors", 1)
		ReloadUI()
	elseif msg == "off" then
		SetCVar("scriptErrors", 0)
		E:Print("Lua errors off.")
	else
		E:Print("/luaerror on - /luaerror off")
	end
end

function E:BGStats()
	DT.ForceHideBGStats = nil
	DT:LoadDataTexts()

	E:Print(L["Battleground datatexts will now show again if you are inside a battleground."])
end

local function OnCallback(command)
	MacroEditBox:GetScript("OnEvent")(MacroEditBox, "EXECUTE_CHAT_LINE", command)
end

function E:DelayScriptCall(msg)
	local secs, command = msg:match("^(%S+)%s+(.*)$")
	secs = tonumber(secs)
	if (not secs) or (#command == 0) then
		self:Print("usage: /in <seconds> <command>")
		self:Print("example: /in 1.5 /say hi")
	else
		E:Delay(secs, OnCallback, command)
	end
end

function FarmMode()
	if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT) return end
	if not E.private.general.minimap.enable then return end

	if Minimap:IsShown() then
		UIFrameFadeOut(Minimap, 0.3)
		UIFrameFadeIn(FarmModeMap, 0.3)
		Minimap.fadeInfo.finishedFunc = function() Minimap:Hide() _G.MinimapZoomIn:Click() _G.MinimapZoomOut:Click() Minimap:SetAlpha(1) end
		FarmModeMap.enabled = true
	else
		UIFrameFadeOut(FarmModeMap, 0.3)
		UIFrameFadeIn(Minimap, 0.3)
		FarmModeMap.fadeInfo.finishedFunc = function() FarmModeMap:Hide() _G.MinimapZoomIn:Click() _G.MinimapZoomOut:Click() Minimap:SetAlpha(1) end
		FarmModeMap.enabled = false
	end
end

function E:FarmMode(msg)
	if E.private.general.minimap.enable ~= true then return end

	if msg and type(tonumber(msg)) == "number" and tonumber(msg) <= 500 and tonumber(msg) >= 20 and not InCombatLockdown() then
		E.db.farmSize = tonumber(msg)
		FarmModeMap:Size(tonumber(msg))
	end

	FarmMode()
end

-- make this a locale later?
local MassKickMessage = "Guild Cleanup Results: Removed all guild members below rank %s, that have a minimal level of %s, and have not been online for at least: %s days."
function E:MassGuildKick(msg)
	local minLevel, minDays, minRankIndex = split(",", msg)
	minRankIndex = tonumber(minRankIndex)
	minLevel = tonumber(minLevel)
	minDays = tonumber(minDays)

	if not minLevel or not minDays then
		E:Print("Usage: /cleanguild <minLevel>, <minDays>, [<minRankIndex>]")
		return
	end

	if minDays > 31 then
		E:Print("Maximum days value must be below 32.")
		return
	end

	if not minRankIndex then
		minRankIndex = GuildControlGetNumRanks() - 1
	end

	for i = 1, GetNumGuildMembers() do
		local name, _, rankIndex, level, _, _, note, officerNote, connected, _, classFileName = GetGuildRosterInfo(i)
		local minLevelx = minLevel

		if classFileName == "DEATHKNIGHT" then
			minLevelx = minLevelx + 55
		end

		if not connected then
			local years, months, days = GetGuildRosterLastOnline(i)
			if days ~= nil and ((years > 0 or months > 0 or days >= minDays) and rankIndex >= minRankIndex)
			and note ~= nil and officerNote ~= nil and (level <= minLevelx) then
				GuildUninvite(name)
			end
		end
	end

	SendChatMessage(format(MassKickMessage, GuildControlGetRankName(minRankIndex), minLevel, minDays), "GUILD")
end

local num_frames = 0
local function OnUpdate()
	num_frames = num_frames + 1
end
local f = CreateFrame("Frame")
f:Hide()
f:SetScript("OnUpdate", OnUpdate)

local toggleMode, debugTimer, cpuImpactMessage = false, 0, "Consumed %sms per frame. Each frame took %sms to render."
function E:GetCPUImpact()
	if not GetCVarBool("scriptProfile") then
		E:Print("For `/cpuimpact` to work, you need to enable script profiling via: `/console scriptProfile 1` then reload. Disable after testing by setting it back to 0.")
		return
	end

	if not toggleMode then
		ResetCPUUsage()
		toggleMode, num_frames, debugTimer = true, 0, debugprofilestop()
		self:Print("CPU Impact being calculated, type /cpuimpact to get results when you are ready.")
		f:Show()
	else
		f:Hide()
		local ms_passed = debugprofilestop() - debugTimer
		UpdateAddOnCPUUsage()

		local per, passed = ((num_frames == 0 and 0) or (GetAddOnCPUUsage("ElvUI") / num_frames)), ((num_frames == 0 and 0) or (ms_passed / num_frames))
		self:Print(format(cpuImpactMessage, per and per > 0 and format("%.3f", per) or 0, passed and passed > 0 and format("%.3f", passed) or 0))
		toggleMode = false
	end
end

function E:EHelp()
	print(L["EHELP_COMMANDS"])
end

local BLIZZARD_ADDONS = {
	"Blizzard_AchievementUI",
	"Blizzard_ArchaeologyUI",
	"Blizzard_ArenaUI",
	"Blizzard_AuctionUI",
	"Blizzard_AuthChallengeUI",
	"Blizzard_BarbershopUI",
	"Blizzard_BattlefieldMinimap",
	"Blizzard_BindingUI",
	"Blizzard_BlackMarketUI",
	"Blizzard_Calendar",
	"Blizzard_ChallengesUI",
	"Blizzard_ClientSavedVariables",
	"Blizzard_CombatLog",
	"Blizzard_CombatText",
	"Blizzard_CompactRaidFrames",
	"Blizzard_CUFProfiles",
	"Blizzard_DebugTools",
	"Blizzard_EncounterJournal",
	"Blizzard_GlyphUI",
	"Blizzard_GMChatUI",
	"Blizzard_GMSurveyUI",
	"Blizzard_GuildBankUI",
	"Blizzard_GuildControlUI",
	"Blizzard_GuildUI",
	"Blizzard_InspectUI",
	"Blizzard_ItemAlterationUI",
	"Blizzard_ItemSocketingUI",
	"Blizzard_ItemUpgradeUI",
	"Blizzard_LookingForGuildUI",
	"Blizzard_MacroUI",
	"Blizzard_MovePad",
	"Blizzard_PetBattleUI",
	"Blizzard_PetJournal",
	"Blizzard_PVPUI",
	"Blizzard_QuestChoice",
	"Blizzard_RaidUI",
	"Blizzard_ReforgingUI",
	"Blizzard_StoreUI",
	"Blizzard_TalentUI",
	"Blizzard_TimeManager",
	"Blizzard_TokenUI",
	"Blizzard_TradeSkillUI",
	"Blizzard_TrainerUI",
	"Blizzard_VoidStorageUI"
}

function E:EnableBlizzardAddOns()
	for _, addon in pairs(BLIZZARD_ADDONS) do
		local reason = select(5, GetAddOnInfo(addon))
		if reason == "DISABLED" then
			EnableAddOn(addon)
			E:Print("The following addon was re-enabled:", addon)
		end
	end
end

do -- Blizzard Commands
	-- ReloadUI: /rl, /reloadui, /reload  NOTE: /reload is from SLASH_RELOAD
	if not SlashCmdList.RELOADUI then
		SLASH_RELOADUI1 = "/rl"
		SLASH_RELOADUI2 = "/reloadui"
		SlashCmdList.RELOADUI = ReloadUI
	end
end

function E:LoadCommands()
	self:RegisterChatCommand("in", "DelayScriptCall")
	self:RegisterChatCommand("ec", "ToggleOptionsUI")
	self:RegisterChatCommand("elvui", "ToggleOptionsUI")
	self:RegisterChatCommand("cpuimpact", "GetCPUImpact")
	self:RegisterChatCommand("cpuusage", "GetTopCPUFunc")
	-- cpuusage args: module, showall, delay, minCalls
	--- Example1: /cpuusage all
	--- Example2: /cpuusage Bags true
	--- Example3: /cpuusage UnitFrames nil 50 25
	---- Note: showall, delay, and minCalls will default if not set
	---- arg1 can be 'all' this will scan all registered modules!

	self:RegisterChatCommand("bgstats", "BGStats")
	self:RegisterChatCommand("hellokitty", "HelloKittyToggle")
	self:RegisterChatCommand("hellokittyfix", "HelloKittyFix")
	self:RegisterChatCommand("harlemshake", "HarlemShakeToggle")
	self:RegisterChatCommand("luaerror", "LuaError")
	self:RegisterChatCommand("egrid", "Grid")
	self:RegisterChatCommand("moveui", "ToggleMoveMode")
	self:RegisterChatCommand("resetui", "ResetUI")
	self:RegisterChatCommand("farmmode", "FarmMode")
	self:RegisterChatCommand("cleanguild", "MassGuildKick")
	self:RegisterChatCommand("enableblizzard", "EnableBlizzardAddOns")
	self:RegisterChatCommand("estatus", "ShowStatusReport")
	self:RegisterChatCommand("ehelp", "EHelp")
	self:RegisterChatCommand("ecommands", "EHelp")

	if E.private.actionbar.enable then
		self:RegisterChatCommand("kb", AB.ActivateBindMode)
	end
end