local E, L, V, P, G = unpack(ElvUI)
local EFL = E:NewModule("EnhancedFriendsList", "AceHook-3.0")
local EP = E.Libs.EP
local LSM = E.Libs.LSM

local addonName = ...

local unpack, tonumber = unpack, tonumber
local format, sub = string.format, string.sub

local GetFriendInfo = GetFriendInfo
local GetQuestDifficultyColor = GetQuestDifficultyColor
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND

local CHAT_FLAG_AFK = CHAT_FLAG_AFK
local CHAT_FLAG_DND = CHAT_FLAG_DND
local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
local FRIENDS_BUTTON_TYPE_WOW = FRIENDS_BUTTON_TYPE_WOW
local PRIEST_COLOR = RAID_CLASS_COLORS.PRIEST

local StatusIcons = {
	Default = {
		Online = FRIENDS_TEXTURE_ONLINE,
		Offline = FRIENDS_TEXTURE_OFFLINE,
		DND = FRIENDS_TEXTURE_DND,
		AFK = FRIENDS_TEXTURE_AFK
	},
	Square = {
		Online = E.EnhancedFriendsListMedia.Textures.Square_Online,
		Offline = E.EnhancedFriendsListMedia.Textures.Square_Offline,
		DND	= E.EnhancedFriendsListMedia.Textures.Square_DND,
		AFK	= E.EnhancedFriendsListMedia.Textures.Square_AFK
	},
	D3 = {
		Online = E.EnhancedFriendsListMedia.Textures.Diablo_Online,
		Offline = E.EnhancedFriendsListMedia.Textures.Diablo_Offline,
		DND	= E.EnhancedFriendsListMedia.Textures.Diablo_DND,
		AFK	= E.EnhancedFriendsListMedia.Textures.Diablo_AFK
	}
}

