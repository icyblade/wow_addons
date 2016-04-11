IcyBetaToolbox = LibStub("AceAddon-3.0"):NewAddon("IcyBetaToolbox", "AceEvent-3.0", "AceHook-3.0")

-- register slash command
SLASH_ICYBETATOOLBOX1 = '/icy'
SlashCmdList["ICYBETATOOLBOX"] = function(msg, editbox)
    if msg == 'help' or msg == '' then
        help()
    elseif msg == 'deletenecklace' or msg == 'dn' then
        delete_necklace()
    end
end

function help()
    DEFAULT_CHAT_FRAME:AddMessage('/icy [dn/deletenecklace]: delete all necklace from THAT treasure')
end

function delete_necklace()
    -- delete Woodshaper Focus
    for b = 0, 4 do 
        for s = 1, GetContainerNumSlots(b) do 
            local l = GetContainerItemLink(b, s)
            if l and l:find('item:130123:') then
                PickupContainerItem(b, s) 
                DeleteCursorItem() 
            end 
        end 
    end
end

ShowChallengeProgress = LibStub("AceAddon-3.0"):NewAddon("ShowChallengeProgress", "AceEvent-3.0", "AceHook-3.0")
function ShowChallengeProgress:OnEnable()
    self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('CRITERIA_UPDATE')
end

function ShowChallengeProgress:PLAYER_ENTERING_WORLD()
    for criteriaIndex, line in pairs(SCENARIO_TRACKER_MODULE:GetBlock().lines) do
        for key, element in pairs(line) do
            if key == 'ProgressBar' then
                local criteriaString, criteriaType, completed, quantity, totalQuantity, flags, assetID, quantityString, criteriaID, duration, elapsed, _, isWeightedProgress = C_Scenario.GetCriteriaInfo(criteriaIndex)
                if quantity ~= nil then
                    element.Bar.Label:SetFormattedText('%d/%d %s', quantity, totalQuantity, quantityString);
                end
            end
        end
    end
end

function ShowChallengeProgress:CRITERIA_UPDATE()
    for criteriaIndex, line in pairs(SCENARIO_TRACKER_MODULE:GetBlock().lines) do
        for key, element in pairs(line) do
            if key == 'ProgressBar' then
                local criteriaString, criteriaType, completed, quantity, totalQuantity, flags, assetID, quantityString, criteriaID, duration, elapsed, _, isWeightedProgress = C_Scenario.GetCriteriaInfo(criteriaIndex)
                element.Bar.Label:SetFormattedText('%d/%d %s', quantity, totalQuantity, quantityString);
            end
        end
    end
end

