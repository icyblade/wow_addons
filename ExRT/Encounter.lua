local GlobalAddonName, ExRT = ...

local GetUnitInfoByUnitFlag = ExRT.F.GetUnitInfoByUnitFlag

local VExRT = nil

local module = ExRT.mod:New("Encounter",ExRT.L.sencounter)
local ELib,L = ExRT.lib,ExRT.L

module.db.firstBlood = nil
module.db.isEncounter = nil
module.db.diff = nil
module.db.nowInTable = nil
module.db.afterCombatFix = nil
module.db.diffNames = {
	[0] = L.sencounterUnknown,
	[1] = L.sencounter5ppl,
	[2] = L.sencounter5pplHC,
	[3] = L.EncounterLegacy..": "..L.sencounter10ppl,
	[4] = L.EncounterLegacy..": "..L.sencounter25ppl,
	[5] = L.EncounterLegacy..": "..L.sencounter10pplHC,
	[6] = L.EncounterLegacy..": "..L.sencounter25pplHC,
	[7] = L.sencounterLfr,		--		PLAYER_DIFFICULTY3
	[8] = L.sencounterChall,
	[9] = L.sencounter40ppl,
	[11] = L.sencounter3pplHC,
	[12] = L.sencounter3ppl,
	[14] = L.sencounterWODNormal,	-- Normal,	PLAYER_DIFFICULTY1
	[15] = L.sencounterWODHeroic,	-- Heroic,	PLAYER_DIFFICULTY2
	[16] = L.sencounterWODMythic,	-- Mythic,	PLAYER_DIFFICULTY6
	[17] = L.sencounterLfr,		-- Lfr,		PLAYER_DIFFICULTY3
	[23] = "5ppl: Mythic",
	[24] = "5ppl: Timewalker",
}
module.db.diffPos = {3,4,5,6,7,14,15,16}
module.db.dropDownNow = nil
module.db.onlyMy = nil
module.db.scrollPos = 1
module.db.playerName = nil
module.db.pullTime = 0

module.db.chachedDB = nil

