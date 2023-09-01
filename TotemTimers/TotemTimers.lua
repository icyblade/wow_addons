-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

--[[ Credits for localization go to
        Sayclub (koKR), StingerSoft (ruRU), a9012456 (zhTW),
        Sabre (zhCN), vanilla_snow (zhCN), tnt2ray (zhCN),
        Vante (esES), DonSlonik (ruRU), Оригинал (ruRU),
        natural_leaf (zhTW), ckeurk (frFR), oXid_FoX (frFR),
        Hemathio (ruRU), wowuicn (zhCN), laincat (zhTW)
]]

--hooksecurefunc("SetMultiCastSpell", function(arg1,arg2) DEFAULT_CHAT_FRAME:AddMessage(tostring(arg1).."  "..tostring(arg2)) end)
--hooksecurefunc("GetMultiCastTotemSpells", function(arg1) DEFAULT_CHAT_FRAME:AddMessage(tostring(arg1)) end)

TotemTimers.emptyTotem = "Interface\\Buttons\\UI-TotemBar"

local totemsqueued = false
local queuedtotems = {}
local warnings = nil

local PlayerName = UnitName("player")

local function TotemTimers_ProcessQueue()
    if totemsqueued and not InCombatLockdown() then
        totemsqueued = false
        for i = 1,4 do
            local element = TotemTimers_Settings.Order[i]
            if queuedtotems[element] then
                local id = queuedtotems[element]
                local multispell = TotemTimers_Settings.RaidTotemsToCall
                SetMultiCastSpell(TotemTimers.MultiCastActions[element][multispell], id)
                TotemTimers.SetupTotemButtons()
                --XiTimers.timers[i].button:SetAttribute("*spell1", queuedtotems[element])
                queuedtotems[element] = nil
            end                
        end
    end
end

local function SendTalentInfo(mode, recipient)
    local _,instance = IsInInstance()
    if instance == "pvp" or instance == "arena" then return end
	local talents = ""
    for i=1,3 do
        for j = 1,GetNumTalents(i) do
            talents = talents..select(5, GetTalentInfo(i,j))
        end
    end
    SendAddonMessage("RAIDTOTEMS", "talents "..talents, mode, recipient)
end

local function SentRTTProtocolVer(mode, recipient)
    local _,instance = IsInInstance()
    if instance == "pvp" or instance == "arena" then return end
	SendAddonMessage("RAIDTOTEMS", "protocol 103", mode, recipient)
end

local inRaid = false
local zoning = false

