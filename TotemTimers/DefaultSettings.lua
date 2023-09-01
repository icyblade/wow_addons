-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

if not TotemTimers_Settings then TotemTimers_Settings = {} end
if not TotemTimers_SpecSettings then TotemTimers_SpecSettings = {[1] = {}, [2] = {}} end

local Default_Settings = {
	Version = 10.41,
    Show = true,    
    Lock = false,
	FlashRed = true,
	ShowTimerBars = true,
    HideBlizzTimers = true,
    Tooltips = true,
    TooltipsAtButtons = true,
    TimeFont = "Friz Quadrata TT",
    TimeColor = {r=1,g=1,b=1},
   	TimerBarTexture = "Blizzard",
    TimerBarColor = {r=0.5,g=0.5,b=1.0,a=1.0},
    ShowKeybinds = true,
    HideInVehicle = true,
    
    Order = {1,2,3,4,},
    Arrange = "horizontal",
 	TimeStyle = "mm:ss",
    TimerTimePos = "BOTTOM",   
	CastBarDirection = "auto",
	TimerSize = 32,
    TimerTimeHeight = 12,	
	TimerSpacing = 5,
	TimerTimeSpacing = 0,
	TotemTimerBarWidth = 36,
    TotemMenuSpacing = 0,
    OpenOnRightclick = false,
    MenusAlwaysVisible = false,
    BarBindings = true,
    ReverseBarBindings = false,    
    MiniIcons = true,
    ProcFlash = true,
    ColorTimerBars = false,
    ShowCooldowns = true,
    CheckPlayerRange = true,
    CheckRaidRange = true,	
    ShowRaidRangeTooltip = true,
    CastButtonPosition = "AUTO",
    CastButtonSize = 0.5,
    StopPulse = true,

	TrackerArrange = "horizontal",
	TrackerTimePos = "BOTTOM",
	TrackerSize = 30,
	TrackerTimeHeight=12,
    TrackerSpacing = 5,
	TrackerTimeSpacing = 0,
    TrackerTimerBarWidth = 36,
    AnkhTracker = true,
    EarthShieldTracker = true,
    WeaponTracker = true,
    WeaponBarDirection = "auto",
    WeaponMenuOnRightclick = false,
    
    CrowdControlEnable = true,
    CrowdControlArrange = "horizontal",
    CrowdControlTimePos = "BOTTOM",
    CrowdControlSize = 30,
    CrowdControlClickthrough = false,

	EarthShieldLeftButton = "recast", 
	EarthShieldRightButton = "target",
	EarthShieldMiddleButton = "targettarget",
	EarthShieldButton4 = "player",
	ShieldLeftButton = TotemTimers.SpellNames[TotemTimers.SpellIDs.LightningShield],
	ShieldRightButton = TotemTimers.SpellNames[TotemTimers.SpellIDs.WaterShield],
	ShieldMiddleButton = TotemTimers.SpellNames[TotemTimers.SpellIDs.TotemicCall],
    EarthShieldTargetName = true,
    ESMainTankMenu = true,
    ESMainTankMenuDirection = "auto",
    
    BorderTimers = true,
    BorderTimerSize = 40,
    RoundButtons = false,
    
	
	Msg = "tt",
    ActivateHiddenTimers = false,    
    
    Warnings = {
        TotemWarning = {
            r = 1,
            g = 0,
            b = 0,
            a = 1,
            sound = "",
            text = "Totem Expiring",
            enabled = true,
        },
        TotemExpiration = {
            r = 1,
            g = 0,
            b = 0,
            a = 1,
            sound = "",
            text = "Totem Expired",            
            enabled = true,
        },
        TotemDestroyed = {
            r = 1,
            g = 0,
            b = 0,
            a = 1,
            sound = "",
            text = "Totem Destroyed",            
            enabled = true,
        },
        Shield = {
            r = 1,
            g = 0,
            b = 0,
            a = 1,
            sound = "",
            text = "Shield removed",            
            enabled = true,
        },
        EarthShield = {
            r = 1,
            g = 0,
            b = 0,
            a = 1,
            sound = "",
            text = "Shield removed",            
            enabled = true,
        },
        Weapon = {
            r = 1,
            g = 0,
            b = 0,
            a = 1,
            sound = "",
            text = "Totem Expired",            
            enabled = true,
        },
        Maelstrom = {
            r = 1,
            g = 0,
            b = 0,
            a = 1,
            sound = "",
            text = "Maelstrom Notifier",            
            enabled = true,
        },
    },
	LastMainEnchants = {},
	LastOffEnchants = {},
                      
	TotemOrder = {},

    TotemSets = {},

    Sink = {},
    
    LastMultiCastSpell = TotemTimers.SpellIDs.CallofElements,
    EnableMultiSpellButton = true,
    MultiSpellSize = 30,
    MultiSpellBarDirection = "sameastimers",
    HideDefaultTotemBar = true,
    MultiSpellBarOnRightclick = false,
    MultiSpellBarBinds = true,
    MultiSpellReverseBarBinds = false,
    
    RaidTotemsToCall = 66842,
    TimersOnButtons = false,
    
    Timer_Clickthrough = false,
    Tracker_Clickthrough = false,
    ESChargesOnly = false,
    
}


