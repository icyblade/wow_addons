GladiatorlosSA = LibStub("AceAddon-3.0"):NewAddon("GladiatorlosSA", "AceEvent-3.0","AceConsole-3.0","AceTimer-3.0")

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")
local LSM = LibStub("LibSharedMedia-3.0")
local self ,GladiatorlosSA = GladiatorlosSA ,GladiatorlosSA
local GSA_TEXT= "GladiatorlosSA"
local GSA_VERSION= " v1.0.1"
local GSA_AUTHOR= " updated by superk"

local GSA_LOCALEPATH = {
	enUS = "GladiatorlosSA\\Voice_enUS",
	zhTW = "GladiatorlosSA\\Voice",
	zhCN = "GladiatorlosSA\\Voice"
}
self.GSA_LOCALEPATH = GSA_LOCALEPATH
local GSA_LANGUAGE = {
	["GladiatorlosSA\\Voice"] = L["Chinese(female)"],
	["GladiatorlosSA\\Voice_enUS"] = L["English(female)"],
}
self.GSA_LANGUAGE = GSA_LANGUAGE
local GSA_EVENT = {
	SPELL_CAST_SUCCESS = L["Spell cast success"],
	SPELL_CAST_START = L["Spell cast start"],
	SPELL_AURA_APPLIED = L["Spell aura applied"],
	SPELL_AURA_REMOVED = L["Spell aura removed"],
	SPELL_INTERRUPT = L["Spell interrupt"],
	SPELL_SUMMON = L["Spell summon"]
	--UNIT_AURA = "Unit aura changed",
}
local GSA_UNIT = {
	any = L["Any"],
	player = L["Player"],
	target = L["Target"],
	focus = L["Focus"],
	mouseover = L["Mouseover"],
	--party = L["Party"],
	--raid = L["Raid"],
	--arena = L["Arena"],
	--boss = L["Boss"],
	custom = L["Custom"], 
}
local GSA_TYPE = {
	[COMBATLOG_FILTER_EVERYTHING] = L["Any"],
	[COMBATLOG_FILTER_FRIENDLY_UNITS] = L["Friendly"],
	[COMBATLOG_FILTER_HOSTILE_PLAYERS] = L["Hostile player"],
	[COMBATLOG_FILTER_HOSTILE_UNITS] = L["Hostile unit"],
	[COMBATLOG_FILTER_NEUTRAL_UNITS] = L["Neutral"],
	[COMBATLOG_FILTER_ME] = L["Myself"],
	[COMBATLOG_FILTER_MINE] = L["Mine"],
	[COMBATLOG_FILTER_MY_PET] = L["My pet"],
}
local sourcetype,sourceuid,desttype,destuid = {},{},{},{}
local gsadb
local PlaySoundFile = PlaySoundFile
local dbDefaults = {
	profile = {
		all = false,
		arena = true,
		battleground = true,
		field = true,
		path = GSA_LOCALEPATH[GetLocale()] or "GladiatorlosSA\\Voice_enUS",
		throttle = 0,
		smartDisable = false,
		
		
		aruaApplied = false,
		aruaRemoved = false,
		castStart = false,
		castSuccess = false,
		interrupt = false,
		
		aonlyTF = false,
		conlyTF= false,
		sonlyTF = false,
		ronlyTF = false,
		drinking = true,
		class = false,

		archangel = false,
		--vendetta = false,
		--desperatePrayer = false,
		--redirect = false,
		freezingTrap = false,
		battlestance = false,
		defensestance = false,
		berserkerstance = false,		
		waterShield = false,
		lichborneDown = false,
		iceboundFortitudeDown = false,
		bindElemental = false,
		custom = {},
	}	
}

local function log(msg) DEFAULT_CHAT_FRAME:AddMessage("|cFF33FF22GSA|r:"..msg) end

function GladiatorlosSA:OnInitialize()
	if not self.spellList then
		self.spellList = self:GetSpellList()
	end
	for _,v in pairs(self.spellList) do
		for _,spell in pairs(v) do
			if dbDefaults.profile[spell] == nil then dbDefaults.profile[spell] = true end
		end
	end
	
	self.db1 = LibStub("AceDB-3.0"):New("GladiatorlosSADB",dbDefaults, "Default");
	--DEFAULT_CHAT_FRAME:AddMessage(GSA_TEXT .. GSA_VERSION .. GSA_AUTHOR .."  - /gsa ");
	--LibStub("AceConfig-3.0"):RegisterOptionsTable("GladiatorlosSA", GladiatorlosSA.Options, {"GladiatorlosSA", "SS"})
	self:RegisterChatCommand("GladiatorlosSA", "ShowConfig")
	self:RegisterChatCommand("gsa", "ShowConfig")
	self.db1.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
	self.db1.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
	self.db1.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
	gsadb = self.db1.profile
	GladiatorlosSA.options = {
		name = "GladiatorlosSA",
		desc = L["PVP Voice Alert"],
		type = 'group',
		args = {},
	}
	local bliz_options = CopyTable(GladiatorlosSA.options)
	bliz_options.args.load = {
		name = L["Load Configuration"],
		desc = L["Load Configuration Options"],
		type = 'execute',
		func = "ShowConfig",
		handler = GladiatorlosSA,
	}
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GladiatorlosSA_bliz", bliz_options)
	AceConfigDialog:AddToBlizOptions("GladiatorlosSA_bliz", "GladiatorlosSA")
