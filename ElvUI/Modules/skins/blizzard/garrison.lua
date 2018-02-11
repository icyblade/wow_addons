local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G
local unpack, pairs, select = unpack, pairs, select
--WoW API / Variables
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: SquareButton_SetIcon

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true then return end

	if E.private.skins.blizzard.orderhall or E.private.skins.blizzard.garrison then
		--These hooks affect both Garrison and OrderHall, so make sure they are set even if Garrison skin is disabled
		hooksecurefunc("GarrisonMissionButton_SetRewards", function(self, _, numRewards)
			if self.numRewardsStyled == nil then
				self.numRewardsStyled = 0
			end
			while self.numRewardsStyled < numRewards do
				self.numRewardsStyled = self.numRewardsStyled + 1
				local reward = self.Rewards[self.numRewardsStyled]
				reward:GetRegions():Hide()

				if not reward.border then
					reward.border = CreateFrame("Frame", nil, reward)
					S:HandleIcon(reward.Icon, reward.border)
				end

				if reward.IconBorder then
					reward.IconBorder:SetTexture()
				end
			end

			--Set border color according to rarity of item
			for _, reward in pairs(self.Rewards) do
				if reward.border and reward.border.backdrop then
					local r, g, b
					if reward.IconBorder:IsShown() then
						--This is an item, use the color set by WoW
						r, g, b = reward.IconBorder:GetVertexColor()
					else
						--This is a currency, use the default ElvUI border color
						r, g, b = unpack(E["media"].bordercolor)
					end
					reward.border.backdrop:SetBackdropBorderColor(r, g, b)
				end
			end
		end)

		hooksecurefunc("GarrisonMissionPage_SetReward", function(frame)
			frame.BG:SetTexture()
			if not frame.backdrop then
				S:HandleIcon(frame.Icon)
			end
			if frame.IconBorder then
				frame.IconBorder:SetTexture()
			end

			--[[ Set border color according to rarity of item
			-- for _, reward in pairs(frame.Rewards) do -- WIP
				local r, g, b
				if frame.IconBorder:IsShown() then
					-- This is an item, use the color set by WoW
					r, g, b = frame.IconBorder:GetVertexColor()
				else
					-- This is a currency, use the default ElvUI border color
					r, g, b = unpack(E["media"].bordercolor)
				end
			-- end
			frame.backdrop:SetBackdropBorderColor(r, g, b)]]
			frame.Icon:SetDrawLayer("BORDER", 0)
		end)
	end

	--Stop here if Garrison skin is disabled
	if E.private.skins.blizzard.garrison ~= true then return end

	-- Building frame
	GarrisonBuildingFrame:StripTextures(true)
	GarrisonBuildingFrame.TitleText:Show()
	GarrisonBuildingFrame:CreateBackdrop("Transparent")
	S:HandleCloseButton(GarrisonBuildingFrame.CloseButton, GarrisonBuildingFrame.backdrop)
	GarrisonBuildingFrame.BuildingLevelTooltip:StripTextures()
	GarrisonBuildingFrame.BuildingLevelTooltip:SetTemplate('Transparent')

	-- Follower List
	local FollowerList = GarrisonBuildingFrame.FollowerList
	S:HandleScrollBar(FollowerList.listScroll.scrollBar)

	FollowerList:ClearAllPoints()
	FollowerList:SetPoint("BOTTOMLEFT", 24, 34)

	local scrollFrame = FollowerList.listScroll
	S:HandleScrollBar(scrollFrame.scrollBar)

	-- Capacitive display frame
	GarrisonCapacitiveDisplayFrame:StripTextures(true)
	GarrisonCapacitiveDisplayFrame:CreateBackdrop("Transparent")
	GarrisonCapacitiveDisplayFrame.Inset:StripTextures()
	S:HandleCloseButton(GarrisonCapacitiveDisplayFrame.CloseButton, GarrisonCapacitiveDisplayFrame.backdrop)
	S:HandleButton(GarrisonCapacitiveDisplayFrame.StartWorkOrderButton, true)
	S:HandleButton(GarrisonCapacitiveDisplayFrame.CreateAllWorkOrdersButton, true)
	GarrisonCapacitiveDisplayFrame.Count:StripTextures()
	S:HandleEditBox(GarrisonCapacitiveDisplayFrame.Count)
	S:HandleNextPrevButton(GarrisonCapacitiveDisplayFrame.DecrementButton)
	SquareButton_SetIcon(GarrisonCapacitiveDisplayFrame.DecrementButton, 'LEFT')
	S:HandleNextPrevButton(GarrisonCapacitiveDisplayFrame.IncrementButton)
	local CapacitiveDisplay = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay
	CapacitiveDisplay.IconBG:SetTexture()
	CapacitiveDisplay.ShipmentIconFrame.Icon:SetTexCoord(unpack(E.TexCoords))
	CapacitiveDisplay.ShipmentIconFrame.Icon:SetInside()
	--Fix unitframes appearing above work orders
	GarrisonCapacitiveDisplayFrame:SetFrameStrata("MEDIUM")
	GarrisonCapacitiveDisplayFrame:SetFrameLevel(45)

	do
		local reagentIndex = 1
		hooksecurefunc("GarrisonCapacitiveDisplayFrame_Update", function(self)
			local reagents = CapacitiveDisplay.Reagents
			local reagent = reagents[reagentIndex]
			while reagent do
				reagent.NameFrame:SetTexture()
				reagent.Icon:SetTexCoord(unpack(E.TexCoords))
				reagent.Icon:SetDrawLayer("BORDER")

				if not reagent.border then
					reagent.border = CreateFrame("Frame", nil, reagent)
					S:HandleIcon(reagent.Icon, reagent.border)
					reagent.Count:SetParent(reagent.border)
				end

				if not reagent.backdrop then
					reagent:CreateBackdrop("Default", true)
				end

				reagentIndex = reagentIndex + 1
				reagent = reagents[reagentIndex]
			end
		end)
	end

	-- Recruiter frame
	GarrisonRecruiterFrame:StripTextures(true)
	GarrisonRecruiterFrame:CreateBackdrop("Transparent")
	GarrisonRecruiterFrame.Inset:StripTextures()
	S:HandleCloseButton(GarrisonRecruiterFrame.CloseButton, GarrisonRecruiterFrame.backdrop)

	-- Recruiter Unavailable frame
	local UnavailableFrame = GarrisonRecruiterFrame.UnavailableFrame
	S:HandleButton(UnavailableFrame:GetChildren())

	-- Mission UI
	GarrisonMissionFrame:StripTextures(true)
	GarrisonMissionFrame.TitleText:Show()
	GarrisonMissionFrame:CreateBackdrop("Transparent")
	S:HandleCloseButton(GarrisonMissionFrame.CloseButton, GarrisonMissionFrame.backdrop)
	for i=1,2 do
		S:HandleTab(_G["GarrisonMissionFrameTab"..i])
	end

	GarrisonMissionFrameTab1:ClearAllPoints()
	GarrisonMissionFrameTab1:Point("BOTTOMLEFT", 11, -40)
	GarrisonMissionFrame.GarrCorners:Hide()

	-- Follower list
	FollowerList = GarrisonMissionFrame.FollowerList
	FollowerList:DisableDrawLayer("BORDER")
	FollowerList.MaterialFrame:StripTextures()
	S:HandleEditBox(FollowerList.SearchBox)
	S:HandleScrollBar(FollowerList.listScroll.scrollBar)
	hooksecurefunc(FollowerList, "ShowFollower", function(self)
		S:HandleFollowerPage(self, true)
	end)

	-- Mission list
	local MissionTab = GarrisonMissionFrame.MissionTab
	local MissionList = MissionTab.MissionList
	local MissionPage = GarrisonMissionFrame.MissionTab.MissionPage
	MissionList:DisableDrawLayer("BORDER")
	S:HandleScrollBar(MissionList.listScroll.scrollBar)
	S:HandleCloseButton(MissionPage.CloseButton)
	MissionPage.CloseButton:SetFrameLevel(MissionPage:GetFrameLevel() + 2)
	S:HandleButton(MissionList.CompleteDialog.BorderFrame.ViewButton)
	S:HandleButton(MissionPage.StartMissionButton)
	S:HandleButton(GarrisonMissionFrame.MissionComplete.NextMissionButton)

	MissionPage.StartMissionButton.Flash:Hide()
	MissionPage.StartMissionButton.Flash.Show = E.noop
	MissionPage.StartMissionButton.FlashAnim:Stop()
	MissionPage.StartMissionButton.FlashAnim.Play = E.noop

	-- Landing page
	-- GarrisonLandingPage:StripTextures(true) -- I actually like the look of this texture. Not sure if we want to remove it.
	GarrisonLandingPage:CreateBackdrop("Transparent")
	S:HandleCloseButton(GarrisonLandingPage.CloseButton, GarrisonLandingPage.backdrop)
	S:HandleTab(GarrisonLandingPageTab1)
	S:HandleTab(GarrisonLandingPageTab2)
	S:HandleTab(GarrisonLandingPageTab3)
	GarrisonLandingPageTab1:ClearAllPoints()
	GarrisonLandingPageTab1:Point("TOPLEFT", GarrisonLandingPage, "BOTTOMLEFT", 70, 2)

	-- Landing page: Report
	local Report = GarrisonLandingPage.Report
	Report.List:StripTextures(true)
	scrollFrame = Report.List.listScroll
	S:HandleScrollBar(scrollFrame.scrollBar)
	local buttons = scrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		for _, reward in pairs(button.Rewards) do
			reward.Icon:SetTexCoord(unpack(E.TexCoords))
			if not reward.border then
				reward.border = CreateFrame("Frame", nil, reward)
				S:HandleIcon(reward.Icon, reward.border)
				reward.Quantity:SetParent(reward.border)
				reward.IconBorder:SetAlpha(0)
			end
		end
	end

	-- Landing page: Follower list
	FollowerList = GarrisonLandingPage.FollowerList
	FollowerList.FollowerHeaderBar:Hide()
	S:HandleEditBox(FollowerList.SearchBox)
	scrollFrame = FollowerList.listScroll
	S:HandleScrollBar(scrollFrame.scrollBar)

	hooksecurefunc(FollowerList, "ShowFollower", function(self)
		S:HandleFollowerPage(self, nil, true)
	end)

	hooksecurefunc("GarrisonFollowerButton_AddAbility", function(self, index)
		local ability = self.Abilities[index]
		if not ability.styled then
			S:HandleIcon(ability.Icon, ability)
			ability.styled = true
		end
	end)

	-- Landing page: Fleet
	local ShipFollowerList = GarrisonLandingPage.ShipFollowerList
	ShipFollowerList.FollowerHeaderBar:Hide()
	S:HandleEditBox(ShipFollowerList.SearchBox)
	scrollFrame = ShipFollowerList.listScroll
	S:HandleScrollBar(scrollFrame.scrollBar)
	-- HandleShipFollowerPage(ShipFollowerList.followerTab)

	-- ShipYard
	GarrisonShipyardFrame:StripTextures(true)
	GarrisonShipyardFrame.BorderFrame:StripTextures(true)
	GarrisonShipyardFrame:CreateBackdrop("Transparent")
	GarrisonShipyardFrame.backdrop:SetOutside(GarrisonShipyardFrame.BorderFrame)
	GarrisonShipyardFrame.BorderFrame.GarrCorners:Hide()
	S:HandleCloseButton(GarrisonShipyardFrame.BorderFrame.CloseButton2)
	S:HandleTab(GarrisonShipyardFrameTab1)
	S:HandleTab(GarrisonShipyardFrameTab2)

	-- ShipYard: Naval Map
	MissionTab = GarrisonShipyardFrame.MissionTab
	MissionList = MissionTab.MissionList
	MissionList:CreateBackdrop("Transparent")
	MissionList.backdrop:SetOutside(MissionList.MapTexture)
	MissionList.CompleteDialog.BorderFrame:StripTextures()
	MissionList.CompleteDialog.BorderFrame:SetTemplate("Transparent")

	-- ShipYard: Mission
	MissionPage = MissionTab.MissionPage
	S:HandleCloseButton(MissionPage.CloseButton)
	MissionPage.CloseButton:SetFrameLevel(MissionPage.CloseButton:GetFrameLevel() + 2)
	S:HandleButton(MissionList.CompleteDialog.BorderFrame.ViewButton)
	S:HandleButton(GarrisonShipyardFrame.MissionComplete.NextMissionButton)
	MissionList.CompleteDialog:SetAllPoints(MissionList.MapTexture)
	GarrisonShipyardFrame.MissionCompleteBackground:SetAllPoints(MissionList.MapTexture)
	S:HandleButton(MissionPage.StartMissionButton)
	MissionPage.StartMissionButton.Flash:Hide()
	MissionPage.StartMissionButton.Flash.Show = E.noop
	MissionPage.StartMissionButton.FlashAnim:Stop()
	MissionPage.StartMissionButton.FlashAnim.Play = E.noop
	S:HandleButton(GarrisonMissionFrameHelpBoxButton)

	-- ShipYard: Follower List
	FollowerList = GarrisonShipyardFrame.FollowerList
	scrollFrame = FollowerList.listScroll
	FollowerList:StripTextures()
	S:HandleScrollBar(scrollFrame.scrollBar)
	S:HandleEditBox(FollowerList.SearchBox)
	FollowerList.MaterialFrame:StripTextures()
	FollowerList.MaterialFrame.Icon:SetAtlas("ShipMission_CurrencyIcon-Oil", false) --Re-add the material icon
	-- HandleShipFollowerPage(FollowerList.followerTab)

	-- ShipYard: Mission Tooltip
	local tooltip = GarrisonShipyardMapMissionTooltip
	local reward = tooltip.ItemTooltip
	local bonusReward = tooltip.BonusReward
	local icon = reward.Icon
	local bonusIcon = bonusReward.Icon
	tooltip:SetTemplate("Transparent")
	if icon then
		S:HandleIcon(icon)
		reward.IconBorder:SetTexture(nil)
	end
	if bonusIcon then
		S:HandleIcon(bonusIcon) --TODO: Check how this actually looks
	end

	-- Threat Counter Tooltips
	-- The tooltip starts using blue backdrop and white border unless we re-set the template.
	-- We should check if there is a better way of doing this.
	S:HookScript(GarrisonMissionMechanicFollowerCounterTooltip, "OnShow", function(self)
		self:SetTemplate("Transparent")
	end)
	S:HookScript(GarrisonMissionMechanicTooltip, "OnShow", function(self)
		self:SetTemplate("Transparent")
	end)

	--LandingPage Tutorial
	S:HandleCloseButton(GarrisonLandingPageTutorialBox.CloseButton)
