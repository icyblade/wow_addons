local GatherMate = LibStub("AceAddon-3.0"):GetAddon("GatherMate2")
local Collector = GatherMate:NewModule("Collector", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GatherMate2",true)
local NL = LibStub("AceLocale-3.0"):GetLocale("GatherMate2Nodes")   -- for get the local name of Gas Cloud´s
local Display = nil
-- prevSpell, curSpell are markers for what has been cast now and the lastcast
-- gatherevents if a flag for wether we are listening to events
local prevSpell, curSpell, foundTarget, gatherEvents, ga

--[[
Convert for 2.4 spell IDs
]]
local miningSpell = (GetSpellInfo(2575))
local herbSpell = (GetSpellInfo(2366))
local herbSkill = (string.gsub((GetSpellInfo(9134)),"%A",""))
local fishSpell = (GetSpellInfo(33095))
local gasSpell = (GetSpellInfo(30427))
--local gasSpell = (GetSpellInfo(48929))  --other gasspell
local openSpell = (GetSpellInfo(3365))
local openNoTextSpell = (GetSpellInfo(22810))
local pickSpell = (GetSpellInfo(1804))
local archSpell = (GetSpellInfo(73979)) -- Searching for Artifacts spell
local sandStormSpell = (GetSpellInfo(93473)) -- Sandstorm spell cast by the camel

local spells = { -- spellname to "database name"
	[miningSpell] = "Mining",
	[herbSpell] = "Herb Gathering",
	[fishSpell] = "Fishing",
	[gasSpell] = "Extract Gas",
	[openSpell] = "Treasure",
	[openNoTextSpell] = "Treasure",
	[pickSpell] = "Treasure",
	[archSpell] = "Archaeology",
	[sandStormSpell] = "Treasure",
}
local tooltipLeftText1 = _G["GameTooltipTextLeft1"]
local strfind, stringmatch = string.find, string.match
local pii = math.pi
local sin = math.sin
local cos = math.cos
local gsub = gsub
local strtrim = strtrim
--[[
	This search string code no longer needed since we use CombatEvent to detect gas clouds harvesting
]]
-- buffsearchstring is for gas extartion detection of the aura event
-- local buffSearchString
--local sub_string = GetLocale() == "deDE" and "%%%d$s" or "%%s"
--buffSearchString = string.gsub(AURAADDEDOTHERHELPFUL, sub_string, "(.+)")

local function getArrowDirection(...)
	if GetPlayerFacing then
		return GetPlayerFacing()
	else
		if(GetCVar("rotateMinimap") == "1") then return -MiniMapCompassRing:GetFacing()	end
		for i=select("#",...),1,-1 do
			local model=select(i,...)
			if model:IsObjectType("Model") and not model:GetName() then	return model and model:GetFacing() end
		end
		return nil
	end
end

--[[
	Enable the collector
]]
function Collector:OnEnable()
	self:RegisterGatherEvents()
end

--[[
	Register the events we are interesting
]]
function Collector:RegisterGatherEvents()
	self:RegisterEvent("UNIT_SPELLCAST_SENT","SpellStarted")
	self:RegisterEvent("UNIT_SPELLCAST_STOP","SpellStopped")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED","SpellFailed")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED","SpellFailed")
	self:RegisterEvent("CURSOR_UPDATE","CursorChange")
	self:RegisterEvent("UI_ERROR_MESSAGE","UIError")
	--self:RegisterEvent("LOOT_CLOSED","GatherCompleted")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "GasBuffDetector")
	self:RegisterEvent("CHAT_MSG_LOOT","SecondaryGasCheck") -- for Storm Clouds
	gatherEvents = true
end

--[[
	Unregister the events
]]
function Collector:UnregisterGatherEvents()
	self:UnregisterEvent("UNIT_SPELLCAST_SENT")
	self:UnregisterEvent("UNIT_SPELLCAST_SENT")
	self:UnregisterEvent("UNIT_SPELLCAST_STOP")
	self:UnregisterEvent("UNIT_SPELLCAST_FAILED")
	self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:UnregisterEvent("CURSOR_UPDATE")
	self:UnregisterEvent("UI_ERROR_MESSAGE")
	--self:UnregisterEvent("LOOT_CLOSED")
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	gatherEvents = false
end

