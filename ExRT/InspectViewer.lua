local GlobalAddonName, ExRT = ...

local VExRT = nil

local parentModule = ExRT.A.Inspect
if not parentModule then
	return
end
local module = ExRT.mod:New("InspectViewer",ExRT.L.InspectViewer,nil,true)
local ELib,L = ExRT.lib,ExRT.L

module.db.inspectDB = parentModule.db.inspectDB
module.db.inspectDBAch = parentModule.db.inspectDBAch
module.db.inspectQuery = parentModule.db.inspectQuery
module.db.specIcons = ExRT.A.ExCD2 and ExRT.A.ExCD2.db.specIcons
module.db.itemsSlotTable = parentModule.db.itemsSlotTable
module.db.classIDs = ExRT.GDB.ClassID
module.db.glyphsIDs = ExRT.is7 and {8,9,10,11,12,13} or {9,11,13,10,8,12}

module.db.statsList = {'intellect','agility','strength','spirit','haste','mastery','crit','spellpower','multistrike','versatility','armor','leech','avoidance','speed'}
module.db.statsListName = {L.InspectViewerInt,L.InspectViewerAgi,L.InspectViewerStr,L.InspectViewerSpirit,L.InspectViewerHaste,L.InspectViewerMastery,L.InspectViewerCrit,L.InspectViewerSpd, L.InspectViewerMS, L.InspectViewerVer, L.InspectViewerBonusArmor, L.InspectViewerLeech, L.InspectViewerAvoidance, L.InspectViewerSpeed}

module.db.baseStats = ExRT.isLegionContent and {	--By class IDs
	strength =  {	10232,	10232,	6231,	8481,	5929,	10232,	4042,	4550,	3875,	4402,	4042,	8481,	},
	agility =   {	6252,	3200,	9030,	9030,	7504,	7532,	9030,	6252,	6927,	9030,	9030,	9030,	},
	intellect = {	5000,	7328,	6006,	5000,	7328,	4002,	7328,	7328,	7328,	7328,	7328,	5000,	},
	spirit =    {	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	},
		--	WARRIOR,PALADIN,HUNTER,	ROGUE,	PRIEST,	DK,	SHAMAN,	MAGE,	WARLOCK,MONK,	DRUID,	DH,
} or { --By class IDs
	agility = {889,455,1284,1284,1067,1071,1284,889,985,1284,1284,0},
	strength = {1455,1455,886,1206,843,1455,626,647,551,626,626,0},
	spirit = {679,782,711,533,782,640,782,1155,1155,782,782,0},
	intellect = {711,1042,854,711,1042,569,1042,1042,1042,1042,1042,0},
}
module.db.raceList = {'Human','Dwarf','Night Elf','Orc','Tauren','Undead','Gnome','Troll','Blood Elf','Draenei','Goblin','Worgen','Pandaren'}
module.db.raceStatsDiffs = {
	strength =  {	0,	5,	-4,	3,	5,	-1,	-5,	1,	-3,	1,	-3,	3,	0,	},
	agility =   {	0,	-4,	4,	-3,	-4,	-2,	2,	2,	2,	-3,	2,	2,	-2,	},
	intellect = {	0,	-1,	0,	-3,	-4,	-2,	3,	-4,	3,	0,	3,	-4,	-1,	},
	spirit =    {	0,	-1,	0,	2,	2,	5,	0,	1,	-2,	2,	-2,	-1,	2,	},
		--	Human,	Dwarf,	NElf,	Orc,	Tauren,	Undead,	Gnome,	Troll,	BElf,	Draenei,Goblin,	Worgen,	Pandaren
}

module.db.statsMultiplayBySpec = ExRT.is7 and {} or {
	[62] = 'mastery',
	[63] = 'crit',
	[64] = 'multistrike',
	[65] = 'crit',
	[66] = 'haste',
	[70] = 'mastery',
	[71] = 'mastery',
	[72] = 'crit',
	[73] = 'mastery',
	[102] = 'mastery',
	[103] = 'crit',
	[104] = 'mastery',
	[105] = 'haste',
	[250] = 'multistrike',
	[251] = 'haste',
	[252] = 'multistrike',
	[253] = 'mastery',
	[254] = 'crit',
	[255] = 'multistrike',
	[256] = 'crit',
	[257] = 'multistrike',
	[258] = 'haste',
	[259] = 'mastery',
	[260] = 'haste',
	[261] = 'multistrike',
	[262] = 'multistrike',
	[263] = 'haste',
	[264] = 'mastery',
	[265] = 'haste',
	[266] = 'mastery',
	[267] = 'crit',
	[268] = 'crit',
	[269] = 'multistrike',
	[270] = 'multistrike',
}

module.db.armorType = ExRT.GDB.ClassArmorType
module.db.roleBySpec = ExRT.GDB.ClassSpecializationRole

module.db.specHasOffhand = {
	[71]=true,
	[72]=true,
	[251]=true,
	[252]=true,
	[259]=true,
	[260]=true,
	[261]=true,
	[263]=true,
	[268]=true,
	[269]=true,
	[577]=true,
	[581]=true,
}

module.db.socketsBonusIDs = {
	[563]=true,
	[564]=true,
	[565]=true,
	[572]=true,
}

module.db.topEnchGems = {
	[5306]="Ring:Vers",
	[5324]="Ring:Crit",
	[5325]="Ring:Haste",
	[5326]="Ring:Mastery",
	[5327]="Ring:MS",
	[5328]="Ring:Vers",
	
	[5310]="Cloak:Crit",
	[5311]="Cloak:Haste",
	[5312]="Cloak:Mastery",
	[5313]="Cloak:MS",
	[5314]="Cloak:Vers",
	
	[5317]="Neck:Crit",
	[5318]="Neck:Haste",
	[5319]="Neck:Mastery",
	[5320]="Neck:MS",
	[5321]="Neck:Vers",

	[5330]="Weapon:Crit",
	[5334]="Weapon:MS",
	[5335]="Weapon:Spirit",
	[5336]="Weapon:Armor",
	[5337]="Weapon:Haste",
	[5384]="Weapon:Mastery",
	[5383]="Gun:Mastery",
	[5276]="Gun:Crit",
	[5275]="Gun:MS",
	[3366]="Weapon:DK",
	[3367]="Weapon:DK",
	[3368]="Weapon:DK",
	[3370]="Weapon:DK",

	--[5346]="Gem:Crit",
	--[5347]="Gem:Haste",
	--[5348]="Gem:Mastery",
	--[5349]="Gem:MS",
	--[5350]="Gem:Vers",
	--[5351]="Gem:Stamina",
	
	[5413]="Gem:Crit",
	[5414]="Gem:Haste",
	[5415]="Gem:Mastery",
	[5416]="Gem:MS",
	[5417]="Gem:Vers",
	[5418]="Gem:Stamina",
}

