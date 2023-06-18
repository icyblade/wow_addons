local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local band = bit.band

local function LoadSkin()
	if not E.private.enhanced.animatedAchievementBars then return end

	local function AnimationStatusBar(bar, noNumber)
		bar.anim = CreateAnimationGroup(bar)
		bar.anim.progress = bar.anim:CreateAnimation("Progress")
		bar.anim.progress:SetSmoothing("Out")
		bar.anim.progress:SetDuration(1.7)

		bar.anim.color = bar.anim:CreateAnimation("Color")
		bar.anim.color:SetSmoothing("Out")
		bar.anim.color:SetColorType("Statusbar")
		bar.anim.color:SetDuration(1.7)
		bar.anim.color.StartR, bar.anim.color.StartG, bar.anim.color.StartB = 1, 0, 0

		if not noNumber then
			bar.anim2 = CreateAnimationGroup(_G[bar:GetName().."Text"])
			bar.anim2.number = bar.anim2:CreateAnimation("Number")
			bar.anim2.number:SetDuration(1.7)
		end
	end

	local function PlayAnimationStatusBar(bar, max, value, noNumber)
		if bar.anim:IsPlaying() or (bar.anim2 and bar.anim2:IsPlaying()) then
			bar.anim:Stop()
			if not noNumber then
				bar.anim2:Stop()
			end
		end
		bar:SetValue(0)
		bar.anim.progress:SetChange(value)

		local r, g, b = E:ColorGradient(value / max, 1, 0, 0, 1, 1, 0, 0, 1, 0)
		bar.anim.color:Reset()
		bar.anim.color:SetChange(r, g, b)
		bar.anim:Play()

		if not noNumber then
			bar.anim2.number:SetPostfix("/"..max)
			bar.anim2.number:SetChange(value)
			bar.anim2:Play()
		end
	end

	AnimationStatusBar(AchievementFrameSummaryCategoriesStatusBar)
	AnimationStatusBar(AchievementFrameComparisonSummaryPlayerStatusBar)
	AnimationStatusBar(AchievementFrameComparisonSummaryFriendStatusBar)

	for i = 1, 8 do
		local frame = _G["AchievementFrameSummaryCategoriesCategory"..i]
		AnimationStatusBar(frame)
	end

	hooksecurefunc("AchievementFrameCategory_StatusBarTooltip", function(self)
		local index = GameTooltip.shownStatusBars
		local name = GameTooltip:GetName().."StatusBar"..index
		local statusBar = _G[name]
		if not statusBar then return end

		if not statusBar.anim then
			AnimationStatusBar(statusBar)
		end

		PlayAnimationStatusBar(statusBar, self.numAchievements, self.numCompleted)
	end)

	hooksecurefunc("AchievementFrameComparison_UpdateStatusBars", function(id)
		local numAchievements, numCompleted = GetCategoryNumAchievements(id)
		local statusBar = AchievementFrameComparisonSummaryPlayerStatusBar
		PlayAnimationStatusBar(statusBar, numAchievements, numCompleted)

		local friendCompleted = GetComparisonCategoryNumAchievements(id)
		statusBar = AchievementFrameComparisonSummaryFriendStatusBar
		PlayAnimationStatusBar(statusBar, numAchievements, friendCompleted)
	end)

	hooksecurefunc("AchievementFrameSummaryCategoriesStatusBar_Update", function()
		local total, completed = GetNumCompletedAchievements()
		PlayAnimationStatusBar(AchievementFrameSummaryCategoriesStatusBar, total, completed)
	end)

	hooksecurefunc("AchievementFrameSummaryCategory_OnShow", function(self)
		local totalAchievements, totalCompleted = AchievementFrame_GetCategoryTotalNumAchievements(self:GetID(), true)
		PlayAnimationStatusBar(self, totalAchievements, totalCompleted)
	end)

	hooksecurefunc("AchievementButton_GetProgressBar", function(index)
		local frame = _G["AchievementFrameProgressBar"..index]
		if frame and not frame.anim then
			AnimationStatusBar(frame, true)
		end
	end)

	hooksecurefunc("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id)
		local numCriteria = GetAchievementNumCriteria(id)
		local progressBars = 0
		for i = 1, numCriteria do
			local _, _, _, quantity, reqQuantity, _, flags = GetAchievementCriteriaInfo(id, i)
			if band(flags, ACHIEVEMENT_CRITERIA_PROGRESS_BAR) == ACHIEVEMENT_CRITERIA_PROGRESS_BAR then
				progressBars = progressBars + 1
				local progressBar = AchievementButton_GetProgressBar(progressBars)
				PlayAnimationStatusBar(progressBar, reqQuantity, quantity, true)
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_AchievementUI", "Enhanced_AchievementUI", LoadSkin)