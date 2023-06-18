local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local _G = _G
local select = select

local function LoadSkin()
	if not E.private.addOnSkins._NPCScan then return end

	_NPCScanButton:StripTextures()
	_NPCScanButton:SetTemplate("Transparent")

	_NPCScanButton:SetScale(1)
	_NPCScanButton.SetScale = E.noop

	_NPCScanButton:HookScript("OnEnter", S.SetModifiedBackdrop)
	_NPCScanButton:HookScript("OnLeave", S.SetOriginalBackdrop)

	for i = 1, _NPCScanButton:GetNumChildren() do
		local child = select(i, _NPCScanButton:GetChildren())
		if child and child:IsObjectType("Button") then
			S:HandleCloseButton(child)
			child:ClearAllPoints()
			child:Point("TOPRIGHT", _NPCScanButton, "TOPRIGHT", 4, 4)
			child:SetScale(1)
		end
	end

	local NPCFoundText = select(5, _NPCScanButton:GetRegions())
	NPCFoundText:SetTextColor(1, 1, 1, 1)
	NPCFoundText:SetShadowOffset(1, -1)

	-- Interface Options
	_NPCScanConfigAlert:StripTextures()

	S:HandleButton(_NPCScanTest)

	S:HandleCheckBox(_NPCScanConfigCacheWarningsCheckbox)
	S:HandleCheckBox(_NPCScanConfigPrintTimeCheckbox)
	S:HandleCheckBox(_NPCScanConfigUnmuteCheckbox)
	S:HandleCheckBox(_NPCScanSearchAchievementAddFoundCheckbox)
	S:HandleCheckBox(_NPCScanConfigShowAsToastCheckbox)
	S:HandleCheckBox(_NPCScanConfigPersistentToastCheckbox)
	S:HandleCheckBox(_NPCScanConfigScreenFlashCheckbox)
	S:HandleCheckBox(_NPCScanVignetteScanCheckbox)
	S:HandleCheckBox(_NPCScanMouseoverScanCheckbox)
	S:HandleCheckBox(_NPCScanBlockFlightScanCheckbox)

	S:HandleDropDownBox(_NPCScanConfigIconDropdown)
	S:HandleDropDownBox(_NPCScanConfigSoundDropdown)

	for i = 1, 10 do
		local tab = _G["_NPCScanSearchTab"..i]

		S:HandleTab(tab)

		for i = 1, tab:GetNumChildren() do
			local child = select(i, tab:GetChildren())

			if child and child:IsObjectType("CheckButton") then
				S:HandleCheckBox(child)
			end
		end
	end

	S:HandleEditBox(_NPCScanSearchNpcIDEditBox)
	S:HandleEditBox(_NPCScanSearchNpcWorldEditBox)
	S:HandleEditBox(_NPCScanSearchNpcNameEditBox)
end

S:AddCallbackForAddon("_NPCScan", "_NPCScan", LoadSkin)