local function GetLevelDiffColorHex(level, offline)
	if level ~= 0 then
		local color = GetQuestDifficultyColor(level)
		return offline and format("|cFF%02x%02x%02x", color.r * 160, color.g * 160, color.b * 160) or format("|cFF%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255)
	else
		return offline and E:RGBToHex(0.49, 0.52, 0.54) or "|cFFFFFFFF"
	end
end

local function GetClassColorHex(class, offline)
	class = E:UnlocalizedClassName(class)

	local color = E:ClassColor(class) or PRIEST_COLOR
	if color then
		return offline and format("|cff%02x%02x%02x", color.r * 160, color.g * 160, color.b * 160) or format("|cff%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255)
	else
		return offline and E:RGBToHex(0.49, 0.52, 0.54) or "|cFFFFFFFF"
	end
end

local function HexToRGB(hex)
	if not hex then return nil end

	local rhex, ghex, bhex = sub(hex, 5, 6), sub(hex, 7, 8), sub(hex, 9, 10)
	return {r = tonumber(rhex, 16) / 225, g = tonumber(ghex, 16) / 225, b = tonumber(bhex, 16) / 225}
end

function EFL:Update()
	for i = 1, #FriendsFrameFriendsScrollFrame.buttons do
		local button = FriendsFrameFriendsScrollFrame.buttons[i]

		self:Configure_Background(button)
		self:Configure_Status(button)
		self:Configure_IconFrame(button)

		button.name:SetFont(LSM:Fetch("font", self.db.nameFont), self.db.nameFontSize, self.db.nameFontOutline)
		button.info:SetFont(LSM:Fetch("font", self.db.zoneFont), self.db.zoneFontSize, self.db.zoneFontOutline)
	end
end

-- Status
function EFL:Update_Status(button)
	if not self.db.showStatusIcon then return end

	if button.TYPE == "Online" then
		button.status:SetTexture(StatusIcons[self.db.statusIcons][(button.statusType == CHAT_FLAG_DND and "DND" or button.statusType == CHAT_FLAG_AFK and "AFK" or "Online")])
	else
		button.status:SetTexture(StatusIcons[self.db.statusIcons].Offline)
	end
end

function EFL:Configure_Status(button)
	button.status:SetShown(self.db.showStatusIcon)
end

-- Name
function EFL:Update_Name(button)
	local isOffline = button.TYPE == "Offline" or false

	local enhancedName = (self.db[button.TYPE].enhancedName and GetClassColorHex(button.class, isOffline)..button.nameText.."|r" or button.nameText)
	local enhancedLevel = self.db[button.TYPE].level and button.levelText and format(self.db[button.TYPE].levelText and (self.db[button.TYPE].shortLevel and L["SHORT_LEVEL_TEMPLATE"] or L["LEVEL_TEMPLATE"]) or "%s", self.db[button.TYPE].levelColor and GetLevelDiffColorHex(button.levelText, isOffline)..button.levelText.."|r" or button.levelText).." " or ""
	local enhancedClass = self.db[button.TYPE].classText and button.class or ""
	button.name:SetText(enhancedName..((enhancedLevel ~= "" or enhancedClass ~= "") and (self.db[button.TYPE].enhancedName and " - " or ", ") or "")..enhancedLevel..enhancedClass)

	local nameColor = self.db[button.TYPE].enhancedName and (self.db[button.TYPE].colorizeNameOnly and (isOffline and FRIENDS_GRAY_COLOR or HIGHLIGHT_FONT_COLOR) or HexToRGB(GetClassColorHex(button.class, isOffline))) or (isOffline and FRIENDS_GRAY_COLOR or FRIENDS_WOW_NAME_COLOR)
	button.name:SetTextColor(nameColor.r, nameColor.g, nameColor.b)

	local infoText
	if isOffline then
		if button.lastSeen then
			infoText = (self.db[button.TYPE].zoneText and button.area and button.area..(self.db[button.TYPE].lastSeen and " - " or "") or "")..(self.db[button.TYPE].lastSeen and L["Last seen"].." "..FriendsFrame_GetLastOnline(button.lastSeen) or "")
		else
			infoText = self.db[button.TYPE].zoneText and button.area or ""
		end

		button.info:SetTextColor(0.49, 0.52, 0.54)
	else
		infoText = self.db[button.TYPE].zoneText and button.area or ""

		local playerZone = GetRealZoneText()
		if self.db[button.TYPE].enhancedZone then
			if self.db[button.TYPE].sameZone then
				if infoText == playerZone then
					button.info:SetTextColor(self.db[button.TYPE].sameZoneColor.r, self.db[button.TYPE].sameZoneColor.g, self.db[button.TYPE].sameZoneColor.b)
				else
					button.info:SetTextColor(self.db[button.TYPE].enhancedZoneColor.r, self.db[button.TYPE].enhancedZoneColor.g, self.db[button.TYPE].enhancedZoneColor.b)
				end
			else
				button.info:SetTextColor(self.db[button.TYPE].enhancedZoneColor.r, self.db[button.TYPE].enhancedZoneColor.g, self.db[button.TYPE].enhancedZoneColor.b)
			end
		else
			if self.db[button.TYPE].sameZone then
				if infoText == playerZone then
					button.info:SetTextColor(self.db[button.TYPE].sameZoneColor.r, self.db[button.TYPE].sameZoneColor.g, self.db[button.TYPE].sameZoneColor.b)
				else
					button.info:SetTextColor(0.49, 0.52, 0.54)
				end
			else
				button.info:SetTextColor(0.49, 0.52, 0.54)
			end
		end
	end
	button.info:SetText(infoText)

	button.name:ClearAllPoints()
	if button.iconFrame:IsShown() then
		button.name:Point("LEFT", button.iconFrame, "RIGHT", 3, infoText ~= "" and 7 or 0)
	else
		button.name:Point("TOPLEFT", self.db.showStatusIcon and 22 or 3, infoText ~= "" and -3 or -10)
	end
end

-- IconFrame
function EFL:Update_IconFrame(button)
	if self.db[button.TYPE].classIcon then
		local classFileName = E:UnlocalizedClassName(button.class)
		if classFileName then
			button.iconFrame:Show()

			button.iconFrame.texture:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]))
			button.iconFrame:SetAlpha(button.TYPE == "Online" and 1 or 0.6)

			if self.db.Online.classIconStatusColor then
				if button.TYPE == "Online" then
					if button.statusType == "" then
						button.iconFrame:SetBackdropBorderColor(unpack(E.media.bordercolor))
					elseif button.statusType == CHAT_FLAG_AFK then
						button.iconFrame:SetBackdropBorderColor(1, 1, 0)
					elseif button.statusType == CHAT_FLAG_DND then
						button.iconFrame:SetBackdropBorderColor(1, 0, 0)
					end
				else
					button.iconFrame:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			else
				button.iconFrame:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		else
			button.iconFrame:Hide()
		end
	elseif button.iconFrame:IsShown() then
		button.iconFrame:Hide()
	end
end

function EFL:Configure_IconFrame(button)
	button.iconFrame:ClearAllPoints()
	button.iconFrame:Point("LEFT", self.db.showStatusIcon and 22 or 3, 0)
end

function EFL:Construct_IconFrame(button)
	button.iconFrame = CreateFrame("Frame", "$parentIconFrame", button)
	button.iconFrame:Size(26)
	button.iconFrame:SetTemplate()

	button.iconFrame.texture = button.iconFrame:CreateTexture()
	button.iconFrame.texture:SetAllPoints()
	button.iconFrame.texture:SetTexture([[Interface\WorldStateFrame\Icons-Classes]])
	button.iconFrame:Hide()
end

-- Background
function EFL:Update_Background(button)
	if not self.db.showBackground then return end

	if button.TYPE == "Online" then
		button.backgroundTex:SetVertexColor(1, 0.824, 0, 0.05)
	else
		button.backgroundTex:SetVertexColor(0.588, 0.588, 0.588, 0.05)
	end
end

