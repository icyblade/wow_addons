local E, L, V, P, G = unpack(select(2, ...))
local M = E:GetModule("Minimap")
local RBR = E:GetModule("ReminderBuffs")

local unpack = unpack
local format, match, utf8sub = string.format, string.match, string.utf8sub

local CloseAllWindows = CloseAllWindows
local CloseMenus = CloseMenus
local CreateFrame = CreateFrame
local GetMinimapZoneText = GetMinimapZoneText
local GetZonePVPInfo = GetZonePVPInfo
local GuildInstanceDifficulty = GuildInstanceDifficulty
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local IsShiftKeyDown = IsShiftKeyDown
local MainMenuMicroButton_SetNormal = MainMenuMicroButton_SetNormal
local Minimap_OnClick = Minimap_OnClick
local PlaySound = PlaySound
local ShowUIPanel, HideUIPanel = ShowUIPanel, HideUIPanel
local UIErrorsFrame = UIErrorsFrame
local ToggleDropDownMenu = ToggleDropDownMenu
local ToggleAchievementFrame = ToggleAchievementFrame
local ToggleCharacter = ToggleCharacter
local ToggleFrame = ToggleFrame
local ToggleFriendsFrame = ToggleFriendsFrame
local ToggleGuildFrame = ToggleGuildFrame
local ToggleHelpFrame = ToggleHelpFrame

local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", E.UIParent, "UIDropDownMenuTemplate")
local guildText = IsInGuild() and ACHIEVEMENTS_GUILD_TAB or LOOKINGFORGUILD
local menuList = {
	{text = CHARACTER_BUTTON, notCheckable = 1, func = function()
		ToggleCharacter("PaperDollFrame")
	end},
	{text = SPELLBOOK_ABILITIES_BUTTON, notCheckable = 1, func = function()
		ToggleFrame(SpellBookFrame)
	end},
	{text = TALENTS_BUTTON, notCheckable = 1, func = function()
		if not PlayerTalentFrame then
			TalentFrame_LoadUI()
		end
		if not GlyphFrame then
			GlyphFrame_LoadUI()
		end
		if not PlayerTalentFrame:IsShown() then
			ShowUIPanel(PlayerTalentFrame)
		else
			HideUIPanel(PlayerTalentFrame)
		end
	end},
	{text = ACHIEVEMENT_BUTTON, notCheckable = 1, func = ToggleAchievementFrame},
	{text = QUESTLOG_BUTTON, notCheckable = 1, func = function()
		ToggleFrame(QuestLogFrame)
	end},
	{text = SOCIAL_BUTTON, notCheckable = 1, func = function()
		ToggleFriendsFrame(1)
	end},
	{text = L["Calendar"], notCheckable = 1, func = function()
		if not CalendarFrame then
			LoadAddOn("Blizzard_Calendar")
		end
		Calendar_Toggle()
	end},
	{text = L["Farm Mode"], notCheckable = 1, func = FarmMode},
	{text = BATTLEFIELD_MINIMAP, notCheckable = 1, func = ToggleBattlefieldMinimap},
	{text = TIMEMANAGER_TITLE, notCheckable = 1, func = ToggleTimeManager},
	{text = guildText, notCheckable = 1, func = ToggleGuildFrame},
	{text = PLAYER_V_PLAYER, notCheckable = 1, func = function()
		if E.mylevel >= SHOW_PVP_LEVEL then
			ToggleFrame(PVPFrame)
		else
			UIErrorsFrame:AddMessage(format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_PVP_LEVEL), 1, 0.1, 0.1)
		end
	end},
	{text = DUNGEONS_BUTTON, notCheckable = 1, func = function()
		if E.mylevel >= SHOW_LFD_LEVEL then
			ToggleFrame(LFDParentFrame)
		else
			UIErrorsFrame:AddMessage(format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_LFD_LEVEL), 1, 0.1, 0.1)
		end
	end},
	{text = RAID_FINDER, notCheckable = 1, func = function()
		ToggleFrame(RaidParentFrame)
	end},
	{text = ENCOUNTER_JOURNAL, notCheckable = 1, func = function()
		if not IsAddOnLoaded("Blizzard_EncounterJournal") then EncounterJournal_LoadUI() end
		ToggleFrame(EncounterJournal)
	end},
	{text = HELP_BUTTON, notCheckable = 1, func = ToggleHelpFrame},
	{text = MAINMENU_BUTTON, notCheckable = 1, func = function()
		if not GameMenuFrame:IsShown() then
			if VideoOptionsFrame:IsShown() then
				VideoOptionsFrameCancel:Click()
			elseif AudioOptionsFrame:IsShown() then
				AudioOptionsFrameCancel:Click()
			elseif InterfaceOptionsFrame:IsShown() then
				InterfaceOptionsFrameCancel:Click()
			end
			CloseMenus()
			CloseAllWindows()
			PlaySound("igMainMenuOpen")
			ShowUIPanel(GameMenuFrame)
		else
			PlaySound("igMainMenuQuit")
			HideUIPanel(GameMenuFrame)
			MainMenuMicroButton_SetNormal()
		end
	end}
}

