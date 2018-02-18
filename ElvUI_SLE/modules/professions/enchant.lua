local SLE, T, E, L, V, P, G = unpack(select(2, ...))
local Pr = SLE:GetModule("Professions")
local S = E:GetModule("Skins")
-- GLOBALS: CreateFrame, hooksecurefunc
local _G = _G
local UseItemByName = UseItemByName
local C_TradeSkillUI = C_TradeSkillUI
Pr.DErank = 0

Pr.mapSpellToItem = {
	[7745] = 38772, -- Enchant 2H Weapon - Minor Impact
	[7786] = 38779, -- Enchant Weapon - Minor Beastslayer
	[7788] = 38780, -- Enchant Weapon - Minor Striking
	[7793] = 38781, -- Enchant 2H Weapon - Lesser Intellect
	[13380] = 38788, -- Enchant 2H Weapon - Lesser Versatility
	[13503] = 38794, -- Enchant Weapon - Lesser Striking
	[13529] = 38796, -- Enchant 2H Weapon - Lesser Impact
	[13653] = 38813, -- Enchant Weapon - Lesser Beastslayer
	[13655] = 38814, -- Enchant Weapon - Lesser Elemental Slayer
	[13693] = 38821, -- Enchant Weapon - Striking
	[13695] = 38822, -- Enchant 2H Weapon - Impact
	[13898] = 38838, -- Enchant Weapon - Fiery Weapon
	[13915] = 38840, -- Enchant Weapon - Demonslaying
	[13937] = 38845, -- Enchant 2H Weapon - Greater Impact
	[13943] = 38848, -- Enchant Weapon - Greater Striking
	[20029] = 38868, -- Enchant Weapon - Icy Chill
	[20030] = 38869, -- Enchant 2H Weapon - Superior Impact
	[20031] = 38870, -- Enchant Weapon - Superior Striking
	[20032] = 38871, -- Enchant Weapon - Lifestealing
	[20033] = 38872, -- Enchant Weapon - Unholy Weapon
	[20034] = 38873, -- Enchant Weapon - Crusader
	[20035] = 38874, -- Enchant 2H Weapon - Major Versatility
	[20036] = 38875, -- Enchant 2H Weapon - Major Intellect
	[21931] = 38876, -- Enchant Weapon - Winter's Might
	[22749] = 38877, -- Enchant Weapon - Spellpower
	[22750] = 38878, -- Enchant Weapon - Healing Power
	[23799] = 38879, -- Enchant Weapon - Strength
	[23800] = 38880, -- Enchant Weapon - Agility
	[23803] = 38883, -- Enchant Weapon - Mighty Versatility
	[23804] = 38884, -- Enchant Weapon - Mighty Intellect
	[27837] = 38896, -- Enchant 2H Weapon - Agility
	[64441] = 46026, -- Enchant Weapon - Blade Ward
	[64579] = 46098, -- Enchant Weapon - Blood Draining
	[7418] = 38679, -- Enchant Bracer - Minor Health
	[7420] = 38766, -- Enchant Chest - Minor Health
	[7426] = 38767, -- Enchant Chest - Minor Absorption
	[7428] = 38768, -- Enchant Bracer - Minor Dodge
	[7443] = 38769, -- Enchant Chest - Minor Mana
	[7457] = 38771, -- Enchant Bracer - Minor Stamina
	[7748] = 38773, -- Enchant Chest - Lesser Health
	[7766] = 38774, -- Enchant Bracer - Minor Versatility
	[7771] = 38775, -- Enchant Cloak - Minor Protection
	[7776] = 38776, -- Enchant Chest - Lesser Mana
	[7779] = 38777, -- Enchant Bracer - Minor Agility
	[7782] = 38778, -- Enchant Bracer - Minor Strength
	[7857] = 38782, -- Enchant Chest - Health
	[7859] = 38783, -- Enchant Bracer - Lesser Versatility
	[7863] = 38785, -- Enchant Boots - Minor Stamina
	[7867] = 38786, -- Enchant Boots - Minor Agility
	[13378] = 38787, -- Enchant Shield - Minor Stamina
	[13419] = 38789, -- Enchant Cloak - Minor Agility
	[13421] = 38790, -- Enchant Cloak - Lesser Protection
	[13464] = 38791, -- Enchant Shield - Lesser Protection
	[13485] = 38792, -- Enchant Shield - Lesser Versatility
	[13501] = 38793, -- Enchant Bracer - Lesser Stamina
	[13536] = 38797, -- Enchant Bracer - Lesser Strength
	[13538] = 38798, -- Enchant Chest - Lesser Absorption
	[13607] = 38799, -- Enchant Chest - Mana
	[13612] = 38800, -- Enchant Gloves - Mining
	[13617] = 38801, -- Enchant Gloves - Herbalism
	[13620] = 38802, -- Enchant Gloves - Fishing
	[13622] = 38803, -- Enchant Bracer - Lesser Intellect
	[13626] = 38804, -- Enchant Chest - Minor Stats
	[13631] = 38805, -- Enchant Shield - Lesser Stamina
	[13635] = 38806, -- Enchant Cloak - Defense
	[13637] = 38807, -- Enchant Boots - Lesser Agility
	[13640] = 38808, -- Enchant Chest - Greater Health
	[13642] = 38809, -- Enchant Bracer - Versatility
	[13644] = 38810, -- Enchant Boots - Lesser Stamina
	[13646] = 38811, -- Enchant Bracer - Lesser Dodge
	[13648] = 38812, -- Enchant Bracer - Stamina
	[13659] = 38816, -- Enchant Shield - Versatility
	[13661] = 38817, -- Enchant Bracer - Strength
	[13663] = 38818, -- Enchant Chest - Greater Mana
	[13687] = 38819, -- Enchant Boots - Lesser Versatility
	[13689] = 38820, -- Enchant Shield - Lesser Parry
	[13698] = 38823, -- Enchant Gloves - Skinning
	[13700] = 38824, -- Enchant Chest - Lesser Stats
	[13746] = 38825, -- Enchant Cloak - Greater Defense
	[13815] = 38827, -- Enchant Gloves - Agility
	[13817] = 38828, -- Enchant Shield - Stamina
	[13822] = 38829, -- Enchant Bracer - Intellect
	[13836] = 38830, -- Enchant Boots - Stamina
	[13841] = 38831, -- Enchant Gloves - Advanced Mining
	[13846] = 38832, -- Enchant Bracer - Greater Versatility
	[13858] = 38833, -- Enchant Chest - Superior Health
	[13868] = 38834, -- Enchant Gloves - Advanced Herbalism
	[13882] = 38835, -- Enchant Cloak - Lesser Agility
	[13887] = 38836, -- Enchant Gloves - Strength
	[13890] = 38837, -- Enchant Boots - Minor Speed
	[13905] = 38839, -- Enchant Shield - Greater Versatility
	[13917] = 38841, -- Enchant Chest - Superior Mana
	[13931] = 38842, -- Enchant Bracer - Dodge
	[13935] = 38844, -- Enchant Boots - Agility
	[13939] = 38846, -- Enchant Bracer - Greater Strength
	[13941] = 38847, -- Enchant Chest - Stats
	[13945] = 38849, -- Enchant Bracer - Greater Stamina
	[13947] = 38850, -- Enchant Gloves - Riding Skill
	[13948] = 38851, -- Enchant Gloves - Minor Haste
	[20008] = 38852, -- Enchant Bracer - Greater Intellect
	[20009] = 38853, -- Enchant Bracer - Superior Versatility
	[20010] = 38854, -- Enchant Bracer - Superior Strength
	[20011] = 38855, -- Enchant Bracer - Superior Stamina
	[20012] = 38856, -- Enchant Gloves - Greater Agility
	[20013] = 38857, -- Enchant Gloves - Greater Strength
	[20015] = 38859, -- Enchant Cloak - Superior Defense
	[20016] = 38860, -- Enchant Shield - Vitality
	[20017] = 38861, -- Enchant Shield - Greater Stamina
	[20020] = 38862, -- Enchant Boots - Greater Stamina
	[20023] = 38863, -- Enchant Boots - Greater Agility
	[20024] = 38864, -- Enchant Boots - Versatility
	[20025] = 38865, -- Enchant Chest - Greater Stats
	[20026] = 38866, -- Enchant Chest - Major Health
	[20028] = 38867, -- Enchant Chest - Major Mana
	[23801] = 38881, -- Enchant Bracer - Argent Versatility
	[23802] = 38882, -- Enchant Bracer - Healing Power
	[25072] = 38885, -- Enchant Gloves - Threat
	[25073] = 38886, -- Enchant Gloves - Shadow Power
	[25074] = 38887, -- Enchant Gloves - Frost Power
	[25078] = 38888, -- Enchant Gloves - Fire Power
	[25079] = 38889, -- Enchant Gloves - Healing Power
	[25080] = 38890, -- Enchant Gloves - Superior Agility
	[25083] = 38893, -- Enchant Cloak - Stealth
	[25084] = 38894, -- Enchant Cloak - Subtlety
	[44506] = 38960, -- Enchant Gloves - Gatherer
	[63746] = 45628, -- Enchant Boots - Lesser Accuracy
	[71692] = 50816, -- Enchant Gloves - Angler
	[27967] = 38917, -- Enchant Weapon - Major Striking
	[27968] = 38918, -- Enchant Weapon - Major Intellect
	[27971] = 38919, -- Enchant 2H Weapon - Savagery
	[27972] = 38920, -- Enchant Weapon - Potency
	[27975] = 38921, -- Enchant Weapon - Major Spellpower
	[27977] = 38922, -- Enchant 2H Weapon - Major Agility
	[27981] = 38923, -- Enchant Weapon - Sunfire
	[27982] = 38924, -- Enchant Weapon - Soulfrost
	[27984] = 38925, -- Enchant Weapon - Mongoose
	[28003] = 38926, -- Enchant Weapon - Spellsurge
	[28004] = 38927, -- Enchant Weapon - Battlemaster
	[34010] = 38946, -- Enchant Weapon - Major Healing
	[42620] = 38947, -- Enchant Weapon - Greater Agility
	[27951] = 37603, -- Enchant Boots - Dexterity
	[25086] = 38895, -- Enchant Cloak - Dodge
	[27899] = 38897, -- Enchant Bracer - Brawn
	[27905] = 38898, -- Enchant Bracer - Stats
	[27906] = 38899, -- Enchant Bracer - Greater Dodge
	[27911] = 38900, -- Enchant Bracer - Superior Healing
	[27913] = 38901, -- Enchant Bracer - Versatility Prime
	[27914] = 38902, -- Enchant Bracer - Fortitude
	[27917] = 38903, -- Enchant Bracer - Spellpower
	[27944] = 38904, -- Enchant Shield - Lesser Dodge
	[27945] = 38905, -- Enchant Shield - Intellect
	[27946] = 38906, -- Enchant Shield - Parry
	[27948] = 38908, -- Enchant Boots - Vitality
	[27950] = 38909, -- Enchant Boots - Fortitude
	[27954] = 38910, -- Enchant Boots - Surefooted
	[27957] = 38911, -- Enchant Chest - Exceptional Health
	[27960] = 38913, -- Enchant Chest - Exceptional Stats
	[27961] = 38914, -- Enchant Cloak - Major Armor
	[33990] = 38928, -- Enchant Chest - Major Versatility
	[33991] = 38929, -- Enchant Chest - Versatility Prime
	[33992] = 38930, -- Enchant Chest - Major Resilience
	[33993] = 38931, -- Enchant Gloves - Blasting
	[33994] = 38932, -- Enchant Gloves - Precise Strikes
	[33995] = 38933, -- Enchant Gloves - Major Strength
	[33996] = 38934, -- Enchant Gloves - Assault
	[33997] = 38935, -- Enchant Gloves - Major Spellpower
	[33999] = 38936, -- Enchant Gloves - Major Healing
	[34001] = 38937, -- Enchant Bracer - Major Intellect
	[34002] = 38938, -- Enchant Bracer - Lesser Assault
	[34003] = 38939, -- Enchant Cloak - PvP Power
	[34004] = 38940, -- Enchant Cloak - Greater Agility
	[34007] = 38943, -- Enchant Boots - Cat's Swiftness
	[34008] = 38944, -- Enchant Boots - Boar's Speed
	[34009] = 38945, -- Enchant Shield - Major Stamina
	[44383] = 38949, -- Enchant Shield - Resilience
	[46594] = 38999, -- Enchant Chest - Dodge
	[47051] = 39000, -- Enchant Cloak - Greater Dodge
	[42974] = 38948, -- Enchant Weapon - Executioner
	[44510] = 38963, -- Enchant Weapon - Exceptional Versatility
	[44524] = 38965, -- Enchant Weapon - Icebreaker
	[44576] = 38972, -- Enchant Weapon - Lifeward
	[44595] = 38981, -- Enchant 2H Weapon - Scourgebane
	[44621] = 38988, -- Enchant Weapon - Giant Slayer
	[44629] = 38991, -- Enchant Weapon - Exceptional Spellpower
	[44630] = 38992, -- Enchant 2H Weapon - Greater Savagery
	[44633] = 38995, -- Enchant Weapon - Exceptional Agility
	[46578] = 38998, -- Enchant Weapon - Deathfrost
	[59625] = 43987, -- Enchant Weapon - Black Magic
	[60621] = 44453, -- Enchant Weapon - Greater Potency
	[60691] = 44463, -- Enchant 2H Weapon - Massacre
	[60707] = 44466, -- Enchant Weapon - Superior Potency
	[60714] = 44467, -- Enchant Weapon - Mighty Spellpower
	[59621] = 44493, -- Enchant Weapon - Berserking
	[59619] = 44497, -- Enchant Weapon - Accuracy
	[62948] = 45056, -- Enchant Staff - Greater Spellpower
	[62959] = 45060, -- Enchant Staff - Spellpower
	[27958] = 38912, -- Enchant Chest - Exceptional Mana
	[44484] = 38951, -- Enchant Gloves - Haste
	[44488] = 38953, -- Enchant Gloves - Precision
	[44489] = 38954, -- Enchant Shield - Dodge
	[44492] = 38955, -- Enchant Chest - Mighty Health
	[44500] = 38959, -- Enchant Cloak - Superior Agility
	[44508] = 38961, -- Enchant Boots - Greater Versatility
	[44509] = 38962, -- Enchant Chest - Greater Versatility
	[44513] = 38964, -- Enchant Gloves - Greater Assault
	[44528] = 38966, -- Enchant Boots - Greater Fortitude
	[44529] = 38967, -- Enchant Gloves - Major Agility
	[44555] = 38968, -- Enchant Bracer - Exceptional Intellect
	[60616] = 38971, -- Enchant Bracer - Assault
	[44582] = 38973, -- Enchant Cloak - Minor Power
	[44584] = 38974, -- Enchant Boots - Greater Vitality
	[44588] = 38975, -- Enchant Chest - Exceptional Resilience
	[44589] = 38976, -- Enchant Boots - Superior Agility
	[44591] = 38978, -- Enchant Cloak - Superior Dodge
	[44592] = 38979, -- Enchant Gloves - Exceptional Spellpower
	[44593] = 38980, -- Enchant Bracer - Major Versatility
	[44598] = 38984, -- Enchant Bracer - Haste
	[60623] = 38986, -- Enchant Boots - Icewalker
	[44616] = 38987, -- Enchant Bracer - Greater Stats
	[44623] = 38989, -- Enchant Chest - Super Stats
	[44625] = 38990, -- Enchant Gloves - Armsman
	[44631] = 38993, -- Enchant Cloak - Shadow Armor
	[44635] = 38997, -- Enchant Bracer - Greater Spellpower
	[47672] = 39001, -- Enchant Cloak - Mighty Stamina
	[47766] = 39002, -- Enchant Chest - Greater Dodge
	[47898] = 39003, -- Enchant Cloak - Greater Speed
	[47899] = 39004, -- Enchant Cloak - Wisdom
	[47900] = 39005, -- Enchant Chest - Super Health
	[47901] = 39006, -- Enchant Boots - Tuskarr's Vitality
	[60606] = 44449, -- Enchant Boots - Assault
	[60653] = 44455, -- Shield Enchant - Greater Intellect
	[60609] = 44456, -- Enchant Cloak - Speed
	[60663] = 44457, -- Enchant Cloak - Major Agility
	[60668] = 44458, -- Enchant Gloves - Crusher
	[60692] = 44465, -- Enchant Chest - Powerful Stats
	[60763] = 44469, -- Enchant Boots - Greater Assault
	[60767] = 44470, -- Enchant Bracer - Superior Spellpower
	[44575] = 44815, -- Enchant Bracer - Greater Assault
	[62256] = 44947, -- Enchant Bracer - Major Stamina
	[74195] = 52747, -- Enchant Weapon - Mending
	[96264] = 68784, -- Enchant Bracer - Agility
	[96261] = 68785, -- Enchant Bracer - Major Strength
	[96262] = 68786, -- Enchant Bracer - Mighty Intellect
	[74132] = 52687, -- Enchant Gloves - Mastery
	[74189] = 52743, -- Enchant Boots - Earthen Vitality
	[74191] = 52744, -- Enchant Chest - Mighty Stats
	[74192] = 52745, -- Enchant Cloak - Lesser Power
	[74193] = 52746, -- Enchant Bracer - Speed
	[74197] = 52748, -- Enchant Weapon - Avalanche
	[74198] = 52749, -- Enchant Gloves - Haste
	[74199] = 52750, -- Enchant Boots - Haste
	[74200] = 52751, -- Enchant Chest - Stamina
	[74201] = 52752, -- Enchant Bracer - Critical Strike
	[74202] = 52753, -- Enchant Cloak - Intellect
	[74207] = 52754, -- Enchant Shield - Protection
	[74211] = 52755, -- Enchant Weapon - Elemental Slayer
	[74212] = 52756, -- Enchant Gloves - Exceptional Strength
	[74213] = 52757, -- Enchant Boots - Major Agility
	[74214] = 52758, -- Enchant Chest - Mighty Resilience
	[74220] = 52759, -- Enchant Gloves - Greater Haste
	[74223] = 52760, -- Enchant Weapon - Hurricane
	[74225] = 52761, -- Enchant Weapon - Heartsong
	[74226] = 52762, -- Enchant Shield - Mastery
	[74229] = 52763, -- Enchant Bracer - Superior Dodge
	[74230] = 52764, -- Enchant Cloak - Critical Strike
	[74231] = 52765, -- Enchant Chest - Exceptional Versatility
	[74232] = 52766, -- Enchant Bracer - Precision
	[74234] = 52767, -- Enchant Cloak - Protection
	[74235] = 52768, -- Enchant Off-Hand - Superior Intellect
	[74236] = 52769, -- Enchant Boots - Precision
	[74237] = 52770, -- Enchant Bracer - Exceptional Versatility
	[74238] = 52771, -- Enchant Boots - Mastery
	[74239] = 52772, -- Enchant Bracer - Greater Haste
	[74240] = 52773, -- Enchant Cloak - Greater Intellect
	[74242] = 52774, -- Enchant Weapon - Power Torrent
	[74244] = 52775, -- Enchant Weapon - Windwalk
	[74246] = 52776, -- Enchant Weapon - Landslide
	[74247] = 52777, -- Enchant Cloak - Greater Critical Strike
	[74248] = 52778, -- Enchant Bracer - Greater Critical Strike
	[74250] = 52779, -- Enchant Chest - Peerless Stats
	[74251] = 52780, -- Enchant Chest - Greater Stamina
	[74252] = 52781, -- Enchant Boots - Assassin's Step
	[74253] = 52782, -- Enchant Boots - Lavawalker
	[74254] = 52783, -- Enchant Gloves - Mighty Strength
	[74255] = 52784, -- Enchant Gloves - Greater Mastery
	[74256] = 52785, -- Enchant Bracer - Greater Speed
	[95471] = 68134, -- Enchant 2H Weapon - Mighty Agility
	[104425] = 74723, -- Enchant Weapon - Windsong
	[104427] = 74724, -- Enchant Weapon - Jade Spirit
	[104430] = 74725, -- Enchant Weapon - Elemental Force
	[104434] = 74726, -- Enchant Weapon - Dancing Steel
	[104440] = 74727, -- Enchant Weapon - Colossus
	[104442] = 74728, -- Enchant Weapon - River's Song
	[104338] = 74700, -- Enchant Bracer - Mastery
	[104385] = 74701, -- Enchant Bracer - Major Dodge
	[104389] = 74703, -- Enchant Bracer - Super Intellect
	[104390] = 74704, -- Enchant Bracer - Exceptional Strength
	[104391] = 74705, -- Enchant Bracer - Greater Agility
	[104392] = 74706, -- Enchant Chest - Super Resilience
	[104393] = 74707, -- Enchant Chest - Mighty Versatility
	[104395] = 74708, -- Enchant Chest - Glorious Stats
	[104397] = 74709, -- Enchant Chest - Superior Stamina
	[104398] = 74710, -- Enchant Cloak - Accuracy
	[104401] = 74711, -- Enchant Cloak - Greater Protection
	[104403] = 74712, -- Enchant Cloak - Superior Intellect
	[104404] = 74713, -- Enchant Cloak - Superior Critical Strike
	[104407] = 74715, -- Enchant Boots - Greater Haste
	[104408] = 74716, -- Enchant Boots - Greater Precision
	[104409] = 74717, -- Enchant Boots - Blurred Speed
	[104414] = 74718, -- Enchant Boots - Pandaren's Step
	[104416] = 74719, -- Enchant Gloves - Greater Haste
	[104417] = 74720, -- Enchant Gloves - Superior Haste
	[104419] = 74721, -- Enchant Gloves - Super Strength
	[104420] = 74722, -- Enchant Gloves - Superior Mastery
	[104445] = 74729, -- Enchant Off-Hand - Major Intellect
	[130758] = 89737, -- Enchant Shield - Greater Parry
	[158914] = 110638, -- Enchant Ring - Gift of Critical Strike
	[158915] = 110639, -- Enchant Ring - Gift of Haste
	[158916] = 110640, -- Enchant Ring - Gift of Mastery
	[158918] = 110642, -- Enchant Ring - Gift of Versatility
	[158899] = 110645, -- Enchant Neck - Gift of Critical Strike
	[158900] = 110646, -- Enchant Neck - Gift of Haste
	[158901] = 110647, -- Enchant Neck - Gift of Mastery
	[158903] = 110649, -- Enchant Neck - Gift of Versatility
	[158884] = 110652, -- Enchant Cloak - Gift of Critical Strike
	[158885] = 110653, -- Enchant Cloak - Gift of Haste
	[158886] = 110654, -- Enchant Cloak - Gift of Mastery
	[158889] = 110656, -- Enchant Cloak - Gift of Versatility
	[159235] = 110682, -- Enchant Weapon - Mark of the Thunderlord
	[159236] = 112093, -- Enchant Weapon - Mark of the Shattered Hand
	[159673] = 112115, -- Enchant Weapon - Mark of Shadowmoon
	[159674] = 112160, -- Enchant Weapon - Mark of Blackrock
	[159671] = 112164, -- Enchant Weapon - Mark of Warsong
	[159672] = 112165, -- Enchant Weapon - Mark of the Frostwolf
	[173323] = 118015, -- Enchant Weapon - Mark of Bleeding Hollow
	[158907] = 110617, -- Enchant Ring - Breath of Critical Strike
	[158908] = 110618, -- Enchant Ring - Breath of Haste
	[158909] = 110619, -- Enchant Ring - Breath of Mastery
	[158911] = 110621, -- Enchant Ring - Breath of Versatility
	[158892] = 110624, -- Enchant Neck - Breath of Critical Strike
	[158893] = 110625, -- Enchant Neck - Breath of Haste
	[158894] = 110626, -- Enchant Neck - Breath of Mastery
	[158896] = 110628, -- Enchant Neck - Breath of Versatility
	[158877] = 110631, -- Enchant Cloak - Breath of Critical Strike
	[158878] = 110632, -- Enchant Cloak - Breath of Haste
	[158879] = 110633, -- Enchant Cloak - Breath of Mastery
	[158881] = 110635, -- Enchant Cloak - Breath of Versatility
	[190866] = 128537, -- Enchant Ring - Word of Critical Strike
	[190992] = 128537, -- Enchant Ring - Word of Critical Strike
	[191009] = 128537, -- Enchant Ring - Word of Critical Strike
	[190867] = 128538, -- Enchant Ring - Word of Haste
	[190993] = 128538, -- Enchant Ring - Word of Haste
	[191010] = 128538, -- Enchant Ring - Word of Haste
	[190868] = 128539, -- Enchant Ring - Word of Mastery
	[190994] = 128539, -- Enchant Ring - Word of Mastery
	[191011] = 128539, -- Enchant Ring - Word of Mastery
	[190869] = 128540, -- Enchant Ring - Word of Versatility
	[190995] = 128540, -- Enchant Ring - Word of Versatility
	[191012] = 128540, -- Enchant Ring - Word of Versatility
	[190874] = 128545, -- Enchant Cloak - Word of Strength
	[191000] = 128545, -- Enchant Cloak - Word of Strength
	[191017] = 128545, -- Enchant Cloak - Word of Strength
	[190875] = 128546, -- Enchant Cloak - Word of Agility
	[191001] = 128546, -- Enchant Cloak - Word of Agility
	[191018] = 128546, -- Enchant Cloak - Word of Agility
	[190876] = 128547, -- Enchant Cloak - Word of Intellect
	[191002] = 128547, -- Enchant Cloak - Word of Intellect
	[191019] = 128547, -- Enchant Cloak - Word of Intellect
	[235695] = 144304, -- Enchant Neck - Mark of the Master
	[235699] = 144304, -- Enchant Neck - Mark of the Master
	[235703] = 144304, -- Enchant Neck - Mark of the Master
	[235696] = 144305, -- Enchant Neck - Mark of the Versatile
	[235700] = 144305, -- Enchant Neck - Mark of the Versatile
	[235704] = 144305, -- Enchant Neck - Mark of the Versatile
	[235697] = 144306, -- Enchant Neck - Mark of the Quick
	[235701] = 144306, -- Enchant Neck - Mark of the Quick
	[235705] = 144306, -- Enchant Neck - Mark of the Quick
	[235698] = 144307, -- Enchant Neck - Mark of the Deadly
	[235702] = 144307, -- Enchant Neck - Mark of the Deadly
	[235706] = 144307, -- Enchant Neck - Mark of the Deadly
	[190870] = 128541, -- Enchant Ring - Binding of Critical Strike
	[190996] = 128541, -- Enchant Ring - Binding of Critical Strike
	[191013] = 128541, -- Enchant Ring - Binding of Critical Strike
	[190871] = 128542, -- Enchant Ring - Binding of Haste
	[190997] = 128542, -- Enchant Ring - Binding of Haste
	[191014] = 128542, -- Enchant Ring - Binding of Haste
	[190872] = 128543, -- Enchant Ring - Binding of Mastery
	[190998] = 128543, -- Enchant Ring - Binding of Mastery
	[191015] = 128543, -- Enchant Ring - Binding of Mastery
	[190873] = 128544, -- Enchant Ring - Binding of Versatility
	[190999] = 128544, -- Enchant Ring - Binding of Versatility
	[191016] = 128544, -- Enchant Ring - Binding of Versatility
	[190877] = 128548, -- Enchant Cloak - Binding of Strength
	[191003] = 128548, -- Enchant Cloak - Binding of Strength
	[191020] = 128548, -- Enchant Cloak - Binding of Strength
	[190878] = 128549, -- Enchant Cloak - Binding of Agility
	[191004] = 128549, -- Enchant Cloak - Binding of Agility
	[191021] = 128549, -- Enchant Cloak - Binding of Agility
	[190879] = 128550, -- Enchant Cloak - Binding of Intellect
	[191005] = 128550, -- Enchant Cloak - Binding of Intellect
	[191022] = 128550, -- Enchant Cloak - Binding of Intellect
	[190892] = 128551, -- Enchant Neck - Mark of the Claw
	[191006] = 128551, -- Enchant Neck - Mark of the Claw
	[191023] = 128551, -- Enchant Neck - Mark of the Claw
	[190893] = 128552, -- Enchant Neck - Mark of the Distant Army
	[191007] = 128552, -- Enchant Neck - Mark of the Distant Army
	[191024] = 128552, -- Enchant Neck - Mark of the Distant Army
	[190894] = 128553, -- Enchant Neck - Mark of the Hidden Satyr
	[191008] = 128553, -- Enchant Neck - Mark of the Hidden Satyr
	[191025] = 128553, -- Enchant Neck - Mark of the Hidden Satyr
	[190954] = 128554, -- Enchant Shoulder - Boon of the Scavenger
	[190988] = 128558, -- Enchant Gloves - Legion Herbalism
	[190989] = 128559, -- Enchant Gloves - Legion Mining
	[190990] = 128560, -- Enchant Gloves - Legion Skinning
	[190991] = 128561, -- Enchant Gloves - Legion Surveying
	[228402] = 141908, -- Enchant Neck - Mark of the Heavy Hide
	[228403] = 141908, -- Enchant Neck - Mark of the Heavy Hide
	[228404] = 141908, -- Enchant Neck - Mark of the Heavy Hide
	[228405] = 141909, -- Enchant Neck - Mark of the Trained Soldier
	[228406] = 141909, -- Enchant Neck - Mark of the Trained Soldier
	[228407] = 141909, -- Enchant Neck - Mark of the Trained Soldier
	[228408] = 141910, -- Enchant Neck - Mark of the Ancient Priestess
	[228409] = 141910, -- Enchant Neck - Mark of the Ancient Priestess
	[228410] = 141910, -- Enchant Neck - Mark of the Ancient Priestess
}