module.db.achievementsList = {
	{	--HFC
		L.RaidLootT18HC..":"..L.sencounterWODMythic,		
		10027,10032,10033,10034,10035,10253,10037,10040,10041,10038,10039,10042,10043,	
	},{
		L.RaidLootT18HC,
		10023,10024,10025,10020,10019,10044,
	},{	--BRF
		L.RaidLootT17BF..":"..L.sencounterWODMythic,		
		8966,8967,8970,8968,8932,8971,8956,8969,8972,8973,
	},{
		L.RaidLootT17BF,
		8989,8990,8991,8992,9444,
	},{	--H
		L.RaidLootT17Highmaul..":"..L.sencounterWODMythic,		
		8949,8960,8962,8961,8963,8964,8965,
	},{
		L.RaidLootT17Highmaul,
		8986,8987,8988,9441,
	},{	--Old curves
		EXPANSION_NAME4,
		6954,7485,8246,7486,8248,7487,8249,8238,8260,8398,8400,8399,8401
	},
}
module.db.achievementsList_statistic = {
	{	--HFC
		{10201,10202,10203,10204},{10205,10206,10207,10208},{10209,10210,10211,10212},{10213,10214,10215,10216},{10217,10218,10219,10220},{10221,10222,10223,10224},{10225,10226,10227,10228},
		{10229,10230,10231,10232},{10241,10242,10243,10244},{10233,10234,10235,10236},{10237,10238,10239,10240},{10245,10246,10247,10248},{10249,10250,10251,10252},
	},{
		{-10201,-10202,-10203,-10205,-10206,-10207,-10209,-10210,-10211},{-10213,-10214,-10215,-10217,-10218,-10219,-10221,-10222,-10223},
		{-10225,-10226,-10227,-10229,-10230,-10231,-10241,-10242,-10243},{-10233,-10234,-10235,-10237,-10238,-10239,-10245,-10246,-10247},{-10249,-10250,-10251},{-10251,-10252},
	},{	--BRF
		{9316,9317,9318,9319},{9320,9321,9322,9323},{9343,9349,9351,9353},{9324,9327,9328,9329},{9330,9331,9332,9333},
		{9354,9355,9356,9357},{9334,9336,9337,9338},{9339,9340,9341,9342},{9358,9359,9360,9361},{9362,9363,9364,9365},
	},{
		{-9316,-9317,-9318,-9320,-9321,-9322,-9343,-9349,-9351},{-9324,-9327,-9328,-9330,-9331,-9332,-9354,-9355,-9356},{-9334,-9336,-9337,-9339,-9340,-9341,-9358,-9359,-9360},{-9362,-9363,-9364},{-9364,-9365},
	},{	--H
		{9280,9282,9284,9285},{9286,9287,9288,9289},{9295,9297,9298,9300},{9290,9292,9293,9294},{9301,9302,9303,9304},{9306,9308,9310,9311},{9312,9313,9314,9315},
	},{
		{-9280,-9282,-9284,-9286,-9287,-9288,-9295,-9297,-9298},{-9290,-9292,-9293,-9301,-9302,-9303,-9306,-9308,-9310},{-9312,-9313,-9314},{-9314,-9315},
	},{	--Old curves
		{6799,7926},{6800,7927},{6811,7963},{6812,7964},{6819,7971},{6820,7972},{8199,8200},{8202,8201},{8203,8256},{8635},{8637},{8636},{8638},
	},
}

