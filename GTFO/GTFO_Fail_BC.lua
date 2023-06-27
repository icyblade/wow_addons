--------------------------------------------------------------------------
-- GTFO_Fail_BC.lua 
--------------------------------------------------------------------------
--[[
GTFO Fail List - Burning Crusade
Author: Zensunim of Malygos

Change Log:
	v2.9.1
		- Added Shadowmoon Technician's Proximity Bomb
	v3.0
		- Added Shade of Aran's Arcane Explosion
		- Added Netherspite's Cleave
		- Added Netherspite's Smoldering Breath
		- Added Netherspite's Tail Sweep
		- Added Prince Malchezaar's Shadow Nova
	v3.0.1
		- Added Mennu the Betrayer's Fire Nova
		- Added Ghaz'an's Acid Breath
		- Added Ghaz'an's Tail Sweep
		- Added Talon King Ikiss's Arcane Explosion
		- Added Ambassador Hellmaw's Corrosive Acid
		- Added Gatewatcher's Stream of Machine Fluid
		- Added Hungarfen's Spore Cloud
		- Added Epoch Hunter's Sand Breath
		- Added Aeonus's Sand Breath
		- Added Kaz'rogal's Malevolent Cleave
		- Added Azgalor's Cleave
		- Added Gurtogg Bloodboil's Arcing Smash		
	v3.2
		- Added Mother Shahraz's Saber Lash
		- Added Lurker's Spout
		- Added Murmur's Sonic Boom
		- Updated Gatewatcher's Stream of Machine Fluid
		- Added Mechano-Lord Capacitus's Nether Detonation
	v3.2.1
		- Added Magtheridon's Cleave
		- Added Gruul's Hurtful Strike
		- Added Gruul's Shatter
		- Added Lair Brute's Cleave
		- Added High King Maulgar's Arcing Smash		
	v3.2.4
		- Added Attumen the Huntsman's Shadow Cleave
		- Added Tinhead's Cleave
		- Added Shade of Aran's Explosion (Flame Wreath)
		
]]--

GTFO.SpellID["30844"] = {
	--desc = "Proximity Bomb (Shadowmoon Technician - Blood Furnace)";
	sound = 3;
	trivialLevel = 80;
};

GTFO.SpellID["32786"] = {
	--desc = "Proximity Bomb (Shadowmoon Technician - Blood Furnace Heroic)";
	sound = 3;
	trivialLevel = 80;
};

GTFO.SpellID["29973"] = {
	--desc = "Arcane Explosion (Shade of Aran - Karazhan)";
	sound = 3;
	trivialLevel = 80;
};

GTFO.SpellID["30131"] = {
	--desc = "Cleave (Nightbane - Karazhan)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["30210"] = {
	--desc = "Smoldering Breath (Nightbane - Karazhan)";
	sound = 3;
	tankSound = 0;
	applicationOnly = true;
	trivialLevel = 80;
};

GTFO.SpellID["25653"] = {
	--desc = "Tail Sweep (Nightbane - Karazhan)";
	sound = 3;
	applicationOnly = true;
	trivialLevel = 80;
};

GTFO.SpellID["30852"] = {
	--desc = "Shadow Nova (Prince Malchezaar - Karazhan)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["33132"] = {
	--desc = "Fire Nova (Mennu the Betrayer - Slave Pens)";
	sound = 3;
	trivialLevel = 80;
};

GTFO.SpellID["34268"] = {
	--desc = "Acid Breath (Ghaz'an - The Underbog)";
	sound = 3;
	tankSound = 0;
	applicationOnly = true;
	trivialLevel = 80;
};

GTFO.SpellID["34267"] = {
	--desc = "Tail Sweep (Ghaz'an - The Underbog)";
	sound = 3;
};

GTFO.SpellID["38737"] = {
	--desc = "Tail Sweep (Ghaz'an - The Underbog Heroic)";
	sound = 3;
};

GTFO.SpellID["38197"] = {
	--desc = "Arcane Explosion (Talon King Ikiss - Sethekk Halls)";
	sound = 3;
	trivialLevel = 80;
};

GTFO.SpellID["40425"] = {
	--desc = "Arcane Explosion (Talon King Ikiss - Sethekk Halls - Heroic)";
	sound = 3;
	trivialLevel = 80;
};

GTFO.SpellID["34268"] = {
	--desc = "Corrosive Acid (Ambassador Hellmaw - Shadow Labyrinth)";
	sound = 3;
	tankSound = 0;
	applicationOnly = true;
	trivialLevel = 80;
};

GTFO.SpellID["35311"] = {
	--desc = "Stream of Machine Fluid (Gatewatchers - Mechanar)";
	sound = 3;
	tankSound = 0;
	applicationOnly = true;
	trivialLevel = 80;
};

GTFO.SpellID["34168"] = {
	--desc = "Spore Cloud (Hungarfen - Underbog)";
	sound = 3;
	trivialLevel = 80;
	applicationOnly = true;
};

GTFO.SpellID["31914"] = {
	--desc = "Sand Breath (Epoch Hunter - CoT:OHF)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["31473"] = {
	--desc = "Sand Breath (Aeonus - CoT:BM)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["39049"] = {
	--desc = "Sand Breath (Aeonus - CoT:BM - Heroic)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["31436"] = {
	--desc = "Malevolent Cleave (Kaz'rogal - CoT:HS)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["31345"] = {
	--desc = "Cleave (Azgalor - CoT:HS)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["40599"] = {
	--desc = "Arcing Smash (Gurtogg Bloodboil - Black Temple)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["40599"] = {
	--desc = "Saber Lash (Mother Shahraz - Black Temple)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["37433"] = {
	--desc = "Spout (Lurker - SSC)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["33666"] = {
	--desc = "Sonic Boom (Murmur - Shadow Labyrinth)";
	sound = 3;
	applicationOnly = true;
	trivialLevel = 80;
};

GTFO.SpellID["38795"] = {
	--desc = "Sonic Boom (Murmur - Shadow Labyrinth Heroic)";
	sound = 3;
	applicationOnly = true;
	trivialLevel = 80;
};

GTFO.SpellID["35152"] = {
	--desc = "Nether Detonation (Mechano-Lord Capacitus - Mechanar)";
	sound = 3;
	trivialLevel = 80;
};

GTFO.SpellID["30619"] = {
	--desc = "Cleave (Magtheridon)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["33813"] = {
	--desc = "Hurtful Strike (Gruul)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 85;
};

GTFO.SpellID["33671"] = {
	--desc = "Shatter (Gruul)";
	sound = 3;
	trivialLevel = 80;
};

GTFO.SpellID["39174"] = {
	--desc = "Cleave (Lair Brute - Gruul's Lair)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["39174"] = {
	--desc = "Arcing Smash (High King Maulgar - Gruul's Lair)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["29832"] = {
	--desc = "Shadow Cleave (Attumen the Huntsman - Karazhan)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["31043"] = {
	--desc = "Tinhead (Attumen the Huntsman - Karazhan)";
	sound = 3;
	tankSound = 0;
	trivialLevel = 80;
};

GTFO.SpellID["29949"] = {
	--desc = "Explosion (Flame Wreath) (Shade of Aran - Karazhan)";
	sound = 3;
};