function Pr:EnchantButton()
	local button = CreateFrame("Button", "SLE_EnchScrollButton", _G["TradeSkillFrame"], "MagicButtonTemplate")
	if E.private.skins.blizzard.tradeskill == true and E.private.skins.blizzard.enable == true then
		S:HandleButton(button)
		button:StripTextures()
		button:SetTemplate('Default', true)
		button:ClearAllPoints()
		button:SetPoint("TOPRIGHT", _G["TradeSkillFrame"].DetailsFrame.CreateButton, "TOPLEFT", -1, 0)
	else
		button:SetPoint("TOPRIGHT", _G["TradeSkillFrame"].DetailsFrame.CreateButton, "TOPLEFT")
	end
	button:SetScript("OnClick", function()
		if (IsShiftKeyDown() and button.itemID) then
			local activeEditBox = ChatEdit_GetActiveWindow()
			if activeEditBox then
				local _, link = T.GetItemInfo(button.itemID)
				ChatEdit_InsertLink(link)
			end
		else
			C_TradeSkillUI.CraftRecipe(_G["TradeSkillFrame"].DetailsFrame.selectedRecipeID)
			UseItemByName(38682)
		end
	end)
	button:SetScript("OnEnter", function()
		if button.itemID then
			GameTooltip:SetOwner(button)
			GameTooltip:SetItemByID(button.itemID)
		end
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
	button:SetMotionScriptsWhileDisabled(true)
	local EnchName = T.GetSpellInfo(7411)

	local function UpdateScrollButton(frame)
		if not frame.selectedRecipeID then return end
		local _, CURRENT_TRADESKILL = C_TradeSkillUI.GetTradeSkillLine()
		if CURRENT_TRADESKILL ~= EnchName then _G["SLE_EnchScrollButton"]:Hide() return end

		local recipeInfo = C_TradeSkillUI.GetRecipeInfo(frame.selectedRecipeID)
		if not recipeInfo then return end
		if C_TradeSkillUI.IsTradeSkillGuild() or C_TradeSkillUI.IsTradeSkillLinked() then
			_G["SLE_EnchScrollButton"]:Hide()
		elseif recipeInfo.alternateVerb then
			button.itemID = Pr.mapSpellToItem[recipeInfo.recipeID]
			if (not button.itemID) then
				SLE:Print(string.format(L["Missing scroll item for spellID %d. Please report this at the Shadow&Light Ticket Tracker."], recipeInfo.recipeID))
			end
			_G["SLE_EnchScrollButton"]:Show()
			local scrollnum = T.GetItemCount(38682)
			_G["SLE_EnchScrollButton"]:SetText(string.format("%s (%d)", L['Scroll'], scrollnum))
			if recipeInfo.craftable and scrollnum > 0 then
				_G["SLE_EnchScrollButton"]:Enable()
			else
				_G["SLE_EnchScrollButton"]:Disable()
			end
		else
			_G["SLE_EnchScrollButton"]:Hide()
		end
	end
	hooksecurefunc(_G["TradeSkillFrame"].DetailsFrame, "Refresh", UpdateScrollButton)
end
