-- 显示大秘境精确进度
MythicDungeon = LibStub('AceAddon-3.0'):NewAddon('MythicDungeon', 'AceEvent-3.0', 'AceHook-3.0')

function MythicDungeon:OnEnable()
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
end

function MythicDungeon:OnDisable()
    self:UnRegisterAllEvents()
end

function MythicDungeon:PLAYER_ENTERING_WORLD()
    local difficulty_id = select(3, GetInstanceInfo())
    if difficulty_id == 8 or difficulty_id == 23 then
        self:RegisterEvent('CRITERIA_UPDATE', 'update_progress_bar')
        self:RegisterEvent('SCENARIO_CRITERIA_UPDATE', 'update_progress_bar')
        DEFAULT_CHAT_FRAME:AddMessage('大秘境进度: |cff00FF00ON|r')
        MythicDungeon:update_progress_bar() -- direct call
    else
        self:UnregisterEvent('CRITERIA_UPDATE')
        self:UnregisterEvent('SCENARIO_CRITERIA_UPDATE')
        DEFAULT_CHAT_FRAME:AddMessage('大秘境进度: |cffFF0000OFF|r')
    end
end

function MythicDungeon:update_progress_bar()
    for criteriaIndex, line in ipairs(SCENARIO_TRACKER_MODULE:GetBlock().lines) do
        for key, element in pairs(line) do
            if key == 'ProgressBar' then
                local criteriaString, criteriaType, completed, quantity, totalQuantity, flags, assetID, quantityString, criteriaID, duration, elapsed, _, isWeightedProgress = C_Scenario.GetCriteriaInfo(criteriaIndex)
                if quantityString ~= nil then
                    quantityString = quantityString:gsub('%%', '')
                end
                element.Bar.Label:SetFormattedText('%s/%s %s%%', quantityString or '', totalQuantity or '', quantity or '');
            end
        end
    end
end
