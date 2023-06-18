local E, L, V, P, G = unpack(ElvUI)
local mod = E:GetModule("Enhanced_Blizzard")
local S = E:GetModule("Skins")

local _G = _G
local band = bit.band
local ceil, floor = math.ceil, math.floor
local format, upper, sub, join = string.format, string.upper, string.sub, string.join
local tsort, twipe = table.sort, table.wipe
local pcall = pcall
local tonumber = tonumber

local CannotBeResurrected = CannotBeResurrected
local CopyTable = CopyTable
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local GetReleaseTimeRemaining = GetReleaseTimeRemaining
local GetSpellInfo = GetSpellInfo
local GetSpellLink = GetSpellLink
local HasSoulstone = HasSoulstone
local IsActiveBattlefieldArena = IsActiveBattlefieldArena
local RepopMe = RepopMe
local UnitClass = UnitClass
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UseSoulstone = UseSoulstone

local ACTION_SWING = ACTION_SWING
local ARENA_SPECTATOR = ARENA_SPECTATOR
local COMBATLOG_FILTER_ME = COMBATLOG_FILTER_ME
local COMBATLOG_UNKNOWN_UNIT = COMBATLOG_UNKNOWN_UNIT
local DEATH_RELEASE_NOTIMER = DEATH_RELEASE_NOTIMER
local DEATH_RELEASE_SPECTATOR = DEATH_RELEASE_SPECTATOR
local DEATH_RELEASE_TIMER = DEATH_RELEASE_TIMER
local MINUTES = MINUTES
local SECONDS = SECONDS
local TEXT_MODE_A_STRING_VALUE_SCHOOL = TEXT_MODE_A_STRING_VALUE_SCHOOL

local lastDeathEvents
local index = 0
local deathList = {}
local eventList = {}

local function AddEvent(timestamp, event, sourceGUID, sourceName, spellId, spellName, environmentalType, amount, overkill, school, resisted, blocked, absorbed, critical)
	if index > 0 and eventList[index].timestamp + 10 <= timestamp then
		index = 0
		twipe(eventList)
	end

	if index < 5 then
		index = index + 1
	else
		index = 1
	end

	if not eventList[index] then
		eventList[index] = {}
	else
		twipe(eventList[index])
	end

	eventList[index].timestamp = timestamp
	eventList[index].event = event
	eventList[index].sourceGUID = sourceGUID
	eventList[index].sourceName = sourceName
	eventList[index].spellId = spellId
	eventList[index].spellName = spellName
	eventList[index].environmentalType = environmentalType
	eventList[index].amount = amount
	eventList[index].overkill = overkill
	eventList[index].school = school
	eventList[index].resisted = resisted
	eventList[index].blocked = blocked
	eventList[index].absorbed = absorbed
	eventList[index].critical = critical
	eventList[index].currentHP = UnitHealth("player")
	eventList[index].maxHP = UnitHealthMax("player")
end

local function HasEvents()
	if lastDeathEvents then
		return #deathList > 0, #deathList
	else
		return false, #deathList
	end
end

local function EraseEvents()
	if index > 0 then
		index = 0
		twipe(eventList)
	end
end

local function AddDeath()
	if #eventList > 0 then
		local _, deathEvents = HasEvents()
		local deathIndex = deathEvents + 1
		deathList[deathIndex] = CopyTable(eventList)
		EraseEvents()

		DEFAULT_CHAT_FRAME:AddMessage("|cff71d5ff|Hdeath:"..deathIndex.."|h["..L["You died."].."]|h|r")

		return true
	end
end

local function GetDeathEvents(recapID)
	if recapID and deathList[recapID] then
		local deathEvents = deathList[recapID]
		tsort(deathEvents, function(a, b) return a.timestamp > b.timestamp end)
		return deathEvents
	end
end

local function GetTableInfo(data)
	local texture
	local nameIsNotSpell = false

	local event = data.event
	local spellId = data.spellId
	local spellName = data.spellName

	if event == "SWING_DAMAGE" then
		spellId = 88163
		spellName = ACTION_SWING

		nameIsNotSpell = true
	elseif event == "RANGE_DAMAGE" then
		nameIsNotSpell = true
	elseif event == "ENVIRONMENTAL_DAMAGE" then
		local environmentalType = data.environmentalType
		environmentalType = upper(environmentalType)
		spellName = _G["ACTION_ENVIRONMENTAL_DAMAGE_"..environmentalType]
		nameIsNotSpell = true
		if environmentalType == "DROWNING" then
			texture = "spell_shadow_demonbreath"
		elseif environmentalType == "FALLING" then
			texture = "ability_rogue_quickrecovery"
		elseif environmentalType == "FIRE" or environmentalType == "LAVA" then
			texture = "spell_fire_fire"
		elseif environmentalType == "SLIME" then
			texture = "inv_misc_slime_01"
		elseif environmentalType == "FATIGUE" then
			texture = "ability_creature_cursed_05"
		else
			texture = "ability_creature_cursed_05"
		end
		texture = "Interface\\Icons\\"..texture
	end

	if spellName and nameIsNotSpell then
		spellName = format("|Haction:%s|h%s|h", event, spellName)
	end

	if spellId and not texture then
		texture = select(3, GetSpellInfo(spellId))
	end

	return spellId, spellName, texture
