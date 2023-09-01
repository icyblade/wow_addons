-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters



local map, mapfloor = nil,nil
local mapWidth, mapHeight = 0,0

local mapdata = LibStub("LibMapData-1.0")
local talentquery = LibStub("LibTalentQuery-1.0")


mapdata:RegisterCallback("MapChanged",
    function(event,mapname,mfloor,w,h)
        map = mapname
        mapfloor = mfloor
        mapWidth = w or 0
        mapHeight = h or 0
    end)

local function yards(x,y)
    return x*mapWidth,y*mapHeight
end


local playerName = UnitName("player")

local BuffNames = TotemTimers.BuffNames

-- roles: 1:melee, 2:ranged, 3:caster, 4:healer, 5:hybrid (elemental shaman)
--local GroupTalents = LibStub:GetLibrary("LibGroupTalents-1.0")

local RaidNames = {}
local RaidRoles = {}
local RaidClasses = {}
local RaidRange = {[1]={},[2]={},[3]={},[4]={}}
local RaidRangeCount = {0,0,0,0}
local inRaid = false
local inParty = false
local inBattleground = false
local TotemPositions = {[1]={x=0,y=0},[2]={x=0,y=0},[3]={x=0,y=0},[4]={x=0,y=0},}
local PlayerRange = {}


local function checkRange(unit,nr,guid)
    if UnitIsDeadOrGhost(unit) then return true end
    local role = nil
    if guid then role = RaidRoles[guid] end
    local totem = XiTimers.timers[nr].activeTotem
    if TotemData[totem].noRangeCheck then return true end
    if TotemData[totem].partyOnly and not UnitInParty(unit) then return true end
    if role and role ~= 0 and not TotemData[totem].needed[role] then return true end
    if TotemData[totem].hasBuff or mapWidth == 0 or mapHeight == 0 then
        -- Coordinates not available or totem gives buff, check buffs instead
        local buff = BuffNames[TotemData[totem].hasBuff]
        if buff then
            local b = UnitBuff(unit,buff)
            if not b and TotemData[totem].moreBuffs then
                for k,v in pairs(TotemData[totem].moreBuffs) do
                    if BuffNames[v] then
                        b = UnitBuff(unit, BuffNames[v]) or b
                    end
                end
            end
            return b ~= nil
        else
            -- totem gives no buff and no coords available: always return true
            return true
        end
    else
        --check range using coordinates
        local element = XiTimers.timers[nr].button.element
        local x,y = GetPlayerMapPosition(unit)
        x = x * mapWidth
        y = y * mapHeight
        local xDist = x - TotemPositions[element].x
        local yDist = y - TotemPositions[element].y
        local squareDist = xDist*xDist+yDist*yDist
        return squareDist<=900        
    end
end

local lastUnit = 0

-- only check two players per update
local function UpdatePartyRange()
    for i = 1,2 do
        lastUnit = lastUnit + 1
        if (not inRaid and lastUnit > 4) or (inRaid and lastUnit > 25) then lastUnit = 1 end
        local unit
        if inRaid then
            unit = "raid"..lastUnit
        else
            unit = "party"..lastUnit
        end
        if UnitExists(unit) and not UnitIsUnit(unit, "player") then
            local guid = UnitGUID(unit)
            if RaidRoles[guid] == 0 then
                talentquery:Query(unit)
            end
            for nr = 1,4 do
                if XiTimers.timers[nr].timers[1] > 0 then 
                    local range = checkRange(unit,nr,guid)
                    local element = XiTimers.timers[nr].button.element
                    if (not RaidRange[element][guid]) ~= range then
                        if range then RaidRange[element][guid] = nil
                        else RaidRange[element][guid] = true end
                        RaidRangeCount[element] = 0
                        for k,v in pairs(RaidRange[element]) do
                            RaidRangeCount[element] = RaidRangeCount[element] + 1
                        end                    
                    end
                end                    
            end
        end
    end
end

local lastPlayerTotem = 0

local function UpdatePlayerRange()
    lastPlayerTotem = lastPlayerTotem + 1
    if lastPlayerTotem > 4 then lastPlayerTotem = 1 end
    if XiTimers.timers[lastPlayerTotem].timers[1] > 0 then
        local element = XiTimers.timers[lastPlayerTotem].button.element
        PlayerRange[element] = checkRange("player", lastPlayerTotem)
    end
end

local rangeFrame = CreateFrame("Frame", "TotemTimers_RangeFrame")
rangeFrame:Hide()
TotemTimers.RangeFrame = rangeFrame
rangeFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
rangeFrame:RegisterEvent("RAID_ROSTER_UPDATE")
rangeFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
rangeFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
local Settings

