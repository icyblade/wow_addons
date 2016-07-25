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

if ExRT.is7 then
	module.db.diffPos = {1,2,8,3,4,5,6,7,14,15,16}
end

module.db.chachedDB = nil

function module.options:Load()
	local table_find = ExRT.F.table_find3
	
	module.db.sortedList = {
		{764,1069,1070,1071,1073,1072},
		{690,1144,1145,1146},
		{756,1064,1065,1063,1062,1060,1081},
		{749,585,586,587,588,589,590,591,592},
		{761,1656,438,1659,1660,1661},
		{688,1667,1668,1669,1675,1676,1670,1671,1672},
		{692,547,548,549,551,552,553,554,1887},
		{691,379,378,380,381,382},
		{687,492,488,486,487,490,491,493},
		{760,1662,1663,1664,1665,1666},
		{762,444,446,447,448,449,450},
		{686,593,594,595,596,597,598,599,600},
		{721,267,268,269,270,271,272,274,273,275},
		{704,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245},
		{718,1084},
		{733,1919,1920,1921},
		{763,451,452,453,454,455,456,457,458,459,460,461,462,463},
		{697,785,784,786,787,788,789,790,791,792,793},
		{765,473,474,476,475,477,478,472,479,480,481,482,483,484,1885},
		{750,422,423,427,424,425,426,428,429},
		{680,1443,1444,1445,1446},
		{696,663,664,665,666,667,668,669,670,671,672},
		{699,343,344,345,346,350,347,348,349,361,362,363,364,365,366,367,368},
		{755,610,611,612,613,614,615,616,617},
		{717,718,719,720,721,722,723},
		{766,709,710,711,712,713,714,715,716,717},
		{799,652,653,654,655,656,657,658,659,660,661,662},
		{535,1107,1110,1116,1117,1112,1115,1113,1109,1121,1118,1111,1108,1120,1119,1114},
		{775,618,619,620,621,622},
		{710,1935,1936,1937,1938},
		{725,1922,1923,1924},
		{797,1891,1892,1893},
		{779,651},
		{727,1942,1943,1944},
		{726,1945,1946,1947,1948},
		{728,1939,1940,1941},
		{780,623,624,625,626,627,628},
		{782,730,731,732,733},
		{731,1913,1914,1915,1916},
		{729,1925,1926,1927,1928,1929},
		{730,1930,1931,1932,1933,1934},
		{724,1908,1909,1910,1911},
		{723,1902,1903,1904},
		{732,1899,1900,250,1901},
		{722,1889,1890},
		{734,1905,1906,1907},
		{796,601,602,603,604,605,606,607,608,609},
		{776,649,650},
		{781,1189,1190,1191,1192,1193,1194},
		{523,571,572,573,574,575,576},
		{524,577,579,578,581,580,582,583,584},
		{520,519,520,522,521,524,523,525,526,527},
		{528,528,530,529,532,531,533,534,535},
		{789,724,725,726,727,728,729},
		{798,1894,1895,1897,1898},
		{521,293,297,298,294,299,295,296,300},
		{526,563,565,564,567,566,568,569,570},
		{534,369,371,370,373,372,374,375,376},
		{533,216,264,265,217,218,266},
		{525,555,557,556,559,558,560,561,562},
		{529,1132,1136,1139,1142,1140,1137,1131,1135,1141,1164,1165,1166,1133,1138,1134,1143,1130},
		{530,383,385,384,386,387,388,390,389,391},
		{536,541,542,543,544,545,546},
		{531,1093,1092,1091,1090},
		{527,1094},
		{522,212,259,260,213,261,214,215,262,263},
		{532,1126,1127,1128,1129},
		{604,1101,1100,1099,1096,1104,1097,1102,1095,1103,1098,1105,1106},
		{601,829,831,830,832},
		{767,1045,1044,1046,1047},
		{759,1080,1076,1075,1077,1074,1079,1078},
		{753,1040,1038,1039,1037,1036},
		{543,1088,1087,1086,1089,1085},
		{542,334,336,338,339,340,341},
		{769,1043,1041,1042},
		{602,833,834,835,836,837,838},
		{603,842,841,840,839,843,844},
		{754,1027,1024,1022,1023,1025,1026},
		{757,1051,1050,1048,1049},
		{758,1030,1032,1028,1029,1082,1083},
		{800,1197,1204,1205,1206,1200,1185,1203},
		{609,1147,1149,1148,1150},
		{768,1056,1059,1058,1057},
		{773,1035,1034},
		{747,1052,1053,1054,1055},
		{752,1033,1250,1332},
		{793,1178,1179,1188,1180,1181,1182},
		{951,1563,1564,1571,1587},
		{820,1881,1882,1883,1884,1271},
		{816,1272,1273,1274},
		{819,1337,1340,1339},
		{877,1303,1304,1305,1306},
		{867,1418,1417,1416,1439},
		{876,1412,1413,1414},
		{875,1397,1405,1406,1419},
		{824,1292,1294,1295,1296,1297,1298,1291,1299},
		{885,1442,1509,1510,1441},
		{886,1409,1505,1506,1431},
		{871,1422,1421,1420},
		{874,1423,1424,1425},
		{898,1426,1427,1428,1429,1430},
		{896,1395,1390,1434,1436,1500,1407},
		{897,1507,1504,1463,1498,1499,1501},
		{887,1465,1502,1447,1464},
		{930,1577,1575,1570,1565,1578,1573,1572,1574,1576,1559,1560,1579,1580,1581},
		{1011,1755,1770,1801},
		{953,1602,1598,1624,1604,1622,1600,1606,1603,1595,1594,1599,1601,1593,1623,1605},
		{899,1918},
		{964,1655,1653,1652,1654},
		{969,1677,1688,1679,1682},
		{984,1686,1685,1678,1714},
		{987,1749,1748,1750,1754},
		{994,1721,1706,1720,1722,1719,1723,1705},
		{988,1696,1691,1693,1694,1689,1692,1690,1713,1695,1704},
		{993,1715,1732,1736},
		{989,1698,1699,1700,1701},
		{1080,1879,1880,1888,1917,1950,1951,1952,1953,1949},
		{1008,1746,1757,1751,1752,1756},
		{995,1761,1758,1759,1760,1762},
		{1026,1778,1785,1787,1798,1786,1783,1788,1794,1777,1800,1784,1795,1799},
		{1046,1810,1811,1812,1813,1814},
		{1065,1790,1791,1792,1793},
		{1067,1836,1837,1838,1839},
		{1041,1805,1806,1807,1808,1809},
		{1043,1822,1823,1824},
		{1045,1815,1850,1816,1817,1818},
		{1081,1832,1833,1834,1835},
		{1079,1825,1826,1827,1828,1829},
		{1094,1853,1841,1873,1854,1876,1877,1864},
		{1088,1849,1865,1867,1871,1862,1886,1842,1863,1872,1866},
		{1066,1845,1846,1847,1848,1851,1852,1855,1856},
		{1087,1868,1869,1870},
	}
	local LegacyDiffs = {
		[3]=true,
		[4]=true,
		[5]=true,
		[6]=true,
	}
	
	local function GetEncounterSortIndex(id,unk)
		for i=1,#module.db.sortedList do
			local dung = module.db.sortedList[i]
			for j=2,#dung do
				if id == dung[j] then
					return i * 100 + j
				end
			end
		end
		return unk
	end
	local function GetEncounterMapID(id)
		for i=1,#module.db.sortedList do
			local dung = module.db.sortedList[i]
			for j=2,#dung do
				if id == dung[j] then
					return dung[1]
				end
			end
		end
		return -999
	end

	self:CreateTilte()
	
	local function ConvertNumberToTime(num)
		local str = ""
		local s = num % 60
		num = floor(num / 60)
		local m = num % 60
		num = floor(num / 60)
		str = format("%d:%02d",m,s)
		if num == 0 then return str end
		local h = num % 24
		num = floor(num / 60)
		str = format("%d:%02d:%02d",h,m,s)
		if num == 0 then return str end
		return num .. "." .. str
	end

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
		
		local minPullTime = LegacyDiffs[ newDiff ] and 0 or 30
		
		if not module.db.chachedDB then
			for playerName,playerData in pairs(VExRT.Encounter.list) do
				if not module.db.onlyMy or playerName == module.db.playerName then
					
					for i=1,#playerData do
						local data = playerData[i]
						local isNewFormat = data:find("^%^")
						local diffID
						if isNewFormat then
							diffID = tonumber( select (3, strsplit("^",data) ), nil )
						else
							diffID = tonumber( string.sub(data,4,4),16 ) + 1
						end
						if diffID == newDiff then
							local encounterID, pull, pullTime, isKill, groupSize, firstBloodName, raidIlvl, _
						
							if isNewFormat then
								_, encounterID, _, pull, pullTime, isKill, groupSize, raidIlvl, firstBloodName = strsplit("^", data)
								encounterID = tonumber(encounterID)
								pull = tonumber(pull)
								pullTime = tonumber(pullTime)
								isKill = isKill == "1"
								groupSize = tonumber(groupSize)
							else
								encounterID = tonumber( string.sub(data,1,3),16 )
								pull = tonumber( string.sub(data,5,14),nil )
								pullTime = tonumber( string.sub(data,15,17),16 )
								isKill = string.sub(data,18,18) == "1"
								groupSize = tonumber(string.sub(data,19,20),nil)
								firstBloodName = string.sub(data,21)							
							end
							raidIlvl = tonumber(raidIlvl or "0")
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
									mapID = GetEncounterMapID(encounterID),
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
								if not pullTime or pullTime > minPullTime or pullTime == 0 then
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
								fb = firstBloodName,
								i = raidIlvl,
							}
						end
					end			
				end
			end
		
			--sort(encounters,function(a,b) return a.first > b.first end)
			sort(encounters,function(a,b) return GetEncounterSortIndex(a.id,a.first) > GetEncounterSortIndex(b.id,b.first) end)
			
			for _,encounterData in pairs(encounters) do
				sort(encounterData.firstBlood,function(a,b) return a.c > b.c end)
				sort(encounterData.pullTable,function(a,b) return a.t < b.t end)
				
				
				local totalTime,isFK = 0
				-- redo firstkill counter, cuz exist error if you kill boss on another char
				for i=1,#encounterData.pullTable do
					if not isFK and encounterData.pullTable[i].k then
						encounterData.firstKill = i
						isFK = true
					end
					totalTime = totalTime + (encounterData.pullTable[i].d or 0)
				end
				
				if not encounterData.killTime or encounterData.killTime == 4095 then
					encounterData.killTime = 0
				end
				encounterData.wipeTime = encounterData.wipeTime or 0
				encounterData.wipeTime = totalTime
			end
			
			local prev = nil
			for i=#encounters,1,-1 do
				local eLine = encounters[i]
				if not prev then
					prev = eLine.mapID
				end
				if prev ~= eLine.mapID or i==1 then
					local name = GetMapNameByID(prev or -999)
					if name then
						tinsert(encounters,i==1 and 1 or i+1,{
							isHeader = true,
							name = name,
						})
					end
					prev = eLine.mapID
				end
			end
			
		end
		
		module.db.chachedDB = encounters
			
		local j = 0
		for i=module.db.scrollPos,#encounters do
			j = j + 1
			local encounterLine = encounters[i]
			local optionsLine = module.options.line[j]
		
			if encounterLine.isHeader then
				optionsLine.headertext:SetText(encounterLine.name)
				optionsLine.boss:SetText("")
				optionsLine.wipeBK:SetText("")
				optionsLine.wipe:SetText("")
				optionsLine.kill:SetText("")
				optionsLine.firstBlood:SetText("")
				optionsLine.longest:SetText("")
				optionsLine.fastest:SetText("")
				
				optionsLine.headerHL:Show()
				optionsLine.pullClick:Hide()
				optionsLine.firstBloodB:Hide()
			else
				optionsLine.headertext:SetText("")
				optionsLine.boss:SetText(encounterLine.name)
				optionsLine.wipeBK:SetText(encounterLine.firstKill or "-")
				optionsLine.wipe:SetText(encounterLine.pulls)
				optionsLine.kill:SetText(encounterLine.kills)
				optionsLine.firstBlood:SetText(encounterLine.firstBlood[1] and encounterLine.firstBlood[1].n or "")
				optionsLine.longest:SetText(ConvertNumberToTime(encounterLine.wipeTime))
				optionsLine.fastest:SetText(date("%M:%S",encounterLine.killTime))
				if encounterLine.wipeTime == 0 then optionsLine.longest:SetText("-") end
				if encounterLine.killTime == 0 then optionsLine.fastest:SetText("-") end
				
				optionsLine.firstBloodB.n = encounterLine.firstBlood
				optionsLine.pullClick.n = encounterLine.pullTable
				optionsLine.pullClick.bossName = encounterLine.name or ""
				
				optionsLine.headerHL:Hide()
				optionsLine.pullClick:Show()
				optionsLine.firstBloodB:Show()
			end
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
	self.borderList.decorationLine.texture:SetColorTexture(1,1,1,1)
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
		self.line[i].headertext = ELib:Text(self.line[i],"",11):Point("LEFT",0,0):Point("RIGHT",0,0):Center():Color()
		
		if i>0 then
			ExRT.lib.CreateHoverHighlight(self.line[i])
			self.line[i].hl:SetVertexColor(0.3,0.3,0.7,0.7)
			self.line[i]:SetScript("OnEnter",LineOnEnter)
			self.line[i]:SetScript("OnLeave",LineOnLeave)	
			
			ExRT.lib.CreateHoverHighlight(self.line[i],"headerHL",1)
			self.line[i].headerHL:SetVertexColor(0.6,0.6,0.6,0.7)
		
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
	self.line[0].longest:SetText(L.EncounterAllTime)
	self.line[0].fastest:SetText(L.sencounterKillTime)
	
	do
		local wipeBK = CreateFrame("Frame",nil,self.borderList)
		wipeBK:SetAllPoints(self.line[0].wipeBK)
		wipeBK:SetScript("OnEnter",function(self)
			ELib.Tooltip.Show(self,nil,L.EncounterFirstKillTooltip)
		end)
		wipeBK:SetScript("OnLeave",function()
			GameTooltip_Hide()
		end)
		
		local pulls = CreateFrame("Frame",nil,self.borderList)
		pulls:SetAllPoints(self.line[0].wipe)
		pulls:SetScript("OnEnter",function(self)
			ELib.Tooltip.Show(self,nil,L.EncounterPullsTooltip)
		end)
		pulls:SetScript("OnLeave",function()
			GameTooltip_Hide()
		end)
		
		local longest = CreateFrame("Frame",nil,self.borderList)
		longest:SetAllPoints(self.line[0].longest)
		longest:SetScript("OnEnter",function(self)
			ELib.Tooltip.Show(self,nil,L.EncounterAllTimeTooltip)
		end)
		longest:SetScript("OnLeave",function()
			GameTooltip_Hide()
		end)
		
		local fastest = CreateFrame("Frame",nil,self.borderList)
		fastest:SetAllPoints(self.line[0].fastest)
		fastest:SetScript("OnEnter",function(self)
			ELib.Tooltip.Show(self,nil,L.EncounterFastKillTooltip)
		end)
		fastest:SetScript("OnLeave",function()
			GameTooltip_Hide()
		end)		
	end
	
	self.FBframe = ELib:Popup():Size(150,97)
	
	self.FBframe.txtR = {}
	self.FBframe.txtL = {}
	for i=1,5 do
		self.FBframe.txtL[i] = ELib:Text(self.FBframe,"nam1",11):Size(100,14):Point(10,-6-14*i):Color()
		self.FBframe.txtR[i] = ELib:Text(self.FBframe,"123",11):Size(40,14):Point("TOPRIGHT",-10,-6-14*i):Color()
	end	
	
	self.PullsFrame = ELib:Popup():Size(330,247)
	
	self.PullsFrame.txtL = {}
	for i=1,16 do
		self.PullsFrame.txtL[i] = ELib:Text(self.PullsFrame,"",11):Size(305,14):Point(5,-6-14*i):Color()
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
					module.options.PullsFrame.txtL[j]:SetText(date("%d.%m.%Y %H:%M:%S",data[i].t)..(data[i].d > 0 and " ["..date("%M:%S",data[i].d).."]" or "")..(data[i].k and " (kill) " or "")..((data[i].s > 0 and module.db.diffPos[module.db.dropDownNow or 0] ~= 16) and " GS:"..data[i].s or "")..(data[i].i > 0 and " ilvl:"..data[i].i or ""))
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
	
	self.exportButton = ELib:Button(self,L.Export):Size(100,20):Point("RIGHT",self.clearButton,"LEFT",-5,0):OnClick(function() 
		local allData = {}
		for _,encounterData in pairs(module.db.chachedDB) do
			if encounterData.pullTable then
				for i=1,#encounterData.pullTable do
					local pull = encounterData.pullTable[i]
					
					local resultString = date("%d.%m.%Y %H:%M:%S",pull.t).."\t"..encounterData.name.."\t"..(pull.d > 0 and date("%M:%S",pull.d) or "").."\t"..(pull.k and "Kill" or "").."\t"..(pull.fb or "")
					
					allData[#allData + 1] = {
						t = pull.t,
						s = resultString,
					}
				end
			end
		end
		sort(allData,function(a,b) return a.t<b.t end)
		local text = ""
		for i=1,#allData do
			text = text .. allData[i].s .. "\n"
		end
		ExRT.F:Export(text)
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
	if ExRT.is7 then
		module:RegisterEvents('BOSS_KILL')
	end
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
	
	VExRT.Encounter.list[module.db.playerName][module.db.nowInTable] = 
		"^".. encounterID .. "^" .. difficultyID .. "^" .. module.db.pullTime .. "^0^0^" .. (groupSize or 0) .. "^" .. format("%.2f",ExRT.F.RaidItemLevel and ExRT.F:RaidItemLevel() or 0) .. "^"
	
	VExRT.Encounter.names[encounterID] = encounterName
	module.db.firstBlood = nil
	module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
	
	module.db.chachedDB = nil
end

do
	local function ScheduledAfterCombatFix()
		module.db.afterCombatFix = nil
	end
	function module.main:ENCOUNTER_END(encounterID,_,_,_,success,isBossKillEvent)
		if not module.db.isEncounter then
			return
		end
		if encounterID == module.db.isEncounter then
			local currTime = time()
			if isBossKillEvent then
				currTime = currTime - 3
			end
			local pullTime = currTime - module.db.pullTime
			
			local _,encounterID,difficultyID,pull,_,_,groupSize,raidIlvl,fb = strsplit("^", VExRT.Encounter.list[module.db.playerName][module.db.nowInTable])
			
			VExRT.Encounter.list[module.db.playerName][module.db.nowInTable] = 
				"^".. encounterID .. "^" .. difficultyID .. "^" .. pull .. "^".. pullTime .."^"..(success == 1 and "1" or "0").."^" .. groupSize .. "^" .. raidIlvl .. "^".. fb
			
		end
		module.db.isEncounter = nil
		module.db.diff = nil
		module.db.nowInTable = nil
		module.db.afterCombatFix = true
		ExRT.F.ScheduleTimer(ScheduledAfterCombatFix, 5)
		module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		
		module.db.chachedDB = nil
	end
	function module.main:BOSS_KILL(encounterID)		--08.03.2016: ENCOUNTER_END not fired in 5ppl, but boss_kill only for kills
		if select(2,GetInstanceInfo()) == 'raid' then	--Not needed in raids
			return
		end
		ExRT.F.Timer(module.main.ENCOUNTER_END, 3, module.main, encounterID, 0, 0, 0, 1, true)
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