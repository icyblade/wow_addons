local _, race = UnitRace("player")

function ClassTimer:Races()
return race == "Scourge" and {
		GetSpellInfo(20577), -- Cannibalize
		(GetSpellInfo(7744)), -- Will of the Forsaken --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	}
	or race == "Orc" and {
		(GetSpellInfo(20572)), -- Blood Fury --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	}
	or race == "Tauren" and {
		(GetSpellInfo(20549)), -- War Stomp --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	}
	or race == "Troll" and {
		(GetSpellInfo(26297)), -- Berserking --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	}
	or race == "BloodElf" and {
		GetSpellInfo(25046), -- Arcane Torrent
		(GetSpellInfo(28734)), -- Mana Tap --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	}
	or race == "Gnome" and {
		(GetSpellInfo(20589)), -- Escape Artist --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	}
	or race == "Dwarf" and {
		(GetSpellInfo(20594)), -- Stoneform --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	}
	or race == "Draenei" and {
		(GetSpellInfo(28880)), -- Gift of the Naaru --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	}
	or {}
end
