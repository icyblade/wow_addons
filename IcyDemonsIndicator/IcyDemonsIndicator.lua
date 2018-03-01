IcyDemonsIndicator = LibStub('AceAddon-3.0'):NewAddon('IcyDemonsIndicator', 'AceEvent-3.0', 'AceHook-3.0')

local candy = LibStub('LibCandyBar-3.0')
local media = LibStub('LibSharedMedia-3.0')
local UnitClass = UnitClass
local GetSpecialization = GetSpecialization
local GetSpellTexture = GetSpellTexture
local UnitSpellHaste = UnitSpellHaste
local INFINITY = 24*3600*100


IcyDemonsIndicator.valid_demons_db = {
    ['Creature-55659'] = {icon=GetSpellTexture(205145), base_duration=11.5}, -- Wild Imps
    ['Vehicle-98035'] = {icon=GetSpellTexture(104316), duration=8},  -- Dreadstalkers
    ['Creature-135002'] = {icon=GetSpellTexture(265187), duration=15},  -- Demon Commander
    ['Pet-17252'] = {icon=GetSpellTexture(30146), duration=INFINITY},  -- Felguard
    ['Creature-17252'] = {icon=GetSpellTexture(108501), duration=25},  -- Grimoire of Service
    ['Creature-135816'] = {icon=GetSpellTexture(264119), duration=15},  -- Vilefiend
    
    -- Nether Portal
    ['Creature-136397'] = {icon=GetSpellTexture(112868), duration=15},  -- Prince Malchezaar from Nether Portal
    ['Creature-136398'] = {icon=GetSpellTexture(112868), duration=15},  -- Illidari Satyr from Nether Portal
    ['Creature-136399'] = {icon=GetSpellTexture(112868), duration=15},  -- Vicious Hellhound from Nether Portal
    ['Creature-136401'] = {icon=GetSpellTexture(112868), duration=15},  -- Eye of Gul'dan from Nether Portal
    ['Creature-136402'] = {icon=GetSpellTexture(112868), duration=15},  -- Ur'zul from Nether Portal
    ['Creature-136403'] = {icon=GetSpellTexture(112868), duration=15},  -- Void Terror from Nether Portal
    ['Creature-136404'] = {icon=GetSpellTexture(112868), duration=15},  -- Bilescourge from Nether Portal
    ['Creature-136405'] = {icon=GetSpellTexture(112868), duration=15},  -- Eredar Brute from Nether Portal
    ['Creature-136406'] = {icon=GetSpellTexture(112868), duration=15},  -- Shivarra from Nether Portal
    ['Creature-136407'] = {icon=GetSpellTexture(112868), duration=15},  -- Wrathguard from Nether Portal
    ['Creature-136408'] = {icon=GetSpellTexture(112868), duration=15},  -- Darkhound from Nether Portal
}


-- initialize/reset IDI_SETTINGS
local function InitializeSettings(reset)
    IDI_SETTINGS_DEFAULT = {
        texture = 'Glaze2',
        width = 200,
        height = 20,
        point = 'TOPLEFT',
        relativeFrame = 'UIParent',
        relativePoint = 'TOPLEFT',
        ofsx = 0,
        ofsy = -80,
        color = {r=1, g=0, b=0, a=1},
        grow = -1,  -- -1 for growing down, 1 for growing up
    }

    if reset then
        IDI_SETTINGS = IDI_SETTINGS_DEFAULT
    else
        -- if IDI_SETTINGS has nil values, use IDI_SETTINGS_DEFAULT instead
        if type(IDI_SETTINGS) ~= table then
            IDI_SETTINGS = {}
        end

        for k, v in pairs(IDI_SETTINGS_DEFAULT) do
            if IDI_SETTINGS[k] == nil then
                IDI_SETTINGS[k] = v
            end
        end
    end
end


-- check if you're demonology warlock
local function IsDemonology()
    local player_class = select(2, UnitClass('player'))
    local specialization = GetSpecialization()
    return (player_class == 'WARLOCK' and specialization == 2)
end


-- update addon status, used when changing equipments, talents, etc.
local function UpdateStatus()
    if not IsDemonology() then
        IcyDemonsIndicator:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
        IcyDemonsIndicator:UnregisterEvent('PET_DISMISS_START')
    else
        IcyDemonsIndicator:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
        IcyDemonsIndicator:RegisterEvent('PET_DISMISS_START')
    end
end


function IcyDemonsIndicator:OnEnable()
    media:Register('statusbar', 'Glaze2', [[Interface\Addons\IcyDemonsIndicator\textures\Glaze2]])
    
    InitializeSettings()
    self:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateStatus)
    self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', UpdateStatus)
    self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED', UpdateStatus)
end


function IcyDemonsIndicator:OnDisable()
    self:UnRegisterAllEvents()
end


