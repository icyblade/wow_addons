local GlobalAddonName, ExRT = ...

local VExRT = nil

local module = ExRT.mod:New("AutoLogging",ExRT.L.Logging,nil,true)
local ELib,L = ExRT.lib,ExRT.L

module.db.raidIDs = {
	[988]=true,	--BF
	[994]=true,	--H
	[1026]=true,	--HC
	[-999]=true,	--All new raids
}

function module.options:Load()
	self:CreateTilte()

	self.enableChk = ELib:Check(self,L.LoggingEnable,VExRT.Logging.enabled):Point(5,-30):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Logging.enabled = true
			module:Enable()
		else
			VExRT.Logging.enabled = nil
			module:Disable()
		end
	end)
		
	self.shtml1 = ELib:Text(self,"- "..L.RaidLootT17Highmaul.."\n- "..L.RaidLootT17BF.."\n -"..L.RaidLootT18HC,12):Size(620,0):Point("TOP",0,-65):Top()

	self.shtml2 = ELib:Text(self,L.LoggingHelp1,12):Size(650,0):Point("TOP",self.shtml1,"BOTTOM",0,-15):Top()
	
	self.disableLFR =  ELib:Check(self,L.RaidCheckDisableInLFR,VExRT.Logging.disableLFR):Point("TOP",self.shtml2,"BOTTOM",0,-15):Point("LEFT",self,5,0):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.Logging.disableLFR = true
		else
			VExRT.Logging.disableLFR = nil
		end
	end)
end


function module:Enable()
	module:RegisterEvents('ZONE_CHANGED_NEW_AREA')
	module.main:ZONE_CHANGED_NEW_AREA()
end
function module:Disable()
	module:UnregisterEvents('ZONE_CHANGED_NEW_AREA')
	module.main:ZONE_CHANGED_NEW_AREA()
end


function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Logging = VExRT.Logging or {}

	if VExRT.Logging.enabled then
		module:Enable()
	end
end

local function GetCurrentMapAreaID_Fix()
	if VExRT.Logging.enabled then
		if VExRT.Logging.disableLFR then
			local _,zoneType,difficulty, _, _, _, _, mapID = GetInstanceInfo()
			if difficulty == 7 or difficulty == 17 then
				return 0
			else
				local zoneID = GetCurrentMapAreaID()
				if ((zoneID and zoneID > 1026) or (tonumber(mapID) and mapID >= 1520)) and zoneType == 'raid' then
					zoneID = -999
				end
				return zoneID
			end
		else
			local _, _, _, _, _, _, _, mapID = GetInstanceInfo()
			local zoneID = GetCurrentMapAreaID()
			local _,zoneType = GetInstanceInfo()
			if ((zoneID and zoneID > 1026) or (tonumber(mapID) and mapID >= 1520)) and zoneType == 'raid' then
				zoneID = -999
			end
			return zoneID
		end
	else
		return 0
	end
end

local prevZone = 0
local function ZoneNewFunction()
	local zoneID = GetCurrentMapAreaID_Fix()
	if module.db.raidIDs[zoneID] then
		LoggingCombat(true)
		print('==================')
		print(ExRT.L.LoggingStart)
		print('==================')
	else
		if module.db.raidIDs[prevZone] and LoggingCombat() then
			LoggingCombat(false)
			print('==================')
			print(ExRT.L.LoggingEnd)
			print('==================')
		end
	end
	prevZone = zoneID
end

function module.main:ZONE_CHANGED_NEW_AREA()
	ExRT.F.ScheduleTimer(ZoneNewFunction, 2)
end
