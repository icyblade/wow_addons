--[[
ToDo:
    - 
]]

local L = LibStub("AceLocale-3.0"):GetLocale("SimpleILevel", true);
SIL_Group = LibStub("AceAddon-3.0"):NewAddon('SIL_Group', "AceEvent-3.0", "AceTimer-3.0");
SIL_Group.autoscan = false;
SIL_Group.autoscanFailed = 0;
SIL_Group.autoscanLog = {};

function SIL_Group:OnInitialize()
    SIL:Print(L.group.load, GetAddOnMetadata("SimpleILevel_Group", "Version"));
    
    -- Additional Setup
    self:SetupSILMenu();
    self:AddSlash();
    
    self:UpdateGroup();
end

function SIL_Group:AddSlash()
    -- Update SIL_Options table
    SIL_Options.args.group = {
            name = L.group.options.group,
            desc = L.group.options.groupDesc,
            type = "input",
            guiHidden = true,
            set = function(i,v) dest, to = strsplit(' ', v, 2); SIL_Group:GroupOutput(dest, to); end,
            get = function() return ''; end,
        };
    SIL_Options.args.party = {
            name = L.group.options.group,
            desc = L.group.options.groupDesc,
            type = "input",
            hidden = true,
            set = function(i,v) dest, to = strsplit(' ', v, 2); SIL_Group:GroupOutput(dest, to); end,
            get = function() return ''; end,
        };
    SIL_Options.args.raid = SIL_Options.args.party;
end

function SIL_Group:SetupSILMenu()
    -- Add menu items
    SIL:AddMenuItems('top', {
        text = L.group.options.group, 
        textFunc = function() 
                local groupScore = SIL_Group:GroupScore();
                groupScore = SIL:FormatScore(groupScore);
                return L.group.options.group..' '..groupScore;
            end,
        notCheckable = 1,
        hasArrow = 1,
        value = 'SIL_Group',
        enabled = function() 
                local t = SIL_Group:GroupType();
                return t ~= 'solo';
            end,
    }, 1);
    
    -- Submenu Title
    SIL:AddMenuItems('top', {
        text = L.group.options.group,
        isTitle = 1,
        notCheckable = 1,
    }, 2, 'SIL_Group');
    
    
    -- System
    SIL:AddMenuItems('middle', {    
        text = CHAT_MSG_SYSTEM,
        func = function() SIL_Group:GroupOutput("SYSTEM"); end,
        notCheckable = 1,
    }, 2, 'SIL_Group');
    
    -- Party
    SIL:AddMenuItems('middle', {   
        text = CHAT_MSG_PARTY,
        func = function() SIL_Group:GroupOutput("PARTY"); end,
        notCheckable = 1,
        enabled = function() return IsInGroup(LE_PARTY_CATEGORY_HOME); end,
    }, 2, 'SIL_Group');
    
    -- Raid
    SIL:AddMenuItems('middle', {    
        text = CHAT_MSG_RAID,
        func = function() SIL_Group:GroupOutput("RAID"); end,
        notCheckable = 1,
        enabled = function() return IsInRaid(); end,
    }, 2, 'SIL_Group');
    
    -- Battleground
    SIL:AddMenuItems('middle', {    
        text = CHAT_MSG_BATTLEGROUND,
        func = function() SIL_Group:GroupOutput("BG"); end,
        notCheckable = 1,
        enabled = function() return UnitInBattleground("player"); end,
    }, 2, 'SIL_Group');

    -- Instance
    SIL:AddMenuItems('middle', {    
        text = INSTANCE_CHAT_MESSAGE,
        func = function() SIL_Group:GroupOutput("I"); end,
        notCheckable = 1,
        enabled = function() return IsInLFGDungeon(); end,
    }, 2, 'SIL_Group');
    
    -- Guild
    SIL:AddMenuItems('middle', {    
        text = CHAT_MSG_GUILD,
        func = function() SIL_Group:GroupOutput("GUILD"); end,
        notCheckable = 1,
        enabled = function() return IsInGuild(); end,
    }, 2, 'SIL_Group');
    
    -- Guild - Officer
    SIL:AddMenuItems('middle', {    
        text = CHAT_MSG_OFFICER,
        func = function() SIL_Group:GroupOutput("OFFICER"); end,
        notCheckable = 1,
        enabled = function() return SIL:CanOfficerChat(); end,
    }, 2, 'SIL_Group');
    
    -- Say
    SIL:AddMenuItems('middle', {    
        text = CHAT_MSG_SAY,
        func = function() SIL_Group:GroupOutput("SAY"); end,
        notCheckable = 1,
    }, 2, 'SIL_Group');
    
    -- Sums
    SIL:AddMenuItems('bottom', {    
        textFunc = function()
                local groupAvg, groupSize, groupMin, groupMax = SIL_Group:GroupScore();
                groupMin = SIL:FormatScore(groupMin);
                groupAvg = SIL:FormatScore(groupAvg);
                groupMax = SIL:FormatScore(groupMax);
                
                return groupMin..' '..groupAvg..' '..groupMax;
            end,
        notCheckable = 1,
        disabled = 1,
    }, 2, 'SIL_Group');
