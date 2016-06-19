local GlobalAddonName, ExRT = ...

local module = ExRT.mod:New("Coins",ExRT.L.Coins,nil,true)
local ELib,L = ExRT.lib,ExRT.L

local VExRT = nil

local strsplit = strsplit

module.db.spellsCoins = {
	[188958] = L.RaidLootT18HCBoss1,	-- T18x1
	[188959] = L.RaidLootT18HCBoss2,	-- T18x2
	[188960] = L.RaidLootT18HCBoss3,	-- T18x3
	[188961] = L.RaidLootT18HCBoss4,	-- T18x4
	[188962] = L.RaidLootT18HCBoss5,	-- T18x5
	[188963] = L.RaidLootT18HCBoss6,	-- T18x6
	[188964] = L.RaidLootT18HCBoss7,	-- T18x7
	[188965] = L.RaidLootT18HCBoss8,	-- T18x8
	[188966] = L.RaidLootT18HCBoss9,	-- T18x9
	[188967] = L.RaidLootT18HCBoss10,	-- T18x10
	[188968] = L.RaidLootT18HCBoss11,	-- T18x11
	[188969] = L.RaidLootT18HCBoss12,	-- T18x12
	[188970] = L.RaidLootT18HCBoss13,	-- T18x13

	[177510] = L.RaidLootBFBoss1,	-- T17x2x1
	[177511] = L.RaidLootBFBoss2,	-- T17x2x2
	[177517] = L.RaidLootBFBoss3,	-- T17x2x3
	[177515] = L.RaidLootBFBoss4,	-- T17x2x4
	[177513] = L.RaidLootBFBoss5,	-- T17x2x5
	[177518] = L.RaidLootBFBoss6,	-- T17x2x6
	[177512] = L.RaidLootBFBoss7,	-- T17x2x7
	[177516] = L.RaidLootBFBoss8,	-- T17x2x8
	[177519] = L.RaidLootBFBoss9,	-- T17x2x9
	[177520] = L.RaidLootBFBoss10,	-- T17x2x10

	[177503] = L.RaidLootHighmaulBoss1,-- T17x1x1
	[177504] = L.RaidLootHighmaulBoss2,-- T17x1x2
	[177505] = L.RaidLootHighmaulBoss3,-- T17x1x3
	[177506] = L.RaidLootHighmaulBoss4,-- T17x1x4
	[177507] = L.RaidLootHighmaulBoss5,-- T17x1x5
	[177508] = L.RaidLootHighmaulBoss6,-- T17x1x6
	[177509] = L.RaidLootHighmaulBoss7,-- T17x1x7

	[163435] = L.sooitemssooboss1,	-- T16x1
	[163533] = L.sooitemssooboss2,	-- T16x2
	[165021] = L.sooitemssooboss3,	-- T16x3
	[165037] = L.sooitemssooboss4,	-- T16x4
	[165038] = L.sooitemssooboss5,	-- T16x5
	[165041] = L.sooitemssooboss6,	-- T16x6
	[165043] = L.sooitemssooboss7,	-- T16x7
	[165044] = L.sooitemssooboss8,	-- T16x8
	[165045] = L.sooitemssooboss9,	-- T16x9
	[165048] = L.sooitemssooboss12,	-- T16x10
	[165046] = L.sooitemssooboss10,	-- T16x11
	[165047] = L.sooitemssooboss11,	-- T16x12
	[165049] = L.sooitemssooboss13,	-- T16x13
	[165050] = L.sooitemssooboss14,	-- T16x14

	[145923] = L.sooitemssooboss1,	-- T16x1
	[145924] = L.sooitemssooboss2,	-- T16x2
	[145925] = L.sooitemssooboss3,	-- T16x3
	[145926] = L.sooitemssooboss4,	-- T16x4
	[145927] = L.sooitemssooboss5,	-- T16x5
	[145928] = L.sooitemssooboss6,	-- T16x6
	[145929] = L.sooitemssooboss7,	-- T16x7
	[145930] = L.sooitemssooboss8,	-- T16x8
	[145931] = L.sooitemssooboss9,	-- T16x9
	[145932] = L.sooitemssooboss12,	-- T16x10
	[145933] = L.sooitemssooboss10,	-- T16x11
	[145934] = L.sooitemssooboss11,	-- T16x12
	[145935] = L.sooitemssooboss13,	-- T16x13
	[145936] = L.sooitemssooboss14,	-- T16x14

	[139673] = L.sooitemstotboss1,	-- T15x1
	[139659] = L.sooitemstotboss2,	-- T15x2
	[139661] = L.sooitemstotboss3,	-- T15x3
	[139662] = L.sooitemstotboss4,	-- T15x4
	[139663] = L.sooitemstotboss5,	-- T15x5
	[139664] = L.sooitemstotboss6,	-- T15x6
	[139665] = L.sooitemstotboss7,	-- T15x7
	[139666] = L.sooitemstotboss8,	-- T15x8
	[139667] = L.sooitemstotboss9,	-- T15x9
	[139669] = L.sooitemstotboss10,	-- T15x10
	[139670] = L.sooitemstotboss11,	-- T15x11
	[139671] = L.sooitemstotboss12,	-- T15x12
	[139668] = L.sooitemstotboss13,	-- T15x13

	[125145] = true,	-- T14x1x1
	[132171] = true,	-- T14x1x2
	[132172] = true,	-- T14x1x3
	[132173] = true,	-- T14x1x4
	[132174] = true,	-- T14x1x5
	[132175] = true,	-- T14x1x6

	[132176] = true,	-- T14x2x1
	[132177] = true,	-- T14x2x2
	[132178] = true,	-- T14x2x3
	[132179] = true,	-- T14x2x4
	[132180] = true,	-- T14x2x5
	[132181] = true,	-- T14x2x6

	[132182] = true,	-- T14x3x1x1
	[132186] = true,	-- T14x3x1x2
	[132183] = true,	-- T14x3x2
	[132184] = true,	-- T14x3x3
	[132185] = true,	-- T14x3x4
}
module.db.endCoinTimer = nil
module.db.bonusLootChat = nil
module.db.bonusLootChatSelf = nil
module.db.classNames = ExRT.GDB.ClassList

