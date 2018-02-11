local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local TT = E:NewModule('Tooltip', 'AceTimer-3.0', 'AceHook-3.0', 'AceEvent-3.0')

--Cache global variables
--Lua functions
local _G = _G
local unpack, select = unpack, select
local twipe, tinsert, tconcat = table.wipe, table.insert, table.concat
local floor = math.floor
local find, format, sub = string.find, string.format, string.sub
--WoW API / Variables
local CanInspect = CanInspect
local CreateFrame = CreateFrame
local C_PetJournalGetPetTeamAverageLevel = C_PetJournal.GetPetTeamAverageLevel
local GameTooltip_ClearMoney = GameTooltip_ClearMoney
local GetAverageItemLevel = GetAverageItemLevel
local GetCreatureDifficultyColor = GetCreatureDifficultyColor
local GetDetailedItemLevelInfo = GetDetailedItemLevelInfo
local GetGuildInfo = GetGuildInfo
local GetInspectSpecialization = GetInspectSpecialization
local GetInventoryItemLink = GetInventoryItemLink
local GetInventorySlotInfo = GetInventorySlotInfo
local GetItemCount = GetItemCount
local GetItemInfo = GetItemInfo
local GetMouseFocus = GetMouseFocus
local GetNumGroupMembers = GetNumGroupMembers
local GetRelativeDifficultyColor = GetRelativeDifficultyColor
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetSpecializationRoleByID = GetSpecializationRoleByID
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local IsShiftKeyDown = IsShiftKeyDown
local NotifyInspect = NotifyInspect
local SetTooltipMoney = SetTooltipMoney
local UnitAura = UnitAura
local UnitBattlePetLevel = UnitBattlePetLevel
local UnitBattlePetType = UnitBattlePetType
local UnitClass = UnitClass
local UnitClassification = UnitClassification
local UnitCreatureType = UnitCreatureType
local UnitExists = UnitExists
local UnitFactionGroup = UnitFactionGroup
local UnitGUID = UnitGUID
local UnitHasVehicleUI = UnitHasVehicleUI
local UnitIsAFK = UnitIsAFK
local UnitIsBattlePetCompanion = UnitIsBattlePetCompanion
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsDND = UnitIsDND
local UnitIsPlayer = UnitIsPlayer
local UnitIsPVP = UnitIsPVP
local UnitIsTapDenied = UnitIsTapDenied
local UnitIsUnit = UnitIsUnit
local UnitIsWildBattlePet = UnitIsWildBattlePet
local UnitLevel = UnitLevel
local UnitName = UnitName
local UnitPVPName = UnitPVPName
local UnitRace = UnitRace
local UnitReaction = UnitReaction
local UnitRealmRelationship = UnitRealmRelationship
local DEAD = DEAD
local FACTION_ALLIANCE = FACTION_ALLIANCE
local FACTION_BAR_COLORS = FACTION_BAR_COLORS
local FACTION_HORDE = FACTION_HORDE
local FOREIGN_SERVER_LABEL = FOREIGN_SERVER_LABEL
local ID = ID
local INTERACTIVE_SERVER_LABEL = INTERACTIVE_SERVER_LABEL
local LEVEL = LEVEL
local LE_REALM_RELATION_COALESCED = LE_REALM_RELATION_COALESCED
local LE_REALM_RELATION_VIRTUAL = LE_REALM_RELATION_VIRTUAL
local PVP = PVP
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local TARGET = TARGET

--Global variables that we don't cache, list them here for mikk's FindGlobals script
-- GLOBALS: ElvUI_ContainerFrame, RightChatPanel, TooltipMover, UIParent, ElvUI_KeyBinder
-- GLOBALS: RightChatToggleButton, BNToastFrame, MMHolder, GameTooltipText
-- GLOBALS: BNETMover, ItemRefTooltip, InspectFrame,  GameTooltipHeaderText, GameTooltipTextSmall
-- GLOBALS: ShoppingTooltip1TextLeft1, ShoppingTooltip1TextLeft2, ShoppingTooltip1TextLeft3
-- GLOBALS: ShoppingTooltip1TextLeft4, ShoppingTooltip1TextRight1, ShoppingTooltip1TextRight2
-- GLOBALS: ShoppingTooltip1TextRight3, ShoppingTooltip1TextRight4, ShoppingTooltip2TextLeft1
-- GLOBALS: ShoppingTooltip2TextLeft2, ShoppingTooltip2TextLeft3, ShoppingTooltip2TextLeft4
-- GLOBALS: ShoppingTooltip2TextRight1, ShoppingTooltip2TextRight2, ShoppingTooltip2TextRight3
-- GLOBALS: ShoppingTooltip2TextRight4, GameTooltipTextLeft1, GameTooltipTextLeft2, WorldMapTooltip
-- GLOBALS: CUSTOM_CLASS_COLORS

