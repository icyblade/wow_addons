local E, L, V, P, G = unpack(select(2, ...))
local TOTEMS = E:GetModule("Totems")

local _G = _G
local unpack = unpack

local CreateFrame = CreateFrame
local GetTotemInfo = GetTotemInfo
local CooldownFrame_SetTimer = CooldownFrame_SetTimer
local MAX_TOTEMS = MAX_TOTEMS

local SLOT_BORDER_COLORS = {
	[EARTH_TOTEM_SLOT]	= {r = 0.23, g = 0.45, b = 0.13},
	[FIRE_TOTEM_SLOT]	= {r = 0.58, g = 0.23, b = 0.10},
	[WATER_TOTEM_SLOT]	= {r = 0.19, g = 0.48, b = 0.60},
	[AIR_TOTEM_SLOT]	= {r = 0.42, g = 0.18, b = 0.74}
}

function TOTEMS:Update()
	local displayedTotems = 0
	for i = 1, MAX_TOTEMS do
		local color
		local haveTotem, _, startTime, duration, icon = GetTotemInfo(i)

		if haveTotem and icon and icon ~= "" then
			self.bar[i]:Show()
			self.bar[i].iconTexture:SetTexture(icon)
			displayedTotems = displayedTotems + 1
			CooldownFrame_SetTimer(self.bar[i].cooldown, startTime, duration, 1)

			if E.myclass == "SHAMAN" then
				color = SLOT_BORDER_COLORS[self.bar[i]:GetID()]
				self.bar[i]:SetBackdropBorderColor(color.r, color.g, color.b)
				self.bar[i].ignoreBorderColors = true
			end

			for d = 1, MAX_TOTEMS do
				if _G["TotemFrameTotem"..d.."IconTexture"]:GetTexture() == icon then
					_G["TotemFrameTotem"..d]:ClearAllPoints()
					_G["TotemFrameTotem"..d]:SetParent(self.bar[i].holder)
					_G["TotemFrameTotem"..d]:SetAllPoints(self.bar[i].holder)
				end
			end
		else
			self.bar[i]:Hide()
		end
	end
end

function TOTEMS:ToggleEnable()
	if self.db.enable then
		self.bar:Show()
		self:RegisterEvent("PLAYER_TOTEM_UPDATE", "Update")
		self:RegisterEvent("PLAYER_ENTERING_WORLD", "Update")
		self:Update()
		E:EnableMover("TotemBarMover")
	else
		self.bar:Hide()
		self:UnregisterEvent("PLAYER_TOTEM_UPDATE")
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		E:DisableMover("TotemBarMover")
	end
end

function TOTEMS:PositionAndSize()
	if not self.Initialized then return end

	for i = 1, MAX_TOTEMS do
		local button = self.bar[i]
		local prevButton = self.bar[i - 1]

		button:Size(self.db.size)
		button:ClearAllPoints()

		if self.db.growthDirection == "HORIZONTAL" and self.db.sortDirection == "ASCENDING" then
			if i == 1 then
				button:Point("LEFT", self.bar, "LEFT", self.db.spacing, 0)
			elseif prevButton then
				button:Point("LEFT", prevButton, "RIGHT", self.db.spacing, 0)
			end
		elseif self.db.growthDirection == "VERTICAL" and self.db.sortDirection == "ASCENDING" then
			if i == 1 then
				button:Point("TOP", self.bar, "TOP", 0, -self.db.spacing)
			elseif prevButton then
				button:Point("TOP", prevButton, "BOTTOM", 0, -self.db.spacing)
			end
		elseif self.db.growthDirection == "HORIZONTAL" and self.db.sortDirection == "DESCENDING" then
			if i == 1 then
				button:Point("RIGHT", self.bar, "RIGHT", -self.db.spacing, 0)
			elseif prevButton then
				button:Point("RIGHT", prevButton, "LEFT", -self.db.spacing, 0)
			end
		else
			if i == 1 then
				button:Point("BOTTOM", self.bar, "BOTTOM", 0, self.db.spacing)
			elseif prevButton then
				button:Point("BOTTOM", prevButton, "TOP", 0, self.db.spacing)
			end
		end
	end

	local width, height = self.db.size * (MAX_TOTEMS) + self.db.spacing * (MAX_TOTEMS) + self.db.spacing, self.db.size + self.db.spacing * 2
	self.bar:Width(self.db.growthDirection == "HORIZONTAL" and width or height)
	self.bar:Height(self.db.growthDirection == "HORIZONTAL" and height or width)

	self:Update()
end

function TOTEMS:Initialize()
	self.db = E.db.general.totems

	local bar = CreateFrame("Frame", "ElvUI_TotemBar", E.UIParent)
	bar:Point("TOPLEFT", LeftChatPanel, "TOPRIGHT", 14, 0)
	self.bar = bar

	for i = 1, MAX_TOTEMS do
		local frame = CreateFrame("Button", "$parentTotem"..i, bar)
		frame:SetID(i)
		frame:SetTemplate()
		frame:StyleButton()
		frame:Hide()

		frame.holder = CreateFrame("Frame", nil, frame)
		frame.holder:SetAlpha(0)
		frame.holder:SetAllPoints()

		frame.iconTexture = frame:CreateTexture(nil, "ARTWORK")
		frame.iconTexture:SetTexCoord(unpack(E.TexCoords))
		frame.iconTexture:SetInside()

		frame.cooldown = CreateFrame("Cooldown", "$parentCooldown", frame, "CooldownFrameTemplate")
		frame.cooldown:SetReverse(true)
		frame.cooldown:SetInside()
		E:RegisterCooldown(frame.cooldown)

		self.bar[i] = frame
	end

	self.Initialized = true

	self:PositionAndSize()

	E:CreateMover(bar, "TotemBarMover", L["Class Totems"], nil, nil, nil, nil, nil, "general,totems")
	self:ToggleEnable()
end

local function InitializeCallback()
	TOTEMS:Initialize()
end

E:RegisterModule(TOTEMS:GetName(), InitializeCallback)