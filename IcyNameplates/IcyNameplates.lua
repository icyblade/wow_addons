IcyNameplates = LibStub("AceAddon-3.0"):NewAddon("IcyNameplates", "AceEvent-3.0", "AceHook-3.0")

local isInCombat = false
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
    nameplate.npufhb = _G[name..'UnitFrameHealthBar']
    return nameplate
end

function Nameplate:update()
    self.np:SetHeight(51)
    self.npuf:SetHeight(10)
    self.npufhb:SetHeight(10)
    -- self.npufhb:SetWidth(100)
end

function IcyNameplates:OnEnable() -- OnLoad
	self:RegisterEvent("NAME_PLATE_CREATED", create);
	self:RegisterEvent("NAME_PLATE_UNIT_ADDED", reset);
	-- self:RegisterEvent("NAME_PLATE_UNIT_REMOVED", reset);
	self:RegisterEvent("PLAYER_TARGET_CHANGED", reset);
	-- self:RegisterEvent("DISPLAY_SIZE_CHANGED", reset);
	-- self:RegisterEvent("UNIT_AURA", reset);
	-- self:RegisterEvent("VARIABLES_LOADED", reset);
	-- self:RegisterEvent("CVAR_UPDATE", reset);
    -- self:Hook(GameTooltip, "SetUnit", true)
end

function create(event, f, ...)
    nameplate = Nameplate.create(f)
    table.insert(nameplates, nameplate)
    nameplate:update()
end

function add(event, f, ...)
    start_pos, end_pos = strfind(f, '%d')
    no = string.sub(f, start_pos, end_pos+1)
    f = _G['NamePlate'..no]
    name = f:GetName()
    print('Add '..name)
    f:SetHeight(51)
    _G[name..'UnitFrame']:SetHeight(10)
    _G[name..'UnitFrameHealthBar']:SetHeight(10)
    _G[name..'UnitFrameHealthBar']:SetWidth(100)
end

function reset()
    for k, f in pairs(nameplates) do
        f:update()
    end
end
