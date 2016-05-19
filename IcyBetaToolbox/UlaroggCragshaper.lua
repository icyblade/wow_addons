-- 找石头
UlaroggCragshaper = LibStub('AceAddon-3.0'):NewAddon('UlaroggCragshaper', 'AceEvent-3.0', 'AceHook-3.0')

local stones = {}
local stance_of_the_mountain_ids = {198509,198510,198564,198565,198569,198616,198617,198619,198630,198631,198713,214423,216249,216250}
local enabled = false
local boss_guid

function UlaroggCragshaper:OnEnable()
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function UlaroggCragshaper:OnDisable()
    self:UnRegisterAllEvents()
end

function UlaroggCragshaper:PLAYER_ENTERING_WORLD()
    local _, _, _, _, _, _, _, id = GetInstanceInfo()
    if id == 1458 then -- 1458: Neltharion's Lair
        DEFAULT_CHAT_FRAME:AddMessage('Ularogg Helper Enabled')
        self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
        self:RegisterEvent('PLAYER_TARGET_CHANGED')
    else
        self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
        self:UnregisterEvent('PLAYER_TARGET_CHANGED')
    end
end

function UlaroggCragshaper:COMBAT_LOG_EVENT_UNFILTERED(self, timestamp, event, ...)
    local sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, spellId, spellName, spellSchool = ...
    
    -- enable & disable
    if event == 'SPELL_AURA_APPLIED' and spellId == 198510 then
        -- new five stones
        DEFAULT_CHAT_FRAME:AddMessage('Time to find the BOSS!')
        stones = {}
        enabled = true
    elseif event == 'SPELL_AURA_REMOVED' and spellId == 198510 then
        -- finished
        DEFAULT_CHAT_FRAME:AddMessage('Time to kill the BOSS!')
        stones = {}
        enabled = false
    end
    
    if enabled then
        if event == 'SPELL_SUMMON' then
            for _, v in pairs(stance_of_the_mountain_ids) do
                if v == spellId then
                    table.insert(stones, destGUID)
                end
            end
        elseif event == 'SPELL_AURA_APPLIED' and spellId == 198717 then
            for _, v in pairs(stones) do
                if v ~= destGUID then
                    boss_guid = v
                    DEFAULT_CHAT_FRAME:AddMessage('Boss GUID: '..tostring(v))
                end
            end
        end
    end
end

function UlaroggCragshaper:PLAYER_TARGET_CHANGED()
    if not enabled then return end
    local target_guid = UnitGUID('target')
    DEFAULT_CHAT_FRAME:AddMessage('Target GUID: '..tostring(target_guid))
    if target_guid == boss_guid then
        DEFAULT_CHAT_FRAME:AddMessage('This is the BOSS! Kill it!')
        SetRaidTarget('target', 8) -- 8: white skull
        PlaySound('QUESTCOMPLETED', 'master')
    end
end