local function deformat(str)
	str = str:gsub("%.","%%.")
	str = str:gsub("%%s","(.+)")
	
	return str
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Coins = VExRT.Coins or {}
	VExRT.Coins.list = VExRT.Coins.list or {}
	
	module:RegisterEvents('ENCOUNTER_END','ENCOUNTER_START')
	
	module.db.bonusLootChat = deformat(LOOT_ITEM_BONUS_ROLL)
	module.db.bonusLootChatSelf = deformat(LOOT_ITEM_BONUS_ROLL_SELF)
end

do
	local function CoinsTimerEnd()
		module.db.endCoinTimer = nil
		module:UnregisterEvents('UNIT_SPELLCAST_SUCCEEDED','CHAT_MSG_LOOT')
	end
	function module.main:ENCOUNTER_END(encounterID,encounterName,difficultyID,groupSize,success)
		if success == 1 then
			module:RegisterEvents('CHAT_MSG_LOOT','UNIT_SPELLCAST_SUCCEEDED')
			module.db.endCoinTimer = ExRT.F.ScheduleETimer(module.db.endCoinTimer, CoinsTimerEnd, 180)
		end
		if encounterID == 1594 then
			module:UnregisterEvents('CHAT_MSG_MONSTER_YELL')
		end	
	end
end

