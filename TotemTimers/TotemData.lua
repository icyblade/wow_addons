-- Copyright © 2008, 2009 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.
-- Current distribution permissions only include curse.com, wowui.worldofwar.net, wowinterface.com and their respective addon updaters

TotemTimers = {}


TotemTimers.AvailableSpells = {}
TotemTimers.AvailableSpellIDs = {}
TotemTimers.MaxSpellIDs = {}
TotemTimers.AvailableTalents = {}

TotemTimers.SpellIDs = {
    StoneSkin = 8071,
    StoneClaw = 5730,
    EarthBind = 2484,
    StrengthOfEarth = 8075,
    Tremor = 8143,
    EarthElemental = 2062,
    
    Searing = 3599,
    FireNova = 1535,
    Magma = 8190,
    FlameTongue = 8227,
    FireElemental = 2894,
    
    HealingStream = 5394,
    ManaSpring = 5675,
    ManaTide = 16190,
    ElementalResistance = 8184,
    TranquilMind = 87718,
    
    Grounding = 8177,
    Windfury = 8512,
    WrathOfAir = 3738,
    SpiritLink = 98008,
    
    Ankh = 20608,
    LightningShield = 324,
    WaterShield = 52127,
    EarthShield = 974,
    TotemicCall = 36936,
    WindfuryWeapon = 8232,
    RockbiterWeapon = 8017,
    FlametongueWeapon = 8024,
    FrostbrandWeapon = 8033,
    EarthlivingWeapon = 51730,
    
    StormStrike = 17364,
    PrimalStrike = 73899,
    EarthShock = 8042,
    FrostShock = 8056,
    FlameShock = 8050,
    LavaLash = 60103,
    LightningBolt = 403,
    ChainLightning = 421,
    LavaBurst = 51505,
    Maelstrom = 53817,
    WindShear = 57994,
    ShamanisticRage = 30823,
    FeralSpirit = 51533,
    ElementalMastery = 16166,
    Thunderstorm = 51490,
    HealingRain = 73920,
    Riptide = 61295,
    UnleashElements = 73680,
    SpiritwalkersGrace = 79206,
        
    CallofSpirits = 66844,
    CallofElements = 66842,
    CallofAncestors = 66843,
    
    LavaSurge = 77762,
    
    Hex = 51514,
    BindElemental = 76780,
}

TotemTimers.BuffIDs = {
    StoneSkin = 8072,
    StrengthOfEarth = 8076,
    FlameTongue = 52109,
    TranquilMind = 87717,
    ElementalResistance = 8185,
    Wrath = 57663,
    FireResistance = 58740,
    ManaSpring = 5677,
    ManaTide = 16191,
    Grounding = 8178,
    Windfury = 8515,
    WrathOfAir = 2895,
    SpiritLink = 98007,
    Volcano = 99207,
        
    ElementalResistancePala = 19891,
    NatureResistanceHunter = 20043,
    IcyTalons = 55610,
    HuntingParty = 53290,
    HornOfWinter = 57330,
    BattleShout = 6673,
    RoarOfCourage = 93435,
    BlessingOfMight = 19740,
    FelIntelligence = 54424,
    DemonicPact = 47236,
    TotemicWrath = 77746,
    ArcaneBrilliance = 1459,
    DalaranBrilliance = 61316,
    UnleashFlame = 73683,
    MindQuickening = 49868,
    MoonkinAura = 24907,
    DevotionAura = 465,
    ConcentrationAura = 19746,
    
}

TotemTimers.SpellTextures = {}
TotemTimers.SpellNames = {}

for k,v in pairs(TotemTimers.SpellIDs) do
    local n,_,t = GetSpellInfo(v)
    TotemTimers.SpellTextures[v] = t
    TotemTimers.SpellNames[v] = n
end

TotemTimers.BuffNames = {}
for k,v in pairs(TotemTimers.BuffIDs) do
    local n = GetSpellInfo(v)
    TotemTimers.BuffNames[v] = n
end

--[[
1 - Melee
2 - Ranged
3 - Caster
4 - Healer
5 - Hybrid (mostly Enh. Shaman)
]]


