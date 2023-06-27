local E, L, V, P, G = unpack(ElvUI)
local mod = E:GetModule("Enhanced_Blizzard")
local S = E:GetModule("Skins")

local floor = math.floor
local tconcat = table.concat

local CreateFrame = CreateFrame
local DisableAddOn = DisableAddOn
local EnableAddOn = EnableAddOn
local GetAddOnDependencies = GetAddOnDependencies
local GetAddOnInfo = GetAddOnInfo
local GetNumAddOns = GetNumAddOns
local IsAddOnLoaded = IsAddOnLoaded
local IsShiftKeyDown = IsShiftKeyDown
local LoadAddOn = LoadAddOn
local GameTooltip_Hide = GameTooltip_Hide

local function AddonList_HasAnyChanged()
	for i = 1, GetNumAddOns() do
		local _, _, _, enabled, _, reason = GetAddOnInfo(i)
		if enabled ~= ElvUI_AddonList.startStatus[i] and reason ~= "DEP_DISABLED" then
			return true
		end
	end

	return false
end

local function AddonList_IsAddOnLoadOnDemand(index)
	local lod = false

	if IsAddOnLoadOnDemand(index) then
		if not IsAddOnLoaded(index) then
			lod = true
		end
	end

	return lod
end

local function AddonList_SetStatus(entry, load, status, reload)
	if load then
		entry.LoadButton:Show()
	else
		entry.LoadButton:Hide()
	end

	if status then
		entry.Status:Show()
	else
		entry.Status:Hide()
	end

	if reload then
		entry.Reload:Show()
	else
		entry.Reload:Hide()
	end
end

local function AddonList_Update()
	local numEntries = GetNumAddOns()
	local addonIndex, entry, checkbox, status

	for i = 1, 20 do
		addonIndex = ElvUI_AddonList.offset + i
		entry = _G["ElvUI_AddonListEntry"..i]

		if addonIndex > numEntries then
			entry:Hide()
		else
			local name, title, _, enabled, loadable, reason = GetAddOnInfo(addonIndex)

			checkbox = _G["ElvUI_AddonListEntry"..i.."Enabled"]
			checkbox:SetChecked(enabled)

			status = _G["ElvUI_AddonListEntry"..i.."Title"]

			if loadable or (enabled and (reason == "DEP_DEMAND_LOADED" or reason == "DEMAND_LOADED")) then
				status:SetTextColor(1.0, 0.78, 0.0)
			elseif enabled and reason ~= "DEP_DISABLED" then
				status:SetTextColor(1.0, 0.1, 0.1)
			else
				status:SetTextColor(0.5, 0.5, 0.5)
			end

			if title then
				status:SetText(title)
			else
				status:SetText(name)
			end

			status = _G["ElvUI_AddonListEntry"..i.."Status"]
			if not loadable and reason then
				status:SetText(_G["ADDON_"..reason])
			else
				status:SetText("")
			end

			if enabled ~= ElvUI_AddonList.startStatus[addonIndex] and reason ~= "DEP_DISABLED" then
				if enabled then
					if AddonList_IsAddOnLoadOnDemand(addonIndex) then
						AddonList_SetStatus(entry, true, false, false)
					else
						AddonList_SetStatus(entry, false, false, true)
					end
				else
					AddonList_SetStatus(entry, false, false, true)
				end
			else
				AddonList_SetStatus(entry, false, true, false)
			end

			entry:SetID(addonIndex)
			entry:Show()
		end
	end

	FauxScrollFrame_Update(ElvUI_AddonListScrollFrame, numEntries, 20, 16, nil, nil, nil, nil, nil, nil, true)

	if AddonList_HasAnyChanged() then
		ElvUI_AddonListOkayButton:SetText(L["Reload UI"])
		ElvUI_AddonList.shouldReload = true
	else
		ElvUI_AddonListOkayButton:SetText(OKAY)
		ElvUI_AddonList.shouldReload = false
	end
end

local function AddonList_Enable(index, enabled)
	if enabled then
		EnableAddOn(index)
	else
		DisableAddOn(index)
	end

	AddonList_Update()
end

local function AddonList_LoadAddOn(index)
	if not AddonList_IsAddOnLoadOnDemand(index) then return end

	LoadAddOn(index)

	if IsAddOnLoaded(index) then
		ElvUI_AddonList.startStatus[index] = 1
	end

	AddonList_Update()
end

local function AddonList_TooltipBuildDeps(...)
	local deps

	local argsCount = select("#", ...)
	if argsCount == 1 then
		deps = ...
	else
		deps = tconcat({...}, ", ")
	end

	return L["Dependencies: "] .. deps
