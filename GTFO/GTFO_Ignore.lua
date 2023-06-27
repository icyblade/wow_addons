--------------------------------------------------------------------------
-- GTFO_Ignore.lua 
--------------------------------------------------------------------------
--[[
GTFO Ignore List
Author: Zensunim of Malygos

Change Log:
	v4.12
		- Implemented ignore list system
	
]]--

GTFO.IgnoreSpellCategory["HagaraWateryEntrenchment"] = {
	-- mobID = 55689; -- Hagara the Stormbinder
	spellID = 110317,
	desc = "Watery Entrenchment"
}

GTFO.IgnoreSpellCategory["Fatigue"] = {
	spellID = 3271, -- Not really the spell, but a good placeholder
	desc = "Fatigue",
	tooltip = "Alert when entering a fatigue area",
	override = true
}

