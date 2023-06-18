local E, L, V, P, G = unpack(ElvUI)
local ENP = E:NewModule("Enhanced_NamePlates", "AceHook-3.0", "AceEvent-3.0")
local NP = E:GetModule("NamePlates")
local M = E:GetModule("Misc")
local CH = E:GetModule("Chat")

local _G = _G
local ipairs, next, pairs = ipairs, next, pairs
local sub, gsub, floor = string.sub, string.gsub, math.floor
local match, gmatch, format, lower = string.match, string.gmatch, string.format, string.lower
local tinsert, tremove = table.insert, table.remove

local GetGuildInfo = GetGuildInfo
local IsInGuild = IsInGuild
local IsInInstance = IsInInstance
local IsResting = IsResting
local UnitClass = UnitClass
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName
local UnitPlayerControlled = UnitPlayerControlled
local UnitReaction = UnitReaction

local UNKNOWN = UNKNOWN

local classMap = {}
local guildMap = {}
local npcTitleMap = {}

local function UpdateNameplateByName(name)
	for frame in pairs(NP.VisiblePlates) do
		if frame.UnitName == name then
			NP.OnShow(frame:GetParent(), nil, true)
		end
	end
end

function ENP:UPDATE_MOUSEOVER_UNIT()
	if UnitIsPlayer("mouseover") and UnitReaction("mouseover", "player") ~= 2 then
		local name, realm = UnitName("mouseover")
		if realm or not name or name == UNKNOWN then return end

		if E.db.enhanced.nameplates.classCache then
			local _, class = UnitClass("mouseover")
			class = classMap[class]

			if EnhancedDB.UnitClass[name] ~= class then
				EnhancedDB.UnitClass[name] = class
			end
		end

		if E.db.enhanced.nameplates.titleCache then
			local guildName = GetGuildInfo("mouseover")
			if not guildName then
				if EnhancedDB.UnitTitle[name] then
					EnhancedDB.UnitTitle[name] = nil
					UpdateNameplateByName(name)
				end
				return
			end

			if not guildMap[guildName] then
				tinsert(EnhancedDB.GuildList, guildName)
				guildMap[guildName] = #EnhancedDB.GuildList
			end

			if EnhancedDB.UnitTitle[name] ~= guildMap[guildName] then
				EnhancedDB.UnitTitle[name] = guildMap[guildName]
				UpdateNameplateByName(name)
			end
		end
	else
		self.scanner:ClearLines()
		self.scanner:SetUnit("mouseover")

		local name = _G["Enhanced_ScanningTooltipTextLeft1"]:GetText()
		if not name then return end
		local description = _G["Enhanced_ScanningTooltipTextLeft2"]:GetText()
		if not description then return end

		if match(description, UNIT_LEVEL_TEMPLATE) then return end

		name = gsub(gsub((name), "|c........", "" ), "|r", "")
		if name ~= UnitName("mouseover") then return end
		if UnitPlayerControlled("mouseover") then return end

		if not npcTitleMap[description] then
			tinsert(EnhancedDB.NPCList, description)
			npcTitleMap[description] = #EnhancedDB.NPCList
		end

		if EnhancedDB.UnitTitle[name] ~= npcTitleMap[description] then
			EnhancedDB.UnitTitle[name] = npcTitleMap[description]
			UpdateNameplateByName(name)
		end
	end
end

-- Class Cache
local grenColorToClass = {}
for class, color in pairs(RAID_CLASS_COLORS) do
	local monkColorB = class == "MONK" and 0.01 or 0

	grenColorToClass[color.b + monkColorB] = class
end

local function UnitClassHook(self, frame, unitType)
	if unitType == "FRIENDLY_PLAYER" then
		local unitName = frame.UnitName
		local unit = self[unitType][unitName]
		if unit then
			local _, class = UnitClass(unit)
			if class then
				return class
			end
		elseif EnhancedDB.UnitClass[unitName] then
			return CLASS_SORT_ORDER[EnhancedDB.UnitClass[unitName]]
		else
			return NP:GetUnitClassByGUID(frame)
		end
	elseif unitType == "ENEMY_PLAYER" then
		local _, _, b = frame.oldHealthBar:GetStatusBarColor()

		return grenColorToClass[floor(b * 100 + 0.5) / 100]
	end
end

function ENP:ClassCache()
	if E.db.enhanced.nameplates.classCache then
		if not self:IsHooked(NP, "UnitClass") then
			self:RawHook(NP, "UnitClass", UnitClassHook)
		end
	else
		if self:IsHooked(NP, "UnitClass") then
			self:Unhook(NP, "UnitClass")
		end
	end
end