function TotemTimers_OnEvent(event, ...)
    if zoning and event ~= "PLAYER_ENTERING_WORLD" then return
	elseif event == "PLAYER_ENTERING_WORLD" then 
        if zoning then
            TotemTimersFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
            zoning = false
            return
        end
		TotemTimers_SetupGlobals()
		inRaid = GetNumRaidMembers()>0
    elseif event == "LEARNED_SPELL_IN_TAB" then
        TotemTimers.LearnedSpell(...)
    elseif event == "PLAYER_REGEN_ENABLED" then
        TotemTimers_ProcessQueue()
    elseif event == "PLAYER_ALIVE" then
        --TotemTimers_Spells.maelstrom = GetTalentInfo(2,28)
        --TotemTimersFrame:UnregisterEvent("PLAYER_ALIVE")
        TotemTimers.GetTalents()
        TotemTimers.ProcessSpecSetting("EnhanceCDs")
        TotemTimers.options.args.enhancecds.args["2"].name = select(2,GetTalentTabInfo(2)) or "Enhancement"
        TotemTimers.options.args.enhancecds.args["1"].name = select(2,GetTalentTabInfo(1)) or "Elemental"
        TotemTimers.options.args.enhancecds.args["3"].name = select(2,GetTalentTabInfo(3)) or "Restoration"
    elseif event == "CHARACTER_POINTS_CHANGED" then
        local nr = select(1,...)
        if nr > 1 then
            TotemTimers.ChangedTalents()
        elseif nr == -1 then
            TotemTimers.LearnedSpell()
            TotemTimers.GetTalents()
        end
	elseif event == "PLAYER_TALENT_UPDATE" then
        TotemTimersFrame:RegisterEvent("ACTIONBAR_UPDATE_STATE")
        TotemTimers.ActiveSpecSettings = TotemTimers_SpecSettings[GetActiveTalentGroup()]
        XiTimers.TimerPositions = TotemTimers.ActiveSpecSettings.TimerPositions
		TotemTimers.ChangedTalents()
        TotemTimers.ProcessAllSpecSettings()
		if inRaid then
			SendTalentInfo("RAID")
		end        
    elseif event == "CHAT_MSG_ADDON" then
        local prefix, msg, _, sender = ...
        if prefix == "RAIDTOTEMS" then
            if msg == "getprotocol" then
                SentRTTProtocolVer("WHISPER", sender)
            elseif msg == "gettalents" then
                SendTalentInfo("WHISPER", sender)
            else
                local args = {strsplit(" ", msg)}
				if args[1] == "es" and args[2] == PlayerName then
					local sn = GetSpellInfo(49284) -- Earth Shield Name, in case shaman is not resto
					TotemTimers_SetEarthShieldRecast(args[3])
					DEFAULT_CHAT_FRAME:AddMessage("TotemTimers: "..sn.." -> "..args[3])
				elseif args[1] == "totems" and args[2] == PlayerName then
                    for i=3,6 do
                        args[i] = tonumber(args[i])
                    end
                    msg = "TotemTimers: RaidTotems: "
                    for i=1,4 do
                        local element = i+2--TotemTimers_Settings.Order[i]+2
                        if args[element] and args[element] ~= 0 then
                            local name = GetSpellInfo(args[element])
                            msg = msg..name
							if i<4 then msg = msg..", " end
                            if TotemTimers_Settings.RaidTotemsToCall ~= 0 then
                                queuedtotems[i] = args[element]
                                totemsqueued = true
                            end                            
                        end
                    end
					if not InCombatLockdown() then TotemTimers_ProcessQueue() end
                    DEFAULT_CHAT_FRAME:AddMessage(msg)
                end
            end
        end
    elseif event == "RAID_ROSTER_UPDATE" or (event == "PARTY_MEMBERS_CHANGED" and GetNumRaidMembers()==0) then
        --TotemTimers_UpdateRaid()
		if not inRaid and GetNumRaidMembers()>0 then
			SentRTTProtocolVer("RAID")
			--SendTalentInfo("RAID")
		end
		inRaid = GetNumRaidMembers()>0
    elseif event == "ACTIONBAR_UPDATE_STATE" then
        TotemTimersFrame:UnregisterEvent("ACTIONBAR_UPDATE_STATE")
        if not InCombatLockdown() then TotemTimers.SetupTotemButtons() end
    elseif event == "PLAYER_LEAVING_WORLD" then
        zoning = true
        TotemTimersFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	end   
end


