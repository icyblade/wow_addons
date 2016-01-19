if select(2, UnitClass("player")) ~= "PALADIN" then
	return
end

function ClassTimer:CreateTimers()
return {
	Blessings = {
		GetSpellInfo(1044), -- Hand of Freedom
		GetSpellInfo(1022), -- Hand of Protection
		GetSpellInfo(6940), -- Hand of Sacrifice
		GetSpellInfo(1038), -- Hand of Salvation
		GetSpellInfo(20217), -- Blessing of Kings
		(GetSpellInfo(19740)), -- Blessing of Might -- Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	Buffs = {
		GetSpellInfo(31884), -- Avenging Wrath
        GetSpellInfo(31850), -- Ardent Defender
		GetSpellInfo(498), -- Divine Protection
		GetSpellInfo(642), -- Divine Shield
		GetSpellInfo(53601), -- Sacred Shield
        GetSpellInfo(53709), -- Sacred Duty
		GetSpellInfo(53486), -- The Art of War
        GetSpellInfo(84963), -- Inquisition
		(GetSpellInfo(20925)), -- Holy Shield -- Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	Seals = {
		GetSpellInfo(20165), -- Seal of Insight
		GetSpellInfo(31801), -- Seal of Truth
		(GetSpellInfo(20154)), -- Seal of Righteousness -- Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	Stuns = {
		GetSpellInfo(853), -- Hammer of Justice
		(GetSpellInfo(20066)), -- Repentance -- Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	Misc = {
		GetSpellInfo(53380), -- Righteous Vengeance
		GetSpellInfo(31935), -- Avenger's Shield
		GetSpellInfo(26573), -- Consecration
		GetSpellInfo(31842), -- Divine Illumination
		GetSpellInfo(64205), -- Divine Sacrifice
		GetSpellInfo(53563), -- Beacon of Light
		GetSpellInfo(31833), -- Light's Grace
		GetSpellInfo(53672), -- Infusion of Light
		GetSpellInfo(20127), -- Redoubt
		GetSpellInfo(10326), -- Turn Evil
		GetSpellInfo(20049), -- Vengeance
		GetSpellInfo(20335), -- Heart of the Crusader
		GetSpellInfo(53380), -- Righteous Vengeance
		GetSpellInfo(31803), -- Holy Vengeance
		GetSpellInfo(31803), -- Censure
		(GetSpellInfo(9452)), -- Vindication -- Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	}
}
end