-- Title Cache
local separatorMap = {
	NONE = "%s",
	ARROW = ">%s<",
	ARROW1 = "> %s <",
	ARROW2 = "<%s>",
	ARROW3 = "< %s >",
	BOX = "[%s]",
	BOX1 = "[ %s ]",
	CURLY = "{%s}",
	CURLY1 = "{ %s }",
	CURVE = "(%s)",
	CURVE1 = "( %s )"
}

local function Update_NameHook(self, frame)
	if not E.db.enhanced.nameplates.titleCache then return end

	if frame.Health:IsShown() then
		if frame.Title then
			frame.Title:SetText()
			frame.Title:Hide()
		end
		return
	end

	local guildName = EnhancedDB.GuildList[EnhancedDB.UnitTitle[frame.UnitName]]
	if frame.UnitType == "FRIENDLY_PLAYER" and guildName then
		local db = E.db.enhanced.nameplates.guild

		local shown
		if IsResting() then
			shown = db.visibility.city
		else
			local _, instanceType = IsInInstance()
			if instanceType == "pvp" then
				shown = db.visibility.pvp
			elseif instanceType == "arena" then
				shown = db.visibility.arena
			elseif instanceType == "party" then
				shown = db.visibility.party
			elseif instanceType == "raid" then
				shown = db.visibility.raid
			else
				shown = true
			end
		end

		if shown then
			if not frame.Title then
				frame.Title = frame:CreateFontString(nil, "OVERLAY")
				frame.Title:SetWordWrap(false)
			end

			frame.Title:SetFont(E.LSM:Fetch("font", db.font), db.fontSize, db.fontOutline)

			local color
			if UnitInRaid(frame.UnitName) then
				color = db.colors.raid
			elseif UnitInParty(frame.UnitName) then
				color = db.colors.party
			elseif IsInGuild and GetGuildInfo("player") == guildName then
				color = db.colors.guild
			else
				color = db.colors.none
			end

			frame.Title:SetTextColor(color.r, color.g, color.b)
			frame.Title:SetPoint("TOP", frame.Name, "BOTTOM")
			frame.Title:SetFormattedText(separatorMap[db.separator], guildName)
			frame.Title:Show()
		elseif frame.Title then
			frame.Title:Hide()
		end
	elseif (frame.UnitType == "FRIENDLY_NPC" or frame.UnitType == "ENEMY_NPC") and EnhancedDB.NPCList[EnhancedDB.UnitTitle[frame.UnitName]] then
		if not frame.Title then
			frame.Title = frame:CreateFontString(nil, "OVERLAY")
			frame.Title:SetWordWrap(false)
		end

		local db = E.db.enhanced.nameplates.npc
		frame.Title:SetFont(E.LSM:Fetch("font", db.font), db.fontSize, db.fontOutline)

		if E.db.enhanced.nameplates.npc.reactionColor then
			local db = self.db.colors
			if frame.UnitReaction then
				if frame.UnitReaction == 1 then
					r, g, b = db.reactions.tapped.r, db.reactions.tapped.g, db.reactions.tapped.b
				elseif frame.UnitReaction == 4 then
					r, g, b = db.reactions.neutral.r, db.reactions.neutral.g, db.reactions.neutral.b
				elseif frame.UnitReaction > 4 then
					r, g, b = db.reactions.good.r, db.reactions.good.g, db.reactions.good.b
				else
					r, g, b = db.reactions.bad.r, db.reactions.bad.g, db.reactions.bad.b
				end
			else
				r, g, b = 1, 1, 1
			end

			frame.Title:SetTextColor(r, g, b)
		else 
			frame.Title:SetTextColor(db.color.r, db.color.g, db.color.b)
		end

		frame.Title:SetPoint("TOP", frame.Name, "BOTTOM")
		frame.Title:SetFormattedText(separatorMap[db.separator], EnhancedDB.NPCList[EnhancedDB.UnitTitle[frame.UnitName]])
		frame.Title:Show()
	elseif frame.Title then
		frame.Title:SetText("")
	end
end

function ENP:TitleCache()
	if E.db.enhanced.nameplates.titleCache then
		if not self:IsHooked(NP, "Update_Name") then
			self:Hook(NP, "Update_Name", Update_NameHook)
		end
	else
		if self:IsHooked(NP, "Update_Name") then
			self:Unhook(NP, "Update_Name")
		end
	end
end

-- Chat Bubbles
local events = {
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_BATTLEGROUND",
	"CHAT_MSG_BATTLEGROUND_LEADER",
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_SAY",
	"CHAT_MSG_YELL",
	"CHAT_MSG_MONSTER_SAY",
	"CHAT_MSG_MONSTER_YELL"
}

