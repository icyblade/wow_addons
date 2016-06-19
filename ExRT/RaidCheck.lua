local GlobalAddonName, ExRT = ...

local IsEncounterInProgress, GetTime = IsEncounterInProgress, GetTime

local VExRT = nil

local module = ExRT.mod:New("RaidCheck",ExRT.L.raidcheck,nil,true)
local ELib,L = ExRT.lib,ExRT.L

module.db.isEncounter = nil
module.db.tableFood = {
--Stamina,	Spirit,		Int,		Agi,		Str 		Crit		Haste		Mastery		MS		Versatility	Armor		Other
[160600]=50,	[160778]=50,							[160724]=50,	[160726]=50,	[160793]=50,	[160832]=50,	[160839]=50,	[160722]=50,
[160600]=75,	[160895]=75,							[160889]=75,	[160893]=75,	[160897]=75,	[160900]=75,	[160902]=75,	[160885]=75,	
[175784]=75,									[174062]=75,	[174079]=75,	[174077]=75,	[174080]=75,	[174078]=75,			--Blue food
										[175785]=75,
[160883]=100,									[175218]=100,	[175219]=100,	[175220]=100,	[175222]=100,	[175223]=100,
[165802]=100,
[180747]=125,									[180745]=125,	[180748]=125,	[180750]=125,	[180749]=125,	[180746]=125,

[188534]=125, --new food

										[225597]=600,	[225598]=600,	[225599]=600,			[225600]=600,			[225601]=600,
										[225602]=750,	[225603]=750,	[225604]=750,			[225605]=750,			[225606]=750,
}
module.db.StaminaFood = {[160600]=true,[175784]=true,[160883]=true,[165802]=true,[180747]=true}

module.db.tableFood_headers = ExRT.isLegionContent and {0,600,750} or {0,50,75,100,125}
module.db.tableFlask = {
	--Stamina,	Spirit,		Int,		Agi,		Str 
	[156077]=200,			[156070]=200,	[156073]=200,	[156071]=200,
	[156084]=250,			[156079]=250,	[156064]=250,	[156080]=250,
	
	[188035]=1300,			[188031]=1300,	[188033]=1300,	[188034]=1300,
}
module.db.tableFlask_headers = ExRT.isLegionContent and {0,1300} or {0,200,250}
module.db.tablePotion = {
	[105702]=true,	[156426]=true,			--Int
	[105697]=true,	[156423]=true,			--Agi	
	[105706]=true,	[156428]=true,			--Str
	[105709]=true,	[156436]=true,	[188017]=true,	--Mana 3k, 17k
	[105701]=true,	[156432]=true,	[188030]=true,	--Mana 4.5k, 25.5k
	[105707]=true,			[188024]=true,	--Run haste
	[105698]=true,	[156430]=true,	[188029]=true,	--Armor
	[105704]=true,	[156455]=true,	[188018]=true,	--Health + Mana [alchim]	
	[125282]=true,					--Kafa Boost
}
module.db.hsSpells = {
	[6262] = true,
	[105708] = true,
	[156438] = true,
	[188016] = true,
	[188018] = true,
}
module.db.potionList = {}
module.db.hsList = {}
module.db.tableFoodInProgress = nil
module.db.RaidCheckReadyCheckHide = nil
module.db.RaidCheckReadyCheckTime = nil
module.db.RaidCheckReadyCheckTable = {}
module.db.RaidCheckReadyPPLNum = 0
module.db.RaidCheckReadyCheckHideSchedule = nil

module.db.tableRunes = {
	[175456]=true,	--Agi
	[175457]=true,	--Int
	[175439]=true,	--Str
}

module.db.buffsList = {"STAMINA","STATS","MASTERY","CRIT","HASTE","MS","VERSA","SPD","AP"}
module.db.buffsNames = {
	STAMINA = RAID_BUFF_2 or "Stamina",
	STATS = RAID_BUFF_1 or "Stats",
	MASTERY = RAID_BUFF_7 or "Mastery",
	CRIT = RAID_BUFF_6 or "Crit",
	HASTE = RAID_BUFF_4 or "Haste",
	MS = RAID_BUFF_8 or "Ms",
	VERSA = RAID_BUFF_9 or "Versatility",
	SPD = RAID_BUFF_5 or "SPD",
	AP = RAID_BUFF_3 or "AP",
}