function M:Minimap_OnMouseUp(btn)
	local position = self:GetPoint()

	if btn == "MiddleButton" or (btn == "RightButton" and IsShiftKeyDown()) then
		if match(position, "LEFT") then
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
		else
			EasyMenu(menuList, menuFrame, "cursor", -160, 0, "MENU", 2)
		end
	elseif btn == "RightButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor")
	else
		Minimap_OnClick(self)
	end
end

function M:GetLocTextColor()
	local pvpType = GetZonePVPInfo()

	if pvpType == "arena" then
		return 0.84, 0.03, 0.03
	elseif pvpType == "friendly" then
		return 0.05, 0.85, 0.03
	elseif pvpType == "contested" then
		return 0.9, 0.85, 0.05
	elseif pvpType == "hostile" then
		return 0.84, 0.03, 0.03
	elseif pvpType == "sanctuary" then
		return 0.035, 0.58, 0.84
	elseif pvpType == "combat" then
		return 0.84, 0.03, 0.03
	else
		return 0.9, 0.85, 0.05
	end
end

function M:Update_ZoneText()
	if E.db.general.minimap.locationText == "HIDE" or not E.private.general.minimap.enable then return end

	Minimap.location:FontTemplate(E.Libs.LSM:Fetch("font", E.db.general.minimap.locationFont), E.db.general.minimap.locationFontSize, E.db.general.minimap.locationFontOutline)
	Minimap.location:SetText(utf8sub(GetMinimapZoneText(), 1, 46))
	Minimap.location:SetTextColor(M:GetLocTextColor())
end

function M:Minimap_OnMouseWheel(d)
	local zoomLevel = Minimap:GetZoom()

	if d > 0 and zoomLevel < 5 then
		Minimap:SetZoom(zoomLevel + 1)
	elseif d < 0 and zoomLevel > 0 then
		Minimap:SetZoom(zoomLevel - 1)
	end
end

local isResetting
local function ResetZoom()
	Minimap:SetZoom(0)
	isResetting = nil
end

local function SetupZoomReset(self, zoomLevel)
	if not isResetting and zoomLevel > 0 and E.db.general.minimap.resetZoom.enable then
		isResetting = true
		E:Delay(E.db.general.minimap.resetZoom.time, ResetZoom)
	end
end

