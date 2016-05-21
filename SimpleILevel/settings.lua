--[[
ToDo:
    - 
]]

local L = LibStub("AceLocale-3.0"):GetLocale("SimpleILevel", true);

--[[
    MoP Colors:
        White 0, #FFFFFF, 255, 255, 255
        Yellow 463, #FFFF00, 255, 255, 0
        Green 463, #00FF00, 0, 255, 0
        Teal 518, #00FFFF, 0, 255, 255
        Blue H T17, #0066ff, 0, 102, 255 - Raw Blue was to dark
        Purple H T18, #FF00FF, 255, 0, 255
        Red H T19, #FF0000, 255, 0, 0
]]--
-- Melons: change color for legion
--[[
SIL_ColorIndex = {0,463,615,695,740,785,1000};
SIL_Colors = {
    -- White base color
    [0] =       {['r']=255,     ['g']=255,      ['b']=255,      ['rgb']='FFFFFF',   ['p']=0,},
    -- Yellow for MoP dungeon gear
    [463] =     {['r']=255,     ['g']=255,      ['b']=0,        ['rgb']='FFFF00',   ['p']=0,},
    -- Green for WoD dungeon gear
    [615] =     {['r']=0,       ['g']=255,      ['b']=0,        ['rgb']='00FF00',   ['p']=463,},
    -- Teal for Mythic T17
    [695] =     {['r']=0,       ['g']=255,      ['b']=255,      ['rgb']='00FFFF',   ['p']=615,},
    -- Blue for Mythic T18
    [740] =     {['r']=0,       ['g']=102,      ['b']=255,      ['rgb']='0066ff',   ['p']=695,},
    -- Purple for Mythic T19
    [785] =     {['r']=255,     ['g']=0,        ['b']=255,      ['rgb']='FF00FF',   ['p']=740,},
    -- Red for a max score
    [1000] =    {['r']=255,     ['g']=0,        ['b']=0,        ['rgb']='FF0000',   ['p']=785,},
};]]
SIL_ColorIndex = {0,825,850,1000};
SIL_Colors = {
    -- Gray for leveling~5H
    [0] =    {['r']=157,     ['g']=157,      ['b']=157,      ['rgb']='9d9d9d',   ['p']=0  ,},
    [825] =  {['r']=157,     ['g']=157,      ['b']=157,      ['rgb']='9d9d9d',   ['p']=0  ,},
    -- Blue for 5H~RAID
    [850] =  {['r']=0  ,     ['g']=112,      ['b']=221,      ['rgb']='0070dd',   ['p']=825,},
    -- Purple for RAID+
    [1000] = {['r']=163,     ['g']=53 ,      ['b']=238,      ['rgb']='a335ee',   ['p']=850,},
};

-- Supported channel localization table
SIL_Channels = {
    SYSTEM = string.lower(CHAT_MSG_SYSTEM),
    GROUP = string.lower(GROUP),
    PARTY = string.lower(CHAT_MSG_PARTY),
    RAID = string.lower(CHAT_MSG_RAID),
    GUILD = string.lower(CHAT_MSG_GUILD),
    SAY = string.lower(CHAT_MSG_SAY),
    BATTLEGROUND = string.lower(CHAT_MSG_BATTLEGROUND),
    INSTANCE_CHAT = string.lower(INSTANCE_CHAT_MESSAGE),
    OFFICER = string.lower(CHAT_MSG_OFFICER),
}
SIL_GroupChannelString = '';
local i = 0;
for channel,name in pairs(SIL_Channels) do
    if i == 0 then
        SIL_GroupChannelString = name;
    else
        SIL_GroupChannelString = SIL_GroupChannelString..'/'..name;
    end
    i = i + 1;
end
L.group.options.groupDesc = format(L.group.options.groupDesc, SIL_GroupChannelString);