Default_SpecSettings = {
    LastWeaponEnchant = TotemTimers.SpellNames[TotemTimers.SpellIDs.FlametongueWeapon],
    LastWeaponEnchant2 = TotemTimers.SpellNames[TotemTimers.SpellIDs.FlametongueWeapon],
    HiddenTotems = {},
    CastButtons = {},
    ShieldTracker = true,
    EnhanceCDs_Spells = {
        [2] = {
            [1] = true, --SpellIDs.StormStrike
            [2] = true, --SpellIDs.EarthShock
            [3] = true, --SpellIDs.LavaLash
            [4] = true, --SpellIDs.FireNova
            [5] = true, --SpellIDs.Magma
            [6] = true, --SpellIDs.ShamanisticRage
            [7] = true, --SpellIDs.WindShear
            [8] = true, --SpellIDs.LightningShield
            [9] = true, -- Unleash Elements,
            [10] = true, -- Spiritwalkers Grace
            [20] = true, --SpellIDs.FeralSpirit
            [21] = true, --SpellIDs.FlameShock
            [22] = true, --SpellIDs.Maelstrom
        },
        [1] = {
            [1] = true, --SpellIDs.FlameShock,
            [2] = true, --SpellIDs.LavaBurst,
            [3] = true, --SpellIDs.ChainLightning,
            [4] = true, --SpellIDs.Thunderstorm,
            [5] = true, --SpellIDs.ElementalMastery,            
            [6] = true, -- Searing
            [7] = true, --FireNova
            [8] = true, --Lightning Shield
            [9] = true, -- Wind Shear
            [10] = true, -- Unleash Elements,
            [11] = true, -- Spiritwalkers Grace
            [20] = true, -- Flame Shock duration
        },
        [3] = {
            [1] = true, --SpellIDs.Riptide,
            [2] = true, --SpellIDs.WaterShield,
            [3] = true, --SpellIDs.HealingRain,
            [4] = true, --SpellIDs.EarthShock
            [5] = true, -- Wind Shear
            [6] = true, -- Unleash Elements,
            [7] = true, -- Spiritwalkers Grace
            [20] = true, -- Flame Shock duration
        },
    },
    EnhanceCDs_Order = {
        [2] = {
            [1] = 1, --SpellIDs.StormStrike
            [2] = 2, --SpellIDs.EarthShock
            [3] = 3, --SpellIDs.LavaLash
            [4] = 4, --SpellIDs.FireNova
            [5] = 5, --SpellIDs.Magma
            [6] = 6, --SpellIDs.ShamanisticRage
            [7] = 7, --SpellIDs.WindShear
            [8] = 8, --SpellIDs.LightningShield
            [9] = 9, -- Unleash Elements
            [10] = 10, -- Spiritwalker's Grace
        },
        [1] = {
            [1] = 1, --SpellIDs.FlameShock,
            [2] = 2, --SpellIDs.LavaBurst,
            [3] = 3, --SpellIDs.ChainLightning,
            [4] = 4, --SpellIDs.Thunderstorm,
            [5] = 5, --SpellIDs.ElementalMastery,
            [6] = 6, -- Searing
            [7] = 7, --FireNova
            [8] = 8, -- Lightning Shield Counter
            [9] = 9, -- Wind Shear
            [10] = 10, -- Unleash Elements
            [11] = 11, -- Spiritwalker's Grace
        },
        [3] = {
            [1] = 1, 
            [2] = 2, 
            [3] = 3, 
            [4] = 4, -- Wind Shear
            [5] = 5, 
            [6] = 6,
            [7] = 7,
        },
    },
    EnhanceCDs = true,
    EnhanceCDsSize = 30,
    EnhanceCDsTimeHeight = 12,
    EnhanceCDsMaelstromHeight = 14,
    ShowOmniCCOnEnhanceCDs = true,
    EnhanceCDsOOCAlpha = 0.4,
    CDTimersOnButtons = true,
    LavaSurgeAura = true,
    LavaSurgeGlow = true,
    FulminationAura = true,
    FulminationGlow = true,
    FlameShockDurationOnTop = false,
    EnhanceCDs_Clickthrough = false,
    
    FramePositions = {
        TotemTimersFrame = {"CENTER", nil, "CENTER", -200,0},
        TotemTimers_TrackerFrame = {"CENTER", nil, "CENTER", 50,0},
        TotemTimers_EnhanceCDsFrame = {"CENTER", nil, "CENTER", 0, -170},
        TotemTimers_MultiSpellFrame = {"CENTER", nil, "CENTER", -250,0},
        TotemTimers_CastBar1 = {"CENTER", nil, "CENTER", -200,-190},
        TotemTimers_CastBar2  = {"CENTER", nil, "CENTER", -200,-225},
        TotemTimers_CastBar3  = {"CENTER", nil, "CENTER", 50, -190},
        TotemTimers_CastBar4  = {"CENTER", nil, "CENTER", 50, -225}, 
        TotemTimers_CrowdControlFrame = {"CENTER", nil, "CENTER", -50, -50},
    },
    
    TimerPositions = { 
        [1] = {"CENTER", nil, "CENTER", -50,-40},
        [2] = {"CENTER", nil, "CENTER", -70,0},
        [3] = {"CENTER", nil, "CENTER", -30, 0},
        [4] = {"CENTER", nil, "CENTER", -50, 40}, 
    },
}