function M:CreateFarmModeMap()
	local fm = CreateFrame("Minimap", "FarmModeMap", E.UIParent)
	fm:CreateBackdrop()
	fm:Point("TOP", E.UIParent, "TOP", 0, -120)
	fm:Size(E.db.farmSize)
	fm:SetClampedToScreen(true)
	fm:EnableMouseWheel(true)
	fm:SetMovable(true)
	fm:RegisterForDrag("LeftButton", "RightButton")
	fm:SetScript("OnMouseUp", M.Minimap_OnMouseUp)
	fm:SetScript("OnMouseWheel", M.Minimap_OnMouseWheel)
	fm:SetScript("OnDragStart", function(frame) frame:StartMoving() end)
	fm:SetScript("OnDragStop", function(frame) frame:StopMovingOrSizing() end)
	fm:Hide()

	M.farmModeMap = fm

	fm:SetScript("OnShow", function()
		if BuffsMover and not E:HasMoverBeenMoved("BuffsMover") then
			BuffsMover:ClearAllPoints()
			BuffsMover:Point("TOPRIGHT", E.UIParent, "TOPRIGHT", -3, -3)
		end

		if DebuffsMover and not E:HasMoverBeenMoved("DebuffsMover") then
			DebuffsMover:ClearAllPoints()
			DebuffsMover:Point("TOPRIGHT", ElvUIPlayerBuffs, "BOTTOMRIGHT", 0, -3)
		end

		MinimapCluster:ClearAllPoints()
		MinimapCluster:SetAllPoints(fm)

		if IsAddOnLoaded("Routes") then
			LibStub("AceAddon-3.0"):GetAddon("Routes"):ReparentMinimap(fm)
		end

		if IsAddOnLoaded("GatherMate2") then
			LibStub("AceAddon-3.0"):GetAddon("GatherMate2"):GetModule("Display"):ReparentMinimapPins(fm)
		end
	end)

	fm:SetScript("OnHide", function()
		if BuffsMover and not E:HasMoverBeenMoved("BuffsMover") then
			E:ResetMovers(L["Player Buffs"])
		end

		if DebuffsMover and not E:HasMoverBeenMoved("DebuffsMover") then
			E:ResetMovers(L["Player Debuffs"])
		end

		MinimapCluster:ClearAllPoints()
		MinimapCluster:SetAllPoints(Minimap)

		if IsAddOnLoaded("Routes") then
			LibStub("AceAddon-3.0"):GetAddon("Routes"):ReparentMinimap(Minimap)
		end

		if IsAddOnLoaded("GatherMate2") then
			LibStub("AceAddon-3.0"):GetAddon("GatherMate2"):GetModule("Display"):ReparentMinimapPins(Minimap)
		end
	end)
end

function M:PLAYER_REGEN_ENABLED()
	M:UnregisterEvent("PLAYER_REGEN_ENABLED")
	M:UpdateSettings()
end

