local SLE, T, E, L, V, P, G = unpack(select(2, ...)) 
local LibQTip = LibStub('LibQTip-1.0')
local DTP = SLE:GetModule('Datatexts')
local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("S&L Guild",
{
	type	= "data source",
	icon	= "Interface\\Icons\\INV_Drink_08.png",
	label	= "S&L Guild",
	text	= "S&L Guild"
})
local _G = _G
local MyRealm = T.gsub(E.myrealm,'[%s%-]','')
local frame = CreateFrame("frame")

local tooltip
local LDB_ANCHOR

local GROUP_CHECKMARK	= "|TInterface\\Buttons\\UI-CheckBox-Check:0|t"
local AWAY_ICON		= "|TInterface\\FriendsFrame\\StatusIcon-Away:18|t"
local BUSY_ICON		= "|TInterface\\FriendsFrame\\StatusIcon-DnD:18|t"
local MOBILE_ICON	= "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat:18|t"
local MINIMIZE		= "|TInterface\\BUTTONS\\UI-PlusButton-Up:0|t"

local FACTION_COLOR_HORDE = RED_FONT_COLOR_CODE
local FACTION_COLOR_ALLIANCE = "|cff0070dd"
local MINIMIZE = MINIMIZE
local GUILD = GUILD
local IsShiftKeyDown, IsControlKeyDown, IsAltKeyDown = IsShiftKeyDown, IsControlKeyDown, IsAltKeyDown
local SetItemRef = SetItemRef
local StaticPopup_Show = StaticPopup_Show
local SetGuildRosterSelection = SetGuildRosterSelection
local ToggleGuildFrame = ToggleGuildFrame

-- Setup the Title Font. 14
local ssTitleFont = CreateFont("ssTitleFont")
ssTitleFont:SetTextColor(1,0.823529,0)

-- Setup the Header Font. 12
local ssHeaderFont = CreateFont("ssHeaderFont")
ssHeaderFont:SetTextColor(1,0.823529,0)

-- Setup the Regular Font. 12
local ssRegFont = CreateFont("ssRegFont")
ssRegFont:SetTextColor(1,0.823529,0)

local list_sort = {
	TOONNAME = function(a, b)
		if not a["TOONNAME"] or not b["TOONNAME"] then return false end
		return a["TOONNAME"] < b["TOONNAME"]
	end,
	LEVEL =	function(a, b)
		if not a["LEVEL"] or not b["LEVEL"] then
			return false
		elseif a["LEVEL"] < b["LEVEL"] then
			return true
		elseif a["LEVEL"] > b["LEVEL"] then
			return false
		else  -- TOONNAME
			return a["TOONNAME"] < b["TOONNAME"]
		end
	end,
	RANKINDEX =	function(a, b)
		if not a["RANKINDEX"] or not b["RANKINDEX"] then
			return false
		elseif a["RANKINDEX"] > b["RANKINDEX"] then
			return true
		elseif a["RANKINDEX"] < b["RANKINDEX"] then
			return false
		else -- TOONNAME
			return a["TOONNAME"] < b["TOONNAME"]
		end
	end,
	ZONENAME = function(a, b)
		if not a["ZONENAME"] or not b["ZONENAME"] then
			return false
		elseif a["ZONENAME"] < b["ZONENAME"] then
			return true
		elseif a["ZONENAME"] > b["ZONENAME"] then
			return false
		else -- TOONNAME
			return a["TOONNAME"] < b["TOONNAME"]
		end
	end,
	revTOONNAME	= function(a, b)
		if a["TOONNAME"] or not b["TOONNAME"] then return false end
		return a["TOONNAME"] > b["TOONNAME"]
	end,
	revLEVEL = function(a, b)
		if not a["LEVEL"] or not b["LEVEL"] then
			return false
		elseif a["LEVEL"] > b["LEVEL"] then
			return true
		elseif a["LEVEL"] < b["LEVEL"] then
			return false
		else  -- TOONNAME
			return a["TOONNAME"] < b["TOONNAME"]
		end
	end,
	revRANKINDEX = function(a, b)
		if not a["RANKINDEX"] or not b["RANKINDEX"] then
			return false
		elseif a["RANKINDEX"] < b["RANKINDEX"] then
			return true
		elseif a["RANKINDEX"] > b["RANKINDEX"] then
			return false
		else -- TOONNAME
			return a["TOONNAME"] < b["TOONNAME"]
		end
	end,
	revZONENAME	= function(a, b)
		if not a["ZONENAME"] or not b["ZONENAME"] then
			return false
		elseif a["ZONENAME"] > b["ZONENAME"] then
			return true
		elseif a["ZONENAME"] < b["ZONENAME"] then
			return false
		else -- TOONNAME
			return a["TOONNAME"] < b["TOONNAME"]
		end
	end
}

