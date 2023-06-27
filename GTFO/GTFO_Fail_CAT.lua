--------------------------------------------------------------------------
-- GTFO_Fail_CAT.lua 
--------------------------------------------------------------------------
--[[
GTFO Fail List - Cataclysm (New areas)
Author: Zensunim of Malygos

Change Log:
	v2.3
		- Added Lady Naz'jar's Fungal Spores
		- Added Commander Ulthok's Dark Fissure (Impact)
		- Added Erunak Stonespeaker's Magma Splash
		- Added Stonecore's Stalactite
	v2.4
		- Added Slabhide's Sand Blast
		- Added Stonecore Bruiser's Shockwave
		- Added Ozruk's Ground Slam
		- Added High Priestess Azil's Seismic Shard
	v2.5
		- Split spell files into sections
		- Added Rom'ogg Bonecrusher's Skullcracker
		- Added Rom'ogg Bonecrusher's Ground Rupture
		- Added Karsh Steelbender's Lava Spout
		- Added Young Storm Dragon's Chilling Blast
		- Added Titanic Guardian's Meteor Blast
		- Added Titanic Guardian's Blazing Eruption
	v2.5.1
		- Added Highbank's Artillery Barrage
		- Added Dragonmaw Hold's Blade Strike
		- Added Servias Windterror's Static Flux Detonation
		- Added Obsidian Stoneslave's Rupture Line
		- Added Bloodgorged Ettin's Log Smash
		- Added General Umbriss's Ground Siege
		- Added Twilight Drake's Twilight Breath
		- Added Erudax's Binding Shadows
		- Fixed Young Strom Dragon's Chilling Blast
		- Added Karsh Steelbender's Lava Spout (Heroic)
		- Added Young Storm Dragon's Chilling Blast (Heroic)
	v2.5.2
		- Added Water Warden's Aqua Bomb
		- Added Air Warden's Whirling Winds
		- Added Earth Warden's Rockwave
		- Added Rajh's Solar Winds
		- Added Lady Naz'jar's Fungal Spores (Heroic)
		- Added Stonecore's Stalactite (Heroic)
		- Added Stonecore's Crystal Shards (Heroic)
		- Added Stonecore's Magma Eruption (Heroic)
		- Added Slabhide's Sand Blast (Heroic)
		- Added Stonecore Bruiser's Shockwave (Heroic)
		- Added Ozruk's Ground Slam (Heroic)
		- Added High Priestess Azil's Seismic Shard (Heroic)
		- Added General Husam's Shockwave
		- Added General Husam's Mystic Trap
		- Added Siamat's Cloud Burst
	v2.5.3
		- Added Invoked Flaming Spirit's Supernova
		- Added Foe Reaper 5000's Reaper Strike (Heroic)
		- Added Defias Watcher's Cleave (Heroic)
	v3.0.1
		- Updated Foe Reaper 5000's Reaper Strike (Heroic)
		- Added Foe Reaper 5000's Harvest Sweep (Heroic)
		- Added Defias Watcher's Cleave (Heroic)
		- Added Defias Cannon's Cannonball (Heroic)
		- Added Collapsing Icicle's Ice Shards (Heroic)
		- Added Helix Gearbreaker's Chest Bomb (Heroic)
		- Added Sticky Bomb's Explode (Heroic)
	v3.0.2
		- Added Theralion's Dazzling Destruction (Twilight)
		- Added Theralion's Twilight Flames (Twilight)
		- Added Elementium Monstrosity's Lava Plume
	v3.1
		- Added Toxitron's Poison Bomb
		- Added Maloriak's Absolute Zero
		- Added Atramedes's Sonar Bomb
		- Added Rohash's Wind Blast
		- Added Rohash's Tornado
		- Added Al'Akir's Squall Line
		- Added Al'Akir's Lightning Clouds		
		- Added Sorcerous Skeleton's Living Bomb Explosion
	v3.2.5
		- Removed Rom'ogg Bonecrusher's Ground Rupture
		- Added Obsidian Colossus's Shadow Storm
		- Added Obsidian Colossus's Sweeping Attack
		- Added Executor of the Caliph's Shockwave
		- Added Lady Naz'jar's Geyser
		- Added Lady Naz'jar Honor Guard's Arc Slash
	v3.2.6
		- Added Hurp'Derp's Overhead Smash
		- Added Torg Drakeflayer's Liquid Flame
		- Added Cadaver Collage's Belch
		- Added Emberscar the Devourer's Magmatic Fault
		- Added Altairus's Twisting Winds 
		- Added Falling Boulder's Searing Stone
	v3.2.7
		- Added Earthrager Ptah's Earth Spike (Heroic)
		- Added Earthrager Ptah's Consume (Heroic)
		- Added Isiset's Supernova
		- Added Ragnaros's Flame Tsunami
		- Added Ragnaros's Lava Strike
	v3.3
		- Added Ozruk's Shatter (Heroic)
		- Added Lady Naz'jar's Waterspout (Heroic)
		- Added Ozruk's Rupture (Heroic)
		- Added Crystalspawn Giant's Quake (Heroic)
		- Added Corborus's Thrashing Charge
		- Moved Al'Akir's Lightning Clouds
	v3.3.1
		- Added Magmaw's Infectious Vomit
		- Added Magmaw's Pillar of Flame
		- Added Onyxia and Nefarian's Tail Lash
		- Added Onyxia and Nefarian's Shadowflame Breath
		- Added Asaad's Static Cling
		- Added Grand Vizier Ertan's Cyclone Shield 		
		- Added Magmaw's Massive Crash
	v3.3.2
		- Added Drakonid Chainwielder's Overhead Smash
		- Added Halfus Wyrmbreaker's Fireball Barrage
		- Added Shadow Lord's Gripping Shadow
		- Added Fire Elemental's Concussive Blast
	v3.4
		- Added General Umbriss's Blitz
		- Added Maimgor's Tail Lash
		- Added Drakonid Slayer's Cleave
		- Fixed Erunak Stonespeaker's Magma Splash
	v3.4.1
		- Fixed Halfus Wyrmbreaker's Fireball Barrage
	v3.5
		- Fixed Falling Boulder's Searing Stone
		- Added Bound Rumbler's Shockwave
		- Added Evolved Drakonaar's Twilight Rupture
		- Updated Shadow Lord's Gripping Shadow
		- Added Jora Wildwing's Stormhammer
		- Added Crystalspawn Giant's Quake (Normal)
	v3.5.1
		- Added Lava Parasite's Parasitic Infection
	v3.5.4
		- Added Cho'gall's Corrupting Crash
	v3.5.5
		- Fixed Rohash's Tornado
		- Added Nefarian's Hail of Bones
	v4.0
		- Added Sethria's Twilight Fissure
		- Added Zul'Gurub's Exploding Boulder
		- Added Zul'Gurub's Boulder Smash
		- Added Bloodlord Mandokir's Devastating Slam
		- Added High Priestess Kilnara's Wave of Agony
		- Added Gurubashi Cauldron-Mixer's Gout of Flame
		- Added Jin'do the Godbreaker's Shadow Spike
		- Added Amani'shi Warbringer's Cleave
		- Added Jin'alai's Fire Bomb
	v4.1
		- Added Sinestra's Twilight Extinction
	v4.2
		- Added Magmaw's Blazing Inferno
		- Added Arcanotron's Arcane Blowback
		- Removed Al'Akir's Squall Line
	v4.2.1
		- Added Hex Lord Malacrass's Fire Nova Totem
	v4.2.2
		- Moved Onyxia and Nefarian's Shadowflame Breath
	v4.2.3
		- Added Wushoolay's Lightning Rod
		- Added Golem Sentry's Flash Bomb
	v4.3.1
		- Added Gri'lek's Rupture Line
	v4.4
		- Added Beth'tilac's Meteor Burn
		- Added Beth'tilac's Smoldering Devastation
		- Added Beth'tilac's Volatile Burst
		- Added Alysrazor's Blazing Claw
		- Added Shannox's Immolation Trap
		- Added Shannox's Crystal Prison Trap
		- Added Ragnaros's Lava Wave
		- Added Demon Containment Unit's Demon Repellent Ray
		- Added Argaloth's Meteor Slash
	v4.5
		- Updated Argaloth's Meteor Slash
	v4.6
		- Added Occu'thar's Searing Shadows
		- Added Al'Akir's Squall Line
		- Added Beth'tilac's Boiling Spatter
		- Added Alysrazor's Gushing Wound
		- Added Alysrazor's Molten Meteor
		- Added Alysrazor's Molten Boulder
		- Added Shannox's Arcing Slash
		- Added Shannox's Hurl Spear
		- Added Maloriak's Magma Jets
	v4.7
		- Updated Defias Watcher's Cleave
	v4.8
		- Added Akma'hat's Shockwave
		- Added Akma'hat's Fury of the Sands
		- Updated Beth'tilac's Smoldering Devastation
		- Added Ragnaros's Sulfuras Smash
		- Added Ragnaros's Meteor Impact
	v4.8.1
		- Added Shannox's Magma Rupture
		- Added Fire Turtle Hatchling's Shell Spin
		- Added Molten Lord's Lava Jet
		- Added Flamewalker Forward Guard's Shockwave
	v4.8.2
		- Added Lord Rhyolith Magma Flow
		- Added Lava Burster's Lava Shower
		- Added Nemesis's Molten Fury
	v4.8.3
		- Added Fiery Behemoth's Fiery Boulder
		- Added Molten Behemoth's Molten Stomp
		- Added Molten Behemoth's Fiery Boulder
		- Added Millagazor's Gout of Flame
		- Added Molten Splash
	v4.8.4
		- Added Firestorm's Molten Boulder
		- Added Fireball's Detonate
	v4.8.5
		- Added Flamewalker Shaman's Flamewave
		- Added Leyara's Gout of Flame
		- Added Cinderweb Queen's Cinder Web
	v4.8.6
		- Added Nethergarde Miner's Explosion
		- Added Ancient Charscale's Javelin Breach
	v4.8.7
		- Added Druid of the Flame's Reckless Leap
	v4.9
		- Moved Nethergarde Miner's Explosion
		- Added Molten Erupter's Molten Eruption
	v4.9.5
		- Added Ragnaros's Molten Seed
		- Added Murozond's Infinite Breath
		- Added Murozond's Tail Sweep
		- Added Time-Twisted Scourge Beast's Face Kick
		- Added Echo of Tyrande's Piercing Gaze of Elune
		- Added Echo of Tyrande's Moonlance
		- Added Echo of Jaina's Frost Blades
		- Added Asira Dawnslayer's Throw Knife
		- Added Archbishop Benedictus's Wave of Virtue
		- Added Archbishop Benedictus's Wave of Twilight
		- Added Archbishop Benedictus's Purifying Blast
		- Added Archbishop Benedictus's Twilight Bolt
		- Added Ceredos's Spellflame
		- Added Echo of Jaina's Flarecore Ember
		- Added Time-Twisted Drake's Flame Breath
		- Added Icebound Sentinel's Erupting Ice
	v4.10
		- Added Dreadlord Defender's Carrion Swarm
		- Added Guardian Demon's Incinerate
		- Added Peroth'arn's Easy Prey
		- Added Zon'ozz's Psychic Drain
		- Added Alysrazor's Meteoric Impact
	v4.11.1
		- Added Earthen Destroyer's Boulder Smash
		- Added Morchok's Resonating Crystal
		- Added Hagara the Stormbinder's Ice Shards
		- Added Hagara the Stormbinder's Ice Wave
		- Added Twilight Bruiser's Cleave
	v4.11.2
		- Added Twilight Assaulter's Twilight Breath
		- Added Warmaster Blackhorn's Shockwave
		- Added Warmaster Blackhorn's Degeneration
		- Added Warmaster Blackhorn's Detonate
		- Added Deathwing's Nuclear Blast
		- Added Deathwing's Crush
	v4.11.3
		- Removed Deathwing's Crush
		- Added Time-Twisted Drake's Flame Breath
		- Updated Peroth'arn's Easy Prey
	v4.11.4
		- Updated Murozond's Tail Sweep
	v4.13
		- Added Hagara the Stormbinder's Storm Pillar
		
]]--