function M:UpdateSettings()
	if InCombatLockdown() then
		M:RegisterEvent("PLAYER_REGEN_ENABLED")
	end

	local mWidth, mHeight = Minimap:GetSize()
	E.MinimapSize = E.private.general.minimap.enable and E.db.general.minimap.size or mWidth
	E.RBRWidth = E.db.general.reminder.enable and (E.MinimapSize + ((E.Border - E.Spacing * 3) * 5) + E.Border * 2) / 6 or E:Scale(E.PixelMode and 1 or -1)

	if E.private.general.minimap.enable then
		Minimap:Size(E.MinimapSize, E.MinimapSize)
	end

	if MMHolder then
		local panel = E.db.datatexts.minimapPanels and (LeftMiniPanel and (LeftMiniPanel:GetHeight() + E.Border) or 24) or E:Scale(E.PixelMode and 2 or 1)
		MMHolder:Width((mWidth + E.Border + E.Spacing * 4) + E.RBRWidth)
		MMHolder:Height(mHeight + panel + E.Spacing * 3)
	end

	if MinimapMover then
		MinimapMover:Size(MMHolder:GetSize())
	end

	if ElvConfigToggle then
		ElvConfigToggle:Width(E.RBRWidth)

		if E.db.general.reminder.enable and E.db.datatexts.minimapPanels and E.private.general.minimap.enable then
			ElvConfigToggle:Show()
		else
			ElvConfigToggle:Hide()
		end
	end

	if ElvUI_ReminderBuffs then
		RBR:UpdateSettings()
	end

	if Minimap.location then
		Minimap.location:Width(E.MinimapSize)

		if E.db.general.minimap.locationText == "SHOW" and E.private.general.minimap.enable then
			Minimap.location:Show()
		else
			Minimap.location:Hide()
		end
	end

	if LeftMiniPanel and RightMiniPanel then
		if E.db.datatexts.minimapPanels and E.private.general.minimap.enable then
			LeftMiniPanel:Show()
			RightMiniPanel:Show()
		else
			LeftMiniPanel:Hide()
			RightMiniPanel:Hide()
		end
	end

	if BottomMiniPanel then
		if E.db.datatexts.minimapBottom and E.private.general.minimap.enable then
			BottomMiniPanel:Show()
		else
			BottomMiniPanel:Hide()
		end
	end

	if BottomLeftMiniPanel then
		if E.db.datatexts.minimapBottomLeft and E.private.general.minimap.enable then
			BottomLeftMiniPanel:Show()
		else
			BottomLeftMiniPanel:Hide()
		end
	end

	if BottomRightMiniPanel then
		if E.db.datatexts.minimapBottomRight and E.private.general.minimap.enable then
			BottomRightMiniPanel:Show()
		else
			BottomRightMiniPanel:Hide()
		end
	end

	if TopMiniPanel then
		if E.db.datatexts.minimapTop and E.private.general.minimap.enable then
			TopMiniPanel:Show()
		else
			TopMiniPanel:Hide()
		end
	end

	if TopLeftMiniPanel then
		if E.db.datatexts.minimapTopLeft and E.private.general.minimap.enable then
			TopLeftMiniPanel:Show()
		else
			TopLeftMiniPanel:Hide()
		end
	end

	if TopRightMiniPanel then
		if E.db.datatexts.minimapTopRight and E.private.general.minimap.enable then
			TopRightMiniPanel:Show()
		else
			TopRightMiniPanel:Hide()
		end
	end

	--Stop here if ElvUI Minimap is disabled.
	if not E.private.general.minimap.enable then return end

	if GameTimeFrame then
		if E.db.general.minimap.icons.calendar.hide then
			GameTimeFrame:Hide()
		else
			local pos = E.db.general.minimap.icons.calendar.position or "TOPRIGHT"
			local scale = E.db.general.minimap.icons.calendar.scale or 1

			GameTimeFrame:ClearAllPoints()
			GameTimeFrame:Point(pos, Minimap, pos, E.db.general.minimap.icons.calendar.xOffset or 0, E.db.general.minimap.icons.calendar.yOffset or 0)
			GameTimeFrame:SetScale(scale)
			GameTimeFrame:Show()
		end
	end

	if MiniMapMailFrame then
		local pos = E.db.general.minimap.icons.mail.position or "TOPRIGHT"
		local scale = E.db.general.minimap.icons.mail.scale or 1

		MiniMapMailFrame:ClearAllPoints()
		MiniMapMailFrame:Point(pos, Minimap, pos, E.db.general.minimap.icons.mail.xOffset or 3, E.db.general.minimap.icons.mail.yOffset or 4)
		MiniMapMailFrame:SetScale(scale)

		MiniMapMailIcon:SetTexture(E.Media.MailIcons[E.db.general.minimap.icons.mail.texture] or E.Media.MailIcons.Mail0)
	end

	if MiniMapLFGFrame then
		local pos = E.db.general.minimap.icons.lfgEye.position or "BOTTOMRIGHT"
		local scale = E.db.general.minimap.icons.lfgEye.scale or 1

		MiniMapLFGFrame:ClearAllPoints()
		MiniMapLFGFrame:Point(pos, Minimap, pos, E.db.general.minimap.icons.lfgEye.xOffset or 3, E.db.general.minimap.icons.lfgEye.yOffset or 0)
		MiniMapLFGFrame:SetScale(scale)
		LFGSearchStatus:SetScale(1 / scale)
	end

	if MiniMapBattlefieldFrame then
		local pos = E.db.general.minimap.icons.battlefield.position or "BOTTOMRIGHT"
		local scale = E.db.general.minimap.icons.battlefield.scale or 1

		MiniMapBattlefieldFrame:ClearAllPoints()
		MiniMapBattlefieldFrame:Point(pos, Minimap, pos, E.db.general.minimap.icons.battlefield.xOffset or 3, E.db.general.minimap.icons.battlefield.yOffset or 0)
		MiniMapBattlefieldFrame:SetScale(scale)

		MiniMapBattlefieldIcon:SetTexCoord(unpack(E.TexCoords))
	end

	if MiniMapInstanceDifficulty and GuildInstanceDifficulty then
		local pos = E.db.general.minimap.icons.difficulty.position or "TOPLEFT"
		local scale = E.db.general.minimap.icons.difficulty.scale or 1
		local x = E.db.general.minimap.icons.difficulty.xOffset or 0
		local y = E.db.general.minimap.icons.difficulty.yOffset or 0

		MiniMapInstanceDifficulty:ClearAllPoints()
		MiniMapInstanceDifficulty:Point(pos, Minimap, pos, x, y)
		MiniMapInstanceDifficulty:SetScale(scale)

		GuildInstanceDifficulty:ClearAllPoints()
		GuildInstanceDifficulty:Point(pos, Minimap, pos, x, y)
		GuildInstanceDifficulty:SetScale(scale)
	end

	if HelpOpenTicketButton then
		local pos = E.db.general.minimap.icons.ticket.position or "TOPRIGHT"
		local scale = E.db.general.minimap.icons.ticket.scale or 1
		local x = E.db.general.minimap.icons.ticket.xOffset or 0
		local y = E.db.general.minimap.icons.ticket.yOffset or 0

		HelpOpenTicketButton:ClearAllPoints()
		HelpOpenTicketButton:Point(pos, Minimap, pos, x, y)
		HelpOpenTicketButton:SetScale(scale)

		HelpOpenTicketButton:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
		HelpOpenTicketButton:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
	end

	if MiniMapWorldMapButton then
		if E.db.general.minimap.icons.worldMap.hide then
			MiniMapWorldMapButton:Hide()
		else
			local pos = E.db.general.minimap.icons.worldMap.position or "TOPRIGHT"
			local scale = E.db.general.minimap.icons.worldMap.scale or 1
			local x = E.db.general.minimap.icons.worldMap.xOffset or 0
			local y = E.db.general.minimap.icons.worldMap.yOffset or 0

			MiniMapWorldMapButton:ClearAllPoints()
			MiniMapWorldMapButton:Point(pos, Minimap, pos, x, y)
			MiniMapWorldMapButton:SetScale(scale)
			MiniMapWorldMapButton:Show()

			MiniMapWorldMapButton:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
			MiniMapWorldMapButton:GetPushedTexture():SetTexCoord(unpack(E.TexCoords))
		end
	end