local CrystalizedWater = (GetItemInfo(37705)) or ""
local MoteOfAir = (GetItemInfo(22572)) or ""

function Collector:SecondaryGasCheck(event,msg)
	if ga ~= gasSpell then return end
	if not msg then return end
	if foundTarget then return end
	if ga == gasSpell and strfind(msg,CrystalizedWater) then
		-- check for Steam Clouds by assuming your always getting water from Steam Clouds
		foundTarget = true
		self:addItem(ga,NL["Steam Cloud"])
		ga = "No"
	end
	if ga == gasSpell and strfind(msg,MoteOfAir) then
		-- check for Steam Clouds by assuming your always getting water from Steam Clouds
		foundTarget = true
		self:addItem(ga,NL["Windy Cloud"])
		ga = "No"
	end
end

--[[
	This is a hack for scanning mote extraction, hopefully blizz will make the mote mobs visible so we can mouse over
	or get a better event instead of cha msg parsing
	UNIT_DISSIPATES,0x0000000000000000,nil,0x80000000,0xF1307F0A00002E94,"Cinder Cloud",0xa28 now fires in cataclysm so hack not needed any more
]]
function Collector:GasBuffDetector(b,timestamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags, spellId,spellName,spellSchool,auraType)
	if foundTarget or (prevSpell and prevSpell ~= gasSpell) then return end

	if eventType == "SPELL_CAST_SUCCESS" and  spellName == gasSpell then
		ga = gasSpell
	elseif eventType == "UNIT_DISSIPATES" and  ga == gasSpell then
		foundTarget = true
		self:addItem(ga,dstName)
		ga = "No"
	end
	-- Try to detect the camel figurine
	if eventType == "SPELL_CAST_SUCCESS" and spellName == sandStormSpell and srcName == NL["Mysterious Camel Figurine"] then
		foundTarget = true
		self:addItem(sandStormSpell,NL["Mysterious Camel Figurine"])
	end

end

--[[
	Any time we close a loot window stop checking for targets ala the Fishing bobber
]]
function Collector:GatherCompleted()
	prevSpell, curSpell = nil, nil
	foundTarget = false
end

--[[
	When the hand icon goes to a gear see if we can find a nde under the gear ala for the fishing bobber OR herb of mine
]]
function Collector:CursorChange()
	if foundTarget then return end
	if (MinimapCluster:IsMouseOver()) then return end
	if spells[prevSpell] then
		self:GetWorldTarget()
	end
end

--[[
	We stopped casting the spell
]]
function Collector:SpellStopped(event,unit)
	if unit ~= "player" then return end
	if spells[prevSpell] then
		self:GetWorldTarget()
	end
	-- prev spel needs set since it is used for cursor changes
	prevSpell, curSpell = curSpell, curSpell
end

--[[
	We failed to cast
]]
function Collector:SpellFailed(event,unit)
	if unit ~= "player" then return end
	prevSpell, curSpell = nil, nil
end

--[[
	UI Error from gathering when you dont have the required skill
]]
function Collector:UIError(event,msg)
	local what = tooltipLeftText1:GetText();
	if not what then return end
	if strfind(msg, miningSpell) then
		self:addItem(miningSpell,what)
	elseif strfind(msg, herbSkill) then
		self:addItem(herbSpell,what)
	elseif strfind(msg, pickSpell) or strfind(msg, openSpell) then -- locked box or failed pick
		self:addItem(openSpell, what)
	end
end

--[[
	spell cast started
]]
function Collector:SpellStarted(event,unit,spellcast,rank,target)
	if unit ~= "player" then return end
	foundTarget = false
	ga ="No"
	if spells[spellcast] then
		curSpell = spellcast
		prevSpell = spellcast
		local nodeID = GatherMate:GetIDForNode(spells[prevSpell], target)
		if nodeID then -- seem 2.4 has the node name now as the target
			self:addItem(prevSpell,target)
			foundTarget = true
		else
			self:GetWorldTarget()
		end
	else
		prevSpell, curSpell = nil, nil
	end