end

local function AddonList_TooltipUpdate(self)
	local id = self:GetID()
	if id == 0 then return end

	local name, title, notes, _, _, security = GetAddOnInfo(id)
	if not name then return end

	GameTooltip:ClearLines()

	if security == "BANNED" then
		GameTooltip:SetText(L["This addon has been disabled. You should install an updated version."])
	else
		if title then
			GameTooltip:AddLine(title)
		else
			GameTooltip:AddLine(name)
		end

		GameTooltip:AddLine(notes, 1.0, 1.0, 1.0)
		GameTooltip:AddLine(AddonList_TooltipBuildDeps(GetAddOnDependencies(id)))
	end

	GameTooltip:Show()
end

function mod:AddonList()
	if IsAddOnLoaded("ACP") then return end

	local addonList = CreateFrame("Frame", "ElvUI_AddonList", UIParent)
	addonList:SetFrameStrata("HIGH")
	addonList:Size(520, 466)
	addonList:Point("CENTER", 0, 0)
	addonList:SetTemplate("Transparent")
	addonList:SetClampedToScreen(true)
	addonList:SetMovable(true)
	addonList:EnableMouse(true)
	addonList:RegisterForDrag("LeftButton")
	addonList:Hide()
	tinsert(UISpecialFrames, addonList:GetName())

	addonList.offset = 0
	addonList.shouldReload = false
	addonList.startStatus = {}

	for i = 1, GetNumAddOns() do
		local _, _, _, enabled = GetAddOnInfo(i)
		addonList.startStatus[i] = enabled
	end

	addonList:SetScript("OnDragStart", function(self)
		if IsShiftKeyDown() then
			self:StartMoving()
		end
	end)
	addonList:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)

	local addonTitle = addonList:CreateFontString("$parentTitle", "BACKGROUND", "GameFontNormal")
	addonTitle:Point("TOP", 0, -10)
	addonTitle:SetText(ADDONS)

	local cancelButton = CreateFrame("Button", "$parentCancelButton", addonList, "UIPanelButtonTemplate")
	S:HandleButton(cancelButton)
	cancelButton:Size(80, 22)
	cancelButton:Point("BOTTOMRIGHT", -10, 10)
	cancelButton:SetText(CANCEL)
	cancelButton:SetScript("OnClick", function()
		ElvUI_AddonList:Hide()
	end)

	local closeButton = CreateFrame("Button", "$parentCloseButton", addonList, "UIPanelCloseButton")
	closeButton:Size(32)
	closeButton:Point("TOPRIGHT", 4, 6)
	S:HandleCloseButton(closeButton)

	closeButton:SetScript("OnClick", function()
		ElvUI_AddonList:Hide()
	end)

	local okayButton = CreateFrame("Button", "$parentOkayButton", addonList, "UIPanelButtonTemplate")
	S:HandleButton(okayButton)
	okayButton:Size(80, 22)
	okayButton:Point("RIGHT", cancelButton, "LEFT", -10, 0)
	okayButton:SetText(OKAY)
	okayButton:SetScript("OnClick", function()
		ElvUI_AddonList:Hide()
		if ElvUI_AddonList.shouldReload then
			ReloadUI()
		end
	end)

	local enableAllButton = CreateFrame("Button", "$parentEnableAllButton", addonList, "UIPanelButtonTemplate")
	S:HandleButton(enableAllButton)
	enableAllButton:Size(120, 22)
	enableAllButton:Point("BOTTOMLEFT", 10, 10)
	enableAllButton:SetText(L["Enable All"])
	enableAllButton:SetScript("OnClick", function()
		EnableAllAddOns()
		AddonList_Update()
	end)

	local disableAllButton = CreateFrame("Button", "$parentDisableAllButton", addonList, "UIPanelButtonTemplate")
	S:HandleButton(disableAllButton)
	disableAllButton:Size(120, 22)
	disableAllButton:Point("LEFT", enableAllButton, "RIGHT", 10, 0)
	disableAllButton:SetText(L["Disable All"])
	disableAllButton:SetScript("OnClick", function()
		DisableAllAddOns()
		AddonList_Update()
	end)

	addonList:SetScript("OnShow", function()
		AddonList_Update()
		PlaySound("igMainMenuOption")
	end)

	addonList:SetScript("OnHide", function()
		PlaySound("igMainMenuOptionCheckBoxOn")
	end)

	local scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", addonList, "FauxScrollFrameTemplate")
	S:HandleScrollBar(ElvUI_AddonListScrollFrameScrollBar, 5)
	scrollFrame:SetTemplate("Transparent")
	scrollFrame:Point("TOPLEFT", 8, -25)
	scrollFrame:Point("BOTTOMRIGHT", -29, 37)

	scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
		local scrollbar = _G[self:GetName().."ScrollBar"]
		scrollbar:SetValue(offset)
		addonList.offset = floor((offset / 16) + 0.5)
		AddonList_Update()

		if GameTooltip:IsShown() then
			AddonList_TooltipUpdate(GameTooltip:GetOwner())
		end
	end)

	local addonListEntry = {}
	for i = 1, 20 do
		addonListEntry[i] = CreateFrame("Button", "ElvUI_AddonListEntry"..i, scrollFrame)
		addonListEntry[i]:Size(scrollFrame:GetWidth() - 8, 16)
		addonListEntry[i]:SetID(i)

		if i == 1 then
			addonListEntry[i]:Point("TOPLEFT", 4, -4)
		else
			addonListEntry[i]:Point("TOP", addonListEntry[i - 1], "BOTTOM", 0, -4)
		end

		local enabled = CreateFrame("CheckButton", "$parentEnabled", addonListEntry[i])
		enabled:Size(24, 24)
		enabled:Point("LEFT", -4, 0)
		S:HandleCheckBox(enabled)

		local title = addonListEntry[i]:CreateFontString("$parentTitle", "BACKGROUND", "GameFontNormal")
		title:Size(220, 12)
		title:Point("LEFT", 22, 0)
		title:SetJustifyH("LEFT")

		local status = addonListEntry[i]:CreateFontString("$parentStatus", "BACKGROUND", "GameFontNormalSmall")
		status:Size(220, 12)
		status:Point("RIGHT", -22, 0)
		status:SetJustifyH("RIGHT")
		addonListEntry[i].Status = status

		local reload = addonListEntry[i]:CreateFontString("$parentReload", "BACKGROUND", "GameFontRed")
		reload:Size(220, 12)
		reload:Point("RIGHT", -22, 0)
		reload:SetJustifyH("RIGHT")
		reload:SetText(L["Requires Reload"])
		addonListEntry[i].Reload = reload

		local load = CreateFrame("Button", "$parentLoad", addonListEntry[i], "UIPanelButtonTemplate")
		load:Size(100, 22)
		load:Point("RIGHT", -21, 0)
		load:SetText(L["Load AddOn"])
		S:HandleButton(load)
		addonListEntry[i].LoadButton = load

		addonListEntry[i]:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self)
			AddonList_TooltipUpdate(self)
		end)
		addonListEntry[i]:SetScript("OnLeave", GameTooltip_Hide)

		enabled:SetScript("OnClick", function(self)
			AddonList_Enable(self:GetParent():GetID(), self:GetChecked())
			PlaySound("igMainMenuOptionCheckBoxOn")
		end)

		load:SetScript("OnClick", function(self)
			AddonList_LoadAddOn(self:GetParent():GetID())
		end)
	end

	local buttonAddons = CreateFrame("Button", "ElvUI_ButtonAddons", GameMenuFrame, "GameMenuButtonTemplate")
	if E.private.skins.blizzard.enable and E.private.skins.blizzard.misc then
		S:HandleButton(buttonAddons)
	end
	buttonAddons:Point("TOP", GameMenuButtonMacros, "BOTTOM", 0, -1)
	buttonAddons:SetText(ADDONS)
	buttonAddons:SetScript("OnClick", function()
		HideUIPanel(GameMenuFrame)
		ElvUI_AddonList:Show()
	end)

	self:HookScript(GameMenuButtonRatings, "OnShow", function()
		ElvUI_ButtonAddons:Point("TOP", GameMenuButtonRatings, "BOTTOM", 0, -1)
	end)

	self:HookScript(GameMenuButtonRatings, "OnHide", function()
		ElvUI_ButtonAddons:Point("TOP", GameMenuButtonMacros, "BOTTOM", 0, -1)
	end)

	self:RawHookScript(GameMenuButtonLogout, "OnShow", function(self)
		self:SetPoint("TOP", ElvUI_ButtonAddons, "BOTTOM", 0, -16)

		if not StaticPopup_Visible("CAMP") and not StaticPopup_Visible("QUIT") then
			self:Enable()
		else
			self:Disable()
		end
	end)

	if GetLocale() == "koKR" then
		if IsMacClient() then
			GameMenuFrame:Height(308)
		else
			GameMenuFrame:Height(282)
		end
	else
		if IsMacClient() then
			GameMenuFrame:Height(292)
		else
			GameMenuFrame:Height(266)
		end
	end
end