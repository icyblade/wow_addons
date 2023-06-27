local random = random;
local floor = floor;
local twipe = table.wipe;


local VUHDO_CLASS_ID_POWER_TYPES = {
	[VUHDO_ID_WARRIORS] = VUHDO_UNIT_POWER_RAGE,
	[VUHDO_ID_ROGUES] = VUHDO_UNIT_POWER_ENERGY,
	[VUHDO_ID_HUNTERS] = VUHDO_UNIT_POWER_MANA,
	[VUHDO_ID_PALADINS] = VUHDO_UNIT_POWER_MANA,
	[VUHDO_ID_MAGES] = VUHDO_UNIT_POWER_MANA,
	[VUHDO_ID_WARLOCKS] = VUHDO_UNIT_POWER_MANA,
	[VUHDO_ID_SHAMANS] = VUHDO_UNIT_POWER_MANA,
	[VUHDO_ID_DRUIDS] = VUHDO_UNIT_POWER_MANA,
	[VUHDO_ID_PRIESTS] = VUHDO_UNIT_POWER_MANA,
	[VUHDO_ID_DEATH_KNIGHT] = VUHDO_UNIT_POWER_RUNES,
}



local sClassNamesForId = {
	[VUHDO_ID_WARRIORS] = "Warrior",
	[VUHDO_ID_ROGUES] = "Rogue",
	[VUHDO_ID_HUNTERS] = "Hunter",
	[VUHDO_ID_PALADINS] = "Paladin",
	[VUHDO_ID_MAGES] = "Mage",
	[VUHDO_ID_WARLOCKS] = "Warlock",
	[VUHDO_ID_SHAMANS] = "Shaman",
	[VUHDO_ID_DRUIDS] = "Druid",
	[VUHDO_ID_PRIESTS] = "Priest",
	[VUHDO_ID_DEATH_KNIGHT] = "Death Knight",
}

