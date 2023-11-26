local AngryAssign = LibStub("AceAddon-3.0"):NewAddon("AngryAssignments", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local libS = LibStub("AceSerializer-3.0")
local libC = LibStub("LibCompress")
local lwin = LibStub("LibWindow-1.1")
local libCE = libC:GetAddonEncodeTable()
local LSM = LibStub("LibSharedMedia-3.0")

BINDING_HEADER_AngryAssign = "Angry Assignments"
BINDING_NAME_AngryAssign_WINDOW = "Toggle Window"
BINDING_NAME_AngryAssign_LOCK = "Toggle Lock"
BINDING_NAME_AngryAssign_DISPLAY = "Toggle Display"
BINDING_NAME_AngryAssign_OUTPUT = "Output Assignment to Chat"

local AngryAssign_Version = 'v1.6.1'
local AngryAssign_Timestamp = '20150717175821'

local protocolVersion = 1
local comPrefix = "AnAss"..protocolVersion
local updateFrequency = 2
local pageLastUpdate = {}
local pageTimerId = {}
local displayLastUpdate = nil
local displayTimerId = nil
local versionLastUpdate = nil
local versionTimerId = nil

local guildName = nil
local officerGuildRank = nil -- The lowest officer guild rank

-- Used for version tracking
local warnedOOD = false
local versionList = {}

local comnStarted = false

local warnedPermission = false

local currentGroup = nil

-- Pages Saved Variable Format 
-- 	AngryAssign_Pages = {
-- 		[Id] = { Id = "1231", Updated = time(), UpdateId = self:Hash(name, contents), Name = "Name", Contents = "...", Backup = "..." },
--		...
-- 	}
--
-- Format for our addon communication
--
-- { "PAGE", [Id], [Last Update Timestamp], [Name], [Contents], [Last Update Unique Id] }
-- Sent when a page is updated. Id is a random unique value. Unique Id is hash of page contents. Uses RAID.
--
-- { "REQUEST_PAGE", [Id] }
-- Asks to be sent PAGE with given Id. Response is a throttled PAGE. Uses WHISPER to raid leader.
--
-- { "DISPLAY", [Id], [Last Update Timestamp], [Last Update Unique Id] }
-- Raid leader / promoted sends out when new page is to be displayed. Uses RAID.
--
-- { "REQUEST_DISPLAY" }
-- Asks to be sent DISPLAY. Response is a throttled DISPLAY. Uses WHISPER to raid leader.
--
-- { "VER_QUERY" }
-- { "VERSION", [Version], [Project Timestamp], [Valid Raid] }

-- Constants for dealing with our addon communication
local COMMAND = 1

local PAGE_Id = 2
local PAGE_Updated = 3
local PAGE_Name = 4
local PAGE_Contents = 5
local PAGE_UpdateId = 6

local REQUEST_PAGE_Id = 2

local DISPLAY_Id = 2
local DISPLAY_Updated = 3
local DISPLAY_UpdateId = 4

local VERSION_Version = 2
local VERSION_Timestamp = 3
local VERSION_ValidRaid = 4

-----------------------
-- Utility Functions --
-----------------------

local _player_realm = nil
local function EnsureUnitFullName(unit)
--	if not _player_realm then _player_realm = select(2, UnitFullName('player')) end					--we only need the name
--	if unit and not unit:find('-') then
--		unit = unit..'-'.._player_realm
--	end
	return unit
end

local function EnsureUnitShortName(unit)
--	if not _player_realm then _player_realm = select(2, UnitFullName('player')) end					--we only need the name
--	local name, realm = strsplit("-", unit, 2)
--	if not realm or realm == _player_realm then
--		return name
--	else
		return unit
--	end
end

local function PlayerFullName()
--	if not _player_realm then _player_realm = select(2, UnitFullName('player')) end					--we only need the name
	return UnitName('player') --..'-'.._player_realm
end

local function RGBToHex(r, g, b, a)
	r = math.ceil(255 * r)
	g = math.ceil(255 * g)
	b = math.ceil(255 * b)
	if a == nil then
		return string.format("%02x%02x%02x", r, g, b)
	else
		a = math.ceil(255 * a)
		return string.format("%02x%02x%02x%02x", r, g, b, a)
	end
end

local function HexToRGB(hex)
	if string.len(hex) == 8 then
		return tonumber("0x"..hex:sub(1,2)) / 255, tonumber("0x"..hex:sub(3,4)) / 255, tonumber("0x"..hex:sub(5,6)) / 255, tonumber("0x"..hex:sub(7,8)) / 255
	else
		return tonumber("0x"..hex:sub(1,2)) / 255, tonumber("0x"..hex:sub(3,4)) / 255, tonumber("0x"..hex:sub(5,6)) / 255
	end
end

-------------------------
-- Addon Communication --
-------------------------

function AngryAssign:ReceiveMessage(prefix, data, channel, sender)
	if prefix ~= comPrefix then return end
	
	local one = libCE:Decode(data) -- Decode the compressed data
	
	local two, message = libC:Decompress(one) -- Decompress the decoded data
	
	if not two then error("Error decompressing: " .. message); return end
	
	local success, final = libS:Deserialize(two) -- Deserialize the decompressed data
	if not success then error("Error deserializing " .. final); return end

	self:ProcessMessage( sender, final )
end

function AngryAssign:SendMessage(data, channel, target)
	local one = libS:Serialize( data )
	local two = libC:CompressHuffman(one)
	local final = libCE:Encode(two)
	if not channel then
--		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then       --MoP functions/not needed
--			channel = "INSTANCE_CHAT"
		if IsInRaid() then
			channel = "RAID"
		elseif IsInGroup() then
			channel = "PARTY"
		end
	end

	if not channel then return end
	if channel == "GUILD" and not guildName then return end

	-- self:Print("Sending "..data[COMMAND].." over "..channel.." to "..tostring(target))
	self:SendCommMessage(comPrefix, final, channel, target, "NORMAL")
	return true
end

function AngryAssign:ProcessMessage(sender, data)
	local cmd = data[COMMAND]
	sender = EnsureUnitFullName(sender)
	
	-- self:Print("Received "..data[COMMAND].." from "..sender)
	if cmd == "PAGE" then
		if sender == PlayerFullName() then return end
		if not self:PermissionCheck(sender) then
			self:PermissionCheckFailError(sender)
			return
		end

		local contents_updated = true
		local id = data[PAGE_Id]
		local page = AngryAssign_Pages[id]
		if page then
			if data[PAGE_UpdateId] and page.UpdateId == data[PAGE_UpdateId] then return end -- The version received is same as the one we already have

			contents_updated = page.Contents ~= data[PAGE_Contents]
			page.Name = data[PAGE_Name]
			page.Contents = data[PAGE_Contents]
			page.Updated = data[PAGE_Updated]
			page.UpdateId = data[PAGE_UpdateId] or self:Hash(page.Name, page.Contents)

			if self:SelectedId() == id then
				self:SelectedUpdated(sender)
				self:UpdateSelected()
			end
		else
			AngryAssign_Pages[id] = { Id = id, Updated = data[PAGE_Updated], UpdateId = data[PAGE_UpdateId], Name = data[PAGE_Name], Contents = data[PAGE_Contents] }
		end
		if AngryAssign_State.displayed == id then
			self:UpdateDisplayed()
			self:ShowDisplay()
			if contents_updated then self:DisplayUpdateNotification() end
		end
		self:UpdateTree()

	elseif cmd == "DISPLAY" then
		if sender == PlayerFullName() then return end
		if not self:PermissionCheck(sender) then
			if data[DISPLAY_Id] then self:PermissionCheckFailError(sender) end
			return
		end

		local id = data[DISPLAY_Id]
		local updated = data[DISPLAY_Updated]
		local updateId = data[DISPLAY_UpdateId]
		local page = AngryAssign_Pages[id]
		local sameVersion = (updateId and page and updateId == page.UpdateId) or (not updateId and page and updated == page.Updated)
		if id and not sameVersion then
			self:SendRequestPage(id, sender)
		end
		
		if AngryAssign_State.displayed ~= id then
			AngryAssign_State.displayed = id
			self:UpdateTree()
			self:UpdateDisplayed()
			self:ShowDisplay()
			if id then self:DisplayUpdateNotification() end
		end

	elseif cmd == "REQUEST_DISPLAY" then
		if sender == PlayerFullName() then return end
		if not self:IsPlayerRaidLeader() then return end

		self:SendDisplay( AngryAssign_State.displayed )

	elseif cmd == "REQUEST_PAGE" then
		if sender == PlayerFullName() then return end
		
		self:SendPage( data[REQUEST_PAGE_Id] )


	elseif cmd == "VER_QUERY" then
		
		self:SendVersion()
		
		
	elseif cmd == "VERSION" then
		local localTimestamp, ver, timestamp
		
		if AngryAssign_Timestamp:sub(1,1) == "@" then localTimestamp = nil else localTimestamp = tonumber(AngryAssign_Timestamp) end
		ver = data[VERSION_Version]
		timestamp = data[VERSION_Timestamp]
			
		if localTimestamp ~= nil and timestamp ~= "dev" and timestamp > localTimestamp and not warnedOOD then 
			self:Print("Your version of Angry Assignments is out of date! Download the latest version from curse.com.")
			warnedOOD = true
		end
		
		versionList[ sender ] = { valid = data[VERSION_ValidRaid], version = ver }
	end
end

function AngryAssign:PermissionCheckFailError(sender)
	if not warnedPermission then
		self:Print( RED_FONT_COLOR_CODE .. "You have received a page update from "..sender.." that was rejected due to insufficient permissions. If you wish to see this page, please adjust your permission settings.|r" )   --removed "Ambiguate" method, it was causing errors and we just need to know the sender
		warnedPermission = true
	end
end

function AngryAssign:SendPage(id, force)
	local lastUpdate = pageLastUpdate[id]
	local timerId = pageTimerId[id]
	local curTime = time()

	if lastUpdate and (curTime - lastUpdate <= updateFrequency) then
		if not timerId then
			if force then
				self:SendPageMessage(id)
			else
				pageTimerId[id] = self:ScheduleTimer("SendPageMessage", updateFrequency - (curTime - lastUpdate), id)
			end
		elseif force then
			self:CancelTimer( timerId )
			self:SendPageMessage(id)
		end
	else
		self:SendPageMessage(id)
	end
end

function AngryAssign:SendPageMessage(id)
	pageLastUpdate[id] = time()
	pageTimerId[id] = nil
	
	local page = AngryAssign_Pages[ id ]
	if not page then error("Can't send page, does not exist"); return end
	if not page.UpdateId then page.UpdateId = self:Hash(page.Name, page.Contents) end
	self:SendMessage({ "PAGE", [PAGE_Id] = page.Id, [PAGE_Updated] = page.Updated, [PAGE_Name] = page.Name, [PAGE_Contents] = page.Contents, [PAGE_UpdateId] = page.UpdateId })
end

function AngryAssign:SendDisplay(id, force)
	local curTime = time()

	if displayLastUpdate and (curTime - displayLastUpdate <= updateFrequency) then
		if not displayTimerId then
			if force then
				self:SendDisplayMessage(id)
			else
				displayTimerId = self:ScheduleTimer("SendDisplayMessage", updateFrequency - (curTime - displayLastUpdate), id)
			end
		elseif force then
			self:CancelTimer( displayTimerId )
			self:SendDisplayMessage(id)
		end
	else
		self:SendDisplayMessage(id)
	end
end

function AngryAssign:SendDisplayMessage(id)
	displayLastUpdate = time()
	displayTimerId = nil
	
	local page = AngryAssign_Pages[ id ]
	if not page then
		self:SendMessage({ "DISPLAY", [DISPLAY_Id] = nil, [DISPLAY_Updated] = nil, [DISPLAY_UpdateId] = nil }) 
	else
		if not page.UpdateId then page.UpdateId = self:Hash(page.Name, page.Contents) end
		self:SendMessage({ "DISPLAY", [DISPLAY_Id] = page.Id, [DISPLAY_Updated] = page.Updated, [DISPLAY_UpdateId] = page.UpdateId }) 
	end
end

function AngryAssign:SendRequestDisplay()
	if (IsInRaid() or IsInGroup()) then
		local to = self:GetRaidLeader(true)
		if to then self:SendMessage({ "REQUEST_DISPLAY" }, "WHISPER", to) end
	end
end

function AngryAssign:SendVersion(force)
	local curTime = time()

	if versionLastUpdate and (curTime - versionLastUpdate <= updateFrequency) then
		if not versionTimerId then
			if force then
				self:SendVersionMessage(id)
			else
				versionTimerId = self:ScheduleTimer("SendVersionMessage", updateFrequency - (curTime - versionLastUpdate), id)
			end
		elseif force then
			self:CancelTimer( versionTimerId )
			self:SendVersionMessage()
		end
	else
		self:SendVersionMessage()
	end
end

function AngryAssign:SendVersionMessage()
	versionLastUpdate = time()
	versionTimerId = nil

	local revToSend
	local timestampToSend
	local verToSend
	if AngryAssign_Version:sub(1,1) == "@" then verToSend = "dev" else verToSend = AngryAssign_Version end
	if AngryAssign_Timestamp:sub(1,1) == "@" then timestampToSend = "dev" else timestampToSend = tonumber(AngryAssign_Timestamp) end
	self:SendMessage({ "VERSION", [VERSION_Version] = verToSend, [VERSION_Timestamp] = timestampToSend, [VERSION_ValidRaid] = self:IsValidRaid() })
end


function AngryAssign:SendVerQuery()
	self:SendMessage({ "VER_QUERY" })
end

function AngryAssign:SendRequestPage(id, to)
	if (IsInRaid() or IsInGroup()) or to then
		if not to then to = self:GetRaidLeader(true) end
		if to then self:SendMessage({ "REQUEST_PAGE", [REQUEST_PAGE_Id] = id }, "WHISPER", to) end
	end
end

function AngryAssign:GetRaidLeader(online_only)
	if (IsInRaid() or IsInGroup()) then
		for i = 1, GetNumGroupMembers() do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML  = GetRaidRosterInfo(i)
			if rank == 2 then
				if (not online_only) or online then
					return EnsureUnitFullName(name)
				else
					return nil
				end
			end
		end
	end
	return nil
end

function AngryAssign:GetCurrentGroup()
	local player = PlayerFullName()
	if (IsInRaid() or IsInGroup()) then
		for i = 1, GetNumGroupMembers() do
			local name, _, subgroup = GetRaidRosterInfo(i)
			if EnsureUnitFullName(name) == player then
				return subgroup
			end
		end
	end
	return nil
end

function AngryAssign:VersionCheckOutput()
	local missing_addon = {}
	local invalid_raid = {}
	local different_version = {}
	local up_to_date = {}
	
	local ver = AngryAssign_Version
	if ver:sub(1,1) == "@" then ver = "dev" end
	
	if (IsInRaid() or IsInGroup()) then
		for i = 1, GetNumGroupMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			local fullname = EnsureUnitFullName(name)
			if online then
				if not versionList[ fullname ] then
					tinsert(missing_addon, name)
				elseif versionList[ fullname ].valid == false or (versionList[ fullname ].valid == nil and self:GetGuildRank(name) == 100) then
					tinsert(invalid_raid, name)
				elseif ver ~= versionList[ fullname ].version then
					tinsert(different_version, string.format("%s - %s", name, versionList[ fullname ].version)  )
				else
					tinsert(up_to_date, name)
				end
			end
		end
	end
	
	self:Print("Version check results:")
	if #up_to_date > 0 then
		print(LIGHTYELLOW_FONT_COLOR_CODE.."Same version:|r "..table.concat(up_to_date, ", "))
	end
	
	if #different_version > 0 then
		print(LIGHTYELLOW_FONT_COLOR_CODE.."Different version:|r "..table.concat(different_version, ", "))
	end
	
	if #invalid_raid > 0 then
		print(LIGHTYELLOW_FONT_COLOR_CODE.."Not allowing changes:|r "..table.concat(invalid_raid, ", "))
	end
	
	if #missing_addon > 0 then
		print(LIGHTYELLOW_FONT_COLOR_CODE.."Missing addon:|r "..table.concat(missing_addon, ", "))
	end
end

--------------------------
-- Editing Pages Window --
--------------------------

function AngryAssign_ToggleWindow()
	if not AngryAssign.window then AngryAssign:CreateWindow() end
	if AngryAssign.window:IsShown() then 
		AngryAssign.window:Hide() 
	else
		AngryAssign.window:Show() 
	end
end

function AngryAssign_ToggleLock()
	AngryAssign:ToggleLock()
end

local function AngryAssign_AddPage(widget, event, value)
	local popup_name = "AngryAssign_AddPage"
	if StaticPopupDialogs[popup_name] == nil then
		StaticPopupDialogs[popup_name] = {
			button1 = OKAY,
			button2 = CANCEL,
			OnAccept = function(self)
				local text = self.editBox:GetText()
				if text ~= "" then AngryAssign:CreatePage(text) end
			end,
			EditBoxOnEnterPressed = function(self)
				local text = self:GetParent().editBox:GetText()
				if text ~= "" then AngryAssign:CreatePage(text) end
				self:GetParent():Hide()
			end,
			text = "New page name:",
			hasEditBox = true,
			whileDead = true,
			timeout = 0; -- was giving some errors inside StaticPopup.lua
			EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
			hideOnEscape = true,
			preferredIndex = 3
		}
	end
	StaticPopup_Show(popup_name)
end

local function AngryAssign_RenamePage(widget, event, value)
	local page = AngryAssign:Get()
	if not page then return end

	local popup_name = "AngryAssign_RenamePage_"..page.Id
	if StaticPopupDialogs[popup_name] == nil then
		StaticPopupDialogs[popup_name] = {
			button1 = OKAY,
			button2 = CANCEL,
			OnAccept = function(self)
				local text = self.editBox:GetText()
				AngryAssign:RenamePage(page.Id, text)
			end,
			EditBoxOnEnterPressed = function(self)
				local text = self:GetParent().editBox:GetText()
				AngryAssign:RenamePage(page.Id, text)
				self:GetParent():Hide()
			end,
			OnShow = function(self)
				self.editBox:SetText(page.Name)
			end,
			whileDead = true,
			timeout = 0; -- was giving some errors inside StaticPopup.lua
			hasEditBox = true,
			EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
			hideOnEscape = true,
			preferredIndex = 3
		}
	end
	StaticPopupDialogs[popup_name].text = 'Rename page "'.. page.Name ..'" to:'

	StaticPopup_Show(popup_name)
end

local function AngryAssign_DeletePage(widget, event, value)
	local page = AngryAssign:Get()
	if not page then return end

	local popup_name = "AngryAssign_DeletePage_"..page.Id
	if StaticPopupDialogs[popup_name] == nil then
		StaticPopupDialogs[popup_name] = {
			button1 = OKAY,
			button2 = CANCEL,
			OnAccept = function(self)
				AngryAssign:DeletePage(page.Id)
			end,
			whileDead = true,
			timeout = 0; -- was giving some errors inside StaticPopup.lua
			hideOnEscape = true,
			preferredIndex = 3
		}
	end
	StaticPopupDialogs[popup_name].text = 'Are you sure you want to delete page "'.. page.Name ..'"?'

	StaticPopup_Show(popup_name)
end

local function AngryAssign_RevertPage(widget, event, value)
	if not AngryAssign.window then return end
	AngryAssign:UpdateSelected(true)
end

function AngryAssign:DisplayPageByName( name )
	for id, page in pairs(AngryAssign_Pages) do
		if page.Name == name then
			return self:DisplayPage( id )
		end
	end
	return false
end

function AngryAssign:DisplayPage( id )
	if not self:PermissionCheck() then return end

	self:TouchPage( id )
	self:SendPage( id, true )
	self:SendDisplay( id, true )
	
	if AngryAssign_State.displayed ~= id then
		AngryAssign_State.displayed = id
		AngryAssign:UpdateDisplayed()
		AngryAssign:ShowDisplay()
		AngryAssign:UpdateTree()
		AngryAssign:DisplayUpdateNotification()
	end
	
	return true
end

local function AngryAssign_DisplayPage(widget, event, value)
	if not AngryAssign:PermissionCheck() then return end
	local id = AngryAssign:SelectedId()
	AngryAssign:DisplayPage( id )
end

local function AngryAssign_ClearPage(widget, event, value)
	if not AngryAssign:PermissionCheck() then return end

	AngryAssign:ClearDisplayed()
	AngryAssign:SendDisplay( nil, true )
end

local function AngryAssign_TextChanged(widget, event, value)
	AngryAssign.window.button_revert:SetDisabled(false)
	AngryAssign.window.button_restore:SetDisabled(false)
	AngryAssign.window.button_display:SetDisabled(true)
	AngryAssign.window.button_output:SetDisabled(true)
end

local function AngryAssign_TextEntered(widget, event, value)
	AngryAssign:UpdateContents(AngryAssign:SelectedId(), value)
end

local function AngryAssign_RestorePage(widget, event, value)
	if not AngryAssign.window then return end
	local page = AngryAssign_Pages[AngryAssign:SelectedId()]
	if not page or not page.Backup then return end
	
	AngryAssign.window.text:SetText( page.Backup )
	AngryAssign.window.text.button:Enable()
	AngryAssign_TextChanged(widget, event, value)
end

function AngryAssign:CreateWindow()
	local window = AceGUI:Create("Frame")
	window:SetTitle("Angry Assignments")
	window:SetStatusText("")
	window:SetLayout("Flow")
	if AngryAssign:GetConfig('scale') then window.frame:SetScale( AngryAssign:GetConfig('scale') ) end
	window:SetStatusTable(AngryAssign_State.window)
	window:Hide()
	AngryAssign.window = window

	AngryAssign_Window = window.frame
	window.frame:SetMinResize(700, 400)
	window.frame:SetFrameStrata("HIGH")
	window.frame:SetFrameLevel(1)
	tinsert(UISpecialFrames, "AngryAssign_Window")

	local tree = AceGUI:Create("TreeGroup")
	tree:SetTree( self:GetTree() )
	tree:SelectByValue(1)
	tree:SetStatusTable(AngryAssign_State.tree)
	tree:SetFullWidth(true)
	tree:SetFullHeight(true)
	tree:SetLayout("Flow")
	tree:SetCallback("OnGroupSelected", function(widget, event, value) AngryAssign:UpdateSelected(true) end)
	window:AddChild(tree)
	window.tree = tree

	local text = AceGUI:Create("MultiLineEditBox")
	text:SetLabel(nil)
	text:SetFullWidth(true)
	text:SetFullHeight(true)
	text:SetCallback("OnTextChanged", AngryAssign_TextChanged)
	text:SetCallback("OnEnterPressed", AngryAssign_TextEntered)
	tree:AddChild(text)
	window.text = text
	text.button:SetWidth(75)
	local buttontext = text.button:GetFontString()
	buttontext:ClearAllPoints()
	buttontext:SetPoint("TOPLEFT", text.button, "TOPLEFT", 15, -1)
	buttontext:SetPoint("BOTTOMRIGHT", text.button, "BOTTOMRIGHT", -15, 1)

	tree:PauseLayout()
	local button_display = AceGUI:Create("Button")
	button_display:SetText("Send and Display")
	button_display:SetWidth(140)
	button_display:SetHeight(22)
	button_display:ClearAllPoints()
	button_display:SetPoint("BOTTOMRIGHT", text.frame, "BOTTOMRIGHT", 0, 4)
	button_display:SetCallback("OnClick", AngryAssign_DisplayPage)
	tree:AddChild(button_display)
	window.button_display = button_display

	local button_revert = AceGUI:Create("Button")
	button_revert:SetText("Revert")
	button_revert:SetWidth(80)
	button_revert:SetHeight(22)
	button_revert:ClearAllPoints()
	button_revert:SetDisabled(true)
	button_revert:SetPoint("BOTTOMLEFT", text.button, "BOTTOMRIGHT", 6, 0)
	button_revert:SetCallback("OnClick", AngryAssign_RevertPage)
	tree:AddChild(button_revert)
	window.button_revert = button_revert
	
	local button_restore = AceGUI:Create("Button")
	button_restore:SetText("Restore")
	button_restore:SetWidth(80)
	button_restore:SetHeight(22)
	button_restore:ClearAllPoints()
	button_restore:SetPoint("LEFT", button_revert.frame, "RIGHT", 6, 0)
	button_restore:SetCallback("OnClick", AngryAssign_RestorePage)
	tree:AddChild(button_restore)
	window.button_restore = button_restore
	
	local button_output = AceGUI:Create("Button")
	button_output:SetText("Output")
	button_output:SetWidth(80)
	button_output:SetHeight(22)
	button_output:ClearAllPoints()
	button_output:SetPoint("BOTTOMLEFT", button_restore.frame, "BOTTOMRIGHT", 6, 0)
	button_output:SetCallback("OnClick", AngryAssign_OutputDisplayed)
	tree:AddChild(button_output)
	window.button_output = button_output

	window:PauseLayout()
	local button_add = AceGUI:Create("Button")
	button_add:SetText("Add")
	button_add:SetWidth(80)
	button_add:SetHeight(19)
	button_add:ClearAllPoints()
	button_add:SetPoint("BOTTOMLEFT", window.frame, "BOTTOMLEFT", 17, 18)
	button_add:SetCallback("OnClick", AngryAssign_AddPage)
	window:AddChild(button_add)
	window.button_add = button_add

	local button_rename = AceGUI:Create("Button")
	button_rename:SetText("Rename")
	button_rename:SetWidth(80)
	button_rename:SetHeight(19)
	button_rename:ClearAllPoints()
	button_rename:SetPoint("BOTTOMLEFT", button_add.frame, "BOTTOMRIGHT", 5, 0)
	button_rename:SetCallback("OnClick", AngryAssign_RenamePage)
	window:AddChild(button_rename)
	window.button_rename = button_rename

	local button_delete = AceGUI:Create("Button")
	button_delete:SetText("Delete")
	button_delete:SetWidth(80)
	button_delete:SetHeight(19)
	button_delete:ClearAllPoints()
	button_delete:SetPoint("BOTTOMLEFT", button_rename.frame, "BOTTOMRIGHT", 5, 0)
	button_delete:SetCallback("OnClick", AngryAssign_DeletePage)
	window:AddChild(button_delete)
	window.button_delete = button_delete

	local button_clear = AceGUI:Create("Button")
	button_clear:SetText("Clear")
	button_clear:SetWidth(80)
	button_clear:SetHeight(19)
	button_clear:ClearAllPoints()
	button_clear:SetPoint("BOTTOMRIGHT", window.frame, "BOTTOMRIGHT", -135, 18)
	button_clear:SetCallback("OnClick", AngryAssign_ClearPage)
	window:AddChild(button_clear)
	window.button_clear = button_clear

	self:UpdateSelected(true)
	
	--self:CreateIconPicker()
end

local function AngryAssign_IconPicker_Clicked(widget, event)
	local texture
	if widget:GetUserData('name') then
		icon = widget:GetUserData('name')
	else
		icon = '{icon '..strmatch(widget.image:GetTexture():lower(), "^interface\\icons\\([-_%w]+)$")..'}'
	end

	local position = AngryAssign.window.text.editBox:GetCursorPosition()
	if position > 0 then
		local text = AngryAssign.window.text:GetText()
		AngryAssign.window.text:SetText( strsub(text, 1, position)..icon..strsub(text, position+1, AngryAssign.window.text.editBox:GetNumLetters()) )
		AngryAssign.window.text.editBox:SetCursorPosition( position, string.len(text) )
	else
		AngryAssign.window.text:SetText( AngryAssign.window.text:GetText()..icon)
	end

	AngryAssign.window.text.button:Enable()
	AngryAssign_TextChanged()
end

local iconCache = nil
local function AngryAssign_IconPicker_TextChanged(widget, event, value)
	AngryAssign.iconpicker_scroll:ReleaseChildren()

	local names = {}

	local spellID = strmatch(value, '|Hspell:(%d+)|')
	local itemID = strmatch(value, '|Hitem:(%d+):')

	if spellID then
		local path = select(3, GetSpellInfo(tonumber(spellID)))
		tinsert(names, path)
	elseif itemID then
		local path = select(10, GetItemInfo(tonumber(itemID)))
		tinsert(names, path)
	elseif value ~= "" then
		if not iconCache then iconCache = GetMacroIcons() end
		local iconsFound = 0
		local subname = value:lower()
		for _, path in ipairs(iconCache) do
			if path:lower():find(subname) then
				tinsert(names, "Interface\\Icons\\"..path)
				iconsFound = iconsFound + 1
			end

			if iconsFound >= 60 then
				break
			end
		end
	end

	for _, path in ipairs(names) do
		if path then
			local icon = AceGUI:Create("Icon")
			icon:SetImage(path)
			icon:SetImageSize(32, 32)
			icon:SetWidth(36)
			icon:SetHeight(36)
			icon:SetCallback('OnClick', AngryAssign_IconPicker_Clicked)
			AngryAssign.iconpicker_scroll:AddChild(icon)
		end
	end
end

function AngryAssign:CreateIconButton(name, texture)
	local icon = AceGUI:Create("Icon")
	icon:SetImage(texture)
	icon:SetImageSize(20, 20)
	icon:SetWidth(21)
	icon:SetHeight(24)
	icon:SetUserData('name', name)
	icon:SetCallback('OnClick', AngryAssign_IconPicker_Clicked)
	return icon
end

function AngryAssign:CreateIconPicker()
	local window = AceGUI:Create("Window")
	window:SetTitle("Insert an Icon")
	window:SetLayout("List")
	window:SetWidth(240)
	window:SetHeight(320)
	window.frame:SetParent(self.window.frame)
	window.frame:ClearAllPoints()
	window.frame:SetPoint("TOPLEFT", self.window.frame, "TOPRIGHT", 4, -4)
	window.frame:SetMovable(false)
	window.title:SetScript("OnMouseDown", nil)
	window.title:SetScript("OnMouseUp", nil)
	window:EnableResize(false)
	self.iconpicker = window

	local group = AceGUI:Create("SimpleGroup")
	group:SetLayout("Flow")
	group:SetFullWidth(true)
	for i = 8, 1, -1 do 
		group:AddChild( self:CreateIconButton("{rt"..i.."}", "Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..i) )
	end
	group:AddChild( self:CreateIconButton("{bl}", "Interface\\Icons\\SPELL_Nature_Bloodlust") )
	group:AddChild( self:CreateIconButton("{hs}", "Interface\\Icons\\INV_Stone_04") )
	window:AddChild(group)

	local heading = AceGUI:Create("Heading")
	heading:SetFullWidth(true)
	window:AddChild(heading)

	local text = AceGUI:Create("EditBox")
	text:SetFullWidth(true)
	text:DisableButton(true)
	text:SetCallback("OnTextChanged", AngryAssign_IconPicker_TextChanged)
	window:AddChild(text)

	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scroll:SetFullWidth(true)
	scroll:SetFullHeight(true)
	window:AddChild(scroll)
	self.iconpicker_scroll = scroll
end

function AngryAssign:SelectedUpdated(sender)
	if self.window and self.window.text.button:IsEnabled() then
		local popup_name = "AngryAssign_PageUpdated"
		if StaticPopupDialogs[popup_name] == nil then
			StaticPopupDialogs[popup_name] = {
				button1 = OKAY,
				whileDead = true,
				text = "",
				hideOnEscape = true,
				preferredIndex = 3
			}
		end
		StaticPopupDialogs[popup_name].text = "The page you are editing has been updated by "..sender..".\n\nYou can view this update by reverting your changes."
		StaticPopup_Show(popup_name)
		return true
	else
		return false
	end
end

function AngryAssign:GetTree()

	local sortTable = {}
	for _, page in pairs(AngryAssign_Pages) do
		tinsert(sortTable, { Id = page.Id, Name = page.Name })
	end

	table.sort( sortTable, function(a,b) return a.Name < b.Name end)


	local ret = {}
	for _, page in ipairs(sortTable) do
		if page.Id == AngryAssign_State.displayed then
			tinsert(ret, { value = page.Id, text = page.Name, icon = "Interface\\BUTTONS\\UI-GuildButton-MOTD-Up" })
		else
			tinsert(ret, { value = page.Id, text = page.Name })
		end
	end

	return ret
end

function AngryAssign:UpdateTree(id)
	if not self.window then return end
	self.window.tree:SetTree( self:GetTree() )
	if id then
		self.window.tree:SelectByValue( id )
	end
end

function AngryAssign:UpdateSelected(destructive)
	if not self.window then return end
	local page = AngryAssign_Pages[ self:SelectedId() ]
	local permission = self:PermissionCheck()
	if destructive or not self.window.text.button:IsEnabled() then
		if page then
			self.window.text:SetText( page.Contents )
		else
			self.window.text:SetText("")
		end
		self.window.text.button:Disable()
	end
	if page and permission then
		self.window.button_rename:SetDisabled(false)
		self.window.button_revert:SetDisabled(not self.window.text.button:IsEnabled())
		self.window.button_display:SetDisabled(self.window.text.button:IsEnabled())
		self.window.button_output:SetDisabled(self.window.text.button:IsEnabled())
		self.window.button_restore:SetDisabled(not self.window.text.button:IsEnabled() and page.Backup == page.Contents)
		self.window.text:SetDisabled(false)
	else
		self.window.button_rename:SetDisabled(true)
		self.window.button_revert:SetDisabled(true)
		self.window.button_display:SetDisabled(true)
		self.window.button_output:SetDisabled(true)
		self.window.button_restore:SetDisabled(true)
		self.window.text:SetDisabled(true)
	end
	if page then
		self.window.button_delete:SetDisabled(false)
	else
		self.window.button_delete:SetDisabled(true)
	end
	if permission then
		self.window.button_add:SetDisabled(false)
		self.window.button_clear:SetDisabled(false)
	else
		self.window.button_add:SetDisabled(true)
		self.window.button_clear:SetDisabled(true)
	end
end

----------------------------------
-- Performing changes functions --
----------------------------------

function AngryAssign:SelectedId()
	return AngryAssign_State.tree.selected
end

function AngryAssign:Get(id)
	if id == nil then id = self:SelectedId() end
	return AngryAssign_Pages[id]
end

function AngryAssign:Hash(name, contents)
	local code = libC:fcs32init()
	code = libC:fcs32update(code, name)
	code = libC:fcs32update(code, "\n")
	code = libC:fcs32update(code, contents)
	return libC:fcs32final(code)
end

function AngryAssign:CreatePage(name)
	if not self:PermissionCheck() then return end
	local id = math.random(2000000000)

	AngryAssign_Pages[id] = { Id = id, Updated = time(), UpdateId = self:Hash(name, ""), Name = name, Contents = "" }
	self:UpdateTree(id)
	self:SendPage(id, true)
end

function AngryAssign:RenamePage(id, name)
	local page = self:Get(id)
	if not page or not self:PermissionCheck() then return end

	page.Name = name
	page.Updated = time()
	page.UpdateId = self:Hash(page.Name, page.Contents)

	self:SendPage(id, true)
	self:UpdateTree()
	if AngryAssign_State.displayed == id then
		self:UpdateDisplayed()
		self:ShowDisplay()
	end
end

function AngryAssign:DeletePage(id)
	AngryAssign_Pages[id] = nil
	if self.window and self:SelectedId() == id then
		self.window.tree:SetSelected(nil)
		self:UpdateSelected(true)
	end
	if AngryAssign_State.displayed == id then
		self:ClearDisplayed()
	end
	self:UpdateTree()
end

function AngryAssign:TouchPage(id)
	if not self:PermissionCheck() then return end
	local page = self:Get(id)
	if not page then return end

	page.Updated = time()
end

function AngryAssign:UpdateContents(id, value)
	if not self:PermissionCheck() then return end
	local page = self:Get(id)
	if not page then return end

	local new_content = value:gsub('^%s+', ''):gsub('%s+$', '')
	local contents_updated = new_content ~= page.Contents
	page.Contents = new_content
	page.Backup = new_content
	page.Updated = time()
	page.UpdateId = self:Hash(page.Name, page.Contents)

	self:SendPage(id, true)
	self:UpdateSelected(true)
	if AngryAssign_State.displayed == id then
		self:UpdateDisplayed()
		self:ShowDisplay()
		if contents_updated then self:DisplayUpdateNotification() end
	end
end

function AngryAssign:CreateBackup()
	for _, page in pairs(AngryAssign_Pages) do
		page.Backup = page.Contents
	end
	self:UpdateSelected()
end

function AngryAssign:GetGuildRank(player)
	if not guildName or not player then return 100 end
	local fullplayer = EnsureUnitFullName(player)

	for i = 1, GetNumGuildMembers() do
		local fullname, _, rankIndex = GetGuildRosterInfo(i)
		if fullname and (fullname == fullplayer) then
			return rankIndex 
		end
	end
	return 100
end

function AngryAssign:ClearDisplayed()
	AngryAssign_State.displayed = nil
	self:UpdateDisplayed()
	self:UpdateTree()
end

function AngryAssign:UpdateOfficerRank()
	local currentGuildName = GetGuildInfo('player')
	local newOfficerGuildRank = 0
	if currentGuildName then
		for i = 1, GuildControlGetNumRanks() do
			GuildControlSetRank(i)
			if select(4, GuildControlGetRankFlags()) ~= nil then
				newOfficerGuildRank = i - 1
			else
				break
			end
		end
	end
	if newOfficerGuildRank ~= officerGuildRank or currentGuildName ~= guildName then
		officerGuildRank = newOfficerGuildRank
		guildName = currentGuildName
		self:UpdateSelected()
	end
end

function AngryAssign:IsPlayerRaidLeader()
	local leader = self:GetRaidLeader()
	return leader and PlayerFullName() == EnsureUnitFullName(leader)
end

function AngryAssign:IsGuildRaid()
	local leader = self:GetRaidLeader()
	
	if self:GetGuildRank(leader) <= officerGuildRank then -- If leader is in current guild and an officer rank
		return true
	end
	
	return false
end
	
	
function AngryAssign:IsValidRaid()
	if self:GetConfig('allowall') then
		return true
	end
	
	local leader = self:GetRaidLeader()
	
	if self:GetGuildRank(leader) <= officerGuildRank then -- If leader is in current guild and an officer rank
		return true
	end
	
	for token in string.gmatch( AngryAssign:GetConfig('allowplayers') , "[^%s!#$%%&()*+,./:;<=>?@\\^_{|}~%[%]]+") do
		if leader and EnsureUnitFullName(token):lower() == EnsureUnitFullName(leader):lower() then
			return true
		end
	end

	if self:IsPlayerRaidLeader() then
		return true
	end
	
	return false
end

function AngryAssign:PermissionCheck(sender)
	if not sender then sender = PlayerFullName() end

	if (IsInRaid() or IsInGroup()) then
		return (UnitIsGroupLeader(EnsureUnitShortName(sender)) == true or UnitIsGroupAssistant(EnsureUnitShortName(sender)) == true) and self:IsValidRaid()
	else
		return sender == PlayerFullName()
	end
end


function AngryAssign:PermissionsUpdated()
	self:UpdateSelected()
	if comnStarted then
		self:SendRequestDisplay()
	end
	if (IsInRaid() or IsInGroup()) and not self:IsValidRaid() then
		self:ClearDisplayed()
	end
end

---------------------
-- Displaying Page --
---------------------

local function DragHandle_MouseDown(frame) frame:GetParent():GetParent():StartSizing("RIGHT") end
local function DragHandle_MouseUp(frame)
	local display = frame:GetParent():GetParent()
	display:StopMovingOrSizing()
	AngryAssign_State.display.width = display:GetWidth()
	lwin.SavePosition(display)
	AngryAssign:UpdateBackdrop()
end
local function Mover_MouseDown(frame) frame:GetParent():StartMoving() end
local function Mover_MouseUp(frame)
	local display = frame:GetParent()
	display:StopMovingOrSizing()
	lwin.SavePosition(display)
end

function AngryAssign:ResetPosition()
	AngryAssign_State.display = {}
	AngryAssign_State.directionUp = false
	AngryAssign_State.locked = false
	
	self.display_text:Show()
	self.mover:Show()
	self.frame:SetWidth(300)
	
	lwin.RegisterConfig(self.frame, AngryAssign_State.display)
	lwin.RestorePosition(self.frame)
	
	self:UpdateDirection()
end

function AngryAssign_ToggleDisplay()
	AngryAssign:ToggleDisplay()
end

function AngryAssign:ShowDisplay()
	self.display_text:Show()
	self:UpdateBackdrop()
	AngryAssign_State.display.hidden = false
end

function AngryAssign:HideDisplay()
	self.display_text:Hide()
	AngryAssign_State.display.hidden = true
end

function AngryAssign:ToggleDisplay()
	if self.display_text:IsShown() then
		self:HideDisplay()
	else
		self:ShowDisplay()
	end
end


function AngryAssign:CreateDisplay()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetPoint("CENTER",0,0)
	frame:SetWidth(AngryAssign_State.display.width or 300)
	frame:SetHeight(1)
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:SetClampedToScreen(true)
	frame:SetMinResize(180,1)
	frame:SetMaxResize(830,1)
	frame:SetFrameStrata("MEDIUM")	
	self.frame = frame

	lwin.RegisterConfig(frame, AngryAssign_State.display)
	lwin.RestorePosition(frame)

	local text = CreateFrame("ScrollingMessageFrame", nil, frame)
	text:SetIndentedWordWrap(true)
	text:SetJustifyH("LEFT")
	text:SetFading(false)
	text:SetMaxLines(70)
	text:SetHeight(700)
	text:SetHyperlinksEnabled(false)
	self.display_text = text

	local backdrop = text:CreateTexture()
	backdrop:SetDrawLayer("BACKGROUND")
	self.backdrop = backdrop

	local mover = CreateFrame("Frame", nil, frame)
	mover:SetPoint("LEFT",0,0)
	mover:SetPoint("RIGHT",0,0)
	mover:SetHeight(16)
	mover:EnableMouse(true)
	mover:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background" })
	mover:SetBackdropColor( 0.616, 0.149, 0.114, 0.9)
	mover:SetScript("OnMouseDown", Mover_MouseDown)
	mover:SetScript("OnMouseUp", Mover_MouseUp)
	self.mover = mover
	if AngryAssign_State.locked then mover:Hide() end

	local label = mover:CreateFontString()
	label:SetFontObject("GameFontNormal")
	label:SetJustifyH("CENTER")
	label:SetPoint("LEFT", 38, 0)
	label:SetPoint("RIGHT", -38, 0)
	label:SetText("Angry Assignments")

	local direction = CreateFrame("Button", nil, mover)
	direction:SetPoint("LEFT", 2, 0)
	direction:SetWidth(16)
	direction:SetHeight(16)
	direction:SetNormalTexture("Interface\\Buttons\\UI-Panel-QuestHideButton")
	direction:SetPushedTexture("Interface\\Buttons\\UI-Panel-QuestHideButton")
	direction:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight", "ADD")
	direction:SetScript("OnClick", function() AngryAssign:ToggleDirection() end)
	self.direction_button = direction

	local lock = CreateFrame("Button", nil, mover)
	lock:SetNormalTexture("Interface\\LFGFRAME\\UI-LFG-ICON-LOCK")
	lock:GetNormalTexture():SetTexCoord(0, 0.71875, 0, 0.875)
	lock:SetPoint("LEFT", direction, "RIGHT", 4, 0)
	lock:SetWidth(12)
	lock:SetHeight(14)
	lock:SetScript("OnClick", function() AngryAssign:ToggleLock() end)

	local drag = CreateFrame("Frame", nil, mover)
	drag:SetFrameLevel(mover:GetFrameLevel() + 10)
	drag:SetWidth(16)
	drag:SetHeight(16)
	drag:SetPoint("BOTTOMRIGHT", 0, 0)
	drag:EnableMouse(true)
	drag:SetScript("OnMouseDown", DragHandle_MouseDown)
	drag:SetScript("OnMouseUp", DragHandle_MouseUp)
	drag:SetAlpha(0.5)
	local dragtex = drag:CreateTexture(nil, "OVERLAY")
	dragtex:SetTexture("Interface\\AddOns\\AngryAssignments\\Textures\\draghandle")
	dragtex:SetWidth(16)
	dragtex:SetHeight(16)
	dragtex:SetBlendMode("ADD")
	dragtex:SetPoint("CENTER", drag)

	local glow = text:CreateTexture()
	glow:SetDrawLayer("BORDER")
	glow:SetTexture("Interface\\AddOns\\AngryAssignments\\Textures\\LevelUpTex")
	glow:SetSize(223, 115)
	glow:SetTexCoord(0.56054688, 0.99609375, 0.24218750, 0.46679688)
	glow:SetVertexColor( HexToRGB(self:GetConfig('glowColor')) )
	glow:SetAlpha(0)
	self.display_glow = glow

	local glow2 = text:CreateTexture()
	glow2:SetDrawLayer("BORDER")
	glow2:SetTexture("Interface\\AddOns\\AngryAssignments\\Textures\\LevelUpTex")
	glow2:SetSize(418, 7)
	glow2:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
	glow2:SetVertexColor( HexToRGB(self:GetConfig('glowColor')) )
	glow2:SetAlpha(0)
	self.display_glow2 = glow2

	if AngryAssign_State.display.hidden then text:Hide() end
	self:UpdateMedia()
	self:UpdateDirection()
end

function AngryAssign:ToggleLock()
	AngryAssign_State.locked = not AngryAssign_State.locked
	if AngryAssign_State.locked then
		self.mover:Hide()
	else
		self.mover:Show()
	end
end

function AngryAssign:ToggleDirection()
	AngryAssign_State.directionUp = not AngryAssign_State.directionUp
	self:UpdateDirection()
end

function AngryAssign:UpdateDirection()
	if AngryAssign_State.directionUp then
		self.display_text:ClearAllPoints()
		self.display_text:SetPoint("BOTTOMLEFT", 0, 8)
		self.display_text:SetPoint("RIGHT", 0, 0)
		self.display_text:SetInsertMode("bottom")
		self.direction_button:GetNormalTexture():SetTexCoord(0, 0.5, 0.5, 1)
		self.direction_button:GetPushedTexture():SetTexCoord(0.5, 1, 0.5, 1)

		self.backdrop:ClearAllPoints()
		self.backdrop:SetPoint("BOTTOMLEFT", -4, -4)
		self.backdrop:SetPoint("BOTTOMRIGHT", 4, -4)

		self.display_glow:ClearAllPoints()
		self.display_glow:SetPoint("BOTTOM", 0, -4)
		self.display_glow:SetTexCoord(0.56054688, 0.99609375, 0.24218750, 0.46679688)
		self.display_glow2:ClearAllPoints()
		self.display_glow2:SetPoint("TOP", self.display_glow, "BOTTOM", 0, 6)
	else
		self.display_text:ClearAllPoints()
		self.display_text:SetPoint("TOPLEFT", 0, -8)
		self.display_text:SetPoint("RIGHT", 0, 0)
		self.display_text:SetInsertMode("top")						--top, not TOP, plus only works with one way, no switch in-game
		self.direction_button:GetNormalTexture():SetTexCoord(0, 0.5, 0, 0.5)
		self.direction_button:GetPushedTexture():SetTexCoord(0.5, 1, 0, 0.5)

		self.backdrop:ClearAllPoints()
		self.backdrop:SetPoint("TOPLEFT", -4, 4)
		self.backdrop:SetPoint("TOPRIGHT", 4, 4)

		self.display_glow:ClearAllPoints()
		self.display_glow:SetPoint("TOP", 0, 4)
		self.display_glow:SetTexCoord(0.56054688, 0.99609375, 0.46679688, 0.24218750)
		self.display_glow2:ClearAllPoints()
		self.display_glow2:SetPoint("BOTTOM", self.display_glow, "TOP", 0, 0)
	end
	if self.display_text:IsShown() then
		self.display_text:Hide()
		self.display_text:Show()
	end
	self:UpdateDisplayed()
end

function AngryAssign:UpdateBackdrop()
	local regions = { self.display_text:GetRegions() }

	local min, max, last_height
	for i, region in ipairs(regions) do
		if region:GetObjectType() == "FontString" then
			local position = region:GetBottom()
			if min == nil or position < min then min = position end
			if max == nil or position > max then
				max = position
				last_height = region:GetHeight()
			end
		end
	end
	if min ~= nil and max ~= nil and self:GetConfig('backdropShow') then
		self.backdrop:SetHeight( max - min + last_height + 8 )
		self.backdrop:SetTexture( HexToRGB(self:GetConfig('backdropColor')) )
		self.backdrop:Show()
	else
		self.backdrop:Hide()
	end
end

function AngryAssign:UpdateMedia()
	local fontName = LSM:Fetch("font", AngryAssign:GetConfig('fontName'))
	local fontHeight = AngryAssign:GetConfig('fontHeight')
	local fontFlags = AngryAssign:GetConfig('fontFlags')
	
	self.display_text:SetTextColor( HexToRGB(self:GetConfig('color')) )
	self.display_text:SetFont(fontName, fontHeight, fontFlags)
	self:UpdateBackdrop()
end

local updateFlasher, updateFlasher2 = nil, nil
function AngryAssign:DisplayUpdateNotification()
	if updateFlasher == nil then
		updateFlasher = self.display_glow:CreateAnimationGroup() 

		-- Flashing in
		local fade1 = updateFlasher:CreateAnimation("Alpha")
		fade1:SetDuration(0.5)
		fade1:SetChange(1)
		fade1:SetOrder(1)

		-- Holding it visible for 1 second
		fade1:SetEndDelay(5)

		-- Flashing out
		local fade2 = updateFlasher:CreateAnimation("Alpha")
		fade2:SetDuration(0.5)
		fade2:SetChange(-1)
		fade2:SetOrder(3)
	end
	if updateFlasher2 == nil then
		updateFlasher2 = self.display_glow2:CreateAnimationGroup() 

		-- Flashing in
		local fade1 = updateFlasher2:CreateAnimation("Alpha")
		fade1:SetDuration(0.5)
		fade1:SetChange(1)
		fade1:SetOrder(1)

		-- Holding it visible for 1 second
		fade1:SetEndDelay(5)

		-- Flashing out
		local fade2 = updateFlasher2:CreateAnimation("Alpha")
		fade2:SetDuration(0.5)
		fade2:SetChange(-1)
		fade2:SetOrder(3)
	end

	updateFlasher:Play()
	updateFlasher2:Play()
end

local function ci_pattern(pattern)
	local p = pattern:gsub("(%%?)(.)", function(percent, letter)
		if percent ~= "" or not letter:match("%a") then
			return percent .. letter
		else
			return string.format("[%s%s]", letter:lower(), letter:upper())
		end
	end)
	return p
end

function AngryAssign:UpdateDisplayedIfNewGroup()
	local newGroup = self:GetCurrentGroup()
	if newGroup ~= currentGroup then
		currentGroup = newGroup
		self:UpdateDisplayed()
	end
end

function AngryAssign:UpdateDisplayed()
	local page = AngryAssign_Pages[ AngryAssign_State.displayed ]
	if page then
		local text = page.Contents

		local highlights = { }
		for token in string.gmatch( AngryAssign:GetConfig('highlight') , "[^%s%p]+") do
			token = token:lower()
			if token == 'group'then
				tinsert(highlights, 'g'..(currentGroup or 0))
			else
				tinsert(highlights, token)
			end
		end
		local highlightHex = self:GetConfig('highlightColor')
		
		text = text:gsub("||", "|")
			:gsub(ci_pattern('|cblue'), "|cff00cbf4")
			:gsub(ci_pattern('|cgreen'), "|cff0adc00")
			:gsub(ci_pattern('|cred'), "|cffeb310c")
			:gsub(ci_pattern('|cyellow'), "|cfffaf318")
			:gsub(ci_pattern('|corange'), "|cffff9d00")
			:gsub(ci_pattern('|cpink'), "|cfff64c97")
			:gsub(ci_pattern('|cpurple'), "|cffdc44eb")
			:gsub("([^%s%p]+)", function(word)
				local word_lower = word:lower()
				for _, token in ipairs(highlights) do
					if token == word_lower then
						return string.format("|cff%s%s|r", highlightHex, word)
					end
				end
				return word
			end)
			:gsub(ci_pattern('{spell%s+(%d+)}'), function(id)
				return GetSpellLink(id)
			end)
			:gsub(ci_pattern('{boss%s+(%d+)}'), function(id)
				return select(5, EJ_GetEncounterInfo(id))
			end)
			:gsub(ci_pattern('{journal%s+(%d+)}'), function(id)
				return select(9, EJ_GetSectionInfo(id))
			end)
			:gsub(ci_pattern('{star}'), "{rt1}")
			:gsub(ci_pattern('{circle}'), "{rt2}")
			:gsub(ci_pattern('{diamond}'), "{rt3}")
			:gsub(ci_pattern('{triangle}'), "{rt4}")
			:gsub(ci_pattern('{moon}'), "{rt5}")
			:gsub(ci_pattern('{square}'), "{rt6}")
			:gsub(ci_pattern('{cross}'), "{rt7}")
			:gsub(ci_pattern('{x}'), "{rt7}")
			:gsub(ci_pattern('{skull}'), "{rt8}")
			:gsub(ci_pattern('{rt([1-8])}'), "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%1:0|t" )
			:gsub(ci_pattern('{healthstone}'), "{hs}")
			:gsub(ci_pattern('{hs}'), "|TInterface\\Icons\\INV_Stone_04:0|t")
			:gsub(ci_pattern('{bloodlust}'), "{bl}")
			:gsub(ci_pattern('{bl}'), "|TInterface\\Icons\\SPELL_Nature_Bloodlust:0|t")
			:gsub(ci_pattern('{icon%s+([%w_]+)}'), "|TInterface\\Icons\\%1:0|t")
			:gsub(ci_pattern('{damage}'), "{dps}")
			:gsub(ci_pattern('{tank}'), "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:0:0:0:0:64:64:0:19:22:41|t")
			:gsub(ci_pattern('{healer}'), "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:0:0:0:0:64:64:20:39:1:20|t")
			:gsub(ci_pattern('{dps}'), "|TInterface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES:0:0:0:0:64:64:20:39:22:41|t")
			:gsub(ci_pattern('{hero}'), "{heroism}")
			:gsub(ci_pattern('{heroism}'), "|TInterface\\Icons\\ABILITY_Shaman_Heroism:0|t")
			:gsub(ci_pattern('{hunter}'), "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:0:16:16:32|t")
			:gsub(ci_pattern('{warrior}'), "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:0:16:0:16|t")
			:gsub(ci_pattern('{rogue}'), "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:32:48:0:16|t")
			:gsub(ci_pattern('{mage}'), "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:16:32:0:16|t")
			:gsub(ci_pattern('{priest}'), "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:32:48:16:32|t")
			:gsub(ci_pattern('{warlock}'), "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:48:64:16:32|t")
			:gsub(ci_pattern('{paladin}'), "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:0:16:32:48|t")
			:gsub(ci_pattern('{deathknight}'), "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:16:32:32:48|t")
			:gsub(ci_pattern('{druid}'), "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:48:64:0:16|t")
		--	:gsub(ci_pattern('{monk}'), "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:32:48:32:48|t")					--no monks in cataclysm exp
			:gsub(ci_pattern('{shaman}'), "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:0:0:0:0:64:64:16:32:16:32|t")

		self.display_text:Clear()
		local lines = { strsplit("\n", text) }
		local lines_count = #lines
		for i = 1, lines_count do
			local line
			if AngryAssign_State.directionUp then
				line = lines[i]
			else 
				line = lines[lines_count - i + 1]
			end
			if line == "" then line = " " end
			self.display_text:AddMessage(line)
		end
	else
		self.display_text:Clear()
	end
	self:UpdateBackdrop()
end

function AngryAssign_OutputDisplayed()
	return AngryAssign:OutputDisplayed( AngryAssign:SelectedId() )
end
function AngryAssign:OutputDisplayed(id)
	if not self:PermissionCheck() then
		self:Print( RED_FONT_COLOR_CODE .. "You don't have permission to output a page.|r" )
	end
	if not id then id = AngryAssign_State.displayed end
	local page = AngryAssign_Pages[ id ]
	local channel
--	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then			--MoP functions/not needed
--		channel = "INSTANCE_CHAT"
	if IsInRaid() then
		channel = "RAID"
	elseif IsInGroup() then
		channel = "PARTY"
	end
	if channel and page then
		local output = page.Contents

		output = output:gsub("||", "|")
			:gsub(ci_pattern('|r'), "")
			:gsub(ci_pattern('|cblue'), "")
			:gsub(ci_pattern('|cgreen'), "")
			:gsub(ci_pattern('|cred'), "")
			:gsub(ci_pattern('|cyellow'), "")
			:gsub(ci_pattern('|corange'), "")
			:gsub(ci_pattern('|cpink'), "")
			:gsub(ci_pattern('|cpurple'), "")
			:gsub(ci_pattern('|cpurple'), "")
			:gsub(ci_pattern('|c%w?%w?%w?%w?%w?%w?%w?%w?'), "")
			:gsub(ci_pattern('{spell%s+(%d+)}'), function(id)
				return GetSpellLink(id)
			end)
			:gsub(ci_pattern('{boss%s+(%d+)}'), function(id)
				return select(5, EJ_GetEncounterInfo(id))
			end)
			:gsub(ci_pattern('{journal%s+(%d+)}'), function(id)
				return select(9, EJ_GetSectionInfo(id))
			end)
			:gsub(ci_pattern('{star}'), "{rt1}")
			:gsub(ci_pattern('{circle}'), "{rt2}")
			:gsub(ci_pattern('{diamond}'), "{rt3}")
			:gsub(ci_pattern('{triangle}'), "{rt4}")
			:gsub(ci_pattern('{moon}'), "{rt5}")
			:gsub(ci_pattern('{square}'), "{rt6}")
			:gsub(ci_pattern('{cross}'), "{rt7}")
			:gsub(ci_pattern('{x}'), "{rt7}")
			:gsub(ci_pattern('{skull}'), "{rt8}")
			:gsub(ci_pattern('{healthstone}'), "{hs}")
			:gsub(ci_pattern('{hs}'), 'Healthstone')
			:gsub(ci_pattern('{bl}'), 'Bloodlust')
			:gsub(ci_pattern('{icon%s+([%w_]+)}'), '')
			:gsub(ci_pattern('{damage}'), 'Damage')
			:gsub(ci_pattern('{tank}'), 'Tanks')
			:gsub(ci_pattern('{healer}'), 'Healers')
			:gsub(ci_pattern('{dps}'), 'Damage')
			:gsub(ci_pattern('{hero}'), "{heroism}")
			:gsub(ci_pattern('{heroism}'), 'Heroism')
			:gsub(ci_pattern('{hunter}'), LOCALIZED_CLASS_NAMES_MALE["HUNTER"])
			:gsub(ci_pattern('{warrior}'), LOCALIZED_CLASS_NAMES_MALE["WARRIOR"])
			:gsub(ci_pattern('{rogue}'), LOCALIZED_CLASS_NAMES_MALE["ROGUE"])
			:gsub(ci_pattern('{mage}'), LOCALIZED_CLASS_NAMES_MALE["MAGE"])
			:gsub(ci_pattern('{priest}'), LOCALIZED_CLASS_NAMES_MALE["PRIEST"])
			:gsub(ci_pattern('{warlock}'), LOCALIZED_CLASS_NAMES_MALE["WARLOCK"])
			:gsub(ci_pattern('{paladin}'), LOCALIZED_CLASS_NAMES_MALE["PALADIN"])
			:gsub(ci_pattern('{deathknight}'), LOCALIZED_CLASS_NAMES_MALE["DEATHKNIGHT"])
			:gsub(ci_pattern('{druid}'), LOCALIZED_CLASS_NAMES_MALE["DRUID"])
		--	:gsub(ci_pattern('{monk}'), LOCALIZED_CLASS_NAMES_MALE["MONK"])								--no monks on cataclysm exp
			:gsub(ci_pattern('{shaman}'), LOCALIZED_CLASS_NAMES_MALE["SHAMAN"])
		
		local lines = { strsplit("\n", output) }
		for _, line in ipairs(lines) do
			if line ~= "" then
				SendChatMessage(line, channel)
			end
		end
	end
end

-----------------
-- Addon Setup --
-----------------

local configDefaults = {
	scale = 1,
	hideoncombat = false,
	fontName = "Friz Quadrata TT",
	fontHeight = 12,
	fontFlags = "NONE",
	highlight = "",
	highlightColor = "ffd200",
	color = "ffffff",
	allowall = false,
	allowplayers = "",
	backdropShow = false,
	backdropColor = "00000080",
	glowColor = "FF0000"
}

function AngryAssign:GetConfig(key)
	if AngryAssign_Config[key] == nil then
		return configDefaults[key]
	else
		return AngryAssign_Config[key]
	end
end

function AngryAssign:SetConfig(key, value)
	if configDefaults[key] == value then
		AngryAssign_Config[key] = nil
	else
		AngryAssign_Config[key] = value
	end
end

function AngryAssign:RestoreDefaults()
	AngryAssign_Config = {}
	self:UpdateMedia()
	self:UpdateDisplayed()
	LibStub("AceConfigRegistry-3.0"):NotifyChange("AngryAssign")
end

local blizOptionsPanel
function AngryAssign:OnInitialize()
	if AngryAssign_State == nil then
		AngryAssign_State = { tree = {}, window = {}, display = {}, displayed = nil, locked = false, directionUp = false }
	end
	if AngryAssign_Pages == nil then AngryAssign_Pages = { } end
	if AngryAssign_Config == nil then AngryAssign_Config = { } end
	if not AngryAssign_Config.highlightColor and AngryAssign_Config.highlightColorR and AngryAssign_Config.highlightColorG and AngryAssign_Config.highlightColorB then
		AngryAssign_Config.highlightColor = RGBToHex( AngryAssign_Config.highlightColorR, AngryAssign_Config.highlightColorG, AngryAssign_Config.highlightColorB )
		AngryAssign_Config.highlightColorR = nil
		AngryAssign_Config.highlightColorG = nil
		AngryAssign_Config.highlightColorB = nil
	end

	local ver = AngryAssign_Version
	if ver:sub(1,1) == "@" then ver = "dev" end
	
	local options = {
		name = "Angry Assignments "..ver,
		handler = AngryAssign,
		type = "group",
		args = {
			window = {
				type = "execute",
				order = 3,
				name = "Toggle Window",
				desc = "Shows/hides the edit window (also available in game keybindings)",
				func = function() AngryAssign_ToggleWindow() end
			},
			help = {
				type = "execute",
				order = 99,
				name = "Help",
				hidden = true,
				func = function()
					LibStub("AceConfigCmd-3.0").HandleCommand(self, "aa", "AngryAssign", "")
				end
			},
			toggle = {
				type = "execute",
				order = 1,
				name = "Toggle Display",
				desc = "Shows/hides the display frame (also available in game keybindings)",
				func = function() AngryAssign_ToggleDisplay() end
			},
			deleteall = {
				type = "execute",
				name = "Delete All Pages",
				desc = "Deletes all pages",
				order = 4,
				hidden = true,
				cmdHidden = false,
				confirm = true,
				func = function()
					AngryAssign_State.displayed = nil
					AngryAssign_Pages = {}
					self:UpdateTree()
					self:UpdateSelected()
					self:UpdateDisplayed()
					if self.window then self.window.tree:SetSelected(nil) end
					self:Print("All pages have been deleted.")
				end
			},
			defaults = {
				type = "execute",
				name = "Restore Defaults",
				desc = "Restore configuration values to their default settings",
				order = 10,
				hidden = true,
				cmdHidden = false,
				confirm = true,
				func = function()
					self:RestoreDefaults()
				end
			},
			output = {
				type = "execute",
				name = "Output",
				desc = "Outputs currently displayed assignents to chat",
				order = 11,
				hidden = true,
				cmdHidden = false,
				confirm = true,
				func = function()
					self:OutputDisplayed()
				end
			},
			send = {
				type = "input",
				name = "Send and Display",
				desc = "Sends page with specified name",
				order = 12,
				hidden = true,
				cmdHidden = false,
				confirm = true,
				get = function(info) return "" end,
				set = function(info, val)
					local result = self:DisplayPageByName( val:trim() )
					if result == false then
						self:Print( RED_FONT_COLOR_CODE .. "A page with the name \""..val:trim().."\" could not be found.|r" )
					elseif not result then 
						self:Print( RED_FONT_COLOR_CODE .. "You don't have permission to send a page.|r" )
					end
				end
			},
			backup = {
				type = "execute",
				order = 20,
				name = "Backup Pages",
				desc = "Creates a backup of all pages with their current contents",
				func = function() 
					self:CreateBackup()
					self:Print("Created a backup of all pages.")
				end
			},
			resetposition = {
				type = "execute",
				order = 22,
				name = "Reset Position",
				desc = "Resets position for the assignment display",
				func = function()
					self:ResetPosition()
				end
			},
			version = {
				type = "execute",
				order = 21,
				name = "Version Check",
				desc = "Displays a list of all users (in the raid) running the addon and the version they're running",
				func = function()
					if (IsInRaid() or IsInGroup()) then
						versionList = {} -- start with a fresh version list, when displaying it
						self:SendMessage({ "VER_QUERY" }) 
						self:ScheduleTimer("VersionCheckOutput", 3)
						self:Print("Version check running...")
					else
						self:Print("You must be in a raid group to run the version check.")
					end
				end
			},
			lock = {
				type = "execute",
				order = 2,
				name = "Toggle Lock",
				desc = "Shows/hides the display mover (also available in game keybindings)",
				func = function() self:ToggleLock() end
			},
			config = { 
				type = "group",
				order = 5,
				name = "General",
				inline = true,
				args = {
					highlight = {
						type = "input",
						order = 1,
						name = "Highlight",
						desc = "A list of words to highlight on displayed pages (separated by spaces or punctuation)\n\nUse 'Group' to highlight the current group you are in, ex. G2",
						get = function(info) return self:GetConfig('highlight') end,
						set = function(info, val)
							self:SetConfig('highlight', val)
							self:UpdateDisplayed()
						end
					},
					hideoncombat = {
						type = "toggle",
						order = 3,
						name = "Hide on Combat",
						desc = "Enable to hide display frame upon entering combat",
						get = function(info) return self:GetConfig('hideoncombat') end,
						set = function(info, val)
							self:SetConfig('hideoncombat', val)

						end
					},
					scale = {
						type = "range",
						order = 4,
						name = "Scale",
						desc = "Sets the scale of the edit window",
						min = 0.3,
						max = 3,
						get = function(info) return self:GetConfig('scale') end,
						set = function(info, val)
							self:SetConfig('scale', val)
							if AngryAssign.window then AngryAssign.window.frame:SetScale(val) end
						end
					},
					backdrop = {
						type = "toggle",
						order = 5,
						name = "Display Backdrop",
						desc = "Enable to display a backdrop behind the assignment display",
						get = function(info) return self:GetConfig('backdropShow') end,
						set = function(info, val)
							self:SetConfig('backdropShow', val)
							self:UpdateBackdrop()
						end
					},
					backdropcolor = {
						type = "color",
						order = 6,
						name = "Backdrop Color",
						desc = "The color used by the backdrop",
						hasAlpha = true,
						get = function(info)
							local hex = self:GetConfig('backdropColor')
							return HexToRGB(hex)
						end,
						set = function(info, r, g, b, a)
							self:SetConfig('backdropColor', RGBToHex(r, g, b, a))
							self:UpdateMedia()
							self:UpdateDisplayed()
						end
					},
					updatecolor = {
						type = "color",
						order = 7,
						name = "Update Notification Color",
						desc = "The color used by the update notification glow",
						get = function(info)
							local hex = self:GetConfig('glowColor')
							return HexToRGB(hex)
						end,
						set = function(info, r, g, b)
							self:SetConfig('glowColor', RGBToHex(r, g, b))
							self.display_glow:SetVertexColor(r, g, b)
							self.display_glow2:SetVertexColor(r, g, b)
						end
					}
				}
			},
			font = { 
				type = "group",
				order = 6,
				name = "Font",
				inline = true,
				args = {
					fontname = {
						type = 'select',
						order = 1,
						dialogControl = 'LSM30_Font',
						name = 'Face',
						desc = 'Sets the font face used to display a page',
						values = LSM:HashTable("font"),
						get = function(info) return self:GetConfig('fontName') end,
						set = function(info, val)
							self:SetConfig('fontName', val)
							self:UpdateMedia()
						end
					},
					fontheight = {
						type = "range",
						order = 2,
						name = "Size",
						desc = function() 
							return "Sets the font height used to display a page"
						end,
						min = 6,
						max = 24,
						step = 1,
						get = function(info) return self:GetConfig('fontHeight') end,
						set = function(info, val)
							self:SetConfig('fontHeight', val)
							self:UpdateMedia()
						end
					},
					fontflags = {
						type = "select",
						order = 3,
						name = "Outline",
						desc = "Sets the font outline used to display a page",
						values = { ["NONE"] = "None", ["OUTLINE"] = "Outline", ["THICKOUTLINE"] = "Thick Outline", ["MONOCHROMEOUTLINE"] = "Monochrome" },
						get = function(info) return self:GetConfig('fontFlags') end,
						set = function(info, val)
							self:SetConfig('fontFlags', val)
							self:UpdateMedia()
						end
					},
					color = {
						type = "color",
						order = 4,
						name = "Normal Color",
						desc = "The normal color used to display assignments",
						get = function(info)
							local hex = self:GetConfig('color')
							return HexToRGB(hex)
						end,
						set = function(info, r, g, b)
							self:SetConfig('color', RGBToHex(r, g, b))
							self:UpdateMedia()
							self:UpdateDisplayed()
						end
					},
					highlightcolor = {
						type = "color",
						order = 5,
						name = "Highlight Color",
						desc = "The color used to emphasize highlighted words",
						get = function(info)
							local hex = self:GetConfig('highlightColor')
							return HexToRGB(hex)
						end,
						set = function(info, r, g, b)
							self:SetConfig('highlightColor', RGBToHex(r, g, b))
							self:UpdateDisplayed()
						end
					}
				}
			},
			permissions = { 
				type = "group",
				order = 7,
				name = "Permissions",
				inline = true,
				args = {
					allowall = {
						type = "toggle",
						order = 1,
						name = "Allow All",
						desc = "Enable to allow changes from any raid assistant, even if you aren't in a guild raid",
						get = function(info) return self:GetConfig('allowall') end,
						set = function(info, val)
							self:SetConfig('allowall', val)
							self:PermissionsUpdated()
						end
					},
					allowplayers = {
						type = "input",
						order = 2,
						name = "Allow Players",
						desc = "A list of players that when they are the raid leader to allow changes from all raid assistants",
						get = function(info) return self:GetConfig('allowplayers') end,
						set = function(info, val)
							self:SetConfig('allowplayers', val)
							self:PermissionsUpdated()
						end
					},
				}
			}
		}
	}

	self:RegisterChatCommand("aa", "ChatCommand")
	LibStub("AceConfig-3.0"):RegisterOptionsTable("AngryAssign", options)

	blizOptionsPanel = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AngryAssign", "Angry Assignments")
	blizOptionsPanel.default = function() self:RestoreDefaults() end
end

function AngryAssign:ChatCommand(input)
  if not input or input:trim() == "" then
	InterfaceOptionsFrame_OpenToCategory(blizOptionsPanel)
	InterfaceOptionsFrame_OpenToCategory(blizOptionsPanel)
  else
    LibStub("AceConfigCmd-3.0").HandleCommand(self, "aa", "AngryAssign", input)
  end
end

function AngryAssign:OnEnable()
	self:UpdateOfficerRank()
	self:CreateDisplay()
	
	self:ScheduleTimer("AfterEnable", 4)

	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_GUILD_UPDATE")

	LSM.RegisterCallback(self, "LibSharedMedia_Registered", "UpdateMedia")
	LSM.RegisterCallback(self, "LibSharedMedia_SetGlobal", "UpdateMedia")
end


function AngryAssign:PARTY_LEADER_CHANGED()
	self:PermissionsUpdated()
	if AngryAssign_State.displayed and not self:IsGuildRaid() then self:ClearDisplayed() end
end

function AngryAssign:PARTY_CONVERTED_TO_RAID()
	self:SendRequestDisplay()
	self:SendVerQuery()
	self:UpdateDisplayedIfNewGroup()
end

function AngryAssign:GROUP_JOINED()
	self:SendVerQuery()
	self:UpdateDisplayedIfNewGroup()
	self:ScheduleTimer("SendRequestDisplay", 0.5)
end

function AngryAssign:PLAYER_REGEN_DISABLED()
	if AngryAssign:GetConfig('hideoncombat') then
		self:HideDisplay()
	end
end

function AngryAssign:GROUP_ROSTER_UPDATE()
	self:UpdateSelected()
	if not (IsInRaid() or IsInGroup()) then
		if AngryAssign_State.displayed then self:ClearDisplayed() end
		currentGroup = nil
		warnedPermission = false
	else
		self:UpdateDisplayedIfNewGroup()
	end
end

function AngryAssign:PLAYER_GUILD_UPDATE()
	self:UpdateOfficerRank()
	self:RegisterEvent("GUILD_ROSTER_UPDATE")
	GuildRoster()
end

function AngryAssign:GUILD_ROSTER_UPDATE()
	self:UpdateOfficerRank()
	self:PermissionsUpdated()
	self:UnregisterEvent("GUILD_ROSTER_UPDATE")
end

function AngryAssign:AfterEnable()
	self:RegisterComm(comPrefix, "ReceiveMessage")
	comnStarted = true

	if not (IsInRaid() or IsInGroup()) then
		self:ClearDisplayed()
	end
	
	self:RegisterEvent("PARTY_CONVERTED_TO_RAID")
	self:RegisterEvent("PARTY_LEADER_CHANGED")
	self:RegisterEvent("GROUP_JOINED")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	
	self:SendRequestDisplay()
	self:UpdateDisplayedIfNewGroup()
	self:SendVerQuery()
end

-------------------------------------------------------------------
---------Missing Methods that were implemented in MoP/WoD----------
-------------------------------------------------------------------

function IsInRaid()
	if(GetNumRaidMembers() > 0) then
		return true
	end
	return false;
end

function IsInGroup()
	if(GetNumRaidMembers() == 0 and GetNumPartyMembers() > 0) then
		return true
	end
	return false;
end

function GetNumGroupMembers()
	if (IsInRaid()) then
		return GetNumRaidMembers();
	elseif (IsInGroup()) then
		return GetNumPartyMembers() + 1;
	end
end

function UnitIsGroupLeader(playerName)
	if(IsInRaid()) then
		local name, rank = GetRaidRosterInfo(UnitInRaid(playerName));
		if(rank == 2) then
			return true;
		end
	elseif (IsInGroup()) then
		if((UnitName("player") == playername) and IsPartyLeader()) then
			return true;
		end
		return true;
	end
	return false;
end

function UnitIsGroupAssistant(playerName)
	if(IsInRaid()) then
		local name, rank = GetRaidRosterInfo(UnitInRaid(playerName));
		if(rank == 1) then
			return true;
		end
	end
	return false;
end
