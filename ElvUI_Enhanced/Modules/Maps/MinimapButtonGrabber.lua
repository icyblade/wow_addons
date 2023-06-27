local E, L, V, P, G = unpack(ElvUI)
local MBG = E:NewModule("Enhanced_MinimapButtonGrabber", "AceHook-3.0", "AceTimer-3.0")

local pairs, ipairs = pairs, ipairs
local select = select
local unpack = unpack
local ceil = math.ceil
local find, len, sub = string.find, string.len, string.sub
local tinsert = table.insert

local UIFrameFadeIn = UIFrameFadeIn
local UIFrameFadeOut = UIFrameFadeOut

local ignoreButtons = {
	["ElvConfigToggle"] = true,

	["BattlefieldMinimap"] = true,
	["ButtonCollectFrame"] = true,
	["GameTimeFrame"] = true,
	["HelpOpenTicketButton"] = true,
	["MiniMapBattlefieldFrame"] = true,
	["MiniMapLFGFrame"] = true,
	["MiniMapMailFrame"] = true,
	["MiniMapPing"] = true,
	["MiniMapRecordingButton"] = true,
	["MiniMapTracking"] = true,
	["MiniMapTrackingButton"] = true,
	["MiniMapVoiceChatFrame"] = true,
	["MiniMapWorldMapButton"] = true,
	["Minimap"] = true,
	["MinimapBackdrop"] = true,
	["MinimapToggleButton"] = true,
	["MinimapZoneTextButton"] = true,
	["MinimapZoomIn"] = true,
	["MinimapZoomOut"] = true,
	["TimeManagerClockButton"] = true,
}

local genericIgnores = {
	"Archy",
	"GuildInstance",
	"GatherMatePin",
	"GatherNote",
	"GuildInstance",
	"GuildMap3Mini",
	"HandyNotesPin",
	"LibRockConfig-1.0_MinimapButton",
	"NauticusMiniIcon",
	"WestPointer",
	"poiMinimap",
	"Spy_MapNoteList_mini",
}

local partialIgnores = {
	"Node",
	"Note",
	"Pin",
}

local whiteList = {
	"LibDBIcon",
}

local buttonFunctions = {
	"SetParent",
	"SetFrameStrata",
	"SetFrameLevel",
	"ClearAllPoints",
	"SetPoint",
	"SetScale",
	"SetSize",
	"SetWidth",
	"SetHeight"
}

local function OnEnter()
	UIFrameFadeIn(MBG.frame, 0.1, MBG.frame:GetAlpha(), MBG.maxAlpha)
end

local function OnLeave()
	UIFrameFadeOut(MBG.frame, 0.1, MBG.frame:GetAlpha(), 0)
end

function MBG:LockButton(button)
	for _, func in ipairs(buttonFunctions) do
		button[func] = E.noop
	end
end

function MBG:UnlockButton(button)
	for _, func in ipairs(buttonFunctions) do
		button[func] = nil
	end
end

function MBG:CheckVisibility()
	local updateLayout

	for _, button in ipairs(self.skinnedButtons) do
		if button:IsVisible() and button.__hidden then
			button.__hidden = false
			updateLayout = true
		elseif not button:IsVisible() and not button.__hidden then
			button.__hidden = true
			updateLayout = true
		end
	end

	return updateLayout
end

function MBG:GetVisibleList()
	local t = {}

	for _, button in ipairs(self.skinnedButtons) do
		if button:IsVisible() then
			tinsert(t, button)
		end
	end

	return t
end

function MBG:GrabMinimapButtons()
	for _, frame in ipairs(self.minimapFrames) do
		for i = 1, frame:GetNumChildren() do
			local object = select(i, frame:GetChildren())

			if object and object:IsObjectType("Button") then
				self:SkinMinimapButton(object)
			end
		end
	end

	if AtlasButtonFrame then self:SkinMinimapButton(AtlasButton) end
	if FishingBuddyMinimapFrame then self:SkinMinimapButton(FishingBuddyMinimapButton) end
	if HealBot_MMButton then self:SkinMinimapButton(HealBot_MMButton) end

	if self.needUpdate or self:CheckVisibility() then
		self:UpdateLayout()
	end