end

local function SkinTooltip()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.garrison ~= true then return end

	local function SkinFollowerTooltip(frame)
		for i = 1, 9 do
			select(i, frame:GetRegions()):Hide()
		end
		frame:SetTemplate("Transparent")
	end

	local function SkinAbilityTooltip(frame)
		for i = 1, 9 do
			select(i, frame:GetRegions()):Hide()
		end
		local icon = frame.Icon
		icon:SetTexCoord(unpack(E.TexCoords))
		if not frame.border then
			frame.border = CreateFrame("Frame", nil, frame)
			S:HandleIcon(frame.Icon, frame.border)
		end
		frame:SetTemplate("Transparent")
	end

	SkinFollowerTooltip(GarrisonFollowerTooltip)
	SkinFollowerTooltip(FloatingGarrisonFollowerTooltip)
	SkinFollowerTooltip(FloatingGarrisonMissionTooltip)
	SkinFollowerTooltip(FloatingGarrisonShipyardFollowerTooltip)
	SkinFollowerTooltip(GarrisonShipyardFollowerTooltip)

	SkinAbilityTooltip(GarrisonFollowerAbilityTooltip)
	SkinAbilityTooltip(FloatingGarrisonFollowerAbilityTooltip)
	SkinAbilityTooltip(GarrisonFollowerMissionAbilityWithoutCountersTooltip)
	SkinAbilityTooltip(GarrisonFollowerAbilityWithoutCountersTooltip)

	S:HandleCloseButton(FloatingGarrisonFollowerTooltip.CloseButton)
	S:HandleCloseButton(FloatingGarrisonFollowerAbilityTooltip.CloseButton)
	S:HandleCloseButton(FloatingGarrisonMissionTooltip.CloseButton)
	S:HandleCloseButton(FloatingGarrisonShipyardFollowerTooltip.CloseButton)

	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", function(tooltipFrame)
		-- Abilities
		if tooltipFrame.numAbilitiesStyled == nil then
			tooltipFrame.numAbilitiesStyled = 1
		end
		local numAbilitiesStyled = tooltipFrame.numAbilitiesStyled
		local abilities = tooltipFrame.Abilities
		local ability = abilities[numAbilitiesStyled]
		while ability do
			local icon = ability.Icon
			icon:SetTexCoord(unpack(E.TexCoords))
			if not ability.border then
				ability.border = CreateFrame("Frame", nil, ability)
				S:HandleIcon(ability.Icon, ability.border)
			end

			numAbilitiesStyled = numAbilitiesStyled + 1
			ability = abilities[numAbilitiesStyled]
		end
		tooltipFrame.numAbilitiesStyled = numAbilitiesStyled

		-- Traits
		if tooltipFrame.numTraitsStyled == nil then
			tooltipFrame.numTraitsStyled = 1
		end
		local numTraitsStyled = tooltipFrame.numTraitsStyled
		local traits = tooltipFrame.Traits
		local trait = traits[numTraitsStyled]
		while trait do
			local icon = trait.Icon
			icon:SetTexCoord(unpack(E.TexCoords))
			if not trait.border then
				trait.border = CreateFrame("Frame", nil, trait)
				S:HandleIcon(trait.Icon, trait.border)
			end

			numTraitsStyled = numTraitsStyled + 1
			trait = traits[numTraitsStyled]
		end
		tooltipFrame.numTraitsStyled = numTraitsStyled
	end)

	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetShipyardFollower", function(tooltipFrame)
		-- Properties
		if tooltipFrame.numPropertiesStyled == nil then
			tooltipFrame.numPropertiesStyled = 1
		end
		local numPropertiesStyled = tooltipFrame.numPropertiesStyled
		local properties = tooltipFrame.Properties
		local property = properties[numPropertiesStyled]
		while property do
			local icon = property.Icon
			icon:SetTexCoord(unpack(E.TexCoords))
			if not property.border then
				property.border = CreateFrame("Frame", nil, property)
				S:HandleIcon(property.Icon, property.border)
			end

			numPropertiesStyled = numPropertiesStyled + 1
			property = properties[numPropertiesStyled]
		end
		tooltipFrame.numPropertiesStyled = numPropertiesStyled
	end)
end

S:AddCallbackForAddon('Blizzard_GarrisonUI', "Garrison", LoadSkin)
S:AddCallback("GarrisonTooltips", SkinTooltip)