do
	local function SpellName(spellID)
		local name = GetSpellInfo(spellID)
		return name or "UNK BUFF NAME"
	end
	module.db.buffsSpells = {
		STAMINA={
			SpellName(21562),	-- Power Word: Fortitude
			SpellName(166928),	-- Blood Pact
			SpellName(469), 	-- Commanding Shout
			SpellName(90364),	-- Silithid, Qiraji Fortitude
			SpellName(50256),	-- Bear, Invigorating Roar
			SpellName(160014),	-- Goat, Sturdiness
			SpellName(160199),	-- Hunter, level 100
		},
		STATS={
			SpellName(20217),	-- Blessing of Kings
			SpellName(1126),	-- Mark of the Wild
			SpellName(116781),	-- Legacy of the White Tiger
			SpellName(115921),	-- Legacy of the Emperor
			SpellName(90363),	-- Shale Spider, Embrace of the Shale Spider
			SpellName(159988),	-- Dog, Bark of the Wild
			SpellName(160017),	-- Gorilla, Blessing of Kongs
			SpellName(160077),	-- Worm, Strength of the Earth
			SpellName(160206),	-- Hunter, level 100
		},
		MASTERY={
			SpellName(19740),	-- Blessing of Might
			SpellName(155522),	-- Power of the Grave
			SpellName(116956),	-- Grace of Air
			SpellName(24907),	-- Moonkin Aura
			SpellName(93435),	-- Cat, Roar of Courage
			SpellName(128997),	-- Spirit Beast, Spirit Beast Blessing
			SpellName(160073),	-- Tallstrider, Plainswalking
			SpellName(160039),	-- Hydra, Keen Senses
			SpellName(160198),	-- Hunter, level 100
		},
		CRIT={
			SpellName(116781),	-- Legacy of the White Tiger
			SpellName(17007),	-- Leader of the Pack
			SpellName(1459),	-- Arcane Brilliance
			SpellName(61316),	-- Dalaran Brilliance
			SpellName(24604),	-- Wolf, Furious Howl
			SpellName(90309),	-- Devilsaur, Terrifying Roar
			SpellName(126373),	-- Quilen, Fearless Roar
			SpellName(126309),	-- Water Strider, Still Water
			SpellName(90363),	-- Shale Spider, Embrace of the Shale Spider
			SpellName(160052),	-- Raptor, Strength of the Pack
			SpellName(160200),	-- Hunter, level 100
			SpellName(128997),	-- Spirit Beast Blessing
		},
		HASTE={
			SpellName(55610),	-- Unholy Aura
			SpellName(116956),	-- Grace of Air
			SpellName(49868),	-- Mind Quickening
			SpellName(113742),	-- Swiftblade's Cunning
			SpellName(135678),	-- Sporebat, Energizing Spores
			SpellName(128432),	-- Hyena, Cackling Howl
			SpellName(160074),	-- Wasp, Speed of the Swarm
			SpellName(160203),	-- Hunter, level 100
		},
		MS={
			SpellName(166916),	-- Windflurry
			SpellName(49868),	-- Mind Quickening
			SpellName(113742),	-- Swiftblade's Cunning
			SpellName(109773),	-- Dark Intent
			SpellName(50519),	-- Bat, Sonic Focus
			SpellName(159736), 	-- Chimaera, Duality
			SpellName(57386),	-- Clefthoof, Wild Strength
			SpellName(58604),	-- Core Hound, Double Bite
			SpellName(34889),	-- Dragonhawk, Spry Attacks
			SpellName(24844),	-- Wind Serpent, Breath of the Winds
			SpellName(172968),	-- Hunter, level 100
		},
		VERSA={
			SpellName(167187),	-- Sanctity Aura
			SpellName(167188),	-- Inspiring Presence
			SpellName(55610),	-- Unholy Aura
			SpellName(1126),	-- Mark of the Wild
			SpellName(159735),	-- Bird of Prey, Tenacity
			SpellName(35290),	-- Boar, Indomitable
			SpellName(57386),	-- Clefthoof, Wild Strength
			SpellName(160045),	-- Porcupine, Defensive Quills
			SpellName(50518),	-- Ravager, Chitinous Armor
			SpellName(160077),	-- Worm, Strength of the Earth
			SpellName(172967),	-- Hunter, level 100
		},
		SPD={
			SpellName(1459),	-- Arcane Brilliance
			SpellName(61316),	-- Dalaran Brilliance
			SpellName(109773),	-- Dark Intent
			SpellName(126309),	-- Water Strider, Still Water
			SpellName(90364),	-- Silithid, Qiraji Fortitude
			SpellName(128433),	-- Serpent, Serpent's Cunning
			SpellName(160205),	-- Hunter, level 100
		},
		AP={
			SpellName(19506),	-- Trueshot Aura
			SpellName(6673),	-- Battle Shout
			SpellName(57330),	-- Horn of Winter
		},
	}
end

local IsSendFoodByMe,IsSendFlaskByMe,IsSendRunesByMe,IsSendBuffsByMe = nil