end

function MBG:SkinMinimapButton(button)
	if not button or button.isSkinned then return end

	local name = button:GetName()
	if not name then return end

	if button:IsObjectType("Button") then
		local validIcon

		for i = 1, #whiteList do
			if sub(name, 1, len(whiteList[i])) == whiteList[i] then
				validIcon = true
				break
			end
		end

		if not validIcon then
			if ignoreButtons[name] then return end

			for i = 1, #genericIgnores do
				if sub(name, 1, len(genericIgnores[i])) == genericIgnores[i] then return end
			end

			for i = 1, #partialIgnores do
				if find(name, partialIgnores[i]) then return end
			end
		end

		button:SetPushedTexture(nil)
		button:SetHighlightTexture(nil)
		button:SetDisabledTexture(nil)
	end

	for i = 1, button:GetNumRegions() do
		local region = select(i, button:GetRegions())

		if region:GetObjectType() == "Texture" then
			local texture = region:GetTexture()

			if texture and (find(texture, "Border") or find(texture, "Background") or find(texture, "AlphaMask")) then
				region:SetTexture(nil)
			else
				if name == "BagSync_MinimapButton" then
					region:SetTexture("Interface\\AddOns\\BagSync\\media\\icon")
				elseif name == "DBMMinimapButton" then
					region:SetTexture("Interface\\Icons\\INV_Helmet_87")
				elseif name == "OutfitterMinimapButton" then
					if region:GetTexture() == "Interface\\Addons\\Outfitter\\Textures\\MinimapButton" then
						region:SetTexture(nil)
					end
				elseif name == "SmartBuff_MiniMapButton" then
					region:SetTexture("Interface\\Icons\\Spell_Nature_Purge")
				elseif name == "VendomaticButtonFrame" then
					region:SetTexture("Interface\\Icons\\INV_Misc_Rabbit_2")
				end

				region:ClearAllPoints()
				region:SetInside()
				region.SetPoint = E.noop

				region:SetTexCoord(unpack(E.TexCoords))
				region.SetTexCoord = E.noop
				region:SetDrawLayer("ARTWORK")
			end
		end
	end

	button:SetParent(self.frame)
	button:SetFrameLevel(self.frame:GetFrameLevel() + 5)
	button:SetTemplate()
	button:StyleButton()

	self:LockButton(button)

	button:SetScript("OnDragStart", nil)
	button:SetScript("OnDragStop", nil)

	if E.db.enhanced.minimap.buttonGrabber.mouseover then
		button:HookScript("OnEnter", OnEnter)
		button:HookScript("OnLeave", OnLeave)
	end

	button.__hidden = button:IsVisible() and true or false
	button.isSkinned = true
	tinsert(self.skinnedButtons, button)

	self.needUpdate = true
end