-- Options for AceOptions
SIL_Options = {
    name = L.core.options.name,
    desc = L.core.desc,
    type = "group",
    args = {
        general = {
            name = L.core.options.options,
            type = "group",
            inline = true,
            order = 1,
            args = {
                advanced = { -- Advanced Tooltip
                    name = L.core.options.ttAdvanced,
                    desc = L.core.options.ttAdvancedDesc,
                    type = "toggle",
                    set = function(i,v) SIL:SetAdvanced(v); end,
                    get = function(i) return SIL:GetAdvanced(); end,
                    order = 1,
                },
                combat = { -- Tooltip in Combat
                    name = L.core.options.ttCombat,
                    desc = L.core.options.ttCombatDesc,
                    type = "toggle",
                    get = function(i) return SIL:GetTTCombat(); end,
                    set = function(i,v) SIL:SetTTCombat(v);  end,
                    order = 2,
                },
                color = { -- Color Score
                    name = L.core.options.color,
                    desc = L.core.options.colorDesc,
                    type = "toggle",
                    get = function(i) return SIL:GetColorScore(); end,
                    set = function(i,v) SIL:SetColorScore(v);  end,
                    order = 3,
                },
                round = { -- Round Score
                    name = L.core.options.round,
                    desc = L.core.options.roundDesc,
                    type = "toggle",
                    get = function(i) return SIL:GetRoundScore(); end,
                    set = function(i,v) SIL:SetRoundScore(v);  end,
                    order = 3,
                },
                
                autoscan = { -- Autoscan Group Members
                    name = L.core.options.autoscan,
                    desc = L.core.options.autoscanDesc,
                    type = "toggle",
                    set = function(i,v) SIL:SetAutoscan(v); end,
                    get = function(i) return SIL:GetAutoscan(); end,
                    order = 5,
                },
                minimap = { -- Minimap Button
                    name = L.core.options.minimap,
                    desc = L.core.options.minimapDesc,
                    type = "toggle",
                    set = function(i,v) SIL:SetMinimap(v); end,
                    get = function(i) return SIL:GetMinimap(); end,
                    order = 6,
                },
                cinfo = { -- Paperdoll Information
                    name = L.core.options.paperdoll,
                    desc = L.core.options.paperdollDesc,
                    type = "toggle",
                    set = function(i,v) SIL:SetPaperdoll(v); end,
                    get = function(i) return SIL:GetPaperdoll(); end,
                    order = 7,
                },
                
                
                age = {
                    name = L.core.options.maxAge,
                    desc = L.core.options.maxAgeDesc,
                    type = "range",
                    min = 1,
                    softMax = 240,
                    step = 1,
                    get = function(i) return (SIL:GetAge() / 60); end,
                    set = function(i,v) v = tonumber(tonumber(v) * 60); SIL:SetAge(v); end,
                    order = 20,
                    width = "full",
                },
                
                autoPurge = {
                    name = L.core.options.purgeAuto,
                    desc = L.core.options.purgeAutoDesc,
                    type = "range",
                    min = 0,
                    softMax = 30,
                    step = 1,
                    get = function(i) return (SIL:GetPurge() / 24); end,
                    set = function(i,v) SIL:SetPurge(v * 24);  end,
                    order = 21,
                    width = "full",
                    cmdHidden = true,
                },
            },
        },
        
        ldbOpt = {
            name = L.core.options.ldb,
            type = "group",
            inline = true,
            order = 2,
            cmdHidden = true,
            args = {
                ldbText = {
                    name = L.core.options.ldbText,
                    desc = L.core.options.ldbTextDesc,
                    type = "toggle",
                    get = function(i) return SIL:GetLDB(); end,
                    set = function(i,v) SIL:SetLDB(v); end,
                    order = 1,
                },
                ldbLabel = {
                    name = L.core.options.ldbSource,
                    desc = L.core.options.ldbSourceDesc,
                    type = "toggle",
                    get = function(i) return SIL:GetLDBlabel(); end,
                    set = function(i,v) SIL:SetLDBlabel(v); end,
                    order = 2,
                },
                ldbRefresh = { -- Refreshrate of LDB
                    name = L.core.options.ldbRefresh,
                    desc = L.core.options.ldbRefreshDesc,
                    type = "range",
                    min = 1,
                    softMax = 300,
                    step = 1,
                    get = function(i) return SIL:GetLDBrefresh(); end,
                    set = function(i,v) SIL:SetLDBrefresh(v); end,
                    order = 20,
                    width = "full",
                },
            },
        },
        
        module = {
            name = L.core.options.modules,
            desc = L.core.options.modulesDesc,
            type = 'multiselect',
            values = function() return SIL:ModulesList(); end,
            get = function(s,m) return SIL:GetModule(m) end,
            set = function(s,m,v) return SIL:SetModule(m, v) end,
            order = 3,
        },
        
        purge = {
            name = L.core.options.purge,
            desc = L.core.options.purgeDesc,
            type = "execute",
            func = function(i) SIL:AutoPurge(false); end,
            confirm = true,
            order = 49,
        },
        clear = {
            name = L.core.options.clear,
            desc = L.core.options.clearDesc,
            type = "execute",
            func = function(i) SIL:SlashReset(); end,
            confirm = true,
            order = 50,
        },
        
        -- Console Only
        get = {
            name = L.core.options.get,
            desc = L.core.options.getDesc,
            type = "input",
            set = function(i,v) SIL:SlashGet(v); end,
            hidden = true,
            guiHidden = true,
            cmdHidden = false,
        },
        target = {
            name = L.core.options.target,
            desc = L.core.options.targetDesc,
            type = "input",
            set = function(i) SIL:SlashTarget(); end,
            hidden = true,
            guiHidden = true,
            cmdHidden = false,
        },
        options = {
            name = L.core.options.options,
            desc = L.core.options.open,
            type = "input",
            set = function(i) SIL:ShowOptions(); end,
            hidden = true,
            guiHidden = true,
            cmdHidden = false,
        },
        
        leveladj = {
            name = 'Level Adjustment',
            desc = "[item link], used to get the level adjustment id of a item link.",
            type = "input",
            set = function(i,link)
                    local itemLevel = select(4,GetItemInfo(link));

                    if itemLevel then
                        SIL:Print(link, "has a base item level", itemLevel, "with adjustment id", link:match(":(%d+)\124h%["));
                    end
                end,
            guiHidden = true,
            cmdHidden = false,
        },

        debug = {
            name = 'Debug Mode',
            type = "toggle",
            set = function(i,v) SIL:SetDebug(v); SIL:Print('Debug', SIL:GetDebug()); end,
            get = function(i) return SIL:GetDebug(); end,
            hidden = true,
            guiHidden = true,
            cmdHidden = true,
        },
    },
};

