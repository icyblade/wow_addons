local E, L, V, P, G = unpack(ElvUI)
local TT = E:GetModule("Tooltip")

local _G = _G
local select, tonumber = select, tonumber
local find, format = string.find, string.format

local CanInspect = CanInspect
local ClearAchievementComparisonUnit = ClearAchievementComparisonUnit
local GetComparisonStatistic = GetComparisonStatistic
local GetStatistic = GetStatistic
local GetTime = GetTime
local SetAchievementComparisonUnit = SetAchievementComparisonUnit
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL

local tiers = {"T16", "T15"}
local levels = {{"25 Heroic", "10 Heroic"}, {"25 Normal", "10 Normal"}, {"Flex"}, {"LFR"}}

local bosses = {
	{
		{{8554, 8560, 8566, 8573, 8579, 8585, 8591, 8598, 8604, 8612, 8619, 8625, 8631, 8638}, {8553, 8559, 8565, 8571, 8578, 8584, 8590, 8597, 8603, 8610, 8618, 8624, 8630, 8637}},
		{{8552, 8558, 8564, 8570, 8577, 8583, 8589, 8596, 8602, 8609, 8617, 8623, 8629, 8636}, {8551, 8557, 8563, 8569, 8576, 8582, 8588, 8595, 8601, 8608, 8616, 8622, 8628, 8635}},
		{{8550, 8556, 8562, 8568, 8575, 8581, 8587, 8594, 8600, 8606, 8615, 8621, 8627, 8634}},
		{{8549, 8555, 8561, 8567, 8574, 8580, 8586, 8593, 8599, 8605, 8614, 8620, 8626, 8632}},
	},
	{
		{{8145, 8152, 8157, 8161, 8167, 8172, 8177, 8180, 8187, 8192, 8197, 8201, 8256}, {8144, 8151, 8156, 8162, 8166, 8171, 8176, 8181, 8186, 8191, 8196, 8202, 8203}},
		{{8143, 8150, 8155, 8160, 8165, 8170, 8175, 8182, 8185, 8190, 8195, 8200}, {8142, 8149, 8154, 8159, 8164, 8169, 8174, 8179, 8184, 8189, 8194, 8199}},
		{{0}},
		{{8141, 8148, 8153, 8158, 8163, 8168, 8173, 8178, 8183, 8188, 8193, 8198}}
	}
}

local progressCache = {}
local highest = {0, 0}

local function GetProgression(guid)
	local kills, complete, pos = 0, false, 0
	local statFunc = guid == E.myguid and GetStatistic or GetComparisonStatistic

	for tier = 1, 2 do
		for level = 1, 4 do
			for bracket = 1, (level < 3 and 2 or 1) do
				highest[bracket] = 0

				for statInfo = 1, #bosses[tier][level][bracket] do
					kills = tonumber((statFunc(bosses[tier][level][bracket][statInfo])))
					if kills and kills > 0 then
						highest[bracket] = highest[bracket] + 1
					end
				end
			end

			pos = highest[1] > highest[2] and 1 or 2

			if highest[pos] > 0 then
				progressCache[guid].header = format("%s [%s]:", levels[level][pos], tiers[tier])
				progressCache[guid].info = format("%d/%d", highest[pos], #bosses[tier][level][pos])
				complete = true
				break
			end
		end

		if complete then break end
	end
end

local function UpdateProgression(guid)
	progressCache[guid] = progressCache[guid] or {}
	progressCache[guid].timer = GetTime()

	GetProgression(guid)
end

local function SetProgressionInfo(guid, tt)
	if progressCache[guid] then
		for i = 1, tt:NumLines() do
			local leftTipText = _G["GameTooltipTextLeft"..i]

			for tier = 1, 2 do
				if leftTipText:GetText() and leftTipText:GetText():find(tiers[tier]) then
					local rightTipText = _G["GameTooltipTextRight"..i]
					leftTipText:SetText(progressCache[guid].header)
					rightTipText:SetText(progressCache[guid].info)

					return
				end
			end
		end

		tt:AddDoubleLine(progressCache[guid].header, progressCache[guid].info, nil, nil, nil, 1, 1, 1)
	end
end

function TT:INSPECT_ACHIEVEMENT_READY(_, GUID)
	if self.compareGUID ~= GUID then return end

	local unit = "mouseover"
	if UnitExists(unit) then
		UpdateProgression(GUID)
		GameTooltip:SetUnit(unit)
	end

	ClearAchievementComparisonUnit()
	self:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
end

hooksecurefunc(TT, "AddInspectInfo", function(self, tt, unit)
	if not E.db.enhanced.tooltip.progressInfo then return end
	if not unit and CanInspect(unit) then return end

	local level = UnitLevel(unit)
	if not level or level < MAX_PLAYER_LEVEL then return end

	local guid = UnitGUID(unit)
	if not guid then return end

	if not progressCache[guid] or (GetTime() - progressCache[guid].timer) > 600 then
		if guid == E.myguid then
			UpdateProgression(guid)
		else
			ClearAchievementComparisonUnit()

			if not self.loadedComparison and select(2, IsAddOnLoaded("Blizzard_AchievementUI")) then
				AchievementFrame_DisplayComparison(unit)
				HideUIPanel(AchievementFrame)
				ClearAchievementComparisonUnit()
				self.loadedComparison = true
			end

			self.compareGUID = guid

			if SetAchievementComparisonUnit(unit) then
				self:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
			end

			return
		end
	end

	SetProgressionInfo(guid, tt)
end)