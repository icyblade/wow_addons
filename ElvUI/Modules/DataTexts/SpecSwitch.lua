local E, L, V, P, G = unpack(select(2, ...))
local DT = E:GetModule("DataTexts")

local select = select
local format, join = string.format, string.join

local EasyMenu = EasyMenu
local GetLootSpecialization = GetLootSpecialization
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecializationInfoByID = GetSpecializationInfoByID
local HideUIPanel = HideUIPanel
local IsShiftKeyDown = IsShiftKeyDown
local SetLootSpecialization = SetLootSpecialization
local SetActiveSpecGroup = SetActiveSpecGroup
local ShowUIPanel = ShowUIPanel

local LOOT = LOOT
local SELECT_LOOT_SPECIALIZATION = SELECT_LOOT_SPECIALIZATION
local LOOT_SPECIALIZATION_DEFAULT = LOOT_SPECIALIZATION_DEFAULT
local ACTIVE_PETS, FACTION_INACTIVE = ACTIVE_PETS, FACTION_INACTIVE

local activeString = join("", "|cff00FF00" , ACTIVE_PETS, "|r")
local inactiveString = join("", "|cffFF0000", FACTION_INACTIVE, "|r")
local iconString = "|T%s:14:14:0:0:50:50:4:46:4:46|t"
local displayString = ""

local lastPanel, active

local menuFrame = CreateFrame("Frame", "LootSpecializationDatatextClickMenu", E.UIParent, "UIDropDownMenuTemplate")
local menuList = {
	{text = SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true},
	{notCheckable = true, func = function() SetLootSpecialization(0) end},
	{notCheckable = true},
	{notCheckable = true},
	{notCheckable = true},
	{notCheckable = true}
}

local function OnEvent(self)
	lastPanel = self

	local specIndex = GetSpecialization()

	if not specIndex then
		self.text:SetText("N/A")
		return
	end

	active = specIndex

	local spec, loot, text = "", "N/A", LOOT
	local specialization = GetLootSpecialization()

	local _, _, _, specTex = GetSpecializationInfo(specIndex)
	if specTex then
		spec = format(iconString, specTex)
	end

	if specialization == 0 then
		loot, text = spec, "|cFF54FF00"..text.."|r"
	else
		local _, _, _, texture = GetSpecializationInfoByID(specialization)
		if texture then
			loot = format(iconString, texture)
		end
	end

	self.text:SetFormattedText("%s: %s %s: %s", L["Spec"], spec, text, loot)
end

local function AddTexture(texture)
	texture = texture and "|T"..texture..":16:16:0:0:50:50:4:46:4:46|t" or ""

	return texture
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	for i = 1, GetNumSpecializations() do
		local _, name, _, icon = GetSpecializationInfo(i)
		if name then
			DT.tooltip:AddLine(join(" ", format(displayString, name), AddTexture(icon), (i == active and activeString or inactiveString)), 1, 1, 1)
		end
	end

	DT.tooltip:AddLine(" ")
	local specialization = GetLootSpecialization()
	if specialization == 0 then
		local specIndex = GetSpecialization()

		if specIndex then
			local _, name = GetSpecializationInfo(specIndex)
			DT.tooltip:AddLine(format("|cffFFFFFF%s:|r %s", SELECT_LOOT_SPECIALIZATION, format(LOOT_SPECIALIZATION_DEFAULT, name)))
		end
	else
		local specID, name = GetSpecializationInfoByID(specialization)
		if specID then
			DT.tooltip:AddLine(format("|cffFFFFFF%s:|r %s", SELECT_LOOT_SPECIALIZATION, name))
		end
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L["|cffFFFFFFLeft Click:|r Change Talent Specialization"])
	DT.tooltip:AddLine(L["|cffFFFFFFShift + Left Click:|r Show Talent Specialization UI"])
	DT.tooltip:AddLine(L["|cffFFFFFFRight Click:|r Change Loot Specialization"])

	DT.tooltip:Show()
end

local function OnClick(_, button)
	local specIndex = GetSpecialization()
	if not specIndex then return end

	if button == "LeftButton" then
		DT.tooltip:Hide()
		if not PlayerTalentFrame then
			LoadAddOn("Blizzard_TalentUI")
		end
		if IsShiftKeyDown() then
			if not PlayerTalentFrame:IsShown() then
				ShowUIPanel(PlayerTalentFrame)
			else
				HideUIPanel(PlayerTalentFrame)
			end
		else
			SetActiveSpecGroup(active == 1 and 2 or 1)
		end
	else
		DT.tooltip:Hide()
		local _, specName = GetSpecializationInfo(specIndex)
		menuList[2].text = format(LOOT_SPECIALIZATION_DEFAULT, specName)

		for index = 1, 4 do
			local id, name = GetSpecializationInfo(index)
			if id then
				menuList[index + 2].text = name
				menuList[index + 2].func = function() SetLootSpecialization(id) end
			else
				menuList[index + 2] = nil
			end
		end

		EasyMenu(menuList, menuFrame, "cursor", -15, -7, "MENU", 2)
	end
end

local function ValueColorUpdate()
	displayString = join("", "|cffFFFFFF%s:|r ")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Talent/Loot Specialization", {"PLAYER_ENTERING_WORLD", "CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_LOOT_SPEC_UPDATED"}, OnEvent, nil, OnClick, OnEnter, nil, L["Talent/Loot Specialization"])