function TotemTimers_SetupGlobals()
	if TotemTimers_IsSetUp then
		return
	end
	if select(2,UnitClass("player")) == "SHAMAN" then
        TotemTimers.Frames = {}
		TotemTimers.GetSpells()
		TotemTimers_LoadDefaultSettings()
        TotemTimers.ActiveSpecSettings = TotemTimers_SpecSettings[GetActiveTalentGroup()]    
        
        local sink = LibStub("LibSink-2.0")
        if sink then
            sink.SetSinkStorage(TotemTimers,TotemTimers_Settings.Sink)
        end
		XiTimers.TimerPositions = TotemTimers.ActiveSpecSettings.TimerPositions
		TotemTimers_CreateTimers()
		TotemTimers_CreateTrackers()
        TotemTimers.SetWeaponTrackerSpells()
        TotemTimers.CreateEnhanceCDs()
        TotemTimers.CreateMultiCastButtons()
        TotemTimers.SetMultiCastSpells()
        TotemTimers.CreateCrowdControl()
        
        
		for setting,value in pairs(TotemTimers_Settings) do
			TotemTimers.ProcessSetting(setting)
		end
        TotemTimers.ProcessAllSpecSettings()
		TotemTimers_OrderTimers()
		--TotemTimers_OrderTrackers()
		TotemTimersFrame:Show()
        
        TotemTimers_InitSetButtons()
		
		--init weapon tracker, get it to set its textures
		if XiTimers.timers[8].active then TotemTimers.WeaponEvent(XiTimers.timers[8].button, "UNIT_INVENTORY_CHANGED") end
		
		--set the slashcommand
		SLASH_TOTEMTIMERS1 = "/totemtimers";
		SLASH_TOTEMTIMERS2 = "/tt";
		SlashCmdList["TOTEMTIMERS"] = TotemTimers_Slash

		--TotemTimers_LastGUIPane = TotemTimers_GUI_General

        TotemTimers_InitializeBindings()
        hooksecurefunc("SaveBindings", function() ClearOverrideBindings(TotemTimersFrame) TotemTimers_InitializeBindings() end)    
            
		
        TotemTimersFrame:RegisterEvent("SPELLS_CHANGED")
        TotemTimersFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        TotemTimersFrame:RegisterEvent("PLAYER_ALIVE")
        TotemTimersFrame:RegisterEvent("LEARNED_SPELL_IN_TAB")
        TotemTimersFrame:RegisterEvent("CHARACTER_POINTS_CHANGED")
        TotemTimersFrame:RegisterEvent("CHAT_MSG_ADDON")
        TotemTimersFrame:RegisterEvent("RAID_ROSTER_UPDATE")
        TotemTimersFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
		TotemTimersFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
        TotemTimersFrame:RegisterEvent("PLAYER_LEAVING_WORLD")
        --TotemTimers_UpdateRaid()
		TotemTimers_InitButtonFacade()
		TotemTimers.RangeFrame:RegisterEvent("RAID_ROSTER_UPDATE")
		TotemTimers.RangeFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
        TotemTimers.RangeFrame:Show()
        TotemTimers.SetupTotemButtons()
        TotemTimers_SetCastButtonSpells()
        -- activate shield timer after reloading ui
        if XiTimers.timers[6].active then
            TotemTimers.ShieldEvent(XiTimers.timers[6].button, "", "player")
        end  

        --TotemTimers.OrderCDs("2")
        --TotemTimers.OrderCDs("1")
        
        TotemTimers_OnEvent("PLAYER_ALIVE") -- simulate PLAYER_ALIVE event in case the ui is reloaded
        XiTimers.invokeOOCFader()
        TotemTimersFrame:SetScript("OnUpdate", XiTimers.UpdateTimers)
        XiTimers.InitWarnings(TotemTimers_Settings.Warnings)
        TotemTimers.AuraFrameOnEvent(TotemTimers_AuraFrame, "ACTIONBAR_SLOT_CHANGED")
        TotemTimers.ConfigAuras()
        TotemTimers.SetEarthShieldButtons()
        TotemTimers.LayoutCrowdControl()
        --TotemTimers.ApplySkin()
        RegisterAddonMessagePrefix("RAIDTOTEMS")
	else
		TotemTimersFrame:Hide()
	end
	TotemTimers_IsSetUp = true
    TotemTimersFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function TotemTimers_Slash(msg)
	if InCombatLockdown() then
		DEFAULT_CHAT_FRAME:AddMessage("Can't open TT options in combat.")
		return
	end
	--[[if msg == "i" or msg == "inspect" then
        InterfaceOptionsFrame_OpenToCategory(TotemTimers_GUI_Inspect.name)
    else
        InterfaceOptionsFrame_OpenToCategory(TotemTimers_LastGUIPane.name)
    end]]
    if TotemTimers.LastGUIPanel then
        InterfaceOptionsFrame_OpenToCategory(TotemTimers.LastGUIPanel)
    else
        InterfaceOptionsFrame_OpenToCategory("TotemTimers")
    end
end


local text

local function addVar(var, indent)
    if type(var) == "table" then
        text = text.." {|n"
        for k,v in pairs(var) do
            for i=1,indent+4 do text = text.." " end
            text = text..'["'..k..'"] = '
            addVar(v, indent+4)
        end
        for i=1,indent do text = text.." " end
        text = text.."}|n"
    else
        text = text..tostring(var).."|n"
    end
end

local DebugText = ""

function TotemTimers.ResetDebug()
end