TotemData = {
	[TotemTimers.SpellIDs.StoneSkin] = {
		element = EARTH_TOTEM_SLOT,
        hasBuff = TotemTimers.BuffIDs.StoneSkin,
        needed = {[1]=true,},
        moreBuffs = {TotemTimers.BuffIDs.DevotionAura,}
	},
	[TotemTimers.SpellIDs.StrengthOfEarth] = {
		element = EARTH_TOTEM_SLOT,
        hasBuff = TotemTimers.BuffIDs.StrengthOfEarth,
        needed = {[1]=true,[2]=true,[5]=true,},
        moreBuffs = {TotemTimers.BuffIDs.HornOfWinter, TotemTimers.BuffIDs.BattleShout, TotemTimers.BuffIDs.RoarOfCourage,}
	},
	[TotemTimers.SpellIDs.StoneClaw] = {
		element = EARTH_TOTEM_SLOT,
        noRangeCheck = true,
	},
	[TotemTimers.SpellIDs.Tremor] = {
		element = EARTH_TOTEM_SLOT,
        partyOnly = true,
        needed = {[1] = true, [2] = true, [3] = true, [4] = true, [5] = true,},
	},
	[TotemTimers.SpellIDs.EarthBind] = {
		element = EARTH_TOTEM_SLOT,
		flashInterval = 3,
		flashDelay = 1.7,
        noRangeCheck = true,
	},
	[TotemTimers.SpellIDs.EarthElemental] = {
		element = EARTH_TOTEM_SLOT,
        noRangeCheck = true,
	},
	[TotemTimers.SpellIDs.Searing] = {
		element = FIRE_TOTEM_SLOT,
        noRangeCheck = true,
	},
	[TotemTimers.SpellIDs.Magma] = {
		element = FIRE_TOTEM_SLOT,
        noRangeCheck = true,
	},
	[TotemTimers.SpellIDs.FlameTongue] = {
		element = FIRE_TOTEM_SLOT,
        hasBuff = TotemTimers.BuffIDs.FlameTongue,
        needed={[3]=true,[4]=true,[5]=true,},
        moreBuffs = {TotemTimers.BuffIDs.DemonicPact, TotemTimers.BuffIDs.Wrath, TotemTimers.BuffIDs.ArcaneBrilliance, TotemTimers.BuffIDs.DalaranBrilliance},
	},	
	[TotemTimers.SpellIDs.FireElemental] = {
		element = FIRE_TOTEM_SLOT,
        noRangeCheck = true,
	},	
	[TotemTimers.SpellIDs.HealingStream] = {
		element = WATER_TOTEM_SLOT,
        partyOnly = true,
        needed = {[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,},
	},
	[TotemTimers.SpellIDs.ElementalResistance] = {
		element = WATER_TOTEM_SLOT,
        hasBuff = TotemTimers.BuffIDs.ElementalResistance,
		needed = {[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,},
        moreBuffs = {TotemTimers.BuffIDs.FireResistancePala},
	},
	[TotemTimers.SpellIDs.ManaSpring] = {
		element = WATER_TOTEM_SLOT,
		hasBuff = TotemTimers.BuffIDs.ManaSpring,
		needed = {[3]=true,[4]=true,[5]=true,},
        moreBuffs = {TotemTimers.BuffIDs.BlessingOfMight, TotemTimers.BuffIDs.FelIntelligence,},
	},
	[TotemTimers.SpellIDs.TranquilMind] = {
		element = WATER_TOTEM_SLOT,
		hasBuff = TotemTimers.BuffIDs.TranquilMind,
		needed = {[3]=true,[4]=true,},
        moreBuffs = {TotemTimers.BuffIDs.ConcentrationAura},
	},
	[TotemTimers.SpellIDs.ManaTide] = {
		element = WATER_TOTEM_SLOT,
        partyOnly = true,
        needed = {[3] = true, [4] = true, [5] = true,},
	},
	[TotemTimers.SpellIDs.Grounding] = {
		element = AIR_TOTEM_SLOT,
        hasBuff = TotemTimers.BuffIDs.Grounding,
        needed = {[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,},
        partyOnly = true,
	},
	[TotemTimers.SpellIDs.Windfury] = {
		element = AIR_TOTEM_SLOT,
        hasBuff = TotemTimers.BuffIDs.Windfury,
        needed = {[1]=true,[2]=true,[5]=true,},
        moreBuffs = {TotemTimers.BuffIDs.IcyTalons, TotemTimers.BuffIDs.HuntingParty},
	},
	[TotemTimers.SpellIDs.WrathOfAir] = {
		element = AIR_TOTEM_SLOT,
        hasBuff = TotemTimers.BuffIDs.WrathOfAir,
        needed = {[3]=true,[4]=true,},
        moreBuffs = {TotemTimers.BuffIDs.MoonkinAura, TotemTimers.BuffIDs.MindQuickening},
	},
    [TotemTimers.SpellIDs.SpiritLink] = {
        element = AIR_TOTEM_SLOT,
        hasBuff = TotemTimers.BuffIDs.SpiritLink,
        needed = {[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,},
    },
}

TotemTimers_Spells = {}

--TotemTimers.TextureToName = {}
TotemTimers.NameToSpellID = {}
for k,v in pairs(TotemTimers.SpellIDs) do
    --if TotemData[TotemTimers.SpellNames[v]] then
    TotemTimers.NameToSpellID[TotemTimers.SpellNames[v]] = v
        --TotemTimers.TextureToName[TotemTimers.SpellTextures[v]] = TotemTimers.SpellNames[v]
    --end
end
TT_EMPTY_ICON = "Spell_Totem_WardOfDraining"
