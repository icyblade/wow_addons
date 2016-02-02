if select(2, UnitClass("player")) ~= "DEMONHUNTER" then
	return
end

function ClassTimer:CreateTimers()
return {
	Buffs = {
		(GetSpellInfo(188501)), -- Spectral Sight --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
}
end
