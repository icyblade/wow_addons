---------------
-- Totem Icon Widget
---------------

local path = "Interface\\Addons\\TidyPlates_ThreatPlates\\Widgets\\TotemIconWidget\\"

local AIR_TOTEM, EARTH_TOTEM, FIRE_TOTEM, WATER_TOTEM = 1, 2, 3, 4

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------	

local function IsTotem(name) if name then return (TotemIcons[name] ~= nil) end end
local function TotemSlot(name) if name then return TotemTypes[name] end end

local function UpdateTotemIconWidget(self, unit)
	local icon = TotemIcons[unit.name]
	if icon then
		self.Icon:SetTexture(icon)
		self:Show()
	else 
		self:Hide() 
	end
end

function tL(number)
	local name = GetSpellInfo(number)
	return name
end

TPtotemList = {
	
	-- Air Totem
	[tL(8177)] = 	"A1", 	-- Grounding Totem
	[tL(120668)] = 	"A2", 	-- Stormlash Totem
	[tL(108273)] = 	"A3", 	-- Windwalk Totem
	[tL(98008)] = 	"A4", 	-- Spirit Link Totem
	[tL(108269)] = 	"A5", 	-- Capacitor Totem
	-- Earth Totems
	[tL(2062)] = "E1", -- Earth Elemental Totem
	[tL(2484)] = "E2", -- Earthbind Totem
	[tL(51485)] = "E3", -- Earthgrab Totem
	[tL(108270)] = "E4", -- Stone Bulwark Totem
	[tL(8143)] = "E5", -- Tremor Totem
	-- Fire Totems
	[tL(2894)] = "F1", -- Fire Elemental Totem
	[tL(8190)] = "F2", -- Magma Totem
	[tL(3599)] = "F3", -- Searing Totem
	-- Water Totems
	[tL(5394)] = "W1", -- Healing Stream Totem
	[tL(16190)] = "W2", -- Mana Tide Totem
	[tL(108280)] = "W3", -- Healing Tide Totem
	
	--[tL(98008)] = "A4", -- Spirit Link Totem
	--[tL(98008)] = "A4", -- Spirit Link Totem
	
	--[tL(8075)] = "E6", -- Strength of Earth Totem
	--[tL(8075)] = "E7", -- Strength of Earth Totem
	--[tL(8075)] = "E8", -- Strength of Earth Totem
	
	--[tL(8227)] = "F4", -- Flametongue Totem
	
	--[tL(108280)] = "W1", -- Elemental Resistance Totem
	--[tL(5675)] = "W4", -- Mana Spring Totem	
	--[tL(87718)] = "W6" -- Totem of Tranquil Mind
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