end
function GladiatorlosSA:OnEnable()
	GladiatorlosSA:RegisterEvent("PLAYER_ENTERING_WORLD")
	GladiatorlosSA:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	GladiatorlosSA:RegisterEvent("UNIT_AURA")
	if not GSA_LANGUAGE[gsadb.path] then gsadb.path = GSA_LOCALEPATH[GetLocale()] end
	self.throttled = {}
	self.smarter = 0
end
function GladiatorlosSA:OnDisable()
end
local function initOptions()
	--[[if GladiatorlosSA.options.args.general then
		return
	end]]

	GladiatorlosSA:OnOptionsCreate()

	for k, v in GladiatorlosSA:IterateModules() do
		if type(v.OnOptionsCreate) == "function" then
			v:OnOptionsCreate()
		end
	end
	AceConfig:RegisterOptionsTable("GladiatorlosSA", GladiatorlosSA.options)
end
function GladiatorlosSA:ShowConfig()
	initOptions()
	AceConfigDialog:SetDefaultSize("GladiatorlosSA",800, 500)
	AceConfigDialog:Open("GladiatorlosSA")
end
function GladiatorlosSA:ChangeProfile()
	gsadb = self.db1.profile
	for k,v in GladiatorlosSA:IterateModules() do
		if type(v.ChangeProfile) == 'function' then
			v:ChangeProfile()
		end
	end
end
function GladiatorlosSA:AddOption(key, table)
	self.options.args[key] = table
end