function module.main:CHAT_MSG_LOOT(msg, ...)
	if msg:find(module.db.bonusLootChatSelf) then
		local unitName = UnitName("player")
		local itemID = msg:match("|Hitem:(%d+)")
		local class = select(3,UnitClass("player"))
		local affixes = ""
		local affixesFind = msg:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+(:[^|]+)|")
		if affixesFind then
			affixes = affixesFind
		end
		if itemID then
			VExRT.Coins.list[#VExRT.Coins.list + 1] = "!"..ExRT.F.tohex(class or 0,1)..itemID..unitName..time()..affixes
		end	
	elseif msg:find(module.db.bonusLootChat) then
		local unitName = msg:match(module.db.bonusLootChat)
		local itemID = msg:match("|Hitem:(%d+)")
		local class
		if unitName and itemID then
			if UnitName(unitName) then
				class = select(3,UnitClass(unitName))
			end
			local affixes = ""
			local affixesFind = msg:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+(:[^|]+)|")
			if affixesFind then
				affixes = affixesFind
			end
			VExRT.Coins.list[#VExRT.Coins.list + 1] = "!"..ExRT.F.tohex(class or 0,1)..itemID..unitName..time()..affixes
		end
	end	
end

function module.main:ENCOUNTER_START(encounterID,encounterName,difficultyID,groupSize)
	if encounterID == 1594 then
		module:RegisterEvents('CHAT_MSG_MONSTER_YELL')
	end
end

function module.main:CHAT_MSG_MONSTER_YELL(msg, ...)
	if msg:find(L.CoinsSpoilsOfPandariaWinTrigger) then
		module.main:ENCOUNTER_END(1594,nil,nil,nil,1)
	end	
end

do
	local module_db_spellsCoins = module.db.spellsCoins
	function module.main:UNIT_SPELLCAST_SUCCEEDED(unitID,_,_,_,spellID)
		if module_db_spellsCoins[spellID] and unitID:find("^raid%d+$") then
			local name = ExRT.F.UnitCombatlogname(unitID)
			if name then
				local _,className,class = UnitClass(unitID)
				VExRT.Coins.list[#VExRT.Coins.list + 1] = ExRT.F.tohex(class or 0,1)..spellID..name..time()
				
				if VExRT.Coins.ShowMessage then
					local msg = L.CoinsMessage
					print( msg:format( "|c"..ExRT.F.classColor( className or "?" )..name.."|r" ) )
				end
			end
		end
	end
	if ExRT.is7 then
		function module.main:UNIT_SPELLCAST_SUCCEEDED(unitID,_,_,spellLine)
			local unitType,_,serverID,instanceID,zoneUID,spellID,spawnID = strsplit("-", spellLine or "")
			spellID = tonumber(spellID or 0) or 0
			if module_db_spellsCoins[spellID] and unitID:find("^raid%d+$") then
				local name = ExRT.F.UnitCombatlogname(unitID)
				if name then
					local _,className,class = UnitClass(unitID)
					VExRT.Coins.list[#VExRT.Coins.list + 1] = ExRT.F.tohex(class or 0,1)..spellID..name..time()
					
					if VExRT.Coins.ShowMessage then
						local msg = L.CoinsMessage
						print( msg:format( "|c"..ExRT.F.classColor( className or "?" )..name.."|r" ) )
					end
				end
			end
		end
	end
end

function module.options:Load()
	local historyBoxUpdate = nil
	
	self:CreateTilte()

	local LINES_COUNT = 50
	local FONT_SIZE = 11
	local currFilter = nil
	
	self.shtml1 = ELib:Text(self,L.CoinsHelp,11):Size(550,200):Point(5,-30):Top()
	
	self.clearButton = ELib:Button(self,L.MarksClear):Size(100,20):Point("TOPRIGHT",-5,-30):Tooltip(L.CoinsClear):OnClick(function() 
		StaticPopupDialogs["EXRT_COINS_CLEAR"] = {
			text = L.CoinsClearPopUp,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				table.wipe(VExRT.Coins.list)
				if module.options.textList.ScrollBar:GetValue() == 1 then
					historyBoxUpdate(1)
				else
					module.options.textList.ScrollBar:SetValue(1)
				end
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_COINS_CLEAR")
	end) 
	
	local function OptionsScheduledItemInfoEventCancel()
		module.options.GET_ITEM_INFO_RECEIVED_cancel = nil
		module.options:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
	end
	
	local function HandleString(str)
		local unitClass,spellID,unitName,timestamp = str:match("^([^!])(%d+)([^0-9]+)(%d+)")
		if spellID and unitClass and unitName and timestamp then
			local spellName = module.db.spellsCoins[tonumber(spellID) or 0]
			if type(spellName) ~= "string" then
				spellName = GetSpellInfo(spellID)
			end
			local classColor = ExRT.F.classColor( module.db.classNames[ tonumber(unitClass,16) ] or "?")
			return date("%d/%m/%y %H:%M:%S ",timestamp),classColor,unitName,spellName,spellID
		else
			local unitClass,itemID,unitName,timestamp,affixes = str:match("^!(.)(%d+)([^0-9]+)(%d+)(:?.*)")
			if itemID and unitClass and unitName and timestamp then
				itemID = tonumber(itemID)
				local itemName,_,itemQuality,_,itemReqLevel,_,_,_,_,itemTexture = GetItemInfo(itemID)
				local itemColor = select(4,GetItemQualityColor(itemQuality or 4))
				local link = format("|c%s|Hitem:%d:0:0:0:0:0:0:0:%d:0:0:0%s|h[%s]|h|r",itemColor,itemID,itemReqLevel or UnitLevel("player"),affixes or ":0",itemName or "ItemID: "..itemID)
				local classColor = ExRT.F.classColor( module.db.classNames[ tonumber(unitClass,16) ] or "?")
				return date("%d/%m/%y %H:%M:%S ",timestamp),classColor,unitName,link,itemID,true
			end
		end
		--[[
		/run print'-----'local q,a,s=VExRT.Coins.list,{},{} for i=1,#q do local w,e,r,t,y,u=Q(q[i])if u then a[r]=(a[r] or 0)+1 else s[r]=(s[r] or 0)+1 end end for w,e in pairs(a)do if s[w] and s[w]>20 then print(w,e/s[w],e,s[w])end end
		Q = HandleString
		]]
	end
	local function IsMatchFilter(unitName,spell,spellID,timestamp)
		if unitName:lower():match(currFilter) then
			return 1
		elseif (spell and spell:lower():match(currFilter)) then
			return 2
		elseif (spellID and (tostring(spellID)):match(currFilter) ) then
			return 3
		elseif timestamp:lower():match(currFilter) then
			return 4
		end
	end

	local historyBoxUpdateTable = {}
	function historyBoxUpdate(val)
		ExRT.F.table_wipe(historyBoxUpdateTable)
		module.options:RegisterEvent("GET_ITEM_INFO_RECEIVED")
		module.options.GET_ITEM_INFO_RECEIVED_cancel = ExRT.F.ScheduleETimer(module.options.GET_ITEM_INFO_RECEIVED_cancel, OptionsScheduledItemInfoEventCancel, 1.5)
		if currFilter then
			local count = 0
			for i=#VExRT.Coins.list,1,-1 do
				local timestamp,classColor,unitName,spellOrLink,itemIDorSpellID,isItem = HandleString(VExRT.Coins.list[i])
				local isMatchFilter = IsMatchFilter(unitName,spellOrLink,itemIDorSpellID,timestamp)
				if not isMatchFilter and isItem and VExRT.Coins.list[i-1] then
					local timestamp2,_,unitName2,spell2,spellID2 = HandleString(VExRT.Coins.list[i-1])
					if unitName == unitName2 and IsMatchFilter(unitName2,spell2,spellID2,timestamp2) then
						isMatchFilter = true
					end
				end
				
				if isMatchFilter then
					count = count + 1
					if count >= val and timestamp then
						historyBoxUpdateTable [#historyBoxUpdateTable + 1] = timestamp.."|c"..classColor..unitName.."|r: "..(spellOrLink or "???")
					end
				end
			
				if #historyBoxUpdateTable >= LINES_COUNT then
					break
				end
			end
		else
			for i=(#VExRT.Coins.list-val+1),1,-1 do
				local timestamp,classColor,unitName,spellOrLink,itemIDorSpellID,isItem = HandleString(VExRT.Coins.list[i])
				local isMatchFilter = not currFilter or IsMatchFilter(unitName,spellOrLink,itemIDorSpellID,timestamp)
				if not isMatchFilter and isItem and VExRT.Coins.list[i-1] then
					local timestamp2,_,unitName2,spell2,spellID2 = HandleString(VExRT.Coins.list[i-1])
					if unitName == unitName2 and IsMatchFilter(unitName2,spell2,spellID2,timestamp2) then
						isMatchFilter = true
					end
				end
				
				if isMatchFilter and timestamp then
					historyBoxUpdateTable [#historyBoxUpdateTable + 1] = timestamp.."|c"..classColor..unitName.."|r: "..(spellOrLink or "???")
				end
			
				if #historyBoxUpdateTable >= LINES_COUNT then
					break
				end
			end
		end
		
		if #historyBoxUpdateTable > 0 then
			module.options.textList:SetText(strjoin("\n",unpack(historyBoxUpdateTable)))
		elseif not currFilter then
			module.options.textList:SetText(L.CoinsEmpty)
		else 
			module.options.textList:SetText(BROWSE_NO_RESULTS)
		end
	end
	
	local function OptionsScheduledItemInfoEventUpdate()
		self.GET_ITEM_INFO_RECEIVED = nil
		historyBoxUpdate( floor(module.options.textList.ScrollBar:GetValue() / FONT_SIZE) + 1 ) 
	end
	self:SetScript("OnEvent",function ()
		if not self.GET_ITEM_INFO_RECEIVED then
			self.GET_ITEM_INFO_RECEIVED = ExRT.F.ScheduleTimer(OptionsScheduledItemInfoEventUpdate, 0.1)
		end
	end)
	
	local function historyBoxShow()
		module.options.textList.ScrollBar:Range(1,max((#VExRT.Coins.list - 40) * FONT_SIZE,1))
		if module.options.textList.ScrollBar:GetValue() == 1 then
			historyBoxUpdate(1)
		else
			module.options.ScrollBar:SetValue(1)
		end
		module.options.textList.ScrollBar:UpdateButtons()
	end
	
	self.filterEditBox = ELib:Edit(self):Size(655,16):Point("TOP",0,-60):Tooltip(FILTER):OnChange(function (self)
		local text = self:GetText()
		local count
		if text == "" then
			currFilter = nil
			count = #VExRT.Coins.list
		else
			currFilter = text:lower()
			count = 0
			local i = 1
			local max = #VExRT.Coins.list
			while true do
				local timestamp,_,unitName,spellName,spellID,isItem = HandleString(VExRT.Coins.list[i])
				local isMatchFilter = IsMatchFilter(unitName,spellName,spellID,timestamp)
				if isMatchFilter then
					count = count + 1
				end
				i = i + 1
				if isMatchFilter == 2 and not isItem and VExRT.Coins.list[i] then
					local _,_,unitName2,_,_,isItem2 = HandleString(VExRT.Coins.list[i])
					if isItem2 and unitName2 == unitName then
						count = count + 1
						i = i + 1
					end
				end
				if i > max then
					break
				end
			end
		end
		
		module.options.textList.ScrollBar:Range(1,max((count-40) * FONT_SIZE,1))
		historyBoxUpdate(1)
	end)
	
	self.textList = ExRT.lib:MultiEdit2(self):Size(653,500):Point("TOP",0,-85):Font('x',FONT_SIZE):Hyperlinks()
	self.textList.ScrollBar:Range(1,1)
	self.textList.wheelRange = FONT_SIZE
	
	self.textList.ScrollBar:SetScript("OnShow",historyBoxShow)
	self.textList.ScrollBar:SetScript("OnValueChanged",function (self,val)
		module.options.textList:SetVerticalScroll((val % FONT_SIZE))
		val = floor(val / FONT_SIZE) + 1
		self:UpdateButtons()
		historyBoxUpdate(val)
	end)
	
	self.showMessageChk = ELib:Check(self,L.CoinsShowMessage,VExRT.Coins.ShowMessage):Point("TOPLEFT",self.textList,"BOTTOMLEFT",-2,-7):OnClick(function(self,event) 
		if self:GetChecked() then
			VExRT.Coins.ShowMessage = true
		else
			VExRT.Coins.ShowMessage = nil
		end
	end)
	
	self.buttonExport = ELib:Button(self,L.Export):Point("TOPRIGHT",self.textList,"BOTTOMRIGHT",3,-7):Size(100,20):OnClick(function()
		local text = ""
		local pos = 1
		for i=1,#VExRT.Coins.list do
			local timestamp,classColor,unitName,spellOrLink,itemIDorSpellID,isItem = HandleString(VExRT.Coins.list[pos])
			if not isItem and timestamp then
				local isMatchFilter = not currFilter or IsMatchFilter(unitName,spellOrLink,itemIDorSpellID,timestamp)
				
				local itemStr = nil
				if VExRT.Coins.list[pos+1] then
					local timestamp2,classColor2,unitName2,spellOrLink2,itemIDorSpellID2,isItem2 = HandleString(VExRT.Coins.list[pos+1])
					if isItem2 and unitName2 == unitName then
						local bonus,itemName = spellOrLink2:match(UnitLevel('player')..":0:0:0:(.-)|h%[(.-)%]")
						if not bonus then
							itemStr = '=hyperlink("http://wowhead.com/item='..itemIDorSpellID2..'";"'..itemIDorSpellID2..'")'
						else
							if bonus == '0' then
								bonus = ''
							else
								local newbonus = '&bonus='
								local bonusNum,bonusRest = bonus:match("^([0-9]+):(.+)$")
								bonus = bonusRest
								bonusNum = tonumber(bonusNum)
								for i=1,bonusNum do
									local bonusNow = bonus:match("^([0-9]+)")
									if bonusNow then
										newbonus = newbonus .. bonusNow .. ":"
									end
									bonus = bonus:match("^[0-9]+:(.+)$")
									if not bonus then
										break
									end
								end
								bonus = newbonus:sub(1,-2)
							end
							itemStr = '=hyperlink("http://wowhead.com/item='..itemIDorSpellID2..bonus..'";"'..itemName..'")'
						end
						
						pos = pos + 1
					end
				end
				
				if isMatchFilter then
					local className = nil
					for classN,data in pairs(RAID_CLASS_COLORS) do
						if classColor == data.colorStr then
							className = classN
							break
						end
					end
					text = text .. timestamp.."\t"..unitName.."\t"..(className or "unk").."\t"..spellOrLink.."\t"..(itemStr or "").."\n"
				end
			end
			pos = pos + 1
			if not VExRT.Coins.list[pos] then
				break
			end
		end
		if text ~= "" then
			text = text:sub(1,-2)
		end
		ExRT.F:Export(text)
	end)
	
	historyBoxShow()
end