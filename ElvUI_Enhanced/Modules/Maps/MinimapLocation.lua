local E, L, V, P, G = unpack(ElvUI)
local ML = E:NewModule("Enhanced_MinimapLocation", "AceHook-3.0")
local M = E:GetModule("Minimap")

local utf8sub = string.utf8sub

local GetMinimapZoneText = GetMinimapZoneText
local GetPlayerMapPosition = GetPlayerMapPosition
local InCombatLockdown = InCombatLockdown
local UIFrameFade = UIFrameFade

local init = false
local cluster, panel, location, xMap, yMap

local digits = {
	[0] = {.5, "%.0f"},
	[1] = {.2, "%.1f"},
	[2] = {.03, "%.2f"}
}

local function UpdateLocation(self, elapsed)
	location.elapsed = (location.elapsed or 0) + elapsed
	if location.elapsed < digits[E.db.enhanced.minimap.locationdigits][1] then return end

	xMap.pos, yMap.pos = GetPlayerMapPosition("player")
	xMap.text:SetFormattedText(digits[E.db.enhanced.minimap.locationdigits][2], xMap.pos * 100)
	yMap.text:SetFormattedText(digits[E.db.enhanced.minimap.locationdigits][2], yMap.pos * 100)

	location.elapsed = 0
end

local function CreateEnhancedMaplocation()
	cluster = MinimapCluster

	panel = CreateFrame("Frame", "EnhancedLocationPanel", MinimapCluster)
	panel:SetFrameStrata("BACKGROUND")
	panel:Point("CENTER", E.UIParent, "CENTER", 0, 0)
	panel:Size(206, 22)

	xMap = CreateFrame("Frame", "MapCoordinatesX", panel)
	xMap:SetTemplate("Transparent")
	xMap:Point("LEFT", panel, "LEFT", 0, 0)
	xMap:Size(40, 22)

	xMap.text = xMap:CreateFontString(nil, "OVERLAY")
	xMap.text:FontTemplate()
	xMap.text:SetAllPoints(xMap)

	yMap = CreateFrame("Frame", "MapCoordinatesY", panel)
	yMap:SetTemplate("Transparent")
	yMap:Point("RIGHT", panel, "RIGHT", 0, 0)
	yMap:Size(40, 22)

	yMap.text = yMap:CreateFontString(nil, "OVERLAY")
	yMap.text:FontTemplate()
	yMap.text:SetAllPoints(yMap)

	location = CreateFrame("Frame", "EnhancedLocationText", panel)
	location:SetTemplate("Transparent")
	location:Size(40, 22)
	location:Point("LEFT", xMap, "RIGHT", E.PixelMode and -1 or 1, 0)
	location:Point("RIGHT", yMap, "LEFT", E.PixelMode and 1 or -1, 0)

	location.text = location:CreateFontString(nil, "OVERLAY")
	location.text:FontTemplate()
	location.text:SetAllPoints(location)
end

local function FadeFrame(frame, direction, startAlpha, endAlpha, time, func)
	UIFrameFade(frame, {
		mode = direction,
		finishedFunc = func,
		startAlpha = startAlpha,
		endAlpha = endAlpha,
		timeToFade = time
	})
end

local function FadeInMinimap()
	if not InCombatLockdown() then
		FadeFrame(cluster, "IN", 0, 1, 0.5, function()
			if not InCombatLockdown() then
				cluster:Show()
			end
		end)
	end
end

local function ShowMinimap()
	if E.db.enhanced.minimap.fadeindelay == 0 then
		FadeInMinimap()
	else
		E:Delay(E.db.enhanced.minimap.fadeindelay, FadeInMinimap)
	end
end

local function HideMinimap()
	cluster:Hide()
end