function TotemTimers.AddDebug(text)
    DebugText = DebugText..text.."|n"
end

function TotemTimers.ShowDebug()
	--text = ""
	--[[text = text.."Settings:|n"
	for k,v in pairs(TotemTimers_Settings) do
		text = text..'    ["'..k..'"] = '
        addVar(v, 4)
	end
	text=text.."|n|n"
    text=text.."Available spells:|n"
	for k,v in pairs(TotemTimers_Spells) do
		text = text..'    ["'..k..'"] = '
        addVar(v, 4)
	end  ]]
	--[[text = "EnhanceCDs option: "..tostring(TotemTimers_Settings["EnhanceCDs"]).."|n"
	local name,_,_,_,rank = GetTalentInfo(2,28)
	text = text..tostring(name)..": "..tostring(rank).."|n"
    name,_,_,_,rank = GetTalentInfo(2,21)
	text = text..tostring(name)..": "..tostring(rank).."|n"
    name,_,_,_,rank = GetTalentInfo(2,23)
	text = text..tostring(name)..": "..tostring(rank).."|n"
	text = text.."SS-Timer: "..tostring(XiTimers.timers[9].active).."|n"
	text = text.."ES-Timer: "..tostring(XiTimers.timers[10].active).."|n"
	text = text.."LL-Timer: "..tostring(XiTimers.timers[11].active).."|n"
	text = text.."EC Pos: "
	local a,b,c,d,e = TotemTimers_EnhanceCDsFrame:GetPoint(1)
	if a then
		text=text..a.." "
		if b then text = text..b:GetName() else text = text.."nil " end
		text = text..tostring(c).." "..tostring(d).." "..tostring(e)
	end
	text=text.."|n"]]
	TotemTimers_Debug:SetText(DebugText)
	TotemTimers_Debug:HighlightText()
end

local SLOT_EMPTY_TCOORDS = { --Tex coords taken from MultiCastActionBarFrame.lua for empty totem slots
	[EARTH_TOTEM_SLOT] = {
		left	= 66 / 128,
		right	= 96 / 128,
		top		= 3 / 256,
		bottom	= 33 / 256,
	},
	[FIRE_TOTEM_SLOT] = {
		left	= 67 / 128,
		right	= 97 / 128,
		top		= 100 / 256,
		bottom	= 130 / 256,
	},
	[WATER_TOTEM_SLOT] = {
		left	= 39 / 128,
		right	= 69 / 128,
		top		= 209 / 256,
		bottom	= 239 / 256,
	},
	[AIR_TOTEM_SLOT] = {
		left	= 66 / 128,
		right	= 96 / 128,
		top		= 36 / 256,
		bottom	= 66 / 256,
	},
}

local skin = IsAddOnLoaded("Masque") or IsAddOnLoaded("rActionButtonStyler")

function TotemTimers.SetEmptyTexCoord(icon, nr)
    if nr and nr > 0 and nr < 5 then
        local tcoords = SLOT_EMPTY_TCOORDS[nr]
		local tcoordLeft, tcoordRight, tcoordTop, tcoordBottom = tcoords.left, tcoords.right, tcoords.top, tcoords.bottom
        icon:SetTexCoord(tcoordLeft, tcoordRight, tcoordTop, tcoordBottom) 
    elseif skin and type(skin) == "table" and skin.Icon and skin.Icon.TexCoords then
        icon:SetTexCoord(unpack(skin.Icon.TexCoords))    
    else
        icon:SetTexCoord(0,1,0,1)
    end
end

local DoubleIcons = {}
local EmptyIcons = {}