SIL_Defaults = {
    global = {
        age = 1800,             -- How long till information is refreshed
        purge = 360,            -- How often to automaticly purge
        advanced = false,       -- Display extra information in the tooltips
        autoscan = true,        -- Automaticly scan for changes
        cinfo = false,          -- Character Info/Paperdoll info
        minimap = {
            hide = false,       -- Minimap Icon
        },
        version = 1,            -- Version for future referance
        ldbText = true,         -- LDB Text
        ldbLabel = true,        -- LDB Label
        ldbRefresh = 30,        -- LDB Refresh Rate
        ttCombat = true,        -- Tooltip in combat
        color = true,           -- Color the score
        round = false,          -- Round the score
    },
    char = {
        module = {},            -- Module State
        debug = false,          -- Debug mode
    }
};

-- From http://www.wowhead.com/items?filter=qu=7;sl=16:18:5:8:11:10:1:23:7:21:2:22:13:24:15:28:14:4:3:19:25:12:17:6:9;minrl=80;maxrl=80
-- and $("a.q7").each(function(k,v){var url = v.href.split('/')[3].split('=');if (url[0] == 'item') {console.log(url[1])}});
SIL_Heirlooms = {
    [1] = {86559,86468,86558},
    [60] = {122383,122245,122263,122264,122265,122266,122349,122350,122351,122352,122353,122530,122377,122376,122375,122374,122373,122372,122371,122370,122369,122368,122367,122366,122365,122364,122363,122378,122379,122529,122396,122392,122391,122390,122389,122388,122387,122386,122385,122384,122354,122382,122381,122380,122362,122361,122360,122260,122259,122258,122257,122256,122255,122254,122253,122252,122251,122250,122249,122248,122247,122246,122261,122262,122359,122358,122357,122356,122355},
    [80] = {44098,92948,48677,44107,44105,44103,44102,44101,44100,48685,48687,48689,79131,69893,69890,69889,50255,48718,48716,48691,44099,48683,44097,42951,42950,42949,42948,42947,42946,42945,42944,42952,42984,42985,44096,44095,44094,44093,44092,44091,42992,42991,42943},
};

SIL_Heirlooms90100 = {105675,104399,105678,105679,105680,105683,105684,105685,105686,105687,105688,105689,105690,105691,105692,105676,105677,105674,104400,104401,104402,104403,104404,104405,104406,104407,104408,104409,105670,105671,105672,105673,105693}

-- LibDogTag Support
local LibDogTag = LibStub("LibDogTag-3.0", true);
if LibDogTag then
    LibDogTag:AddTag("Unit", "ItemLevel", {
           code = function(unit)
              local ilvl = SIL:Cache(UnitGUID(unit), 'score')
              if type(ilvl) == "number" then
                 return ilvl
              else
                 return ''
              end
           end,
           arg = {
              'unit', 'string;undef', 'player'
           },
           ret = "number;string",
           events = "UNIT_INVENTORY_CHANGED#$unit;INSPECT_READY#$unit",
           doc = "Return the item level of unit (from Simple iLevel)",
           example = ('[ItemLevel] => "%d"; [ItemLevel] => ""'):format(552.1),
           category = "Characteristics"
        }
    );
end