rangeFrame:SetScript("OnUpdate", function(self)
    if Settings.CheckRaidRange and (inRaid or inParty) then
        UpdatePartyRange()
    end
    if Settings.CheckPlayerRange then UpdatePlayerRange() end
end)


local function GetUnitData(unit)
    if not UnitExists(unit) then return end
    if not UnitIsUnit(unit, "player") then
        local guid = UnitGUID(unit)
        if not guid then return end
        RaidNames[guid] = UnitName(unit)
        _,RaidClasses[guid] = UnitClass(unit)
        if RaidClasses[guid] == "HUNTER" then
            RaidRoles[guid] = 2
        elseif RaidClasses[guid] == "MAGE" or RaidClasses[guid] == "WARLOCK" or RaidClasses[guid] == "PRIEST" then
            RaidRoles[guid] = 3
        elseif RaidClasses[guid] == "ROGUE" or RaidClasses[guid] == "DEATHKNIGHT" or RaidClasses[guid] == "WARRIOR" then
            RaidRoles[guid] = 1
        else            
            if not RaidRoles[guid] or RaidRoles[guid] == 0 then
                talentquery:Query(unit)
                RaidRoles[guid] = 0
            end
        end
    end   
end


rangeFrame:SetScript("OnEvent", function(self, event, unit, spellname, spellrank, counter, spellid)
    if event == "UNIT_SPELLCAST_SUCCEEDED" and (spellid == 63645 or spellid == 63644) then
        if not UnitIsUnit(unit, "player") then
            local guid = UnitGUID(unit)
            if not guid then return end
            if RaidClasses[guid] == "SHAMAN" or RaidClasses[guid] == "PALADIN"
                or RaidClasses[guid] == "DRUID" then
                    RaidRoles[guid] = 0
                    talentquery:Query(unit)
            end
        end
        return
    end
    if GetNumRaidMembers() > 0 then inRaid = true end
    if GetNumPartyMembers() > 0 then inParty = true end
    if inRaid then
        for i = 1,25 do
            local unit = "raid"..i
            GetUnitData(unit)
        end
    elseif inParty then
        for i = 1,4 do
            local unit = "party"..i
            GetUnitData(unit)
        end
    end
end)


local TalentTreeToRole = {
    ["SHAMAN"]  = {3,5,3,},
    ["DRUID"]   = {3,1,3,},
    ["PALADIN"] = {3,1,1,},
}

function TotemTimers:TalentQuery_Ready(e, name, realm, unit, guid)
    if not guid then guid = UnitGUID(unit) end
    if UnitIsUnit(unit, "player") then return end
    local tree = GetPrimaryTalentTree(true)
    if not tree or tree < 1 or tree > 3 then talentquery:Query(unit) return end
    if RaidClasses[guid] and TalentTreeToRole[RaidClasses[guid]] then
        RaidRoles[guid] = TalentTreeToRole[RaidClasses[guid]][tree]
    end    
end
talentquery.RegisterCallback(TotemTimers, "TalentQuery_Ready")

rangeFrame:SetScript("OnShow", function()
    Settings = TotemTimers_Settings
end)



function TotemTimers.ResetRange(element)
    wipe(RaidRange[element])
    RaidRangeCount[element] = 0
end


--[[function TotemTimers.LibGroupTalents_Add(self, event, guid, unit, name, realm)
    RaidNames[guid] = name
    _, RaidClasses[guid] = UnitClass(unit)
    --for i=1,4 do ResetRange(i) end
end]]


local Roles = {tank = 1, melee = 1, caster = 3, healer = 4}

function TotemTimers.GetPlayerRange(element)
    return (not TotemTimers_Settings.CheckPlayerRange and true) or PlayerRange[element]
end

function TotemTimers.GetOutOfRange(element)
    return RaidRangeCount[element]
end

function TotemTimers.GetOutOfRangePlayers(element)
    return RaidRange[element], RaidNames, RaidClasses
end

function TotemTimers.GetRaidRoles()
    return RaidRoles, RaidClasses
end

--position of totems around player in radians, order fire,earth,water,air
local TotemOffsets = {0.7354,5.4978,3.927,2.3562,}

local sin, cos = math.sin, math.cos

function TotemTimers.SetTotemPosition(element)
   local x,y = GetPlayerMapPosition("player")
   x = x * mapWidth
   y = y * mapHeight
   local facing = GetPlayerFacing()
   local offsetX = -sin(facing+TotemOffsets[element])
   local offsetY = cos(facing+TotemOffsets[element])
   TotemPositions[element].x = x+offsetX
   TotemPositions[element].y = y+offsetY
end