function TotemTimers.SetDoubleTexCoord(button, flash)
    if DoubleIcons[button] then
        button.icons[1]:ClearAllPoints()
        button.icons[1]:SetPoint("RIGHT", button, "CENTER")
        button.icons[2]:Show()
        if not skin then
            button.icons[1]:SetWidth(18)
            button.icons[1]:SetHeight(36)
            button.icons[2]:SetWidth(18)
            button.icons[2]:SetHeight(36)
            button.icons[1]:SetTexCoord(0,0.5,0,1)
            button.icons[2]:SetTexCoord(0.5,1,0,1)
            if flash and button.flash then
                button.flash[1]:SetTexCoord(0,0.5,0,1)
                button.flash[2]:SetTexCoord(0.5,1,0,1)
            end
        else
            local icon = XiTimers.timers[1].button.icons[1]
            local flash = XiTimers.timers[1].button.flash[1]
            button.icons[1]:SetWidth(icon:GetWidth()/2)
            button.icons[2]:SetWidth(icon:GetWidth()/2)
            button.icons[1]:SetHeight(icon:GetHeight())
            button.icons[2]:SetHeight(icon:GetHeight())
            local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = icon:GetTexCoord()
            button.icons[1]:SetTexCoord(ULx, ULy, LLx, LLy, URx/2, URy, LRx/2, LRy)
            button.icons[2]:SetTexCoord((1-ULx)/2, ULy, (1-LLx)/2, LLy, URx, URy, LRx, LRy)
            button.icons[2]:Show()
            if flash and button.flash then
                button.flash[2]:SetTexture(button.flash[1]:GetTexture())
                button.flash[1]:SetTexCoord(0,0.5,0,1)
                button.flash[2]:SetTexCoord(0.5,1,0,1)
            end
        end
    else
        button.icons[1]:ClearAllPoints()
        button.icons[1]:SetPoint("CENTER", button, "CENTER")
        button.icons[2]:Hide()        
        if not skin then
            button.icons[1]:SetWidth(36)
            button.icons[1]:SetHeight(36)
            button.icons[1]:SetTexCoord(0,1,0,1)
            if flash and button.flash then
                button.flash[1]:SetTexCoord(0,1,0,1)
            end           
        else
            local icon = XiTimers.timers[1].button.icons[1]
            button.icons[1]:SetWidth(icon:GetWidth())
            button.icons[1]:SetHeight(icon:GetHeight())
            local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = icon:GetTexCoord()
            button.icons[1]:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
            if flash and button.flash then
                button.flash[1]:SetTexCoord(XiTimers.timers[1].button.flash[1]:GetTexCoord())
            end
        end
    end
end

function TotemTimers.SetDoubleTexture(button, isdouble, flash)
    if isdouble then
        DoubleIcons[button] = true
    else
        DoubleIcons[button] = nil
    end
    TotemTimers.SetDoubleTexCoord(button, flash)
end

function TotemTimers.SetEmptyIcon(icon, nr)
    if not nr then
        EmptyIcons[icon] = nil
    else
        EmptyIcons[icon] = nr
        icon:SetTexture(TotemTimers.emptyTotem)
    end
    TotemTimers.SetEmptyTexCoord(icon, nr)
end

function TotemTimers.ApplySkin(newskin)
    if newskin then skin = newskin end
    for k,v in pairs(DoubleIcons) do
        TotemTimers.SetDoubleTexCoord(k, k == XiTimers.timers[8].button)
    end
end


function TotemTimers.SaveFramePositions()
    for k,v in pairs(TotemTimers.ActiveSpecSettings.FramePositions) do
        local pos = {_G[k]:GetPoint()}
        if not pos[1] then pos = nil end
        if pos[2] then pos[2] = pos[2]:GetName() end
        TotemTimers.ActiveSpecSettings.FramePositions[k] = pos
    end 
    for i = 1, #XiTimers.timers do
        local timer = XiTimers.timers[i]
        if timer.savePos and timer.button:GetNumPoints()>0 then
            local pos = {timer.button:GetPoint(1)}
            if not pos[1] then pos = nil
            elseif pos[2] then
                pos[2] = pos[2]:GetName()
            end
            XiTimers.TimerPositions[timer.nr] = pos
        end
    end
end

XiTimers.SaveFramePositions = TotemTimers.SaveFramePositions


local Sink = LibStub:GetLibrary("LibSink-2.0")
local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers")

function TotemTimers.ThrowWarning(wtype, object, icon)
    local warning = TotemTimers_Settings.Warnings[wtype]
    if warning and Sink then
        Sink:Pour(TotemTimers, warning, format(L[wtype],object),warning.r,warning.g,warning.b,
            nil,nil,nil,nil,nil,icon)        
    end
end