do
	local array = parentModule.db.acivementsIDs
	for i=1,#module.db.achievementsList do
		local from = module.db.achievementsList[i]
		for j=2,#from do
			array[#array + 1] = from[j]
		end
		
		local from = module.db.achievementsList_statistic[i]
		for j=1,#from do
			if from[j] then
				for k=1,#from[j] do
					local id = from[j][k]
					if id > 0 then
						array[#array + 1] = -id
					elseif id < 0 then
						from[j][k] = -id
					end
				end
			end
		end
	end
	--ELib:Frame(UIParent):SetScript('OnUpdate',function()local q=GetMouseFocus()if not q or not q.id then DInfo'nil' return end DInfo(q.id)end)
end

module.db.perPage = 18
module.db.page = 1

module.db.filter = nil
module.db.filterType = nil

module.db.colorizeNoEnch = true
module.db.colorizeLowIlvl = true
module.db.colorizeNoGems = true
module.db.colorizeNoTopEnchGems = false
module.db.colorizeLowIlvl685 = false
module.db.colorizeNoValorUpgrade = false

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.InspectViewer = VExRT.InspectViewer or {}
	--if VExRT.InspectViewer.enabled and (not VExRT.ExCD2 or not VExRT.ExCD2.enabled) then module:Enable() end
	
	if VExRT.Addon.Version < 3580 then
		VExRT.InspectViewer.ColorizeNoEnch = true
		VExRT.InspectViewer.ColorizeLowIlvl = true
		VExRT.InspectViewer.ColorizeNoGems = true
		VExRT.InspectViewer.ColorizeNoTopEnchGems = false
		VExRT.InspectViewer.ColorizeLowIlvl685 = false
		VExRT.InspectViewer.ColorizeNoValorUpgrade = false
	end
	
	module:RegisterSlash()
end

function module.main:INSPECT_READY()
	module.options.UpdatePage_InspectEvent()
end

function module:Enable()
	parentModule:RegisterTimer()
	parentModule:RegisterEvents('GROUP_ROSTER_UPDATE','INSPECT_READY','UNIT_INVENTORY_CHANGED','PLAYER_EQUIPMENT_CHANGED')
	parentModule.main:GROUP_ROSTER_UPDATE()
end

function module:Disable()
	if not VExRT or not VExRT.ExCD2 or not VExRT.ExCD2.enabled then
		parentModule:UnregisterTimer()
		parentModule:UnregisterEvents('GROUP_ROSTER_UPDATE','INSPECT_READY','UNIT_INVENTORY_CHANGED','PLAYER_EQUIPMENT_CHANGED')
	end
end

function module.options:Load()
	self:CreateTilte()

	local function reloadChks(self)
		local clickID = self.id
		self:SetChecked(true)
		module.options.achievementsDropDown:Hide()
		module.options.filterDropDown:Show()
		module.options.chkAchivs.text:Show()
		if clickID == 1 then
			module.options.chkTalents:SetChecked(false)
			module.options.chkInfo:SetChecked(false)
			module.options.chkAchivs:SetChecked(false)
		elseif clickID == 2 then
			module.options.chkItems:SetChecked(false)
			module.options.chkInfo:SetChecked(false)
			module.options.chkAchivs:SetChecked(false)
		elseif clickID == 3 then
			module.options.chkItems:SetChecked(false)
			module.options.chkTalents:SetChecked(false)
			module.options.chkAchivs:SetChecked(false)
		elseif clickID == 4 then
			module.options.chkItems:SetChecked(false)
			module.options.chkTalents:SetChecked(false)
			module.options.chkInfo:SetChecked(false)

			module.options.achievementsDropDown:Show()
			module.options.filterDropDown:Hide()
			module.options.chkAchivs.text:Hide()
		end
		module.db.page = clickID
		module.options.showPage()
	end
	
	self.chkItems = ELib:Radio(self,L.InspectViewerItems,true):Point(10,-28):OnClick(reloadChks)
	self.chkItems.id = 1
	
	self.chkTalents = ELib:Radio(self,L.InspectViewerTalents):Point(135,-28):OnClick(reloadChks)
	self.chkTalents.id = 2

	self.chkInfo = ELib:Radio(self,L.InspectViewerInfo):Point(260,-28):OnClick(reloadChks)
	self.chkInfo.id = 3

	self.chkAchivs = ELib:Radio(self,ACHIEVEMENTS):Point(385,-28):OnClick(reloadChks)
	self.chkAchivs.id = 4
	
	local function ItemsTrackDropDownClick(self)
		local f = self.checkButton:GetScript("OnClick")
		self.checkButton:SetChecked(not self.checkButton:GetChecked())
		f(self.checkButton)
	end
	
	module.db.colorizeNoEnch = VExRT.InspectViewer.ColorizeNoEnch
	module.db.colorizeLowIlvl = VExRT.InspectViewer.ColorizeLowIlvl
	module.db.colorizeNoGems = VExRT.InspectViewer.ColorizeNoGems
	module.db.colorizeNoTopEnchGems = VExRT.InspectViewer.ColorizeNoTopEnchGems
	module.db.colorizeLowIlvl685 = VExRT.InspectViewer.ColorizeLowIlvl685
	module.db.colorizeNoValorUpgrade = VExRT.InspectViewer.ColorizeNoValorUpgrade
	
	self.chkItemsTrackDropDown = ELib:DropDown(self,300,7):Point(50,0):Size(50)
	self.chkItemsTrackDropDown:Hide()
	self.chkItemsTrackDropDown.List = {
		{text = L.InspectViewerColorizeNoEnch,checkable = true,checkState = module.db.colorizeNoEnch, checkFunc = function(self,checked) 
			module.db.colorizeNoEnch = checked
			VExRT.InspectViewer.ColorizeNoEnch = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = L.InspectViewerColorizeNoGems,checkable = true,checkState = module.db.colorizeNoGems, checkFunc = function(self,checked) 
			module.db.colorizeNoGems = checked
			VExRT.InspectViewer.ColorizeNoGems = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = format(L.InspectViewerColorizeLowIlvl,630),checkable = true,checkState = module.db.colorizeLowIlvl, checkFunc = function(self,checked) 
			module.db.colorizeLowIlvl = checked
			VExRT.InspectViewer.ColorizeLowIlvl = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = L.InspectViewerColorizeNoTopEnch,checkable = true,checkState = module.db.colorizeNoTopEnchGems, checkFunc = function(self,checked) 
			module.db.colorizeNoTopEnchGems = checked
			VExRT.InspectViewer.ColorizeNoTopEnchGems = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = format(L.InspectViewerColorizeLowIlvl,685),checkable = true,checkState = module.db.colorizeLowIlvl685, checkFunc = function(self,checked) 
			module.db.colorizeLowIlvl685 = checked
			VExRT.InspectViewer.ColorizeLowIlvl685 = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = L.InspectViewerColorizeNoValorUpgrade,checkable = true,checkState = module.db.colorizeNoValorUpgrade, checkFunc = function(self,checked)
			module.db.colorizeNoValorUpgrade = checked
			VExRT.InspectViewer.ColorizeNoValorUpgrade = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = L.minimapmenuclose,checkable = false, padding = 16, func = function()
			ELib:DropDownClose()
		end},
	}
	
	self.chkItemsTrack = ELib:Template("ExRTTrackingButtonModernTemplate",self)  
	self.chkItemsTrack:SetPoint("TOPLEFT", 130, -28)
	self.chkItemsTrack:SetScale(.8)
	self.chkItemsTrack.Button:SetScript("OnClick",function (this)
		if ExRT.lib.ScrollDropDown.DropDownList[1]:IsShown() then
			ELib:DropDownClose()
		else
			ExRT.lib.ScrollDropDown.ToggleDropDownMenu(module.options.chkItemsTrackDropDown)
		end
	end)
	self.chkItemsTrackDropDown:ClearAllPoints()
	self.chkItemsTrackDropDown:SetPoint("CENTER",self.chkItemsTrack,0,0)
	self.chkItemsTrackDropDown.toggleX = -32
	
	self:SetScript("OnHide",function() ELib:DropDownClose() end)
	
	local dropDownTable = {
		[1] = {
			ExRT.GDB.ClassList,
		},
		[2] = {
			{"CLOTH","LEATHER","MAIL","PLATE"},
			{L.InspectViewerTypeCloth,L.InspectViewerTypeLeather,L.InspectViewerTypeMail,L.InspectViewerTypePlate},
		},
		[3] = {
			{"TANK","HEAL","MELEE-RANGE","MELEE","RANGE"},
			{TANK,HEALER,DAMAGER,MELEE,RANGED},
		},
		[4] = {
			{"PALADIN_PRIEST_WARLOCK_DEMONHUNTER","ROGUE_DEATHKNIGHT_MAGE_DRUID","WARRIOR_HUNTER_SHAMAN_MONK"},
		},
	}
	
	self.filterDropDown = ELib:DropDown(self,250,6):Point(504,-25):Size(150):SetText(L.InspectViewerFilter)
	
	local EQUIPMENT_SETS_Fixed = EQUIPMENT_SETS or "EQUIPMENT SETS"
	if EQUIPMENT_SETS_Fixed:find(":") then
		EQUIPMENT_SETS_Fixed = EQUIPMENT_SETS_Fixed:gsub(":.+$","")
	else
		EQUIPMENT_SETS_Fixed = EQUIPMENT_SETS_Fixed:gsub("%%s","")
	end
	
	self.filterDropDown.List = {
		{text = L.InspectViewerClass, subMenu = {}},
		{text = L.InspectViewerType, subMenu = {}},
		{text = ROLE, subMenu = {}},
		{text = EQUIPMENT_SETS_Fixed, subMenu = {}},
		{text = L.InspectViewerHideInRaid,checkable = true, checkState = VExRT.InspectViewer.HideNotInRaid, checkFunc = function(self,checked) 
			VExRT.InspectViewer.HideNotInRaid = checked
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
		end, func = ItemsTrackDropDownClick},
		{text = L.InspectViewerClear,func = function (self)
			module.db.filter = nil
			module.db.filterType = nil
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
			module.options.filterDropDown:SetText(L.InspectViewerFilter)
		end},
	}
	for i=1,#dropDownTable[1][1] do
		self.filterDropDown.List[1].subMenu[i] = {text = L.classLocalizate[ dropDownTable[1][1][i] ],func = function (self,arg1)
			module.db.filter = arg1
			module.db.filterType = 1
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
			module.options.filterDropDown:SetText(L.InspectViewerFilterShort.. L.classLocalizate[ arg1 ] )
		end, arg1 = dropDownTable[1][1][i]}
	end
	for i=1,#dropDownTable[2][1] do
		self.filterDropDown.List[2].subMenu[i] = {text = dropDownTable[2][2][i],func = function (self,arg1,arg2)
			module.db.filter = arg1
			module.db.filterType = 2
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
			module.options.filterDropDown:SetText(L.InspectViewerFilterShort.. arg2 )
		end, arg1 = dropDownTable[2][1][i], arg2 = dropDownTable[2][2][i]}
	end
	for i=1,#dropDownTable[3][1] do
		self.filterDropDown.List[3].subMenu[i] = {text = dropDownTable[3][2][i],func = function (self,arg1,arg2)
			module.db.filter = arg1
			module.db.filterType = 3
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
			module.options.filterDropDown:SetText(L.InspectViewerFilterShort.. arg2 )
		end, arg1 = dropDownTable[3][1][i], arg2 = dropDownTable[3][2][i]}
	end
	for i=1,#dropDownTable[4][1] do
		local text = ""
		for className,_ in pairs(module.db.classIDs) do
			if dropDownTable[4][1][i]:find(className) then
				text = text..(text ~= "" and ", " or "")..L.classLocalizate[ className ]
			end
		end
		self.filterDropDown.List[4].subMenu[i] = {text = text,func = function (self,arg1)
			module.db.filter = arg1
			module.db.filterType = 4
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
			module.options.filterDropDown:SetText(L.InspectViewerFilterShort.. text )
		end, arg1 = dropDownTable[4][1][i]}
	end
	
	module.db.achievementList = 2
	self.achievementsDropDown = ELib:DropDown(self,330,#module.db.achievementsList + 2):Point(405,-25):Size(249):SetText(ACHIEVEMENT_FILTER_TITLE)
	self.achievementsDropDown:Hide()
	self.achievementsDropDown.List = {}
	for i=1,#module.db.achievementsList do
		self.achievementsDropDown.List[i] = {text = module.db.achievementsList[i][1],func = function (self)
			module.db.achievementList = i
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
		end}
	end
	self.achievementsDropDown.List[ #self.achievementsDropDown.List + 1 ] = {text = ENABLE,checkable = true, checkState = VExRT.InspectViewer.EnableA4ivs, checkFunc = function(self,checked) 
		VExRT.InspectViewer.EnableA4ivs = checked
	end, func = ItemsTrackDropDownClick}
	self.achievementsDropDown.List[ #self.achievementsDropDown.List + 1 ] = {text = L.minimapmenuclose,checkable = false,func = function()
		ELib:DropDownClose()
	end}
	
		
	self.borderList = CreateFrame("Frame",nil,self)
	self.borderList:SetSize(648,module.db.perPage*30)
	self.borderList:SetPoint("TOP", 0, -50)
	ELib:Border(self.borderList,2,.24,.25,.30,1)
	
	self.borderList:SetScript("OnMouseWheel",function (self,delta)
		if delta > 0 then
			module.options.ScrollBar.buttonUP:Click("LeftButton")
		else
			module.options.ScrollBar.buttonDown:Click("LeftButton")
		end
	end)
	
	self.ScrollBar = ELib:ScrollBar(self.borderList):Size(16,0):Point("TOPRIGHT",-3,-3):Point("BOTTOMRIGHT",-3,3):Range(1,20)
	
	local function IsItemHasNotGem(link)
		if link then
			local gem = link:match("item:%d+:[0-9%-]*:([0-9%-]*):")
			if gem == "0" then
				return true
			end
		end
	end
	
	local function IsTopEnchAndGems(link)
		if link then
			local ench,gem = link:match("item:%d+:([0-9%-]*):([0-9%-]*):")
			if ench and gem then
				local isTop = true
				if ench ~= "0" then
					ench = tonumber(ench)
					if not module.db.topEnchGems[ench] then
						isTop = false
					end
				end
				if gem ~= "0" then
					gem = tonumber(gem)
					if not module.db.topEnchGems[gem] then
						isTop = false
					end
				end
				return isTop
			end
		end
	end
	
	local function IsValorUpgraded(link)
		if link then
			local isUpgraded = true
			local upgradeType,linkRest = link:match("item:%d+:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:[0-9%-]*:([0-9%-]*):[0-9%-]*:([%d:]+)")
			if upgradeType and linkRest then --linkRest contains (a variable amount of) bonus IDs and the upgrade ID at the end
				if upgradeType == "4" then -- this item can be upgraded with valor points
					local upgradeID = linkRest:match(":(%d+)$")
					if upgradeID ~= "531" then -- 529 is 0/2, 530 is 1/2, 531 is 2/2
						isUpgraded = false
					end
				end
			end
			return isUpgraded
		end
	end

	function module.options.ReloadPage()
		local nowDB = {}
		for name,data in pairs(module.db.inspectDB) do
			table.insert(nowDB,{name,data})
		end
		for name,_ in pairs(module.db.inspectQuery) do
			if not module.db.inspectDB[name] then
				table.insert(nowDB,{name})
			end
		end
		table.sort(nowDB,function(a,b) return a[1] < b[1] end)

		local scrollNow = ExRT.F.Round(module.options.ScrollBar:GetValue())
		local counter = 0
		for i=scrollNow,#nowDB do
			local data = nowDB[i][2]
			local isInRaid = (not VExRT.InspectViewer.HideNotInRaid) or (VExRT.InspectViewer.HideNotInRaid and data and UnitName( nowDB[i][1] ))
			if (not module.db.filter or (data and (
			  (module.db.filterType == 1 and module.db.filter == data.class) or 
			  (module.db.filterType == 2 and module.db.filter == module.db.armorType[ data.class or "?" ]) or 
			  (module.db.filterType == 3 and module.db.roleBySpec[ data.spec or 0 ] and module.db.filter:find( module.db.roleBySpec[ data.spec or 0 ] )) or
			  (module.db.filterType == 4 and module.db.filter:find( data.class ))
			))) and isInRaid then
				counter = counter + 1
				
				local name = nowDB[i][1]
				local line = module.options.lines[counter]
				line.name:SetText(name)
				line.unit = name
				if data then
					local class = data.class
					local classIconCoords = CLASS_ICON_TCOORDS[class]
					if classIconCoords then
						line.class.texture:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
						line.class.texture:SetTexCoord(unpack(classIconCoords))
					else
						line.class.texture:SetTexture("Interface\\Icons\\INV_MISC_QUESTIONMARK")
					end
					
					local spec = data.spec
					local specIcon = module.db.specIcons[spec]
					if not specIcon and VExRT and VExRT.ExCD2 and VExRT.ExCD2.gnGUIDs and VExRT.ExCD2.gnGUIDs[ name ] then
						spec = VExRT.ExCD2.gnGUIDs[ name ]
						specIcon = module.db.specIcons[spec]
					end
					
					if specIcon then
						line.spec.texture:SetTexture(specIcon)
						line.spec.id = spec
					else
						line.spec.texture:SetTexture("Interface\\Icons\\INV_MISC_QUESTIONMARK")
						line.spec.id = nil
					end
					
					line.ilvl:SetText(format("%.2f",data.ilvl or 0))
					
					line.linkSpecID = spec
					line.linkClassID = module.db.classIDs[class or "?"]
					
					if module.db.page == 1 then
						for j=1,16 do
							line.items[j]:Show()
							line.items[j].border:Hide()
						end
						line.time:Hide()
						line.otherInfo:Hide()
						line.otherInfoTooltipFrame:Hide()
					
						local items = data.items
						local items_ilvl = data.items_ilvl
						if items then
							for j=1,#module.db.itemsSlotTable do
								local slotID = module.db.itemsSlotTable[j]
								local item = items[slotID]
								if item then
									local itemID,enchantID = string.match(item,"item:(%d+):(%d+):")
									itemID = itemID and tonumber(itemID) or 0
									enchantID = enchantID and tonumber(enchantID) or 0
									--local itemTexture = GetItemIcon(itemID)
									local _,_,_,_,_,_,_,_,_,itemTexture = GetItemInfo(item)
									line.items[j].texture:SetTexture(itemTexture)
									line.items[j].link = item
									if (enchantID == 0 and (slotID == 2 or slotID == 15 or slotID == 11 or slotID == 12 or slotID == 16 or (module.db.specHasOffhand[spec or 0] and slotID == 17)) and module.db.colorizeNoEnch) or
										(items_ilvl[slotID] and items_ilvl[slotID] > 0 and items_ilvl[slotID] < 630 and module.db.colorizeLowIlvl) or
										(module.db.colorizeNoGems and ExRT.F.IsBonusOnItem(item,module.db.socketsBonusIDs) and IsItemHasNotGem(item)) or 
										(module.db.colorizeNoTopEnchGems and not IsTopEnchAndGems(item)) or
										(module.db.colorizeNoValorUpgrade and not IsValorUpgraded(item)) or
										(items_ilvl[slotID] and items_ilvl[slotID] > 0 and items_ilvl[slotID] < 685 and module.db.colorizeLowIlvl685)
										then
										line.items[j].border:Show()
									end
									
									line.items[j]:Show()		
								else
									line.items[j]:Hide()
								end
							end
						else
							for j=1,16 do
								line.items[j]:Hide()
							end
						end
					elseif module.db.page == 2 then
						for j=1,16 do
							ExRT.lib.ShowOrHide(line.items[j],j<=14)
							line.items[j].border:Hide()
						end
						line.time:Hide()
						line.otherInfo:Hide()
						line.otherInfoTooltipFrame:Hide()
					
						for j=1,7 do
							local t = data[j]
							if t and t ~= 0 then
								t = (j-1)*3+t
								local _,_,spellTexture = GetTalentInfoByID( data.talentsIDs[j] )
								line.items[j].texture:SetTexture(spellTexture)
								line.items[j].link = GetTalentLink( data.talentsIDs[j] )
								line.items[j].sid = nil
								line.items[j]:Show()
							else
								line.items[j]:Hide()
							end
						end
						line.items[8]:Hide()
						for j=9,14 do
							local t = data[module.db.glyphsIDs[j-8]]
							if t then
								if ExRT.is7 then
									local _,_,spellTexture = GetPvpTalentInfoByID( data.talentsIDs[ j - 1 ] )
									line.items[j].texture:SetTexture(spellTexture)
									line.items[j].link = GetPvpTalentLink( data.talentsIDs[ j - 1 ] )
									line.items[j].sid = nil
								else
									local spellTexture = GetSpellTexture(t)
									line.items[j].texture:SetTexture(spellTexture)
									line.items[j].link = "|cffffffff|Hspell:"..t.."|h[name]|h|r"
									line.items[j].sid = t
								end
								line.items[j]:Show()
							else
								line.items[j]:Hide()
							end
						end
					elseif module.db.page == 3 then
						for j=1,16 do
							line.items[j]:Hide()
							line.items[j].border:Hide()
						end
						line.time:Show()
						line.time:SetText(date("%H:%M:%S",data.time))
						
						local result = ""
						for k,statName in ipairs(module.db.statsList) do
							local statValue = data[statName]
							if ExRT.is7 then
								if statValue and statValue > 200 then
									if module.db.baseStats[statName] then
										local classCount = module.db.classIDs[class]
										if classCount then
											statValue = statValue + module.db.baseStats[statName][classCount]
											local raceCount = ExRT.F.table_find(module.db.raceList,data.race)
											if raceCount then
												statValue = statValue + module.db.raceStatsDiffs[statName][raceCount]
											end
										end
									end
									if k <= 3 then
										statValue = statValue * 1.05
									end
									result = result .. module.db.statsListName[k] .. ": " ..floor(statValue)..", "
								end
							else
								if statValue and statValue > 50 then
									if module.db.baseStats[statName] then
										local classCount = module.db.classIDs[class]
										if classCount then
											statValue = statValue + module.db.baseStats[statName][classCount]
											local raceCount = ExRT.F.table_find(module.db.raceList,data.race)
											if raceCount then
												statValue = statValue + module.db.raceStatsDiffs[statName][raceCount]
											end
										end
									end
									if spec and module.db.statsMultiplayBySpec[spec] == statName then
										statValue = statValue * 1.05
									end
									if k <= 3 then
										statValue = statValue * 1.05
									elseif k <= 7 and data.amplify and data.amplify ~= 0 then
										statValue = statValue * (1 + data.amplify/100)
									end
									result = result .. module.db.statsListName[k] .. ": " ..floor(statValue)..", "
								end
							end
						end
						result = result:gsub(", $","")
						
						line.otherInfo:SetText(result)
						line.otherInfo:Show()
						line.otherInfoTooltipFrame:Show()
					elseif module.db.page == 4 then
						for j=1,16 do
							line.items[j]:Show()
							line.items[j].border:Hide()
						end
						line.time:Hide()
						line.otherInfo:Hide()
						line.otherInfoTooltipFrame:Hide()
						
						local a4ivsData = module.db.inspectDBAch[name]
						if a4ivsData then
							for j=1,16 do
								local id = module.db.achievementsList[ module.db.achievementList ][j + 1]
								if id then
									local _,acivName,_,_,_,_,_,_,_,texture = GetAchievementInfo(id)
									local link,completed
									if a4ivsData[id] then
										local c_count = GetAchievementNumCriteria(id)
										local criteria = (2 ^ c_count) - 1
										link = format("|cffffff00|Hachievement:%d:%s:1:%s:%d:%d:%d:%d\124h[%s]|h|r",id,a4ivsData.guid,a4ivsData[id],criteria,criteria,criteria,criteria,acivName)
										completed = true
									else
										link = format("|cffffff00|Hachievement:%d:%s:0:0:0:-1:0:0:0:0\124h[%s]|h|r",id,a4ivsData.guid,acivName)
									end
									
									local statisticList = module.db.achievementsList_statistic[ module.db.achievementList ][j]
									if statisticList then
										local additional = {}
										for k=1,#statisticList do
											local statisticID = statisticList[k]
											if statisticID ~= 0 then
												local _,statisticName = GetAchievementInfo(statisticID)
												additional[#additional + 1] = (statisticName or "?")..": |cffffffff"..( a4ivsData[ statisticID ] or 0 ).."|r"
											else
												additional[#additional + 1] = " "
											end
										end
										line.items[j].additional = additional
									else
										line.items[j].additional = nil
									end
									
									line.items[j].texture:SetTexture(texture)
									line.items[j].link = link
									if not completed then
										line.items[j].border:Show()
									end
									
									line.items[j]:Show()		
								else
									line.items[j]:Hide()
								end
							end
						else
							for j=1,16 do
								line.items[j]:Hide()
							end
							line.otherInfo:SetText(L.BossWatcherDamageSwitchTabInfoNoInfo)
							line.otherInfo:Show()
						end
					end
					
					local cR,cG,cB = ExRT.F.classColorNum(class)
					if name and UnitName(name) then
						line.back:SetGradientAlpha("HORIZONTAL", cR,cG,cB, 0.5, cR,cG,cB, 0)
					else
						line.back:SetGradientAlpha("HORIZONTAL", cR,cG,cB, 0, cR,cG,cB, 0.5)
					end
				else
					for j=1,16 do
						line.items[j]:Hide()
					end
					line.time:Show()
					line.time:SetText(L.InspectViewerNoData)
					
					line.otherInfo:Hide()
					line.otherInfoTooltipFrame:Hide()
					
					line.class.texture:SetTexture("Interface\\Icons\\INV_MISC_QUESTIONMARK")
					line.class.texture:SetTexCoord(0,1,0,1)
					line.spec.texture:SetTexture("Interface\\Icons\\INV_MISC_QUESTIONMARK")
					line.spec.id = nil
					line.ilvl:SetText("")
					
					line.back:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0.5, 0, 0, 0, 0)
				end
				
				if not parentModule.db.inspectQuery[ name ] and module.db.page < 3 then
					line.updateButton:Show()
				else
					line.updateButton:Hide()
				end
				
				line:Show()
				if counter >= module.db.perPage then
					break
				end
			end
		end
		for i=(counter+1),module.db.perPage do
			module.options.lines[i]:Hide()
		end
	end
	self.ScrollBar:SetScript("OnValueChanged", module.options.ReloadPage)
	
	local function NoIlvl()
		self.raidItemLevel:SetText("")
	end
	
	function module.options.RaidIlvl()
		local n = GetNumGroupMembers() or 0
		if GetNumGroupMembers() == 0 then
			NoIlvl()
			return
		end
		local isRaid = IsInRaid()
		local gMax = ExRT.F.GetRaidDiffMaxGroup()
		local ilvl = 0
		local countPeople = 0
		if not isRaid then
			for i=1,n do
				local unit = "party"..i
				if i==n then unit = "player" end
				local name = UnitName(unit)
				if name then
					if module.db.inspectDB[name] and module.db.inspectDB[name].ilvl and module.db.inspectDB[name].ilvl >= 1 then
						countPeople = countPeople + 1
						ilvl = ilvl + module.db.inspectDB[name].ilvl
					end
				end
			end
		else
			for i=1,n do
				local name,_,subgroup = GetRaidRosterInfo(i)
				if name and subgroup <= gMax then
					if module.db.inspectDB[name] and module.db.inspectDB[name].ilvl and module.db.inspectDB[name].ilvl >= 1 then
						countPeople = countPeople + 1
						ilvl = ilvl + module.db.inspectDB[name].ilvl
					end
				end
			end
		end
		if countPeople == 0 then
			NoIlvl()
			return
		end
		ilvl = ilvl / countPeople
		self.raidItemLevel:SetText(L.InspectViewerRaidIlvl..": "..format("%.02f",ilvl).." ("..format(L.InspectViewerRaidIlvlData,countPeople)..")")
	end
	
	local function otherInfoHover(self)
		local parent = self:GetParent()
		if not parent.otherInfo:IsShown() then
			return
		end
		if parent.otherInfo:IsTruncated() then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetText(parent.otherInfo:GetText(),nil, nil, nil, nil,true)
			GameTooltip:Show()
		end
	end
	
	local function Lines_SpecIcon_OnEnter(self)
		if self.id then
			local _,name,descr = GetSpecializationInfoByID(self.id)
			ELib.Tooltip.Show(self,"ANCHOR_LEFT",name,{descr,1,1,1,true})
		end
	end
	local function Lines_ItemIcon_OnEnter(self)
		if self.link then
			local classID = self:GetParent().linkClassID
			local specID = self:GetParent().linkSpecID
			ELib.Tooltip.Link(self,self.link,classID,specID)
			if module.db.page == 4 and self.additional then
				ELib.Tooltip:Add(nil,self.additional,false,true)
			end
		end
	end
	local function Lines_ItemIcon_OnLeave(self)
		ELib.Tooltip:Hide()
		ELib.Tooltip:HideAdd()
	end
	local function Lines_ItemIcon_OnClick(self)
		if self.link then
			if module.db.page == 1 then
				ExRT.F.LinkItem(nil, self.link)
			elseif module.db.page == 2 then
				if self.sid then
					ExRT.F.LinkSpell(self.sid)
				else
					ExRT.F.LinkSpell(nil,self.link)
				end
			elseif module.db.page == 4 then
				if ChatEdit_GetActiveWindow() then
					ChatEdit_InsertLink(self.link)
				else
					ChatFrame_OpenChat(self.link)
				end
			end
		end
	end
	local function Lines_UpdateButton_OnEnter(self)
		self.texture:SetVertexColor(0.9,0.75,0,1)
	end	
	local function Lines_UpdateButton_OnLeave(self)
		self.texture:SetVertexColor(1,1,1,0.7)
	end
	local function Lines_UpdateButton_OnClick(self)
		local unit = self:GetParent().unit
		if unit then
			parentModule:AddToQueue(unit)
			module.options:showPage()
		end
	end	
		
	local IconBackDrop = {bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }}
	
	self.lines = {}
	for i=1,module.db.perPage do
		local line = CreateFrame("Frame",nil,self.borderList)
		self.lines[i] = line
		line:SetSize(625,30)
		line:SetPoint("TOPLEFT",0,-(i-1)*30)
		
		line.name = ELib:Text(line,"Name",11):Color():Point(5,0):Size(94,30):Shadow()
		
		line.class = ELib:Icon(line,nil,24):Point(100,-3)
		
		line.spec = ELib:Icon(line,nil,24):Point(130,-3)
		line.spec:SetScript("OnEnter",Lines_SpecIcon_OnEnter)
		line.spec:SetScript("OnLeave",GameTooltip_Hide)
		
		line.ilvl = ELib:Text(line,"630.52",11):Color():Point(160,0):Size(50,30):Shadow()
		
		line.items = {}
		for j=1,16 do
			local item = ELib:Icon(line,nil,21,true):Point("LEFT",210+(24*(j-1)),0)
			line.items[j] = item
			item:SetScript("OnEnter",Lines_ItemIcon_OnEnter)
			item:SetScript("OnLeave",Lines_ItemIcon_OnLeave)
			item:SetScript("OnClick",Lines_ItemIcon_OnClick)
			
			--[[
			item.border = CreateFrame("Frame",nil,item)
			item.border:SetPoint("CENTER",0,0)
			item.border:SetSize(22+8,22+8)
			item.border:SetBackdrop(IconBackDrop)
			item.border:SetBackdropColor(1,0,0,.4)
			item.border:SetBackdropBorderColor(1,0,0,1)
			]]
			
			item.texture:SetTexCoord(.1,.9,.1,.9)

			item.border = CreateFrame("Frame",nil,item)
			item.border:SetPoint("TOPLEFT")
			item.border:SetPoint("BOTTOMRIGHT")			
			
			ELib:Border(item.border,1,.12,.13,.15,1)
			
			item.border.background = item.border:CreateTexture(nil,"OVERLAY")
			item.border.background:SetPoint("TOPLEFT")
			item.border.background:SetPoint("BOTTOMRIGHT")
			
			item.border:Hide()
		end
		
		line.updateButton = ELib:Icon(line,[[Interface\AddOns\ExRT\media\DiesalGUIcons16x256x128]],18,true):Point(210+(24*16)+4,-8)
		line.updateButton.texture:SetTexCoord(0.125,0.1875,0.5,0.625)
		line.updateButton.texture:SetVertexColor(1,1,1,0.7)
		line.updateButton:SetScript("OnEnter",Lines_UpdateButton_OnEnter)
		line.updateButton:SetScript("OnLeave",Lines_UpdateButton_OnLeave)
		line.updateButton:SetScript("OnClick",Lines_UpdateButton_OnClick)
		line.updateButton:Hide()
		
		line.time = ELib:Text(line,date("%H:%M:%S",time()),11):Color():Point(205,0):Size(80,30):Shadow():Center()
		line.otherInfo = ELib:Text(line,"",10):Color():Point(285,0):Size(335,30):Shadow()
		
		line.otherInfoTooltipFrame = CreateFrame("Frame",nil,line)
		line.otherInfoTooltipFrame:SetAllPoints(line.otherInfo)
		line.otherInfoTooltipFrame:SetScript("OnEnter",otherInfoHover)
		line.otherInfoTooltipFrame:SetScript("OnLeave",GameTooltip_Hide)
		
		line.back = line:CreateTexture(nil, "BACKGROUND", nil, -3)
		line.back:SetPoint("TOPLEFT",0,0)
		line.back:SetPoint("BOTTOMRIGHT",0,0)
		line.back:SetColorTexture(1, 1, 1, 1)
		line.back:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 1, 0, 0, 0, 0)
	end
	self.raidItemLevel = ELib:Text(self,"",12):Size(500,20):Point("TOPLEFT",self.borderList,"BOTTOMLEFT",3,-2):Shadow():Color()
	
	local animationTimer = 0
	self:SetScript("OnUpdate",function (self, elapsed)
		animationTimer = animationTimer + elapsed
		local color = animationTimer
		if color > 1 then
			color = 2 - color
		end
		if color < 0 then
			color = 0
		end
		local colorR = color / 1.5
		for i=1,module.db.perPage do
			for j=1,16 do
				local frame = self.lines[i].items[j].border
				if frame:IsVisible() then
					--frame:SetBackdropBorderColor(1,color,color,1)
					--frame:SetBackdropColor(1,color,color,1)
					frame.background:SetColorTexture(1,color,color,.4)
					
					frame.border_top:SetColorTexture(.7,colorR,colorR,1)
					frame.border_bottom:SetColorTexture(.7,colorR,colorR,1)
					frame.border_left:SetColorTexture(.7,colorR,colorR,1)
					frame.border_right:SetColorTexture(.7,colorR,colorR,1)
				end
			end
		end
		if animationTimer > 2 then
			animationTimer = animationTimer % 2
		end
	end)
	
	self.moreInfoButton = ELib:Button(self,L.InspectViewerMoreInfo):Size(150,20):Point("TOPRIGHT",self.borderList,"BOTTOMRIGHT",2,-4):OnClick(function() module.options.moreInfoWindow:Show() end)
	
	self.moreInfoWindow = ELib:Popup(L.InspectViewerMoreInfo):Size(250,170)
	self.moreInfoWindow:SetScript("OnShow",function (self)
		local armorCloth,armorLeather,armorMail,armorPlate = 0,0,0,0
		local roleTank,roleMDD,roleRDD,roleHealer = 0,0,0,0
	
		local n = GetNumGroupMembers() or 0
		local gMax = ExRT.F.GetRaidDiffMaxGroup()
		local ilvl = 0
		local countPeople = 0
		for i=1,n do
			local name,_,subgroup = GetRaidRosterInfo(i)
			if name and subgroup <= gMax then
				local data = module.db.inspectDB[name]
				if data then
					countPeople = countPeople + 1
					if data.class then
						if module.db.armorType[data.class] == "CLOTH" then
							armorCloth = armorCloth + 1
						elseif module.db.armorType[data.class] == "LEATHER" then
							armorLeather = armorLeather + 1
						elseif module.db.armorType[data.class] == "MAIL" then
							armorMail = armorMail + 1
						elseif module.db.armorType[data.class] == "PLATE" then
							armorPlate = armorPlate + 1
						end
					end
					if data.spec then
						if module.db.roleBySpec[data.spec] == "TANK" then
							roleTank = roleTank + 1
						elseif module.db.roleBySpec[data.spec] == "MELEE" then
							roleMDD = roleMDD + 1
						elseif module.db.roleBySpec[data.spec] == "RANGE" then
							roleRDD = roleRDD + 1
						elseif module.db.roleBySpec[data.spec] == "HEAL" then
							roleHealer = roleHealer + 1
						end
					end
				end
			end
		end
	
		self.textData:SetText(
			L.InspectViewerMoreInfoRaidSetup..format(" ("..L.InspectViewerRaidIlvlData.."):",countPeople).."\n"..
			L.InspectViewerType..":\n"..
			"   "..L.InspectViewerTypeCloth..": "..armorCloth.."\n"..
			"   "..L.InspectViewerTypeLeather..": "..armorLeather.."\n"..
			"   "..L.InspectViewerTypeMail..": "..armorMail.."\n"..
			"   "..L.InspectViewerTypePlate..": "..armorPlate.."\n"..
			L.InspectViewerMoreInfoRole..":\n"..
			"   "..L.InspectViewerMoreInfoRoleTank..": "..roleTank.."\n"..
			"   "..L.InspectViewerMoreInfoRoleMDD..": "..roleMDD.."\n"..
			"   "..L.InspectViewerMoreInfoRoleRDD..": "..roleRDD.."\n"..
			"   "..L.InspectViewerMoreInfoRoleHealer..": "..roleHealer
		)
	end)
	self.moreInfoWindow.textData  = ELib:Text(self.moreInfoWindow,"",11):Size(225,180):Point("TOP",0,-32):Top():Color()
	
	self.buttonForce = ELib:Button(self,L.InspectViewerForce):Size(90,20):Point("RIGHT",self.moreInfoButton,"LEFT",-5,0):OnClick(function(self) 
		parentModule:Force() 
		self:SetEnabled(false)
	end)
	
	function module.options.showPage()
		local count = 0
		for _ in pairs(module.db.inspectDB) do
			count = count + 1
		end
		for name,_ in pairs(module.db.inspectQuery) do
			if not module.db.inspectDB[name] then
				count = count + 1
			end
		end
		self.ScrollBar:SetMinMaxValues(1,max(count-module.db.perPage+1,1)):UpdateButtons()
		module.options.ReloadPage()
		
		module.options.RaidIlvl()
	end
	function self.UpdatePage_InspectEvent()
		if not module.options:IsShown() then
			return
		end
		module.options:showPage()
		ExRT.F.ScheduleTimer(module.options.showPage, 4)
	end
	
	self.OnShow_disableNil = true
	self:SetScript("OnShow",module.options.showPage)
	module:RegisterEvents("INSPECT_READY")
	self:showPage()
end

function ExRT.F:RaidItemLevel()
	local n = GetNumGroupMembers() or 0
	if GetNumGroupMembers() == 0 then
		local name = UnitName('player')
		if module.db.inspectDB[name] and module.db.inspectDB[name].ilvl and module.db.inspectDB[name].ilvl >= 1 then
			return module.db.inspectDB[name].ilvl
		end
		return 0
	end
	local isRaid = IsInRaid()
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	local ilvl = 0
	local countPeople = 0
	if not isRaid then
		for i=1,n do
			local unit = "party"..i
			if i==n then unit = "player" end
			local name = UnitName(unit)
			if name then
				if module.db.inspectDB[name] and module.db.inspectDB[name].ilvl and module.db.inspectDB[name].ilvl >= 1 then
					countPeople = countPeople + 1
					ilvl = ilvl + module.db.inspectDB[name].ilvl
				end
			end
		end
	else
		for i=1,n do
			local name,_,subgroup = GetRaidRosterInfo(i)
			if name and subgroup <= gMax then
				if module.db.inspectDB[name] and module.db.inspectDB[name].ilvl and module.db.inspectDB[name].ilvl >= 1 then
					countPeople = countPeople + 1
					ilvl = ilvl + module.db.inspectDB[name].ilvl
				end
			end
		end
	end
	if countPeople == 0 then
		return 0
	end
	return ilvl / countPeople
end

function module:slash(arg)
	if arg == "raid" then
		ExRT.Options:Open(module.options)
	end
end