--
local VUHDO_DEMO_SETUP = {
	[5] = {
		[VUHDO_ID_GROUP_1] = 5,
		[VUHDO_ID_GROUP_2] = 0,
		[VUHDO_ID_GROUP_3] = 0,
		[VUHDO_ID_GROUP_4] = 0,
		[VUHDO_ID_GROUP_5] = 0,
		[VUHDO_ID_GROUP_6] = 0,
		[VUHDO_ID_GROUP_7] = 0,
		[VUHDO_ID_GROUP_8] = 0,
		[VUHDO_ID_GROUP_OWN] = 5,

		[VUHDO_ID_WARRIORS] = 1,
		[VUHDO_ID_ROGUES] = 1,
		[VUHDO_ID_HUNTERS] = 0,
		[VUHDO_ID_PALADINS] = 1,
		[VUHDO_ID_MAGES] = 1,
		[VUHDO_ID_WARLOCKS] = 0,
		[VUHDO_ID_SHAMANS] = 0,
		[VUHDO_ID_DRUIDS] = 0,
		[VUHDO_ID_PRIESTS] = 1,
		[VUHDO_ID_DEATH_KNIGHT] = 0,

		[VUHDO_ID_PETS] = 2,
		[VUHDO_ID_MAINTANKS] = 1,
		[VUHDO_ID_PRIVATE_TANKS] = 1,

		[VUHDO_ID_MAIN_ASSISTS] = 1,
		[VUHDO_ID_MELEE] = 2,
		[VUHDO_ID_RANGED] = 3,
		[VUHDO_ID_MELEE_TANK] = 1,
		[VUHDO_ID_MELEE_DAMAGE] = 1,
		[VUHDO_ID_RANGED_DAMAGE] = 2,
		[VUHDO_ID_RANGED_HEAL] = 1,
		[VUHDO_ID_VEHICLES] = 5,
	},

	[10] = {
		[VUHDO_ID_GROUP_1] = 5,
		[VUHDO_ID_GROUP_2] = 5,
		[VUHDO_ID_GROUP_3] = 0,
		[VUHDO_ID_GROUP_4] = 0,
		[VUHDO_ID_GROUP_5] = 0,
		[VUHDO_ID_GROUP_6] = 0,
		[VUHDO_ID_GROUP_7] = 0,
		[VUHDO_ID_GROUP_8] = 0,
		[VUHDO_ID_GROUP_OWN] = 5,

		[VUHDO_ID_WARRIORS] = 2,
		[VUHDO_ID_ROGUES] = 1,
		[VUHDO_ID_HUNTERS] = 0,
		[VUHDO_ID_PALADINS] = 1,
		[VUHDO_ID_MAGES] = 1,
		[VUHDO_ID_WARLOCKS] = 1,
		[VUHDO_ID_SHAMANS] = 1,
		[VUHDO_ID_DRUIDS] = 1,
		[VUHDO_ID_PRIESTS] = 1,
		[VUHDO_ID_DEATH_KNIGHT] = 1,

		[VUHDO_ID_PETS] = 4,
		[VUHDO_ID_MAINTANKS] = 2,
		[VUHDO_ID_PRIVATE_TANKS] = 2,
		[VUHDO_ID_MAIN_ASSISTS] = 2,
		[VUHDO_ID_MELEE] = 5,
		[VUHDO_ID_RANGED] = 5,
		[VUHDO_ID_MELEE_TANK] = 2,
		[VUHDO_ID_MELEE_DAMAGE] = 2,
		[VUHDO_ID_RANGED_DAMAGE] = 3,
		[VUHDO_ID_RANGED_HEAL] = 3,
		[VUHDO_ID_VEHICLES] = 10,
	},

	[25] = {
		[VUHDO_ID_GROUP_1] = 5,
		[VUHDO_ID_GROUP_2] = 5,
		[VUHDO_ID_GROUP_3] = 5,
		[VUHDO_ID_GROUP_4] = 5,
		[VUHDO_ID_GROUP_5] = 5,
		[VUHDO_ID_GROUP_6] = 0,
		[VUHDO_ID_GROUP_7] = 0,
		[VUHDO_ID_GROUP_8] = 0,
		[VUHDO_ID_GROUP_OWN] = 5,

		[VUHDO_ID_WARRIORS] = 3,
		[VUHDO_ID_ROGUES] = 2,
		[VUHDO_ID_HUNTERS] = 2,
		[VUHDO_ID_PALADINS] = 3,
		[VUHDO_ID_MAGES] = 3,
		[VUHDO_ID_WARLOCKS] = 2,
		[VUHDO_ID_SHAMANS] = 3,
		[VUHDO_ID_DRUIDS] = 2,
		[VUHDO_ID_PRIESTS] = 3,
		[VUHDO_ID_DEATH_KNIGHT] = 2,

		[VUHDO_ID_PETS] = 7,
		[VUHDO_ID_MAINTANKS] = 3,
		[VUHDO_ID_PRIVATE_TANKS] = 2,
		[VUHDO_ID_MAIN_ASSISTS] = 2,
		[VUHDO_ID_MELEE] = 5,
		[VUHDO_ID_RANGED] = 5,
		[VUHDO_ID_MELEE_TANK] = 2,
		[VUHDO_ID_MELEE_DAMAGE] = 6,
		[VUHDO_ID_RANGED_DAMAGE] = 9,
		[VUHDO_ID_RANGED_HEAL] = 7,
		[VUHDO_ID_VEHICLES] = 25,
	},

	[40] = {
		[VUHDO_ID_GROUP_1] = 5,
		[VUHDO_ID_GROUP_2] = 5,
		[VUHDO_ID_GROUP_3] = 5,
		[VUHDO_ID_GROUP_4] = 5,
		[VUHDO_ID_GROUP_5] = 5,
		[VUHDO_ID_GROUP_6] = 5,
		[VUHDO_ID_GROUP_7] = 5,
		[VUHDO_ID_GROUP_8] = 5,
		[VUHDO_ID_GROUP_OWN] = 5,

		[VUHDO_ID_WARRIORS] = 4,
		[VUHDO_ID_ROGUES] = 4,
		[VUHDO_ID_HUNTERS] = 4,
		[VUHDO_ID_PALADINS] = 4,
		[VUHDO_ID_MAGES] = 4,
		[VUHDO_ID_WARLOCKS] = 4,
		[VUHDO_ID_SHAMANS] = 4,
		[VUHDO_ID_DRUIDS] = 4,
		[VUHDO_ID_PRIESTS] = 4,
		[VUHDO_ID_DEATH_KNIGHT] = 4,

		[VUHDO_ID_PETS] = 6,
		[VUHDO_ID_MAINTANKS] = 5,
		[VUHDO_ID_PRIVATE_TANKS] = 3,
		[VUHDO_ID_MAIN_ASSISTS] = 5,
		[VUHDO_ID_MELEE] = 20,
		[VUHDO_ID_RANGED] = 20,
		[VUHDO_ID_MELEE_TANK] = 4,
		[VUHDO_ID_MELEE_DAMAGE] = 12,
		[VUHDO_ID_RANGED_DAMAGE] = 12,
		[VUHDO_ID_RANGED_HEAL] = 12,
		[VUHDO_ID_VEHICLES] = 40,
	},
};