end

local function MinimapPostDrag()
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetAllPoints(Minimap)
	MinimapBackdrop:ClearAllPoints()
	MinimapBackdrop:SetAllPoints(Minimap)
end

function M:ADDON_LOADED(_, addon)
	if addon == "Blizzard_TimeManager" then
		TimeManagerClockButton:Kill()
	elseif addon == "Blizzard_FeedbackUI" then
		FeedbackUIButton:Kill()
	end
end

function M:Initialize()
	menuFrame:SetTemplate("Transparent", true)

	M:UpdateSettings()

	if not E.private.general.minimap.enable then
		Minimap:SetMaskTexture([[Textures\MinimapMask]])
		return
	end

	--Support for other mods
	function GetMinimapShape()
		return "SQUARE"
	end

	Minimap:Size(E.db.general.minimap.size, E.db.general.minimap.size)

	local mmholder = CreateFrame("Frame", "MMHolder", Minimap)
	mmholder:Point("TOPRIGHT", E.UIParent, "TOPRIGHT", -4, -4)
	mmholder:Size(Minimap:GetSize())

	Minimap:ClearAllPoints()
	if E.db.general.reminder.position == "LEFT" then
		Minimap:Point("TOPRIGHT", mmholder, "TOPRIGHT", -E.Border, -E.Border)
	else
		Minimap:Point("TOPLEFT", mmholder, "TOPLEFT", E.Border, -E.Border)
	end

	Minimap:SetMaskTexture([[Interface\ChatFrame\ChatFrameBackground]])
	Minimap:CreateBackdrop()
	Minimap:SetFrameLevel(Minimap:GetFrameLevel() + 2)

	Minimap:HookScript("OnEnter", function(mm) if E.db.general.minimap.locationText == "MOUSEOVER" then mm.location:Show() end end)
	Minimap:HookScript("OnLeave", function(mm) if E.db.general.minimap.locationText == "MOUSEOVER" then mm.location:Hide() end end)

	Minimap.location = Minimap:CreateFontString(nil, "OVERLAY")
	Minimap.location:FontTemplate(nil, nil, "OUTLINE")
	Minimap.location:Point("TOP", Minimap, "TOP", 0, -2)
	Minimap.location:SetJustifyH("CENTER")
	Minimap.location:SetJustifyV("MIDDLE")
	if E.db.general.minimap.locationText ~= "SHOW" then
		Minimap.location:Hide()
	end

	local frames = {
		MinimapBorder,
		MinimapBorderTop,
		MinimapZoomIn,
		MinimapZoomOut,
		MinimapNorthTag,
		MinimapZoneTextButton,
		MiniMapTracking,
		MiniMapMailBorder,
		MiniMapVoiceChatFrame,
		MiniMapLFGFrameBorder,
		MiniMapBattlefieldBorder
	}

	for _, frame in pairs(frames) do
		frame:Kill()
	end

	MiniMapLFGFrame:SetClampedToScreen(true)

	MiniMapInstanceDifficulty:SetParent(Minimap)
	GuildInstanceDifficulty:SetParent(Minimap)
	HelpOpenTicketButton:SetParent(Minimap)

	for _, frame in pairs({MiniMapBattlefieldFrame, HelpOpenTicketButton, MiniMapWorldMapButton}) do
		frame:StripTextures()
		frame:CreateBackdrop()
		frame:SetFrameStrata("MEDIUM")
		frame:Size(28)
		frame:StyleButton(nil, true)
		frame.hover:SetAllPoints()

		local normal, pushed = frame:GetNormalTexture(), frame:GetPushedTexture()
		if frame == MiniMapWorldMapButton then
			normal:SetTexture([[Interface\Icons\INV_Misc_Map02]])
			normal:SetAllPoints()

			pushed:SetTexture([[Interface\Icons\INV_Misc_Map02]])
			pushed:SetAllPoints()
		elseif frame == HelpOpenTicketButton then
			normal:SetTexture([[Interface\ChatFrame\UI-ChatIcon-Blizz]])
			normal:Point("TOPLEFT", 2, -6)
			normal:Point("BOTTOMRIGHT", -2, 6)

			pushed:SetTexture([[Interface\ChatFrame\UI-ChatIcon-Blizz]])
			pushed:Point("TOPLEFT", 2, -6)
			pushed:Point("BOTTOMRIGHT", -2, 6)
		end
	end

	MiniMapBattlefieldIcon:SetTexture("Interface\\Icons\\PVPCurrency-Honor-"..E.myfaction)
	MiniMapBattlefieldIcon:SetInside(MiniMapBattlefieldFrame.backdrop)

	--Hide the BlopRing on Minimap
	Minimap:SetArchBlobRingAlpha(0)
	Minimap:SetArchBlobRingScalar(0)

	Minimap:SetQuestBlobRingAlpha(0)
	Minimap:SetQuestBlobRingScalar(0)

	if TimeManagerClockButton then
		TimeManagerClockButton:Kill()
	end

	if FeedbackUIButton then
		FeedbackUIButton:Kill()
	end

	E:CreateMover(MMHolder, "MinimapMover", L["Minimap"], nil, nil, MinimapPostDrag, nil, nil, "maps,minimap")

	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", M.Minimap_OnMouseWheel)
	Minimap:SetScript("OnMouseUp", M.Minimap_OnMouseUp)

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "Update_ZoneText")
	M:RegisterEvent("ZONE_CHANGED", "Update_ZoneText")
	M:RegisterEvent("ZONE_CHANGED_INDOORS", "Update_ZoneText")
	M:RegisterEvent("PLAYER_ENTERING_WORLD", "Update_ZoneText")
	M:RegisterEvent("ADDON_LOADED")

	hooksecurefunc(Minimap, "SetZoom", SetupZoomReset)

	M:CreateFarmModeMap()

	M.Initialized = true
end

local function InitializeCallback()
	M:Initialize()
end

E:RegisterInitialModule(M:GetName(), InitializeCallback)