end

-- Popupdate SIL_Group.group
function SIL_Group:UpdateGroup(startAutoscan)
    
    SIL:UpdateGroup();
    
    -- Make sure we are in a group
    if 1 < #SIL.group and SIL:GetAutoscan() then
        
        -- Start autoscan
        if not self.autoscan and startAutoscan then
            self:AutoscanStart();
        else
            self:Autoscan();
        end
    end
end

-- Sumerize SIL_Group
function SIL_Group:GroupScore()
    self:UpdateGroup();
    
    local playerScore = SIL:Cache(UnitGUID('player'), 'score');
    local groupSize = 0;
    local totalScore = 0;
    local groupMin = playerScore;
    local groupMax = playerScore;
    
    for junk1,guid in pairs(SIL.group) do
        local score = SIL:Cache(guid, 'score');
        
        if score and score ~= 0 then
            groupSize = groupSize + 1;
            totalScore = totalScore + score;
            
            if score < groupMin then groupMin = score; end
            if score > groupMax then groupMax = score; end
        end
    end
    
    -- SIL:UpdateLDB();
    local groupAvg = totalScore / groupSize;
    return groupAvg, groupSize, groupMin, groupMax;
end

function SIL_Group:GroupOutput(dest, to)
    --if InCombatLockdown() then return false; end
    
    self:UpdateGroup(true); -- Get the scores updated
    local groupAvg, groupSize, groupMin, groupMax = self:GroupScore(true);
    local dest, to, color = SIL:GroupDest(dest, to);
    local rough = false;
    
	groupAvgFmt = SIL:FormatScore(groupAvg, 16, color);
    
	SIL:PrintTo(format(L.group.outputHeader, groupAvgFmt), dest, to);
    
    -- Sort by score
    table.sort(SIL.group, function(...) return SIL_Group:SortScore(...); end);
    
    for junk1,guid in ipairs(SIL.group) do
		local name = SIL:Cache(guid, 'name');
		local items = SIL:Cache(guid, 'items');
		local score = SIL:Cache(guid, 'score');
        local class = SIL:Cache(guid, 'class');
        local age = SIL:Cache(guid, 'age');
        local str = '';
        
		if color then
            name = '|cFF'..SIL:RGBtoHex(RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b)..name..'|r';
        end
            
		if score and tonumber(score) and 0 < score then
            str = format('%s - %s', name, SIL:FormatScore(score, items, color));
            
            if items <= SIL.grayScore then
                str = str..' *';
                rough = true;
            elseif (SIL:GetAge() * 2) <= age then
                str = str..' *';
                rough = true;
            end
		else
            str = format(L.group.outputNoScore, name);
        end
        
		SIL:PrintTo(str, dest, to);
	end
    
    if rough then
        SIL:PrintTo(L.group.outputRough, dest, to);
    end
end

-- Figure out the type of group we are in
function SIL_Group:GroupType()
    local name, itype = GetInstanceInfo();
    
    if itype == 'arena' then
        return 'arena', ARENA;
    elseif UnitInBattleground("player") then
        return 'battleground', CHAT_MSG_BATTLEGROUND;
    elseif UnitInRaid("player") then
        return 'raid', CHAT_MSG_RAID;
    elseif GetNumSubgroupMembers() > 0 then
        return 'party', CHAT_MSG_PARTY;
    else
        return 'solo', UnitName('player');
    end
end

