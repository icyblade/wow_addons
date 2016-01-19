if select(2, UnitClass("player")) ~= "MONK" then
	return
end

function ClassTimer:CreateTimers()
return {
	Buffs = {
        GetSpellInfo(122278), -- Dampen Harm
		GetSpellInfo(115213), -- Avert Harm
		GetSpellInfo(124280), -- Touch of Karma
		GetSpellInfo(115308), -- Elusive Brew
		GetSpellInfo(115203), -- Fortifying Brew
		GetSpellInfo(124682), -- Enveloping Mist
		GetSpellInfo(115151), -- Renewing Mist
		GetSpellInfo(115175), -- Soothing Mist
		GetSpellInfo(115307), -- Shuffle
		GetSpellInfo(120274), -- Tiger Strikes
		GetSpellInfo(118636), -- Power Guard
		GetSpellInfo(121125), -- Death Note
		GetSpellInfo(125359), -- Tiger Power
		GetSpellInfo(115288), -- Energizing Brew
		GetSpellInfo(115295), -- Guard
		GetSpellInfo(116768), -- Combo Breaker: Blackout Kick
		GetSpellInfo(118864), -- Combo Breaker: Tiger Palm
		GetSpellInfo(101546), -- Spinning Crane Kick
		GetSpellInfo(116740), -- Tigereye Brew
		(GetSpellInfo(122783)), -- Diffuse Magic  --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	Debuffs = {
		GetSpellInfo(115804), -- Mortal Wounds
		GetSpellInfo(128531), -- Blackout Kick
		GetSpellInfo(107428), -- Rising Sun Kick
		(GetSpellInfo(115180)), -- Dizzying Haze --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	Misc = {
		GetSpellInfo(116095), -- Disable
		GetSpellInfo(119381), -- Leg Sweep
		(GetSpellInfo(115078)), -- Paralysis --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	}
}
end

