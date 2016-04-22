IcyNameplates = LibStub("AceAddon-3.0"):NewAddon("IcyNameplates", "AceEvent-3.0", "AceHook-3.0")

local nameplates = {}

-- Nameplate
Nameplate = {}
Nameplate.__index = Nameplate

function Nameplate.create(f)
    local nameplate = {}
    setmetatable(nameplate, Nameplate)
    nameplate.np = f
    name = f:GetName()
    nameplate.npuf = _G[name..'UnitFrame']
    nameplate.npufhb = nameplate.npuf.healthBar
    return nameplate
end

function Nameplate:update()
    self.np:Hide()
    self.np:SetHeight(51)
    self.npuf:SetHeight(10)
    self.npufhb:SetHeight(10)
    self.np:Show()
end

function IcyNameplates:OnEnable()
	self:RegisterEvent("NAME_PLATE_CREATED", create);
	self:RegisterEvent("NAME_PLATE_UNIT_ADDED", reset);
	self:RegisterEvent("PLAYER_TARGET_CHANGED", reset);
end

function create(event, f, ...)
    nameplate = Nameplate.create(f)
    table.insert(nameplates, nameplate)
    nameplate:update()
end

function reset()
    for k, f in pairs(nameplates) do
        f:update()
    end
end