function MBG:UpdateLayout()
	if #self.skinnedButtons == 0 then return end

	local db = E.db.enhanced.minimap.buttonGrabber
	local spacing = (db.backdrop and (E.Border + db.backdropSpacing) or E.Spacing)

	local visibleButtons = self:GetVisibleList()

	if #visibleButtons == 0 then
		self.frame:Size(db.buttonSize + (spacing * 2))
		self.frame.backdrop:Hide()
		return
	end

	local numButtons = #visibleButtons
	local buttonsPerRow = db.buttonsPerRow
	local numColumns = ceil(numButtons / buttonsPerRow)

	if buttonsPerRow > numButtons then
		buttonsPerRow = numButtons
	end

	local barWidth = (db.buttonSize * buttonsPerRow) + (db.buttonSpacing * (buttonsPerRow - 1)) + spacing * 2
	local barHeight = (db.buttonSize * numColumns) + (db.buttonSpacing * (numColumns - 1)) + spacing * 2
	self.frame:Size(barWidth, barHeight)
	self.frame.mover:Size(barWidth, barHeight)

	if db.backdrop then
		self.frame.backdrop:Show()
	else
		self.frame.backdrop:Hide()
	end

	if db.transparentBackdrop then
		self.frame.backdrop:SetTemplate("Transparent")
	else
		self.frame.backdrop:SetTemplate("Default")
	end

	local verticalGrowth = (db.growFrom == "TOPLEFT" or db.growFrom == "TOPRIGHT") and "DOWN" or "UP"
	local horizontalGrowth = (db.growFrom == "TOPLEFT" or db.growFrom == "BOTTOMLEFT") and "RIGHT" or "LEFT"

	for i, button in ipairs(visibleButtons) do
		self:UnlockButton(button)

		button:Size(db.buttonSize)
		button:ClearAllPoints()

		if i == 1 then
			local x, y
			if db.growFrom == "TOPLEFT" then
				x, y = spacing, -spacing
			elseif db.growFrom == "TOPRIGHT" then
				x, y = -spacing, -spacing
			elseif db.growFrom == "BOTTOMLEFT" then
				x, y = spacing, spacing
			else
				x, y = -spacing, spacing
			end

			button:Point(db.growFrom, self.frame, db.growFrom, x, y)
		elseif (i - 1) % buttonsPerRow == 0 then
			if verticalGrowth == "DOWN" then
				button:Point("TOP", visibleButtons[i - buttonsPerRow], "BOTTOM", 0, -db.buttonSpacing)
			else
				button:Point("BOTTOM", visibleButtons[i - buttonsPerRow], "TOP", 0, db.buttonSpacing)
			end
		elseif horizontalGrowth == "RIGHT" then
			button:Point("LEFT", visibleButtons[i - 1], "RIGHT", db.buttonSpacing, 0)
		elseif horizontalGrowth == "LEFT" then
			button:Point("RIGHT", visibleButtons[i - 1], "LEFT", -db.buttonSpacing, 0)
		end
		self:LockButton(button)
	end

	self.needUpdate = false
end

function MBG:UpdatePosition()
	local db = E.db.enhanced.minimap.buttonGrabber.insideMinimap

	if db.enable then
		self.frame:ClearAllPoints()
		self.frame:Point(db.position, Minimap, db.position, db.xOffset, db.yOffset)

		E:DisableMover(self.frame.mover:GetName())
	else
		self.frame:ClearAllPoints()
		self.frame:SetAllPoints(self.frame.mover)

		E:EnableMover(self.frame.mover:GetName())
	end
end

function MBG:UpdateAlpha()
	self.maxAlpha = E.db.enhanced.minimap.buttonGrabber.alpha

	if not E.db.enhanced.minimap.buttonGrabber.mouseover then
		self.frame:SetAlpha(self.maxAlpha)
	end
end

function MBG:ToggleMouseover()
	local mouseover = E.db.enhanced.minimap.buttonGrabber.mouseover
	local enter = mouseover and OnEnter or nil
	local leave = mouseover and OnLeave or nil

	self.frame:SetAlpha(mouseover and 0 or E.db.enhanced.minimap.buttonGrabber.alpha)
	self.frame:SetScript("OnEnter", enter)
	self.frame:SetScript("OnLeave", leave)

	if #self.skinnedButtons > 0 then
		for _, button in ipairs(self.skinnedButtons) do
			button:SetScript("OnEnter", enter)
			button:SetScript("OnLeave", leave)
		end
	end
end

