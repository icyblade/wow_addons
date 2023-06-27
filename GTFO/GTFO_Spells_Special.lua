--------------------------------------------------------------------------
-- GTFO_Spells_Special.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Special Events
Author: Zensunim of Malygos

Change Log:
	v3.2
		- Moved Apothecaries' Colognes/Perfumes
		- Moved Grand Ambassador Flamelash's Hot Spot
	v3.5.2
		- Updated Irresistible Cologne
		- Updated Irresistible Cologne Spray
		- Updated Alluring Perfume
		- Updated Alluring Perfume Spray
	v3.8
		- Added Ahune's Ice Spear
	v4.11.3
		- Added Darkmoon Faire's Stay Out!

]]--

GTFO.SpellID["68947"] = {
	--desc = "Irresistible Cologne (Love is in the Air)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["68934"] = {
	--desc = "Concentrated Irresistible Cologne Spill (Love is in the Air)";
	sound = 1;
};

GTFO.SpellID["68948"] = {
	--desc = "Irresistible Cologne Spray (Love is in the Air)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["68641"] = {
	--desc = "Alluring Perfume (Love is in the Air)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["68927"] = {
	--desc = "Concentrated Alluring Perfume Spill (Love is in the Air)";
	sound = 1;
};

GTFO.SpellID["68607"] = {
	--desc = "Alluring Perfume Spray (Love is in the Air)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["77280"] = {
	--desc = "Hot Spot (Grand Ambassador Flamelash, Blackrock Depths - Pre-Cataclysm Event)";
	sound = 1;
};

-- ==============================================================================
-- Fail alerts
-- ==============================================================================

GTFO.SpellID["46588"] = {
	--desc = "Ice Spear (Ahune - Midsummer)";
	sound = 3;
};

GTFO.SpellID["46198"] = {
	--desc = "Cold Slap (Ahune - Midsummer)";
	sound = 3;
};

GTFO.SpellID["47310"] = {
	--desc = "Disarm (Coren Direbrew - Brewfest)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["109976"] = {
	--desc = "Stay Out! (Jessica Rogers, Darkmoon Faire)";
	sound = 3;
};

GTFO.SpellID["109977"] = {
	--desc = "Stay Out! (Mola, Darkmoon Faire)";
	sound = 3;
};

GTFO.SpellID["109972"] = {
	--desc = "Stay Out! (Finlay Coolshot, Darkmoon Faire)";
	sound = 3;
};
