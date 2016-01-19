if select(2, UnitClass("player")) ~= "SHAMAN" then
	return
end

function ClassTimer:CreateTimers()
return {
	Buffs= {
		GetSpellInfo(16176), -- Ancestral Healing
		GetSpellInfo(30160), -- Elemental Devastation
		GetSpellInfo(64701), -- Elemental Mastery (Haste + Damage Buff)
		GetSpellInfo(16166), -- Elemental Mastery (Instant)
		GetSpellInfo(29062), -- Eye of the Storm
		GetSpellInfo(29206), -- Healing Way
		GetSpellInfo(30823), -- Shamanistic Rage
--		GetSpellInfo(51528), -- Maelstrom Weapon
--		GetSpellInfo(51730), -- Earthliving Weapon
--		GetSpellInfo(8024), -- Flametongue Weapon
--		GetSpellInfo(8232), -- Windfury Weapon
		GetSpellInfo(16246), -- Clearcasting
		GetSpellInfo(73683), -- Unleash Flame
		GetSpellInfo(73681), -- Unleash Wind
		GetSpellInfo(51945), -- Earthliving
		GetSpellInfo(55198), -- Tidal Force
		GetSpellInfo(79206), -- Spiritwalker's Grace
		GetSpellInfo(17364), -- Stormstrike
		GetSpellInfo(61295), -- Riptide
		GetSpellInfo(51562), -- Tidal Waves
		GetSpellInfo(131), -- Water Breathing
		GetSpellInfo(546), -- Water Walking
		GetSpellInfo(117014), -- Elemental Blast
		GetSpellInfo(114050), -- Ascendance (Ele)
		GetSpellInfo(114051), -- Ascendance (Enhance)
		GetSpellInfo(114052), -- Ascendance (Resto)
		(GetSpellInfo(30802)), -- Unleashed Rage --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	Shocks = {
		GetSpellInfo(73684), -- Unleash Earth
		GetSpellInfo(73682), -- Unleash Frost
		GetSpellInfo(8042), -- Earth Shock
		GetSpellInfo(8050), -- Flame Shock
		GetSpellInfo(115798), -- Weakened Blows 
		(GetSpellInfo(8056)), -- Frost Shock --Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
	Shields = {
		GetSpellInfo(324), --Lightning Shield
		GetSpellInfo(974), --Earth Shield
		(GetSpellInfo(52127)), --Water Shield -Important: Double parentheses are necessary because the last item in a table contains all the values from the function call and we only want the first one.
	},
}
end
