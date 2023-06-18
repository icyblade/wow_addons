local E, L, V, P, G = unpack(ElvUI)
local UB = E:NewModule("Enhanced_UndressButtons")
local S = E:GetModule("Skins")

function UB:CreateUndressButton()
	self.dressUpButton = CreateFrame("Button", "DressUpFrameUndressButton", DressUpFrame, "UIPanelButtonTemplate")
	self.dressUpButton:Size(80, 22)
	self.dressUpButton:SetText(L["Undress"])
	self.dressUpButton:SetScript("OnClick", function(self)
		self.model:Undress()
		PlaySound("gsTitleOptionOK")
	end)
	self.dressUpButton.model = DressUpModel

	self.sideDressUpButton = CreateFrame("Button", "SideDressUpFrameUndressButton", SideDressUpModel, "UIPanelButtonTemplate")
	self.sideDressUpButton:Size(80, 22)
	self.sideDressUpButton:SetText(L["Undress"])
	self.sideDressUpButton:SetScript("OnClick", function(self)
		self.model:Undress()
		PlaySound("gsTitleOptionOK")
	end)
	self.sideDressUpButton.model = SideDressUpModel

	if E.private.skins.blizzard.enable and E.private.skins.blizzard.dressingroom then
		S:HandleButton(DressUpFrameUndressButton)
		DressUpFrameUndressButton:Point("RIGHT", DressUpFrameResetButton, "LEFT", -3, 0)

		S:HandleButton(SideDressUpFrameUndressButton)
		SideDressUpFrameUndressButton:Point("RIGHT", SideDressUpModelResetButton, "LEFT", -3, 0)
	else
		DressUpFrameUndressButton:Point("RIGHT", DressUpFrameResetButton, "LEFT", 2, 0)
		SideDressUpFrameUndressButton:Point("BOTTOM", SideDressUpModelResetButton, "BOTTOM", 0, -25)
	end
end

function UB:ToggleState()
	if E.db.enhanced.general.undressButton then
		if not self.dressUpButton then
			self:CreateUndressButton()
		end

		self.dressUpButton:Show()
		self.sideDressUpButton:Show()

		SideDressUpModelResetButton:Point("BOTTOM", 43, 2)
	else
		if self.dressUpButton and self.dressUpButton then
			self.dressUpButton:Hide()
			self.sideDressUpButton:Hide()
		end
		SideDressUpModelResetButton:Point("BOTTOM", 0, 2)
	end
end

function UB:Initialize()
	if not E.db.enhanced.general.undressButton then return end

	self:ToggleState()
end

local function InitializeCallback()
	UB:Initialize()
end

E:RegisterModule(UB:GetName(), InitializeCallback)