function SIL_Group:SortScore(a, b)
    scoreA = SIL:Cache(a, 'score') or 0;
    scoreB = SIL:Cache(b, 'score') or 0;
    
    return scoreA > scoreB;
end

--[[
    Automatic scanning methods
]]
function SIL_Group:Autoscan(autoscan)
    if InCombatLockdown() then return end
    
    -- Check that we have a good group values
    if type(SIL.group) ~= 'table' or #SIL.group == 0 then
        self:UpdateGroup();
    end
    
    -- Stop if we are all alone :(
    if autoscan and 1 == #SIL.group then self:AutoscanStop(); end
    
    -- Get the worst score in the group
    local target, reason, value = self:AutoscanNext(autoscan);
    
    if target then
        local guid = UnitGUID(target);
        self.autoscanLog[guid] = self.autoscanLog[guid] + 1;
        
        SIL:Debug('Found someone to Scan!', UnitName(target), target, reason, value);
        
        SIL:GetScoreTarget(target, true);
        
        -- Reset failed
        self.autoscanFailed = 0;
        
    -- Bummer :(
    else
        if autoscan then
            self.autoscanFailed = self.autoscanFailed + 1;
            
            if self.autoscanFailed >= 2 then
                SIL:Debug('Autscan Failed', self.autoscanFailed);
                self:AutoscanStop();
            end
        end
    end
end

function SIL_Group:AutoscanNext()
    
    -- Macro to clear the score of everyone in your group and reset SIL_Group
    -- /run for _,g in pairs(SIL_Group.group) do SIL_CacheGUID[g]=nil; end SIL_Group.group={}; SIL_Group.autoscanLog={}; SIL.debug=true; SIL_Group:UpdateGroup();
    
    local yourScore = SIL:GetScoreTarget('player', false) or 100;
    
    -- Set some high min values
    local lowItems = SIL.grayScore * 1.5;            -- currently 8 * 1.5 = 12 items
    local lowScore = yourScore / 2;                  -- this should scale well while leveling
    local oldScore = time() - (SIL:GetAge() * 0.75); -- 75% of max age
    
    local lowItemsT = false;
    local lowScoreT = false;
    local oldScoreT = false;
    
    -- Loop
    for junk1,guid in pairs(SIL.group) do
        local target = SIL:Cache(guid, 'target');
        
        if not self.autoscanLog[guid] then
            self.autoscanLog[guid] = 0;
        end
        
        if CanInspect(target) and CheckInteractDistance(target, 1) and self.autoscanLog[guid] <= 3 and not UnitIsUnit('player', target) then
            
            local items = SIL:Cache(guid, 'items') or 0;
            local score = SIL:Cache(guid, 'score') or 0;
            local time = SIL:Cache(guid, 'time') or 0;
            
            -- SIL:Debug(SIL:Cache(guid, 'name'), items, score, time);
            
            -- Items
            if items < lowItems then
                lowItems = items;
                lowItemsT = target;
            end
            
            -- Score
            if score < lowScore then
                lowScore = score;
                lowScoreT = target;
            end
            
            -- Age
            if time < oldScore then
                oldScore = time;
                oldScoreT = target;
            end
        end
    end
    
    -- Figure out the person
    if lowItemsT then
        return lowItemsT, 'items', lowItems;
    elseif lowScoreT then
        return lowScoreT, 'score', lowScore;
    elseif oldScoreT then
        return oldScoreT, 'age', oldScore;
    else
        return false;
    end
end

function SIL_Group:AutoscanStart()
    if not self.autoscan and SIL:GetAutoscan() then 
        self.autoscan = self:ScheduleRepeatingTimer(function() 
            if not InCombatLockdown() then 
                SIL:Debug('Autoscaning...'); 
                SIL_Group:Autoscan(true); 
            end 
        end, 5);
    end
end

function SIL_Group:AutoscanStop()
    if self.autoscan then
        self:CancelTimer(self.autoscan, true);
        self.autoscan = false;
        self.autoscanFailed = 0;
    end
end

function SIL_Group:InTable(tabl, value, continue)
    local found = false;
    local keys = {};
    
    for i,v in pairs(tabl) do
        if v == s then
            
            if continue then
                found = true;
                keys = i;
                
                return true, i;
            else
                found = true;
                table.insert(keys, i);
            end
        end
    end
    
    return found, keys;
end