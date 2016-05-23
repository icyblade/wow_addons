--[[
ToDo:
    - Move more Group Functionality to here
        * Autoscan
        * SIL_Group:GroupType();
    - On UpdateGroup if there is no data do a rough scan
    - Group methods within this file
    - Better way to hooking tooltips
    -
]]

local L = LibStub("AceLocale-3.0"):GetLocale("SimpleILevel", true);

-- Start SIL
SIL = LibStub("AceAddon-3.0"):NewAddon(L.core.name, "AceEvent-3.0", "AceConsole-3.0", "AceTimer-3.0");
SIL.category = GetAddOnMetadata("SimpleILevel", "X-Category");
SIL.version = GetAddOnMetadata("SimpleILevel", "Version");
SIL.versionMajor = 3;                    -- Used for cache DB versioning
SIL.versionRev = 'r235';    -- Used for version information
SIL.action = {};        -- DB of unitGUID->function to run when a update comes through
SIL.hooks = {};         -- List of hooks in [type][] = function;
SIL.autoscan = 0;       -- time() value of last autoscan, must be more then 1sec
SIL.lastScan = {};      -- target = time();
SIL.grayScore = 7;      -- Number of items to consider gray/aprox
SIL.ldbAuto = false;    -- AceTimer for LDB
SIL.menu = false;       -- Menu frame
SIL.menuItems = {       -- Table for the dropdown menu
    top = {},
    middle = {},
    bottom = {},
};
SIL.modules = {};       -- Modules
SIL.group = {};         -- Group Members by guid
--SIL.L = L;              -- Non-local locals

-- Load Libs
SIL.aceConfig = LibStub:GetLibrary("AceConfig-3.0");
SIL.aceConfigDialog = LibStub:GetLibrary("AceConfigDialog-3.0");
SIL.inspect = LibStub:GetLibrary("LibInspect");
SIL.ldb = LibStub:GetLibrary("LibDataBroker-1.1");
SIL.ldbIcon = LibStub:GetLibrary("LibDBIcon-1.0");
SIL.callback = LibStub("CallbackHandler-1.0"):New(SIL);
SIL.itemUpgrade = LibStub("LibItemUpgradeInfo-1.0");

-- OnLoad
function SIL:OnInitialize()

    -- Make sure everything is ok with the db
    if not SIL_CacheGUID or type(SIL_CacheGUID) ~= 'table' then SIL_CacheGUID = {}; end
    
    -- Tell the player we are being loaded
	self:Print(format(L.core.load, self.version));
    self:ModulesProcess();
        
    -- Load settings
    self.db = LibStub("AceDB-3.0"):New("SIL_Settings", SIL_Defaults, true);
	self:UpdateSettings();
	
    -- Set Up LDB
    local ldbObj = {
        type = "data source",
        icon = "Interface\\Icons\\inv_misc_armorkit_24",
        label = L.core.name,
        text = 'n/a',
        category = self.category,
        version = self.version,
        OnClick = function(...) SIL:MenuOpen(...); end,
        OnTooltipShow = function(tt)
                            if SIL:GetLDB() and SIL.ldb.text then
                                tt:AddLine(SIL.ldb.text);
                            end
                            
                            tt:AddLine(L.core.minimapClick);
                            tt:AddLine(L.core.minimapClickDrag);
            end,
    };
    
    -- Set back to a launcher if text is off
	if not self:GetLDB() then
		ldbObj.type = 'launcher';
		ldbObj.text = nil;
	end
    
    -- Start LDB
	self.ldb = self.ldb:NewDataObject(L.core.name, ldbObj);
	self.ldbUpdated = 0;
	self.ldbLable = '';
    
    -- Start the minimap icon
	self.ldbIcon:Register(L.core.name, self.ldb, self.db.global.minimap);
    
    -- Register Options
	SIL_Options.args.purge.desc = format(L.core.options.purgeDesc, self:GetPurge() / 24);
	self.aceConfig:RegisterOptionsTable(L.core.name, SIL_Options, {"sil", "silev", "simpleilevel"});
	self.aceConfigDialog:AddToBlizOptions(L.core.name);
    
    -- Add Hooks
    self.inspect:AddHook(L.core.name, 'items', function(...) SIL:ProcessInspect(...); end);
    GameTooltip:HookScript("OnTooltipSetUnit", function(...) SIL:TooltipHook(...); end);
    self:Autoscan(self:GetAutoscan());
    
    -- Events
    self:RegisterEvent("PLAYER_TARGET_CHANGED", function() if CanInspect('target') then SIL:GetScoreTarget('target'); end end);
    self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", function() SIL:ShowTooltip(); end);
    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", function() SIL:StartScore('player'); end);
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function() SIL:UpdateLDB(); end);
    self:RegisterEvent("GROUP_ROSTER_UPDATE", function() SIL:UpdateGroup() end);
    
    -- Add to Paperdoll - not relevent as of 4.3, well see
    --[[ -- Melons: cause error in legion
    table.insert(PAPERDOLL_STATCATEGORIES["GENERAL"].stats, L.core.name);
	if self:GetPaperdoll() then
		PAPERDOLL_STATINFO[L.core.name] = { updateFunc = function(...) SIL:UpdatePaperDollFrame(...); end };
	else
		PAPERDOLL_STATINFO[L.core.name] = nil;
	end]]
    
    -- GuildMemberInfo
    if GMI then
        GMI:Register("SimpleILevel", {
            lines = {
                    SimpleILevel = {
                        label = L.core.name,
                        default = 'n/a',
                        callback = function(name) return SIL:GMICallback(name); end,
                    },
                },
            }); 
    end
    
    -- Clear the cache
	self:AutoPurge(true);
    
    -- Build the menu
    self:MenuInitialize();
    
    -- Get working on a score for the player
    self:StartScore('player');
    self:LDBSetAuto();
    self:UpdateLDB(); -- This may cause excesive loading time...
    
    -- Process modules
    self:ModulesLoad();
    
    -- Localization Notice
    if GetLocale() == 'itIT' or GetLocale() == 'esMX' or GetLocale() == 'esES' then
        self:Print("Help Localize Simple iLevel! http://j.mp/localSIL")
    end