function IcyDemonsIndicator:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
    timestamp, combat_event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName = CombatLogGetCurrentEventInfo()
    
    if sourceGUID ~= UnitGUID('player') then
        return
    end

    if combat_event == 'SPELL_SUMMON' then
        local _, _, summon_type, _, _, _, _, creature_id, _ = destGUID:find('(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)')
        local demon_id = summon_type..'-'..creature_id
        
        for id, db in pairs(self.valid_demons_db) do
            if id == demon_id then
                local duration
                if db.base_duration then
                    local haste = UnitSpellHaste("player")
                    duration = db.base_duration / (1 + haste / 100)
                else
                    duration = db.duration
                end
                local bar = self:CreateBar(db.icon, duration, destGUID, summon_type)
                table.insert(self.BarPool, bar)
                bar:Start()
                self:SortAllBars()
                return
            end
        end
    elseif combat_event == 'SPELL_CAST_SUCCESS' and spellId == 265187 then
        -- Demon Commander, +15s
        for _, bar in pairs(self.BarPool) do
            local remaining = bar.remaining
            bar:Pause()
            bar:SetDuration(bar.duration + 15)
            bar.remaining = remaining + 15
            bar:Start()
        end
    elseif combat_event == 'SPELL_INSTAKILL' and spellId == 196278 then
        -- Implosion
        for _, bar in pairs(self.BarPool) do
            if bar.GUID == destGUID then
                bar:Stop()
            end
        end
        self:SortAllBars()
    elseif (combat_event == 'SPELL_AURA_APPLIED' or combat_event == 'SPELL_AURA_APPLIED_DOSE') and spellId == 267549 then
        -- Power Siphon
        for _, bar in pairs(self.BarPool) do
            if bar.GUID == destGUID then
                bar:Stop()
            end
        end
        self:SortAllBars()
    end
end

function IcyDemonsIndicator:PET_DISMISS_START(event, ...)
    for _, bar in pairs(self.BarPool) do
        if bar.summon_type == 'Pet' then
            bar:Stop()
            return
        end
    end
end

-- slash command for accessing config
SLASH_ICYDEMONSINDICATOR1, SLASH_ICYDEMONSINDICATOR2 = '/idi', '/icydemonsindicator'
function SlashCmdList.ICYDEMONSINDICATOR(msg)
    action, param = msg:match('([^ ]+) ([^ ]+)')
    if action == 'width' then
        IDI_SETTINGS.width = tonumber(param)
    elseif action == 'height' then
        IDI_SETTINGS.height = tonumber(param)
    elseif action == 'x' then
        IDI_SETTINGS.ofsx = tonumber(param)
    elseif action == 'y' then
        IDI_SETTINGS.ofsy = tonumber(param)
    elseif action == 'grow' then
        IDI_SETTINGS.grow = (string.lower(param) == 'up' and 1 or -1)
    elseif action == 'reset' then
        InitializeSettings(true)
    else
        if (GetLocale() == 'zhCN') then
            DEFAULT_CHAT_FRAME:AddMessage('|cff00FF00IcyDemonsIndicator|r 帮助文档')
            DEFAULT_CHAT_FRAME:AddMessage('命令行：/idi 或 /icydemonsindicator')
            DEFAULT_CHAT_FRAME:AddMessage('/idi width 200: 调整计量条宽度为200（默认200）')
            DEFAULT_CHAT_FRAME:AddMessage('/idi height 20: 调整计量条高度为20（默认20）')
            DEFAULT_CHAT_FRAME:AddMessage('/idi x 0: 调整横坐标位置为0（默认0）')
            DEFAULT_CHAT_FRAME:AddMessage('/idi y -80: 调整纵坐标位置为-80（默认-80）')
            DEFAULT_CHAT_FRAME:AddMessage('/idi grow DOWN: 向上/向下延拓（默认 DOWN）')
            DEFAULT_CHAT_FRAME:AddMessage('/idi reset: 重置设置')
        else
            DEFAULT_CHAT_FRAME:AddMessage('|cff00FF00IcyDemonsIndicator|r manuals')
            DEFAULT_CHAT_FRAME:AddMessage('Console: /idi or /icydemonsindicator')
            DEFAULT_CHAT_FRAME:AddMessage('/idi width 200: set bar width to 200(default 200)')
            DEFAULT_CHAT_FRAME:AddMessage('/idi height 20: set bar height to 20(default 20)')
            DEFAULT_CHAT_FRAME:AddMessage('/idi x 0: set x coordinate to 0(default 0)')
            DEFAULT_CHAT_FRAME:AddMessage('/idi y -80: set y coordinate to -80(default -80)')
            DEFAULT_CHAT_FRAME:AddMessage('/idi grow DOWN: bar grow UP/DOWN(default DOWN)')
            DEFAULT_CHAT_FRAME:AddMessage('/idi reset: reset settings')
        end
    end
end