local bubbleList = {}
local delayFrame = CreateFrame("Frame")
delayFrame:Hide()
delayFrame:SetScript("OnUpdate", function(self, elapsed)
	local i, frame = 1

	while bubbleList[i] do
		frame = bubbleList[i]
		frame.delay = frame.delay - elapsed

		if frame.delay <= 0 then
			frame.delay = 0
			E:UIFrameFadeOut(frame, .2, frame:GetAlpha(), 0)
			tremove(bubbleList, i)
		else
			i = i + 1
		end
	end

	if #bubbleList == 0 then
		self:Hide()
	end
end)

local function SetBubbleDelay(frame, delay)
	local found

	if #bubbleList > 0 then
		for _, v in ipairs(bubbleList) do
			if v == frame then
				v.delay = delay
				found = true
				break
			end
		end
	end

	if not found then
		frame.delay = delay
		tinsert(bubbleList, frame)
		delayFrame:Show()
	end
end

local inactiveBubbles = {}

local function ReleaseBubble(frame)
	inactiveBubbles[#inactiveBubbles + 1] = frame
	frame.parent.bubbleFrame = nil
	frame:Hide()
end

local function FadeClosure(frame)
	if frame.fadeInfo.mode == "OUT" then
		ReleaseBubble(frame)
	end
end

local function CreateBubble()
	local frame = CreateFrame("Frame")
	frame:SetFrameStrata("BACKGROUND")
	frame:Hide()
	frame.text = frame:CreateFontString()
	frame.text:SetJustifyH("CENTER")
	frame.text:SetJustifyV("MIDDLE")
	frame.text:SetWordWrap(true)
	frame.text:SetNonSpaceWrap(true)
	frame:SetPoint("TOPLEFT", frame.text, -15, 15)
	frame:SetPoint("BOTTOMRIGHT", frame.text, 15, -15)
	M:SkinBubble(frame)

	frame.delay = 0
	frame.FadeObject = {
		finishedFuncKeep = true,
		finishedArg1 = frame,
		finishedFunc = FadeClosure
	}

	return frame
end

local function AcquireBubble()
	local numInactiveObjects = #inactiveBubbles
	if numInactiveObjects > 0 then
		local frame = inactiveBubbles[numInactiveObjects]
		inactiveBubbles[numInactiveObjects] = nil
		return frame
	end

	return CreateBubble()
end

function ENP:AddBubbleMessage(frame, msg, author, guid)
	if E.private.general.chatBubbleName then
		M:AddChatBubbleName(frame, guid, author)
	else
		frame.Name:SetText()
	end

	frame.text:SetText(msg)

	if frame.text:GetStringWidth() > 300 then
		frame.text:SetWidth(300)
	end

	if E.private.chat.enable and E.private.general.classColorMentionsSpeech then
		local classColorTable, lowerCaseWord, isFirstWord, rebuiltString, tempWord, wordMatch, classMatch
		if msg and match(msg, "%s-%S+%s*") then
			for word in gmatch(msg, "%s-%S+%s*") do
				tempWord = gsub(word, "^[%s%p]-([^%s%p]+)([%-]?[^%s%p]-)[%s%p]*$","%1%2")
				lowerCaseWord = lower(tempWord)

				classMatch = CH.ClassNames[lowerCaseWord]
				wordMatch = classMatch and lowerCaseWord

				if wordMatch and not E.global.chat.classColorMentionExcludedNames[wordMatch] then
					classColorTable = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classMatch] or RAID_CLASS_COLORS[classMatch]
					word = gsub(word, gsub(tempWord, "%-","%%-"), format("\124cff%.2x%.2x%.2x%s\124r", classColorTable.r*255, classColorTable.g*255, classColorTable.b*255, tempWord))
				end

				if not isFirstWord then
					rebuiltString = word
					isFirstWord = true
				else
					rebuiltString = format("%s%s", rebuiltString, word)
				end
			end

			if rebuiltString ~= nil then
				frame.text:SetText(rebuiltString)
			end
		end
	end
end