function module.options:Load()
	local table_find = ExRT.F.table_find3

	self:CreateTilte()

	self.dropDown = ELib:DropDown(self,205,#module.db.diffPos):Size(220):Point(435,-30)
	function self.dropDown:SetValue(newValue,resetDB)
		if module.db.dropDownNow ~= newValue then
			module.db.scrollPos = 1
			module.options.ScrollBar:SetValue(1)
		end
		if resetDB then
			module.db.chachedDB = nil
		end
		module.db.dropDownNow = newValue
		local newDiff = module.db.diffPos[newValue]
		module.options.dropDown:SetText(module.db.diffNames[newDiff])
		ELib:DropDownClose()
		local myName = UnitName("player")
		
		local encounters = module.db.chachedDB or {}
		local currDate = time()
		
		if not module.db.chachedDB then
			for playerName,playerData in pairs(VExRT.Encounter.list) do
				if not module.db.onlyMy or playerName == module.db.playerName then
					for i=1,#playerData do
						local data = playerData[i]
						local diffID = tonumber( string.sub(data,4,4),16 ) + 1
						if diffID == newDiff then
							local encounterID = tonumber( string.sub(data,1,3),16 )
							local pull = tonumber( string.sub(data,5,14) )
							local pullTime = tonumber( string.sub(data,15,17),16 )
							local isKill = string.sub(data,18,18) == "1"
							local groupSize = tonumber(string.sub(data,19,20))
							local firstBloodName = string.sub(data,21)
							if firstBloodName == "" then 
								firstBloodName = nil
							end
							
							local encounterLine = table_find(encounters,encounterID,"id")
							if not encounterLine then
								encounterLine = {
									id = encounterID,
									firstBlood = {},
									pullTable = {},
									name = VExRT.Encounter.names[encounterID] or "Unknown",
									pulls = 0,
									kills = 0,
								}
								encounters[#encounters + 1] = encounterLine
							end
							
							encounterLine.first = min( encounterLine.first or currDate, pull )
							if isKill then
								encounterLine.killTime = min( encounterLine.killTime or 4095, pullTime )
								encounterLine.kills = encounterLine.kills + 1
								if not encounterLine.firstKill then
									encounterLine.firstKill = encounterLine.pulls + 1
								end
								encounterLine.pulls = encounterLine.pulls + 1
							else
								encounterLine.wipeTime = max( encounterLine.wipeTime or 0, pullTime )
								if not pullTime or pullTime > 30 then
									encounterLine.pulls = encounterLine.pulls + 1
								end
							end
							
							if firstBloodName then
								local firstBloodLine = table_find(encounterLine.firstBlood,firstBloodName,"n")
								if not firstBloodLine then
									encounterLine.firstBlood[#encounterLine.firstBlood + 1] = { 
										n = firstBloodName,
										c = 1,
									}
								else
									firstBloodLine.c = firstBloodLine.c + 1
								end
							end
							
							encounterLine.pullTable[ #encounterLine.pullTable + 1 ] = {
								t = pull,
								d = pullTime,
								k = isKill,
								s = groupSize,
							}
						end
					end			
				end
			end
		
			sort(encounters,function(a,b) return a.first > b.first end)
			
			for _,encounterData in pairs(encounters) do
				sort(encounterData.firstBlood,function(a,b) return a.c > b.c end)
				sort(encounterData.pullTable,function(a,b) return a.t < b.t end)
				
				if not encounterData.killTime or encounterData.killTime == 4095 then
					encounterData.killTime = 0
				end
				encounterData.wipeTime = encounterData.wipeTime or 0
			end
			
		end
		
		module.db.chachedDB = encounters
			
		local j = 0
		for i=module.db.scrollPos,#encounters do
			j = j + 1
			local encounterLine = encounters[i]
			local optionsLine = module.options.line[j]
		
			optionsLine.boss:SetText(encounterLine.name)
			optionsLine.wipeBK:SetText(encounterLine.firstKill or "-")
			optionsLine.wipe:SetText(encounterLine.pulls)
			optionsLine.kill:SetText(encounterLine.kills)
			optionsLine.firstBlood:SetText(encounterLine.firstBlood[1] and encounterLine.firstBlood[1].n or "")
			optionsLine.longest:SetText(date("%M:%S",encounterLine.wipeTime))
			optionsLine.fastest:SetText(date("%M:%S",encounterLine.killTime))
			if encounterLine.wipeTime == 0 then optionsLine.longest:SetText("-") end
			if encounterLine.killTime == 0 then optionsLine.fastest:SetText("-") end
			
			optionsLine.firstBloodB.n = encounterLine.firstBlood
			optionsLine.pullClick.n = encounterLine.pullTable
			optionsLine.pullClick.bossName = encounterLine.name or ""

			optionsLine:Show()

			if j>=30 then break end
		end
		for i=(j+1),30 do
			module.options.line[i]:Hide()
		end
		module.options.ScrollBar:SetMinMaxValues(1,max(#encounters-29,1))
		module.options.ScrollBar:UpdateButtons()
		module.options.FBframe:Hide()
		module.options.PullsFrame:Hide()
	end

	for i=1,#module.db.diffPos do
		self.dropDown.List[i] = {text = module.db.diffNames[ module.db.diffPos[i] ], justifyH = "CENTER", arg1 = i, arg2 = true, func = self.dropDown.SetValue}
	end
	
	self.borderList = CreateFrame("Frame",nil,self)
	self.borderList:SetSize(655,562)
	self.borderList:SetPoint("TOP", 0, -55)
	self.borderList:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8})
	self.borderList:SetBackdropColor(0,0,0,0.3)
	self.borderList:SetBackdropBorderColor(.24,.25,.30,1)


	self.borderList.decorationLine = CreateFrame("Frame",nil,self.borderList)
	self.borderList.decorationLine.texture = self.borderList.decorationLine:CreateTexture(nil, "BACKGROUND")
	self.borderList.decorationLine:SetPoint("TOPLEFT",self.borderList,2,-2)
	self.borderList.decorationLine:SetPoint("BOTTOMRIGHT",self.borderList,"TOPRIGHT",-2,-20)
	self.borderList.decorationLine.texture:SetAllPoints()
	self.borderList.decorationLine.texture:SetTexture(1,1,1,1)
	self.borderList.decorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)

	local function LineOnEnter(self)
		if self.pullClick.n then 
			self.hl:Show() 
		end 
	end
	local function LineOnLeave(self)
		self.hl:Hide() 
	end
	local function LineFirstBloodClick(self)
		if not self.n or #self.n == 0 then 
			return 
		end
		local x, y = GetCursorPosition()
		local Es = self:GetEffectiveScale()
		x, y = x/Es, y/Es
		module.options.FBframe:ClearAllPoints()
		module.options.FBframe:SetPoint("BOTTOMLEFT",UIParent,x,y)
		for i=1,#module.options.FBframe.txtL do
			if self.n[i] then
				module.options.FBframe.txtL[i]:SetText(self.n[i].n)
				module.options.FBframe.txtR[i]:SetText(self.n[i].c)
				module.options.FBframe.txtR[i]:Show()
				module.options.FBframe.txtL[i]:Show()				
			else
				module.options.FBframe.txtR[i]:Hide()
				module.options.FBframe.txtL[i]:Hide()
			end
		end
		module.options.FBframe:Show() 
		module.options.PullsFrame:Hide()
	end
	local function LineFirstBloodOnEnter(self)
		self:GetParent().firstBlood:SetTextColor(1,1,0.5,1)
	end
	local function LineFirstBloodOnLeave(self)
		self:GetParent().firstBlood:SetTextColor(1,1,1,1)
	end
	local function LinePullsClick(self)
		local x, y = GetCursorPosition()
		local Es = self:GetEffectiveScale()
		x, y = x/Es, y/Es
		module.options.PullsFrame:ClearAllPoints()
		module.options.PullsFrame:SetPoint("BOTTOMLEFT",UIParent,x,y)
		module.options.PullsFrame.data = self.n
		module.options.PullsFrame.boss = self.bossName
		module.options.PullsFrame.ScrollBar:SetValue(1)
		module.options.PullsFrame:SetBoss()
		
		module.options.graphsFrame.data = self.n
	end
	local function LinePullsOnEnter(self)
		self:GetParent().wipe:SetTextColor(1,0.5,0.5,1)
	end
	local function LinePullsOnLeave(self)
		self:GetParent().wipe:SetTextColor(1,1,1,1)
	end
	
	self.line = {}
	for i=0,30 do
		self.line[i] = CreateFrame("Frame",nil,self.borderList)     
		self.line[i]:SetSize(630,18)        
		self.line[i]:SetPoint("TOPLEFT",5,-3-18*i) 

		self.line[i].boss = ELib:Text(self.line[i],"",11):Size(300,18):Point("LEFT",0,0):Color()
		self.line[i].wipeBK = ELib:Text(self.line[i],"",11):Size(35,18):Point("LEFT",250,0):Color()
		self.line[i].wipe = ELib:Text(self.line[i],"",11):Size(35,18):Point("LEFT",290,0):Color()
		self.line[i].kill = ELib:Text(self.line[i],"",11):Size(35,18):Point("LEFT",330,0):Color()
		self.line[i].firstBlood = ELib:Text(self.line[i],"",11):Size(85,18):Point("LEFT",370,0):Color()
		self.line[i].longest = ELib:Text(self.line[i],"",11):Size(75,18):Point("LEFT",460,0):Color()
		self.line[i].fastest = ELib:Text(self.line[i],"",11):Size(75,18):Point("LEFT",540,0):Color()
		
		if i>0 then
			ExRT.lib.CreateHoverHighlight(self.line[i])
			self.line[i].hl:SetVertexColor(0.3,0.3,0.7,0.7)
			self.line[i]:SetScript("OnEnter",LineOnEnter)
			self.line[i]:SetScript("OnLeave",LineOnLeave)		
		
			self.line[i].firstBloodB = CreateFrame("Button",nil,self.line[i])  
			self.line[i].firstBloodB:SetSize(85,18) 
			self.line[i].firstBloodB:SetPoint("TOPLEFT",370,0)
			self.line[i].firstBloodB:SetScript("OnClick",LineFirstBloodClick)
			self.line[i].firstBloodB:SetScript("OnEnter",LineFirstBloodOnEnter)
			self.line[i].firstBloodB:SetScript("OnLeave",LineFirstBloodOnLeave)

			self.line[i].pullClick = CreateFrame("Button",nil,self.line[i])  
			self.line[i].pullClick:SetSize(35,18) 
			self.line[i].pullClick:SetPoint("TOPLEFT",290,0)
			self.line[i].pullClick:SetScript("OnClick",LinePullsClick)
			self.line[i].pullClick:SetScript("OnEnter",LinePullsOnEnter)
			self.line[i].pullClick:SetScript("OnLeave",LinePullsOnLeave)		
		end
	end
	self.line[0].wipe:SetSize(50,18)
	self.line[0].wipe:SetPoint("LEFT", 287,0)

	self.line[0].boss:SetText(L.sencounterBossName)
	self.line[0].wipeBK:SetText(L.sencounterFirstKill)
	self.line[0].wipe:SetText(L.sencounterWipes)
	self.line[0].kill:SetText(L.sencounterKills)
	self.line[0].firstBlood:SetText(L.sencounterFirstBlood)
	self.line[0].longest:SetText(L.sencounterWipeTime)
	self.line[0].fastest:SetText(L.sencounterKillTime)
	
	self.FBframe = ELib:Popup():Size(150,97)
	
	self.FBframe.txtR = {}
	self.FBframe.txtL = {}
	for i=1,5 do
		self.FBframe.txtL[i] = ELib:Text(self.FBframe,"nam1",11):Size(100,14):Point(10,-6-14*i):Color()
		self.FBframe.txtR[i] = ELib:Text(self.FBframe,"123",11):Size(40,14):Point("TOPRIGHT",-10,-6-14*i):Color()
	end	
	
	self.PullsFrame = ELib:Popup():Size(280,247)
	
	self.PullsFrame.txtL = {}
	for i=1,16 do
		self.PullsFrame.txtL[i] = ELib:Text(self.PullsFrame,"",11):Size(255,14):Point(5,-6-14*i):Color()
	end	
	
	self.PullsFrame.ScrollBar = ELib:ScrollBar(self.PullsFrame):Size(16,224):Point("TOPRIGHT",-3,-20):Range(1,1):OnChange(function(self,event)
		event = event - event%1
		module.options.PullsFrame:SetBoss(event)
		self:UpdateButtons()
	end)
	
	function self.PullsFrame:SetBoss(scrollVal)
		local data = module.options.PullsFrame.data
		if data and #data > 0 then
			local j = 0
			for i=(scrollVal or 1),#data do
				j = j + 1
				if j <= 16 then
					module.options.PullsFrame.txtL[j]:SetText(date("%d.%m.%Y %H:%M:%S",data[i].t)..(data[i].d > 0 and " ["..date("%M:%S",data[i].d).."]" or "")..(data[i].k and " (kill) " or "")..((data[i].s > 0 and module.db.diffPos[module.db.dropDownNow or 0] ~= 16) and " GS:"..data[i].s or ""))
				else
					break
				end
			end
			for i=(j+1),16 do
				module.options.PullsFrame.txtL[i]:SetText("")
			end
			if not scrollVal then
				module.options.PullsFrame.ScrollBar:SetMinMaxValues(1,max(#data-15,1))
			end
			
			module.options.PullsFrame.title:SetText(module.options.PullsFrame.boss)
			module.options.PullsFrame:Show()
			module.options.PullsFrame.ScrollBar:UpdateButtons()
			module.options.FBframe:Hide()
		end		
	end
	
	self.PullsFrame:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.ScrollBar:GetMinMaxValues()
		local val = self.ScrollBar:GetValue()
		if (val - delta) < min then
			self.ScrollBar:SetValue(min)
		elseif (val - delta) > max then
			self.ScrollBar:SetValue(max)
		else
			self.ScrollBar:SetValue(val - delta)
		end
	end)
	
	self.PullsFrame.graphs = ELib:Button(self.PullsFrame,L.BossWatcherTabGraphics):Size(150,20):Point("BOTTOMLEFT",3,-22):OnClick(function()
		if not self.graphsFrame.data then
			print('Error: No Graph data')
			return
		end
		local data = {[1]={}}
		local v_data = {}
		for i=1,#self.graphsFrame.data do
			local line = self.graphsFrame.data[i]
			local t = line.d
			if t > 30 then
				local size = #data[1] + 1
				data[1][size] = {size,t,format("#%d <%s>",i,date("%d.%m.%Y %H:%M:%S",line.t)),format("%s%d:%02d",line.k and "|cff00ff00" or "",t/60,t%60)}
				if line.k then
					v_data[#v_data + 1] = size
				end
			end
		end
		if #data[1] > 0 then
			local prev = data[1][ #data[1] ]
			data[1][#data[1] + 1] = {
				prev[1] + 1,
				prev[2],			
			}
		end
		self.graphsFrame.graph.data = data
		self.graphsFrame.graph.vertical_data = v_data
		self.graphsFrame.graph:Reload()
		
		self.graphsFrame:ShowClick("TOPRIGHT")
		
		self.PullsFrame:Hide()
	end)
	
	self.graphsFrame = ELib:Popup(L.BossWatcherTabGraphics):Size(600,400)
	self.graphsFrame.graph = ExRT.lib.CreateGraph(self.graphsFrame,565,375,"TOPLEFT",30,-20,true)
	self.graphsFrame.graph:SetScript("OnLeave",function ()	GameTooltip_Hide() end)
	self.graphsFrame.graph.AddedOordLines = 1
	self.graphsFrame.graph.IsYIsTime = true
	
	self.onlyThisChar = ELib:Check(self,L.sencounterOnlyThisChar):Point(5,-30):OnClick(function(self,event) 
		module.db.chachedDB = nil
		if self:GetChecked() then
			module.db.onlyMy = true
		else
			module.db.onlyMy = nil
		end
		module.options.ScrollBar:SetValue(1)
		module.options.dropDown:SetValue(module.db.dropDownNow)
	end)	
	
	self.ScrollBar = ELib:ScrollBar(self.borderList):Size(16,self.borderList:GetHeight()-27):Point("TOPRIGHT",-4,-22):Range(1,1):OnChange(function(self,event)
		event = ExRT.F.Round(event)
		module.db.scrollPos = event
		module.options.dropDown:SetValue(module.db.dropDownNow)
		self:UpdateButtons()
	end)
	self.ScrollBar:SetScript("OnShow",function() 
		module.options.dropDown:SetValue(module.db.dropDownNow)
		module.options.ScrollBar:UpdateButtons() 
	end)
	
	self.clearButton = ELib:Button(self,L.MarksClear):Size(100,20):Point(330,-30):Tooltip(L.EncounterClear):OnClick(function() 
		StaticPopupDialogs["EXRT_ENCOUNTER_CLEAR"] = {
			text = L.EncounterClearPopUp,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				table.wipe(VExRT.Encounter.list)
				table.wipe(VExRT.Encounter.names)
				module.db.chachedDB = nil
				if module.options.ScrollBar:GetValue() == 1 then
					local func = module.options.ScrollBar:GetScript("OnValueChanged")
					func(module.options.ScrollBar,1)
				else
					module.options.ScrollBar:SetValue(1)
				end
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_ENCOUNTER_CLEAR")
	end) 

	self.dropDown:SetValue(#module.db.diffPos)
	
	self:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.ScrollBar:GetMinMaxValues()
		local val = self.ScrollBar:GetValue()
		if (val - delta) < min then
			self.ScrollBar:SetValue(min)
		elseif (val - delta) > max then
			self.ScrollBar:SetValue(max)
		else
			self.ScrollBar:SetValue(val - delta)
		end
	end)
end

local function DiffInArray(diff)
	for i=1,#module.db.diffPos do
		if module.db.diffPos[i] == diff then
			return true
		end
	end
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Encounter = VExRT.Encounter or {}
	VExRT.Encounter.list = VExRT.Encounter.list or {}
	VExRT.Encounter.names = VExRT.Encounter.names or {}
	
	if VExRT.Addon.Version < 2022 then
		local newTable = {}
		local newTableNames = {}
		for encID,encData in pairs(VExRT.Encounter.list) do
			local encHex = ExRT.F.tohex(encID,3)
			for diffID,diffData in pairs(encData) do
				if tonumber(diffID) then
					local diffHex = ExRT.F.tohex(diffID - 1)
					for _,pullData in pairs(diffData) do
						local pull = pullData.pull
						local long = "000"
						local kill = "0"
						local gs = format("%02d",pullData.gs or 0)
						if pullData.wipe then
							long = ExRT.F.tohex(pullData.wipe - pull,3)
						end
						if pullData.kill then
							long = ExRT.F.tohex(pullData.kill - pull,3)
							kill = "1"
						end
						local name = pullData.player or 0
						newTable[name] = newTable[name] or {}
						table.insert(newTable[name],encHex..diffHex..format("%010d",pull)..long..kill..gs..(pullData.fb or ""))
					end
				end
			end
			newTableNames[tonumber(encHex,16)] = encData.name or "Unknown"
		end
		VExRT.Encounter.list = newTable
		VExRT.Encounter.names = newTableNames
	end
	
	module.db.playerName = UnitName("player") or 0
	VExRT.Encounter.list[module.db.playerName] = VExRT.Encounter.list[module.db.playerName] or {}
	
	module:RegisterEvents('ENCOUNTER_START','ENCOUNTER_END')
end

--AAABCCCCCCCCCCDDDEFF
--
--AAA = encounterID [hex]
--B = diffID - 1 [hex]
--CCCCCCCCCC = pull UNIX time
--DDD - pull time [hex]
--E - kill (1) or wipe (0)
--FF - groupSize

function module.main:ENCOUNTER_START(encounterID, encounterName, difficultyID, groupSize)
	if not DiffInArray(difficultyID) or module.db.afterCombatFix then
		return
	end
	if not VExRT.Encounter.list[module.db.playerName] then
		VExRT.Encounter.list[module.db.playerName] = {}
	end
	module.db.isEncounter = encounterID
	module.db.diff = difficultyID
	module.db.pullTime = time()
	module.db.nowInTable = #VExRT.Encounter.list[module.db.playerName] + 1
	if difficultyID == 17 then	--LFR fix
		difficultyID = 7
	end
	VExRT.Encounter.list[module.db.playerName][module.db.nowInTable] = ExRT.F.tohex(encounterID,3)..ExRT.F.tohex(difficultyID-1)..format("%010d",module.db.pullTime).."0000"..format("%02d",groupSize or 0)
	VExRT.Encounter.names[encounterID] = encounterName
	module.db.firstBlood = nil
	module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
	
	module.db.chachedDB = nil
end

do
	local function ScheduledAfterCombatFix()
		module.db.afterCombatFix = nil
	end
	function module.main:ENCOUNTER_END(encounterID,_,_,_,success)
		if not module.db.isEncounter then
			return
		end
		if encounterID == module.db.isEncounter then
			local str = VExRT.Encounter.list[module.db.playerName][module.db.nowInTable]
			local time_ = min(time() - module.db.pullTime,4095)
			VExRT.Encounter.list[module.db.playerName][module.db.nowInTable] = string.sub(str,1,14) .. ExRT.F.tohex(time_,3) .. (success == 1 and "1" or "0") .. string.sub(str,19)
		end
		module.db.isEncounter = nil
		module.db.diff = nil
		module.db.nowInTable = nil
		module.db.afterCombatFix = true
		ExRT.F.ScheduleTimer(ScheduledAfterCombatFix, 5)
		module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		
		module.db.chachedDB = nil
	end
end

function module.main:COMBAT_LOG_EVENT_UNFILTERED(_,_,event,_,_,_,_,_,destGUID,destName,destFlags)
	if event == "UNIT_DIED" and destName and GetUnitInfoByUnitFlag(destFlags,1) == 1024 then
		if UnitIsFeignDeath(destName) then
			return
		end
		module.db.firstBlood = true
		VExRT.Encounter.list[module.db.playerName][module.db.nowInTable] = VExRT.Encounter.list[module.db.playerName][module.db.nowInTable] .. destName
		module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		
		module.db.chachedDB = nil
	end
end