-- 显示恶魔术恶魔存活时间
WarlockDemons = LibStub('AceAddon-3.0'):NewAddon('WarlockDemons', 'AceEvent-3.0', 'AceHook-3.0')
local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")

WarlockDemons.validDemonsDB = {
    [55659]  = {icon=GetSpellTexture(205145), duration=12}, -- Wild imps from Hand of Gul'dan
    [98035]  = {icon=GetSpellTexture(104316), duration=12}, -- Dreadstalkers, which is a vehicle. Imps on dreadstalkers are 99737
    [103673] = {icon=GetSpellTexture(205180), duration=12}, -- Darkglare
}

if IDI_SETTINGS == nil then
    IDI_SETTINGS = {
        texture = 'Glaze2',
        width = 200,
        height = 20,
        point = 'TOPLEFT',
        relativeFrame = 'UIParent',
        relativePoint = 'TOPLEFT',
        ofsx = 0,
        ofsy = -80,
        color = {r=1, g=0, b=0, a=1},
        grow = 'DOWN', -- UP not supported yet
    }
end

WarlockDemons.BarPool = {}

function WarlockDemons:CreateBar(icon, duration, note)
    local s = IDI_SETTINGS
    local texture = media:Fetch('statusbar', s.texture)
    local bar = candy:New(texture, s.width, s.height)
    local cnt = #WarlockDemons.BarPool
    bar:SetIcon(icon)
    bar:SetDuration(duration)
    bar:SetPoint(s.point, s.relativeFrame, s.relativePoint, s.ofsx, s.ofsy-cnt*s.height)
    bar:SetColor(s.color.r, s.color.g, s.color.b, s.color.a)
    bar.updater:SetScript('OnStop', function() WarlockDemons:RemoveBar(bar) end)
    bar.note = note or ''
    return bar
end

function WarlockDemons:RemoveBar(bar)
    local _, _, _, _, removed_y = bar:GetPoint()
    local s = IDI_SETTINGS
    for k, b in pairs(WarlockDemons.BarPool) do
        if b.note == bar.note then
            WarlockDemons.BarPool[k] = 'removed' -- mark removal, safe for iteration
        else
            local _, _, _, _, y = b:GetPoint()
            if y <= removed_y then
                b:ClearAllPoints()
                b:SetPoint(s.point, s.relativeFrame, s.relativePoint, s.ofsx, y+s.height)
            end
        end
    end
    for k, b in pairs(WarlockDemons.BarPool) do
        if b == 'removed' then
            table.remove(WarlockDemons.BarPool, k)
        end
    end
end

function check_status()
    local player_class = select(2, UnitClass('player'))
    local specialization = GetSpecialization()
    if player_class == 'WARLOCK' and specialization == 2 then -- Demonology only
        WarlockDemons:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
        if (GetLocale() == 'zhCN') then
            DEFAULT_CHAT_FRAME:AddMessage('检测到恶魔术，正在启用核武器...|cff00FF00完成|r')
        else
            DEFAULT_CHAT_FRAME:AddMessage('Demonology warlock detected, launching nuclear weapon...|cff00FF00DONE|r')
        end
    end
end

function WarlockDemons:OnInitialize()
    media:Register('statusbar', 'Glaze2', [[Interface\Addons\IcyDemonsIndicator\textures\Glaze2]])
    self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', check_status)
    self:RegisterEvent('PLAYER_ENTERING_WORLD', check_status)
end

function WarlockDemons:OnDisable()
    self:UnRegisterAllEvents()
end

function WarlockDemons:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
    local timestamp, combat_event, _, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, spellId, spellName, spellSchool = ...
    if sourceGUID ~= UnitGUID('player') then
        return
    end
    if combat_event == 'SPELL_SUMMON' then    
        local _, _, _, _, _, _, _, creature_id, _ = destGUID:find('(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)')
        creature_id = tonumber(creature_id)
        
        for id, v in pairs(WarlockDemons.validDemonsDB) do
            if id == creature_id then
                bar = WarlockDemons:CreateBar(v.icon, v.duration, destGUID)
                table.insert(WarlockDemons.BarPool, bar)
                bar:Start()
                return
            end
        end
    elseif combat_event == 'SPELL_INSTAKILL' then
        if spellId == 196278 then -- implosion
            for k, b in pairs(WarlockDemons.BarPool) do
                if b.note == destGUID then
                    b:Stop()
                end
            end
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
    else
        if (GetLocale() == 'zhCN') then
            DEFAULT_CHAT_FRAME:AddMessage('|cff00FF00IcyDemonsIndicator|r 帮助文档')
            DEFAULT_CHAT_FRAME:AddMessage('命令行：/idi 或 /icydemonsindicator')
            DEFAULT_CHAT_FRAME:AddMessage('/idi width 200: 调整计量条宽度为200（默认200）')
            DEFAULT_CHAT_FRAME:AddMessage('/idi height 20: 调整计量条高度为20（默认20）')
            DEFAULT_CHAT_FRAME:AddMessage('/idi x 0: 调整横坐标位置为0（默认0）')
            DEFAULT_CHAT_FRAME:AddMessage('/idi y -80: 调整纵坐标位置为-80（默认-80）')
        else
            DEFAULT_CHAT_FRAME:AddMessage('|cff00FF00IcyDemonsIndicator|r manuals')
            DEFAULT_CHAT_FRAME:AddMessage('Console: /idi or /icydemonsindicator')
            DEFAULT_CHAT_FRAME:AddMessage('/idi width 200: set bar width to 200(default 200)')
            DEFAULT_CHAT_FRAME:AddMessage('/idi height 20: set bar height to 20(default 20)')
            DEFAULT_CHAT_FRAME:AddMessage('/idi x 0: set x coordinate to 0(default 0)')
            DEFAULT_CHAT_FRAME:AddMessage('/idi y -80: set y coordinate to -80(default -80)')
        end
    end
end