local VUHDO_LEET_NAME_PREFIXES = {
 "Head", "Face", "Fire", "Ice", "Black", "Storm", "Magic", "Mystic",
 "Night", "Mad", "Crazy", "Elite", "Star", "Chicken", "Twilight",
 "Flesh", "Beef", "Bone", "Brain", "Shadow", "Evil", "Hell", "Thunder",
 "Imba", "Ghost", "Poison", "Plague", "Schnitzel", "Wurst", "Kraut",
 "Fat", "Lonely", "Uber", "Iron", "Steel", "Power", "Soul",
 "Kungfu", "Karate", "Secret", "Hidden", "Light", "Darkness", "Doom",
 "Stealth", "Skin", "Krass", "Law", "Justice", "Revenge",
 "Retri", "Vengeance", "War", "Battle", "Gore", "Splatter", "Dust",
 "Heat", "Mind", "Plastic", "Thought", "Desert", "Fancy", "Beer", "Dark",
 "Wonder", "Wish", "Insane", "Blood", "Necro", "Death", "Grave", "Wind",
 "Freedom", "Tomb", "Dungeon", "Cave", "Worm", "Nerveous", "Cool", "Sad",
 "Happy", "Strange", "Odd", "Blue", "Eternal", "Pain", "Torture", "Nature",
 "Flash", "Leet", "Holy", "Style", "Flower", "Forest", "Pest", "Holo",
 "Dimension", "Rage", "Fury", "Blind", "Lego", "Lost", "White", "Mortal",
 "Savage", "Voodoo", "Cult",
};


local VUHDO_LEET_NAME_SUFFIXES = {
 "melter", "breaker", "crusher", "cracker", "burner", "ruler", "checker",
 "killer", "hunter", "owner", "runner", "warrior", "walker", "soldier",
 "devil", "bringer", "claw", "hero", "sissy", "fighter", "walker", "eater",
 "man", "girl", "boi", "maiden", "gangsta", "star", "banger", "pimp", "poser",
 "cat", "wall", "dog", "prophet", "pally", "fly", "master", "r0xx0r", "sniper",
 "crawler", "butcher", "king", "queen", "finger", "sword", "axe", "demon",
 "dragon", "finder", "lover", "keeper", "creature", "burger", "ball", "creep",
 "bender", "shredder", "arrow", "shield", "blade", "minion", "pet", "animal",
 "digger", "coil", "addict", "stranger", "cutter", "builder", "chopper", "caller",
 "emperor", "baron", "lord", "priest", "pope", "worker", "summoner", "smell",
 "taste", "flame", "god", "freak", "nerd", "pro", "cake", "winner", "angel",
 "cookie", "deo", "controller", "saver", "watcher", "waker", "buster", "cop",
 "mask", "servant", "nuker", "shooter", "ripper", "monster", "messiah", "frodo",
 "cowboy", "ranger", "leecher", "dwarf", "guru", "corpse", "panda", "knife",
 "dagger", "muck", "saw",
};