function ENP:FindNameplateByChatMsg(event, msg, author, _, _, _, _, _, channelID, _, _, _, guid)
	if author == UnitName("player") or not author then return end
	if not next(NP.VisiblePlates) then return end

	local chatType = sub(event, 10)
	if sub(chatType, 1, 7) == "CHANNEL" then
		chatType = "CHANNEL"..channelID
	end

	local info = ChatTypeInfo[chatType]
	if not info then return end

	for frame in pairs(NP.VisiblePlates) do
		if frame.UnitName == author then
			local bubbleFrame
			if not frame.bubbleFrame then
				bubbleFrame = AcquireBubble()
				frame.bubbleFrame = bubbleFrame
				bubbleFrame.text:ClearAllPoints()
				bubbleFrame.text:SetPoint("BOTTOM", frame, "TOP", 0, 20)
				bubbleFrame:Show()
				E:UIFrameFadeIn(bubbleFrame, .2, 0, 1)
			else
				bubbleFrame = frame.bubbleFrame
			end

			bubbleFrame.parent = frame

			bubbleFrame.text:SetSize(0, 0)
			bubbleFrame.text:SetTextColor(info.r, info.g, info.b)
			bubbleFrame.author = author

			if E.private.general.chatBubbles == "backdrop" then
				if E.PixelMode then
					bubbleFrame:SetBackdropBorderColor(info.r, info.g, info.b)
				else
					local r, g, b = info.r, info.g, info.b
					bubbleFrame.bordertop:SetTexture(r, g, b)
					bubbleFrame.borderbottom:SetTexture(r, g, b)
					bubbleFrame.borderleft:SetTexture(r, g, b)
					bubbleFrame.borderright:SetTexture(r, g, b)
				end
			end

			ENP:AddBubbleMessage(bubbleFrame, msg, author, guid)

			if bubbleFrame.delay == 0 then
				E:UIFrameFadeRemoveFrame(bubbleFrame)
				E:UIFrameFadeIn(bubbleFrame, .2, bubbleFrame:GetAlpha(), 1)
			end

			local _, delayMult = gsub(msg, "%s+", "")
			SetBubbleDelay(bubbleFrame, 2 + (0.5 * delayMult))
		end
	end
end

local function OnShowHook(frame, ...)
	ENP.hooks[NP].OnShow(frame, ...)

	if frame.UnitFrame.bubbleFrame then
		frame.UnitFrame.bubbleFrame = nil
	end

	if #bubbleList > 0 then
		for _, bubbleFrame in ipairs(bubbleList) do
			if frame.UnitFrame.UnitName == bubbleFrame.author then
				frame.UnitFrame.bubbleFrame = bubbleFrame
				bubbleFrame.parent = frame.UnitFrame

				bubbleFrame.text:ClearAllPoints()
				bubbleFrame.text:SetPoint("BOTTOM", frame.UnitFrame, "TOP", 0, 20)
				bubbleFrame:Show()
				break
			end
		end
	end
end

local function OnHideHook(frame)
	if frame.UnitFrame.bubbleFrame then
		frame.UnitFrame.bubbleFrame:Hide()
	end
	if frame.UnitFrame.Title then
		frame.UnitFrame.Title:SetText()
		frame.UnitFrame.Title:Hide()
	end
end

function ENP:ChatBubbles()
	if E.db.enhanced.nameplates.chatBubbles then
		for _, event in ipairs(events) do
			ENP:RegisterEvent(event, "FindNameplateByChatMsg")
		end
	else
		for _, event in ipairs(events) do
			ENP:UnregisterEvent(event)
		end
	end
end

function ENP:UpdateAllSettings()
	self:ClassCache()
	self:ChatBubbles()
	self:TitleCache()

	if E.db.enhanced.nameplates.titleCache or E.db.enhanced.nameplates.classCache then
		if not self.scanner then
			self.scanner = CreateFrame("GameTooltip", "Enhanced_ScanningTooltip", nil, "GameTooltipTemplate")
			self.scanner:SetOwner(WorldFrame, "ANCHOR_NONE")
		end

		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

	elseif not E.db.enhanced.nameplates.titleCache and not E.db.enhanced.nameplates.classCache then
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	end

	if E.db.enhanced.nameplates.chatBubbles or E.db.enhanced.nameplates.titleCache then
		if not ENP:IsHooked(NP, "OnHide") then
			ENP:Hook(NP, "OnHide", OnHideHook)
		end
	elseif not E.db.enhanced.nameplates.chatBubbles and not E.db.enhanced.nameplates.titleCache then
		if ENP:IsHooked(NP, "OnHide") then
			ENP:Unhook(NP, "OnHide")
		end
	end
	if E.db.enhanced.nameplates.chatBubbles then
		if not ENP:IsHooked(NP, "OnShow") then
			ENP:RawHook(NP, "OnShow", OnShowHook, true)
		end
	else
		if ENP:IsHooked(NP, "OnShow") then
			ENP:Unhook(NP, "OnShow")
		end
	end
end

function ENP:Initialize()
	EnhancedDB.UnitClass = EnhancedDB.UnitClass or {}
	EnhancedDB.UnitTitle = EnhancedDB.UnitTitle or {}

	if EnhancedDB.GuildList then
		for i, guildName in ipairs(EnhancedDB.GuildList) do
			guildMap[guildName] = i
		end
	else
		EnhancedDB.GuildList = {}
	end

	if EnhancedDB.NPCList then
		for i, guildName in ipairs(EnhancedDB.NPCList) do
			npcTitleMap[guildName] = i
		end
	else
		EnhancedDB.NPCList = {}
	end

	for i, class in ipairs(CLASS_SORT_ORDER) do
		classMap[class] = i
	end

	ENP:UpdateAllSettings()
end

local function InitializeCallback()
	ENP:Initialize()
end

E:RegisterModule(ENP:GetName(), InitializeCallback)