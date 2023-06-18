local E, L, V, P, G = unpack(ElvUI)
local RM = E:NewModule("RaidMarkerBar", "AceEvent-3.0")
local S = E:GetModule("Skins")

local ipairs = ipairs
local format = string.format

local GameTooltip = GameTooltip
local UnregisterStateDriver = UnregisterStateDriver
local RegisterStateDriver = RegisterStateDriver

RM.VisibilityStates = {
	["DEFAULT"] = "[noexists, nogroup] hide;show",
	["INPARTY"] = "[group] show;hide",
	["ALWAYS"] = "[noexists, nogroup] show;show"
}

local layouts = {
	[1] = {RT = 1, WM = 5},	-- Star
	[2] = {RT = 2},			-- Circle
	[3] = {RT = 3, WM = 3},	-- Diamond
	[4] = {RT = 4, WM = 2},	-- Triangle
	[5] = {RT = 5},			-- Moon
	[6] = {RT = 6, WM = 1},	-- Square
	[7] = {RT = 7, WM = 4},	-- Cross
	[8] = {RT = 8},			-- Skull
	[9] = {RT = 0, WM = 0},	-- Clear target/worldmarker
}

function RM:Make(name, command, description)
	_G["BINDING_NAME_CLICK "..name..":LeftButton"] = description
	local btn = CreateFrame("Button", name, nil, "SecureActionButtonTemplate")
	btn:SetAttribute("type", "macro")
	btn:SetAttribute("macrotext", command)
	btn:RegisterForClicks("AnyDown")
end

function RM:CreateButtons()
	for i, layout in ipairs(layouts) do
		local button = CreateFrame("Button", format("RaidMarkerBarButton%d", i), self.frame, "SecureActionButtonTemplate")
		button:SetTemplate("Default", true)
		button:StyleButton()
		button:Size(self.db.buttonSize)

		local image = button:CreateTexture(nil, "ARTWORK")
		image:SetInside()
		image:SetTexture(i == 9 and "Interface\\BUTTONS\\UI-GroupLoot-Pass-Up" or format("Interface\\TargetingFrame\\UI-RaidTargetingIcon_%d", i))

		local target, worldmarker = layout.RT, layout.WM

		if target then
			button:SetAttribute("type1", "macro")
			button:SetAttribute("macrotext1", format("/tm %d", i == 9 and 0 or i))
		end

		button:RegisterForClicks("AnyDown")
		self.frame.buttons[i] = button
	end
end

function RM:UpdateWorldMarkersAndTooltips()
	for i = 1, 9 do
		local target, worldmarker = layouts[i].RT, layouts[i].WM
		local button = self.frame.buttons[i]

		if target and not worldmarker then
			button:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(i == 9 and L["Click to clear the mark."] or L["Click to mark the target."], 1, 1, 1)
				GameTooltip:Show()
			end)
		else
			local modifier = self.db.modifier or "shift-"
			button:SetAttribute(format("%stype1", modifier), "macro")
			button.modifier = modifier
			button:SetAttribute(format("%smacrotext1", modifier), worldmarker == 0 and "/cwm all" or format("/cwm %d\n/wm %d", worldmarker, worldmarker))

			button:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(L["Raid Markers"])
				GameTooltip:AddLine(i == 9 and format("%s\n%s", L["Click to clear the mark."], format(L["%sClick to remove all worldmarkers."], button.modifier:upper()))
					or format("%s\n%s", L["Click to mark the target."], format(L["%sClick to place a worldmarker."], button.modifier:upper())), 1, 1, 1)
				GameTooltip:Show()
			end)
		end

		button:SetScript("OnLeave", function(self)
			GameTooltip:Hide() 
		end)
	end
end

function RM:UpdateBar(update)
	if self.db.orientation == "VERTICAL" then
		self.frame:SetWidth(self.db.buttonSize + 4)
		self.frame:SetHeight(((self.db.buttonSize * 9) + (self.db.spacing * 8)) + 4)
	else
		self.frame:SetWidth(((self.db.buttonSize * 9) + (self.db.spacing * 8)) + 4)
		self.frame:SetHeight(self.db.buttonSize + 4)
	end

	local head, tail
	for i = 9, 1, -1 do
		local button = self.frame.buttons[i]
		local prev = self.frame.buttons[i + 1]
		button:ClearAllPoints()

		button:Size(self.db.buttonSize)

		if self.db.orientation == "VERTICAL" then
			head = self.db.reverse and "BOTTOM" or "TOP"
			tail = self.db.reverse and "TOP" or "BOTTOM"
			if i == 9 then
				button:Point(head, 0, (self.db.reverse and 2 or -2))
			else
				button:Point(head, prev, tail, 0, self.db.spacing*(self.db.reverse and 1 or -1))
			end
		else
			head = self.db.reverse and "RIGHT" or "LEFT"
			tail = self.db.reverse and "LEFT" or "RIGHT"
			if i == 9 then
				button:Point(head, (self.db.reverse and -2 or 2), 0)
			else
				button:Point(head, prev, tail, self.db.spacing*(self.db.reverse and -1 or 1), 0)
			end
		end
	end

	if self.db.enable then self.frame:Show() else self.frame:Hide() end
end

function RM:Visibility()
	if self.db.enable then
		RegisterStateDriver(self.frame, "visibility", self.db.visibility == "CUSTOM" and self.db.customVisibility or RM.VisibilityStates[self.db.visibility])
		E:EnableMover(self.frame.mover:GetName())
	else
		UnregisterStateDriver(self.frame, "visibility")
		self.frame:Hide()
		E:DisableMover(self.frame.mover:GetName())
	end
end

function RM:Backdrop()
	if self.db.backdrop then
		self.frame.backdrop:Show()
	else
		self.frame.backdrop:Hide()
	end

	if self.db.transparentBackdrop then
		self.frame.backdrop:SetTemplate("Transparent")
	else
		self.frame.backdrop:SetTemplate("Default")
	end
end

function RM:ButtonBackdrop()
	for i = 1, 9 do
		local button = self.frame.buttons[i]
		if self.db.transparentButtons then
			button:SetTemplate("Transparent")
		else
			button:SetTemplate("Default", true)
		end
	end
end

function RM:Initialize()
	self.db = E.db.enhanced.raidmarkerbar

	self.frame = CreateFrame("Frame", "RaidMarkerBar", E.UIParent, "SecureHandlerStateTemplate")
	self.frame:SetResizable(false)
	self.frame:SetClampedToScreen(true)
	self.frame:SetFrameStrata("LOW")
	self.frame:CreateBackdrop()
	self.frame:ClearAllPoints()
	self.frame:Point("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", -1, 200)
	self.frame.buttons = {}

	self.frame.backdrop:SetAllPoints()

	E:CreateMover(self.frame, "RaidMarkerBarAnchor", L["Raid Marker Bar"])

	self:CreateButtons()

	function RM:ForUpdateAll()
		self:Visibility()
		self:Backdrop()
		self:ButtonBackdrop()
		self:UpdateBar()
		self:UpdateWorldMarkersAndTooltips()
	end

	self:ForUpdateAll()
end

local function InitializeCallback()
	RM:Initialize()
end

E:RegisterModule(RM:GetName(), InitializeCallback)