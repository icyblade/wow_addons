--------------------------------------------------------------------------
-- GTFO_Fail_MP.lua 
--------------------------------------------------------------------------
--[[
GTFO Fail List - Mists of Panderia
Author: Zensunim of Malygos

Change Log:
	v4.13
		- Added Instructor Chillheart's Ice Wall
		- Added Instructor Chillheart's Frigid Grasp
		- Added Professor Slate's Fire Breath Potion
		- Added Ook-Ook's Brew Explosion
		- Added Ook-Ook's Ground Pound
		- Added Hopper's Explosive Brew
		- Added Yan-Zhu the Uncasked's Wall of Suds
		- Added Liu Flameheart's Serpent Wave
		- Added Wise Mari's Wash Away
		- Added Armsmaster Harlan's Dragon's Reach
		- Added Armsmaster Harlan's Blades of Light
		- Added Flameweaver Koegler's Greater Dragon's Breath

]]--

GTFO.SpellID["111231"] = {
	--desc = "Ice Wall (Instructor Chillheart, Scholo)";
	sound = 3;
};

GTFO.SpellID["114886"] = {
	--desc = "Frigid Grasp (Instructor Chillheart, Scholo)";
	sound = 3;
};

GTFO.SpellID["114038"] = {
	--desc = "Gravity Flux (Jandice Barov, H. Scholo)";
	sound = 3;
	test = true; -- Verify
};

GTFO.SpellID["114872"] = {
	--desc = "Fire Breath Potion (Professor Slate, Scholo)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["106648"] = {
	--desc = "Brew Explosion (Ook-Ook, SSB)";
	sound = 3;
};

GTFO.SpellID["106808"] = {
	--desc = "Ground Pound (Ook-Ook, SSB)";
	soundFunction = function() 
		-- Only alert the first failed one per volley
		GTFO_AddEvent("GroundPound", 4);
		return 3;
	end;
	ignoreEvent = "GroundPound";	
};

GTFO.SpellID["114291"] = {
	--desc = "Explosive Brew (Hopper, SSB)";
	sound = 3;
	test = true; -- Might be spammy, don't know if these are avoidable or not
};

GTFO.SpellID["114466"] = {
	--desc = "Wall of Suds (Yan-Zhu the Uncasked, SSB)";
	sound = 3;
	test = true; -- Wild guess at spell ID
};

GTFO.SpellID["106938"] = {
	--desc = "Serpent Wave (Liu Flameheart, TJS)";
	sound = 3;
};

GTFO.SpellID["106334"] = {
	--desc = "Wash Away (Wise Mari, TJS)";
	sound = 3;
	trivialPercent = 0;
};

GTFO.SpellID["111217"] = {
	--desc = "Dragon's Reach (Armsmaster Harlan, SH)";
	sound = 3;
	tankSound = 0;
	trivialPercent = 0;
};

GTFO.SpellID["112955"] = {
	--desc = "Blades of Light (Armsmaster Harlan, SH)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["113653"] = {
	--desc = "Greater Dragon's Breath (Flameweaver Koegler, SH)";
	sound = 3;
	trivialPercent = 0;
	applicationOnly = true;
};

