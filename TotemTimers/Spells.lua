-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters


local TotemTimers = TotemTimers

local function GetSpellTab(tab)
    local _, _, offset, numSpells = GetSpellTabInfo(tab)
    for s = offset + 1, offset + numSpells do
        local spelltype, spell = GetSpellBookItemInfo(s, BOOKTYPE_SPELL)
        if spelltype == "SPELL" then
            TotemTimers.AvailableSpells[spell] = true
        end
    end
end    


function TotemTimers.GetSpells()
    wipe(TotemTimers.AvailableSpells)
    wipe(TotemTimers.AvailableSpellIDs)
	for i = 2, GetNumSpellTabs() do
        GetSpellTab(i)
	end
    return true
end

function TotemTimers.GetTalents()
    wipe(TotemTimers.AvailableTalents)
    if select(5, GetTalentInfo(2,17))>0 then TotemTimers.AvailableTalents.Maelstrom = true end
    if select(5, GetTalentInfo(1,18))>0 then TotemTimers.AvailableTalents.LavaSurge = true end
    if select(5, GetTalentInfo(1,13))>0 then TotemTimers.AvailableTalents.Fulmination = true end
end


function TotemTimers.LearnedSpell(spell,tab)
    if spell then
        TotemTimers.AvailableSpells[spell] = true
    elseif tab then
        GetSpellTab(tab)
    else
        TotemTimers.GetSpells()
    end
    TotemTimers_SetCastButtonSpells()
    TotemTimers.SetWeaponTrackerSpells()
    TotemTimers.ProcessSetting("AnkhTracker")
    TotemTimers.ProcessSpecSetting("ShieldTracker")
    TotemTimers.ProcessSetting("EarthShieldTracker")
    TotemTimers.ProcessSetting("WeaponTracker")  
    TotemTimers.ProcessSpecSetting("EnhanceCDs") 
    TotemTimers.ProcessSetting("Show")
    TotemTimers.SetMultiCastSpells()
    TotemTimers.MultiSpellActivate()
    TotemTimers_ProgramSetButtons()
    TotemTimers.SetupTotemButtons()
    TotemTimers.ConfigAuras()
end


function TotemTimers.ChangedTalents()
	TotemTimers.GetSpells()
    TotemTimers.GetTalents()
    TotemTimers.ProcessSpecSetting("ShieldTracker")
    TotemTimers.ProcessSetting("EarthShieldTracker")
    TotemTimers.ProcessSetting("WeaponTracker")
    TotemTimers.ProcessSpecSetting("EnhanceCDs")  
    TotemTimers.SetupTotemCastButtons()
    TotemTimers_SetCastButtonSpells()
    TotemTimers.ConfigAuras()
    TotemTimers_OrderTimers()
    TotemTimers_OrderTrackers()
end