local function inGroup(name)
	if T.GetNumSubgroupMembers() > 0 and T.UnitInParty(name) then
		return true
	elseif T.GetNumGroupMembers() > 0 and T.UnitInRaid(name) then
		return true
	end

	return false
end

local function guild_name_to_index(name)
	local lookupname

	for i = 1, T.GetNumGuildMembers() do
		lookupname = T.GetGuildRosterInfo(i)

		if lookupname == name then
			return i
		end
	end
end

local function ColoredLevel(level)
	if level ~= "" then
		local color = T.GetQuestDifficultyColor(level)
		return T.format("|cff%02x%02x%02x%d|r", color.r * 255, color.g * 255, color.b * 255, level)
	end
end

local CLASS_COLORS, color = {}
local classes_female, classes_male = {}, {}

FillLocalizedClassList(classes_female, true)
FillLocalizedClassList(classes_male, false)

for token, localizedName in T.pairs(classes_female) do
	color = RAID_CLASS_COLORS[token]
	CLASS_COLORS[localizedName] = T.format("%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255) 
end

for token, localizedName in T.pairs(classes_male) do
	color = RAID_CLASS_COLORS[token]
	CLASS_COLORS[localizedName] = T.format("%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255) 
end

local function valueColor(totals)
	if totals ~= "" then
		local color = E.db.general.valuecolor
		return T.format("|cff%02x%02x%02x%d|r", color.r * 255, color.g * 255, color.b * 255, totals)
	end
end

function DTP:update_Guild()
	if T.IsInGuild() then
		T.GuildRoster()
		local guildTotal, online = T.GetNumGuildMembers()
		for i = 1, guildTotal do
			local _, _, _, _, _, _, _, _, connected, _, _, _, _, isMobile = T.GetGuildRosterInfo(i)
			if isMobile then
				online = online + 1
			end
		end
		local text = E.db.sle.dt.guild.textStyle == "Default" and GUILD..": " or E.db.sle.dt.guild.textStyle == "NoText" and "" or E.db.sle.dt.guild.textStyle == "Icon" and "|TInterface\\ICONS\\Achievement_Dungeon_HEROIC_GloryoftheRaider:12|t: "
		if E.db.sle.dt.guild.totals then
			LDB.text = --[["|cff82c5ff"]]text..valueColor(online).."/"..valueColor(guildTotal)--[["|r"]]
		else
			LDB.text = text..valueColor(online)
		end
	else
		LDB.text = L["No Guild"]
	end
end

local function Entry_OnMouseUp(frame, info, button)
	local i_type, toon_name, full_name, presence_id = T.split(":", info)

	if button == "LeftButton" then
		if IsAltKeyDown() then
			T.InviteUnit(toon_name)
			return
		end

		if IsShiftKeyDown() then
			SetItemRef("player:"..toon_name, "|Hplayer:"..toon_name.."|h["..toon_name.."|h", "LeftButton")
			return
		end

		if IsControlKeyDown() then
			if i_type == "guild" and T.CanEditPublicNote() then
				SetGuildRosterSelection(guild_name_to_index(toon_name))
				StaticPopup_Show("SET_GUILDPLAYERNOTE")
				return
			end
		end

		SetItemRef( "player:"..full_name, T.format("|Hplayer:%1$s|h[%1$s]|h", full_name), "LeftButton" )
	elseif button == "RightButton" then
		if IsControlKeyDown() then
			if i_type == "guild" and T.CanEditOfficerNote() then
				SetGuildRosterSelection(guild_name_to_index(toon_name))
				StaticPopup_Show("SET_GUILDOFFICERNOTE")
			end
		end
	end
end

local function HideOnMouseUp(cell, section)
	E.db.sle.dt.guild[section] = not E.db.sle.dt.guild[section]
	LDB.OnEnter(LDB_ANCHOR)
end

local function SetGuildSort(cell, sortsection)
	if E.db.sle.dt.guild["sortGuild"] == sortsection then
		E.db.sle.dt.guild["sortGuild"] = "rev" .. sortsection
	else
		E.db.sle.dt.guild["sortGuild"] = sortsection
	end
	LDB.OnEnter(LDB_ANCHOR)
end

function LDB:OnClick(button)
	if button == "LeftButton" then
		ToggleGuildFrame(1)
	end

	if button == "RightButton" then
		E:ToggleConfig()
		SLE.ACD:SelectGroup("ElvUI", "sle", "modules", "datatext", "sldatatext", "slguild")
	end
end

function LDB.OnLeave() end

function LDB.OnEnter(self)
	if E.db.sle.dt.guild.combat and T.InCombatLockdown() then return end
	LDB_ANCHOR = self

	if LibQTip:IsAcquired("ShadowLightGuild") then
		tooltip:Clear()
	else
		tooltip = LibQTip:Acquire("ShadowLightGuild", 8, "RIGHT", "RIGHT", "LEFT", "LEFT", "CENTER", "CENTER", "RIGHT")

		tooltip:SetBackdropColor(0,0,0,1)

		ssHeaderFont:SetFont(GameTooltipHeaderText:GetFont())
		ssRegFont:SetFont(GameTooltipText:GetFont())
		tooltip:SetHeaderFont(ssHeaderFont)
		tooltip:SetFont(ssRegFont)

		tooltip:SmartAnchorTo(self)
		tooltip:SetAutoHideDelay(E.db.sle.dt.guild.tooltipAutohide, self)
		tooltip:SetScript("OnShow", function(ttskinself) ttskinself:SetTemplate('Transparent') end)
	end

	local line = tooltip:AddLine()
	if not E.db.sle.dt.guild.hide_titleline then
		ssTitleFont:SetFont(GameTooltipText:GetFont())
		tooltip:SetCell(line, 1, "Shadow & Light Guild", ssTitleFont, "CENTER", 0)
		tooltip:AddLine(" ")
	end

	if T.IsInGuild() then
		local guild_table = {}
		if not E.db.sle.dt.guild.hide_gmotd then
			line = tooltip:AddLine()
			if not E.db.sle.dt.guild.minimize_gmotd then
				tooltip:SetCell(line, 1, "|cffffffff" .. _G.CHAT_GUILD_MOTD_SEND .. "|r", "LEFT", 3)
			else
				tooltip:SetCell(line, 1, "|cffffffff".. MINIMIZE .. _G.CHAT_GUILD_MOTD_SEND .. "|r", "LEFT", 3)
			end
			tooltip:SetCellScript(line, 1, "OnMouseUp", HideOnMouseUp, "minimize_gmotd")

			if not E.db.sle.dt.guild.minimize_gmotd then
				line = tooltip:AddLine()
				tooltip:SetCell(line, 1, "|cff00ff00"..T.GetGuildRosterMOTD().."|r", "LEFT", 0, nil, nil, nil, 100)
			end

			tooltip:AddLine(" ")
		end

		local ssGuildName
		if not E.db.sle.dt.guild.hide_guildname then
			ssGuildName = T.GetGuildInfo("player")
		else
			ssGuildName = _G.GUILD
		end
		if not ssGuildName then return end
		line = tooltip:AddLine()
		if not E.db.sle.dt.guild.hideGuild then
			tooltip:SetCell(line, 1, "|cffffffff" .. ssGuildName .."|r", "LEFT", 3)
		else
			line = tooltip:SetCell(line, 1, MINIMIZE .. "|cffffffff" .. ssGuildName .. "|r", "LEFT", 3)
		end
		tooltip:SetCellScript(line, 1, "OnMouseUp", HideOnMouseUp, "hideGuild")

		if not E.db.sle.dt.guild.hideGuild then
			line = tooltip:AddHeader()
			line = tooltip:SetCell(line, 1, "  ")
			tooltip:SetCellScript(line, 1, "OnMouseUp", SetGuildSort, "LEVEL")
			line = tooltip:SetCell(line, 3, _G.NAME)
			tooltip:SetCellScript(line, 3, "OnMouseUp", SetGuildSort, "TOONNAME")
			line = tooltip:SetCell(line, 5, _G.ZONE)
			tooltip:SetCellScript(line, 5, "OnMouseUp", SetGuildSort, "ZONENAME")
			line = tooltip:SetCell(line, 6, _G.RANK)
			tooltip:SetCellScript(line, 6, "OnMouseUp", SetGuildSort, "RANKINDEX")

			if not E.db.sle.dt.guild.hide_guild_onotes then
				line = tooltip:SetCell(line, 7, _G.NOTE_COLON)
			else
				line = tooltip:SetCell(line, 7, MINIMIZE .. _G.NOTE_COLON)
			end
			tooltip:SetCellScript(line, 7, "OnMouseUp", HideOnMouseUp, "hide_guild_onotes")

			tooltip:AddSeparator()

			for i = 1, T.GetNumGuildMembers() do
				local toonName, rank, rankindex, level, class, zoneName, note, onote, connected, status, classFileName, achievementPoints, achievementRank, isMobile = T.GetGuildRosterInfo(i)
				local toonShortName, toonRealm = T.split("-", toonName)
				if MyRealm == toonRealm then toonName = toonShortName end
				if connected or isMobile then
					if note and note ~= '' then note="|cff00ff00["..note.."]|r" end
					if onote and onote ~= '' then onote = "|cff00ffff["..onote.."]|r" end

					if status == 1 then
						status = AWAY_ICON
					elseif status == 2 then
						status = BUSY_ICON
					elseif status == 0 then
						status = ''
					end

					if isMobile then
						status = MOBILE_ICON
						zoneName = "Remote Chat"
					end

					T.tinsert(guild_table, {
						TOONNAME = toonName,
						RANK = rank,
						RANKINDEX = rankindex,
						LEVEL = level,
						CLASS = class,
						ZONENAME = zoneName,
						NOTE = note,
						ONOTE = onote,
						STATUS = status
						})
				end
			end

			T.sort(guild_table, list_sort[E.db.sle.dt.guild["sortGuild"]])

			for _, player in T.ipairs(guild_table) do
					line = tooltip:AddLine()
					line = tooltip:SetCell(line, 1, ColoredLevel(player["LEVEL"]))
					line = tooltip:SetCell(line, 2, player["STATUS"])
					line = tooltip:SetCell(line, 3,
						T.format("|cff%s%s", CLASS_COLORS[player["CLASS"]] or "ffffff", player["TOONNAME"] .. "|r") .. (inGroup(player["TOONNAME"]) and GROUP_CHECKMARK or ""))
					line = tooltip:SetCell(line, 5, player["ZONENAME"] or "???")
					line = tooltip:SetCell(line, 6, player["RANK"])
					if not E.db.sle.dt.guild.hide_guild_onotes then
						line = tooltip:SetCell(line, 7, player["NOTE"] .. player["ONOTE"])
					end

					tooltip:SetLineScript(line, "OnMouseUp", Entry_OnMouseUp, T.format("guild:%s:%s", player["TOONNAME"], player["TOONNAME"]))
			end
		end
		tooltip:AddLine(" ")
	end

	if not E.db.sle.dt.guild.hide_hintline then
		line = tooltip:AddLine()
		if not E.db.sle.dt.guild.minimize_hintline then
			tooltip:SetCell(line, 1, "Hint:", "LEFT", 3)
		else
			tooltip:SetCell(line, 1, MINIMIZE .. "Hint:", "LEFT", 3)
		end
		tooltip:SetCellScript(line, 1, "OnMouseUp", HideOnMouseUp, "minimize_hintline")

		if not E.db.sle.dt.guild.minimize_hintline then
			line = tooltip:AddLine()
			tooltip:SetCell(line, 1, "", "LEFT", 1)
			tooltip:SetCell(line, 2, L["|cffeda55fLeft Click|r to open the guild panel."], "LEFT", 3)
			tooltip:SetCell(line, 5, L["|cffeda55fRight Click|r to open configuration panel."], "LEFT", 3)
			line = tooltip:AddLine()
			tooltip:SetCell(line, 1, "", "LEFT", 1)
			tooltip:SetCell(line, 2, L["|cffeda55fLeft Click|r a line to whisper a player."], "LEFT", 3)
			tooltip:SetCell(line, 5, L["|cffeda55fShift+Left Click|r a line to lookup a player."], "LEFT", 3)--
			line = tooltip:AddLine()
			tooltip:SetCell(line, 1, "", "LEFT", 1)
			tooltip:SetCell(line, 2, L["|cffeda55fCtrl+Left Click|r a line to edit note."], "LEFT", 3)
			tooltip:SetCell(line, 5, L["|cffeda55fCtrl+Right Click|r a line to edit officer note."], "LEFT", 3)
			line = tooltip:AddLine()
			tooltip:SetCell(line, 1, "", "LEFT", 1)
			tooltip:SetCell(line, 2, L["|cffeda55fAlt+Left Click|r a line to invite."], "LEFT", 3)--
			tooltip:SetCell(line, 5, L["|cffeda55fLeft Click|r a Header to hide it or sort it."], "LEFT", 3)--
		end
	end

	tooltip:UpdateScrolling()
	tooltip:Show()
end

frame:SetScript("OnEvent", function(self, event, ...)
	if self[event] then
		return self[event](self, event, ...) 
	end 
end)

local DELAY = 15  --  Update every 15 seconds
local elapsed = DELAY - 5

frame:SetScript("OnUpdate", function (self, elapse)
	elapsed = elapsed + elapse

	if elapsed >= DELAY then
		elapsed = 0
		DTP:update_Guild()
	end
end)

frame:RegisterEvent("PLAYER_LOGIN")
