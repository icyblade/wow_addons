-- Bar related

IcyDemonsIndicator.BarPool = {}

local candy = LibStub('LibCandyBar-3.0')
local media = LibStub('LibSharedMedia-3.0')


function IcyDemonsIndicator:CreateBar(icon, duration, GUID, summon_type)
    local S = IDI_SETTINGS
    local texture = media:Fetch('statusbar', S.texture)
    local bar = candy:New(texture, S.width, S.height)
    local cnt = #self.BarPool

    bar:SetIcon(icon)
    bar:SetDuration(duration)
    bar:SetPoint(S.point, S.relativeFrame, S.relativePoint, S.ofsx, S.ofsy + cnt*S.height*S.grow)
    bar:SetColor(S.color.r, S.color.g, S.color.b, S.color.a)
    bar.updater:SetScript('OnStop', function() self:RemoveBar(bar) end)
    bar.GUID = GUID or ''
    bar.summon_type = summon_type or ''

    if summon_type == 'Pet' then
        -- hide duration for pet, fake a "forever" bar
        bar:SetTextColor(0, 0, 0, 0)
    end

    return bar
end


function IcyDemonsIndicator:RemoveBar(bar_to_be_removed)
    local S = IDI_SETTINGS
    local _, _, _, _, removed_y = bar_to_be_removed:GetPoint()
    for index, bar in pairs(self.BarPool) do
        if bar.GUID == bar_to_be_removed.GUID then
            table.remove(self.BarPool, index)
            self:SetPointAllBars()
            return
        end
    end
end


function IcyDemonsIndicator:SortAllBars()
    -- theoretically O(nlogn), no need to optimized to O(logn)
    table.sort(self.BarPool, function(a, b) return a.remaining < b.remaining end)
    self:SetPointAllBars()
end


function IcyDemonsIndicator:SetPointAllBars()
    local S = IDI_SETTINGS
    local current_y = S.ofsy
    for _, bar in pairs(self.BarPool) do
        bar:ClearAllPoints()
        bar:SetPoint(S.point, S.relativeFrame, S.relativePoint, S.ofsx, current_y)
        current_y = current_y + S.height*S.grow
    end
end
