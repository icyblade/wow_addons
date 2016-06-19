local GlobalAddonName, ExRT = ...

local module = ExRT.mod:New("WhoPulled",ExRT.L.WhoPulled,nil,true)
local ELib,L = ExRT.lib,ExRT.L

module.db.lastPull = nil
module.db.lastBossName = nil
module.db.whoPulled = nil

function module.options:Load()
	self:CreateTilte()
	
	local function UpdatePage()
		local pull = "-"
		if module.db.lastPull then
			pull = date("%d/%m/%Y %H:%M:%S",module.db.lastPull).." "..(module.db.lastBossName or "")
		end
	  	self.lastPull:SetText(L.WhoPulledlastPull..": "..pull)
	  	self.name:SetText(module.db.whoPulled or "")
	end
	
	self.lastPull = ELib:Text(self,"",12):Point("TOP",0,-50):Top():Color()
	self.name = ELib:Text(self,"",18):Point("TOP",0,-65):Top():Color()
	
	self.OnShow_disableNil = true
	self:SetScript("OnShow",UpdatePage)
	
	UpdatePage()
end


function module.main:ADDON_LOADED()
	module:RegisterEvents('ENCOUNTER_START')
end

local bossUnits = {["boss1"]=true,["boss2"]=true,["boss3"]=true,["boss4"]=true,["boss5"]=true,}

local function Unregister()
	module:UnregisterEvents('UNIT_TARGET')
end

function module.main:ENCOUNTER_START(encounterID, encounterName, difficultyID, groupSize)
	module.db.whoPulled = nil
	module.db.lastPull = time()
	module.db.lastBossName = encounterName
	for boss,_ in pairs(bossUnits) do
		local tname = UnitName(boss.."target")
		if tname then
			module.db.whoPulled = tname
			return
		end
	end
	module:RegisterEvents('UNIT_TARGET')
	C_Timer.NewTimer(10,Unregister)
end

function module.main:UNIT_TARGET(unit)
	if unit and bossUnits[unit] then
		local tname = UnitName(unit.."target")
		if tname then
			module.db.whoPulled = tname
			module:UnregisterEvents('UNIT_TARGET')
		end
	end
end