end

local function OpenRecap(recapID)
	local self = ElvUI_DeathRecapFrame

	if self:IsShown() and self.recapID == recapID then
		self:Hide()
		return
	end

	local deathEvents = GetDeathEvents(recapID)
	if not deathEvents then return end

	self.recapID = recapID
	self:Show()

	if not deathEvents or #deathEvents <= 0 then
		for i = 1, 5 do
			self.DeathRecapEntry[i]:Hide()
		end
		self.Unavailable:Show()
		return
	end
	self.Unavailable:Hide()

	local highestDmgIdx, highestDmgAmount = 1, 0
	self.DeathTimeStamp = nil

	for i = 1, #deathEvents do
		local entry = self.DeathRecapEntry[i]
		local dmgInfo = entry.DamageInfo
		local evtData = deathEvents[i]
		local spellId, spellName, texture = GetTableInfo(evtData)

		entry:Show()
		self.DeathTimeStamp = self.DeathTimeStamp or evtData.timestamp

		if evtData.amount then
			local amountStr = E:GetFormattedText("CURRENT", -evtData.amount)

			dmgInfo.Amount:SetText(amountStr)
			dmgInfo.AmountLarge:SetText(amountStr)

			dmgInfo.dmgExtraStr = ""

			local ovrkStr, absoStr, resiStr, blckStr = "", "", "", ""
			local ovrkSpacer, absoSpacer, resiSpacer, blckSpacer, critSpacer = "", "", "", "", ""
			if evtData.overkill and evtData.overkill > 0 then
				ovrkStr = format(L["(%d Overkill)"], evtData.overkill)
				ovrkSpacer = " "
			end
			if evtData.absorbed and evtData.absorbed > 0 then
				absoStr = format(L["(%d Absorbed)"], evtData.absorbed)
				absoSpacer = " "
			end
			if evtData.resisted and evtData.resisted > 0 then
				resiStr = format(L["(%d Resisted)"], evtData.resisted)
				resiSpacer = " "
			end
			if evtData.blocked and evtData.blocked > 0 then
				blckStr = format(L["(%d Blocked)"], evtData.blocked)
				blckSpacer = " "
			end
			local critStr = (evtData.critical and evtData.critical > 0) and L["Critical"] or ""
			dmgInfo.dmgExtraStr = join("", dmgInfo.dmgExtraStr, "", ovrkStr, ovrkSpacer, absoStr, absoSpacer, resiStr, resiSpacer, blckStr, blckSpacer, critStr)

			local absoDmg = (evtData.absorbed and evtData.absorbed > 0) and evtData.absorbed or 0
			local resiDmg = (evtData.resisted and evtData.resisted > 0) and evtData.resisted or 0
			local blckDmg = (evtData.blocked and evtData.blocked > 0) and evtData.blocked or 0

			dmgInfo.amount = evtData.amount - (absoDmg + resiDmg + blckDmg)

			if evtData.amount > highestDmgAmount then
				highestDmgIdx = i
				highestDmgAmount = evtData.amount
			end

			dmgInfo.Amount:Show()
			dmgInfo.AmountLarge:Hide()
		else
			dmgInfo.Amount:SetText("")
			dmgInfo.AmountLarge:SetText("")
			dmgInfo.amount = nil
			dmgInfo.dmgExtraStr = nil
		end

		dmgInfo.timestamp = evtData.timestamp
		dmgInfo.hpPercent = floor(evtData.currentHP / evtData.maxHP * 100)

		dmgInfo.spellName = spellName

		dmgInfo.caster = evtData.sourceName or COMBATLOG_UNKNOWN_UNIT
		entry.SpellInfo.Caster:SetText(dmgInfo.caster)

		local class = select(3, pcall(GetPlayerInfoByGUID, evtData.sourceGUID))
		if class then
			local classColor = E:ClassColor(class)
			entry.SpellInfo.Caster:SetTextColor(classColor.r, classColor.g, classColor.b)
		else
			entry.SpellInfo.Caster:SetTextColor(0.5, 0.5, 0.5)
		end

		if evtData.school and evtData.school > 1 then
			local colorArray = CombatLog_Color_ColorArrayBySchool(evtData.school)
			entry.SpellInfo.FrameIcon:SetBackdropBorderColor(colorArray.r, colorArray.g, colorArray.b)
		else
			entry.SpellInfo.FrameIcon:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end

		dmgInfo.school = evtData.school

		entry.SpellInfo.Name:SetText(spellName)
		entry.SpellInfo.Icon:SetTexture(texture)

		entry.SpellInfo.spellId = spellId
	end

	for i = #deathEvents + 1, #self.DeathRecapEntry do
		self.DeathRecapEntry[i]:Hide()
	end

	local entry = self.DeathRecapEntry[highestDmgIdx]
	if entry.DamageInfo.amount then
		entry.DamageInfo.Amount:Hide()
		entry.DamageInfo.AmountLarge:Show()
	end
