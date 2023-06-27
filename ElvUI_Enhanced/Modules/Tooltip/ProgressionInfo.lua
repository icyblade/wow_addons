local E, L, V, P, G = unpack(ElvUI)
local PI = E:NewModule("Enhanced_ProgressionInfo", "AceHook-3.0", "AceEvent-3.0")
local TT = E:GetModule("Tooltip")

local find, format = string.find, string.format
local pairs, ipairs, select, tonumber = pairs, ipairs, select, tonumber

local CanInspect = CanInspect
local ClearAchievementComparisonUnit = ClearAchievementComparisonUnit
local GetComparisonStatistic = GetComparisonStatistic
local GetStatistic = GetStatistic
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local SetAchievementComparisonUnit = SetAchievementComparisonUnit
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitIsPlayer = UnitIsPlayer
local UnitLevel = UnitLevel
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL

local difficulties = {"H", "N"}

local tiers = {
	["DS"] = {
		{6154, 6156, 6158, 6160, 6162, 6164, 6166, 6168},	-- Heroic
		{6153, 6155, 6157, 6159, 6161, 6163, 6165, 6167}	-- Normal
	},
	["FL"] = {
		{5965, 5967, 5969, 5971, 5973, 5975, 5977},			-- Heroic
		{5964, 5966, 5968, 5970, 5972, 5974, 5976}			-- Normal
	},
	["BH"] = {
		{},
		{5578, 5981, 6170}									-- Normal
	},
	["TOTFW"] = {
		{5574, 5577},										-- Heroic
		{5575, 5576}										-- Normal
	},
	["BT"] = {
		{5553, 5568, 5570, 5571, 5573},						-- Heroic
		{5554, 5567, 5569, 5572}							-- Normal
	},
	["BWD"] = {
		{5556, 5558, 5560, 5562, 5563, 5566},				-- Heroic
		{5555, 5557, 5559, 5561, 5564, 5565}				-- Normal
	}
}

local progressCache = {}

local function GetEntryCount(tab)
	local i = 0
	for _ in pairs(tab) do
		i = i + 1
	end
	return i
end

local function GetProgression(guid)
	local statFunc = guid == E.myguid and GetStatistic or GetComparisonStatistic
	local total, kills, killed

	for tier in pairs(tiers) do
		progressCache[guid].header[tier] = {}
		progressCache[guid].info[tier] = {}

		for i, difficulty in ipairs(difficulties) do
			if GetEntryCount(tiers[tier][i]) > 0 then
				total, killed = 0, 0

				for _, statsID in ipairs(tiers[tier][i]) do
					kills = tonumber(statFunc(statsID))
					total = total + 1

					if kills and kills > 0 then
						killed = killed + 1
					end
				end

				if killed > 0 then
					progressCache[guid].header[tier][i] = format("%s [%s]:", L[tier], difficulty)
					progressCache[guid].info[tier][i] = format("%d/%d", killed, total)

					if killed == total then break end
				end
			end
		end
	end
end

local function UpdateProgression(guid)
	progressCache[guid] = progressCache[guid] or {}
	progressCache[guid].header = progressCache[guid].header or {}
	progressCache[guid].info = progressCache[guid].info or {}
	progressCache[guid].timer = GetTime()

	GetProgression(guid)
end

local function SetProgressionInfo(guid, tt)
	if progressCache[guid] then
		local updated = 0

		for i = 1, tt:NumLines() do
			local leftTipText = _G["GameTooltipTextLeft"..i]

			for tier in pairs(tiers) do
				if E.db.enhanced.tooltip.progressInfo.tiers[tier] then
					for j, difficulty in ipairs(difficulties) do
						if GetEntryCount(tiers[tier][j]) > 0 then
							if leftTipText:GetText() and find(leftTipText:GetText(), L[tier]) and find(leftTipText:GetText(), difficulty) then
								local rightTipText = _G["GameTooltipTextRight"..i]
								leftTipText:SetText(progressCache[guid].header[tier][j])
								rightTipText:SetText(progressCache[guid].info[tier][j])
								updated = 1
							end
						end
					end
				end
			end
		end

		if updated == 1 then return end

		for tier in pairs(tiers) do
			if E.db.enhanced.tooltip.progressInfo.tiers[tier] then
				for i, difficulty in ipairs(difficulties) do
					if GetEntryCount(tiers[tier][i]) > 0 then
						tt:AddDoubleLine(progressCache[guid].header[tier][i], progressCache[guid].info[tier][i], nil, nil, nil, 1, 1, 1)
					end
				end
			end
		end
	end
