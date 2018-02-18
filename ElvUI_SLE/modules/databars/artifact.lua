local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local DB = SLE:GetModule("DataBars")
--GLOBALS: hooksecurefunc
local HasArtifactEquipped = HasArtifactEquipped
local MainMenuBar_GetNumArtifactTraitsPurchasableFromXP = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP
local C_ArtifactUIGetEquippedArtifactInfo = C_ArtifactUI.GetEquippedArtifactInfo

local ARTIFACT_XP_GAIN = ARTIFACT_XP_GAIN

DB.Art = {
	Strings = {},
	Styles = {
		["STYLE1"] = "|T%s:%s|t|cffe6cc80%s|r +%s.",
		["STYLE2"] = "|T%s:%s|t|cffe6cc80%s|r |cff0CD809+%s|r.",
	},
}

local function UpdateArtifact(self, event)
	if not E.db.databars.artifact.enable then return end
	if not E.db.sle.databars.artifact.longtext then return end
	local bar = self.artifactBar

	local hasArtifact = HasArtifactEquipped();
	if hasArtifact then
		local text = ''
		local totalXP, pointsSpent = T.select(5, C_ArtifactUIGetEquippedArtifactInfo());
		local tier = T.select(13, C_ArtifactUIGetEquippedArtifactInfo());
		local numPointsAvailableToSpend, xp, xpForNextPoint
		numPointsAvailableToSpend, xp, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(pointsSpent, totalXP, tier);
		if xpForNextPoint <= 0 then
			xpForNextPoint = xp
		end

		local textFormat = self.db.artifact.textFormat
		if textFormat == 'PERCENT' then
			text = T.format(numPointsAvailableToSpend > 0 and '%s%% (%s)' or '%s%%', T.floor(xp / xpForNextPoint * 100), numPointsAvailableToSpend)
		elseif textFormat == 'CURMAX' then
			text = T.format(numPointsAvailableToSpend > 0 and '%s - %s (%s)' or '%s - %s', xp, xpForNextPoint, numPointsAvailableToSpend)
		elseif textFormat == 'CURPERC' then
			text = T.format(numPointsAvailableToSpend > 0 and '%s - %s%% (%s)' or '%s - %s%%',xp, T.floor(xp / xpForNextPoint * 100), numPointsAvailableToSpend)
		elseif textFormat == 'CUR' then
			text = T.format(numPointsAvailableToSpend > 0 and '%s (%s)' or '%s', xp, numPointsAvailableToSpend)
		elseif textFormat == 'REM' then
			text = T.format(numPointsAvailableToSpend > 0 and '%s (%s)' or '%s', xpForNextPoint - xp, numPointsAvailableToSpend)
		elseif textFormat == 'CURREM' then
			text = T.format(numPointsAvailableToSpend > 0 and '%s - %s (%s)' or '%s - %s', xp, xpForNextPoint - xp, numPointsAvailableToSpend)
		end

		bar.text:SetText(text)
	end
end

function DB:PopulateArtPatterns()
	local symbols = {'%(','%)','%.','([-+])','|4.-;','%%[sd]','%%%d%$[sd]','%%(','%%)','%%.','%%%1','.-','(.-)','(.-)'}
	local pattern

	pattern = T.rgsub(ARTIFACT_XP_GAIN,T.unpack(symbols))
	T.tinsert(DB.Art.Strings, pattern)
end

function DB:FilterArtExperience(event, message, ...)
	local name, exp
	if DB.db.artifact.chatfilter.enable then
			for i = 1, #DB.Art.Strings do
				name, exp = T.match(message, DB.Art.Strings[i])
				local _, _, _, icon = C_ArtifactUIGetEquippedArtifactInfo()
				if name then
					message = T.format(DB.Art.Styles[DB.db.artifact.chatfilter.style], E.db.sle.loot.looticons.channels["CHAT_MSG_SYSTEM"] and "" or icon, DB.db.artifact.chatfilter.iconsize, name, exp)
					return false, message, ...
				end
			end
		return false, message, ...
	end
	return false, message, ...
end

function DB:ArtInit()
	DB:PopulateArtPatterns()
	hooksecurefunc(E:GetModule('DataBars'), "UpdateArtifact", UpdateArtifact)
	E:GetModule('DataBars'):UpdateArtifact()
end