--
local function VUHDO_generateLeetName()
	return VUHDO_LEET_NAME_PREFIXES[random(1, #VUHDO_LEET_NAME_PREFIXES)]
		.. VUHDO_LEET_NAME_SUFFIXES[random(1, #VUHDO_LEET_NAME_SUFFIXES)];
end



local VUHDO_TEST_USERS_LEFT = { };



--
local function VUHDO_getNextFreeModelInRange(aFirstModel, aLastModel)
	local tCnt;

	for tCnt = aFirstModel, aLastModel do
		if (VUHDO_TEST_USERS_LEFT[tCnt] > 0) then
			VUHDO_TEST_USERS_LEFT[tCnt] = VUHDO_TEST_USERS_LEFT[tCnt] - 1;
			return tCnt;
		end
	end

	return nil;
end



--
local function VUHDO_getRandomDebuff()
	local tRandom = random(1, 30 + VUHDO_DEBUFF_TYPE_CUSTOM - 1);
	if (tRandom <= 30) then
		return VUHDO_DEBUFF_TYPE_NONE;
	else
		if (tRandom == 35) then
			tRandom = 36;
		end
		return tRandom - 30;
	end
end



--
local function VUHDO_getRandomThreatSituation()
	local tRandom = random(1, 13);
	if (tRandom <= 10) then
		return 0;
	else
		return tRandom - 10;
	end
end



--
local function VUHDO_getRandomHealth(aMax)
	local tRandom = random(1, 3);
	if (tRandom == 1) then
		return aMax;
	elseif (tRandom == 2) then
		return floor(random(0, aMax) * 0.5 + aMax * 0.5);
	else
		return random(0, aMax);
	end
end


local tPetDemoIdx, tRaidDemoIdx;



--
local function VUHDO_createTestUser()
	local tIsCreatePet, tUnit;
	local tNumber;
	local tClassId;
	local tGroup;
	local tInfo;
	local tRole;
	local tHealthMax;

	tIsCreatePet = false;
	tHealthMax = random(10000, 20000);

	if (VUHDO_TEST_USERS_LEFT[VUHDO_ID_PETS] > 0) then
		tIsCreatePet = true;
		VUHDO_TEST_USERS_LEFT[VUHDO_ID_PETS] = VUHDO_TEST_USERS_LEFT[VUHDO_ID_PETS] - 1;
		tUnit = "raidpet" .. tPetDemoIdx;
		tClassId = VUHDO_ID_WARRIORS;
		tGroup = 0;
		tNumber = tPetDemoIdx;
		tRole = nil;
		tPetDemoIdx = tPetDemoIdx + 1;
	else
		tUnit = "raid" .. tRaidDemoIdx;
		tClassId = VUHDO_getNextFreeModelInRange(VUHDO_ID_WARRIORS, VUHDO_ID_DEATH_KNIGHT);
		tGroup = VUHDO_getNextFreeModelInRange(VUHDO_ID_GROUP_1, VUHDO_ID_GROUP_8);
		tNumber = tRaidDemoIdx;
		tRaidDemoIdx = tRaidDemoIdx + 1;
		VUHDO_getNextFreeModelInRange(VUHDO_ID_MELEE, VUHDO_ID_RANGED);
		tRole = VUHDO_getNextFreeModelInRange(VUHDO_ID_MELEE_TANK, VUHDO_ID_RANGED_HEAL);

		if (tClassId == nil or tGroup == nil) then
			return false;
		end
	end

	if (VUHDO_RAID[tUnit] == nil) then
		VUHDO_RAID[tUnit] = { };
	end
	tInfo = VUHDO_RAID[tUnit];
	tInfo["healthmax"] = tHealthMax;
	tInfo["health"] = VUHDO_getRandomHealth(tHealthMax);
	tInfo["name"] = VUHDO_generateLeetName();
	tInfo["number"] = tNumber;
	tInfo["unit"] = tUnit;
	tInfo["class"] = VUHDO_ID_CLASSES[tClassId];
	tInfo["range"] = random(1, 5) < 5;
	tInfo["debuff"] = VUHDO_getRandomDebuff();
	tInfo["isPet"] = tIsCreatePet;
	tInfo["powertype"] = VUHDO_CLASS_ID_POWER_TYPES[tClassId];
	tInfo["power"] = random(0, 100);
	tInfo["powermax"] = 100;
	tInfo["charmed"] = false;
	tInfo["dead"] = random(1, 10) > 9;
	tInfo["connected"] = random(1,15) <= 14;
	tInfo["aggro"] = random(1, 10) > 8 and not tInfo["dead"] and tInfo["connected"];
	tInfo["group"] = tGroup;
	tInfo["afk"] = random(1, 10) > 8;
	tInfo["threat"] = VUHDO_getRandomThreatSituation();
	tInfo["threatPerc"] = random(0, 100);
	tInfo["isVehicle"] = false;
	tInfo["ownerUnit"] = VUHDO_PET_2_OWNER[tUnit];
	tInfo["className"] = sClassNamesForId[tClassId] or "";
	tInfo["petUnit"] = VUHDO_OWNER_2_PET[tUnit];
	tInfo["targetUnit"] = VUHDO_getTargetUnit(tUnit);
	tInfo["classId"] = tClassId;
	tInfo["sortMaxHp"] = tHealthMax;
	tInfo["role"] = tRole;
	tInfo["fullName"] = tInfo["name"];
	tInfo["raidIcon"] = nil;
	tInfo["visible"] = tInfo["range"];
	tInfo["zone"], tInfo["map"] = VUHDO_getUnitZoneName("player");
	tInfo["baseRange"] = tInfo["range"];

	return true;
end



--
local tHasLoaded = false;



function VUHDO_demoSetupResetUsers()
	tHasLoaded = false;
end



--
local tCnt;
function VUHDO_reloadRaidDemoUsers()
	if (tHasLoaded) then
		return;
	end
	tHasLoaded = true;
	twipe(VUHDO_RAID);
	VUHDO_TEST_USERS_LEFT = VUHDO_deepCopyTable(VUHDO_DEMO_SETUP[VUHDO_CONFIG_TEST_USERS]);
	tPetDemoIdx = 1;
	tRaidDemoIdx = 1;
	while (VUHDO_createTestUser()) do
	end

	twipe(VUHDO_MAINTANK_NAMES);
	for tCnt = 1, VUHDO_TEST_USERS_LEFT[VUHDO_ID_MAINTANKS] do
		VUHDO_MAINTANK_NAMES[tCnt] = VUHDO_RAID["raid" .. tCnt]["name"];
	end

	twipe(VUHDO_PLAYER_TARGETS);
	for tCnt = 1, VUHDO_TEST_USERS_LEFT[VUHDO_ID_PRIVATE_TANKS] do
		VUHDO_PLAYER_TARGETS[VUHDO_RAID["raid" .. (VUHDO_CONFIG_TEST_USERS - tCnt)]["name"]] = true;
	end
end

