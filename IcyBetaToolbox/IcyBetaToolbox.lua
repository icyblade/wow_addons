IcyBetaToolbox = LibStub("AceAddon-3.0"):NewAddon("IcyBetaToolbox", "AceEvent-3.0", "AceHook-3.0")

-- register slash command
SLASH_ICYBETATOOLBOX1 = '/icy'
SlashCmdList["ICYBETATOOLBOX"] = function(msg, editbox)
    lst = {}
    for k, v in string.gmatch(msg, '[^ ]+') do
        table.insert(lst, k)
    end
    command = lst[1]
    parameter = lst[2]
    if command == 'help' or command == '' then
        help()
    elseif command == 'deletenecklace: ' or command == 'dn' then
        delete_necklace()
    elseif command == 'ks' then
        keystone_to_be_kept = parameter
        filter_keystone()
    end
end

function help()
    DEFAULT_CHAT_FRAME:AddMessage('/icy [dn/deletenecklace]: delete all necklace from THAT treasure')
    DEFAULT_CHAT_FRAME:AddMessage('/icy ks [NAME]: DELETE all keystone except NAME')
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

function filter_keystone()
    -- select concat('{[',group_concat(concat(field6,']=\'',m_name_lang) SEPARATOR '\',['),'\'}') from dbc_JournalInstance,dbc_JournalTierXInstance where dbc_JournalInstance.m_ID=dbc_JournalTierXInstance.m_journalInstanceID and dbc_JournalTierXInstance.m_journalTierID=(select m_ID from dbc_JournalTier where m_name_lang='军团再临')
    print('Removing keystone except'..keystone_to_be_kept)
    journal_dict = {[1493]='守望者地窟',[1456]='艾萨拉之眼',[1477]='英灵殿',[1492]='噬魂之喉',[1516]='魔法回廊',[1501]='黑鸦堡垒',[1466]='黑心林地',[1458]='奈萨里奥的巢穴',[1520]='翡翠梦魇',[1544]='突袭紫罗兰监狱',[1530]='暗夜要塞',[1571]='群星庭院',[1520]='破碎群岛'}
    -- open keystone container
    for b = 0, 4 do 
        for s = 1, GetContainerNumSlots(b) do 
            local l = GetContainerItemLink(b, s)
            if l then
            lst = {}
            for k, v in string.gmatch(l, '[^:]+') do
                table.insert(lst, k)
            end
            local item_id = lst[2]
            local instance_id = lst[6]
            if item_id == '139381' or item_id == '139382' or item_id == '139383' then
                UseContainerItem(b, s)
            end
          end 
        end
    end
    C_Timer.After(5, remove_keystone_except)
end

function remove_keystone_except()
    -- filter keystone
    for b = 0, 4 do 
        for s = 1, GetContainerNumSlots(b) do 
            local l = GetContainerItemLink(b, s)
            if l then
                lst = {}
                for k, v in string.gmatch(l, '[^:]+') do
                    table.insert(lst, k)
                end
                local item_id = lst[2]
                local instance_id = lst[6]
                if item_id == '138019' and journal_dict[tonumber(lst[6])] ~= keystone_to_be_kept then
                    PickupContainerItem(b, s) 
                    DeleteCursorItem() 
                end
            end 
        end
    end
end
