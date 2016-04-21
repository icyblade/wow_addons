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