end

local function Spell_OnEnter(self)
	if self.spellId then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetHyperlink(GetSpellLink(self.spellId))
		GameTooltip:Show()
	end
end

local function Amount_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()
	if self.amount then
		local valueStr = self.school and format("%s %s", self.amount, CombatLog_String_SchoolString(self.school)) or self.amount
		GameTooltip:AddLine(format(L["%s %s"], valueStr, self.dmgExtraStr), 1, 0, 0, false)
	end

	if self.spellName then
		if self.caster then
			GameTooltip:AddLine(format(L["%s by %s"], self.spellName, self.caster), 1, 1, 1, true)
		else
			GameTooltip:AddLine(self.spellName, 1, 1, 1, true)
		end
	end

	local seconds = ElvUI_DeathRecapFrame.DeathTimeStamp - self.timestamp
	if seconds > 0 then
		GameTooltip:AddLine(format(L["%s sec before death at %s%% health."], format("%.1F", seconds), self.hpPercent), 1, 0.824, 0, true)
	else
		GameTooltip:AddLine(format(L["Killing blow at %s%% health."], self.hpPercent), 1, 0.824, 0, true)
	end

	GameTooltip:Show()
end

function mod:HideDeathPopup()
	E:StaticPopup_Hide("DEATH")
end

function mod:PLAYER_DEAD()
	if StaticPopup_FindVisible("DEATH") then
		if AddDeath() then
			lastDeathEvents = true
		else
			lastDeathEvents = false
		end

		StaticPopup_Hide("DEATH")
		E:StaticPopup_Show("DEATH", GetReleaseTimeRemaining(), SECONDS)
	end
end

function mod:COMBAT_LOG_EVENT_UNFILTERED(_, timestamp, event, _, sourceGUID, sourceName, sourceFlags, _, _, _, destFlags, ...)
	if (band(destFlags, COMBATLOG_FILTER_ME) ~= COMBATLOG_FILTER_ME) or (band(sourceFlags, COMBATLOG_FILTER_ME) == COMBATLOG_FILTER_ME) then return end
	if event ~= "ENVIRONMENTAL_DAMAGE" and event ~= "RANGE_DAMAGE" and event ~= "SPELL_DAMAGE" and event ~= "SPELL_EXTRA_ATTACKS" and event ~= "SPELL_INSTAKILL" and event ~= "SPELL_PERIODIC_DAMAGE" and event ~= "SWING_DAMAGE" then return end

	local subVal = sub(event, 1, 5)
	local _, environmentalType, spellId, spellName, amount, overkill, school, resisted, blocked, absorbed

	if event == "SWING_DAMAGE" then
		_, amount, overkill, school, resisted, blocked, absorbed, critical = ...
	elseif subVal == "SPELL" or event == "RANGE_DAMAGE" then
		_, spellId, spellName, _, amount, overkill, school, resisted, blocked, absorbed, critical = ...
	elseif event == "ENVIRONMENTAL_DAMAGE" then
		_, environmentalType, amount, overkill, school, resisted, blocked, absorbed, critical = ...
	end

	if not tonumber(amount) then return end

	AddEvent(timestamp, event, sourceGUID, sourceName, spellId, spellName, environmentalType, amount, overkill, school, resisted, blocked, absorbed, critical)
end

function mod:SetItemRef(link, ...)
	if sub(link, 1, 5) == "death" then
		local _, id = strsplit(":", link)
		OpenRecap(tonumber(id))
		return
	else
		self.hooks.SetItemRef(link, ...)
	end
end