local function copy(object)
    if type(object) ~= table then
        return object
    else
        local newtable = {}
        for k,v in pairs(object) do
            newtable[k] = copy(v)
        end
        return newtable
    end
end

TotemTimers.Default_Settings = Default_Settings
TotemTimers.Default_SpecSettings = Default_SpecSettings


local SettingsConverters = {
    [10.192] = function()
        TotemTimers_Settings.Version = 10.29
        TotemTimers_Settings.TotemOrder = {}
        for i = 1,2 do TotemTimers_SpecSettings[i].CastButtons = nil end
    end,
    [10.29] = function()
        TotemTimers_Settings.Version = 10.32
        for i = 1,2 do
            TotemTimers_SpecSettings[i].EnhanceCDs_Order = nil
            TotemTimers_SpecSettings[i].EnhanceCDs_Spells = nil
        end
    end,
    [10.30] = function()
        TotemTimers_Settings.Version = 10.31
        for i = 1,2 do
            if TotemTimers_SpecSettings[i].EnhanceCDs_Order and TotemTimers_SpecSettings[i].EnhanceCDs_Order[1] then
                TotemTimers_SpecSettings[i].EnhanceCDs_Order[1][7] = 7
            else
                TotemTimers_SpecSettings[i].EnhanceCDs_Order = nil
            end
            if TotemTimers_SpecSettings[i].EnhanceCDs_Spells and TotemTimers_SpecSettings[i].EnhanceCDs_Spells[1] then
                TotemTimers_SpecSettings[i].EnhanceCDs_Spells[1][7] = true
                TotemTimers_SpecSettings[i].EnhanceCDs_Spells[1][8] = true
            else
                TotemTimers_SpecSettings[i].EnhanceCDs_Spells = nil
            end
        end
    end,
    [10.31] = function()
        TotemTimers_Settings.Version = 10.32
        for i = 1,2 do
            if TotemTimers_SpecSettings[i].EnhanceCDs_Spells and TotemTimers_SpecSettings[i].EnhanceCDs_Spells[1] then
                TotemTimers_SpecSettings[i].EnhanceCDs_Spells[1][8] = TotemTimers_SpecSettings[i].EnhanceCDs_Spells[1][7]
                TotemTimers_SpecSettings[i].EnhanceCDs_Spells[1][7] = true
            else
                TotemTimers_SpecSettings[i].EnhanceCDs_Spells = nil
            end
        end
    end,
    [10.32] = function()
        TotemTimers_Settings.Version = 10.33
        for i = 1,2 do
            TotemTimers_SpecSettings[i].EnhanceCDs_Order = copy(Default_SpecSettings.EnhanceCDs_Order)
            TotemTimers_SpecSettings[i].EnhanceCDs_Spells = copy(Default_SpecSettings.EnhanceCDs_Spells)
        end
        if TotemTimers_Settings.FramePositions then
            TotemTimers_Settings.FramePositions.TotemTimers_EnhanceCDsFrame = {"CENTER", nil, "CENTER", 0, -170}
        end
    end,
    [10.33] = function()
        TotemTimers_Settings.Version = 10.34
        if TotemTimers_Settings.FramePositions then
            TotemTimers_SpecSettings[1].FramePositions = copy(TotemTimers_Settings.FramePositions)            
            TotemTimers_SpecSettings[2].FramePositions = copy(TotemTimers_Settings.FramePositions)
        end
        TotemTimers_Settings.TimerPositions = nil
        if TotemTimers_Settings.TimerPositions then
            TotemTimers_SpecSettings[1].TimerPositions = copy(TotemTimers_Settings.TimerPositions)            
            TotemTimers_SpecSettings[2].TimerPositions = copy(TotemTimers_Settings.TimerPositions)
        end
        TotemTimers_Settings.TimerPositions = nil
    end,
    [10.34] = function()
        TotemTimers_Settings.Version = 10.4
        for i = 1,2 do
            TotemTimers_SpecSettings[i].FramePositions.TotemTimers_CrowdControlFrame = {"CENTER", nil, "CENTER", -50, -50}
        end
    end,
    [10.40] = function()
        TotemTimers_Settings.Version = 10.41
        table.insert(TotemTimers_Settings.TotemOrder[AIR_TOTEM_SLOT], TotemTimers.SpellIDs.SpiritLink)
    end,    
}

	
function TotemTimers_LoadDefaultSettings()
	if not TotemTimers_Settings then
		TotemTimers_Settings = {}
	end
    if not TotemTimers_SpecSettings then TotemTimers_SpecSettings = {} end
    if not TotemTimers_SpecSettings[1] then TotemTimers_SpecSettings[1] = {} end --needed if pressed "reset all"-button
    if not TotemTimers_SpecSettings[2] then TotemTimers_SpecSettings[2] = {} end
    
	if not TotemTimers_Settings.Version or TotemTimers_Settings.Version < 10.192 then
		DEFAULT_CHAT_FRAME:AddMessage("TotemTimers: Pre-10.2.4 or no saved settings found, loading defaults...")
		TotemTimers_Settings = {}
	elseif TotemTimers_Settings.Version ~= Default_Settings.Version then
        if not SettingsConverters[TotemTimers_Settings.Version] then
            DEFAULT_CHAT_FRAME:AddMessage("TotemTimers: Unknown settings found, loading defaults...")
            TotemTimers_Settings = {}
        else
            while SettingsConverters[TotemTimers_Settings.Version] do
                SettingsConverters[TotemTimers_Settings.Version]()
            end
        end
    end



	for k,v in pairs(Default_Settings) do
		if TotemTimers_Settings[k] == nil then
			TotemTimers_Settings[k] = copy(v)
		end
	end	
    
    for k,v in pairs(Default_SpecSettings) do
        for i = 1,2 do
            if TotemTimers_SpecSettings[i][k] == nil then
                TotemTimers_SpecSettings[i][k] = copy(v)
            end
        end
        TotemTimers_Settings[k] = nil
    end
    
	if #TotemTimers_Settings.TotemOrder == 0 then
		for i=1,4 do
			TotemTimers_Settings.TotemOrder[i] = {}
		end
		for k,v in pairs(TotemData) do
			table.insert(TotemTimers_Settings.TotemOrder[v.element], k)
		end
	end
    
    for i = 1,2 do
        TotemTimers_SpecSettings[i].EnhanceCDs_Order = TotemTimers_SpecSettings[i].EnhanceCDs_Order or {}
        for j = 1,3 do
            TotemTimers_SpecSettings[i].EnhanceCDs_Order[j] = TotemTimers_SpecSettings[i].EnhanceCDs_Order[j] or {}
            for k = 1, TotemTimers.num_CD_Spells[j] do
                TotemTimers_SpecSettings[i].EnhanceCDs_Order[j][k] = TotemTimers_SpecSettings[i].EnhanceCDs_Order[j][k] or k
            end
        end
    end
end
