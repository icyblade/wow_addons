if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then
	return
end

function ClassTimer:CreateTimers()
return {
	Misc = {
		GetSpellInfo(51271), -- Unbreakable Armor
		GetSpellInfo(49039), -- Lichborne
		GetSpellInfo(48792), -- Icebound Fortitude
		GetSpellInfo(55095), -- Frost Fever
        GetSpellInfo(81131), -- Scarlet Fever
        GetSpellInfo(49194), -- Unholy Blight
		GetSpellInfo(22744), -- Chains of Ice
		GetSpellInfo(55078), -- Blood Plague
		GetSpellInfo(51726), -- Ebon Plague
		GetSpellInfo(59052), -- Freezing Fog
		GetSpellInfo(51123), -- Killing Machine
		GetSpellInfo(57330), -- Horn of Winter
        GetSpellInfo(49182), -- Blade Barrier
        GetSpellInfo(55233), -- Vampiric Blood
		GetSpellInfo(63560), -- Ghoul Frenzy (Pet)
        GetSpellInfo(63560), -- Dark Transformation (Pet)
		(GetSpellInfo(49222)), -- Bone Shield --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	
	DOTs = {
		(GetSpellInfo(115798)), -- Weakened Blows 
	},
}
end