function mod:DeathRecap()
	if DeathRecapFrame then return end
	if not E.private.enhanced.deathRecap then return end

	local frame = CreateFrame("Frame", "ElvUI_DeathRecapFrame", UIParent)
	frame:Size(340, 326)
	frame:Point("CENTER")
	frame:SetTemplate("Transparent")
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:Hide()
	frame:SetScript("OnHide", function(self) self.recapID = nil end)
	tinsert(UISpecialFrames, frame:GetName())

	frame.Title = frame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	frame.Title:Point("TOP", 0, -9)
	frame.Title:SetText(L["Death Recap"])

	frame.Unavailable = frame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	frame.Unavailable:Point("CENTER")
	frame.Unavailable:SetText(L["Death Recap unavailable."])

	frame.CloseXButton = CreateFrame("Button", "$parentCloseXButton", frame, "UIPanelCloseButton")
	frame.CloseXButton:Size(32)
	frame.CloseXButton:Point("TOPRIGHT", 2, 1)
	frame.CloseXButton:SetScript("OnClick", function(self) self:GetParent():Hide() end)
	S:HandleCloseButton(frame.CloseXButton)

	frame.DragButton = CreateFrame("Button", "$parentDragButton", frame)
	frame.DragButton:Point("TOPLEFT", 0, 0)
	frame.DragButton:Point("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -32)
	frame.DragButton:RegisterForDrag("LeftButton")
	frame.DragButton:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
	frame.DragButton:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)

	frame:SetScript("OnShow", function() PlaySound("igMainMenuOption") end)
	frame:SetScript("OnHide", function() PlaySound("igMainMenuOptionCheckBoxOn") end)

	frame.DeathRecapEntry = {}
	for i = 1, 5 do
		local button = CreateFrame("Frame", nil, frame)
		button:Size(308, 34)
		button:SetTemplate("Transparent")

		frame.DeathRecapEntry[i] = button

		button.DamageInfo = CreateFrame("Button", nil, button)
		button.DamageInfo:Point("TOPLEFT", 0, 0)
		button.DamageInfo:Point("BOTTOMRIGHT", button, "BOTTOMLEFT", 90, 0)
		button.DamageInfo:SetScript("OnEnter", Amount_OnEnter)
		button.DamageInfo:SetScript("OnLeave", GameTooltip_Hide)

		button.DamageInfo.Amount = button.DamageInfo:CreateFontString("ARTWORK", nil, "GameFontNormalRight")
		button.DamageInfo.Amount:Size(0, 32)
		button.DamageInfo.Amount:SetTextColor(0.75, 0.05, 0.05, 1)
		button.DamageInfo.Amount:Point("TOPRIGHT", -6, -1)
		button.DamageInfo.Amount:SetJustifyH("LEFT")
		button.DamageInfo.Amount:SetJustifyV("CENTER")

		button.DamageInfo.AmountLarge = button.DamageInfo:CreateFontString("ARTWORK", nil, "NumberFont_Outline_Large")
		button.DamageInfo.AmountLarge:Size(0, 32)
		button.DamageInfo.AmountLarge:SetTextColor(1, 0.07, 0.07, 1)
		button.DamageInfo.AmountLarge:Point("TOPRIGHT", -6, -1)
		button.DamageInfo.AmountLarge:SetJustifyH("LEFT")
		button.DamageInfo.AmountLarge:SetJustifyV("CENTER")

		button.SpellInfo = CreateFrame("Button", nil, button)
		button.SpellInfo:Point("TOPLEFT", button.DamageInfo, "TOPRIGHT", 2, 0)
		button.SpellInfo:Point("BOTTOMRIGHT", 2, 0)
		button.SpellInfo:SetScript("OnEnter", Spell_OnEnter)
		button.SpellInfo:SetScript("OnLeave", GameTooltip_Hide)

		button.SpellInfo.FrameIcon = CreateFrame("Button", nil, button.SpellInfo)
		button.SpellInfo.FrameIcon:Size(34)
		button.SpellInfo.FrameIcon:Point("LEFT", 0, 0)
		button.SpellInfo.FrameIcon:SetTemplate()

		button.SpellInfo.Icon = button.SpellInfo:CreateTexture("ARTWORK")
		button.SpellInfo.Icon:SetParent(button.SpellInfo.FrameIcon)
		button.SpellInfo.Icon:SetTexCoord(unpack(E.TexCoords))
		button.SpellInfo.Icon:SetInside()

		button.SpellInfo.Name = button.SpellInfo:CreateFontString("ARTWORK", nil, "GameFontNormal")
		button.SpellInfo.Name:SetJustifyH("LEFT")
		button.SpellInfo.Name:SetJustifyV("BOTTOM")
		button.SpellInfo.Name:Point("BOTTOMLEFT", button.SpellInfo.Icon, "RIGHT", 6, 1)
		button.SpellInfo.Name:Point("TOPRIGHT", 0, 0)

		button.SpellInfo.Caster = button.SpellInfo:CreateFontString("ARTWORK", nil, "SystemFont_Shadow_Small")
		button.SpellInfo.Caster:SetJustifyH("LEFT")
		button.SpellInfo.Caster:SetJustifyV("TOP")
		button.SpellInfo.Caster:Point("TOPLEFT", button.SpellInfo.Icon, "RIGHT", 6, -2)
		button.SpellInfo.Caster:Point("BOTTOMRIGHT", 0, 0)
		button.SpellInfo.Caster:SetTextColor(0.5, 0.5, 0.5, 1)

		if i == 1 then
			button:Point("BOTTOMLEFT", 16, 64)

			button.tombstone = button:CreateTexture("ARTWORK")
			button.tombstone:Size(15, 20)
			button.tombstone:Point("LEFT", button.DamageInfo, "LEFT", 8, 0)
			button.tombstone:SetTexCoord(0.658203125, 0.6875, 0.00390625, 0.08203125)
			button.tombstone:SetTexture(E.EnhancedMedia.Textures.DeathRecap)
		else
			button:Point("BOTTOM", frame.DeathRecapEntry[i - 1], "TOP", 0, 14)
		end
	end

	frame.CloseButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.CloseButton:Size(144, 21)
	frame.CloseButton:Point("BOTTOM", 0, 15)
	frame.CloseButton:SetText(CLOSE)
	frame.CloseButton:SetScript("OnClick", function() ElvUI_DeathRecapFrame:Hide() end)
	S:HandleButton(frame.CloseButton)

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_DEAD")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "HideDeathPopup")
	self:RegisterEvent("RESURRECT_REQUEST", "HideDeathPopup")
	self:RegisterEvent("PLAYER_ALIVE", "HideDeathPopup")
	self:RegisterEvent("RAISED_AS_GHOUL", "HideDeathPopup")

	self:RawHook("SetItemRef", true)

	E.PopupDialogs.DEATH = {
		text = DEATH_RELEASE_TIMER,
		button1 = DEATH_RELEASE,
		button2 = USE_SOULSTONE,
		button3 = L["Recap"],
		OnShow = function(self)
			self.timeleft = GetReleaseTimeRemaining()
			local text = HasSoulstone()
			if text then
				self.button2:SetText(text)
			end

			if IsActiveBattlefieldArena() then
				self.text:SetText(DEATH_RELEASE_SPECTATOR)
			elseif self.timeleft == -1 then
				self.text:SetText(DEATH_RELEASE_NOTIMER)
			end
			if HasEvents() then
				self.button3:Enable()
			else
				self.button3:Disable()
			end
		end,
		OnHide = function(self)
			ElvUI_DeathRecapFrame:Hide()
		end,
		OnAccept = function()
			if IsActiveBattlefieldArena() then
				local info = ChatTypeInfo.SYSTEM
				DEFAULT_CHAT_FRAME:AddMessage(ARENA_SPECTATOR, info.r, info.g, info.b, info.id)
			end
			RepopMe()
			if CannotBeResurrected() then
				return 1
			end
		end,
		OnCancel = function(_, _, reason)
			if reason == "override" then
				StaticPopup_Show("RECOVER_CORPSE")
				return
			end
			if reason == "timeout" then
				return
			end
			if reason == "clicked" then
				if HasSoulstone() then
					UseSoulstone()
				else
					RepopMe()
				end
				if CannotBeResurrected() then
					return 1
				end
			end
		end,
		OnAlt = function()
			local _, recapID = HasEvents()
			OpenRecap(recapID)
		end,
		OnUpdate = function(self, elapsed)
			if self.timeleft > 0 then
				local text = _G[self:GetName().."Text"]
				local timeleft = self.timeleft
				if timeleft < 60 then
					text:SetFormattedText(DEATH_RELEASE_TIMER, timeleft, SECONDS)
				else
					text:SetFormattedText(DEATH_RELEASE_TIMER, ceil(timeleft / 60), MINUTES)
				end
			end

			if IsFalling() and not IsOutOfBounds() then
				self.button1:Disable()
				self.button2:Disable()
				return
			else
				self.button1:Enable()
			end
			if HasSoulstone() then
				self.button2:Enable()
			else
				self.button2:Disable()
			end
		end,
		DisplayButton2 = HasSoulstone,
		whileDead = 1,
		interruptCinematic = 1,
		noCancelOnReuse = 1,
		hideOnEscape = false,
		noCloseOnAlt = true
	}
end