end

function PI:INSPECT_ACHIEVEMENT_READY(GUID)
	if UnitExists("mouseover") then
		UpdateProgression(GUID)
		GameTooltip:SetUnit("mouseover")
	end

	ClearAchievementComparisonUnit()
	self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
end

function PI:MODIFIER_STATE_CHANGED(_, key)
	if (key == format("L%s", self.modifier) or key == format("R%s", self.modifier)) and UnitExists("mouseover") then
		GameTooltip:SetUnit("mouseover")
	end
end

local function ShowInspectInfo(tt)
	if InCombatLockdown() then return end

	local modifier = E.db.enhanced.tooltip.progressInfo.modifier
	if modifier ~= "ALL" and not ((modifier == "SHIFT" and IsShiftKeyDown()) or (modifier == "CTRL" and IsControlKeyDown()) or (modifier == "ALT" and IsAltKeyDown())) then return end

	local unit = select(2, tt:GetUnit())
	if not unit or not UnitIsPlayer(unit) then return end

	if unit == "player" and not E.db.enhanced.tooltip.progressInfo.checkPlayer then return end

	local level = UnitLevel(unit)
	if not level or level < MAX_PLAYER_LEVEL then return end

	if not CanInspect(unit, false) then return end

	local guid = UnitGUID(unit)

	if not progressCache[guid] or (GetTime() - progressCache[guid].timer) > 600 then
		if guid == E.myguid then
			UpdateProgression(guid)
		else
			local self = E.private.tooltip.enable and TT or GameTooltip

			ClearAchievementComparisonUnit()

			if not self.loadedComparison and select(2, IsAddOnLoaded("Blizzard_AchievementUI")) then
				AchievementFrame_DisplayComparison(unit)
				HideUIPanel(AchievementFrame)
				ClearAchievementComparisonUnit()
				self.loadedComparison = true
			end

			self.compareGUID = guid

			if SetAchievementComparisonUnit(unit) then
				PI:RegisterEvent("INSPECT_ACHIEVEMENT_READY", "INSPECT_ACHIEVEMENT_READY", self.compareGUID)
			end
			return
		end
	end

	SetProgressionInfo(guid, tt)
end

function PI:UpdateSettings()
	local db = E.db.enhanced.tooltip.progressInfo.tiers
	local enabled

	for _, state in pairs(db) do
		enabled = state
		if enabled then break end
	end

	if enabled then
		self:ToggleState()
	else
		self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
		self:UnhookAll()
	end
end

function PI:UpdateModifier()
	self.modifier = E.db.enhanced.tooltip.progressInfo.modifier

	if self.modifier == "ALL" then
		self:UnregisterEvent("MODIFIER_STATE_CHANGED")
	else
		self:RegisterEvent("MODIFIER_STATE_CHANGED")
	end
end

function PI:ToggleState()
	if E.db.enhanced.tooltip.progressInfo.enable then
		if E.private.tooltip.enabled and TT then
			if not self:IsHooked(TT, "GameTooltip_OnTooltipSetUnit", ShowInspectInfo) then
				self:SecureHook(TT, "GameTooltip_OnTooltipSetUnit", ShowInspectInfo)
			end
		else
			if not self:IsHooked(GameTooltip, "OnTooltipSetUnit", ShowInspectInfo) then
				self:HookScript(GameTooltip, "OnTooltipSetUnit", ShowInspectInfo)
			end
		end

		self:UpdateModifier()
	else
		self:UnregisterAllEvents()
		self:UnhookAll()
	end
end

function PI:Initialize()
	if not E.db.enhanced.tooltip.progressInfo.enable then return end

	self:ToggleState()
end

local function InitializeCallback()
	PI:Initialize()
end

E:RegisterModule(PI:GetName(), InitializeCallback)