local function GetPotion(arg1)
	local h = L.raidcheckPotion
	local t = {}
	for key,val in pairs(module.db.potionList) do
		t[#t+1] = {key,val}
	end

	local function toChat(h)
		local chat_type = ExRT.F.chatType(true)
		if arg1 == 2 then print(h) end
		if arg1 == 1 then SendChatMessage(h,chat_type) end  
	end

	table.sort(t,function(a,b) return a[2]>b[2] end)
	for i=1,#t do
		h = h .. format("%s %d%s",t[i][1],t[i][2],i<#t and ", " or "")
		if #h > 230 then
			toChat(h)
			h = ""
		end
	end
	toChat(h)
end

local function GetHs(arg1)
	local h = L.raidcheckHS
	local t = {}
	for key,val in pairs(module.db.hsList) do
		t[#t+1] = {key,val}
	end

	local function toChat(h)
		local chat_type = ExRT.F.chatType(true)
		if arg1 == 2 then print(h) end
		if arg1 == 1 then SendChatMessage(h,chat_type) end
	end

	table.sort(t,function(a,b) return a[2]>b[2] end)
	for i=1,#t do
		h = h .. format("%s %d%s",t[i][1],t[i][2],i<#t and ", " or "")
		if #h > 230 then
			toChat(h)
			h = ""
		end
	end
	toChat(h)
end

--[[
	Check Types:
	
	1 - to chat
	2 - ready check
	3 - ready check (self)
	nil - self
]]

local function PublicResults(msg,chat_type)
	if msg == "" or not msg then
		return
	elseif chat_type then
		msg = msg:gsub("|c........","")
		msg = msg:gsub("|r","")
	
		chat_type = ExRT.F.chatType(true)
		SendChatMessage(msg,chat_type)
	else
		print(msg)
	end
end


local function GetRunes(checkType)
	local f = {[0]={},[50]={}}
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local isAnyBuff = nil
			for i=1,40 do
				local _,_,_,_,_,_,_,_,_,_,spellId = UnitAura(name, i,"HELPFUL")
				if not spellId then
					break
				else
					local isRune = module.db.tableRunes[spellId]
					if isRune then
						f[50][ #f[50]+1 ] = name
						isAnyBuff = true
					end
				end
			end
			if not isAnyBuff then
				f[0][ #f[0]+1 ] = name
			end
		end
	end
	
	if not checkType or checkType == 1 then
		for _,stats in ipairs({0,50}) do
			local result = format("|cff00ff00%d (%d):|r ",stats,#f[stats])
			for i=1,#f[stats] do
				result = result .. f[stats][i]
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				elseif i ~= #f[stats] then
					result = result .. ", "
				end
			end
			PublicResults(result,checkType)
		end
	elseif checkType == 2 or checkType == 3 then
		if checkType == 3 then
			checkType = nil
		end
		local result = format("|cff00ff00%s (%d):|r ",L.RaidCheckNoRunes,#f[0])
		for i=1,#f[0] do
			result = result .. f[0][i]
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			elseif i ~= #f[0] then
				result = result .. ", "
			end
		end
		PublicResults(result,checkType)
	end
end

local function GetFood(checkType)
	local f = {[0]={}}
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local isAnyBuff = nil
			for i=1,40 do
				local _,spellId,stats
				if ExRT.is7 then
					_,_,_,_,_,_,_,_,_,_,spellId,_,_,_,_,stats = UnitAura(name, i,"HELPFUL")
				else
					_,_,_,_,_,_,_,_,_,_,spellId,_,_,_,stats = UnitAura(name, i,"HELPFUL")
				end
				if not spellId then
					break
				else
					local foodType = module.db.tableFood[spellId]
					if foodType then
						local _,unitRace = UnitRace(name)
						
						if unitRace == "Pandaren" and stats then
							stats = stats / 2
						end
						if module.db.StaminaFood[spellId] and stats then
							stats = ceil( stats / 1.5 )
						end
						stats = stats or foodType
						if spellId == 188534 then stats = 125 end
					
						f[stats] = f[stats] or {}
						f[stats][ #f[stats]+1 ] = name
						if ExRT.F.table_find(module.db.tableFood_headers,stats) then
							isAnyBuff = true
						end
					end
				end
			end
			if not isAnyBuff then
				f[0][ #f[0]+1 ] = name
			end
		end
	end
	
	if not checkType or checkType == 1 then
		for _,foodType in ipairs(module.db.tableFood_headers) do
			f[foodType] = f[foodType] or {}
			local result = format("|cff00ff00%d (%d):|r ",foodType,#f[foodType])
			for j=1,#f[foodType] do
				result = result .. f[foodType][j] .. (j < #f[foodType] and ", " or "")
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				end
			end
			PublicResults(result,checkType)
		end
	elseif checkType == 2 or checkType == 3 then
		if checkType == 3 then
			checkType = nil
		end
		local counter,counterResult = 0,0
		local badStats = {}
		for statsNum,data in pairs(f) do
			if ((VExRT.RaidCheck.FoodMinLevel and statsNum < VExRT.RaidCheck.FoodMinLevel) or (not VExRT.RaidCheck.FoodMinLevel and statsNum == 0)) and #data > 0 then
				badStats[#badStats + 1] = statsNum
				counter = counter + #data
			end
		end
		sort(badStats)
		local result = format("|cff00ff00%s (%d):|r ",L.raidchecknofood,counter)
		for i=1,#badStats do
			local statsNum = badStats[i]
			for j=1,#f[statsNum] do
				counterResult = counterResult + 1
				result = result .. f[statsNum][j].. (statsNum ~= 0 and "("..statsNum..")" or "") .. (counterResult < counter and ", " or "")
				if #result > 220 then
					PublicResults(result,checkType)
					result = ""
				end
			end
		end
		PublicResults(result,checkType)
	end
end

local function GetFlask(checkType)
	local f = {[0]={}}
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	local _time = GetTime()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local isAnyBuff = nil
			for i=1,40 do
				local _,_,_,_,_,_,expires,_,_,_,spellId = UnitAura(name, i,"HELPFUL")
				if not spellId then
					break
				else
					local flaskType = module.db.tableFlask[spellId]
					if flaskType then
						f[flaskType] = f[flaskType] or {}
						expires = expires or -1
						local lost = expires-_time
						if expires == 0 or lost < 0 then
							lost = 901
						end
						f[flaskType][ #f[flaskType]+1 ] = {name,lost}
						if ExRT.F.table_find(module.db.tableFlask_headers,flaskType) then
							isAnyBuff = true
						end
					end
				end
			end
			if not isAnyBuff then
				f[0][ #f[0]+1 ] = {name,901}
			end
		end
	end
	for flaskType,typeData in pairs(f) do
		table.sort(typeData,function(a,b) return a[2]<b[2] end)
	end
	
	local showExpFlasks_seconds = VExRT.RaidCheck.FlaskExp == 1 and 300 or VExRT.RaidCheck.FlaskExp == 2 and 600 or -1
	
	if not checkType or checkType == 1 then
		for i=1,#module.db.tableFlask_headers do
			local flaskStats = module.db.tableFlask_headers[i]
			f[ flaskStats ] = f[ flaskStats ] or {}
			local result = format("|cff00ff00%d (%d):|r ",flaskStats,#f[ flaskStats ])
			for j=1,#f[ flaskStats ] do
				result = result .. format("%s%s",f[ flaskStats ][j][1] or "?", j < #f[ flaskStats ] and ", " or "")
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				end
			end
			PublicResults(result,checkType)
		end
	elseif checkType == 2 or checkType == 3 then
		if checkType == 3 then
			checkType = nil
		end
		f[0] = f[0] or {}
		local result = format("|cff00ff00%s (%d):|r ",L.raidchecknoflask,#f[0])
		for j=1,#f[0] do
			result = result .. format("%s%s",f[0][j][1] or "?",j < #f[0] and ", " or "")
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			end
		end
		local strings_list = {}
		for i=1,#module.db.tableFlask_headers do
			local flaskStats = module.db.tableFlask_headers[i]
			if flaskStats ~= 0 then
				f[ flaskStats ] = f[ flaskStats ] or {}
				for j=1,#f[ flaskStats ] do
					if f[ flaskStats ][j][2] <= showExpFlasks_seconds and f[ flaskStats ][j][2] >= 0 then
						local mins = floor( f[ flaskStats ][j][2] / 60 )
						strings_list[#strings_list + 1] = format("%s%s",f[ flaskStats ][j][1] or "?", "("..(mins == 0 and "<1" or tostring(mins))..")")
					end
				end
			end
		end
		local strings_list_len = #strings_list
		if strings_list_len > 0 then
			result = result .. ( #f[0] > 0 and result ~= "" and ", " or "" )
		end
		for i=1,strings_list_len do
			result = result .. strings_list[i] .. (i < strings_list_len and ", " or "")
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			end
		end
		PublicResults(result,checkType)
	end
end

local function GetRaidBuffs(checkType)
	if ExRT.is7 then return end
	local f = {}
	for i=1,#module.db.buffsList do f[i]={} end
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	for i=1,40 do
		local name,_,subgroup,_,_,_,_,online,isDead = GetRaidRosterInfo(i)
		if name and subgroup <= gMax and online and not isDead then
			for j=1,#module.db.buffsList do
				local isAnyBuff = nil
				for k,buffName in pairs(module.db.buffsSpells[ module.db.buffsList[j] ]) do
					if buffName then
						local auraExists = UnitAura(name, buffName)
						if auraExists then
							isAnyBuff = true
							break
						end
					end
				end
				if not isAnyBuff then
					f[j][ #f[j]+1 ] = name
				end
			end
		end
	end

	if not checkType or checkType == 1 then
		for i=1,#f do
			local result = format("|cff00ff00%s (%d):|r ",module.db.buffsNames[ module.db.buffsList[i] ],#f[i])
			for j=1,#f[i] do
				result = result .. format("%s%s",f[i][j] or "?", j < #f[i] and ", " or "")
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				end
			end
			PublicResults(result,checkType)
		end
	elseif checkType == 2 or checkType == 3 then
		if checkType == 3 then
			checkType = nil
		end
		local missingCount = 0
		for i=1,#f do
			if #f[i] > 0 then
				missingCount = missingCount + 1
			end
		end
		local result = format("|cff00ff00%s (%d):|r ",L.RaidCheckNoBuffs,missingCount)
		local missingNow = 0
		for i=1,#f do
			if #f[i] > 0 then
				missingNow = missingNow + 1
				result = result .. module.db.buffsNames[ module.db.buffsList[i] ] .. (missingNow < missingCount and ", " or "")
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				end
			end
		end
		PublicResults(result,checkType)
	end
end


function module.options:Load()
	self:CreateTilte()

	self.food = ELib:Button(self,L.raidcheckfood):Size(230,20):Point(5,-30):OnClick(function() GetFood() end)
	self.food.txt = ELib:Text(self,"/rt food",11):Size(100,20):Point("LEFT",self.food,"RIGHT",5,0)
	
	self.foodToChat = ELib:Button(self,L.raidcheckfoodchat):Size(230,20):Point("LEFT",self.food,"RIGHT",71,0):OnClick(function() GetFood(1) end)
	self.foodToChat.txt = ELib:Text(self,"/rt foodchat",11):Size(100,20):Point("LEFT",self.foodToChat,"RIGHT",5,0)

	self.flask = ELib:Button(self,L.raidcheckflask):Size(230,20):Point(5,-55):OnClick(function() GetFlask() end)
	self.flask.txt = ELib:Text(self,"/rt flask",11):Size(100,20):Point("LEFT",self.flask,"RIGHT",5,0)
	
	self.flaskToChat = ELib:Button(self,L.raidcheckflaskchat):Size(230,20):Point("LEFT",self.flask,"RIGHT",71,0):OnClick(function() GetFlask(1) end)
	self.flaskToChat.txt = ELib:Text(self,"/rt flaskchat",11):Size(100,20):Point("LEFT",self.flaskToChat,"RIGHT",5,0)
	
	self.runes = ELib:Button(self,L.RaidCheckRunesCheck):Size(230,20):Point(5,-80):OnClick(function() GetRunes() end)
	self.runes.txt = ELib:Text(self,"/rt check runes",11):Size(60,22):Point("LEFT",self.runes,"RIGHT",5,0)
	
	self.runesToChat = ELib:Button(self,L.RaidCheckRunesChat):Size(230,20):Point("LEFT",self.runes,"RIGHT",71,0):OnClick(function() GetRunes(1) end)
	self.runesToChat.txt = ELib:Text(self,"/rt check runeschat",11):Size(100,22):Point("LEFT",self.runesToChat,"RIGHT",5,0)
	
	self.buffs = ELib:Button(self,L.RaidCheckBuffs):Size(230,20):Point(5,-105):OnClick(function() GetRaidBuffs() end)
	self.buffs.txt = ELib:Text(self,"/rt check buffs",11):Size(60,22):Point("LEFT",self.buffs,"RIGHT",5,0)
	
	self.buffsToChat = ELib:Button(self,L.RaidCheckBuffsToChat):Size(230,20):Point("LEFT",self.buffs,"RIGHT",71,0):OnClick(function() GetRaidBuffs(1) end)
	self.buffsToChat.txt = ELib:Text(self,"/rt check buffschat",11):Size(100,22):Point("LEFT",self.buffsToChat,"RIGHT",5,0)

	self.chkSlak = ELib:Check(self,L.raidcheckslak,VExRT.RaidCheck.ReadyCheck):Point(7,-130):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.ReadyCheck = true
			module:RegisterEvents('READY_CHECK')
		else
			VExRT.RaidCheck.ReadyCheck = nil
			if not VExRT.RaidCheck.ReadyCheckFrame then
				module:UnregisterEvents('READY_CHECK')
			end
		end
	end)
	
	self.chkOnAttack = ELib:Check(self,L.RaidCheckOnAttack,VExRT.RaidCheck.OnAttack):Point("TOPLEFT",self.chkSlak,"TOPLEFT",25,-25):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.OnAttack = true
		else
			VExRT.RaidCheck.OnAttack = nil
		end
	end)
	
	self.chkSendSelf = ELib:Check(self,L.RaidCheckSendSelf,VExRT.RaidCheck.SendSelf):Point("TOPLEFT",self.chkOnAttack,"TOPLEFT",0,-25):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.SendSelf = true
		else
			VExRT.RaidCheck.SendSelf = nil
		end
	end)
	
	self.disableLFR = ELib:Check(self,L.RaidCheckDisableInLFR,VExRT.RaidCheck.disableLFR):Point("TOPLEFT",self.chkSendSelf,"TOPLEFT",0,-25):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.disableLFR = true
		else
			VExRT.RaidCheck.disableLFR = nil
		end
	end)
	
	self.chkRunes = ELib:Check(self,L.RaidCheckRunesEnable,VExRT.RaidCheck.RunesCheck):Point(7,-230):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.RunesCheck = true
		else
			VExRT.RaidCheck.RunesCheck = nil
		end
	end)
	
	self.chkBuffs = ELib:Check(self,L.RaidCheckBuffsEnable,VExRT.RaidCheck.BuffsCheck):Point(7,-255):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.BuffsCheck = true
		else
			VExRT.RaidCheck.BuffsCheck = nil
		end
	end)
	
	self.minFoodLevelText = ELib:Text(self,L.RaidCheckMinFoodLevel,11):Point("TOPLEFT",self.chkBuffs,"TOPLEFT",3,-23):Size(0,25)

	self.minFoodLevelAny = ELib:Radio(self,L.RaidCheckMinFoodLevelAny,not VExRT.RaidCheck.FoodMinLevel):Point("LEFT",self.minFoodLevelText,"RIGHT", 15, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFoodLevel100:SetChecked(false)
		module.options.minFoodLevel125:SetChecked(false)
		VExRT.RaidCheck.FoodMinLevel = nil
	end)

	
	self.minFoodLevel100 = ELib:Radio(self,"100",VExRT.RaidCheck.FoodMinLevel == 100):Point("LEFT",self.minFoodLevelAny,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFoodLevelAny:SetChecked(false)
		module.options.minFoodLevel125:SetChecked(false)
		VExRT.RaidCheck.FoodMinLevel = 100
	end)
	
	self.minFoodLevel125 = ELib:Radio(self,"125",VExRT.RaidCheck.FoodMinLevel == 125):Point("LEFT",self.minFoodLevel100,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFoodLevelAny:SetChecked(false)
		module.options.minFoodLevel100:SetChecked(false)
		VExRT.RaidCheck.FoodMinLevel = 125
	end)
	
	
	self.minFlaskExpText = ELib:Text(self,L.RaidCheckMinFlaskExp,11):Point("TOPLEFT",self.minFoodLevelText,"TOPLEFT",0,-22):Size(0,25)
	
	self.minFlaskExpNo = ELib:Radio(self,L.RaidCheckMinFlaskExpNo,VExRT.RaidCheck.FlaskExp == 0):Point("LEFT",self.minFlaskExpText,"RIGHT", 15, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFlaskExp5min:SetChecked(false)
		module.options.minFlaskExp10min:SetChecked(false)
		VExRT.RaidCheck.FlaskExp = 0
	end)
	
	self.minFlaskExp5min = ELib:Radio(self,"5 "..L.RaidCheckMinFlaskExpMin,VExRT.RaidCheck.FlaskExp == 1):Point("LEFT",self.minFlaskExpNo,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFlaskExpNo:SetChecked(false)
		module.options.minFlaskExp10min:SetChecked(false)
		VExRT.RaidCheck.FlaskExp = 1
	end)

	self.minFlaskExp10min = ELib:Radio(self,"10 "..L.RaidCheckMinFlaskExpMin,VExRT.RaidCheck.FlaskExp == 2):Point("LEFT",self.minFlaskExp5min,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFlaskExpNo:SetChecked(false)
		module.options.minFlaskExp5min:SetChecked(false)
		VExRT.RaidCheck.FlaskExp = 2
	end)

	
	self.chkPotion = ELib:Check(self,L.raidcheckPotionCheck,VExRT.RaidCheck.PotionCheck):Point(7,-325):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.PotionCheck = true
			module.options.potionToChat:Enable()
			module.options.potion:Enable()
			module.options.hs:Enable()
			module.options.hsToChat:Enable()
		else
			VExRT.RaidCheck.PotionCheck = nil
			module.options.potionToChat:Disable()
			module.options.potion:Disable()
			module.options.hs:Disable()
			module.options.hsToChat:Disable()
		end
	end)

	self.potion = ELib:Button(self,L.raidcheckPotionLastPull):Size(230,20):Point("TOPLEFT",self.chkPotion,"TOPLEFT",-2,-30):OnClick(function() GetPotion(2) end):Run(function(s,a) if a then s:Disable() end end,not VExRT.RaidCheck.PotionCheck)
	self.potion.txt = ELib:Text(self,"/rt potion",11):Size(100,20):Point("LEFT",self.potion,"RIGHT",5,0)

	self.potionToChat = ELib:Button(self,L.raidcheckPotionLastPullToChat):Size(230,20):Point("LEFT",self.potion,"RIGHT",71,0):OnClick(function() GetPotion(1) end):Run(function(s,a) if a then s:Disable() end end,not VExRT.RaidCheck.PotionCheck)
	self.potionToChat.txt = ELib:Text(self,"/rt potionchat",11):Size(100,20):Point("LEFT",self.potionToChat,"RIGHT",5,0)

	self.hs = ELib:Button(self,L.raidcheckHSLastPull):Size(230,20):Point("TOPLEFT",self.potion,"TOPLEFT",0,-25):OnClick(function() GetHs(2) end):Run(function(s,a) if a then s:Disable() end end,not VExRT.RaidCheck.PotionCheck)
	
	self.hsToChat = ELib:Button(self,L.raidcheckHSLastPullToChat):Size(230,20):Point("LEFT",self.hs,"RIGHT",71,0):OnClick(function() GetHs(1) end):Run(function(s,a) if a then s:Disable() end end,not VExRT.RaidCheck.PotionCheck)
	
	self.optReadyCheckFrame = CreateFrame("Frame",nil,self)
	self.optReadyCheckFrame:SetSize(650,125)
	self.optReadyCheckFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8})
	self.optReadyCheckFrame:SetBackdropColor(0,0,0,0.3)
	self.optReadyCheckFrame:SetBackdropBorderColor(.24,.25,.30,0)
	ELib:Border(self.optReadyCheckFrame,2,.24,.25,.30,1)
	self.optReadyCheckFrame:SetPoint("TOP",0,-430)

	self.optReadyCheckFrameHeader = ELib:Text(self.optReadyCheckFrame,L.raidcheckReadyCheck):Size(550,20):Point("BOTTOMLEFT",self.optReadyCheckFrame,"TOPLEFT",10,1):Bottom()

	self.chkReadyCheckFrameEnable = ELib:Check(self.optReadyCheckFrame,L.senable,VExRT.RaidCheck.ReadyCheckFrame):Point(15,-10):OnClick(function(self) 
		if self:GetChecked() then
			module:RegisterEvents('READY_CHECK','READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
			VExRT.RaidCheck.ReadyCheckFrame = true
		else
			module:UnregisterEvents('READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
			if not VExRT.RaidCheck.ReadyCheck then
				module:UnregisterEvents('READY_CHECK')
			end
			VExRT.RaidCheck.ReadyCheckFrame = nil
		end
	end)

	self.chkReadyCheckFrameSliderScale = ELib:Slider(self.optReadyCheckFrame,L.raidcheckReadyCheckScale):Size(250):Point(25,-50):Range(5,200):SetTo(VExRT.RaidCheck.ReadyCheckFrameScale or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.RaidCheck.ReadyCheckFrameScale = event
		ExRT.F.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.chkReadyCheckFrameButTest = ELib:Button(self.optReadyCheckFrame,L.raidcheckReadyCheckTest):Size(280,22):Point(310,-10):OnClick(function(self) 
		module.main:READY_CHECK("raid1",35,"TEST")
		for i=2,25 do
			local y = math.random(1,30000)
			local r = math.random(1,2)
			ExRT.F.ScheduleTimer(function() module.main:READY_CHECK_CONFIRM("raid"..i,r==1,"TEST") end, y/1000)
		end
	end)

	self.chkReadyCheckFrameHtmlTimer = ELib:Text(self.optReadyCheckFrame,L.raidcheckReadyCheckTimerTooltip,11):Size(200,24):Point(310,-50)

	self.chkReadyCheckFrameEditBoxTimer = ELib:Edit(self.optReadyCheckFrame,6,true):Size(50,20):Point(515,-50):Text(VExRT.RaidCheck.ReadyCheckFrameTimerFade or "4"):OnChange(function(self)
		VExRT.RaidCheck.ReadyCheckFrameTimerFade = tonumber(self:GetText()) or 4
		if VExRT.RaidCheck.ReadyCheckFrameTimerFade < 2.5 then VExRT.RaidCheck.ReadyCheckFrameTimerFade = 2.5 end
	end) 
	
	self.htmlReadyCheck1 = ELib:Text(self.optReadyCheckFrame,L.RaidCheckReadyCheckHelp,12):Size(583,100):Point(10,-90):Top()

	self:SetScript("OnShow",nil)
end

local function CheckPotionsOnPull()
	table.wipe(module.db.potionList)
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local b = nil
			for i=1,40 do
				local _,_,_,_,_,_,_,_,_,_,spellId = UnitAura(name, i,"HELPFUL")
				if not spellId then
					break
				elseif module.db.tablePotion[spellId] then
					module.db.potionList[name] = 1
					b = true
				end
			end
			if not b then
				module.db.potionList[name] = 0
			end
		end
	end
end

function module:timer(elapsed)
	if VExRT.RaidCheck.PotionCheck then
		if not module.db.isEncounter and IsEncounterInProgress() then
			module.db.isEncounter = true

			ExRT.F.ScheduleTimer(CheckPotionsOnPull,1.5)
			
			table.wipe(module.db.hsList)
			local gMax = ExRT.F.GetRaidDiffMaxGroup()
			for j=1,40 do
				local name,_,subgroup = GetRaidRosterInfo(j)
				if name and subgroup <= gMax then
					module.db.hsList[name] = 0
				end
			end
			
			module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		elseif module.db.isEncounter and not IsEncounterInProgress() then
			module.db.isEncounter = nil
			
			module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		end
	end
	if VExRT.RaidCheck.ReadyCheckFrame and module.db.RaidCheckReadyCheckHide then
		module.db.RaidCheckReadyCheckHide = module.db.RaidCheckReadyCheckHide - elapsed
		if module.db.RaidCheckReadyCheckHide < 2 and not module.frame.anim:IsPlaying() then
			module.frame.anim:Play()
		end
		if module.db.RaidCheckReadyCheckHide < 0 then
			module.db.RaidCheckReadyCheckHide = nil
		end
	end
	if VExRT.RaidCheck.ReadyCheckFrame and module.frame:IsShown() then
		local h = ""
		local ctime_ = module.db.RaidCheckReadyCheckTime - GetTime()
		if ctime_ > 0 then 
			h = format(" (%d %s)",ctime_+1,L.raidcheckReadyCheckSec) 
		end
		module.frame.headText:SetText(L.raidcheckReadyCheck..h)
	end
end

function module:slash(arg)
	if arg == "food" then
		GetFood()
	elseif arg == "flask" then
		GetFlask()
	elseif arg == "foodchat" then
		GetFood(1)
	elseif arg == "flaskchat" then
		GetFlask(1)
	elseif arg == "potion" and VExRT.RaidCheck.PotionCheck then
		GetPotion(2)
	elseif arg == "potionchat" and VExRT.RaidCheck.PotionCheck then
		GetPotion(1)
	elseif arg == "check runes" then
		GetRunes()
	elseif arg == "check runeschat" then
		GetRunes(1)
	elseif arg == "check buffs" then
		GetRaidBuffs()
	elseif arg == "check buffschat" then
		GetRaidBuffs(1)
	end
end

module.frame = ELib:Template("ExRTDialogModernTemplate",UIParent)
module.frame:SetSize(140*2+20,18*13+40)
module.frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
module.frame:SetFrameStrata("TOOLTIP")
module.frame:EnableMouse(true)
module.frame:SetMovable(true)
module.frame:RegisterForDrag("LeftButton")
module.frame:SetScript("OnDragStart", function(self) 
	self:StartMoving()
end)
module.frame:SetScript("OnDragStop", function(self) 
	self:StopMovingOrSizing()
	VExRT.RaidCheck.ReadyCheckLeft = self:GetLeft()
	VExRT.RaidCheck.ReadyCheckTop = self:GetTop()
end)
module.frame:Hide()
--module.frame.headText = ExRT.lib.CreateText(module.frame,290,18,nil,15,-7,nil,nil,ExRT.F.defFont,14,L.raidcheckReadyCheck,nil,1,1,1,1)
module.frame.border = ExRT.lib.CreateShadow(module.frame,20)
module.frame.headText = module.frame.title

module.frame.anim = module.frame:CreateAnimationGroup()
module.frame.timer = module.frame.anim:CreateAnimation()
module.frame.timer:SetScript("OnFinished", function() 
	module.frame.anim:Stop() 
	module.frame:Hide() 
end)
module.frame.timer:SetDuration(2)
module.frame.timer:SetScript("OnUpdate", function(self,elapsed) 
	module.frame:SetAlpha(1-self:GetProgress())
end)
module.frame:SetScript("OnHide", function(self) 
	module.frame.anim:Stop()
end)

module.frame.u = {}
for i=1,40 do
	local line = CreateFrame("FRAME",nil,module.frame)
	module.frame.u[i] = line
	line:SetPoint("TOPLEFT", ((i-1)%2)*140+10, -floor((i-1)/2)*18-25)
	line:SetSize(140,18)

	line.t = ELib:Text(line,"raid"..i):Size(120,18):Point(20,0):Font(ExRT.F.defFont,12):Color():Shadow()
	line.icon = ELib:Icon(line,"Interface\\RaidFrame\\ReadyCheck-Waiting",18):Point(0,0)
end

local function RaidCheckReadyCheckReset(starter,isTest)
	table.wipe(module.db.RaidCheckReadyCheckTable)
	local j = 0
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	module.db.RaidCheckReadyPPLNum = 0
	module.frame:SetHeight(18*ceil(gMax*5/2)+30)
	for i=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(i)
		if isTest then
			name = format("%s%d","raid",i)
			subgroup = i / 5
		end
		if name and subgroup <= gMax then 
			j = j + 1
			if j > 40 then break end
			module.frame.u[j].t:SetText(name)
			module.frame.u[j].t:SetTextColor(1,1,1,1)
			module.frame.u[j].icon.texture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Waiting")
			module.frame.u[j]:Show()

			module.db.RaidCheckReadyPPLNum = module.db.RaidCheckReadyPPLNum + 1
			module.db.RaidCheckReadyCheckTable[ExRT.F.delUnitNameServer(name)] = j
		end
	end
	for i=(j+1),40 do
		module.frame.u[i]:Hide()
	end
	module.frame.anim:Stop()
	module.frame:SetAlpha(1)
	module.frame:Show()
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.RaidCheck = VExRT.RaidCheck or {}
	
	VExRT.RaidCheck.FlaskExp = VExRT.RaidCheck.FlaskExp or 1

	if VExRT.RaidCheck.ReadyCheckLeft and VExRT.RaidCheck.ReadyCheckTop then
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.RaidCheck.ReadyCheckLeft,VExRT.RaidCheck.ReadyCheckTop) 
	end
	if VExRT.RaidCheck.ReadyCheckFrameScale then
		module.frame:SetScale(VExRT.RaidCheck.ReadyCheckFrameScale/100)
	end
	VExRT.RaidCheck.ReadyCheckFrameTimerFade = VExRT.RaidCheck.ReadyCheckFrameTimerFade or 4
	
	module.db.tableFoodInProgress = GetSpellInfo(104934)
	
	if VExRT.RaidCheck.ReadyCheckFrame then
		module:RegisterEvents('READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
	end
	if VExRT.RaidCheck.ReadyCheck or VExRT.RaidCheck.ReadyCheckFrame then
		module:RegisterEvents('READY_CHECK')	
	end
	if VExRT.RaidCheck.PotionCheck then
		--module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
	end
	
	module:RegisterSlash()
	module:RegisterTimer()
	module:RegisterAddonMessage()
end

local function SendDataToChat()
	if IsSendFoodByMe then
		GetFood(2)
	end
	if IsSendFlaskByMe then
		GetFlask(2)
	end
	if IsSendRunesByMe then
		GetRunes(2)
	end
	if IsSendBuffsByMe then
		GetRaidBuffs(2)
	end
	IsSendFoodByMe = nil
	IsSendFlaskByMe = nil
	IsSendRunesByMe = nil
	IsSendBuffsByMe = nil
end

local function PrepareDataToChat(toSelf)
	if toSelf then
		GetFood(3)
		GetFlask(3)
		if VExRT.RaidCheck.RunesCheck then
			GetRunes(3)
		end
		if VExRT.RaidCheck.BuffsCheck then
			GetRaidBuffs(3)
		end
	else
		if VExRT.RaidCheck.disableLFR then
			local _,_,difficulty = GetInstanceInfo()
			if difficulty == 7 or difficulty == 17 then
				return
			end
		end
		IsSendFoodByMe = true
		ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","FOOD")
		IsSendFlaskByMe = true
		ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","FLASK")
		IsSendRunesByMe = nil
		if VExRT.RaidCheck.RunesCheck then
			IsSendRunesByMe = true
			ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","RUNES")
		end
		IsSendBuffsByMe = nil
		if VExRT.RaidCheck.BuffsCheck then
			IsSendBuffsByMe = true
			ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","BUFFS")
		end
		ExRT.F.ScheduleTimer(SendDataToChat, 1)
	end
end

do
	local function ScheduledReadyCheckFinish()
		module.main:READY_CHECK_FINISHED()
	end
	function module.main:READY_CHECK(starter,timer,isTest)
		if not (isTest == "TEST") then isTest = nil end
		if VExRT.RaidCheck.ReadyCheck and not isTest then
			--[[
			local plus = VExRT.RaidCheck.SendSelf and 1 or 0
			GetFood(2+plus)
			GetFlask(2+plus)
			if VExRT.RaidCheck.RunesCheck then
				GetRunes(2+plus)
			end
			if VExRT.RaidCheck.BuffsCheck then
				GetRaidBuffs(2+plus)
			end
			]]
			PrepareDataToChat(VExRT.RaidCheck.SendSelf)
		end
		if VExRT.RaidCheck.ReadyCheckFrame then
			module.db.RaidCheckReadyCheckHide = nil
			module.db.RaidCheckReadyCheckTime = GetTime() + (timer or 35)
			ExRT.F.CancelTimer(module.db.RaidCheckReadyCheckHideSchedule)
			module.db.RaidCheckReadyCheckHideSchedule = ExRT.F.ScheduleTimer(ScheduledReadyCheckFinish, timer or 35)
			RaidCheckReadyCheckReset(starter,isTest)
			module.main:READY_CHECK_CONFIRM(ExRT.F.delUnitNameServer(starter),true,isTest)
		end
	end
end

function module.main:READY_CHECK_FINISHED()
	if not module.db.RaidCheckReadyCheckHide then
		module.db.RaidCheckReadyCheckHide = VExRT.RaidCheck.ReadyCheckFrameTimerFade
	end
end

function module.main:READY_CHECK_CONFIRM(unit,response,isTest)
	if not (isTest == "TEST") then unit = UnitName(unit) isTest = nil end
	if unit and module.db.RaidCheckReadyCheckTable[unit] then
		local foodBuff = nil
		local flaskBuff = nil
		for i=1,40 do
			local name,_,_,_,_,_,_,_,_,_,spellId = UnitAura(unit, i,"HELPFUL")
			if not spellId then
				break
			elseif module.db.tableFood[spellId] then
				foodBuff = true
			elseif module.db.tableFlask[spellId] then
				flaskBuff = true
			elseif name and module.db.tableFoodInProgress == name then
				foodBuff = true
			end
		end
		if isTest then
			if math.random(1,2) == 1 then foodBuff = nil flaskBuff = nil else foodBuff = true flaskBuff = true end
		end
		if not foodBuff or not flaskBuff then
			module.frame.u[module.db.RaidCheckReadyCheckTable[unit]].t:SetTextColor(1,0.5,0.5,1)
		end
		if response == true then
			module.frame.u[module.db.RaidCheckReadyCheckTable[unit]].icon.texture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
		else
			module.frame.u[module.db.RaidCheckReadyCheckTable[unit]].icon.texture:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
		end
		if foodBuff and flaskBuff and response then
			module.frame.u[module.db.RaidCheckReadyCheckTable[unit]]:Hide()
		end

		module.db.RaidCheckReadyPPLNum = module.db.RaidCheckReadyPPLNum - 1
		if module.db.RaidCheckReadyPPLNum <= 0 then
			module.db.RaidCheckReadyCheckHide = VExRT.RaidCheck.ReadyCheckFrameTimerFade
		end
		module.db.RaidCheckReadyCheckTable[unit] = nil
	end
end

do
	local _db = module.db
	function module.main:COMBAT_LOG_EVENT_UNFILTERED(_,_,event,_,_,sourceName,_,_,_,_,_,_,spellId)
		if event == "SPELL_CAST_SUCCESS" and sourceName then
			if _db.hsSpells[spellId] then
				_db.hsList[sourceName] = _db.hsList[sourceName] and _db.hsList[sourceName] + 1 or 1
			elseif _db.tablePotion[spellId] then
				_db.potionList[sourceName] = _db.potionList[sourceName] and _db.potionList[sourceName] + 1 or 1
			end
		end
	end
end

function module:addonMessage(sender, prefix, ...)
	if prefix == "raidcheck" then
		if sender then
			if ExRT.F.IsPlayerRLorOfficer(ExRT.SDB.charName) == 2 then
				return
			end
			if sender < ExRT.SDB.charName or ExRT.F.IsPlayerRLorOfficer(sender) == 2 then
				local type = ...
				if type == "FOOD" then
					IsSendFoodByMe = nil
				elseif type == "FLASK" then
					IsSendFlaskByMe = nil
				elseif type == "RUNES" then
					IsSendRunesByMe = nil
				elseif type == "BUFFS" then
					IsSendBuffsByMe = nil
				end
			end
		end
	end
end

local addonMsgFrame = CreateFrame'Frame'
local addonMsgAttack_AntiSpam = 0
addonMsgFrame:SetScript("OnEvent",function (self, event, ...)
	local prefix, message, channel, sender = ...
	if message and ((prefix == "BigWigs" and message:find("^T:BWPull")) or (prefix == "D4" and message:find("^PT"))) then
		if VExRT.RaidCheck.OnAttack then
			local _time = GetTime()
			if (_time - addonMsgAttack_AntiSpam) < 2 then
				return
			end
			addonMsgAttack_AntiSpam = _time
		
			PrepareDataToChat(VExRT.RaidCheck.SendSelf)
		end
	end
end)
addonMsgFrame:RegisterEvent("CHAT_MSG_ADDON")