function EFL:Configure_Background(button)
	button.backgroundTex:SetShown(self.db.showBackground)
end

function EFL:Construct_Background(button)
	button.backgroundTex = button:CreateTexture(nil, "BACKGROUND")
	button.backgroundTex:SetInside()
	button.backgroundTex:SetTexture(E.Media.Textures.Highlight)
	button.backgroundTex:SetVertexColor(1, 0.824, 0, 0.05)
end

-- Highlight
function EFL:Update_Highlight(button)
	if button.TYPE == "Online" then
		if button.statusType == "" then
			button.highlightTex:SetVertexColor(0.243, 0.570, 1, 0.35)
		elseif button.statusType == CHAT_FLAG_AFK then
			button.highlightTex:SetVertexColor(1, 1, 0, 0.35)
		elseif button.statusType == CHAT_FLAG_DND then
			button.highlightTex:SetVertexColor(1, 0, 0, 0.35)
		end
	else
		button.highlightTex:SetVertexColor(0.486, 0.518, 0.541, 0.35)
	end
end

function EFL:Construct_Highlight(button)
	button.highlightTex = button:CreateTexture(nil, "HIGHLIGHT")
	button.highlightTex:SetInside()
	button.highlightTex:SetTexture(E.Media.Textures.Highlight)
	button.highlightTex:SetVertexColor(0.243, 0.570, 1, 0.35)
end

function EFL:GetLocalFriendInfo(name)
	local info = EnhancedFriendsListDB[E.myrealm][name]
	if info then
		return info[1], info[2], info[3], info[4]
	else
		return nil, nil, nil, nil
	end
end

function EFL:FriendsFrame_UpdateFriends()
	local offset = HybridScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame)
	local buttons = FriendsFrameFriendsScrollFrame.buttons

	for i = 1, #buttons do
		local button = buttons[i]
		local index = offset + i
		if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
			local name, level, class, area, connected, status = GetFriendInfo(button.id)
			if not name then return end

			button.nameText = name
			button.TYPE = connected and "Online" or "Offline"
			button.statusType = status

			if connected then
				if not EnhancedFriendsListDB[E.myrealm][name] then
					EnhancedFriendsListDB[E.myrealm][name] = {}
				end

				EnhancedFriendsListDB[E.myrealm][name] = {level, class, area, format("%i", time())}
			else
				local lastSeen, lastArea
				level, class, lastArea, lastSeen = self:GetLocalFriendInfo(name)
				area = lastArea or area
				button.lastSeen = lastSeen
			end

			button.levelText = level
			button.class = class
			button.area = area

			self:Update_Background(button)
			self:Update_Status(button)
			self:Update_IconFrame(button)
			self:Update_Name(button)
			self:Update_Highlight(button)
		end
	end
end

function EFL:FriendsFrameStatusDropDown_Update()
	local status = (StatusIcons[self.db.statusIcons][(UnitIsDND("Player") and "DND" or UnitIsAFK("Player") and "AFK" or "Online")])
	FriendsFrameStatusDropDownStatus:SetTexture(status)
end

function EFL:FriendListUpdate()
	if ElvCharacterDB.EnhancedFriendsList_Data then
		for i = 1, GetNumFriends() do
			local name, level, class, area = GetFriendInfo(i)
			if ElvCharacterDB.EnhancedFriendsList_Data[name] then
				local data = ElvCharacterDB.EnhancedFriendsList_Data[name]
				if not EnhancedFriendsListDB[E.myrealm][name] then
					EnhancedFriendsListDB[E.myrealm][name] = {}
				end
				EnhancedFriendsListDB[E.myrealm][name] = {data.level, data.class, data.area, data.lastSeen}
			end
		end
		ElvCharacterDB.EnhancedFriendsList_Data = nil
	end

	for i = 1, #FriendsFrameFriendsScrollFrame.buttons do
		local button = FriendsFrameFriendsScrollFrame.buttons[i]

		self:Construct_IconFrame(button)

		self:Construct_Background(button)
		button.background:Hide()

		self:Construct_Highlight(button)
		button.highlight:SetVertexColor(0, 0, 0, 0)
	end

	self:Update()

	self:SecureHook("FriendsFrameStatusDropDown_Update")
	self:SecureHook("HybridScrollFrame_Update", "FriendsFrame_UpdateFriends")
	self:SecureHook("FriendsFrame_UpdateFriends", "FriendsFrame_UpdateFriends")
end

function EFL:Initialize()
	EP:RegisterPlugin(addonName, self.InsertOptions)

	self.db = E.db.enhanceFriendsList

	if not EnhancedFriendsListDB then
		EnhancedFriendsListDB = {}
	end

	if not EnhancedFriendsListDB[E.myrealm] then
		EnhancedFriendsListDB[E.myrealm] = {}
	end

	self:FriendListUpdate()
end

local function InitializeCallback()
	EFL:Initialize()
end

E:RegisterModule(EFL:GetName(), InitializeCallback)