local function Update_ZoneText()
	if E.db.enhanced.minimap.showlocationdigits then
		xMap.text:FontTemplate(E.LSM:Fetch("font", E.db.general.minimap.locationFont), E.db.general.minimap.locationFontSize, E.db.general.minimap.locationFontOutline)
		yMap.text:FontTemplate(E.LSM:Fetch("font", E.db.general.minimap.locationFont), E.db.general.minimap.locationFontSize, E.db.general.minimap.locationFontOutline)
	end

	location.text:FontTemplate(E.LSM:Fetch("font", E.db.general.minimap.locationFont), E.db.general.minimap.locationFontSize, E.db.general.minimap.locationFontOutline)
	location.text:SetTextColor(M:GetLocTextColor())
	location.text:SetText(utf8sub(GetMinimapZoneText(), 1, 25))
end

local function UpdateSettings()
	if not init then
		init = true
		CreateEnhancedMaplocation()
	end

	if E.db.enhanced.minimap.hideincombat then
		M:RegisterEvent("PLAYER_REGEN_DISABLED", HideMinimap)
		M:RegisterEvent("PLAYER_REGEN_ENABLED", ShowMinimap)
	else
		M:UnregisterEvent("PLAYER_REGEN_DISABLED")
		M:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end

	local holder = MMHolder
	panel:Point("BOTTOMLEFT", holder, "TOPLEFT", 0, -(E.PixelMode and 1 or -1))
	panel:Size(E:Scale(holder:GetWidth()) + (E.PixelMode and 1 or -1), 22)

	local point, relativeTo, relativePoint = holder:GetPoint()
	if E.db.general.minimap.locationText == "ABOVE" then
		holder:Point(point, relativeTo, relativePoint, 0, -21)
		holder:Height(holder:GetHeight() + 22)

		if E.db.enhanced.minimap.showlocationdigits then
			panel:SetScript("OnUpdate", UpdateLocation)
			location:ClearAllPoints()
			location:Point("LEFT", xMap, "RIGHT", E.PixelMode and -1 or 1, 0)
			location:Point("RIGHT", yMap, "LEFT", E.PixelMode and 1 or -1, 0)
			location:Size(40, 22)
			xMap:Show()
			yMap:Show()
		else
			panel:SetScript("OnUpdate", nil)
			location:ClearAllPoints()
			location:Point("LEFT", panel, "LEFT", 0, 0)
			location:Size(panel:GetWidth(), 22)
			xMap:Hide()
			yMap:Hide()
		end

		panel:Show()
	else
		holder:Point(point, relativeTo, relativePoint, 0, 0)
		panel:SetScript("OnUpdate", nil)
		panel:Hide()
	end

	if MinimapMover then
		MinimapMover:Size(holder:GetSize())
	end
end

function ML:UpdateSettings()
	if not E.private.general.minimap.enable then return end

	if E.db.enhanced.minimap.location then
		if not self:IsHooked(M, "Update_ZoneText") then
			self:SecureHook(M, "Update_ZoneText", Update_ZoneText)
		end
		if not self:IsHooked(M, "UpdateSettings") then
			self:SecureHook(M, "UpdateSettings", UpdateSettings)
		end

		M:UpdateSettings()
		M:Update_ZoneText()
	elseif init then
		self:UnhookAll()

		local mmholder = MMHolder
		local point, relativeTo, relativePoint = MMHolder:GetPoint()
		mmholder:Point(point, relativeTo, relativePoint, 0, 0)

		if E.db.datatexts.minimapPanels then
			mmholder:Height(Minimap:GetHeight() + (LeftMiniPanel and (LeftMiniPanel:GetHeight() + E.Border) or 24) + E.Spacing * 3)
		else
			mmholder:Height(Minimap:GetHeight() + E.Border + E.Spacing * 3)
		end

		if MinimapMover then
			MinimapMover:Size(mmholder:GetSize())
		end

		panel:Hide()
	end
end

function ML:Initialize()
	if not (E.private.general.minimap.enable and E.db.enhanced.minimap.location) then return end

	self:SecureHook(M, "Update_ZoneText", Update_ZoneText)
	self:SecureHook(M, "UpdateSettings", UpdateSettings)
end

local function InitializeCallback()
	ML:Initialize()
end

E:RegisterModule(ML:GetName(), InitializeCallback)