---------------
-- Totem Icon Widget
---------------

local path = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\TotemIconWidget\\"

function tL(number)
	local name = GetSpellInfo(number)
	return name
end

TPtotemList = {
	-- Air Totems
	[tL(8177)] = "A1", -- Grounding Totem
	[tL(8512)] = "A4", -- Windfury Totem
	[tL(3738)] = "A5", -- Wrath of Air Totem
	[tL(98008)] = "A6", -- Spirit Link Totem
	-- Earth Totems
	[tL(2062)] = "E1", -- Earth Elemental Totem
	[tL(2484)] = "E2", -- Earthbind Totem
	[tL(5730)] = "E3", -- Stoneclaw Totem
	[tL(8071)] = "E4", -- Stoneskin Totem
	[tL(8075)] = "E5", -- Strength of Earth Totem
	[tL(8143)] = "E6", -- Tremor Totem
	-- Fire Totems
	[tL(2894)] = "F1", -- Fire Elemental Totem
	[tL(8227)] = "F2", -- Flametongue Totem
	[tL(8190)] = "F4", -- Magma Totem
	[tL(3599)] = "F5", -- Searing Totem
	-- Water Totems
	[tL(8184)] = "W2", -- Elemental Resistance Totem
	[tL(5394)] = "W3", -- Healing Stream Totem
	[tL(5675)] = "W4", -- Mana Spring Totem
	[tL(16190)] = "W5", -- Mana Tide Totem
	[tL(87718)] = "W6" -- Totem of Tranquil Mind
}

local function UpdateTotemIconWidget(self, unit)
	local totem = TPtotemList[unit.name]
	local db = TidyPlatesThreat.db.profile
	if totem and db.totemWidget.ON and db.totemSettings[totem][3] then
		self.Icon:SetTexture(path..db.totemSettings[totem][7].."\\"..TPtotemList[unit.name]) 
		self:Show()
	else self:Hide() end
end

local function CreateTotemIconWidget(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetWidth(64)
	frame:SetHeight(64)
	frame.Icon = frame:CreateTexture(nil, "OVERLAY")
	frame.Icon:SetPoint("CENTER",frame)
	frame.Icon:SetAllPoints(frame)
	frame:Hide()
	frame.Update = UpdateTotemIconWidget
	return frame
end

ThreatPlatesWidgets.CreateTotemIconWidget = CreateTotemIconWidget