local E, L, V, P, G = unpack(ElvUI)
local EF = E:NewModule("Enhanced_Farmer", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

local _G = _G
local pairs, ipairs, select = pairs, ipairs, select
local tsort, twipe = table.sort, table.wipe
local format = string.format

local activezones = {L["Sunsong Ranch"], L["The Halfhill Market"]}
local seedButtons = {}
local toolButtons = {}
local portalButtons = {}

local farmSeedBarAnchor, farmToolBarAnchor, farmPortalBarAnchor

local NUM_SEED_BARS = 7

local seeds = {
	[79102] = {1}, -- GreenCabbageSeeds
	[89328] = {1}, -- JadeSquashSeeds
	[80590] = {1}, -- JuicycrunchCarrotSeeds
	[80592] = {1}, -- MoguPumpkinSeeds
	[80594] = {1}, -- PinkTurnipSeeds
	[80593] = {1}, -- RedBlossomLeekSeeds
	[80591] = {1}, -- ScallionSeeds
	[89329] = {1}, -- StripedMelonSeeds
	[80595] = {1}, -- WhiteTurnipSeeds
	[89326] = {1}, -- WitchberrySeeds
	[80809] = {3}, -- Bag of Green Cabbage Seeds
	[95434] = {4}, -- Bag of Green Cabbage Seeds
	[89848] = {3}, -- Bag of Jade Squash Seeds
	[95437] = {4}, -- Bag of Jade Squash Seeds
	[84782] = {3}, -- Bag of Juicycrunch Carrot Seeds
	[95436] = {4}, -- Bag of Juicycrunch Carrot Seeds
	[85153] = {3}, -- Bag of Mogu Pumpkin Seeds
	[95438] = {4}, -- Bag of Mogu Pumpkin Seeds
	[85162] = {3}, -- Bag of Pink Turnip Seeds
	[95439] = {4}, -- Bag of Pink Turnip Seeds
	[85158] = {3}, -- Bag of Red Blossom Leek Seeds
	[95440] = {4}, -- Bag of Red Blossom Leek Seeds
	[84783] = {3}, -- Bag of Scallion Seeds
	[95441] = {4}, -- Bag of Scallion Seeds
	[89849] = {3}, -- Bag of Striped Melon Seeds
	[95442] = {4}, -- Bag of Striped Melon Seeds
	[85163] = {3}, -- Bag of White Turnip Seeds
	[95443] = {4}, -- Bag of White Turnip Seeds
	[89847] = {3}, -- Bag of Witchberry Seeds
	[95444] = {4}, -- Bag of Witchberry Seeds
	[85216] = {2}, -- EnigmaSeed
	[85217] = {2}, -- MagebulbSeed
	[89202] = {2}, -- RaptorleafSeed
	[85215] = {2}, -- SnakerootSeed
	[89233] = {2}, -- SongbellSeed
	[89197] = {2}, -- WindshearCactusSeed
	[85219] = {2}, -- OminousSeed
	[91806] = {2}, -- UnstablePortalShard
	[95449] = {5}, -- Bag of Enigma Seeds
	[95450] = {6}, -- Bag of Enigma Seeds
	[95451] = {5}, -- Bag of Magebulb Seeds
	[95452] = {6}, -- Bag of Magebulb Seeds
	[95457] = {5}, -- Bag of Raptorleaf Seeds
	[95458] = {6}, -- Bag of Raptorleaf Seeds
	[95447] = {5}, -- Bag of Snakeroot Seeds
	[95448] = {6}, -- Bag of Snakeroot Seeds
	[95445] = {5}, -- Bag of Songbell Seeds
	[95446] = {6}, -- Bag of Songbell Seeds
	[95454] = {5}, -- Bag of Windshear Cactus Seeds
	[95456] = {6}, -- Bag of Windshear Cactus Seeds
	[85267] = {7}, -- AutumnBlossomSapling
	[85268] = {7}, -- SpringBlossomSapling
	[85269] = {7}, -- WinterBlossomSapling
}

local tools = {
	[79104]	= {30254}, -- RusyWateringCan
	[80513] = {30254}, -- VintageBugSprayer
	[89880] = {30535}, -- DentedShovel
	[89815] = {31938}, -- MasterPlow
}

local portals = {
	[91850] = {"Horde"}, -- Orgrimmar Portal Shard
	[91861] = {"Horde"}, -- Thunder Bluff Portal Shard
	[91862] = {"Horde"}, -- Undercity Portal Shard
	[91863] = {"Horde"}, -- Silvermoon Portal Shard

	[91860] = {"Alliance"}, -- Stormwind Portal Shard
	[91864] = {"Alliance"}, -- Ironforge Portal Shard
	[91865] = {"Alliance"}, -- Darnassus Portal Shard
	[91866] = {"Alliance"}, -- Exodar Portal Shard
}

local onMouseDown = function(self, mousebutton)
	if InCombatLockdown() then return end

	if mousebutton == "LeftButton" then
		self:SetAttribute("type", self.buttonType)
		self:SetAttribute(self.buttonType, self.sortname)

		if EF:IsInTable(seeds, self.itemId) and UnitName("target") ~= L["Tilled Soil"] then
			local container, slot = EF:FindItemInBags(self.itemId)
			if container and slot then
				self:SetAttribute("type", "macro")
				self:SetAttribute("macrotext", format("/targetexact %s \n/use %s %s", L["Tilled Soil"], container, slot))
			end
		end

		if self.cooldown then
			self.cooldown:SetCooldown(GetItemCooldown(self.itemId))
		end
	elseif mousebutton == "RightButton" and self.allowDrop then
		self:SetAttribute("type", "click")
		local container, slot = EF:FindItemInBags(self.itemId)
		if container and slot then
			PickupContainerItem(container, slot)
			DeleteCursorItem()
		end
	end
end

local onEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 2, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(self.sortname)
	if self.allowDrop then
		GameTooltip:AddLine(L["Right-click to drop the item."])
	end
	GameTooltip:Show()
end

local onLeave = function()
	GameTooltip:Hide()
end

function EF:InSeedZone()
	local subzone = GetSubZoneText()
	for i, zone in ipairs(activezones) do
		if zone == subzone then
			return true
		end
	end

	return false
end

function EF:InFarmZone()
	return GetSubZoneText() == activezones[1]
end

function EF:IsInTable(group, itemId)
	for i in pairs(group) do
		if i == itemId then return true end
	end

	return false
end

function EF:FindButton(group, itemId)
	for _, button in ipairs(group) do
		if button.itemId == itemId then
			return button
		end
	end

	return nil
end

function EF:FindItemInBags(itemId)
	for container = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(container) do
			if itemId == GetContainerItemID(container, slot) then
				return container, slot
			end
		end
	end
end

function EF:UpdateButtonInformation(button)
	button.items = GetItemCount(button.itemId)

	if button.text then
		button.text:SetText(button.items)
	end

	button.icon:SetDesaturated(button.items == 0)
	button.icon:SetAlpha(button.items == 0 and .25 or 1)
end

function EF:FarmerInventoryUpdate()
	if InCombatLockdown() then
		EF:RegisterEvent("PLAYER_REGEN_ENABLED", "FarmerInventoryUpdate")
		return
	else
		EF:UnregisterEvent("PLAYER_REGEN_ENABLED")
 	end

	for i = 1, NUM_SEED_BARS do
		for _, button in ipairs(seedButtons[i]) do
			EF:UpdateButtonInformation(button)
		end
	end

	for _, button in ipairs(toolButtons) do
		EF:UpdateButtonInformation(button)
	end

	for _, button in ipairs(portalButtons) do
		EF:UpdateButtonInformation(button)
	end

	EF:UpdateLayout()
end

function EF:UpdateBarLayout(bar, anchor, buttons)
	local count = 0
	bar:ClearAllPoints()
	bar:Point("LEFT", anchor, "LEFT", 0, 0)

	for _, button in ipairs(buttons) do
		button:ClearAllPoints()
		if not E.db.enhanced.farmer.onlyActive or button.items > 0 then
			button:Point("TOPLEFT", bar, "TOPLEFT", (count * 32) + 2, -2)
			button:Show()
			count = count + 1
		else
			button:Hide()
		end
	end

	bar:Width((count * 32) + 2)
	bar:Height(34)

	return count
end

function EF:UpdateButtonCooldown(button)
	if button.cooldown then
		button.cooldown:SetCooldown(GetItemCooldown(button.itemId))
	end
end

function EF:UpdateCooldown()
	if not EF:InSeedZone() then return end

	for i = 1, NUM_SEED_BARS do
		for _, button in ipairs(seedButtons[i]) do
			EF:UpdateButtonCooldown(button)
		end
	end
	for _, button in ipairs(toolButtons) do
		EF:UpdateButtonCooldown(button)
	end
	for _, button in ipairs(portalButtons) do
		EF:UpdateButtonCooldown(button)
	end
end

function EF:UpdateSeedBarLayout(seedBar, anchor, buttons, category)
	local count, horizontal = 0, E.db.enhanced.farmer.seedBarDirection == "HORIZONTAL"
	seedBar:ClearAllPoints()
	seedBar:Point("TOPLEFT", anchor, "TOPLEFT", horizontal and 0 or (category - 1)* 34, horizontal and -((category - 1)* 34) or 0)

	for _, button in ipairs(buttons) do
		button:ClearAllPoints()
		if not E.db.enhanced.farmer.onlyActive or button.items > 0 then
			button:Point("TOPLEFT", seedBar, "TOPLEFT", horizontal and (count * 32) + 2 or 2, horizontal and - 2 or -(count * 32) - 2)
			button:Show()
			count = count + 1
		else
			button:Hide()
		end
	end

	seedBar:Width(horizontal and (count * 32) + 2 or 32)
	seedBar:Height(horizontal and 32 or (count * 32) + 2)

	return count
end

function EF:UpdateBar(bar, layoutfunc, zonecheck, anchor, buttons, position)
	local count = layoutfunc(self, bar, anchor, buttons, position)
	bar:SetShown(E.db.enhanced.farmer.enable and count > 0 and zonecheck(self) and not InCombatLockdown())

	return count > 0
end

function EF:ZoneChanged()
	if not EF:InSeedZone() and E.db.enhanced.farmer.dropTools then
		for k in pairs(tools) do
			local container, slot = EF:FindItemInBags(k)
			if container and slot then
				PickupContainerItem(container, slot)
				DeleteCursorItem()
			end
		end
	end

	if EF:InSeedZone() then
		EF:RegisterEvent("BAG_UPDATE", "FarmerInventoryUpdate")
		EF:RegisterEvent("BAG_UPDATE_COOLDOWN", "UpdateCooldown")
	else
		EF:UnregisterEvent("BAG_UPDATE")
		EF:UnregisterEvent("BAG_UPDATE_COOLDOWN")
	end

	EF:FarmerInventoryUpdate()
end

function EF:UpdateLayout()
 	local position = 1

	for i = 1, NUM_SEED_BARS do
		if EF:UpdateBar(_G[format("FarmSeedBar%d", i)], EF.UpdateSeedBarLayout, EF.InSeedZone, farmSeedBarAnchor, seedButtons[i], position) then
			position = position + 1
		end
	end

	EF:UpdateBar(_G["FarmToolBar"], EF.UpdateBarLayout, EF.InFarmZone, farmToolBarAnchor, toolButtons)
	EF:UpdateBar(_G["FarmPortalBar"], EF.UpdateBarLayout, EF.InFarmZone, farmPortalBarAnchor, portalButtons)

	if E.db.enhanced.farmer.seedBarDirection == "HORIZONTAL" then
		farmSeedBarAnchor:Size(320, ((position - 1) * 34))
	else
		farmSeedBarAnchor:Size(((position - 1) * 34), 320)
	end
end

function EF:CreateFarmButton(index, owner, buttonType, name, texture, allowDrop, showCount)
	local button = CreateFrame("Button", format("FarmerButton%d", index), owner, "SecureActionButtonTemplate")
	button:StyleButton()
	button:SetTemplate("Default", true)
	button:SetNormalTexture(nil)

	button:Size(30, 30)

	button.sortname = name
	button.itemId = index
	button.allowDrop = allowDrop
	button.buttonType = buttonType

	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetTexture(texture)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.icon:SetInside()

	if showCount then
		button.text = button:CreateFontString(nil, "OVERLAY")
		button.text:SetFont(E.media.normFont, 12, "OUTLINE")
		button.text:SetPoint("BOTTOMRIGHT", button, 1, 2)
	end

	button.cooldown = CreateFrame("Cooldown", format("FarmerButton%dCooldown", index), button)
	button.cooldown:SetAllPoints(button)

	button:SetScript("OnEnter", onEnter)
	button:SetScript("OnLeave", onLeave)
	button:SetScript("OnMouseDown", onMouseDown)

	return button
end

function EF:CreateFrames()
	farmSeedBarAnchor = CreateFrame("Frame", "FarmSeedBarAnchor", E.UIParent)
	farmSeedBarAnchor:Point("LEFT", E.UIParent, "LEFT", 4, -200)
	farmSeedBarAnchor:Size(96, 320)
	farmSeedBarAnchor:SetFrameStrata("BACKGROUND")

	E:CreateMover(farmSeedBarAnchor, "FarmSeedAnchor", L["Farmer Seed Bar"])

	farmToolBarAnchor = CreateFrame("Frame", "FarmToolBarAnchor", E.UIParent)
	farmToolBarAnchor:Point("BOTTOMLEFT", farmSeedBarAnchor, "TOPLEFT", 0, 4)
	farmToolBarAnchor:Size(128, 38)
	farmToolBarAnchor:SetFrameStrata("BACKGROUND")

	E:CreateMover(farmToolBarAnchor, "FarmToolAnchor", L["Farmer Tools Bar"])

	farmPortalBarAnchor = CreateFrame("Frame", "FarmPortalBarAnchor", E.UIParent)
	farmPortalBarAnchor:Point("BOTTOMLEFT", farmToolBarAnchor, "TOPLEFT", 0, 4)
	farmPortalBarAnchor:Size(128, 38)
	farmPortalBarAnchor:SetFrameStrata("BACKGROUND")

	E:CreateMover(farmPortalBarAnchor, "FarmPortalAnchor", L["Farmer Portal Bar"])

	for k, v in pairs(seeds) do
		seeds[k] = {v[1], GetItemInfo(k)}
	end

	for k, v in pairs(tools) do
		tools[k] = {v[1], GetItemInfo(k)}
	end

	for k, v in pairs(portals) do
		portals[k] = {v[1], GetItemInfo(k)}
	end

	for i = 1, NUM_SEED_BARS do
		local seedBar = CreateFrame("Frame", format("FarmSeedBar%d", i), UIParent)
		seedBar:SetFrameStrata("BACKGROUND")
		seedBar:SetPoint("CENTER", farmSeedBarAnchor, "CENTER", 0, 0)

		seedButtons[i] = seedButtons[i] or {}

		for k, v in pairs(seeds) do
			if v[1] == i then
				tinsert(seedButtons[i], EF:CreateFarmButton(k, seedBar, "item", v[2], v[11], false, true))
			end
			tsort(seedButtons[i], function(a, b) return a.sortname < b.sortname end)
		end
	end

	local toolBar = CreateFrame("Frame", "FarmToolBar", UIParent)
	toolBar:SetFrameStrata("BACKGROUND")
	toolBar:SetPoint("CENTER", farmToolBarAnchor, "CENTER", 0, 0)
	for k, v in pairs(tools) do
		tinsert(toolButtons, EF:CreateFarmButton(k, toolBar, "item", v[2], v[11], true, false))
	end

	local portalBar = CreateFrame("Frame", "FarmPortalBar", UIParent)
	portalBar:SetFrameStrata("BACKGROUND")
	portalBar:SetPoint("CENTER", farmPortalBarAnchor, "CENTER", 0, 0)
	local playerFaction = UnitFactionGroup("player")
	for k, v in pairs(portals) do
		if v[1] == playerFaction then
			tinsert(portalButtons, EF:CreateFarmButton(k, portalBar, "item", v[2], v[11], false, true))
		end
	end

	EF:RegisterEvent("ZONE_CHANGED", "ZoneChanged")
	EF:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZoneChanged")
	EF:RegisterEvent("ZONE_CHANGED_INDOORS", "ZoneChanged")

	EF:ScheduleTimer("ZoneChanged", 5)
end

function EF:StartFarmBarLoader()
	EF:UnregisterEvent("PLAYER_ENTERING_WORLD")

	local itemError = false

	for k in pairs(seeds) do
		if select(2, GetItemInfo(k)) == nil then itemError = true end
	end

	for k in pairs(tools) do
		if select(2, GetItemInfo(k)) == nil then itemError = true end
	end

	for k in pairs(portals) do
		if select(2, GetItemInfo(k)) == nil then itemError = true end
	end

	if itemError then
		EF:ScheduleTimer("StartFarmBarLoader", 5)
	else
		EF.CreateFrames()
	end
end

function EF:Initialize()
	if not E.private.enhanced.farmer.enabled then return end

	self:RegisterEvent("PLAYER_ENTERING_WORLD", "StartFarmBarLoader")
end

local function InitializeCallback()
	EF:Initialize()
end

E:RegisterModule(EF:GetName(), InitializeCallback)