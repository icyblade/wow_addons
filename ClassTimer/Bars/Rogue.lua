if select(2, UnitClass("player")) ~= "ROGUE" then
	return
end

function ClassTimer:CreateTimers()
return {
	Buffs = {
		GetSpellInfo(13750), -- Adrenaline Rush
        GetSpellInfo(32645), -- Envenom
		GetSpellInfo(13877), -- Blade Flurry
		GetSpellInfo(1966), -- Feint
		GetSpellInfo(31224), -- Cloak of Shadows
		GetSpellInfo(74001), -- Combat Readiness
		GetSpellInfo(5277), -- Evasion
        GetSpellInfo(73651), -- Recuperate
		GetSpellInfo(36554), -- Shadowstep
		GetSpellInfo(5171), -- Slice and Dice
		GetSpellInfo(2983), -- Sprint
		GetSpellInfo(51713), -- Shadow Dance
		GetSpellInfo(121471), -- Shadow Blades
        GetSpellInfo(58426), -- Overkill
		GetSpellInfo(51690), --Killing Spree
		GetSpellInfo(114015), --Anticipation
		GetSpellInfo(76577), -- Smoke Bomb
		GetSpellInfo(84745), -- Shallow Insight
		GetSpellInfo(84746), -- Moderate Insight
		GetSpellInfo(84747), -- Deep Insight
		GetSpellInfo(156744), -- Shadow Reflection
		(GetSpellInfo(1856)), -- Vanish --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	DOTs = {
		GetSpellInfo(703), -- Garrote
        GetSpellInfo(79140), -- Vendetta
		GetSpellInfo(84617), -- Revealing Strike
		GetSpellInfo(112947), -- Nerve Strike
		GetSpellInfo(2823), -- Deadly Poison
		GetSpellInfo(108211), -- Leeching Poison
		GetSpellInfo(8679), -- -- Wound Poison
		GetSpellInfo(3408), -- Crippling Poison
		GetSpellInfo(157584), -- Instant Poison
		GetSpellInfo(121411), -- Crimson Tempest
		GetSpellInfo(135345), -- Internal Bleeding
		(GetSpellInfo(1943)), -- Rupture --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	Poisons = {
		GetSpellInfo(3408), -- Crippling Poison
		GetSpellInfo(2823), -- Deadly Poison
		GetSpellInfo(157584), -- Instant Poison
		GetSpellInfo(108211), -- Leeching Poison
		(GetSpellInfo(8679)), -- Wound Poison --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	Stuns = {
		GetSpellInfo(2094), -- Blind
		GetSpellInfo(1833), -- Cheap Shot
		GetSpellInfo(1776), -- Gouge
		GetSpellInfo(408), -- Kidney Shot
		(GetSpellInfo(6770)), -- Sap --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	Misc = {
		GetSpellInfo(1330), -- Garrote - Silence
		GetSpellInfo(18425), -- Kick - Silenced
		GetSpellInfo(26679), -- Deadly Throw
		GetSpellInfo(166878), -- Deceit -- T17 Combat 4pc proc
		(GetSpellInfo(16511)), -- Hemorrhage --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
}
end