local GameTooltip, GameTooltipStatusBar = _G["GameTooltip"], _G["GameTooltipStatusBar"]
local targetList, inspectCache = {}, {}
local TAPPED_COLOR = { r=.6, g=.6, b=.6 }
local AFK_LABEL = " |cffFFFFFF[|r|cffFF0000"..L["AFK"].."|r|cffFFFFFF]|r"
local DND_LABEL = " |cffFFFFFF[|r|cffFFFF00"..L["DND"].."|r|cffFFFFFF]|r"
local keybindFrame

local classification = {
	worldboss = format("|cffAF5050 %s|r", BOSS),
	rareelite = format("|cffAF5050+ %s|r", ITEM_QUALITY3_DESC),
	elite = "|cffAF5050+|r",
	rare = format("|cffAF5050 %s|r", ITEM_QUALITY3_DESC)
}

local SlotName = {
	"Head","Neck","Shoulder","Back","Chest","Wrist",
	"Hands","Waist","Legs","Feet","Finger0","Finger1",
	"Trinket0","Trinket1","MainHand","SecondaryHand"
}

function TT:GameTooltip_SetDefaultAnchor(tt, parent)
	if tt:IsForbidden() then return end
	if E.private.tooltip.enable ~= true then return end
	if not self.db.visibility then return; end

	if(tt:GetAnchorType() ~= "ANCHOR_NONE") then return end
	if InCombatLockdown() and self.db.visibility.combat then
		tt:Hide()
		return
	end

	local ownerName = tt:GetOwner() and tt:GetOwner().GetName and tt:GetOwner():GetName()
	if (self.db.visibility.actionbars ~= 'NONE' and ownerName and (find(ownerName, "ElvUI_Bar") or find(ownerName, "ElvUI_StanceBar") or find(ownerName, "PetAction")) and not keybindFrame.active) then
		local modifier = self.db.visibility.actionbars

		if(modifier == 'ALL' or not ((modifier == 'SHIFT' and IsShiftKeyDown()) or (modifier == 'CTRL' and IsControlKeyDown()) or (modifier == 'ALT' and IsAltKeyDown()))) then
			tt:Hide()
			return
		end
	end

	if(parent) then
		if self.db.healthBar.statusPosition == "BOTTOM" then
			if(GameTooltipStatusBar.anchoredToTop) then
				GameTooltipStatusBar:ClearAllPoints()
				GameTooltipStatusBar:Point("TOPLEFT", GameTooltip, "BOTTOMLEFT", E.Border, -(E.Spacing * 3))
				GameTooltipStatusBar:Point("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -E.Border, -(E.Spacing * 3))
				GameTooltipStatusBar.text:Point("CENTER", GameTooltipStatusBar, 0, -3)
				GameTooltipStatusBar.anchoredToTop = nil
			end
		else
			if(not GameTooltipStatusBar.anchoredToTop) then
				GameTooltipStatusBar:ClearAllPoints()
				GameTooltipStatusBar:Point("BOTTOMLEFT", GameTooltip, "TOPLEFT", E.Border, (E.Spacing * 3))
				GameTooltipStatusBar:Point("BOTTOMRIGHT", GameTooltip, "TOPRIGHT", -E.Border, (E.Spacing * 3))
				GameTooltipStatusBar.text:Point("CENTER", GameTooltipStatusBar, 0, 3)
				GameTooltipStatusBar.anchoredToTop = true
			end
		end
		if(self.db.cursorAnchor) then
			tt:SetOwner(parent, "ANCHOR_CURSOR")
			return
		else
			tt:SetOwner(parent, "ANCHOR_NONE")
		end
	end

	local _, anchor = tt:GetPoint()
	if (anchor == nil or (ElvUI_ContainerFrame and anchor == ElvUI_ContainerFrame) or anchor == RightChatPanel or anchor == TooltipMover or anchor == UIParent or anchor == E.UIParent) then
		tt:ClearAllPoints()
		if(not E:HasMoverBeenMoved('TooltipMover')) then
			if ElvUI_ContainerFrame and ElvUI_ContainerFrame:IsShown() then
				tt:Point('BOTTOMRIGHT', ElvUI_ContainerFrame, 'TOPRIGHT', 0, 18)
			elseif RightChatPanel:GetAlpha() == 1 and RightChatPanel:IsShown() then
				tt:Point('BOTTOMRIGHT', RightChatPanel, 'TOPRIGHT', 0, 18)
			else
				tt:Point('BOTTOMRIGHT', RightChatPanel, 'BOTTOMRIGHT', 0, 18)
			end
		else
			local point = E:GetScreenQuadrant(TooltipMover)
			if point == "TOPLEFT" then
				tt:Point("TOPLEFT", TooltipMover, "BOTTOMLEFT", 1, -4)
			elseif point == "TOPRIGHT" then
				tt:Point("TOPRIGHT", TooltipMover, "BOTTOMRIGHT", -1, -4)
			elseif point == "BOTTOMLEFT" or point == "LEFT" then
				tt:Point("BOTTOMLEFT", TooltipMover, "TOPLEFT", 1, 18)
			else
				tt:Point("BOTTOMRIGHT", TooltipMover, "TOPRIGHT", -1, 18)
			end
		end
	end
end

function TT:GetItemLvL(unit)
	local total, item = 0, 0;
	local artifactEquipped = false
	for i = 1, #SlotName do
		local itemLink = GetInventoryItemLink(unit, GetInventorySlotInfo(("%sSlot"):format(SlotName[i])));
		if (itemLink ~= nil) then
			local _, _, rarity, _, _, _, _, _, equipLoc = GetItemInfo(itemLink)
			--Check if we have an artifact equipped in main hand
			if (equipLoc and equipLoc == "INVTYPE_WEAPONMAINHAND" and rarity and rarity == 6) then
				artifactEquipped = true
			end

			--If we have artifact equipped in main hand, then we should not count the offhand as it displays an incorrect item level
			if (not artifactEquipped or (artifactEquipped and equipLoc and equipLoc ~= "INVTYPE_WEAPONOFFHAND")) then
				local itemLevel = GetDetailedItemLevelInfo(itemLink)
				if(itemLevel and itemLevel > 0) then
					item = item + 1;
					total = total + itemLevel;
				end
			end
		end
	end

	if(total < 1 or item < 15) then
		return
	end

	return floor(total / item)
end

function TT:RemoveTrashLines(tt)
	if tt:IsForbidden() then return end
	for i=3, tt:NumLines() do
		local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()

		if(linetext == PVP or linetext == FACTION_ALLIANCE or linetext == FACTION_HORDE) then
			tiptext:SetText(nil)
			tiptext:Hide()
		end
	end
end

function TT:GetLevelLine(tt, offset)
	for i=offset, tt:NumLines() do
		local tipText = _G["GameTooltipTextLeft"..i]
		if(tipText:GetText() and tipText:GetText():find(LEVEL)) then
			return tipText
		end
	end
end

function TT:GetTalentSpec(unit, isPlayer)
	local spec
	if(isPlayer) then
		spec = GetSpecialization()
	else
		spec = GetInspectSpecialization(unit)
	end
	if(spec ~= nil and spec > 0) then
		if(not isPlayer) then
			local role = GetSpecializationRoleByID(spec);
			if(role ~= nil) then
				local _, name = GetSpecializationInfoByID(spec);
				return name
			end
		else
			local _, name = GetSpecializationInfo(spec)

			return name
		end
	end
end

function TT:INSPECT_READY(_, GUID)
	if(self.lastGUID ~= GUID) then return end

	local unit = "mouseover"
	if(UnitExists(unit)) then
		local itemLevel = self:GetItemLvL(unit)
		local talentName = self:GetTalentSpec(unit)
		inspectCache[GUID] = {time = GetTime()}

		if(talentName) then
			inspectCache[GUID].talent = talentName
		end

		if(itemLevel) then
			inspectCache[GUID].itemLevel = itemLevel
		end

		GameTooltip:SetUnit(unit)
	end
	self:UnregisterEvent("INSPECT_READY")
end

function TT:ShowInspectInfo(tt, unit, level, r, g, b, numTries)
	if tt:IsForbidden() then return end
	local canInspect = CanInspect(unit)
	if(not canInspect or level < 10 or numTries > 1) then return end

	local GUID = UnitGUID(unit)
	if(GUID == E.myguid) then
		tt:AddDoubleLine(L["Talent Specialization:"], self:GetTalentSpec(unit, true), nil, nil, nil, r, g, b)
		tt:AddDoubleLine(L["Item Level:"], floor(select(2, GetAverageItemLevel())), nil, nil, nil, 1, 1, 1)
	elseif(inspectCache[GUID]) then
		local talent = inspectCache[GUID].talent
		local itemLevel = inspectCache[GUID].itemLevel

		if(((GetTime() - inspectCache[GUID].time) > 900) or not talent or not itemLevel) then
			inspectCache[GUID] = nil

			return self:ShowInspectInfo(tt, unit, level, r, g, b, numTries + 1)
		end

		tt:AddDoubleLine(L["Talent Specialization:"], talent, nil, nil, nil, r, g, b)
		tt:AddDoubleLine(L["Item Level:"], itemLevel, nil, nil, nil, 1, 1, 1)
	else
		if(not canInspect) or (InspectFrame and InspectFrame:IsShown()) then return end
		self.lastGUID = GUID
		NotifyInspect(unit)
		self:RegisterEvent("INSPECT_READY")
	end
end

function TT:GameTooltip_OnTooltipSetUnit(tt)
	if tt:IsForbidden() then return end
	local unit = select(2, tt:GetUnit())
	if((tt:GetOwner() ~= UIParent) and (self.db.visibility and self.db.visibility.unitFrames ~= 'NONE')) then
		local modifier = self.db.visibility.unitFrames

		if(modifier == 'ALL' or not ((modifier == 'SHIFT' and IsShiftKeyDown()) or (modifier == 'CTRL' and IsControlKeyDown()) or (modifier == 'ALT' and IsAltKeyDown()))) then
			tt:Hide()
			return
		end
	end

	if(not unit) then
		local GMF = GetMouseFocus()
		if(GMF and GMF.GetAttribute and GMF:GetAttribute("unit")) then
			unit = GMF:GetAttribute("unit")
		end
		if(not unit or not UnitExists(unit)) then
			return
		end
	end

	self:RemoveTrashLines(tt) --keep an eye on this may be buggy
	local level = UnitLevel(unit)
	local isShiftKeyDown = IsShiftKeyDown()

	local color
	if(UnitIsPlayer(unit)) then
		local localeClass, class = UnitClass(unit)
		local name, realm = UnitName(unit)
		local guildName, guildRankName, _, guildRealm = GetGuildInfo(unit)
		local pvpName = UnitPVPName(unit)
		local relationship = UnitRealmRelationship(unit);
		if not localeClass or not class then return; end
		color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

		if(self.db.playerTitles and pvpName) then
			name = pvpName
		end

		if(realm and realm ~= "") then
			if(isShiftKeyDown) then
				name = name.."-"..realm
			elseif(relationship == LE_REALM_RELATION_COALESCED) then
				name = name..FOREIGN_SERVER_LABEL
			elseif(relationship == LE_REALM_RELATION_VIRTUAL) then
				name = name..INTERACTIVE_SERVER_LABEL
			end
		end

		if(UnitIsAFK(unit)) then
			name = name..AFK_LABEL
		elseif(UnitIsDND(unit)) then
			name = name..DND_LABEL
		end

		GameTooltipTextLeft1:SetFormattedText("|c%s%s|r", color.colorStr, name)

		local lineOffset = 2
		if(guildName) then
			if(guildRealm and isShiftKeyDown) then
				guildName = guildName.."-"..guildRealm
			end

			if(self.db.guildRanks) then
				GameTooltipTextLeft2:SetText(("<|cff00ff10%s|r> [|cff00ff10%s|r]"):format(guildName, guildRankName))
			else
				GameTooltipTextLeft2:SetText(("<|cff00ff10%s|r>"):format(guildName))
			end
			lineOffset = 3
		end


		local levelLine = self:GetLevelLine(tt, lineOffset)
		if(levelLine) then
			local diffColor = GetCreatureDifficultyColor(level)
			local race, englishRace = UnitRace(unit)
			local _, factionGroup = UnitFactionGroup(unit)
			if(factionGroup and englishRace == "Pandaren") then
				race = factionGroup.." "..race
			end
			levelLine:SetFormattedText("|cff%02x%02x%02x%s|r %s |c%s%s|r", diffColor.r * 255, diffColor.g * 255, diffColor.b * 255, level > 0 and level or "??", race or '', color.colorStr, localeClass)
		end

		--High CPU usage, restricting it to shift key down only.
		if(self.db.inspectInfo and isShiftKeyDown) then
			self:ShowInspectInfo(tt, unit, level, color.r, color.g, color.b, 0)
		end
	else
		if UnitIsTapDenied(unit) then
			color = TAPPED_COLOR
		else
			local unitReaction = UnitReaction(unit, "player")
			if E.db.tooltip.useCustomFactionColors then
				if unitReaction then
					unitReaction = format("%s", unitReaction) --Cast to string because our table is indexed by string keys
					color = E.db.tooltip.factionColors[unitReaction]
				end
			else
				color = FACTION_BAR_COLORS[unitReaction]
			end
		end

		local levelLine = self:GetLevelLine(tt, 2)
		if(levelLine) then
			local isPetWild, isPetCompanion = UnitIsWildBattlePet(unit), UnitIsBattlePetCompanion(unit);
			local creatureClassification = UnitClassification(unit)
			local creatureType = UnitCreatureType(unit)
			local pvpFlag = ""
			local diffColor
			if(isPetWild or isPetCompanion) then
				level = UnitBattlePetLevel(unit)

				local petType = _G["BATTLE_PET_NAME_"..UnitBattlePetType(unit)]
				if creatureType then
					creatureType = format("%s %s", creatureType, petType)
				else
					creatureType = petType
				end

				local teamLevel = C_PetJournalGetPetTeamAverageLevel();
				if(teamLevel) then
					diffColor = GetRelativeDifficultyColor(teamLevel, level);
				else
					diffColor = GetCreatureDifficultyColor(level)
				end
			else
				diffColor = GetCreatureDifficultyColor(level)
			end

			if(UnitIsPVP(unit)) then
				pvpFlag = format(" (%s)", PVP)
			end

			levelLine:SetFormattedText("|cff%02x%02x%02x%s|r%s %s%s", diffColor.r * 255, diffColor.g * 255, diffColor.b * 255, level > 0 and level or "??", classification[creatureClassification] or "", creatureType or "", pvpFlag)
		end
	end

	local unitTarget = unit.."target"
	if(self.db.targetInfo and unit ~= "player" and UnitExists(unitTarget)) then
		local targetColor
		if(UnitIsPlayer(unitTarget) and not UnitHasVehicleUI(unitTarget)) then
			local _, class = UnitClass(unitTarget)
			targetColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
		else
			targetColor = E.db.tooltip.useCustomFactionColors and E.db.tooltip.factionColors[""..UnitReaction(unitTarget, "player")] or FACTION_BAR_COLORS[UnitReaction(unitTarget, "player")]
		end

		GameTooltip:AddDoubleLine(format("%s:", TARGET), format("|cff%02x%02x%02x%s|r", targetColor.r * 255, targetColor.g * 255, targetColor.b * 255, UnitName(unitTarget)))
	end

	if(self.db.targetInfo and IsInGroup()) then
		for i = 1, GetNumGroupMembers() do
			local groupUnit = (IsInRaid() and "raid"..i or "party"..i);
			if (UnitIsUnit(groupUnit.."target", unit)) and (not UnitIsUnit(groupUnit,"player")) then
				local _, class = UnitClass(groupUnit);
				local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
				tinsert(targetList, format("|c%s%s|r", color.colorStr, UnitName(groupUnit)))
			end
		end
		local numList = #targetList
		if (numList > 0) then
			GameTooltip:AddLine(format("%s (|cffffffff%d|r): %s", L["Targeted By:"], numList, tconcat(targetList, ", ")), nil, nil, nil, true);
			twipe(targetList);
		end
	end

	if(color) then
		GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
	else
		GameTooltipStatusBar:SetStatusBarColor(0.6, 0.6, 0.6)
	end

	local textWidth = GameTooltipStatusBar.text:GetStringWidth()
	if textWidth then
		tt:SetMinimumWidth(textWidth)
	end
end

function TT:GameTooltipStatusBar_OnValueChanged(tt, value)
	if tt:IsForbidden() then return end
	if not value or not self.db.healthBar.text or not tt.text then return end
	local unit = select(2, tt:GetParent():GetUnit())
	if(not unit) then
		local GMF = GetMouseFocus()
		if(GMF and GMF.GetAttribute and GMF:GetAttribute("unit")) then
			unit = GMF:GetAttribute("unit")
		end
	end

	local _, max = tt:GetMinMaxValues()
	if(value > 0 and max == 1) then
		tt.text:SetFormattedText("%d%%", floor(value * 100))
		tt:SetStatusBarColor(TAPPED_COLOR.r, TAPPED_COLOR.g, TAPPED_COLOR.b) --most effeciant?
	elseif(value == 0 or (unit and UnitIsDeadOrGhost(unit))) then
		tt.text:SetText(DEAD)
	else
		tt.text:SetText(E:ShortValue(value).." / "..E:ShortValue(max))
	end
end

function TT:GameTooltip_OnTooltipCleared(tt)
	if tt:IsForbidden() then return end
	tt.itemCleared = nil
end

function TT:GameTooltip_OnTooltipSetItem(tt)
	if tt:IsForbidden() then return end
	local ownerName = tt:GetOwner() and tt:GetOwner().GetName and tt:GetOwner():GetName()
	if (self.db.visibility and self.db.visibility.bags ~= 'NONE' and ownerName and (find(ownerName, "ElvUI_Container") or find(ownerName, "ElvUI_BankContainer"))) then
		local modifier = self.db.visibility.bags

		if(modifier == 'ALL' or not ((modifier == 'SHIFT' and IsShiftKeyDown()) or (modifier == 'CTRL' and IsControlKeyDown()) or (modifier == 'ALT' and IsAltKeyDown()))) then
			tt.itemCleared = true
			tt:Hide()
			return
		end
	end

	if not tt.itemCleared then
		local _, link = tt:GetItem()
		local num = GetItemCount(link)
		local numall = GetItemCount(link,true)
		local left = " "
		local right = " "
		local bankCount = " "

		if link ~= nil and self.db.spellID then
			left = (("|cFFCA3C3C%s|r %s"):format(ID, link)):match(":(%w+)")
		end

		if self.db.itemCount == "BAGS_ONLY" then
			right = ("|cFFCA3C3C%s|r %d"):format(L["Count"], num)
		elseif self.db.itemCount == "BANK_ONLY" then
			bankCount = ("|cFFCA3C3C%s|r %d"):format(L["Bank"],(numall - num))
		elseif self.db.itemCount == "BOTH" then
			right = ("|cFFCA3C3C%s|r %d"):format(L["Count"], num)
			bankCount = ("|cFFCA3C3C%s|r %d"):format(L["Bank"],(numall - num))
		end

		if left ~= " " or right ~= " " then
			tt:AddLine(" ")
			tt:AddDoubleLine(left, right)
		end
		if bankCount ~= " " then
			tt:AddDoubleLine(" ", bankCount)
		end

		tt.itemCleared = true
	end
end

function TT:GameTooltip_ShowStatusBar(tt)
	if tt:IsForbidden() then return end
	local statusBar = _G[tt:GetName().."StatusBar"..tt.shownStatusBars];
	if statusBar and not statusBar.skinned then
		statusBar:StripTextures()
		statusBar:SetStatusBarTexture(E['media'].normTex)
		E:RegisterStatusBar(statusBar)
		statusBar:CreateBackdrop('Default')
		statusBar.skinned = true;
	end
end

function TT:SetStyle(tt)
	if tt:IsForbidden() then return end
	tt:SetTemplate("Transparent", nil, true) --ignore updates
	local r, g, b = tt:GetBackdropColor()
	tt:SetBackdropColor(r, g, b, self.db.colorAlpha)
end

function TT:MODIFIER_STATE_CHANGED(_, key)
	if((key == "LSHIFT" or key == "RSHIFT") and UnitExists("mouseover")) then
		GameTooltip:SetUnit('mouseover')
	end
end

function TT:SetUnitAura(tt, unit, index, filter)
	if tt:IsForbidden() then return end
	local _, _, _, _, _, _, _, caster, _, _, id = UnitAura(unit, index, filter)
	if id and self.db.spellID then
		if caster then
			local name = UnitName(caster)
			local _, class = UnitClass(caster)
			local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
			tt:AddDoubleLine(("|cFFCA3C3C%s|r %d"):format(ID, id), format("|c%s%s|r", color.colorStr, name))
		else
			tt:AddLine(("|cFFCA3C3C%s|r %d"):format(ID, id))
		end

		tt:Show()
	end
end

function TT:GameTooltip_OnTooltipSetSpell(tt)
	if tt:IsForbidden() then return end
	local id = select(3, tt:GetSpell())
	if not id or not self.db.spellID then return end

	local displayString = ("|cFFCA3C3C%s|r %d"):format(ID, id)
	local lines = tt:NumLines()
	local isFound
	for i= 1, lines do
		local line = _G[("GameTooltipTextLeft%d"):format(i)]
		if line and line:GetText() and line:GetText():find(displayString) then
			isFound = true;
			break
		end
	end

	if not isFound then
		tt:AddLine(displayString)
		tt:Show()
	end
end

function TT:SetItemRef(link)
	if find(link,"^spell:") and self.db.spellID then
		local id = sub(link,7)
		ItemRefTooltip:AddLine(("|cFFCA3C3C%s|r %d"):format(ID, id))
		ItemRefTooltip:Show()
	end
end

function TT:RepositionBNET(frame, _, anchor)
	if anchor ~= BNETMover then
		frame:ClearAllPoints()
		frame:SetPoint(BNETMover.anchorPoint or 'TOPLEFT', BNETMover, BNETMover.anchorPoint or 'TOPLEFT');
	end
end

function TT:CheckBackdropColor()
	if GameTooltip:IsForbidden() then return end
	if not GameTooltip:IsShown() then return end
	local r, g, b = GameTooltip:GetBackdropColor()
	if (r and g and b) then
		r = E:Round(r, 1)
		g = E:Round(g, 1)
		b = E:Round(b, 1)
		local red, green, blue = unpack(E.media.backdropfadecolor)
		if (r ~= red or g ~= green or b ~= blue) then
			GameTooltip:SetBackdropColor(red, green, blue, self.db.colorAlpha)
		end
	end
end

function TT:SetTooltipFonts()
	local font = E.LSM:Fetch("font", E.db.tooltip.font)
	local fontOutline = E.db.tooltip.fontOutline
	local headerSize = E.db.tooltip.headerFontSize
	local textSize = E.db.tooltip.textFontSize
	local smallTextSize = E.db.tooltip.smallTextFontSize

	GameTooltipHeaderText:SetFont(font, headerSize, fontOutline)
	GameTooltipText:SetFont(font, textSize, fontOutline)
	GameTooltipTextSmall:SetFont(font, smallTextSize, fontOutline)
	if GameTooltip.hasMoney then
		for i = 1, GameTooltip.numMoneyFrames do
			_G["GameTooltipMoneyFrame"..i.."PrefixText"]:SetFont(font, textSize, fontOutline)
			_G["GameTooltipMoneyFrame"..i.."SuffixText"]:SetFont(font, textSize, fontOutline)
			_G["GameTooltipMoneyFrame"..i.."GoldButtonText"]:SetFont(font, textSize, fontOutline)
			_G["GameTooltipMoneyFrame"..i.."SilverButtonText"]:SetFont(font, textSize, fontOutline)
			_G["GameTooltipMoneyFrame"..i.."CopperButtonText"]:SetFont(font, textSize, fontOutline)
		end
	end

	--These show when you compare items ("Currently Equipped", name of item, item level)
	--Since they appear at the top of the tooltip, we set it to use the header font size.
	ShoppingTooltip1TextLeft1:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip1TextLeft2:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip1TextLeft3:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip1TextLeft4:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip1TextRight1:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip1TextRight2:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip1TextRight3:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip1TextRight4:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip2TextLeft1:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip2TextLeft2:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip2TextLeft3:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip2TextLeft4:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip2TextRight1:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip2TextRight2:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip2TextRight3:SetFont(font, headerSize, fontOutline)
	ShoppingTooltip2TextRight4:SetFont(font, headerSize, fontOutline)
end

--This changes the growth direction of the toast frame depending on position of the mover
local function PostBNToastMove(mover)
	local x, y = mover:GetCenter();
	local screenHeight = E.UIParent:GetTop();
	local screenWidth = E.UIParent:GetRight()

	local anchorPoint
	if (y > (screenHeight / 2)) then
		anchorPoint = (x > (screenWidth/2)) and "TOPRIGHT" or "TOPLEFT"
	else
		anchorPoint = (x > (screenWidth/2)) and "BOTTOMRIGHT" or "BOTTOMLEFT"
	end
	mover.anchorPoint = anchorPoint

	BNToastFrame:ClearAllPoints()
	BNToastFrame:Point(anchorPoint, mover)
end

function TT:Initialize()
	self.db = E.db.tooltip

	BNToastFrame:Point('TOPRIGHT', MMHolder, 'BOTTOMRIGHT', 0, -10);
	E:CreateMover(BNToastFrame, 'BNETMover', L["BNet Frame"], nil, nil, PostBNToastMove)
	self:SecureHook(BNToastFrame, "SetPoint", "RepositionBNET")

	if E.private.tooltip.enable ~= true then return end
	E.Tooltip = TT

	GameTooltipStatusBar:Height(self.db.healthBar.height)
	GameTooltipStatusBar:SetScript("OnValueChanged", nil) -- Do we need to unset this?
	GameTooltipStatusBar.text = GameTooltipStatusBar:CreateFontString(nil, "OVERLAY")
	GameTooltipStatusBar.text:Point("CENTER", GameTooltipStatusBar, 0, -3)
	GameTooltipStatusBar.text:FontTemplate(E.LSM:Fetch("font", self.db.healthBar.font), self.db.healthBar.fontSize, self.db.healthBar.fontOutline)

	--Tooltip Fonts
	if not GameTooltip.hasMoney then
		 --Force creation of the money lines, so we can set font for it
		SetTooltipMoney(GameTooltip, 1, nil, "", "")
		SetTooltipMoney(GameTooltip, 1, nil, "", "")
		GameTooltip_ClearMoney(GameTooltip)
	end
	self:SetTooltipFonts()

	local GameTooltipAnchor = CreateFrame('Frame', 'GameTooltipAnchor', E.UIParent)
	GameTooltipAnchor:Point('BOTTOMRIGHT', RightChatToggleButton, 'BOTTOMRIGHT')
	GameTooltipAnchor:Size(130, 20)
	GameTooltipAnchor:SetFrameLevel(GameTooltipAnchor:GetFrameLevel() + 400)
	E:CreateMover(GameTooltipAnchor, 'TooltipMover', L["Tooltip"])

	self:SecureHook('GameTooltip_SetDefaultAnchor')
	self:SecureHook("SetItemRef")
	self:SecureHook(GameTooltip, "SetUnitAura")
	self:SecureHook(GameTooltip, "SetUnitBuff", "SetUnitAura")
	self:SecureHook(GameTooltip, "SetUnitDebuff", "SetUnitAura")
	self:SecureHookScript(GameTooltip, "OnTooltipSetSpell", "GameTooltip_OnTooltipSetSpell")
	self:SecureHookScript(GameTooltip, 'OnTooltipCleared', 'GameTooltip_OnTooltipCleared')
	self:SecureHookScript(GameTooltip, 'OnTooltipSetItem', 'GameTooltip_OnTooltipSetItem')
	self:SecureHookScript(GameTooltip, 'OnTooltipSetUnit', 'GameTooltip_OnTooltipSetUnit')
	self:SecureHookScript(GameTooltipStatusBar, 'OnValueChanged', 'GameTooltipStatusBar_OnValueChanged')
	self:RegisterEvent("MODIFIER_STATE_CHANGED")

	--Variable is localized at top of file, then set here when we're sure the frame has been created
	--Used to check if keybinding is active, if so then don't hide tooltips on actionbars
	keybindFrame = ElvUI_KeyBinder
end

local function InitializeCallback()
	TT:Initialize()
end

E:RegisterModule(TT:GetName(), InitializeCallback)