GTFO.SpellID["80564"] = {
	--desc = "Fungal Spores (Throne of the Tides)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["91470"] = {
	--desc = "Fungal Spores (Throne of the Tides Heroic)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["76047"] = {
	--desc = "Dark Fissure (Impact, Throne of the Tides)";
	sound = 3;
};

GTFO.SpellID["76170"] = {
	--desc = "Magma Splash (Throne of the Tides)";
	tankSound = 0;
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["80643"] = {
	--desc = "Stalactite (Stonecore)";
	sound = 3;
};

GTFO.SpellID["92653"] = {
	--desc = "Stalactite (Stonecore, Heroic)";
	sound = 3;
};

GTFO.SpellID["80913"] = {
	--desc = "Crystal Shards (Stonecore)";
	sound = 3;
};

GTFO.SpellID["92122"] = {
	--desc = "Crystal Shards (Stonecore, Heroic)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["80052"] = {
	--desc = "Magma Eruption (Stonecore)";
	sound = 3;
};

GTFO.SpellID["92634"] = {
	--desc = "Magma Eruption (Stonecore, Heroic)";
	sound = 3;
};

GTFO.SpellID["80807"] = {
	--desc = "Sand Blast (Stonecore)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["92656"] = {
	--desc = "Sand Blast (Stonecore, Heroic)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["80195"] = {
	--desc = "Shockwave (Stonecore)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["92640"] = {
	--desc = "Shockwave (Stonecore, Heroic)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["78903"] = {
	--desc = "Ground Slam (Stonecore)";
	sound = 3;
};

GTFO.SpellID["92410"] = {
	--desc = "Ground Slam (Stonecore, Heroic)";
	sound = 3;
};

GTFO.SpellID["79021"] = {
	--desc = "Seismic Shard (Stonecore)";
	sound = 3;
};

GTFO.SpellID["92665"] = {
	--desc = "Seismic Shard (Stonecore, Heroic)";
	sound = 3;
};

GTFO.SpellID["75428"] = {
	--desc = "The Skullcracker (Rom'ogg Bonecrusher, Blackrock Caverns)";
	sound = 3;
};

GTFO.SpellID["93454"] = {
	--desc = "The Skullcracker (Rom'ogg Bonecrusher, Blackrock Caverns Heroic)";
	sound = 3;
};

GTFO.SpellID["76007"] = {
	--desc = "Lava Spout (Karsh Steelbender, Blackrock Caverns)";
	sound = 3;
};

GTFO.SpellID["93565"] = {
	--desc = "Lava Spout (Karsh Steelbender, Blackrock Caverns Heroic)";
	sound = 3;
};

GTFO.SpellID["88194"] = {
	--desc = "Chilling Blast (Young Storm Dragon, Vortex Pinnacle)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["92759"] = {
	--desc = "Chilling Blast (Young Storm Dragon, Vortex Pinnacle Heroic)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["87701"] = {
	--desc = "Meteor Blast (Titanic Guardian, Uldum)";
	sound = 3;
};

GTFO.SpellID["87755"] = {
	--desc = "Blazing Eruption (Titanic Guardian, Uldum)";
	sound = 3;
};

GTFO.SpellID["84864"] = {
	--desc = "Artillery Barrage (Highbank, Twilight Highlands)";
	sound = 3;
};

GTFO.SpellID["84834"] = {
	--desc = "Blade Strike (Dragonmaw Hold, Twilight Highlands)";
	sound = 3;
};

GTFO.SpellID["88208"] = {
	--desc = "Static Flux Detonation (Servias Windterror, Twilight Highlands)";
	sound = 3;
};

GTFO.SpellID["89936"] = {
	--desc = "Rupture Line (Obsidian Stoneslave, Twilight Highlands)";
	sound = 3;
};

GTFO.SpellID["88421"] = {
	--desc = "Log Smash (Bloodgorged Ettin, Twilight Highlands)";
	sound = 3;
};

GTFO.SpellID["74634"] = {
	--desc = "Ground Siege (General Umbriss, Grim Batol)";
	sound = 3;
};

GTFO.SpellID["90249"] = {
	--desc = "Ground Siege (General Umbriss, Grim Batol Heroic)";
	sound = 3;
};

GTFO.SpellID["76817"] = {
	--desc = "Twilight Breath (Twilight Drake, Grim Batol)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["90875"] = {
	--desc = "Twilight Breath (Twilight Drake, Grim Batol Heroic)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["75861"] = {
	--desc = "Binding Shadows (Erudax, Grim Batol)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["91079"] = {
	--desc = "Binding Shadows (Erudax, Grim Batol Heroic)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["77351"] = {
	--desc = "Aqua Bomb (Water Warden, Halls of Origination)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["91157"] = {
	--desc = "Aqua Bomb (Water Warden, Halls of Origination Heroic)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["77333"] = {
	--desc = "Whirling Winds (Air Warden, Halls of Origination)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["91153"] = {
	--desc = "Whirling Winds (Air Warden, Halls of Origination Heroic)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["77234"] = {
	--desc = "Rockwave (Earth Warden, Halls of Origination)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["91162"] = {
	--desc = "Rockwave (Earth Warden, Halls of Origination Heroic)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["74108"] = {
	--desc = "Solar Winds (Rajh, Halls of Origination)";
	sound = 3;
};

GTFO.SpellID["89130"] = {
	--desc = "Solar Winds (Rajh, Halls of Origination Heroic)";
	sound = 3;
};

GTFO.SpellID["83454"] = {
	--desc = "Shockwave (General Husam, Lost City)";
	sound = 3;
};

GTFO.SpellID["83454"] = {
	--desc = "Shockwave (General Husam, Lost City)";
	sound = 3;
};

GTFO.SpellID["90029"] = {
	--desc = "Shockwave (General Husam, Lost City Heroic)";
	sound = 3;
};

GTFO.SpellID["83171"] = {
	--desc = "Mystic Trap (General Husam, Lost City)";
	sound = 3;
};

GTFO.SpellID["91259"] = {
	--desc = "Mystic Trap (General Husam, Lost City Heroic)";
	sound = 3;
};

GTFO.SpellID["83051"] = {
	--desc = "Cloud Burst (Siamat, Lost City)";
	sound = 3;
};

GTFO.SpellID["90032"] = {
	--desc = "Cloud Burst (Siamat, Lost City Heroic)";
	sound = 3;
};

GTFO.SpellID["75238"] = {
	--desc = "Supernova (Invoked Flaming Spirit, Grim Batol)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["90972"] = {
	--desc = "Supernova (Invoked Flaming Spirit, Grim Batol Heroic)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["91717"] = {
	--desc = "Reaper Strike (Foe Reaper 5000, Deadmines Heroic)";
	tankSound = 0;
	sound = 3;
	vehicle = true;
};

GTFO.SpellID["91718"] = {
	--desc = "Harvest Sweep (Foe Reaper 5000, Deadmines Heroic)";
	sound = 3;
	vehicle = true;
};

GTFO.SpellID["90981"] = {
	--desc = "Cleave (Defias Watcher, Deadmines Heroic)";
	tankSound = 0;
	sound = 3;
	vehicle = true;
};

GTFO.SpellID["95496"] = {
	--desc = "Cannonball (Defias Cannon, Deadmines Heroic)";
	sound = 3;
};

GTFO.SpellID["92203"] = {
	--desc = "Ice Shards (Collapsing Icicle, Deadmines Heroic)";
	sound = 3;
};

GTFO.SpellID["88250"] = {
	--desc = "Chest Bomb (Helix Gearbreaker, Deadmines Heroic)";
	sound = 3;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["91567"] = {
	--desc = "Explode (Sticky Bomb, Deadmines Heroic)";
	sound = 3;
};

GTFO.SpellID["93063"] = {
	--desc = "Dazzling Destruction - Twilight (Theralion, BoT)";
	sound = 3;
};

GTFO.SpellID["86228"] = {
	--desc = "Twilight Flames - Twilight (Theralion, BoT 10)";
	sound = 3;
};

GTFO.SpellID["92867"] = {
	--desc = "Twilight Flames - Twilight (Theralion, BoT 25)";
	sound = 3;
};

GTFO.SpellID["84912"] = {
	--desc = "Lava Plume (Elementium Monstrosity, BoT 10)";
	sound = 3;
};

GTFO.SpellID["92491"] = {
	--desc = "Lava Plume (Elementium Monstrosity, BoT 25)";
	sound = 3;
};

GTFO.SpellID["92492"] = {
	--desc = "Lava Plume (Elementium Monstrosity, BoT 10H)";
	sound = 3;
};

GTFO.SpellID["92493"] = {
	--desc = "Lava Plume (Elementium Monstrosity, BoT 25H)";
	sound = 3;
};

GTFO.SpellID["80092"] = {
	--desc = "Poison Bomb (Toxitron, BWD 10)";
	sound = 3;
};

GTFO.SpellID["91498"] = {
	--desc = "Poison Bomb (Toxitron, BWD 25)";
	sound = 3;
};

GTFO.SpellID["91499"] = {
	--desc = "Poison Bomb (Toxitron, BWD 10H)";
	sound = 3;
};

GTFO.SpellID["91500"] = {
	--desc = "Poison Bomb (Toxitron, BWD 25H)";
	sound = 3;
};

GTFO.SpellID["78208"] = {
	--desc = "Absolute Zero (Maloriak, BWD 10)";
	sound = 3;
};

GTFO.SpellID["93041"] = {
	--desc = "Absolute Zero (Maloriak, BWD 25)";
	sound = 3;
};

GTFO.SpellID["93042"] = {
	--desc = "Absolute Zero (Maloriak, BWD 10H)";
	sound = 3;
};

GTFO.SpellID["93043"] = {
	--desc = "Absolute Zero (Maloriak, BWD 25H)";
	sound = 3;
};

GTFO.SpellID["92553"] = {
	--desc = "Sonar Bomb (Atramedes, BWD 10)";
	sound = 3;
};

GTFO.SpellID["92554"] = {
	--desc = "Sonar Bomb (Atramedes, BWD 25)";
	sound = 3;
};

GTFO.SpellID["92555"] = {
	--desc = "Sonar Bomb (Atramedes, BWD 10H)";
	sound = 3;
};

GTFO.SpellID["92556"] = {
	--desc = "Sonar Bomb (Atramedes, BWD 25H)";
	sound = 3;
};

GTFO.SpellID["85483"] = {
	--desc = "Wind Blast (Rohash, T4W 10)";
	sound = 3;
};

GTFO.SpellID["93138"] = {
	--desc = "Wind Blast (Rohash, T4W 25)";
	sound = 3;
};

GTFO.SpellID["93139"] = {
	--desc = "Wind Blast (Rohash, T4W 10H)";
	sound = 3;
};

GTFO.SpellID["93140"] = {
	--desc = "Wind Blast (Rohash, T4W 25H)";
	sound = 3;
};

GTFO.SpellID["86133"] = {
	--desc = "Tornado (Rohash, T4W 10)";
	sound = 3;
};

GTFO.SpellID["93141"] = {
	--desc = "Tornado (Rohash, T4W 25)";
	sound = 3;
};

GTFO.SpellID["93142"] = {
	--desc = "Tornado (Rohash, T4W 10H)";
	sound = 3;
};

GTFO.SpellID["93143"] = {
	--desc = "Tornado (Rohash, T4W 25H)";
	sound = 3;
};

GTFO.SpellID["87856"] = {
	--desc = "Squall Line (Al'Akir, T4W 10)";
	soundFunction = function() 
		-- Only alert on the first squall hit, ignore until thrown
		GTFO_AddEvent("AlAkirSquall", 5.5);
		return 3;
	end;
	ignoreEvent = "AlAkirSquall";
};

GTFO.SpellID["93283"] = {
	--desc = "Squall Line (Al'Akir, T4W 25)";
	soundFunction = GTFO.SpellID["87856"].soundFunction;
	ignoreEvent = "AlAkirSquall";
};

GTFO.SpellID["93284"] = {
	--desc = "Squall Line (Al'Akir, T4W 10H)";
	soundFunction = GTFO.SpellID["87856"].soundFunction;
	ignoreEvent = "AlAkirSquall";
};

GTFO.SpellID["93285"] = {
	--desc = "Squall Line (Al'Akir, T4W 25H)";
	soundFunction = GTFO.SpellID["87856"].soundFunction;
	ignoreEvent = "AlAkirSquall";
};

GTFO.SpellID["91564"] = {
	--desc = "Living Bomb Explosion (Sorcerous Skeleton, Shadowfang Keep Heroic)";
	sound = 3;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["87991"] = {
	--desc = "Shadow Storm (Obsidian Colossus, Uldum)";
	sound = 3;
};

GTFO.SpellID["88102"] = {
	--desc = "Sweeping Attack (Obsidian Colossus, Uldum)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["80195"] = {
	--desc = "Shockwave (Executor of the Caliph, Vortex Pinnacle)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["92782"] = {
	--desc = "Shockwave (Executor of the Caliph, Vortex Pinnacle Heroic)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["75700"] = {
	--desc = "Geyser (Lady Naz'jar, TToT)";
	sound = 3;
};

GTFO.SpellID["91469"] = {
	--desc = "Geyser (Lady Naz'jar, TToT Heroic)";
	sound = 3;
};

GTFO.SpellID["91469"] = {
	--desc = "Arc Slash (Naz'jar Honor Guard, TToT)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["91469"] = {
	--desc = "Overhead Smash (Hurp'Derp, Twilight Highlands)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["88524"] = {
	--desc = "Liquid Flame (Torg Drakeflayer, Twilight Highlands)";
	sound = 3;
};

GTFO.SpellID["88524"] = {
	--desc = "Liquid Flame (Torg Drakeflayer, Twilight Highlands)";
	sound = 3;
};

GTFO.SpellID["88609"] = {
	--desc = "Belch (Cadaver Collage, Twilight Highlands)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["90335"] = {
	--desc = "Magmatic Fault (Emberscar the Devourer, Twilight Highlands)";
	sound = 3;
};

GTFO.SpellID["88314"] = {
	--desc = "Twisting Winds (Altairus, Vortex Pinnacle Heroic)";
	sound = 3;
	alwaysAlert = true;
};

GTFO.SpellID["75922"] = {
	--desc = "Searing Stone (Falling Boulder, Hyjal)";
	sound = 3;
	vehicle = true;
};

GTFO.SpellID["89882"] = {
	--desc = "Earth Spike (Earthrager Ptah, Halls of Origination Heroic)";
	sound = 3;
};

GTFO.SpellID["75369"] = {
	--desc = "Consume (Earthrager Ptah, Halls of Origination Heroic)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["74137"] = {
	--desc = "Supernova (Isiset, Halls of Origination)";
	sound = 3;
};

GTFO.SpellID["76430"] = {
	--desc = "Flame Tsunami (Ragnaros, Hyjal)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["76134"] = {
	--desc = "Lava Strike (Ragnaros, Hyjal)";
	sound = 3;
};

GTFO.SpellID["92662"] = {
	--desc = "Shatter (Ozruk, Stonecore Heroic)";
	sound = 3;
};

GTFO.SpellID["92381"] = {
	--desc = "Rupture (Ozruk, Stonecore Heroic)";
	sound = 3;
};

GTFO.SpellID["90479"] = {
	--desc = "Waterspout (Lady Naz'jar, Throne of the Tides Heroic)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["81008"] = {
	--desc = "Quake (Crystalspawn Giant, Stonecore)";
	sound = 3;
};

GTFO.SpellID["92631"] = {
	--desc = "Quake (Crystalspawn Giant, Stonecore Heroic)";
	sound = 3;
};

GTFO.SpellID["83981"] = {
	--desc = "Shadow Blast (Unyielding Behemoth, Throne of the Tides)";
	sound = 3;
};

GTFO.SpellID["91510"] = {
	--desc = "Shadow Blast (Unyielding Behemoth, Throne of the Tides Heroic)";
	sound = 3;
};

GTFO.SpellID["81828"] = {
	--desc = "Thrashing Charge (Corborus, Stonecore)";
	sound = 3;
};

GTFO.SpellID["92651"] = {
	--desc = "Thrashing Charge (Corborus, Stonecore Heroic)";
	sound = 3;
};

GTFO.SpellID["78937"] = {
	--desc = "Infectious Vomit (Magmaw, BWD 10)";
	sound = 3;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["91915"] = {
	--desc = "Infectious Vomit (Magmaw, BWD 25)";
	sound = 3;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["91923"] = {
	--desc = "Infectious Vomit (Magmaw, BWD 10H)";
	sound = 3;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["91924"] = {
	--desc = "Infectious Vomit (Magmaw, BWD 25H)";
	sound = 3;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["77971"] = {
	--desc = "Pillar of Flame (Magmaw, BWD 10)";
	sound = 3;
};

GTFO.SpellID["91918"] = {
	--desc = "Pillar of Flame (Magmaw, BWD 25)";
	sound = 3;
};

GTFO.SpellID["91929"] = {
	--desc = "Pillar of Flame (Magmaw, BWD 10H)";
	sound = 3;
};

GTFO.SpellID["91930"] = {
	--desc = "Pillar of Flame (Magmaw, BWD 25H)";
	sound = 3;
};

GTFO.SpellID["77827"] = {
	--desc = "Tail Lash (Onyxia and Nefarian, BWD 10)";
	sound = 3;
};

GTFO.SpellID["94128"] = {
	--desc = "Tail Lash (Onyxia and Nefarian, BWD 25)";
	sound = 3;
};

GTFO.SpellID["94129"] = {
	--desc = "Tail Lash (Onyxia and Nefarian, BWD 10H)";
	sound = 3;
};

GTFO.SpellID["94130"] = {
	--desc = "Tail Lash (Onyxia and Nefarian, BWD 25H)";
	sound = 3;
};

GTFO.SpellID["87618"] = {
	--desc = "Static Cling (Asaad, Vortex Pinnacle Heroic)";
	sound = 3;
};

GTFO.SpellID["86292"] = {
	--desc = "Cyclone Shield (Grand Vizier Ertan, Vortex Pinnacle)";
	sound = 3;
};

GTFO.SpellID["88287"] = {
	--desc = "Massive Crash (Magmaw, BWD 10)";
	sound = 3;
};

GTFO.SpellID["91914"] = {
	--desc = "Massive Crash (Magmaw, BWD 25)";
	sound = 3;
};

GTFO.SpellID["91921"] = {
	--desc = "Massive Crash (Magmaw, BWD 10H)";
	sound = 3;
};

GTFO.SpellID["91922"] = {
	--desc = "Massive Crash (Magmaw, BWD 25H)";
	sound = 3;
};

GTFO.SpellID["91906"] = {
	--desc = "Overhead Smash (Drakonid Chainwielder, BWD)";
	sound = 3;
};

GTFO.SpellID["79580"] = {
	--desc = "Overhead Smash (Drakonid Chainwielder, BWD Heroic)";
	sound = 3;
};

GTFO.SpellID["83734"] = {
	--desc = "Fireball Barrage (Halfus Wyrmbreaker, BoT 10)";
	sound = 3;
};

GTFO.SpellID["86154"] = {
	--desc = "Fireball Barrage (Halfus Wyrmbreaker, BoT 25)";
	sound = 3;
};

GTFO.SpellID["86152"] = {
	--desc = "Fireball Barrage (Halfus Wyrmbreaker, BoT 10H)";
	sound = 3;
};

GTFO.SpellID["86153"] = {
	--desc = "Fireball Barrage (Halfus Wyrmbreaker, BoT 25H)";
	sound = 3;
};

GTFO.SpellID["87629"] = {
	--desc = "Gripping Shadows (Shadow Lord, BoT)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["87638"] = {
	--desc = "Concussive Blast (Fire Elemental, BoT)";
	sound = 3;
};

GTFO.SpellID["74670"] = {
	--desc = "Blitz (General Umbriss, Grim Batol)";
	sound = 3;
};

GTFO.SpellID["90250"] = {
	--desc = "Blitz (General Umbriss, Grim Batol Heroic)";
	sound = 3;
};

GTFO.SpellID["80130"] = {
	--desc = "Tail Lash (Maimgor, BWD 10)";
	sound = 3;
};

GTFO.SpellID["91901"] = {
	--desc = "Tail Lash (Maimgor, BWD 25)";
	sound = 3;
};

GTFO.SpellID["80392"] = {
	--desc = "Cleave (Drakonid Slayer, BWD)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["93386"] = {
	--desc = "Shockwave (Bound Rumbler, BoT)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["93391"] = {
	--desc = "Twilight Rupture (Evolved Drakonaar, BoT)";
	sound = 3;
};

GTFO.SpellID["83692"] = {
	--desc = "Eruption (Terrastra, BoT 10)";
	sound = 3;
};

GTFO.SpellID["92534"] = {
	--desc = "Eruption (Terrastra, BoT 25)";
	sound = 3;
};

GTFO.SpellID["92535"] = {
	--desc = "Eruption (Terrastra, BoT 10H)";
	sound = 3;
};

GTFO.SpellID["92536"] = {
	--desc = "Eruption (Terrastra, BoT 25H)";
	sound = 3;
};

GTFO.SpellID["88534"] = {
	--desc = "Stormhammer (Jora Wildwing, Twilight Highlands)";
	sound = 3;
};

GTFO.SpellID["78941"] = {
	--desc = "Parasitic Infection (Lava Parasite, BWD 10)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["91913"] = {
	--desc = "Parasitic Infection (Lava Parasite, BWD 25)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["94678"] = {
	--desc = "Parasitic Infection (Lava Parasite, BWD 10H)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["94679"] = {
	--desc = "Parasitic Infection (Lava Parasite, BWD 25H)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["81689"] = {
	--desc = "Corrupting Crash (Cho'gall, BoT 10)";
	sound = 3;
};

GTFO.SpellID["93186"] = {
	--desc = "Corrupting Crash (Cho'gall, BoT 25)";
	sound = 3;
};

GTFO.SpellID["93184"] = {
	--desc = "Corrupting Crash (Cho'gall, BoT 10H)";
	sound = 3;
};

GTFO.SpellID["93185"] = {
	--desc = "Corrupting Crash (Cho'gall, BoT 25H)";
	sound = 3;
};

GTFO.SpellID["78684"] = {
	--desc = "Hail of Bones (Nefarian, BWD 10)";
	sound = 3;
};

GTFO.SpellID["94104"] = {
	--desc = "Hail of Bones (Nefarian, BWD 25)";
	sound = 3;
};

GTFO.SpellID["94105"] = {
	--desc = "Hail of Bones (Nefarian, BWD 10H)";
	sound = 3;
};

GTFO.SpellID["94106"] = {
	--desc = "Hail of Bones (Nefarian, BWD 25H)";
	sound = 3;
};

GTFO.SpellID["78162"] = {
	--desc = "Twilight Fissure (Sethria, Hyjal)";
	sound = 3;
};

GTFO.SpellID["96836"] = {
	--desc = "Exploding Boulder (ZG)";
	sound = 3;
};

GTFO.SpellID["96834"] = {
	--desc = "Boulder Smash (ZG)";
	sound = 3;
};

GTFO.SpellID["96743"] = {
	--desc = "Devastating Slam (Bloodlord Mandokir, ZG)";
	sound = 3;
};

GTFO.SpellID["96460"] = {
	--desc = "Wave of Agony (High Priestess Kilnara, ZG)";
	sound = 3;
};

GTFO.SpellID["97351"] = {
	--desc = "Gout of Flame (Gurubashi Cauldron-Mixer, ZG)";
	sound = 3;
};

GTFO.SpellID["97161"] = {
	--desc = "Shadow Spike (Jin'do the Godbreaker, ZG)";
	sound = 3;
};

GTFO.SpellID["43273"] = {
	--desc = "Cleave (Amani'shi Warbringer, ZA)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["42630"] = {
	--desc = "Fire Bomb (Jin'alai, ZA)";
	sound = 3;
};

GTFO.SpellID["87945"] = {
	--desc = "Twilight Extinction (Sinestra, BoT 10H)";
	sound = 3;
	negatingBuffSpellID = 87231 -- Fiery Barrier
};

GTFO.SpellID["86226"] = {
	--desc = "Twilight Extinction (Sinestra, BoT 25H)";
	sound = 3;
	negatingBuffSpellID = 87231 -- Fiery Barrier
};

GTFO.SpellID["90083"] = {
	--desc = "Twilight Breath (Sinestra, BoT 10H)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["92942"] = {
	--desc = "Twilight Breath (Sinestra, BoT 25H)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["92191"] = {
	--desc = "Blazing Inferno (Magmaw, BWD 10H)";
	sound = 3;
};

GTFO.SpellID["92192"] = {
	--desc = "Blazing Inferno (Magmaw, BWD 25H)";
	sound = 3;
};

GTFO.SpellID["91879"] = {
	--desc = "Arcane Blowback (Arcanotron, BWD 10H)";
	sound = 3;
};

GTFO.SpellID["91880"] = {
	--desc = "Arcane Blowback (Arcanotron, BWD 25H)";
	sound = 3;
};

GTFO.SpellID["43464"] = {
	--desc = "Fire Nova Totem (Hex Lord Malacrass, ZA)";
	sound = 3;
};

GTFO.SpellID["96699"] = {
	--desc = "Lightning Rod (Wushoolay, ZG)";
	sound = 3;
};

GTFO.SpellID["81060"] = {
	--desc = "Flash Bomb (Golem Sentry, BWD 10)";
	sound = 3;
};

GTFO.SpellID["91885"] = {
	--desc = "Flash Bomb (Golem Sentry, BWD 25)";
	sound = 3;
};

GTFO.SpellID["96635"] = {
	--desc = "Rupture Line (Gri'lek, ZG)";
	sound = 3;
};

GTFO.SpellID["99076"] = {
	--desc = "Meteor Burn (Beth'tilac, FL)";
	sound = 3;
	alwaysAlert = true;
};

GTFO.SpellID["99052"] = {
	--desc = "Smoldering Devastation (Beth'tilac, FL)";
	sound = 3;
};

-- Not sure how to track Volatile Burst's fixated target vs. non-fixated
-- Is possible to avoid if fixated?
GTFO.SpellID["99990"] = {
	--desc = "Volatile Burst (Beth'tilac, FL 10H)";
	sound = 3;
	test = true;
};

GTFO.SpellID["100838"] = {
	--desc = "Volatile Burst (Beth'tilac, FL 25H)";
	sound = 3;
	test = true;
};

GTFO.SpellID["99838"] = {
	--desc = "Immolation Trap (Shannox, FL 10)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["101208"] = {
	--desc = "Immolation Trap (Shannox, FL 25)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["101209"] = {
	--desc = "Immolation Trap (Shannox, FL 10H)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["101210"] = {
	--desc = "Immolation Trap (Shannox, FL 25H)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["99837"] = {
	--desc = "Crystal Prison Trap (Shannox, FL)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["98928"] = {
	--desc = "Lava Wave (Ragnaros, FL 10)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["100292"] = {
	--desc = "Lava Wave (Ragnaros, FL 25)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["100293"] = {
	--desc = "Lava Wave (Ragnaros, FL 10H)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["100294"] = {
	--desc = "Lava Wave (Ragnaros, FL 25H)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["89348"] = {
	--desc = "Demon Repellent Ray (Demon Containment Unit, BH 10)";
	sound = 3;
	affirmingDebuffSpellID = 89354; -- Arcane Amplifier	
};

GTFO.SpellID["95178"] = {
	--desc = "Demon Repellent Ray (Demon Containment Unit, BH 25)";
	sound = 3;
	affirmingDebuffSpellID = 95179; -- Arcane Amplifier	
};

GTFO.SpellID["88942"] = {
	--desc = "Meteor Slash (Argaloth, BH 10)";
	sound = 3;
	minimumStacks = 1;
	applicationOnly = true;
	affirmingDebuffSpellID = 88942; -- Meteor Slash
};

GTFO.SpellID["95172"] = {
	--desc = "Meteor Slash (Argaloth, BH 25)";
	sound = 3;
	minimumStacks = 1;
	applicationOnly = true;
	affirmingDebuffSpellID = 95172; -- Meteor Slash
};

GTFO.SpellID["96913"] = {
	--desc = "Searing Shadows (Occu'thar, BH)";
	applicationOnly = true;
	soundFunction = function() -- Fail for non-tanks, fail for tanks after more than 1 stack
		if (GTFO.TankMode) then
			local stacks = GTFO_DebuffStackCount("player", 96913); 
			if (stacks > 1) then
				return 3;
			end
			return 0;
		else
			return 3;
		end
	end
};

GTFO.SpellID["99463"] = {
	--desc = "Boiling Spatter (Beth'tilac, FL 10)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["100121"] = {
	--desc = "Boiling Spatter (Beth'tilac, FL 25)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["100832"] = {
	--desc = "Boiling Spatter (Beth'tilac, FL 10H)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["100833"] = {
	--desc = "Boiling Spatter (Beth'tilac, FL 25H)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["100024"] = {
	--desc = "Gushing Wound - 6 yards (Alysrazor, FL 10)";
	tankSound = 0;
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["100721"] = {
	--desc = "Gushing Wound - 6 yards (Alysrazor, FL 25)";
	tankSound = 0;
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["100722"] = {
	--desc = "Gushing Wound - 6 yards (Alysrazor, FL 10H)";
	tankSound = 0;
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["100723"] = {
	--desc = "Gushing Wound - 6 yards (Alysrazor, FL 25H)";
	tankSound = 0;
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["99308"] = {
	--desc = "Gushing Wound - 10 yards (Alysrazor, FL 10)";
	tankSound = 0;
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["100718"] = {
	--desc = "Gushing Wound - 10 yards (Alysrazor, FL 25)";
	tankSound = 0;
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["100719"] = {
	--desc = "Gushing Wound - 10 yards (Alysrazor, FL 10H)";
	tankSound = 0;
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["100720"] = {
	--desc = "Gushing Wound - 10 yards (Alysrazor, FL 25H)";
	tankSound = 0;
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["99274"] = {
	--desc = "Molten Meteor (Alysrazor, FL H)";
	sound = 3;
};

GTFO.SpellID["99275"] = {
	--desc = "Molten Boulder (Alysrazor, FL H)";
	sound = 3;
};

GTFO.SpellID["99931"] = {
	--desc = "Arcing Slash (Shannox, FL 10)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["101201"] = {
	--desc = "Arcing Slash (Shannox, FL 25)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["101202"] = {
	--desc = "Arcing Slash (Shannox, FL 10H)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["101203"] = {
	--desc = "Arcing Slash (Shannox, FL 25H)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["100002"] = {
	--desc = "Hurl Spear (Shannox, FL)";
	sound = 3;
};

GTFO.SpellID["78095"] = {
	--desc = "Magma Jets (Maloriak, BWD 10)";
	sound = 3;
};

GTFO.SpellID["93014"] = {
	--desc = "Magma Jets (Maloriak, BWD 25)";
	sound = 3;
};

GTFO.SpellID["93015"] = {
	--desc = "Magma Jets (Maloriak, BWD 10H)";
	sound = 3;
};

GTFO.SpellID["93016"] = {
	--desc = "Magma Jets (Maloriak, BWD 25H)";
	sound = 3;
};

GTFO.SpellID["93575"] = {
	--desc = "Fury of the Sands (Akma'hat, Uldum)";
	sound = 3;
};

GTFO.SpellID["94968"] = {
	--desc = "Shockwave (Akma'hat, Uldum)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["98708"] = {
	--desc = "Sulfuras Smash (Ragnaros, FL 10)";
	sound = 3;
};

GTFO.SpellID["100256"] = {
	--desc = "Sulfuras Smash (Ragnaros, FL 25)";
	sound = 3;
};

GTFO.SpellID["100257"] = {
	--desc = "Sulfuras Smash (Ragnaros, FL 10H)";
	sound = 3;
};

GTFO.SpellID["100258"] = {
	--desc = "Sulfuras Smash (Ragnaros, FL 25H)";
	sound = 3;
};

GTFO.SpellID["99287"] = {
	--desc = "Meteor Impact (Ragnaros, FL 10)";
	sound = 3;
};

GTFO.SpellID["100299"] = {
	--desc = "Meteor Impact (Ragnaros, FL 25)";
	sound = 3;
};

GTFO.SpellID["100300"] = {
	--desc = "Meteor Impact (Ragnaros, FL 10H)";
	sound = 3;
};

GTFO.SpellID["100301"] = {
	--desc = "Meteor Impact (Ragnaros, FL 25H)";
	sound = 3;
};

GTFO.SpellID["99842"] = {
	--desc = "Magma Rupture (Shannox, FL 10)";
	sound = 3;
};

GTFO.SpellID["101205"] = {
	--desc = "Magma Rupture (Shannox, FL 25)";
	sound = 3;
};

GTFO.SpellID["101206"] = {
	--desc = "Magma Rupture (Shannox, FL 10H)";
	sound = 3;
};

GTFO.SpellID["101207"] = {
	--desc = "Magma Rupture (Shannox, FL 25H)";
	sound = 3;
};

GTFO.SpellID["100273"] = {
	--desc = "Shell Spin (Fire Turtle Hatchling, FL)";
	sound = 3;
};

GTFO.SpellID["99552"] = {
	--desc = "Lava Jet (Molten Lord, FL)";
	sound = 3;
};

GTFO.SpellID["99610"] = {
	--desc = "Shockwave (Flamewalker Forward Guard, FL)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["97234"] = {
	--desc = "Magma Flow (Lord Rhyolith, FL 10)";
	sound = 3;
};

GTFO.SpellID["99631"] = {
	--desc = "Magma Flow (Lord Rhyolith, FL 25)";
	sound = 3;
};

GTFO.SpellID["101017"] = {
	--desc = "Magma Flow (Lord Rhyolith, FL 10H)";
	sound = 3;
};

GTFO.SpellID["101018"] = {
	--desc = "Magma Flow (Lord Rhyolith, FL 25H)";
	sound = 3;
};

GTFO.SpellID["97552"] = {
	--desc = "Lava Shower (Lava Burster, MF)";
	sound = 3;
};

GTFO.SpellID["96917"] = {
	--desc = "Molten Fury (Nemesis, Hyjal)";
	sound = 3;
};

GTFO.SpellID["96688"] = {
	--desc = "Fiery Boulder (Fiery Behemoth, Hyjal)";
	sound = 3;
};

GTFO.SpellID["97246"] = {
	--desc = "Fiery Boulder (Molten Behemoth, MF)";
	sound = 3;
};

GTFO.SpellID["97243"] = {
	--desc = "Molten Stomp (Molten Behemoth, MF)";
	sound = 3;
};

GTFO.SpellID["100975"] = {
	--desc = "Gout of Flame (Millagazor, Hyjal)";
	sound = 3;
};

GTFO.SpellID["97774"] = {
	--desc = "Molten Splash (MF)";
	sound = 3;
};

GTFO.SpellID["99603"] = {
	--desc = "Molten Boulder (Firestorm, FL)";
	sound = 3;
};

GTFO.SpellID["101073"] = {
	--desc = "Detonate (Fireball, Hyjal)";
	sound = 3;
};

GTFO.SpellID["98031"] = {
	--desc = "Flame Spout (Pyrelord, MF)";
	sound = 3;
};

GTFO.SpellID["98185"] = {
	--desc = "Flamewave (Flamewalker Shaman, MF)";
	sound = 3;
};

GTFO.SpellID["80550"] = {
	--desc = "Gout of Flame (Leyara, MF)";
	sound = 3;
};

GTFO.SpellID["99994"] = {
	--desc = "Cinder Web (Cinderweb Queen, MF)";
	sound = 3;
};

GTFO.SpellID["98137"] = {
	--desc = "Javelin Breach (Ancient Charscale, MF)";
	sound = 3;
};

GTFO.SpellID["99078"] = {
	--desc = "Javelin Breach (Ancient Charscale, MF)";
	sound = 3;
};

GTFO.SpellID["99646"] = {
	--desc = "Reckless Leap (Druid of the Flame, FL 10)";
	sound = 3;
};

GTFO.SpellID["100104"] = {
	--desc = "Reckless Leap (Druid of the Flame, FL 25)";
	sound = 3;
};

GTFO.SpellID["99580"] = {
	--desc = "Molten Eruption (Molten Erupter, FL)";
	sound = 3;
};

GTFO.SpellID["100455"] = {
	--desc = "Sulfuras (Ragnaros, FL 10)";
	sound = 3;
};

GTFO.SpellID["101229"] = {
	--desc = "Sulfuras (Ragnaros, FL 25)";
	sound = 3;
};

GTFO.SpellID["101230"] = {
	--desc = "Sulfuras (Ragnaros, FL 10H)";
	sound = 3;
};

GTFO.SpellID["101231"] = {
	--desc = "Sulfuras (Ragnaros, FL 25H)";
	sound = 3;
};

GTFO.SpellID["98498"] = {
	--desc = "Molten Seed (Ragnaros, FL 10)";
	soundFunction = function() -- Warn only if you get hit more than once within 5 seconds
		if (GTFO_FindEvent("RagnarosMoltenSeed")) then
			return 3;
		end
		GTFO_AddEvent("RagnarosMoltenSeed", 5);
		return 0;
	end
};

GTFO.SpellID["100579"] = {
	--desc = "Molten Seed (Ragnaros, FL 25)";
	soundFunction = GTFO.SpellID["98498"].soundFunction;
};

GTFO.SpellID["100580"] = {
	--desc = "Molten Seed (Ragnaros, FL 10H)";
	soundFunction = GTFO.SpellID["98498"].soundFunction;
};

GTFO.SpellID["100581"] = {
	--desc = "Molten Seed (Ragnaros, FL 25H)";
	soundFunction = GTFO.SpellID["98498"].soundFunction;
};

GTFO.SpellID["89104"] = {
	--desc = "Relentless Storm (Al'akir, To4W)";
	sound = 3;
};

GTFO.SpellID["102569"] = {
	--desc = "Infinite Breath (Murozond, ET)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["108589"] = {
	--desc = "Tail Sweep (Murozond, ET)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["101888"] = {
	--desc = "Face Kick (Time-Twisted Scourge Beast, ET)";
	tankSound = 0;
	sound = 3;
};

GTFO.SpellID["102183"] = {
	--desc = "Piercing Gaze of Elune (Echo of Tyrande, ET)";
	sound = 3;
};

GTFO.SpellID["102149"] = {
	--desc = "Moonlance (Echo of Tyrande, ET)";
	sound = 3;
};

GTFO.SpellID["101337"] = {
	--desc = "Frost Blade (Echo of Jaina, ET)";
	sound = 3;
};

GTFO.SpellID["103684"] = {
	--desc = "Wave of Virtue (Archbishop Benedictus, HoT)";
	sound = 3;
};

GTFO.SpellID["103781"] = {
	--desc = "Wave of Twilight (Archbishop Benedictus, HoT)";
	sound = 3;
};

GTFO.SpellID["103651"] = {
	--desc = "Purifying Blast (Archbishop Benedictus, HoT)";
	soundFunction = function() -- Warn only if you get hit more than once within 5 seconds
		if (GTFO_FindEvent("BenedictusBall")) then
			return 3;
		end
		GTFO_AddEvent("BenedictusBall", 3);
		return 0;
	end
};

GTFO.SpellID["103777"] = {
	--desc = "Twilight Bolt (Archbishop Benedictus, HoT)";
	soundFunction = function() -- Warn only if you get hit more than once within 5 seconds
		if (GTFO_FindEvent("BenedictusBall")) then
			return 3;
		end
		GTFO_AddEvent("BenedictusBall", 3);
		return 0;
	end
};

GTFO.SpellID["103597"] = {
	--desc = "Throw Knife (Asira Dawnslayer, HoT)";
	sound = 3;
	tankSound = 0;
	affirmingDebuffSpellID = 102726;
};

GTFO.SpellID["99807"] = {
	--desc = "Spellflame (Ceredos, Nexus)";
	sound = 3;
	applicationOnly = true;
};

GTFO.SpellID["101587"] = {
	--desc = "Flarecore Ember (Echo of Jaina, ET)";
	sound = 3;
};

GTFO.SpellID["102135"] = {
	--desc = "Flame Breath (Time-Twisted Drake, ET)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["99408"] = {
	--desc = "Erupting Ice (Icebound Sentinel, Nexus)";
	sound = 3;
};

GTFO.SpellID["90255"] = {
	--desc = "Fire Nova (Twilight Invader, Nexus)";
	sound = 1;
	specificMobs = { 
		54463, -- Twilight Invader, Nexus
		53486, -- Twilight Invader, Nexus
	}
};

GTFO.SpellID["107840"] = {
	--desc = "Carrion Swarm (Dreadlord Defender, WoE)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["107840"] = {
	--desc = "Incinerate (Guardian Demon, WoE)";
	sound = 3;
	tankSound = 0;
	test = true;
};

GTFO.SpellID["105493"] = {
	--desc = "Easy Prey (Peroth'arn, WoE)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["104322"] = {
	--desc = "Psychic Drain (Zon'ozz, DS 10)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["104606"] = {
	--desc = "Psychic Drain (Zon'ozz, DS 25)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["104607"] = {
	--desc = "Psychic Drain (Zon'ozz, DS 10H)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["104608"] = {
	--desc = "Psychic Drain (Zon'ozz, DS 25H)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["99558"] = {
	--desc = "Meteoric Impact (Alysrazor, FL H)";
	sound = 3;
};

GTFO.SpellID["107629"] = {
	--desc = "Boulder Smash (Earthen Destroyer, DS)";
	sound = 3;
};

GTFO.SpellID["103545"] = {
	--desc = "Resonating Crystal (Morchok, DS 10)";
	sound = 3;
	negatingDebuffSpellID = 103541; -- Safe
};

GTFO.SpellID["108572"] = {
	--desc = "Resonating Crystal (Morchok, DS 25)";
	sound = 3;
	negatingDebuffSpellID = 103541; -- Safe
};

GTFO.SpellID["69425"] = {
	--desc = "Ice Shards (Hagara the Stormbinder, DS 10)";
	sound = 3;
};

GTFO.SpellID["105314"] = {
	--desc = "Ice Wave (Hagara the Stormbinder, DS)";
	sound = 3;
};

GTFO.SpellID["103001"] = {
	--desc = "Cleave (Twilight Bruiser, HoT)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["105858"] = {
	--desc = "Twilight Breath (Twilight Assaulter, DS)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["103327"] = {
	--desc = "Hour of Twilight (Ultraxion, DS 10)";
	sound = 3;
	damageMinimum = 200000;
};

GTFO.SpellID["105858"] = {
	--desc = "Hour of Twilight (Ultraxion, DS 25)";
	sound = 3;
	damageMinimum = 200000;
};

GTFO.SpellID["108046"] = {
	--desc = "Shockwave (Warmaster Blackhorn, DS 10)";
	sound = 3;
};

GTFO.SpellID["107558"] = {
	--desc = "Degeneration (Warmaster Blackhorn, DS 10)";
	sound = 3;
	tankSound = 0;
	applicationOnly = true;
};

GTFO.SpellID["108861"] = {
	--desc = "Degeneration (Warmaster Blackhorn, DS 25)";
	sound = 3;
	tankSound = 0;
	applicationOnly = true;
};

GTFO.SpellID["109207"] = {
	--desc = "Degeneration (Warmaster Blackhorn, DS 10H)";
	sound = 3;
	tankSound = 0;
	applicationOnly = true;
};

GTFO.SpellID["109208"] = {
	--desc = "Degeneration (Warmaster Blackhorn, DS 25H)";
	sound = 3;
	tankSound = 0;
	applicationOnly = true;
};

GTFO.SpellID["107518"] = {
	--desc = "Detonate (Warmaster Blackhorn, DS)";
	sound = 3;
};

GTFO.SpellID["105845"] = {
	--desc = "Nuclear Blast (Deathwing, DS)";
	sound = 3;
};

GTFO.SpellID["102135"] = {
	--desc = "Flame Breath (Time-Twisted Drake, HoT)";
	sound = 3;
	tankSound = 0;
};

GTFO.SpellID["107595"] = {
	--desc = "Blade Rush (Warmaster Blackhorn, DS 10)";
	sound = 3;
};

GTFO.SpellID["109013"] = {
	--desc = "Blade Rush (Warmaster Blackhorn, DS 25)";
	sound = 3;
};

GTFO.SpellID["109014"] = {
	--desc = "Blade Rush (Warmaster Blackhorn, DS 10H)";
	sound = 3;
};

GTFO.SpellID["109015"] = {
	--desc = "Blade Rush (Warmaster Blackhorn, DS 25H)";
	sound = 3;
};

GTFO.SpellID["109563"] = {
	--desc = "Storm Pillar (Hagara the Stormbinder, DS H)";
	sound = 3;
};
