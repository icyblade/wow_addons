--------------------------------------------------------------------------
-- GTFO_Fail_Classic.lua 
--------------------------------------------------------------------------
--[[
GTFO Fail List - Classic
Author: Zensunim of Malygos

Change Log:
	v3.2
		- Added Baron Geddon's Explosion
	v3.2.1
		- Added Defias Cannon's Cannonball
		- Added Glubtok's Frost Blossom
		- Added Glubtok's Fire Blossom
		- Added Helix Gearbreaker's Explode
		- Added Foe Reaper 5000's Reaper Strike
		- Added Foe Reaper 5000's Harvest Sweep
	v3.2.3
		- Added Dark Iron Land Mine's Detonation
		- Added Arcanist Doan's Detonation
	v3.2.4
		- Added Magmadar's Lava Breath
	v3.2.5
		- Added Gyth's Flame Breath
		- Added Drake's Acid Breath
	v4.9
		- Added Nethergarde Miner's Explosion
		- Added Kurinnaxx's Sand Trap
	
	
]]--

GTFO.SpellID["20476"] = {
	--desc = "Explosion (Baron Geddon, Molten Core)";
	sound = 4;
	ignoreSelfInflicted = true;
	trivialLevel = 70;
};

GTFO.SpellID["95495"] = {
	--desc = "Cannonball (Defias Cannon - Deadmines)";
	sound = 3;
	trivialLevel = 40;
};

GTFO.SpellID["88177"] = {
	--desc = "Frost Blossom (Glubtok - Deadmines)";
	sound = 3;
	trivialLevel = 40;
};

GTFO.SpellID["88173"] = {
	--desc = "Fire Blossom (Glubtok - Deadmines)";
	sound = 3;
	trivialLevel = 40;
};

GTFO.SpellID["88321"] = {
	--desc = "Explode (Helix Gearbreaker - Deadmines)";
	sound = 3;
	trivialLevel = 40;
};

GTFO.SpellID["88490"] = {
	--desc = "Reaper Strike (Foe Reaper 5000 - Deadmines)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 40;
};

GTFO.SpellID["88521"] = {
	--desc = "Harvest Sweep (Foe Reaper 5000 - Deadmines)";
	sound = 3;
	tankSound = 2;
	trivialLevel = 40;
};

GTFO.SpellID["92552"] = {
	--desc = "Detonation (Dark Iron Land Mine - Gnomeregan)";
	sound = 3;
	trivialLevel = 45;
};

GTFO.SpellID["9435"] = {
	--desc = "Detonation (Arcanist Doan - Scarlet Monastery)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 45;
};

GTFO.SpellID["19272"] = {
	--desc = "Lava Breath (Magmadar - Molten Core)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 70;
};

GTFO.SpellID["19272"] = {
	--desc = "Flame Breath (Gyth - Blackrock Spire)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 70;
};

GTFO.SpellID["19272"] = {
	--desc = "Acid Breath (Drakes - Sunken Temple)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 65;
	applicationOnly = true;
};

GTFO.SpellID["79728"] = {
	--desc = "Explosion (Nethergarde Miner, BL)";
	sound = 3;
	trivialLevel = 60;
};

GTFO.SpellID["25656"] = {
	--desc = "Sand Trap (Kurinnaxx, AQ10)";
	sound = 3;
	applicationOnly = true;
};