local addonFixes = {
	["Atlas"] = function()
		function AtlasButton_Toggle()
			if AtlasButton:IsVisible() then
				AtlasButton:Hide()
				AtlasOptions.AtlasButtonShown = false
			else
				AtlasButton:Show()
				AtlasOptions.AtlasButtonShown = true
			end

			AtlasOptions_Init()
		end
	end,
	["DBM-Core"] = function()
		local button = DBMMinimapButton
		if not button then return end

		if button:GetScript("OnMouseDown") then
			button:SetScript("OnMouseDown", nil)
			button:SetScript("OnMouseUp", nil)
		end
	end,
	["Enchantrix"] = function()
		if not Enchantrix or EnxMiniMapIcon then return end

		local settings = Enchantrix.Settings
		local oldButton = Enchantrix.MiniIcon

		local newButton = CreateFrame("Button", "EnxMiniMapIcon", Minimap)
		newButton:Size(20)
		newButton:SetToplevel(true)
		newButton:SetFrameStrata("LOW")
		newButton:Point("RIGHT", Minimap, "LEFT", 0,0)
		newButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")

		newButton.icon = oldButton.icon
		newButton.icon:SetTexCoord(0.2, 0.84, 0.13, 0.87)
		newButton.icon:SetParent(newButton)
		newButton.icon:SetPoint("TOPLEFT", newButton, "TOPLEFT", 0, 0)

		newButton.mask = oldButton.mask
		newButton.mask:SetParent(newButton)
		newButton.mask:SetPoint("TOPLEFT", newButton, "TOPLEFT", -8, 8)

		newButton:SetScript("OnClick", oldButton:GetScript("OnClick"))

		oldButton:SetMovable(false)
		oldButton:SetParent(UIParent)
		oldButton:Point("TOPRIGHT", UIParent)
		oldButton:Hide()

		oldButton:SetScript("OnMouseDown", nil)
		oldButton:SetScript("OnMouseUp", nil)
		oldButton:SetScript("OnDragStart", nil)
		oldButton:SetScript("OnDragStop", nil)
		oldButton:SetScript("OnClick", nil)
		oldButton:SetScript("OnUpdate", nil)

		Enchantrix.MiniIcon = newButton

		function Enchantrix.MiniIcon.Reposition()
			if settings.GetSetting("miniicon.enable") then
				newButton:Show()
			else
				newButton:Hide()
			end
		end
	end
}

function MBG:Initialize()
	if not E.private.enhanced.minimapButtonGrabber then return end
	local db = E.db.enhanced.minimap.buttonGrabber
	local spacing = (db.backdrop and (E.Border + db.backdropSpacing) or E.Spacing)

	self.skinnedButtons = {}
	self.minimapFrames = {Minimap, MinimapBackdrop}

	self.frame = CreateFrame("Frame", "ElvUI_MinimapButtonGrabber", UIParent)
	self.frame:Size(db.buttonSize + (spacing * 2))
	self.frame:Point("TOPRIGHT", MMHolder, "BOTTOMRIGHT", 0, 1)
	self.frame:SetFrameStrata("HIGH")
	self.frame:SetClampedToScreen(true)
	self.frame:CreateBackdrop()

	self.frame.backdrop:SetPoint("TOPLEFT", self.frame, "TOPLEFT", E.Spacing, -E.Spacing)
	self.frame.backdrop:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", -E.Spacing, E.Spacing)
	self.frame.backdrop:Hide()

	E:CreateMover(self.frame, "MinimapButtonGrabberMover", L["Minimap Button Grabber"], nil, nil, nil, "ALL,GENERAL")

	if self.frame.mover:GetScript("OnSizeChanged") then
		self.frame.mover:SetScript("OnSizeChanged", nil)
	end

	self:ToggleMouseover()
	self:UpdateAlpha()
	self:UpdatePosition()

	self:GrabMinimapButtons()

	self:ScheduleRepeatingTimer("GrabMinimapButtons", 5)

	local AddonsCompat = E:GetModule("Enhanced_AddonsCompat")
	for addon, func in pairs(addonFixes) do
		AddonsCompat:AddAddon(addon, func)
	end

	self.initialized = true
end

local function InitializeCallback()
	MBG:Initialize()
end

E:RegisterModule(MBG:GetName(), InitializeCallback)