--------------------------------------------------------------------------
-- GTFO_Spells_MP.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Mists of Panderia
Author: Zensunim of Malygos

Change Log:
	v4.13
		- Added Instructor Chillheart's Burn
		- Added Instructor Chillheart's Ice Wave
		- Added Instructor Chillheart's Ice Wrath
		- Added Instructor Chillheart's Arcane Bomb
		- Added Jandice Barov's Wondrous Rapidity
		- Added Lilian Voss's Dark Blaze
		- Added Rattlegore's Soulflame
		- Added Professor Slate's Toxic Potion
		- Added Brother Korloff's Scorched Earth
		- Added Brother Korloff's Firestorm Kick
		- Added Hoptallus's Furlwind
		- Added Hoptallus's Carrot Breath
		- Added Fizzy Brew Alemental's Carbonation
		- Added Yan-Zhu the Uncasked's Blackout Brew
		- Added Yan-Zhu the Uncasked's Carbonation
		- Added Yan-Zhu the Uncasked's Bloat
		- Added Minion of Doubt's Shadow of Doubt
		- Added Liu Flameheart's Jade Serpent Wave
		- Added Liu Flameheart's Jade Fire
		- Added Sodden Hozen Brawler's Fire Strike
		- Added Sodden Hozen Brawler's Water Strike
		- Added Wise Mari's Corrupted Waters
		- Added Wise Mari's Hydrolance Pulse
		- Added Loremaster Stonestep's Swirling Sunfire
		- Added Loremaster Stonestep's Swirling Sunfire
		- Added Sha of Doubt's Nothingness		
		- Added Scarlet Flamethrower's Flamethrower
		- Added Thalnos the Soulrender's Spirit Gale
		- Added High Inquisitor Whitemane's Flamestrike
		- Added Commander Lindon's Exploding Shot
		- Added Flameweaver Koegler's Burning Books
		
]]--

GTFO.SpellID["120027"] = {
	--desc = "Burn (Instructor Chillheart, Scholo)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["120037"] = {
	--desc = "Ice Wave (Instructor Chillheart, Scholo)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["111616"] = {
	--desc = "Ice Wrath (Instructor Chillheart, Scholo)";
	sound = 4;
	trivialPercent = 0;
	test = true; -- Needs verification/testing
};

GTFO.SpellID["113859"] = {
	--desc = "Arcane Bomb (Instructor Chillheart, Scholo)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114061"] = {
	--desc = "Wondrous Rapidity (Jandice Barov, Scholo)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["111628"] = {
	--desc = "Dark Blaze (Lilian Voss, Scholo)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114009"] = {
	--desc = "Soulflame (Rattlegore, Scholo)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114873"] = {
	--desc = "Toxic Potion (Professor Slate, Scholo)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114465"] = {
	--desc = "Scorched Earth (Brother Korloff, SC)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["113766"] = {
	--desc = "Firestorm Kick (Brother Korloff, SC)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["112993"] = {
	--desc = "Furlwind (Hoptallus, SSB)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["112945"] = {
	--desc = "Carrot Breath (Hoptallus, SSB)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["116170"] = {
	--desc = "Carbonation (Fizzy Brew Alemental, SSB)";
	sound = 1;
	alwaysAlert = true;
};

GTFO.SpellID["106851"] = {
	--desc = "Blackout Brew (Yan-Zhu the Uncasked, SSB)";
	sound = 1;
	applicationOnly = true;
	minimumStacks = 4;
	test = true; -- Verify
};

GTFO.SpellID["114386"] = {
	--desc = "Carbonation (Yan-Zhu the Uncasked, SSB)";
	sound = 1;
	alwaysAlert = true;
};

GTFO.SpellID["106546"] = {
	--desc = "Bloat (Yan-Zhu the Uncasked, SSB)";
	sound = 4;
	trivialPercent = 0;
	damageMinimum = 1; -- Ignore application
	test = true; -- This spell doesn't appear to be working correctly in Beta
};

GTFO.SpellID["110099"] = {
	--desc = "Shadow of Doubt (Minion of Doubt, TJS)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["118540"] = {
	--desc = "Jade Serpent Wave (Liu Flameheart, TJS)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["107110"] = {
	--desc = "Jade Fire (Liu Flameheart, TJS)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["107046"] = {
	--desc = "Water Strike (Sodden Hozen Brawler, SSB)";
	sound = 1;
	tankSound = 0;
	trivialPercent = 0;
};

GTFO.SpellID["107176"] = {
	--desc = "Fire Strike (Inflamed Hozen Brawler, SSB)";
	sound = 1;
	tankSound = 0;
	trivialPercent = 0;
};

GTFO.SpellID["115167"] = {
	--desc = "Corrupted Waters (Wise Mari, TJS)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["106267"] = {
	--desc = "Hydrolance Pulse (Wise Mari, TJS)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["106319"] = {
	--desc = "Hydrolance Pulse (Wise Mari, TJS)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["111720"] = {
	--desc = "Swirling Sunfire (Loremaster Stonestep, TJS)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["106653"] = {
	--desc = "Sha Residue (Corrupt Living Water, TJS)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["106228"] = {
	--desc = "Nothingness (Sha of Doubt, TJS)";
	sound = 4;
	negatingDebuffSpellID = 106113; -- Touch of Nothingness
	trivialPercent = 0;
	negatingIgnoreTime = 2;
};

GTFO.SpellID["106228"] = {
	--desc = "Flamethrower (Scarlet Flamethrower, SC)";
	sound = 1;
	tankSound = 2;
	trivialPercent = 0;
};

GTFO.SpellID["115291"] = {
	--desc = "Spirit Gale (Thalnos the Soulrender, SC)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["110963"] = {
	--desc = "Flamestrike (High Inquisitor Whitemane, SC)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["114863"] = {
	--desc = "Exploding Shot (Commander Lindon, SH)";
	sound = 1;
	trivialPercent = 0;
};

GTFO.SpellID["113620"] = {
	--desc = "Burning Books (Flameweaver Koegler, SH)";
	sound = 1;
	trivialPercent = 0;
};