end

-- Make sure the database is the latest version
function SIL:UpdateSettings()
    
    if self.db.global.version == self.versionMajor then
        -- Same version
    elseif self.db.global.version > 2.4 and self.db.global.version < 2.5 then
        for guid,info in pairs(SIL_CacheGUID) do
            SIL_CacheGUID[guid].guid = nil;
        end
    elseif self.db.global.version < 2.4 then
        for guid,info in pairs(SIL_CacheGUID) do
            SIL_CacheGUID[guid].total = nil;
            SIL_CacheGUID[guid].tooltip = nil;
            
            SIL_CacheGUID[guid].level = 85; --ASSuME
            --SIL_CacheGUID[guid].guid = guid;
        end
    end
    
    -- Update version information
    self.db.global.version = self.versionMajor;
end

function SIL:AutoPurge(silent)
	if self:GetPurge() > 0 then
		local count = self:PurgeCache(self:GetPurge());
		
		if not silent then
			self:Print(format(L.core.purgeNotification, count));
		end
		
		return count;
	else
		if not silent then
			self:Print(L.core.purgeNotificationFalse);
		end
		
		return false;
	end
end

function SIL:PurgeCache(hours)
	if tonumber(hours) then
		local maxAge = time() - (tonumber(hours) * 3600);
		local count = 0;
		
		for guid,info in pairs(SIL_CacheGUID) do
			if type(info.time) == "number" and info.time < maxAge then
				SIL_CacheGUID[guid] = nil;
				count = 1 + count;
                
                self:RunHooks('purge', guid);
			end
		end
		
		return count;
	else
		return false;
	end
end

function SIL:AddHook(hookType, callback)
	local hookType = strlower(hookType);
	
    if not self.hooks[hookType] then
        self.hooks[hookType] = {};
    end
    
	table.insert(self.hooks[hookType], callback);
end

function SIL:RunHooks(hookType, ...)
    local r = {};
    
    if self.hooks[hookType] then
        for i,callback in pairs(self.hooks[hookType]) do
            local ret = callback(...);
            
            if ret then
                table.insert(r, callback(...));
            end
        end
        
        if #r > 0 then
            return r;
        else
            return true;
        end
    else
        return false;
    end
end

--[[
    
    Event Handlers
    
]]
function SIL:UNIT_INVENTORY_CHANGED(e, unitID)
    --print('UNIT_INVENTORY_CHANGED'); 
	if InCombatLockdown() then return end
	
	if unitID and CanInspect(unitID) and not UnitIsUnit('player', unitID) and self.autoscan ~= time() then
        self.autoscan = time();
        
		self:StartScore(unitID);
	end
end

-- Used to hook the tooltip to avoid the full tooltip function
function SIL:TooltipHook()
	local name, unit = GameTooltip:GetUnit();
	local guid = false;
	
	if unit then
		guid = UnitGUID(unit);
	elseif name then
		guid = self:NameToGUID(name);
	end
	
	if self:IsGUID(guid, 'Player') then
		self:ShowTooltip(guid);
    end
end

function SIL:Autoscan(toggle)
	if toggle then
		self:RegisterEvent("UNIT_INVENTORY_CHANGED");
	else 
		self:UnregisterEvent("UNIT_INVENTORY_CHANGED");
	end
	
	self.db.global.autoscan = toggle;
end

--[[

    Slash Handlers
    
]]
-- Reset the settings
function SIL:SlashReset()
	self:Print(L.core.slashClear);
	self.db:RegisterDefaults(SIL_Defaults);
	self.db:ResetDB('Default');
	self:SetMinimap(true);
    
    -- Clear the cache
    SIL_CacheGUID = {};
    self:GetScoreTarget('player', true);
    
    -- Update version information
    self.db.global.version = self.versionMajor;
    
    self:RunHooks('clear');
end

