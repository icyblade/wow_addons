--[[
    This file is for method sets
]]
local L = LibStub("AceLocale-3.0"):GetLocale("SimpleILevel", true);

function SIL:MenuInitialize()
    if not self.silmenu then
		self.silmenu = CreateFrame("Frame", "SILMenu")
	end
    
    self.silmenu.initialize = function(...) SIL:MenuShow(...) end;
    
    
    -- Advanced
    self:AddMenuItems('middle', {
        text = L.core.options.ttAdvanced,
        func = function() SIL:ToggleAdvanced(); end,
        checked = function() return SIL:GetAdvanced(); end,
    }, 1);
    
    -- Autoscan
    self:AddMenuItems('middle', {
        text = L.core.options.autoscan,
        func = function() SIL:ToggleAutoscan(); end,
        checked = function() return SIL:GetAutoscan(); end,
    }, 1);
    
    -- Minimap
    self:AddMenuItems('middle', {
        text = L.core.options.minimap,
        func = function() SIL:ToggleMinimap(); end,
        checked = function() return SIL:GetMinimap(); end,
    }, 1);
    
    -- LDB Text
    self:AddMenuItems('middle', {
        text = L.core.options.ldbSource,
        func = function() SIL:ToggleLDBlabel(); end,
        checked = function() return SIL:GetLDBlabel(); end,
    }, 1);
end

function SIL:MenuOpen()
    local x,y = GetCursorPosition(UIParent);
	ToggleDropDownMenu(1, nil, self.silmenu, "UIParent", x / UIParent:GetEffectiveScale() , y / UIParent:GetEffectiveScale());
end

function SIL:MenuShow(s, level)
    if not level or not tonumber(level) then return end
    
    local info = {};
    local spacer = { disabled = 1, notCheckable = 1 };
    
    if level == 1 then
    
        -- Title / Version
        info.isTitle = 1;
        info.text = L.core.name..' '..SIL.version;
        info.notCheckable = 1;
        UIDropDownMenu_AddButton(info, level);
        
        -- Spacer
        UIDropDownMenu_AddButton(spacer, level);
        
        -- Top
        if self:MenuRunItem('top', level) then
            UIDropDownMenu_AddButton(spacer, level);
        end
        
        -- Middle
        if self:MenuRunItem('middle', level) then
            UIDropDownMenu_AddButton(spacer, level);
        end
        
        -- Bottom
        if self:MenuRunItem('bottom', level) then
            UIDropDownMenu_AddButton(spacer, level);
        end   
        
        -- Options
        wipe(info);
        info.text = L.core.options.open;
        info.func = function() SIL:ShowOptions(); end;
        info.notCheckable = 1;
        UIDropDownMenu_AddButton(info, level);
        
        -- My Score
        wipe(info);
        local score, age, items = self:GetScoreTarget('player', true);
        info.text = format(L.core.scoreYour, SIL:FormatScore(score, items));
        info.notClickable = 1;
        info.notCheckable = 1;
        UIDropDownMenu_AddButton(info, level);
        
    elseif tonumber(level) and UIDROPDOWNMENU_MENU_VALUE then
        
        -- Top
        if self:MenuRunItem('top', level, UIDROPDOWNMENU_MENU_VALUE) then
            UIDropDownMenu_AddButton(spacer, level);
        end
        
        if self:MenuRunItem('middle', level, UIDROPDOWNMENU_MENU_VALUE) then
            UIDropDownMenu_AddButton(spacer, level);
        end
        
        self:MenuRunItem('bottom', level, UIDROPDOWNMENU_MENU_VALUE);
    end
end

function SIL:MenuRunItem(where, level, parent)
    where = strlower(where);
    local lev = level;
    
    if level and parent then
        level = level..'-'..parent;
    end
    
    local foundSomething = false;
    
    if self.menuItems[where] and self.menuItems[where][level] then
        for i,info in pairs(self.menuItems[where][level]) do
            
            -- Run functions for a name
            if info.textFunc and type(info.textFunc) == 'function' then
                info.text = info.textFunc(where, lev, parent);
            end
            
            local enabled = true;
            
            if info.enabled and type(info.enabled) == 'function' then
                enabled = info.enabled();
            end
            
            if enabled then
                UIDropDownMenu_AddButton(info, lev);
                foundSomething = true;
            end
        end
    end
    
    return foundSomething;
end

--[[ 
    For what info is see "List of button attributes"
    - http://wowprogramming.com/utils/xmlbrowser/live/FrameXML/UIDropDownMenu.lua
    
    Additional Options:
    info.textFunc = function(where, level, parent); this is ran to update info.text when the menu is shown
    info.enabled = function(where, level, parent); this is backwards, but if enabled is present then it is ran to see if the item should be shown
]]
function SIL:AddMenuItems(where, info, level, parent)
    if not where and not info and not self.menuItems[where] and type(info) ~= 'table' then return end;
    where = strlower(where);
    level = level or 1;
    
    if parent then
        level = level..'-'..parent;
    end
    
    if not self.menuItems[where][level] then
        self.menuItems[where][level] = {};
    end
    
    table.insert(self.menuItems[where][level], info);
end

function SIL:ModulesProcess()
    local silName,silTitle = GetAddOnInfo('SimpleILevel');
    
    for index=1,GetNumAddOns() do
        local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(index);
        
        if string.sub(name, 1, 13) == 'SimpleILevel_' then
            local module = strlower(string.sub(name, 14));
            local stitle = string.gsub(title, silTitle..' %- ', '');
            stitle = string.gsub(stitle, silTitle..': ', '');
            
            self.modules[module] = {
                name = name,
                title = title,
                stitle = stitle,
                notes = notes,
                enabled = enabled,
                loadable = loadable,
                reason = reason,
                module = module,
            }
            
            SIL_Defaults.char.module[module] = true;
        end
    end
end

function SIL:ModulesList()
    local t = {};
    
    for name,info in pairs(self.modules) do
        t[name] = info.stitle;
    end
    
    return t;
end

function SIL:ModulesLoad()
    for module,info in pairs(self.modules) do
        if self:GetModule(module) then
            self:ModuleLoad(module)
        end
    end
end

function SIL:ModuleLoad(module)
    if module and self.modules[module] then
        local name = self.modules[module].name;
        local loaded, reason = LoadAddOn(name);
        
        if loaded then
            self:RunHooks('loadmodule', module);
            return true;
        else
            self:Print(_G['ADDON_'..reason]);
        end
    end
    
    return false;
end

--[[
        Random Methods
]]
-- from http://www.wowpedia.org/Round
function SIL:Round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number);
end

-- from http://www.wowpedia.org/RGBPercToHex
function SIL:RGBtoHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end


function SIL:CanOfficerChat()
    if not IsInGuild() then return false; end

    local _, _, guildRankIndex = GetGuildInfo("player");
	GuildControlSetRank(guildRankIndex + 1);
	local flags = self:Flags2Table(GuildControlGetRankFlags());
	return flags[4];
end

function SIL:Flags2Table(...)
	local ret = {}
	for i = 1, select("#", ...) do
		if (select(i, ...)) then
			ret[i] = true;
		else
			ret[i] = false;
		end
	end
	return ret;
end

-- Play around with to test how color changes will work
function SIL:ColorTest(l,h)
	for i = l,h do
		self:Print(self:FormatScore(i));
	end
end
