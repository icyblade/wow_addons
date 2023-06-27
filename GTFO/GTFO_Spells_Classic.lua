--------------------------------------------------------------------------
-- GTFO_Spells_Classic.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Classic
Author: Zensunim of Malygos

Change Log:
	v2.0.1
		- Added Cloud of Disease
	v2.0.2
		- Added Apothecaries' Colognes/Perfumes (Love is in the Air bosses)
	v2.5
		- Split spell files into sections
	v2.5.1
		- Added Magmadar's Conflagration
	v2.5.2
		- Disabled Magmadar's Conflagration
	v2.9.1
		- Added Gehennas's Rain of Fire
	v3.0.2
		- Added Grand Ambassador Flamelash's Hot Spot
	v3.2
		- Moved Apothecaries' Colognes/Perfumes
		- Moved Grand Ambassador Flamelash's Hot Spot
		- Added Baron Geddon's Inferno
	v3.2.1
		- Added General Drakkisath's Conflagration
		- Added Foe Reaper 5000's Overdrive
		- Added Foe Reaper 5000's Harvest
		- Added "Captain" Cookie's Rotten Aura		
		- Added Diseased Ghoul's Cloud of Disease
		- Added Vectus's Flamestrike
		- Added Skeletal Guardian's Blizzard
	v3.2.3
		- Added Bloodmage Thalnos's Flame Spike
		- Added Tinkerer Gizlock's Goblin Dragon Gun
	v3.2.4
		- Added Irradiated Slime's Radiation Cloud
		- Added Herod's Whirlwind
		- Added Creeping Sludge's Poison Shock
	v3.2.5
		- Added Jammal'an the Prophet's Flamestrike
	v4.3.2
		- Added Sea Cyclone
	v4.11.4
		- Added Death's Step Miscreation's Toxic Waste

]]--

GTFO.SpellID["17742"] = {
	--desc = "Cloud of Disease (Scholomance - Old)";
	sound = 2;
	trivialLevel = 70;
};

GTFO.SpellID["19428"] = {
	--desc = "Conflagration (Magmadar, Molten Core)";
	sound = 1;
	applicationOnly = true;
	trivialLevel = 70;
};

GTFO.SpellID["19717"] = {
	--desc = "Rain of Fire (Gehennas, Molten Core)";
	sound = 2;
	trivialLevel = 70;
};

GTFO.SpellID["19698"] = {
	--desc = "Inferno (Baron Geddon, Molten Core)";
	sound = 1;
	trivialLevel = 70;
};

GTFO.SpellID["10363"] = {
	--desc = "Conflagration (General Drakkisath, UBRS)";
	sound = 4;
	ignoreSelfInflicted = true;
	trivialLevel = 70;
};

GTFO.SpellID["86633"] = {
	--desc = "Rain of Fire (Lord Overheat - Stockades)";
	sound = 2;
	trivialLevel = 40;
};

GTFO.SpellID["88484"] = {
	--desc = "Overdrive (Foe Reaper 5000 - Deadmines)";
	sound = 1;
	tankSound = 2;
	trivialLevel = 40;
};

GTFO.SpellID["88501"] = {
	--desc = "Harvest (Foe Reaper 5000 - Deadmines)";
	sound = 1;
	tankSound = 2;
	trivialLevel = 40;
};

GTFO.SpellID["89735"] = {
	--desc = "Rotten Aura ("Captain" Cookie - Deadmines)";
	sound = 1;
	trivialLevel = 40;
};

GTFO.SpellID["81285"] = {
	--desc = "Cloud of Disease (Diseased Ghoul - Scholomance)";
	sound = 1;
	trivialLevel = 60;
};

GTFO.SpellID["18399"] = {
	--desc = "Flamestrike (Vectus - Scholomance)";
	sound = 2;
	trivialLevel = 80;
};

GTFO.SpellID["8364"] = {
	--desc = "Blizzard (Skeletal Guardian - Stratholme)";
	sound = 2;
	trivialLevel = 60;
};

GTFO.SpellID["93691"] = {
	--desc = "Desecration (Commander Springvale - Shadowfang Keep)";
	sound = 1;
	trivialLevel = 40;
};

GTFO.SpellID["93535"] = {
	--desc = "Ice Shards (Lord Walden - Shadowfang Keep)";
	sound = 1;
	trivialLevel = 40;
};

GTFO.SpellID["93564"] = {
	--desc = "Pistol Barrage (Lord Godfrey - Shadowfang Keep)";
	sound = 1;
	trivialLevel = 40;
};

GTFO.SpellID["8814"] = {
	--desc = "Flame Spike (Bloodmage Thalnos - Scarlet Monastery)";
	sound = 2;
	trivialLevel = 45;
};

GTFO.SpellID["21910"] = {
	--desc = "Goblin Dragon Gun (Tinkerer Gizlock - Maraudon)";
	sound = 2;
	tankSound = 0;
	trivialLevel = 60;
};

GTFO.SpellID["10341"] = {
	--desc = "Radiation Cloud (Irradiated Slime - Gnomeregan)";
	sound = 2;
	trivialLevel = 45;
};

GTFO.SpellID["15578"] = {
	--desc = "Poison Shock (Creeping Sludge - Maraudon)";
	sound = 2;
	tankSound = 0;
	trivialLevel = 50;
};

GTFO.SpellID["12468"] = {
	--desc = "Flamestrike (Jammal'an the Prophet - Sunken Temple)";
	sound = 2;
	trivialLevel = 60;
	specificMobs = { 3975 };
};

GTFO.SpellID["89529"] = {
	--desc = "Sea Cyclone (Sea Cyclone - Thousand Needles)";
	sound = 2;
	trivialLevel = 50;
};

GTFO.SpellID["83019"] = {
	--desc = "Toxic Waste (Death's Step Miscreation - Eastern Plaguelands)";
	sound = 2;
	trivialLevel = 50;
};