local function setOption(info, value)
	local name = info[#info]
	gsadb[name] = value
	if value then 
		PlaySoundFile("Interface\\Addons\\"..gsadb.path.."\\"..name..".ogg","Master");
	end
end
local function getOption(info)
	local name = info[#info]
	return gsadb[name]
end
local function spellOption(order, spellID, ...)
	local spellname,_,icon = GetSpellInfo(spellID)				
	if (spellname ~= nil) then
		return {
			type = 'toggle',
			name = "\124T"..icon..":24\124t"..spellname,							
			desc = function () 
			GameTooltip:SetHyperlink(GetSpellLink(spellID));
			--GameTooltip:Show();
			end,
			descStyle = "custom",
					order = order,
		}
	else
		print("spell id: "..spellID.." is invalid")
	end
end

local function listOption(spellList, listType, ...)
	local args = {}
	for k, v in pairs(spellList) do
		if self.spellList[listType][v] then
			rawset (args, self.spellList[listType][v] ,spellOption(k, v))
		else 
		--[[debug
			print (v)
		]]
		end
	end
	return args
end
function GladiatorlosSA:OnOptionsCreate()
	
	self:AddOption("profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db1))
	self.options.args.profiles.order = -1
	self:AddOption('genaral', {
		type = 'group',
		name = L["General"],
		desc = L["General options"],
		set = setOption,
		get = getOption,
		order = 1,
		args = {
			enableArea = {
				type = 'group',
				inline = true,
				name = L["Enable area"],
				order = 1,
				args = {
					all = {
						type = 'toggle',
						name = L["Anywhere"],
						desc = L["Alert works anywhere"],
						order = 1,
					},
					arena = {
						type = 'toggle',
						name = L["Arena"],
						desc = L["Alert only works in arena"],
						disabled = function() return gsadb.all end,
						order = 2,
					},
					NewLine1 = {
						type= 'description',
						order = 3,
						name= '',
					},
					battleground = {
						type = 'toggle',
						name = L["Battleground"],
						desc = L["Alert only works in BG"],
						disabled = function() return gsadb.all end,
						order = 4,
					},
					field = {
						type = 'toggle',
						name = L["World"],
						desc = L["Alert works anywhere else then anena, BG, dungeon instance"],
						disabled = function() return gsadb.all end,
						order = 5,
					}
				},
			},
			voice = {
				type = 'group',
				inline = true,
				name = L["Voice config"],
				order = 2,
				args = {
					path = {
						type = 'select',
						name = L["Voice language"],
						desc = L["Select language of the alert"],
						values = GSA_LANGUAGE,
						order = 1,
					},
					volumn = {
						type = 'range',
						max = 1,
						min = 0,
						step = 0.1,
						name = L["Volume"],
						desc = L["adjusting the voice volume(the same as adjusting the system master sound volume)"],
						set = function (info, value) SetCVar ("Sound_MasterVolume",tostring (value)) end,
						get = function () return tonumber (GetCVar ("Sound_MasterVolume")) end,
						order = 2,
					},
				},
			},
			advance = {
				type = 'group',
				inline = true,
				name = L["Advance options"],
				order = 3,
				args = {
					smartDisable = {
						type = 'toggle',
						name = L["Smart disable"],
						desc = L["Disable addon for a moment while too many alerts comes"],
						order = 1,
					},
					throttle = {
						type = 'range',
						max = 5,
						min = 0,
						step = 0.1,
						name = L["Throttle"],
						desc = L["The minimum interval of each alert"],
						order = 2,
					},
				},
			},
		}
	})
	self:AddOption('spell', {
		type = 'group',
		name = L["Abilities"],
		desc = L["Abilities options"],
		set = setOption,
		get = getOption,
		order = 2,
		args = {
			spellGeneral = {
				type = 'group',
				name = L["Disable options"],
				desc = L["Disable abilities by type"],
				inline = true,
				order = -1,
				args = {
					aruaApplied = {
						type = 'toggle',
						name = L["Disable Buff Applied"],
						desc = L["Check this will disable alert for buff applied to hostile targets"],
						order = 1,
					},
					aruaRemoved = {
						type = 'toggle',
						name = L["Disable Buff Down"],
						desc = L["Check this will disable alert for buff removed from hostile targets"],
						order = 2,
					},
					castStart = {
						type = 'toggle',
						name = L["Disable Spell Casting"],
						desc = L["Chech this will disable alert for spell being casted to friendly targets"],
						order = 3,
					},
					castSuccess = {
						type = 'toggle',
						name = L["Disable special abilities"],
						desc = L["Check this will disable alert for instant-cast important abilities"],
						order = 4,
					},
					interrupt = {
						type = 'toggle',
						name = L["Disable friendly interrupt"],
						desc = L["Check this will disable alert for successfully-landed friendly interrupting abilities"],
						order = 5,
					}
				},
			},
			spellAuraApplied = {
				type = 'group',
				--inline = true,
				name = L["Buff Applied"],
				disabled = function() return gsadb.aruaApplied end,
				order = 1,
				args = {
					aonlyTF = {
						type = 'toggle',
						name = L["Target and Focus Only"],
						desc = L["Alert works only when your current target or focus gains the buff effect or use the ability"],
						order = 1,
					},
					drinking = { 
						type = 'toggle',
						name = L["Alert Drinking"],
						desc = L["In arena, alert when enemy is drinking"],
						order = 3,
					},
						--[[general = {
						type = 'group',
						inline = true,
						name = L["General Abilities"],
						order = 4,
						args = listOption({42292,20594,7744},"auraApplied"),
					},]]
						dk	= {
							type = 'group',
							inline = true,
							name = L["|cffC41F3BDeath Knight|r"],
							order = 5,
							args = listOption({49039,48792,55233,49016,51271,48707,115989,113072},"auraApplied"),
						},
						druid = {
							type = 'group',
							inline = true,
							name = L["|cffFF7D0ADruid|r"],
							order = 6,
							args = listOption({61336,29166,22812,132158,16689,22842,5229,1850,50334,69369,124974,106922,112071,102351,102342,110575,110570,110617,110696,110700,110717,122291,110806,110717,110715,110788,126456,126453},"auraApplied"),	
						},
						hunter = {
							type = 'group',
							inline = true,
							name = L["|cffABD473Hunter|r"],
							order = 7,
							args = listOption({34471,19263,3045,54216,113073},"auraApplied"),
						},
						mage = {
							type = 'group',
							inline = true,
							name = L["|cff69CCF0Mage|r"],
							order = 8,
							args = listOption({45438,12042,12472,12043,108839,110909},"auraApplied"),
						},
						monk = {
							type = 'group',
							inline = true,
							name = L["|cFF558A84Monk|r"],
							order = 9,
							args = listOption({120954,122278,122783,115213,115176,116849,115294,113306},"auraApplied"),
						},
						paladin = {
							type = 'group',
							inline = true,
							name = L["|cffF58CBAPaladin|r"],
							order = 10,
							args = listOption({31821,1022,1044,642,6940,54428,31884,114917,114163,20925,114039,105809,113075},"auraApplied"),
						},
						preist	= {
							type = 'group',
							inline = true,
							name = L["|cffFFFFFFPriest|r"],
							order = 11,
							args = listOption({33206,37274,6346,47585,89485,81700,47788,112833,109964,81209,81206,81208},"auraApplied"),
						},
						rogue = {
							type = 'group',
							inline = true,
							name = L["|cffFFF569Rogue|r"],
							order = 12,
							args = listOption({51713,2983,31224,13750,5277,74001,114018},"auraApplied"),
						},
						shaman	= {
							type = 'group',
							inline = true,
							name = L["|cff0070daShaman|r"],
							order = 13,
							args = listOption({30823,974,16188,79206,16166,114050,114051,114052,52127},"auraApplied"),
						},
						warlock	= {
							type = 'group',
							inline = true,
							name = L["|cff9482C9Warlock|r"],
							order = 14,
							args = listOption({108416,108503,119049,113858,113861,113860,104773},"auraApplied"),
						},
						warrior	= {
							type = 'group',
							inline = true,
							name = L["|cffC79C6EWarrior|r"],
							order = 15,
							args = listOption({55694,871,18499,23920,12328,46924,85730,12292,1719,114028,107574,112048,114029,114030},"auraApplied"),	
						},
				},
			},
			spellAuraRemoved = {
				type = 'group',
				--inline = true,
				name = L["Buff Down"],
				disabled = function() return gsadb.aruaRemoved end,
				order = 2,
				args = {
					ronlyTF = {
						type = 'toggle',
						name = L["Target and Focus Only"],
						desc = L["Alert works only when your current target or focus gains the buff effect or use the ability"],
						order = 1,
					},
					dk = {
						type = 'group',
						inline = true,
						name = L["|cffC41F3BDeath Knight|r"],
						order = 4,
						args = listOption({48792,49039,113072},"auraRemoved"),
					},
					druid = {
						type = 'group',
						inline = true,
						name = L["|cffFF7D0ADruid|r"],
						order = 5,
						args = listOption({106922,110617,110696,110700,110715,110788,126456,126453},"auraRemoved"),
					},
					hunter = {
						type = 'group',
						inline = true,
						name = L["|cffABD473Hunter|r"],
						order = 6,
						args = listOption({19263},"auraRemoved"),
					},
					mage = {
						type = 'group',
						inline = true,
						name = L["|cff69CCF0Mage|r"],
						order = 7,
						args = listOption({45438},"auraRemoved"),
					},
					monk = {
						type = 'group',
						inline = true,
						name = L["|cFF558A84Monk|r"],
						order = 9,
						args = listOption({120954,115213,115176},"auraRemoved"),	
					},
					paladin = {
						type = 'group',
						inline = true,
						name = L["|cffF58CBAPaladin|r"],
						order = 10,
						args = listOption({1022,642},"auraRemoved"),
					},
					preist	= {
						type = 'group',
						inline = true,
						name = L["|cffFFFFFFPriest|r"],
						order = 11,
						args = listOption({33206,47585,109964},"auraRemoved"),
					},
					rogue = {
						type = 'group',
						inline = true,
						name = L["|cffFFF569Rogue|r"],
						order = 12,
						args = listOption({31224,5277,74001},"auraRemoved"),
					},
					shaman	= {
						type = 'group',
						inline = true,
						name = L["|cff0070daShaman|r"],
						order = 13,
						args = listOption({108271,118350,118347},"auraRemoved"),
					},
					warrior	= {
						type = 'group',
						inline = true,
						name = L["|cffC79C6EWarrior|r"],
						order = 14,
						args = listOption({871,103827,114030},"auraRemoved"),
					},
				},
			},
			spellCastStart = {
				type = 'group',
				--inline = true,
				name = L["Spell Casting"],
				disabled = function() return gsadb.castStart end,
				order = 2,
				args = {
					conlyTF = {
						type = 'toggle',
						name = L["Target and Focus Only"],
						desc = L["Alert works only when your current target or focus gains the buff effect or use the ability"],
						order = 1,
					},
					general = {
						type = 'group',
						inline = true,
						name = L["General Abilities"],
						order = 3,
						args = {
							bigHeal = {
								type = 'toggle',
								name = L["Big Heals"],
								desc = L["Greater Heal, Divine Light, Greater Healing Wave, Healing Touch, Enveloping Mist"],
								order = 1,
							},
							resurrection = {
								type = 'toggle',
								name = L["Resurrection"],
								desc = L["Resurrection, Redemption, Ancestral Spirit, Revive, Resuscitate"],
								order = 2,
							},
						}
					},
					druid = {
						type = 'group',
						inline = true,
						name = L["|cffFF7D0ADruid|r"],
						order = 4,
						args = listOption({2637,33786,339,110707},"castStart"),
					},
					hunter = {
						type = 'group',
						inline = true,
						name = L["|cffABD473Hunter|r"],
						order = 5,
						args = listOption({982,1513,120360},"castStart"),
					},
					mage = {
						type = 'group',
						inline = true,
						name = L["|cff69CCF0Mage|r"],
						order = 6,
						args = listOption({118,102051,113074},"castStart"),
					},
					monk = {
						type = 'group',
						inline = true,
						name = L["|cFF558A84Monk|r"],
						order = 7,
						args = listOption({113275},"castStart"),	
					},
					paladin = {
						type = 'group',
						inline = true,
						name = L["|cffF58CBAPaladin|r"],
						order = 8,
						args = listOption({20066},"castStart"),
					},
					preist	= {
						type = 'group',
						inline = true,
						name = L["|cffFFFFFFPriest|r"],
						order = 9,
						args = listOption({9484,605,32375,113277,113506},"castStart"),
					},
					shaman	= {
						type = 'group',
						inline = true,
						name = L["|cff0070daShaman|r"],
						order = 10,
						args = listOption({51514,76780},"castStart"),
					},
					warlock	= {
						type = 'group',
						inline = true,
						name = L["|cff9482C9Warlock|r"],
						order = 11,
						args = listOption({5782,710,691,112869,112870,112867,112866},"castStart"),
					},
					--dk	= {
						--type = 'group',
						--inline = true,
						--name = L["|cffC41F3BDeath Knight|r"],
						--order = 9,
						--args = listOption({49203},"castStart"),
					--},			
				},
			},
			spellCastSuccess = {
				type = 'group',
				--inline = true,
				name = L["Special Abilities"],
				disabled = function() return gsadb.castSuccess end,
				order = 3,
				args = {
					sonlyTF = {
						type = 'toggle',
						name = L["Target and Focus Only"],
						desc = L["Alert works only when your current target or focus gains the buff effect or use the ability"],
						order = 1,
					},
					class = {
						type = 'toggle',
						name = L["PvP Trinketed Class"],
						desc = L["Also announce class name with trinket alert when hostile targets use PvP trinket in arena"],
						disabled = function() return not gsadb.trinket end,
						order = 3,
					},
					general = {
						type = 'group',
						inline = true,
						name = L["General Abilities"],
						order = 4,
						args = listOption({58984,20594,7744,42292},"castSuccess"),
					},
					dk	= {
						type = 'group',
						inline = true,
						name = L["|cffC41F3BDeath Knight|r"],
						order = 5,
						args = listOption({47528,47476,47568,49206,77606,108194,108199,108201,108200},"castSuccess"),
					},
					druid = {
						type = 'group',
						inline = true,
						name = L["|cffFF7D0ADruid|r"],
						order = 6,
						args = listOption({80964,740,78675,108238,102693,102703,102706,99,5211,102795,102560,102543,102558,33891,102359,33831,102417,102383,49376,16979,102416,102401,110698,110730,113002,113004,122292,112970,128844,126458},"castSuccess"),
					},
					hunter = {
						type = 'group',
						inline = true,
						name = L["|cffABD473Hunter|r"],
						order = 7,
						args = listOption({19386,19503,34490,23989,60192,1499,109248,109304,120657,120697,109259,126216,126215,126214,126213,122811,122809,122807,122806,122804,122802,121118,121818},"castSuccess"),
					},
					mage = {
						type = 'group',
						inline = true,
						name = L["|cff69CCF0Mage|r"],
						order = 8,
						args = listOption({11129,11958,44572,2139,66,12051,113724,110959},"castSuccess"),
					},
					monk = {
						type = 'group',
						inline = true,
						name = L["|cFF558A84Monk|r"],
						order = 9,
						args = listOption({116841,115399,119392,119381,116847,123904,115078,122057,115315,115313,117368,122470,116705,123761,119996},"castSuccess"),
					},
					paladin = {
						type = 'group',
						inline = true,
						name = L["|cffF58CBAPaladin|r"],
						order = 10,
						args = listOption({96231,853,105593,114158,115750,85499},"castSuccess"),
					},
					preist	= {
						type = 'group',
						inline = true,
						name = L["|cffFFFFFFPriest|r"],
						order = 110,
						args = listOption({8122,34433,64044,15487,64843,19236,108920,108921,123040,121135,108968},"castSuccess"),
					},
					rogue = {
						type = 'group',
						inline = true,
						name = L["|cffFFF569Rogue|r"],
						order = 111,
						args = listOption({51722,2094,1766,14185,1856,76577,73981,79140},"castSuccess"),
					},
					shaman	= {
						type = 'group',
						inline = true,
						name = L["|cff0070daShaman|r"],
						order = 112,
						args = listOption({108271,8177,16190,8143,98008,108270,51485,108273,108285,108287,108280,108281,118345,2894,2062,108269,120668,118350,118347,57994,113287},"castSuccess"),
					},
					warlock = {
						type = 'group',
						inline = true,
						name = L["|cff9482C9Warlock|r"],
						order = 113,
						args = listOption({108359,6789,5484,19647,48020,30283,111397,108482,108505,124539,104316,110913,111859,111895,111896,111897,111898},"castSuccess"),
					},
					warrior	= {
						type = 'group',
						inline = true,
						name = L["|cffC79C6EWarrior|r"],
						order = 114,
						args = listOption({97462,676,5246,6552,2457,71,2458,107566,102060,46968,118000,107570,114207,114192,114203},"castSuccess"),	
					},
				},
			},
			spellInterrupt = {
				type = 'group',
				--inline = true,
				name = L["Friendly Interrupt"],
				disabled = function() return gsadb.interrupt end,
				order = 4,
				args = {
					lockout = {
						type = 'toggle',
						name = L["Friendly Interrupt"],
						desc = L["Spell Lock, Counterspell, Kick, Pummel, Mind Freeze, Skull Bash, Rebuke, Solar Beam, Spear Hand Strike, Wind Shear"],
						order = 1,
					},
				}
			},
		}
	})
	self:AddOption('custom', {
		type = 'group',
		name = L["Custom"],
		--name = L["自定義"],
		desc = L["Custom Spell"],
		--set = function(info, value) local name = info[#info] gsadb.custom[name] = value end,
		--get = function(info) local name = info[#info]	return gsadb.custom[name] end,
		order = 4,
		args = {
			newalert = {
				type = 'execute',
				name = L["New Sound Alert"],
				--name = L["添加自定義技能"],
				order = -1,
				--[[args = {
					newname = {
						type = 'input',
						name = "name",
						set = function(info, value) local name = info[#info] if gsadb.custom[vlaue] then log("name already exists") return end gsadb.custom[vlaue]={} end,			
					}]]
				func = function()
					gsadb.custom[L["New Sound Alert"]] = {
						name = L["New Sound Alert"],
						soundfilepath = "Interface\\GSASound\\"..L["New Sound Alert"]..".ogg",
						sourceuidfilter = "any",
						destuidfilter = "any",
						eventtype = {
							SPELL_CAST_SUCCESS = true,
							SPELL_CAST_START = false,
							SPELL_AURA_APPLIED = false,
							SPELL_AURA_REMOVED = false,
							SPELL_INTERRUPT = false,
						},
						sourcetypefilter = COMBATLOG_FILTER_EVERYTHING,
						desttypefilter = COMBATLOG_FILTER_EVERYTHING,
						order = 0,
					}
					self:OnOptionsCreate()
				end,
				disabled = function ()
					if gsadb.custom[L["New Sound Alert"]] then
						return true
					else
						return false
					end
				end,
			}
		}
	})
	local function makeoption(key)
		local keytemp = key
		self.options.args.custom.args[key] = {
			type = 'group',
			name = gsadb.custom[key].name,
			set = function(info, value) local name = info[#info] gsadb.custom[key][name] = value end,
			get = function(info) local name = info[#info] return gsadb.custom[key][name] end,
			order = gsadb.custom[key].order,
			args = {
				name = {
					name = L["name"],
					type = 'input',
					set = function(info, value)
						if gsadb.custom[value] then log(L["same name already exists"]) return end
						gsadb.custom[key].name = value
						gsadb.custom[key].order = 100
						gsadb.custom[key].soundfilepath = "Interface\\GSASound\\"..value..".ogg"
						gsadb.custom[value] = gsadb.custom[key]
						gsadb.custom[key] = nil
						--makeoption(value)
						self.options.args.custom.args[keytemp].name = value
						key = value
					end,
					order = 10,
				},
				spellid = {
					name = L["spellid"],
					type = 'input',
					order = 20,
					pattern = "%d+$",
				},
				remove = {
					type = 'execute',
					order = 25,
					name = L["Remove"],
					confirm = true,
					confirmText = L["Are you sure?"],
					func = function() 
						gsadb.custom[key] = nil
						self.options.args.custom.args[keytemp] = nil
					end,
				},
				test = {
					type = 'execute',
					order = 28,
					name = L["Test"],
					func = function() PlaySoundFile(gsadb.custom[key].soundfilepath,"Master") end,
				},
				existingsound = {
					name = L["Use existing sound"],
					type = 'toggle',
					order = 30,
				},
				existinglist = {
					name = L["choose a sound"],
					type = 'select',
					dialogControl = 'LSM30_Sound',
					values =  LSM:HashTable("sound"),
					disabled = function() return not gsadb.custom[key].existingsound end,
					order = 40,
				},
				NewLine3 = {
					type= 'description',
					order = 45,
					name= '',
				},
				soundfilepath = {
					name = L["file path"],
					type = 'input',
					width = 'double',
					order = 27,
					disabled = function() return gsadb.custom[key].existingsound end,
				},
				eventtype = {
					type = 'multiselect',
					order = 50,
					name = L["event type"],
					values = GSA_EVENT,
					get = function(info, k) return gsadb.custom[key].eventtype[k] end,
					set = function(info, k, v) gsadb.custom[key].eventtype[k] = v end,
				},
				sourceuidfilter = {
					type = 'select',
					order = 61,
					name = L["Source unit"],
					values = GSA_UNIT,
				},
				sourcetypefilter = {
					type = 'select',
					order = 60,
					name = L["Source type"],
					values = GSA_TYPE,
				},
				sourcecustomname = {
					type= 'input',
					order = 62,
					name= L["Custom unit name"],
					disabled = function() return not (gsadb.custom[key].sourceuidfilter == "custom") end,
				},
				destuidfilter = {
					type = 'select',
					order = 65,
					name = L["Dest unit"],
					values = GSA_UNIT,
				},
				desttypefilter = {
					type = 'select',
					order = 63,
					name = L["Dest type"],
					values = GSA_TYPE,
				},
				destcustomname = {
					type= 'input',
					order = 68,
					name = L["Custom unit name"],
					disabled = function() return not (gsadb.custom[key].destuidfilter == "custom") end,
				},
				--[[NewLine5 = {
					type = 'header',
					order = 69,
					name = "",
				},]]
			}
		}
	end
	for key, v in pairs(gsadb.custom) do
		makeoption(key)
	end
end

function GladiatorlosSA:PlayTrinket()
	PlaySoundFile("Interface\\Addons\\"..gsadb.path.."\\Trinket.ogg","Master")
end
function GladiatorlosSA:ArenaClass(id)
	for i = 1 , 5 do
		if id == UnitGUID("arena"..i) then
			return select(2, UnitClass ("arena"..i))
		end
	end
end
function GladiatorlosSA:PLAYER_ENTERING_WORLD()
	--CombatLogClearEntries()
end
function GladiatorlosSA:PlaySpell(list, spellID, ...)
	if not list[spellID] then return end
	if not gsadb[list[spellID]] then return	end
	if gsadb.throttle ~= 0 and self:Throttle("playspell",gsadb.throttle) then return end
	if gsadb.smartDisable then
		if (GetNumRaidMembers() or 0) > 20 then return end
		if self:Throttle("smarter",20) then
			self.smarter = self.smarter + 1
			if self.smarter > 30 then return end
		else 
			self.smarter = 0
		end
	end
	PlaySoundFile("Interface\\Addons\\"..gsadb.path.."\\"..list[spellID]..".ogg","Master");
end
function GladiatorlosSA:COMBAT_LOG_EVENT_UNFILTERED(event , ...)
	local _,currentZoneType = IsInInstance()
	if (not ((currentZoneType == "none" and gsadb.field) or (currentZoneType == "pvp" and gsadb.battleground) or (currentZoneType == "arena" and gsadb.arena) or gsadb.all)) then
		return
	end
	local timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName= select ( 1 , ... );
	if not GSA_EVENT[event] then return end
	--print(sourceName,destName,destFlags,event,spellName,spellID);
	--local sourcetype,sourceuid,desttype,destuid = {},{},{},{}
	if (destFlags) then
		for k in pairs(GSA_TYPE) do
			desttype[k] = CombatLog_Object_IsA(destFlags,k)
			--log("desttype:"..k.."="..(desttype[k] or "nil"))
		end
	else
		for k in pairs(GSA_TYPE) do
			desttype[k] = nil
		end
	end
	if (destGUID) then
		for k in pairs(GSA_UNIT) do
			destuid[k] = (UnitGUID(k) == destGUID)
			--log("destuid:"..k.."="..(destuid[k] and "true" or "false"))
		end
	else
		for k in pairs(GSA_UNIT) do
			destuid[k] = nil
			--log("destuid:"..k.."="..(destuid[k] and "true" or "false"))
		end
	end
	destuid.any = true
	if (sourceFlags) then
		for k in pairs(GSA_TYPE) do
			sourcetype[k] = CombatLog_Object_IsA(sourceFlags,k)
			--log("sourcetype:"..k.."="..(sourcetype[k] or "nil"))
		end
	else
		for k in pairs(GSA_TYPE) do
			sourcetype[k] = nil
			--log("sourcetype:"..k.."="..(sourcetype[k] or "nil"))
		end
	end
	if (sourceGUID) then
		for k in pairs(GSA_UNIT) do
			sourceuid[k] = (UnitGUID(k) == sourceGUID)
			--log("sourceuid:"..k.."="..(sourceuid[k] and "true" or "false"))
		end
	else
		for k in pairs(GSA_UNIT) do
			sourceuid[k] = nil
			--log("sourceuid:"..k.."="..(sourceuid[k] and "true" or "false"))
		end
	end
	sourceuid.any = true
	--print (destuid.target,sourceName,destName)
	--[[debug
	if (spellID == 80964 or spellID == 80965 or spellID == 85285) then 
		print (sourceName,destName,event,spellName,spellID)
	end
	enddebug]]--
	if (event == "SPELL_AURA_APPLIED" and desttype[COMBATLOG_FILTER_HOSTILE_PLAYERS] and (not gsadb.aonlyTF or destuid.target or destuid.focus) and not gsadb.aruaApplied) then
		self:PlaySpell (self.spellList.auraApplied,spellID)
	elseif (event == "SPELL_AURA_REMOVED" and desttype[COMBATLOG_FILTER_HOSTILE_PLAYERS] and (not gsadb.ronlyTF or destuid.target or destuid.focus) and not gsadb.auraRemoved) then
		self:PlaySpell (self.spellList.auraRemoved,spellID)
	elseif (event == "SPELL_CAST_START" and sourcetype[COMBATLOG_FILTER_HOSTILE_PLAYERS] and (not gsadb.conlyTF or sourceuid.target or sourceuid.focus) and not gsadb.castStart) then
		self:PlaySpell (self.spellList.castStart,spellID)
	elseif (event == "SPELL_CAST_SUCCESS" and sourcetype[COMBATLOG_FILTER_HOSTILE_PLAYERS] and (not gsadb.sonlyTF or sourceuid.target or sourceuid.focus) and not gsadb.castSuccess) then
		if (spellID == 42292 or spellID == 59752) and gsadb.class and currentZoneType == "arena" then
			local c = self:ArenaClass(sourceGUID)
			if c then 
				PlaySoundFile("Interface\\Addons\\"..gsadb.path.."\\"..c..".ogg","Master");
			end
			--self:ScheduleTimer("PlayTrinket", 0.3)
		else	
			self:PlaySpell (self.spellList.castSuccess,spellID)
		end
	--[[elseif (event == "SPELL_INTERRUPT") then
		print(sourceName,destName,destFlags,event,spellName,spellID)]]
	elseif (event == "SPELL_INTERRUPT" and desttype[COMBATLOG_FILTER_HOSTILE_PLAYERS] and not gsadb.interrupt) then 
		self:PlaySpell (self.spellList.friendlyInterrupt,spellID)
	elseif (event == "SPELL_SUMMON" and spellID == 82676 and sourcetype[COMBATLOG_FILTER_HOSTILE_PLAYERS] and (not gsadb.sonlyTF or sourceuid.target or sourceuid.focus) and not gsadb.castSuccess) then
		PlaySoundFile("Interface\\Addons\\"..gsadb.path.."\\ringOfFrost.ogg","Master")
	end
	for k,css in pairs (gsadb.custom) do
		if css.destuidfilter == "custom" and destName == css.destcustomname then 
			destuid.custom = true  
		else 
			destuid.custom = false 
		end
		if css.sourceuidfilter == "custom" and sourceName == css.sourcecustomname then
			sourceuid.custom = true  
		else
			sourceuid.custom = false 
		end
		if css.eventtype[event] and destuid[css.destuidfilter] and desttype[css.desttypefilter] and sourceuid[css.sourceuidfilter] and sourcetype[css.sourcetypefilter] and spellID == tonumber(css.spellid) then
			if self:Throttle(tostring(spellID)..css.name,0.1) then return end
			PlaySoundFile(css.soundfilepath,"Master")
		end
	end
end
local DRINK_SPELL = GetSpellInfo(57073)
function GladiatorlosSA:UNIT_AURA(event,uid)
	if uid:find("arena") and gsadb.drinking then
		if UnitAura (uid,DRINK_SPELL) then
			if self:Throttle(tostring(57073)..uid,3) then return end
			PlaySoundFile("Interface\\Addons\\"..gsadb.path.."\\drinking.ogg","Master")
		end
	end
end
local DRINK_SPELL2 = GetSpellInfo(104270)
function GladiatorlosSA:UNIT_AURA(event,uid)
	if uid:find("arena") and gsadb.drinking then
		if UnitAura (uid,DRINK_SPELL2) then
			if self:Throttle(tostring(104270)..uid,3) then return end
			PlaySoundFile("Interface\\Addons\\"..gsadb.path.."\\drinking.ogg","Master")
		end
	end
end

function GladiatorlosSA:Throttle(key,throttle)
	if (not self.throttled) then
		self.throttled = {}
	end
	-- Throttling of Playing
	if (not self.throttled[key]) then
		self.throttled[key] = GetTime()+throttle
		return false
	elseif (self.throttled[key] < GetTime()) then
		self.throttled[key] = GetTime()+throttle
		return false
	else
		return true
	end
end 