end

--[[
	add an item to the map (we delgate to GatherMate)
]]
local lastNode = ""
local lastNodeCoords = 0

function Collector:addItem(skill,what)
	-- check for microdungeon
	local mapName, textureWidth, textureHeight, isMicroDungeon, microDungeonName = GetMapInfo()
	if isMicroDungeon then
	  SetMapByID(GetCurrentMapAreaID())
	end
	-- end check
	local x, y = GetPlayerMapPosition("player")
	if x == 0 and y == 0 then return end
	-- Temporary fix, the map "ScarletEnclave" and "EasternPlaguelands"
	-- both have the same English display name as "Eastern Plaguelands"
	-- so we ignore the new Death Knight starting zone for now.
	if GetMapInfo() == "ScarletEnclave" then return end
	--self:GatherCompleted()
	local zone = GetCurrentMapAreaID()
	if GatherMate.phasing[zone] then zone = GatherMate.phasing[zone] end

	local level = GetCurrentMapDungeonLevel()
	local node_type = spells[skill]
	if not node_type or not what then return end
	-- db lock check
	if GatherMate.db.profile.dbLocks[node_type] then return	end

	local range = GatherMate.db.profile.cleanupRange[node_type]
	-- special case for fishing and gas extraction guage the pointing direction
	if node_type == fishSpell or node_type == gasSpell then
		local yw, yh = GatherMate:GetZoneSize(zone,level)
		if yw == 0 or yh == 0 then return end -- No zone size data
		x,y = self:GetFloatingNodeLocation(x, y, yw, yh)
	end
	local nid = GatherMate:GetIDForNode(node_type, what)
	-- if we couldnt find the node id for what was found, exit the add
	if not nid then return end
	local rares = self.rareNodes
	-- run through the nearby's
	local skip = false
	local foundCoord = GatherMate.mapData:EncodeLoc(x, y, level)
	local specialNode = false
	local specialWhat = what
	if foundCoord == lastNodeCoords and what == lastNode then return end
	--[[ DISABLE SPECIAL NODE PROCESSING FOR HERBS
	if self.specials[zone] and self.specials[zone][node_type] ~= nil then
		specialWhat = GatherMate:GetNameForNode(node_type,self.specials[zone][node_type])
		specialNode = true
	end
	--]]
	for coord, nodeID in GatherMate:FindNearbyNode(zone, x, y, level, node_type, range, true) do
		if (nodeID == nid or rares[nodeID] and rares[nodeID][nid]) then
			GatherMate:RemoveNodeByID(zone, node_type, coord)
		-- we're trying to add a rare node, but there is already a normal node present, skip the adding
		elseif rares[nid] and rares[nid][nodeID] then
			skip = true
		elseif specialNode then -- handle special case zone mappings
			skip = false
			GatherMate:RemoveNodeByID(zone, node_type, coord)
		end
	end

	if not skip then
		if specialNode then
			GatherMate:AddNode(zone, x, y, level, node_type, specialWhat)
		else
			GatherMate:AddNode(zone, x, y, level, node_type, what)
		end
		lastNode = what
		lastNodeCoords = foundCoord
	end
	self:GatherCompleted()
end

--[[
	move the node 20 yards in the direction the player is looking at
]]
function Collector:GetFloatingNodeLocation(x,y,yardWidth,yardHeight)
	local facing = getArrowDirection(Minimap:GetChildren())
	if not facing then	-- happens when minimap rotation is on
		return x,y
	else
		local rad = facing + pii
		return x + sin(rad)*15/yardWidth, y + cos(rad)*15/yardHeight
	end
end

--[[
	get the target your clicking on
]]
function Collector:GetWorldTarget()
	if foundTarget or not spells[curSpell] then return end
	if (MinimapCluster:IsMouseOver()) then return end
	local what = tooltipLeftText1:GetText()
	local nodeID = GatherMate:GetIDForNode(spells[prevSpell], what)
	if what and prevSpell and what ~= prevSpell and nodeID then
		self:addItem(prevSpell,what)
		foundTarget = true
	end
end
