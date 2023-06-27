local E, L, V, P, G = unpack(ElvUI)
local TA = E:NewModule("Enhanced_TrainAll", "AceHook-3.0", "AceEvent-3.0")
local S = E:GetModule("Skins")

local select = select

local BuyTrainerService = BuyTrainerService
local GetMoney = GetMoney
local GetNumTrainerServices = GetNumTrainerServices
local GetTrainerServiceCost = GetTrainerServiceCost
local GetTrainerServiceInfo = GetTrainerServiceInfo

local function BetterSafeThanSorry_OnUpdate(self, elapsed)
	self.delay = self.delay - elapsed

	if self.delay <= 0 then
		TA:ResetScript()
	end
end

function TA:TrainAllSkills()
	self.locked = true
	self.button:Disable()

	local j, cost = 0
	local money = GetMoney()

	for i = 1, GetNumTrainerServices() do
		if select(3, GetTrainerServiceInfo(i)) == "available" then
			j = j + 1
			cost = GetTrainerServiceCost(i)
			if money >= cost then
				money = money - cost
				BuyTrainerService(i)
			else
				self:ResetScript()
				return
			end
		end
	end

	if j > 0 then
		self.skillsToLearn = j
		self.skillsLearned = 0

		self:RegisterEvent("TRAINER_UPDATE")

		self.button.delay = 1
		self.button:SetScript("OnUpdate", BetterSafeThanSorry_OnUpdate)
	else
		self:ResetScript()
	end
end

function TA:TRAINER_UPDATE(event)
	self.skillsLearned = self.skillsLearned + 1

	if self.skillsLearned >= self.skillsToLearn then
		self:ResetScript()
		self:TrainAllSkills()
	else
		self.button.delay = 1
	end
end

function TA:ResetScript()
	self.button:SetScript("OnUpdate", nil)
	self:UnregisterEvent("TRAINER_UPDATE")

	self.skillsLearned = nil
	self.skillsToLearn = nil
	self.button.delay = nil
	self.locked = nil
end

function TA:ButtonCreate()
	self.button = CreateFrame("Button", "ElvUI_TrainAllButton", ClassTrainerFrame, "UIPanelButtonTemplate")
	self.button:Size(80, 22)
	self.button:SetText(TRAIN.." "..ALL)

	if E.private.skins.blizzard.enable and E.private.skins.blizzard.trainer then
		self.button:Point("TOPRIGHT", ClassTrainerTrainButton, "TOPLEFT", -3, 0)
		S:HandleButton(self.button)
	else
		self.button:Point("TOPRIGHT", ClassTrainerTrainButton, "TOPLEFT", 0, 0)
	end

	self.button:SetScript("OnClick", function() TA:TrainAllSkills() end)

	self.button:HookScript("OnEnter", function()
		local cost = 0
		for i = 1, GetNumTrainerServices() do
			if select(3, GetTrainerServiceInfo(i)) == "available" then
				cost = cost + GetTrainerServiceCost(i)
			end
		end

		GameTooltip:SetOwner(self.button,"ANCHOR_TOPRIGHT", 0, 4)
		GameTooltip:SetText("|cffffffff"..TABARDVENDORCOST.."|r "..E:FormatMoney(cost, E.db.datatexts.goldFormat or "BLIZZARD", not E.db.datatexts.goldCoins))
	end)

	self.button:HookScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

function TA:ButtonUpdate()
	if self.locked then return end

	for i = 1, GetNumTrainerServices() do
		if select(3, GetTrainerServiceInfo(i)) == "available" then
			self.button:Enable()
			return
		end
	end

	self.button:Disable()
end

function TA:ADDON_LOADED(event, addon)
	if addon ~= "Blizzard_TrainerUI" then return end

	self:ButtonCreate()

	self:SecureHook("ClassTrainerFrame_Update", "ButtonUpdate")
	self:UnregisterEvent("ADDON_LOADED")
end

function TA:ToggleState()
	if E.db.enhanced.general.trainAllSkills then
		if not self.button then
			if IsAddOnLoaded("Blizzard_TrainerUI") then
				self:ADDON_LOADED(nil, "Blizzard_TrainerUI")
			else
				self:RegisterEvent("ADDON_LOADED")
			end
		else
			self.button:Show()

			if not self:IsHooked("ClassTrainerFrame_Update") then
				self:SecureHook("ClassTrainerFrame_Update", "ButtonUpdate")
			end
		end
	else
		if not self.button then
			self:UnregisterEvent("ADDON_LOADED")
		else
			self.button:Hide()
			self:UnhookAll()

			if self.locked then
				self:ResetScript()
			end
		end
	end
end

function TA:Initialize()
	if not E.db.enhanced.general.trainAllSkills then return end

	self:ToggleState()
end

local function InitializeCallback()
	TA:Initialize()
end

E:RegisterModule(TA:GetName(), InitializeCallback)