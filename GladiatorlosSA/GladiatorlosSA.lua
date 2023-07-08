GladiatorlosSA = LibStub("AceAddon-3.0"):NewAddon("GladiatorlosSA", "AceEvent-3.0","AceConsole-3.0","AceTimer-3.0")

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")
local LSM = LibStub("LibSharedMedia-3.0")
local self , GladiatorlosSA = GladiatorlosSA , GladiatorlosSA
local GSA_TEXT= "GladiatorlosSA"
local GSA_VERSION= " r430.02"
local GSA_AUTHOR= " updated by superk"

local GSA_LOCALEPATH = {
	enUS = "GladiatorlosSA\\Voice_enUS",
	zhTW = "GladiatorlosSA\\Voice",
	zhCN = "GladiatorlosSA\\Voice"
}
self.GSA_LOCALEPATH = GSA_LOCALEPATH
local GSA_LANGUAGE = {
	["GladiatorlosSA\\Voice"] = L["漢語(女聲)"],
	["GladiatorlosSA\\Voice_enUS"] = L["英語(女聲)"],
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
		desc = L["PVP技能語音提示"],
		type = 'group',
		args = {},
	}
	local bliz_options = CopyTable(GladiatorlosSA.options)
	bliz_options.args.load = {
		name = L["加載配置"],
		desc = L["加載配置選項"],
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
	AceConfigDialog:SetDefaultSize("GladiatorlosSA",780, 500)
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
end
local function listOption(spellList, listType, ...)
	local args = {}
	for k,v in pairs(spellList) do
		rawset (args, self.spellList[listType][v] ,spellOption(k, v))
	end
	return args
end
function GladiatorlosSA:OnOptionsCreate()
	
	self:AddOption("profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db1))
	self.options.args.profiles.order = -1
	self:AddOption('genaral', {
		type = 'group',
		name = L["一般"],
		desc = L["一般選項"],
		set = setOption,
		get = getOption,
		order = 1,
		args = {
			enableArea = {
				type = 'group',
				inline = true,
				name = L["當何時啟用"],
				order = 1,
				args = {
					all = {
						type = 'toggle',
						name = L["總是啟用"],
						desc = L["在任何地方GladiatorlosSA都處於開啟狀態"],
						order = 1,
					},
					arena = {
						type = 'toggle',
						name = L["競技場"],
						desc = L["在競技場中啟用GladiatorlosSA"],
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
						name = L["戰場"],
						desc = L["在戰場中啟用GladiatorlosSA"],
						disabled = function() return gsadb.all end,
						order = 4,
					},
					field = {
						type = 'toggle',
						name = L["野外"],
						desc = L["除了戰場、競技場和副本的任何地方都啟用GladiatorlosSA"],
						disabled = function() return gsadb.all end,
						order = 5,
					}
				},
			},
			voice = {
				type = 'group',
				inline = true,
				name = L["聲音設置"],
				order = 2,
				args = {
					path = {
						type = 'select',
						name = L["語言類型"],
						desc = L["選擇通報所用語音"],
						values = GSA_LANGUAGE,
						order = 1,
					},
					volumn = {
						type = 'range',
						max = 1,
						min = 0,
						step = 0.1,
						name = L["聲音大小"],
						desc = L["調節聲音大小(等同於調節系統主音量大小)"],
						set = function (info, value) SetCVar ("Sound_MasterVolume",tostring (value)) end,
						get = function () return tonumber (GetCVar ("Sound_MasterVolume")) end,
						order = 2,
					},
				},
			},
			advance = {
				type = 'group',
				inline = true,
				name = L["高級設置"],
				order = 3,
				args = {
					smartDisable = {
						type = 'toggle',
						name = L["智能禁用模式"],
						desc = L["處於大型戰場等警報過於頻繁的區域自動禁用"],
						order = 1,
					},
					throttle = {
						type = 'range',
						max = 5,
						min = 0,
						step = 0.1,
						name = L["節流閥"],
						desc = L["控制聲音警報的最小間隔"],
						order = 2,
					},
				},
			},
		}
	})
	self:AddOption('spell', {
		type = 'group',
		name = L["技能"],
		desc = L["技能選項"],
		set = setOption,
		get = getOption,
		order = 2,
		args = {
			spellGeneral = {
				type = 'group',
				name = L["技能模組控制"],
				desc = L["技能各個模組禁用選項"],
				inline = true,
				order = -1,
				args = {
					aruaApplied = {
						type = 'toggle',
						name = L["禁用敵方增益技能"],
						desc = L["勾選此選項以關閉敵方增益型技能通報"],
						order = 1,
					},
					aruaRemoved = {
						type = 'toggle',
						name = L["禁用敵方增益結束"],
						desc = L["勾選此選項以關閉敵方增益結束通報"],
						order = 2,
					},
					castStart = {
						type = 'toggle',
						name = L["禁用敵方讀條技能"],
						desc = L["勾選此選項以關閉敵方對友方讀條技能通報"],
						order = 3,
					},
					castSuccess = {
						type = 'toggle',
						name = L["禁用敵方特殊技能"],
						desc = L["勾選此選項以關閉敵方對友方特殊技能通報"],
						order = 4,
					},
					interrupt = {
						type = 'toggle',
						name = L["禁用友方打斷技能"],
						desc = L["勾選此選項以關閉友方對敵方打斷技能成功的通報"],
						order = 5,
					}
				},
			},
			spellAuraApplied = {
				type = 'group',
				--inline = true,
				name = L["敵方增益技能"],
				disabled = function() return gsadb.aruaApplied end,
				order = 1,
				args = {
					aonlyTF = {
						type = 'toggle',
						name = L["僅目標或關注目標"],
						desc = L["僅當該技能是你的目標或關注目標使用或增益出現在你的目標或關注目標身上才語音通報"],
						order = 1,
					},
					drinking = { 
						type = 'toggle',
						name = L["通報正在進食"],
						desc = L["在競技場中,通報敵方玩家正在進食"],
						order = 3,
					},
					--[[general = {
						type = 'group',
						inline = true,
						name = L["通用技能"],
						order = 4,
						args = listOption({42292,20594,7744},"auraApplied"),
					},]]
					druid = {
						type = 'group',
						inline = true,
						name = L["|cffFF7D0A德魯伊|r"],
						order = 5,
						args = listOption({61336,29166,22812,17116,16689,22842,5229,1850,50334,69369},"auraApplied"),	
					},
					paladin = {
						type = 'group',
						inline = true,
						name = L["|cffF58CBA聖騎士|r"],
						order = 6,
						args = listOption({31821,1022,1044,642,6940,54428,85696,31884},"auraApplied"),
					},
					rogue = {
						type = 'group',
						inline = true,
						name = L["|cffFFF569盜賊|r"],
						order = 7,
						args = listOption({51713,2983,31224,13750,5277,74001},"auraApplied"),
					},
					warrior	= {
						type = 'group',
						inline = true,
						name = L["|cffC79C6E戰士|r"],
						order = 8,
						args = listOption({55694,871,18499,20230,23920,12328,46924,85730,12292,1719},"auraApplied"),	
					},
					preist	= {
						type = 'group',
						inline = true,
						name = L["|cffFFFFFF牧師|r"],
						order = 9,
						args = listOption({33206,37274,6346,47585,89485,87153,87152,47788},"auraApplied"),
					},
					shaman	= {
						type = 'group',
						inline = true,
						name = L["|cff0070DE薩滿|r"],
						order = 10,
						args = listOption({30823,974,16188,52127,79206,16166},"auraApplied"),
					},
					mage = {
						type = 'group',
						inline = true,
						name = L["|cff69CCF0法師|r"],
						order = 11,
						args = listOption({45438,12042,12472},"auraApplied"),
					},
					dk	= {
						type = 'group',
						inline = true,
						name = L["|cffC41F3B死亡騎士|r"],
						order = 12,
						args = listOption({49039,48792,55233,49016,51271,48707},"auraApplied"),
					},
					hunter = {
						type = 'group',
						inline = true,
						name = L["|cffABD473獵人|r"],
						order = 13,
						args = listOption({34471,19263,3045,54216},"auraApplied"),
					},
				},
			},
			spellAuraRemoved = {
				type = 'group',
				--inline = true,
				name = L["敵方增益結束"],
				disabled = function() return gsadb.aruaRemoved end,
				order = 2,
				args = {
					ronlyTF = {
						type = 'toggle',
						name = L["僅目標或關注目標"],
						desc = L["僅當該技能是你的目標或關注目標使用或增益出現在你的目標或關注目標身上才語音通報"],
						order = 1,
					},
					paladin = {
						type = 'group',
						inline = true,
						name = L["|cffF58CBA聖騎士|r"],
						order = 4,
						args = listOption({1022,642},"auraRemoved"),
					},
					rogue = {
						type = 'group',
						inline = true,
						name = L["|cffFFF569盜賊|r"],
						order = 5,
						args = listOption({31224,5277,74001},"auraRemoved"),
					},
					warrior	= {
						type = 'group',
						inline = true,
						name = L["|cffC79C6E戰士|r"],
						order = 6,
						args = listOption({871},"auraRemoved"),
					},
					preist	= {
						type = 'group',
						inline = true,
						name = L["|cffFFFFFF牧師|r"],
						order = 7,
						args = listOption({33206,47585},"auraRemoved"),
					},
					mage = {
						type = 'group',
						inline = true,
						name = L["|cff69CCF0法師|r"],
						order = 9,
						args = listOption({45438},"auraRemoved"),
					},
					dk = {
						type = 'group',
						inline = true,
						name = L["|cffC41F3B死亡騎士|r"],
						order = 10,
						args = listOption({48792,49039},"auraRemoved"),
					},
					hunter = {
						type = 'group',
						inline = true,
						name = L["|cffABD473獵人|r"],
						order = 12,
						args = listOption({19263},"auraRemoved"),
					},
				},
			},
			spellCastStart = {
				type = 'group',
				--inline = true,
				name = L["敵方讀條技能"],
				disabled = function() return gsadb.castStart end,
				order = 2,
				args = {
					conlyTF = {
						type = 'toggle',
						name = L["僅目標或關注目標"],
						desc = L["僅當該技能是你的目標或關注目標使用或增益出現在你的目標或關注目標身上才語音通報"],
						order = 1,
					},
					general = {
						type = 'group',
						inline = true,
						name = L["通用技能"],
						order = 3,
						args = {
							bigHeal = {
								type = 'toggle',
								name = L["大型治療法術"],
								desc = L["強效治療術 神聖之光 強效治療波 治療之觸"],
								order = 1,
							},
							resurrection = {
								type = 'toggle',
								name = L["復活技能"],
								desc = L["復活術 救贖 先祖之魂 復活"],
								order = 2,
							},
						}
					},
					druid = {
						type = 'group',
						inline = true,
						name = L["|cffFF7D0A德魯伊|r"],
						order = 4,
						args = listOption({2637,33786},"castStart"),
					},
					preist	= {
						type = 'group',
						inline = true,
						name = L["|cffFFFFFF牧師|r"],
						order = 6,
						args = listOption({8129,9484,605},"castStart"),
					},
					shaman	= {
						type = 'group',
						inline = true,
						name = L["|cff0070DE薩滿|r"],
						order = 7,
						args = listOption({51514,76780},"castStart"),
					},
					mage = {
						type = 'group',
						inline = true,
						name = L["|cff69CCF0法師|r"],
						order = 8,
						args = listOption({118},"castStart"),
					},
					dk	= {
						type = 'group',
						inline = true,
						name = L["|cffC41F3B死亡騎士|r"],
						order = 9,
						args = listOption({49203},"castStart"),
					},
					hunter = {
						type = 'group',
						inline = true,
						name = L["|cffABD473獵人|r"],
						order = 10,
						args = listOption({982,1513},"castStart"),
					},
					warlock	= {
						type = 'group',
						inline = true,
						name = L["|cff9482C9術士|r"],
						order = 11,
						args = listOption({5782,5484,710,691},"castStart"),
					},
				},
			},
			spellCastSuccess = {
				type = 'group',
				--inline = true,
				name = L["敵方特殊技能"],
				disabled = function() return gsadb.castSuccess end,
				order = 3,
				args = {
					sonlyTF = {
						type = 'toggle',
						name = L["僅目標或關注目標"],
						desc = L["僅當該技能是你的目標或關注目標使用或增益出現在你的目標或關注目標身上才語音通報"],
						order = 1,
					},
					class = {
						type = 'toggle',
						name = L["徽章職業提示"],
						desc = L["在競技場中,通報徽章的同時提示使用徽章的職業"],
						disabled = function() return not gsadb.trinket end,
						order = 3,
					},
					general = {
						type = 'group',
						inline = true,
						name = L["通用技能"],
						order = 4,
						args = listOption({58984,20594,7744,42292},"castSuccess"),
					},
					druid = {
						type = 'group',
						inline = true,
						name = L["|cffFF7D0A德魯伊|r"],
						order = 5,
						args = listOption({80964,740,78675},"castSuccess"),
					},
					paladin = {
						type = 'group',
						inline = true,
						name = L["|cffF58CBA聖騎士|r"],
						order = 6,
						args = listOption({96231,20066,853},"castSuccess"),
					},
					rogue = {
						type = 'group',
						inline = true,
						name = L["|cffFFF569盜賊|r"],
						order = 7,
						args = listOption({51722,2094,1766,14185,1856,14177,76577,73981,79140},"castSuccess"),
					},
					warrior	= {
						type = 'group',
						inline = true,
						name = L["|cffC79C6E戰士|r"],
						order = 8,
						args = listOption({97462,676,5246,6552,85388,2457,71,2458},"castSuccess"),	
					},
					preist	= {
						type = 'group',
						inline = true,
						name = L["|cffFFFFFF牧師|r"],
						order = 9,
						args = listOption({8122,34433,64044,15487,64843,19236},"castSuccess"),
					},
					shaman	= {
						type = 'group',
						inline = true,
						name = L["|cff0070DE薩滿|r"],
						order = 10,
						args = listOption({8177,16190,8143,98008},"castSuccess"),
					},
					mage = {
						type = 'group',
						inline = true,
						name = L["|cff69CCF0法師|r"],
						order = 11,
						args = listOption({11958,44572,2139,66,12051,82676},"castSuccess"),
					},
					dk	= {
						type = 'group',
						inline = true,
						name = L["|cffC41F3B死亡騎士|r"],
						order = 12,
						args = listOption({47528,47476,47568,49206,77606},"castSuccess"),
					},
					hunter = {
						type = 'group',
						inline = true,
						name = L["|cffABD473獵人|r"],
						order = 110,
						args = listOption({19386,19503,34490,23989,60192,1499},"castSuccess"),
					},
					warlock = {
						type = 'group',
						inline = true,
						name = L["|cff9482C9術士|r"],
						order = 112,
						args = listOption({6789,5484,19647,48020,77801},"castSuccess"),
					},
				},
			},
			spellInterrupt = {
				type = 'group',
				--inline = true,
				name = L["友方打斷技能"],
				disabled = function() return gsadb.interrupt end,
				order = 4,
				args = {
					lockout = {
						type = 'toggle',
						name = L["友方打斷技能"],
						desc = L["法術封鎖 法術反制 腳踢 拳擊 心智冰封 碎顱猛擊 責難"],
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