function SIL:SlashGet(name)
    
    -- Get score by name
    if name and not (name == '' or name == 'target') then
        local score, age, items = self:GetScoreName(name);
        
        if score then
			local name = self:Cache(self:NameToGUID(name), 'name')
            
			self:Print(format(L.core.slashGetScore, name, self:FormatScore(score, items), self:AgeToText(age)));
            
        -- Nothing :(
        else
            self:Print(format(L.core.slashGetScoreFalse, name));
        end
    
    -- no name but we can inspect the current target
    elseif CanInspect('target') then
        self:SlashTarget();
    
    -- why do you ask so much of me but make no sence
    else
        self:Print(L.core.slashTargetScoreFalse);
    end
end

function SIL:SlashTarget()
    self:StartScore('target', function(...) SIL:SlashTargetPrint(...); end);
end

function SIL:SlashTargetPrint(guid, score, items, age)
    if guid and score then
        local name = self:GUIDtoName(guid);
        
        if name then
            self:Print(format(L.core.slashTargetScore, name, self:FormatScore(score, items)));
        else
            self:Debug("No name for guid", guid, "score", score, items, age);
        end
    else
        self:Print(L.core.slashTargetScoreFalse);
    end
end

--[[

    Basic Functions

]]
function SIL:GUIDtoName(guid)
	if guid and self:IsGUID(guid, 'Player') and self:Cache(guid) then
		return self:Cache(guid, 'name'), self:Cache(guid, 'realm');
	else
		return false;
	end
end

function SIL:NameToGUID(name, realm)
	if not name then return false end
	
	-- Try and get the realm from the name-realm
	if not realm then
		name, realm = strsplit('-', name, 2);
	end
	
	-- If no realm then set it to current realm
	if not realm or realm == '' then
		realm = GetRealmName();
	end
	
	if name then
		name = strlower(name);
		local likely = false;
        
		for guid,info in pairs(SIL_CacheGUID) do
			if strlower(info.name) == name and info.realm == realm then
				return guid;
            elseif strlower(info.name) == name then
                likely = guid;
            end
		end
        
        if likely then
            return likely;
        end
	end
	
	return false;
end

-- Get a GUID from just about anything
function SIL:GetGUID(target)
    if target then
        if tonumber(target) then
            return target;
        elseif UnitGUID(target) then
            return UnitGUID(target);
        else
            return SIL:NameToGUID(target);
        end
    else
        return false;
    end
end

-- Clear score
function SIL:ClearScore(target)
	local guid = self:GetGUID(target);
	
	if SIL_CacheGUID[guid] then
		SIL_CacheGUID[guid].score = false;
		SIL_CacheGUID[guid].items = false;
		SIL_CacheGUID[guid].time = false;
		
        self:RunHooks('purge', guid);
        
		return true;
	else
		return false;
	end
end;

function SIL:AgeToText(age, color)
    if type(color) == 'nil' then color = true; end
    local hex = "00ff00";
	
	if type(age) == 'number' then
		if age > 86400 then
			age = self:Round(age / 86400, 2);
			str = L.core.ageDays;
			hex = "ff0000";
		elseif age > 3600 then
			age = self:Round(age / 3600, 1);
			str = L.core.ageHours;
			hex = "33ccff";
		elseif age > 60 then
			age = self:Round(age / 60, 1);
			str = L.core.ageMinutes;
			hex = "00ff00";
		else
			age = age;
			str = L.core.ageSeconds;
			hex = "00ff00";
		end
		
		if color and self:GetColorScore() then
			return format(str, '|cFF'..hex..age..'|r');
		else
			return format(str, age);
		end
	else
		return 'n/a';
	end
end

-- print a message to channel or whisper player/channel
function SIL:PrintTo(message, channel, to)
	if channel == "print" or channel == "SYSTEM" then
		self:Print(message);
	elseif channel == "WHISPER" then
		SendChatMessage(message, 'WHISPER', nil, to);
	elseif channel == "CHANNEL" then
		SendChatMessage(message, 'CHANNEL', nil, to);
	elseif channel then
		SendChatMessage(message, channel);
	else
		self:Print(message);
	end
end

function SIL:Debug(...)
	if SIL.db.char.debug then
		print('|cFFFF0000SIL Debug:|r ', ...);
	end
end

--[[

    Core Functionality
    
]]
-- Get someones score
function SIL:GetScore(guid, attemptUpdate, target, callback)
    if not self:IsGUID(guid, 'Player') then return false; end
    
	if self:Cache(guid) and self:Cache(guid, 'score') then
		local score = self:Cache(guid, 'score');
		local age = self:Cache(guid, 'age') or time();
		local items = self:Cache(guid, 'items');
		local startScore = nil;
        
        -- If a target was passed and we are over age
        if target and (attemptUpdate or self:GetAge() < age) and self.autoscan ~= time() then
            startScore = self:StartScore(target, callback);
        end
        
		return score, age, items, startScore;
	else
        
        -- If a target was passed
        if target then
            self:StartScore(target);
        end
        
        return false;
	end
end

-- Wrapers for get score, more specialized code may come
function SIL:GetScoreName(name, realm)
    local guid = self:NameToGUID(name, realm);
    return self:GetScore(guid);
end

function SIL:GetScoreTarget(target, force, callback)
    local guid = UnitGUID(target);
    return self:GetScore(guid, force, target, callback);
end

function SIL:GetScoreGUID(guid)
    return self:GetScore(guid);
end

-- Request items to update a score
function SIL:StartScore(target, callback)
    if InCombatLockdown() or not CanInspect(target) then 
        if callback then callback(false, target); end
        return false;
    end
    
    self.autoscan = time();
    local guid = self:AddPlayer(target);
    
    if not self.lastScan[target] or self.lastScan[target] ~= time() then
        if guid then
            self.action[guid] = callback;
            self.lastScan[target] = time();
            
            local canInspect = self.inspect:RequestItems(target, true);
            
            if not canInspect and callback then
                callback(false, target);
            else
                return true;
            end
        end
    end
    
    if callback then callback(false, target); end
    return false;
end

function SIL:ProcessInspect(guid, data, age)
    if guid and self:Cache(guid) and type(data) == 'table' and type(data.items) == 'table' then
        
        local totalScore, totalItems = self:GearSum(data.items, self:Cache(guid, 'level'));
        
        if totalItems and 0 < totalItems then
            
            -- Update the DB
            local score = totalScore / totalItems;
            self:SetScore(guid, score, totalItems, age)
            
            -- Update LDB
            if self:GetLDB() and guid == UnitGUID('player') then
                self:UpdateLDB(true);
            else
                self:UpdateLDB(false);
            end
            
            -- Run Hooks
            self:RunHooks('inspect', guid, score, totalItems, age, data.items);
            
            -- Run any callbacks for this event
            if self.action[guid] then
                self.action[guid](guid, score, totalItems, age, data.items, self:Cache(guid, 'target'));
                self.action[guid] = false;
            end
            
            -- Update the Tooltip
            self:ShowTooltip();
            
            return true;
        end
    end
end

function SIL:GearSum(items, level)
    if items and level and type(items) == 'table' then
        local totalItems = 0;
        local totalScore = 0;
        
        -- Melons: legion artifact rework
        --[[
        for i,itemLink in pairs(items) do
            if itemLink and not ( i == INVSLOT_BODY or i == INVSLOT_RANGED or i == INVSLOT_TABARD ) then
                -- local name, link, itemRarity , itemLevel = GetItemInfo(itemLink);
                local itemLevel = self.itemUpgrade:GetUpgradedItemLevel(itemLink);

                --- print(i, itemLevel, itemLink);
                
                if itemLevel then
                    
                    -- Fix for heirlooms
                    if itemRarity == 7 then
                        itemLevel = self:Heirloom(level, itemLink);
                    end
                    
                    totalItems = totalItems + 1;
                    totalScore = totalScore + itemLevel;
                end
            end
        end]]
        

        if HasArtifactEquipped() then
            for i,itemLink in pairs(items) do
                if not ( i == INVSLOT_BODY or i == INVSLOT_RANGED or i == INVSLOT_TABARD or i == INVSLOT_MAINHAND or i == INVSLOT_OFFHAND ) then
                    if itemLink ~= '' then
                        local itemLevel = self.itemUpgrade:GetUpgradedItemLevel(itemLink);

                        if itemLevel then
                            
                            -- Fix for heirlooms
                            if itemRarity == 7 then
                                itemLevel = self:Heirloom(level, itemLink);
                            end
                            
                            totalItems = totalItems + 1;
                            totalScore = totalScore + itemLevel;
                        end
                    else
                        totalItems = totalItems + 1;
                    end
                end
            end

            if items[INVSLOT_MAINHAND] ~= '' and items[INVSLOT_OFFHAND] ~= '' then
                -- has dual artifact
                local mainhand_itemLevel = self.itemUpgrade:GetUpgradedItemLevel(items[INVSLOT_MAINHAND]);
                local offhand_itemLevel = self.itemUpgrade:GetUpgradedItemLevel(items[INVSLOT_OFFHAND]);
                local itemLevel = max(mainhand_itemLevel, offhand_itemLevel)
                
                totalItems = totalItems + 2
                totalScore = totalScore + itemLevel*2
            else
                -- has only on artifact
                totalItems = totalItems + 1
                totalScore = totalScore + self.itemUpgrade:GetUpgradedItemLevel(items[INVSLOT_MAINHAND]);
            end
        else
            for i,itemLink in pairs(items) do
                if not ( i == INVSLOT_BODY or i == INVSLOT_RANGED or i == INVSLOT_TABARD ) then
                    if itemLink ~= '' then
                        local itemLevel = self.itemUpgrade:GetUpgradedItemLevel(itemLink);
          
                        if itemLevel then
                            
                            -- Fix for heirlooms
                            if itemRarity == 7 then
                                itemLevel = self:Heirloom(level, itemLink);
                            end
                            
                            totalItems = totalItems + 1;
                            totalScore = totalScore + itemLevel;
                        end
                    else
                        totalItems = totalItems + 1
                    end
                end
            end
        end
        
        return totalScore, totalItems;
    else
        return false;
    end
end

-- Thanks to Ro of Hyjal-US http://us.battle.net/wow/en/forum/topic/7199032730#9
function SIL:GetActualItemLevelOld(link)
    -- Updated for 5.4.8
    local levelAdjust={ -- 11th item:id field and level adjustment
        ["0"]=0,["1"]=8,["373"]=4,["374"]=8,["375"]=4,["376"]=4,
        ["377"]=4,["379"]=4,["380"]=4,["445"]=0,["446"]=4,["447"]=8,
        ["451"]=0,["452"]=8,["453"]=0,["454"]=4,["455"]=8,["456"]=0,
        ["457"]=8,["458"]=0,["459"]=4,["460"]=8,["461"]=12,["462"]=16,
        ["465"]=0,["466"]=4,["467"]=8,["469"]=4,["470"]=8,["471"]=12,
        ["472"]=16,["491"]=0,["492"]=4,["493"]=8,["494"]=4,["495"]=8,
        ["496"]=8,["497"]=12,["498"]=16,["504"]=12,["505"]=16,["506"]=20,
        ["507"]=24,
    }
    local baseLevel = select(4,GetItemInfo(link))
    local upgrade = link:match(":(%d+)\124h%[")
    if baseLevel and upgrade and levelAdjust[upgrade] then
        local newLevel = baseLevel + levelAdjust[upgrade];
        return newLevel
    else
        return baseLevel
    end
end

-- /run for i=1,25 do t='raid'..i; if UnitExists(t) then print(i, UnitName(t), CanInspect(t), SIL:RoughScore(t)); end end
function SIL:RoughScore(target)
    if not target then return false; end
    if not CanInspect(target) then return false; end
    
    -- Get stuff in order
    local guid = self:AddPlayer(target)
    self.inspect:AddCharacter(target);
    NotifyInspect(target);
    
    -- Get items and sum
    local items = self.inspect:GetItems(target);
    local totalScore, totalItems = self:GearSum(items, UnitLevel(target));
    
    if totalItems and totalItems > 0 then
        local score = totalScore / totalItems;
        -- self:Debug('SIL:RoughScore', UnitName(target), score, totalItems);
        
        -- Set a score even tho its crap
        if guid and self:Cache(guid) and (not self:Cache(guid, 'score') or self:Cache(guid, 'items') < totalItems) then
            self:SetScore(guid, score, 1, self:GetAge() + 1);
        end
        
        return score, 1, self:GetAge() + 1;
    else
        return false;
    end
end

-- Start or update the DB for a player
function SIL:AddPlayer(target)  
    local guid = UnitGUID(target);
    
    if guid then
        local name, realm = UnitName(target);
        local className, class = UnitClass(target);
        local level = UnitLevel(target);
        
        if not realm then
            realm = GetRealmName();
        end
        
        if name and realm and class and level then
            
            -- Start a table for them
            if not SIL_CacheGUID[guid] then
                SIL_CacheGUID[guid] = {};
            end
            
            SIL_CacheGUID[guid].name = name;
            SIL_CacheGUID[guid].realm = realm;
            SIL_CacheGUID[guid].class = class;
            SIL_CacheGUID[guid].level = level;
            SIL_CacheGUID[guid].target = target;
            
            if not SIL_CacheGUID[guid].score or SIL_CacheGUID[guid].score == 0 then
                SIL_CacheGUID[guid].score = false;
                SIL_CacheGUID[guid].items = false;
                SIL_CacheGUID[guid].time = false;
            end
            
            return guid;
        else
            return false;
        end
    else
        return false;
    end
end

function SIL:SetScore(guid, score, items, age)
    local t = age;
    
    if age and type(age) == 'number' and age < 86400 then
        t = time() - age; 
    end
    
    SIL_CacheGUID[guid].score = score;
    SIL_CacheGUID[guid].items = items;
    SIL_CacheGUID[guid].time = t;
    self:Debug("SetScore", self:GUIDtoName(guid), self:FormatScore(score, items), items, age)
end

-- Get a relative iLevel on Heirlooms
function SIL:Heirloom(level, itemLink)
	--[[
		Here is how I came to the level 81-85 bracket
		200 = level of 80 instance gear
		333 = level of 85 instance gear
		333 - 200 = 133 iLevels / 5 levels = 26.6 iLevel per level
		so then that means for a level 83
		83 - 80 = 3 * 26.6 = 79.8 + 200 = 279.8 iLevel
	]]
	
	-- Check for Wrath Heirlooms that max at 80
	if level > 80 then
		local _, _, _, _, itemId = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?");
		itemId = tonumber(itemId);
		
		-- Downgrade it to 80 if found
		for k,iid in pairs(SIL_Heirlooms[80]) do
			if iid == itemId then
				level = 80;
			end
		end
        
        -- There are currently no 1-90 Heirlooms
        if level > 85 then
            level = 85
        end
	end
	
	if level > 80 then
		return (( level - 80) * 26.6) + 200;
	elseif level > 70 then
		return (( level - 70) * 10) + 100;
	elseif level > 60 then
		return (( level - 60) * 4) + 60;
	else
		return level;
	end
end

-- Format the score for color and round it to xxx.x
function SIL:FormatScore(score, items, color)
    if not items then items = self.grayScore + 1; end
    if type(color) == 'nil' then color = true; end
    
    if tonumber(score) and tonumber(items) then
        local scoreR
        
        if self:GetRoundScore() then
            scoreR = self:Round(tonumber(score), 0);
        else
            scoreR = self:Round(tonumber(score), 1);
        end
        
		if color then
            local hexColor = self:ColorScore(score, items);
            
            
            
			return '|cFF'..hexColor..scoreR..'|r';
		else
			return scoreR;
		end
	else
		return 'n/a';
	end
end

-- Return the hex, r, g, b of a score
function SIL:ColorScore(score, items)
	
    -- There are some missing items so gray
	if items and items <= self.grayScore then
		return self:RGBtoHex(0.5,0.5,0.5), 0.5,0.5,0.5;
    end
    
    if not self:GetColorScore() then
        return self:RGBtoHex(1,1,1), 1,1,1;
    end
    
    -- Default to white
	local r,g,b = 1,1,1;
	
	local found = false;
	
	for i,maxScore in pairs(SIL_ColorIndex) do
		if score < maxScore and not found then
			local colors = SIL_Colors[maxScore];
			local baseColors = SIL_Colors[colors.p];
			
			local steps = maxScore - colors.p;
			local scoreDiff = score - colors.p;
			
			local diffR = (baseColors.r - colors.r) / 255;
			local diffG = (baseColors.g - colors.g) / 255;
			local diffB = (baseColors.b - colors.b) / 255;
			
			local diffStepR = diffR / steps;
			local diffStepG = diffG / steps;
			local diffStepB = diffB / steps;
			
			local scoreDiffR = scoreDiff * diffStepR;
			local scoreDiffG = scoreDiff * diffStepG;
			local scoreDiffB = scoreDiff * diffStepB;
			
			r = (baseColors.r / 255) - scoreDiffR;
			g = (baseColors.g / 255) - scoreDiffG;
			b = (baseColors.b / 255) - scoreDiffB;
			
			found = true;
		end
	end
	
	-- Nothing was found so max
	if not found then
		r = SIL_Colors[1000].r;
		g = SIL_Colors[1000].g;
		b = SIL_Colors[1000].b;
	end
	
    local hex = self:RGBtoHex(r,g,b);
	return hex, r, g, b;
end

function SIL:ShowTooltip(guid)
    if InCombatLockdown() and not self:GetTTCombat() then return end
    
	if not guid then
		guid = UnitGUID("mouseover");
	end
    
	local score, age, items = self:GetScoreGUID(guid);
    
	if score then
        
		-- Build the tooltip text
		local textLeft = '|cFF216bff'..L.core.ttLeft..'|r ';
		local textRight = self:FormatScore(score, items, true);
		
		local textAdvanced = format(L.core.ttAdvanced, self:AgeToText(age, true));
		
		self:AddTooltipText(textLeft, textRight, textAdvanced);
		
		-- Run Hooks
        self:RunHooks('tooltip', guid);
		
		return true;
	else
		return false;
	end
end

-- Add lines to the tooltip, testLeft must be the same
function SIL:AddTooltipText(textLeft, textRight, textAdvanced, textAdvancedRight)
	
	-- Loop tooltip text to check if its alredy there
	local ttLines = GameTooltip:NumLines();
	local ttUpdated = false;
	
	for i = 1,ttLines do
        
		-- If the static text matches
		if _G["GameTooltipTextLeft"..i]:GetText() == textLeft then
			
			-- Update the text
			_G["GameTooltipTextLeft"..i]:SetText(textLeft);
			_G["GameTooltipTextRight"..i]:SetText(textRight);
			GameTooltip:Show();
			
			-- Update the advanced info too
			if self.db.global.advanced and textAdvanced then
                
                if textAdvancedRight then
                    _G["GameTooltipTextLeft"..i]:SetText(textAdvanced);
                    _G["GameTooltipTextRight"..i]:SetText(textAdvancedRight);
                else
                    _G["GameTooltipTextLeft"..i+1]:SetText(textAdvanced);
                end
                
				GameTooltip:Show();
			end
			
			-- Remember that we have updated the tool tip so we won't again
			ttUpdated = true;
			break;
		end
	end
	
	-- Tooltip is new
	if not ttUpdated then
		
		GameTooltip:AddDoubleLine(textLeft, textRight);
		GameTooltip:Show();
		
		if self.db.global.advanced and textAdvanced then
            if textAdvancedRight then
                GameTooltip:AddDoubleLine(textAdvanced, textAdvancedRight);
            else
                GameTooltip:AddLine(textAdvanced);
            end
            
			GameTooltip:Show();
		end
	end
end

function SIL:UpdatePaperDollFrame(statFrame, unit)
    local score, age, items = self:GetScoreTarget(unit, true);
    local formated = self:FormatScore(score, items, false);
    
    PaperDollFrame_SetLabelAndText(statFrame, L.core.name, formated, false);
    statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..L.core.name..FONT_COLOR_CODE_CLOSE;
    statFrame.tooltip2 = L.core.scoreDesc;
    
    statFrame:Show();
end

--[[

    Setters, Getter and Togglers

]]

-- Set
function SIL:SetAdvanced(v) self.db.global.advanced = v; end
function SIL:SetLabel(v) self.db.global.showLabel = v; self:UpdateLDB(); end
function SIL:SetAutoscan(v) self.db.global.autoscan = v; self:Autoscan(v); end
function SIL:SetAge(seconds) self.db.global.age = seconds; end
function SIL:SetLDBlabel(v) self.db.global.ldbLabel = v; self:UpdateLDB(true); end
function SIL:SetLDBrefresh(v) self.db.global.ldbRefresh = v; self:LDBSetAuto() end
function SIL:SetTTCombat(v) self.db.global.ttCombat = v; end
function SIL:SetColorScore(v) self.db.global.color = v; end
function SIL:SetRoundScore(v) self.db.global.round = v; end
function SIL:SetDebug(v) self.db.char.debug = v; end

-- Get
function SIL:GetAdvanced() return self.db.global.advanced; end
function SIL:GetMinimap() return not self.db.global.minimap.hide; end
function SIL:GetAutoscan() return self.db.global.autoscan; end
function SIL:GetPaperdoll() return self.db.global.cinfo; end
function SIL:GetAge() return self.db.global.age; end
function SIL:GetPurge() return self.db.global.purge; end
function SIL:GetLabel() return self.db.global.showLabel; end
function SIL:GetLDB() return self.db.global.ldbText; end
function SIL:GetLDBlabel() return self.db.global.ldbLabel; end
function SIL:GetLDBrefresh() return self.db.global.ldbRefresh; end
function SIL:GetTTCombat() return self.db.global.ttCombat; end
function SIL:GetColorScore() return self.db.global.color; end
function SIL:GetRoundScore() return self.db.global.round; end
function SIL:GetModule(m) return self.db.char.module[m]; end
function SIL:GetDebug(m) return self.db.char.debug; end

-- Toggle
function SIL:ToggleAdvanced() self:SetAdvanced(not self:GetAdvanced()); end
function SIL:ToggleMinimap() self:SetMinimap(not self:GetMinimap()); end
function SIL:ToggleAutoscan() self:SetAutoscan(not self:GetAutoscan()); end
function SIL:TogglePaperdoll() self:SetPaperdoll(not self:GetPaperdoll()); end
function SIL:ToggleLabel() self:SetLabel(not self:GetLabel()); end
function SIL:ToggleLDBlabel() self:SetLDBlabel(not self:GetLDBlabel()); end
function SIL:ToggleTTCombat() self:SetTTCombat(not self:GetTTCombat()); end
function SIL:ToggleColorScore() self:SetColorScore(not self:GetColorScore()); end
function SIL:ToggleRoundScore() self:SetRoundScore(not self:GetRoundScore()); end
function SIL:ToggleColorScore(m) self:SetModule(m, not self:GetModule(m)); end
function SIL:ToggleDebug(m) self:SetDebug(not self:GetDebug()); end

-- Advanced sets
function SIL:SetPurge(hours) 
    self.db.global.purge = hours; 
    SIL_Options.args.purge.desc = format(L.core.options.purgeDesc, self.db.global.purge / 24); 
end

function SIL:SetMinimap(v) 
    self.db.global.minimap.hide = not v;
	
	if not v then
		self.ldbIcon:Hide(L.core.name);
	else
		self.ldbIcon:Show(L.core.name);
	end
end

function SIL:SetPaperdoll(v)
	self.db.global.cinfo = v;
	
	if v then
		PAPERDOLL_STATINFO[L.core.name] = { updateFunc = function(...) SIL:UpdatePaperDollFrame(...); end };
	else
		PAPERDOLL_STATINFO[L.core.name] = nil;
	end
end

function SIL:SetLDB(v)
	self.db.global.ldbText = v;
	
	if v then
		--self:RegisterEvent("GROUP_ROSTER_UPDATE");
		self.ldb.type = 'data source';
	else
		--self:UnregisterEvent("GROUP_ROSTER_UPDATE");
		self.ldb.type = 'launcher';
		self.ldb.text = nil;
	end
	
	self:UpdateLDB(true);
end

function SIL:SetModule(m, v)
    self.db.char.module[m] = v;
    
    if v then
        self:ModuleLoad(m);
    end
end

--[[
    
    GUI Functions
    
]]

-- Open the options window
function SIL:ShowOptions()
    -- Not using this until a paramiter is added to open expanded
    -- InterfaceOptionsFrame_OpenToCategory(L.core.name);
    
    for i,element in pairs(INTERFACEOPTIONS_ADDONCATEGORIES) do 
        if element.name == L.core.name then
            if not InterfaceOptionsFrame:IsShown() then
                InterfaceOptionsFrame_Show();
                InterfaceOptionsFrameTab2:Click();
            end

            for i,button in pairs(InterfaceOptionsFrameAddOns.buttons) do
                if button.element == element then
                    InterfaceOptionsListButton_OnClick(button);
                    
                    -- Expand
                    if element.hasChildren and element.collapsed then
                        OptionsListButtonToggle_OnClick(button.toggle);
                    end
                
                -- Hide anything else that is open
                elseif button.element and type(button.element.collapsed) == 'boolean' and not button.element.collapsed then
                    OptionsListButtonToggle_OnClick(button.toggle);
                end
            end
        end
    end
end

function SIL:UpdateLDB(force, auto)
    
	if self:GetLDB() then
		local label = UnitName('player');
		
        if SIL_Group then
            groupType,label = SIL_Group:GroupType();
		end
        
		-- Do we really need to update LDB?
		if force or label ~= self.ldbLable or (self.ldbUpdated + self:GetLDBrefresh()) < time() then
            
            local text = 'n/a';
            local _, itype = GetInstanceInfo();
            
            if (itype == 'pvp' or itype == 'arena') and SIL_Resil then
                local groupPercent = SIL_Resil:GroupSum();
                groupPercent = SIL_Resil:FormatPercent(groupPercent, true);
                text = groupPercent;
                
                if SIL_Group then
                    local groupScore = SIL_Group:GroupScore();
                    groupScore = self:FormatScore(groupScore, self.grayScore + 1, true);
                    text = groupScore..' '..text;
                end
            elseif SIL_Group then
                local groupScore = SIL_Group:GroupScore()
                text = self:FormatScore(groupScore, 16, true);
            elseif UnitGUID('player') then
                local score, age, items = self:GetScoreTarget('player');
                text = self:FormatScore(score, items, true);
            end
            
			self:UpdateLDBText(label, text)
		end
	else
		self.ldb.type = 'launcher';
		self.ldb.text = nil;
	end
end

function SIL:UpdateLDBText(label, text)
    if not self:GetLDB() then return false; end
    
    -- Add the label
    if self:GetLDBlabel() then
        text = label..": "..text;
    end
    
    self.ldb.text = text;
    self.ldbUpdated = time();
    self.ldbLable = label;
end

function SIL:LDBSetAuto()
    if self.ldbAuto then
        self:CancelTimer(self.ldbAuto, true);
    end
    
    self.ldbAuto = self:ScheduleRepeatingTimer(function() 
        if not InCombatLockdown() then 
            SIL:Debug('Auto LDB...'); 
            SIL:UpdateLDB(false, true); 
        end 
    end, self:GetLDBrefresh());
end

function SIL:GMICallback(name)
    local score, age, items = self:GetScoreName(name);
	
	if score and tonumber(score) and 0 < score then
		return self:FormatScore(score, items, false);
	else
        return 'n/a';
    end
end

function SIL:Cache(guid, what)
    if not guid and not self:IsGUID(guid, 'Player') then return false end
    
    if SIL_CacheGUID[guid] and what then
        if what == 'age' then
            if SIL_CacheGUID[guid].time then
                return time() - SIL_CacheGUID[guid].time;
            else
                return nil;
            end
        else
            return SIL_CacheGUID[guid][what];
        end
    elseif SIL_CacheGUID[guid] then
        return true;
    else
        return false;
    end
end

function SIL:IsGUID(guid, type)
    if not guid then return false end
    if not type then type = 'player' end

    local gType, gGuid = strsplit('-', guid, 2);

    if strlower(type) == strlower(gType) then 
        return true
    else 
        return false
    end
end

function SIL:UpdateGroup()
    self.group = {};
    
    local playerGUID = self:AddPlayer('player');
    table.insert(self.group, playerGUID);
    
    if UnitInBattleground('player') or UnitInRaid('player') then
        for i=1,MAX_RAID_MEMBERS do
            local target = 'raid'..i;
            local guid = self:AddPlayer(target);

            if guid and guid ~= playerGUID then
                table.insert(self.group, guid);
                
                if not self:Cache(guid, 'score') then
                    self:RoughScore(target);
                end
            end
        end
    elseif GetNumSubgroupMembers() > 0 then
        for i=1,MAX_PARTY_MEMBERS do
            local target = 'party'..i;
            local guid = self:AddPlayer(target);
            
            if guid then
                table.insert(self.group, guid);
                
                if not self:Cache(guid, 'score') then
                    self:RoughScore(target);
                end
            end
        end
    end
end

function SIL:GroupDest(dest, to)
	local valid = false;
	local color = false;

	if not dest then dest = "SYSTEM"; valid = true; end
	if dest == '' then dest = "SYSTEM"; valid = true; end
	dest = string.upper(dest);
	
	-- Some short codes, should be a table
	if dest == 'P'  then dest = 'PARTY'; valid = true; end
	if dest == 'R' then dest = 'RAID'; valid = true; end
	if dest == 'BG' then dest = 'BATTLEGROUND'; valid = true; end
	if dest == 'G' then dest = 'GUILD'; valid = true; end
	if dest == 'U' then dest = 'GROUP'; valid = true; end
	if dest == 'A' then dest = 'GROUP'; valid = true; end
	if dest == 'O' then dest = 'OFFICER'; valid = true; end
	if dest == 'S' then dest = 'SAY'; valid = true; end
	if dest == 'T' then dest = 'WHISPER'; valid = true; end
	if dest == 'W' then dest = 'WHISPER'; valid = true; end
	if dest == 'TELL' then dest = 'WHISPER'; valid = true; end
    if dest == 'C' then dest = 'CHANNEL'; valid = true; end
    if dest == 'I' then dest = 'INSTANCE_CHAT'; valid = true; end
	
	-- Find out if its a valid dest
	for fixed,loc in pairs(SIL_Channels) do
		if dest == string.upper(loc) then
			dest = fixed;
			valid = true;
		elseif dest == string.upper(fixed) then
			dest = fixed;
			valid = true;
		end
	end
	
	-- Default to system
	if not valid then
		dest = "SYSTEM";
	end
	
	-- Figure out GROUP
	if dest == 'GROUP' and IsInGroup() then
        if UnitInBattleground("player") then
            dest = 'BATTLEGROUND';
        elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
            dest = 'INSTANCE_CHAT';
		elseif UnitInRaid("player") then
			dest = 'RAID';
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			dest = 'PARTY';
		else
			dest = 'SAY';
		end
	end
	
    if dest == "SYSTEM" then
        color = true;
    end
    
	return dest, to, color;
end