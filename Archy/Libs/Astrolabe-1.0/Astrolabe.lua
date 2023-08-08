--[[
Name: Astrolabe
Revision: $Rev: 123 $
$Date: 2010-12-07 05:56:24 +0200 (Tue, 07 Dec 2010) $
Author(s): Esamynn (esamynn at wowinterface.com)
Inspired By: Gatherer by Norganna
             MapLibrary by Kristofer Karlsson (krka at kth.se)
Documentation: http://wiki.esamynn.org/Astrolabe
SVN: http://svn.esamynn.org/astrolabe/
Description:
	This is a library for the World of Warcraft UI system to place
	icons accurately on both the Minimap and on Worldmaps.  
	This library also manages and updates the position of Minimap icons 
	automatically.  

Copyright (C) 2006-2010 James Carrothers

License:
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.

	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

Note:
	This library's source code is specifically designed to work with
	World of Warcraft's interpreted AddOn system.  You have an implicit
	licence to use this library with these facilities since that is its
	designated purpose as per:
	http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]

-- WARNING!!!
-- DO NOT MAKE CHANGES TO THIS LIBRARY WITHOUT FIRST CHANGING THE LIBRARY_VERSION_MAJOR
-- STRING (to something unique) OR ELSE YOU MAY BREAK OTHER ADDONS THAT USE THIS LIBRARY!!!
local LIBRARY_VERSION_MAJOR = "Astrolabe-1.0"
local LIBRARY_VERSION_MINOR = tonumber(string.match("$Revision: 123 $", "(%d+)") or 1)

if not DongleStub then error(LIBRARY_VERSION_MAJOR .. " requires DongleStub.") end
if not DongleStub:IsNewerVersion(LIBRARY_VERSION_MAJOR, LIBRARY_VERSION_MINOR) then return end

local Astrolabe = {};

-- define local variables for Data Tables (defined at the end of this file)
local WorldMapSize, MinimapSize, ValidMinimapShapes, zeroData;

function Astrolabe:GetVersion()
	return LIBRARY_VERSION_MAJOR, LIBRARY_VERSION_MINOR;
end


--------------------------------------------------------------------------------------------------------------
-- Config Constants
--------------------------------------------------------------------------------------------------------------

local configConstants = { 
	MinimapUpdateMultiplier = true, 
}

-- this constant is multiplied by the current framerate to determine
-- how many icons are updated each frame
Astrolabe.MinimapUpdateMultiplier = 1;


--------------------------------------------------------------------------------------------------------------
-- Working Tables
--------------------------------------------------------------------------------------------------------------

Astrolabe.LastPlayerPosition = { 0, 0, 0, 0 };
Astrolabe.MinimapIcons = {};
Astrolabe.IconsOnEdge = {};
Astrolabe.IconsOnEdge_GroupChangeCallbacks = {};

Astrolabe.MinimapIconCount = 0
Astrolabe.ForceNextUpdate = false;
Astrolabe.IconsOnEdgeChanged = false;

-- This variable indicates whether we know of a visible World Map or not.  
-- The state of this variable is controlled by the AstrolabeMapMonitor library.  
Astrolabe.WorldMapVisible = false;

local AddedOrUpdatedIcons = {}
local MinimapIconsMetatable = { __index = AddedOrUpdatedIcons }


--------------------------------------------------------------------------------------------------------------
-- Local Pointers for often used API functions
--------------------------------------------------------------------------------------------------------------

local twoPi = math.pi * 2;
local atan2 = math.atan2;
local sin = math.sin;
local cos = math.cos;
local abs = math.abs;
local sqrt = math.sqrt;
local min = math.min
local max = math.max
local yield = coroutine.yield
local next = next
local GetFramerate = GetFramerate

local real_GetCurrentMapAreaID = GetCurrentMapAreaID
local function GetCurrentMapAreaID()
	local id = real_GetCurrentMapAreaID();
	if ( id < 0 and GetCurrentMapContinent() == WORLDMAP_WORLD_ID ) then
		return 0;
	end
	return id;
end


--------------------------------------------------------------------------------------------------------------
-- Internal Utility Functions
--------------------------------------------------------------------------------------------------------------

local function assert(level,condition,message)
	if not condition then
		error(message,level)
	end
end

local function argcheck(value, num, ...)
	assert(1, type(num) == "number", "Bad argument #2 to 'argcheck' (number expected, got " .. type(level) .. ")")
	
	for i=1,select("#", ...) do
		if type(value) == select(i, ...) then return end
	end
	
	local types = strjoin(", ", ...)
	local name = string.match(debugstack(2,2,0), ": in function [`<](.-)['>]")
	error(string.format("Bad argument #%d to 'Astrolabe.%s' (%s expected, got %s)", num, name, types, type(value)), 3)
end

local function getSystemPosition( mapData, f, x, y )
	if ( f ~= 0 ) then
		mapData = mapData[f];
	end
	x = x * mapData.width + mapData.xOffset;
	y = y * mapData.height + mapData.yOffset;
	return x, y;
end


--------------------------------------------------------------------------------------------------------------
-- General Utility Functions
--------------------------------------------------------------------------------------------------------------

function Astrolabe:ComputeDistance( m1, f1, x1, y1, m2, f2, x2, y2 )
	--[[
	argcheck(m1, 2, "number");
	assert(3, m1 >= 0, "ComputeDistance: Illegal map id to m1: "..m1);
	argcheck(f1, 3, "number", "nil");
	argcheck(x1, 4, "number");
	argcheck(y1, 5, "number");
	argcheck(m2, 6, "number");
	assert(3, m2 >= 0, "ComputeDistance: Illegal map id to m2: "..m2);
	argcheck(f2, 7, "number", "nil");
	argcheck(x2, 8, "number");
	argcheck(y2, 9, "number");
	--]]
	
	if not ( m1 and m2 ) then return end;
	f1 = f1 or min(#WorldMapSize[m1], 1);
	f2 = f2 or min(#WorldMapSize[m2], 1);
	
	local dist, xDelta, yDelta;
	if ( m1 == m2 and f1 == f2 ) then
		-- points in the same zone on the same floor
		local mapData = WorldMapSize[m1];
		if ( f1 ~= 0 ) then
			mapData = mapData[f1];
		end
		xDelta = (x2 - x1) * mapData.width;
		yDelta = (y2 - y1) * mapData.height;
	
	else
		local map1 = WorldMapSize[m1];
		local map2 = WorldMapSize[m2];
		if ( map1.system == map2.system ) then
			-- points within the same system (continent)
			x1, y1 = getSystemPosition(map1, f1, x1, y1);
			x2, y2 = getSystemPosition(map2, f2, x2, y2);
			xDelta = (x2 - x1);
			yDelta = (y2 - y1);
		
		else
			local sp1 = map1.systemParent;
			local sp2 = map2.systemParent;
			if ( sp1 == sp2 ) then
				--local worldID = sp1;
				-- instead of a new local, reuse sp1
				local s1 = map1.system;
				local s2 = map2.system;
				x1, y1 = getSystemPosition(map1, f1, x1, y1);
				x2, y2 = getSystemPosition(map2, f2, x2, y2);
				if not ( s1 == map1.systemParent ) then
					local cont1 = WorldMapSize[sp1][s1];
					x1 = x1 - cont1.xOffset;
					y1 = y1 - cont1.yOffset;
				end
				if not ( s2 == map2.systemParent ) then
					local cont2 = WorldMapSize[sp1][s2];
					x2 = x2 - cont2.xOffset;
					y2 = y2 - cont2.yOffset;
				end
				
				xDelta = x2 - x1;
				yDelta = y2 - y1;
			end
		
		end
	
	end
	if ( xDelta and yDelta ) then
		dist = sqrt(xDelta*xDelta + yDelta*yDelta);
	end
	return dist, xDelta, yDelta;
end

function Astrolabe:TranslateWorldMapPosition( M, F, xPos, yPos, nM, nF )
	--[[
	argcheck(M, 2, "number");
	argcheck(F, 3, "number", "nil");
	argcheck(xPos, 4, "number");
	argcheck(yPos, 5, "number");
	argcheck(nM, 6, "number");
	argcheck(nF, 7, "number", "nil");
	--]]
	
	if not ( M and nM ) then return end;
	F = F or min(#WorldMapSize[M], 1);
	nF = nF or min(#WorldMapSize[nM], 1);
	if ( nM < 0 ) then
		return;
	end
	
	local mapData;
	if ( M == nM and F == nF ) then
		return xPos, yPos;
	
	else
		local map = WorldMapSize[M];
		local nMap = WorldMapSize[nM];
		if ( map.system == nMap.system ) then
			-- points within the same system (continent)
			xPos, yPos = getSystemPosition(map, F, xPos, yPos);
			mapData = WorldMapSize[nM];
			if ( nF ~= 0 ) then
				mapData = mapData[nF];
			end
		
		else
			-- different continents, same world
			local SP = map.systemParent;
			local nSP = nMap.systemParent;
			if ( SP == nSP ) then
				--local worldID = SP;
				-- instead of a new local, reuse SP
				local S = map.system;
				local nS = nMap.system;
				mapData = WorldMapSize[M];
				xPos, yPos = getSystemPosition(mapData, F, xPos, yPos);
				if ( M ~= SP ) then
					-- translate up to world map if we aren't there already
					local cont = WorldMapSize[SP][S];
					xPos = xPos - cont.xOffset;
					yPos = yPos - cont.yOffset;
					mapData = WorldMapSize[SP];
				end
				if ( nM ~= SP ) then
					-- translate down to the new continent
					local nCont = WorldMapSize[SP][nS];
					xPos = xPos + nCont.xOffset;
					yPos = yPos + nCont.yOffset;
					mapData = WorldMapSize[nM];
					if ( nF ~= 0 ) then
						mapData = mapData[nF];
					end
				end
			
			else
				return;
			end
		
		end
		-- need to account for the offset in the new system so we can
		-- correctly translate into 0-1 style coordinates
		xPos = xPos - mapData.xOffset;
		yPos = yPos - mapData.yOffset;
	
	end
	
	return (xPos / mapData.width), (yPos / mapData.height);
end

--*****************************************************************************
-- This function will do its utmost to retrieve some sort of valid position 
-- for the specified unit, including changing the current map zoom (if needed).  
-- Map Zoom is returned to its previous setting before this function returns.  
--*****************************************************************************
function Astrolabe:GetUnitPosition( unit, noMapChange )
	local x, y = GetPlayerMapPosition(unit);
	if ( x <= 0 and y <= 0 ) then
		if ( noMapChange ) then
			-- no valid position on the current map, and we aren't allowed
			-- to change map zoom, so return
			return;
		end
		local lastMapID, lastFloor = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel();
		SetMapToCurrentZone();
		x, y = GetPlayerMapPosition(unit);
		if ( x <= 0 and y <= 0 ) then
			WorldMapZoomOutButton_OnClick();
			x, y = GetPlayerMapPosition(unit);
			if ( x <= 0 and y <= 0 ) then
				-- we are in an instance or otherwise off map
				return;
			end
		end
		local M, F = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel();
		if ( M ~= lastMapID or F ~= lastFloor ) then
			-- set map zoom back to what it was before
			SetMapByID(lastMapID);
			SetDungeonMapLevel(lastFloor);
		end
		return M, F, x, y;
	end
	return GetCurrentMapAreaID(), GetCurrentMapDungeonLevel(), x, y;
end

--*****************************************************************************
-- This function will do its utmost to retrieve some sort of valid position 
-- for the specified unit, including changing the current map zoom (if needed).  
-- However, if a monitored WorldMapFrame (See AstrolabeMapMonitor.lua) is 
-- visible, then will simply return nil if the current zoom does not provide 
-- a valid position for the player unit.  Map Zoom is returned to its previous 
-- setting before this function returns, if it was changed.  
--*****************************************************************************
function Astrolabe:GetCurrentPlayerPosition()
	return self:GetUnitPosition("player", self.WorldMapVisible);
end

function Astrolabe:GetMapID(continent, zone)
	zone = zone or 0;
	local ret = self.ContinentList[continent];
	if ( ret ) then
		return ret[zone];
	end
	if ( continent == 0 and zone == 0 ) then
		return 0;
	end
end

function Astrolabe:GetNumFloors( mapID )
	if ( type(mapID) == "number" ) then
		local mapData = WorldMapSize[mapID]
		return #mapData
	end
end

function Astrolabe:GetMapInfo( mapID, mapFloor )
	argcheck(mapID, 2, "number");
	assert(3, mapID >= 0, "GetMapInfo: Illegal map id to mapID: "..mapID);
	argcheck(mapFloor, 3, "number", "nil");
	
	mapFloor = mapFloor or min(#WorldMapSize[mapID], 1);
	local mapData = WorldMapSize[mapID];
	local system, systemParent = mapData.system, mapData.systemParent
	if ( mapFloor ~= 0 ) then
		mapData = mapData[mapFloor];
	end
	if ( mapData ~= zeroData ) then
		return system, systemParent, mapData.width, mapData.height, mapData.xOffset, mapData.yOffset;
	end
end


--------------------------------------------------------------------------------------------------------------
-- Working Table Cache System
--------------------------------------------------------------------------------------------------------------

local tableCache = {};
tableCache["__mode"] = "v";
setmetatable(tableCache, tableCache);

local function GetWorkingTable( icon )
	if ( tableCache[icon] ) then
		return tableCache[icon];
	else
		local T = {};
		tableCache[icon] = T;
		return T;
	end
end


--------------------------------------------------------------------------------------------------------------
-- Minimap Icon Placement
--------------------------------------------------------------------------------------------------------------

--*****************************************************************************
-- local variables specifically for use in this section
--*****************************************************************************
local minimapRotationEnabled = false;
local minimapShape = false;

local minimapRotationOffset = GetPlayerFacing();


local function placeIconOnMinimap( minimap, minimapZoom, mapWidth, mapHeight, icon, dist, xDist, yDist )
	local mapDiameter;
	if ( Astrolabe.minimapOutside ) then
		mapDiameter = MinimapSize.outdoor[minimapZoom];
	else
		mapDiameter = MinimapSize.indoor[minimapZoom];
	end
	local mapRadius = mapDiameter / 2;
	local xScale = mapDiameter / mapWidth;
	local yScale = mapDiameter / mapHeight;
	local iconDiameter = ((icon:GetWidth() / 2) + 3) * xScale;
	local iconOnEdge = nil;
	local isRound = true;
	
	if ( minimapRotationEnabled ) then
		local sinTheta = sin(minimapRotationOffset)
		local cosTheta = cos(minimapRotationOffset)
		--[[
		Math Note
		The math that is acutally going on in the next 3 lines is:
			local dx, dy = xDist, -yDist
			xDist = (dx * cosTheta) + (dy * sinTheta)
			yDist = -((-dx * sinTheta) + (dy * cosTheta))
		
		This is because the origin for map coordinates is the top left corner
		of the map, not the bottom left, and so we have to reverse the vertical 
		distance when doing the our rotation, and then reverse the result vertical 
		distance because this rotation formula gives us a result with the origin based 
		in the bottom left corner (of the (+, +) quadrant).  
		The actual code is a simplification of the above.  
		]]
		local dx, dy = xDist, yDist
		xDist = (dx * cosTheta) - (dy * sinTheta)
		yDist = (dx * sinTheta) + (dy * cosTheta)
	end
	
	if ( minimapShape and not (xDist == 0 or yDist == 0) ) then
		isRound = (xDist < 0) and 1 or 3;
		if ( yDist < 0 ) then
			isRound = minimapShape[isRound];
		else
			isRound = minimapShape[isRound + 1];
		end
	end
	
	-- for non-circular portions of the Minimap edge
	if not ( isRound ) then
		dist = max(abs(xDist), abs(yDist))
	end

	if ( (dist + iconDiameter) > mapRadius ) then
		-- position along the outside of the Minimap
		iconOnEdge = true;
		local factor = (mapRadius - iconDiameter) / dist;
		xDist = xDist * factor;
		yDist = yDist * factor;
	end
	
	if ( Astrolabe.IconsOnEdge[icon] ~= iconOnEdge ) then
		Astrolabe.IconsOnEdge[icon] = iconOnEdge;
		Astrolabe.IconsOnEdgeChanged = true;
	end
	
	icon:ClearAllPoints();
	icon:SetPoint("CENTER", minimap, "CENTER", xDist/xScale, -yDist/yScale);
end

function Astrolabe:PlaceIconOnMinimap( icon, mapID, mapFloor, xPos, yPos )
	-- check argument types
	argcheck(icon, 2, "table");
	assert(3, icon.SetPoint and icon.ClearAllPoints, "Usage Message");
	argcheck(mapID, 3, "number");
	argcheck(mapFloor, 4, "number", "nil");
	argcheck(xPos, 5, "number");
	argcheck(yPos, 6, "number");
	
	-- if the positining system is currently active, just use the player position used by the last incremental (or full) update
	-- otherwise, make sure we base our calculations off of the most recent player position (if one is available)
	local lM, lF, lx, ly;
	if ( self.processingFrame:IsShown() ) then
		lM, lF, lx, ly = unpack(self.LastPlayerPosition);
	else
		lM, lF, lx, ly = self:GetCurrentPlayerPosition();
		if ( lM and lM >= 0 ) then
			local lastPosition = self.LastPlayerPosition;
			lastPosition[1] = lM;
			lastPosition[2] = lF;
			lastPosition[3] = lx;
			lastPosition[4] = ly;
		else
			lM, lF, lx, ly = unpack(self.LastPlayerPosition);
		end
	end
	
	local dist, xDist, yDist = self:ComputeDistance(lM, lF, lx, ly, mapID, mapFloor, xPos, yPos);
	if not ( dist ) then
		--icon's position has no meaningful position relative to the player's current location
		return -1;
	end
	
	local iconData = GetWorkingTable(icon);
	if ( self.MinimapIcons[icon] ) then
		self.MinimapIcons[icon] = nil;
	else
		self.MinimapIconCount = self.MinimapIconCount + 1
	end
	
	AddedOrUpdatedIcons[icon] = iconData
	iconData.mapID = mapID;
	iconData.mapFloor = mapFloor;
	iconData.xPos = xPos;
	iconData.yPos = yPos;
	iconData.dist = dist;
	iconData.xDist = xDist;
	iconData.yDist = yDist;
	
	minimapRotationEnabled = GetCVar("rotateMinimap") ~= "0"
	if ( minimapRotationEnabled ) then
		minimapRotationOffset = GetPlayerFacing();
	end
	
	-- check Minimap Shape
	minimapShape = GetMinimapShape and ValidMinimapShapes[GetMinimapShape()];
	
	-- place the icon on the Minimap and :Show() it
	local map = Minimap
	placeIconOnMinimap(map, map:GetZoom(), map:GetWidth(), map:GetHeight(), icon, dist, xDist, yDist);
	icon:Show()
	
	-- We know this icon's position is valid, so we need to make sure the icon placement system is active.  
	self.processingFrame:Show()
	
	return 0;
end

function Astrolabe:RemoveIconFromMinimap( icon )
	if not ( self.MinimapIcons[icon] ) then
		return 1;
	end
	AddedOrUpdatedIcons[icon] = nil
	self.MinimapIcons[icon] = nil;
	self.IconsOnEdge[icon] = nil;
	icon:Hide();
	
	local MinimapIconCount = self.MinimapIconCount - 1
	if ( MinimapIconCount <= 0 ) then
		-- no icons left to manage
		self.processingFrame:Hide()
		MinimapIconCount = 0 -- because I'm paranoid
	end
	self.MinimapIconCount = MinimapIconCount
	
	return 0;
end

function Astrolabe:RemoveAllMinimapIcons()
	self:DumpNewIconsCache()
	local MinimapIcons = self.MinimapIcons;
	local IconsOnEdge = self.IconsOnEdge;
	for k, v in pairs(MinimapIcons) do
		MinimapIcons[k] = nil;
		IconsOnEdge[k] = nil;
		k:Hide();
	end
	self.MinimapIconCount = 0
	self.processingFrame:Hide()
end

local lastZoom; -- to remember the last seen Minimap zoom level

-- local variables to track the status of the two update coroutines
local fullUpdateInProgress = true
local resetIncrementalUpdate = false
local resetFullUpdate = false

-- Incremental Update Code
do
	-- local variables to track the incremental update coroutine
	local incrementalUpdateCrashed = true
	local incrementalUpdateThread
	
	local function UpdateMinimapIconPositions( self )
		yield()
		
		while ( true ) do
			self:DumpNewIconsCache() -- put new/updated icons into the main datacache
			
			resetIncrementalUpdate = false -- by definition, the incremental update is reset if it is here
			
			local M, F, x, y = self:GetCurrentPlayerPosition();
			if ( M and M >= 0 ) then
				local Minimap = Minimap;
				local lastPosition = self.LastPlayerPosition;
				local lM, lF, lx, ly = unpack(lastPosition);
				
				minimapRotationEnabled = GetCVar("rotateMinimap") ~= "0"
				if ( minimapRotationEnabled ) then
					minimapRotationOffset = GetPlayerFacing();
				end
				
				-- check current frame rate
				local numPerCycle = min(50, GetFramerate() * (self.MinimapUpdateMultiplier or 1))
				
				-- check Minimap Shape
				minimapShape = GetMinimapShape and ValidMinimapShapes[GetMinimapShape()];
				
				if ( lM == M and lF == F and lx == x and ly == y ) then
					-- player has not moved since the last update
					if ( lastZoom ~= Minimap:GetZoom() or self.ForceNextUpdate or minimapRotationEnabled ) then
						local currentZoom = Minimap:GetZoom();
						lastZoom = currentZoom;
						local mapWidth = Minimap:GetWidth();
						local mapHeight = Minimap:GetHeight();
						numPerCycle = numPerCycle * 2
						local count = 0
						for icon, data in pairs(self.MinimapIcons) do
							placeIconOnMinimap(Minimap, currentZoom, mapWidth, mapHeight, icon, data.dist, data.xDist, data.yDist);
							
							count = count + 1
							if ( count > numPerCycle ) then
								count = 0
								yield()
								-- check if the incremental update cycle needs to be reset 
								-- because a full update has been run
								if ( resetIncrementalUpdate ) then
									break;
								end
							end
						end
						self.ForceNextUpdate = false;
					end
				else
					local dist, xDelta, yDelta = self:ComputeDistance(lM, lF, lx, ly, M, F, x, y);
					if ( dist ) then
						local currentZoom = Minimap:GetZoom();
						lastZoom = currentZoom;
						local mapWidth = Minimap:GetWidth();
						local mapHeight = Minimap:GetHeight();
						local count = 0
						for icon, data in pairs(self.MinimapIcons) do
							local xDist = data.xDist - xDelta;
							local yDist = data.yDist - yDelta;
							local dist = sqrt(xDist*xDist + yDist*yDist);
							placeIconOnMinimap(Minimap, currentZoom, mapWidth, mapHeight, icon, dist, xDist, yDist);
							
							data.dist = dist;
							data.xDist = xDist;
							data.yDist = yDist;
							
							count = count + 1
							if ( count >= numPerCycle ) then
								count = 0
								yield()
								-- check if the incremental update cycle needs to be reset 
								-- because a full update has been run
								if ( resetIncrementalUpdate ) then
									break;
								end
							end
						end
						if not ( resetIncrementalUpdate ) then
							lastPosition[1] = M;
							lastPosition[2] = F;
							lastPosition[3] = x;
							lastPosition[4] = y;
						end
					else
						self:RemoveAllMinimapIcons()
						lastPosition[1] = M;
						lastPosition[2] = F;
						lastPosition[3] = x;
						lastPosition[4] = y;
					end
				end
			else
				if not ( self.WorldMapVisible ) then
					self.processingFrame:Hide();
				end
			end
			
			-- if we've been reset, then we want to start the new cycle immediately
			if not ( resetIncrementalUpdate ) then
				yield()
			end
		end
	end
	
	function Astrolabe:UpdateMinimapIconPositions()
		if ( fullUpdateInProgress ) then
			-- if we're in the middle a a full update, we want to finish that first
			self:CalculateMinimapIconPositions()
		else
			if ( incrementalUpdateCrashed ) then
				incrementalUpdateThread = coroutine.wrap(UpdateMinimapIconPositions)
				incrementalUpdateThread(self) --initialize the thread
			end
			incrementalUpdateCrashed = true
			incrementalUpdateThread()
			incrementalUpdateCrashed = false
		end
	end
end

-- Full Update Code
do
	-- local variables to track the full update coroutine
	local fullUpdateCrashed = true
	local fullUpdateThread
	
	local function CalculateMinimapIconPositions( self )
		yield()
		
		while ( true ) do
			self:DumpNewIconsCache() -- put new/updated icons into the main datacache
			
			resetFullUpdate = false -- by definition, the full update is reset if it is here
			fullUpdateInProgress = true -- set the flag the says a full update is in progress
			
			local M, F, x, y = self:GetCurrentPlayerPosition();
			if ( M and M >= 0 ) then
				minimapRotationEnabled = GetCVar("rotateMinimap") ~= "0"
				if ( minimapRotationEnabled ) then
					minimapRotationOffset = GetPlayerFacing();
				end
				
				-- check current frame rate
				local numPerCycle = GetFramerate() * (self.MinimapUpdateMultiplier or 1) * 2
				
				-- check Minimap Shape
				minimapShape = GetMinimapShape and ValidMinimapShapes[GetMinimapShape()];
				
				local currentZoom = Minimap:GetZoom();
				lastZoom = currentZoom;
				local Minimap = Minimap;
				local mapWidth = Minimap:GetWidth();
				local mapHeight = Minimap:GetHeight();
				local count = 0
				for icon, data in pairs(self.MinimapIcons) do
					local dist, xDist, yDist = self:ComputeDistance(M, F, x, y, data.mapID, data.mapFloor, data.xPos, data.yPos);
					if ( dist ) then
						placeIconOnMinimap(Minimap, currentZoom, mapWidth, mapHeight, icon, dist, xDist, yDist);
						
						data.dist = dist;
						data.xDist = xDist;
						data.yDist = yDist;
					else
						self:RemoveIconFromMinimap(icon)
					end
					
					count = count + 1
					if ( count >= numPerCycle ) then
						count = 0
						yield()
						-- check if we need to restart due to the full update being reset
						if ( resetFullUpdate ) then
							break;
						end
					end
				end
				
				if not ( resetFullUpdate ) then
					local lastPosition = self.LastPlayerPosition;
					lastPosition[1] = M;
					lastPosition[2] = F;
					lastPosition[3] = x;
					lastPosition[4] = y;
					
					resetIncrementalUpdate = true
				end
			else
				if not ( self.WorldMapVisible ) then
					self.processingFrame:Hide();
				end
			end
			
			-- if we've been reset, then we want to start the new cycle immediately
			if not ( resetFullUpdate ) then
				fullUpdateInProgress = false
				yield()
			end
		end
	end
	
	function Astrolabe:CalculateMinimapIconPositions( reset )
		if ( fullUpdateCrashed ) then
			fullUpdateThread = coroutine.wrap(CalculateMinimapIconPositions)
			fullUpdateThread(self) --initialize the thread
		elseif ( reset ) then
			resetFullUpdate = true
		end
		fullUpdateCrashed = true
		fullUpdateThread()
		fullUpdateCrashed = false
		
		-- return result flag
		if ( fullUpdateInProgress ) then
			return 1 -- full update started, but did not complete on this cycle
		
		else
			if ( resetIncrementalUpdate ) then
				return 0 -- update completed
			else
				return -1 -- full update did no occur for some reason
			end
		
		end
	end
end

function Astrolabe:GetDistanceToIcon( icon )
	local data = self.MinimapIcons[icon];
	if ( data ) then
		return data.dist, data.xDist, data.yDist;
	end
end

function Astrolabe:IsIconOnEdge( icon )
	return self.IconsOnEdge[icon];
end

function Astrolabe:GetDirectionToIcon( icon )
	local data = self.MinimapIcons[icon];
	if ( data ) then
		local dir = atan2(data.xDist, -(data.yDist))
		if ( dir > 0 ) then
			return twoPi - dir;
		else
			return -dir;
		end
	end
end

function Astrolabe:Register_OnEdgeChanged_Callback( func, ident )
	-- check argument types
	argcheck(func, 2, "function");
	
	self.IconsOnEdge_GroupChangeCallbacks[func] = ident;
end

--*****************************************************************************
-- INTERNAL USE ONLY PLEASE!!!
-- Calling this function at the wrong time can cause errors
--*****************************************************************************
function Astrolabe:DumpNewIconsCache()
	local MinimapIcons = self.MinimapIcons
	for icon, data in pairs(AddedOrUpdatedIcons) do
		MinimapIcons[icon] = data
		AddedOrUpdatedIcons[icon] = nil
	end
	-- we now need to restart any updates that were in progress
	resetIncrementalUpdate = true
	resetFullUpdate = true
end


--------------------------------------------------------------------------------------------------------------
-- World Map Icon Placement
--------------------------------------------------------------------------------------------------------------

function Astrolabe:PlaceIconOnWorldMap( worldMapFrame, icon, mapID, mapFloor, xPos, yPos )
	-- check argument types
	argcheck(worldMapFrame, 2, "table");
	assert(3, worldMapFrame.GetWidth and worldMapFrame.GetHeight, "Usage Message");
	argcheck(icon, 3, "table");
	assert(3, icon.SetPoint and icon.ClearAllPoints, "Usage Message");
	argcheck(mapID, 4, "number");
	argcheck(mapFloor, 5, "number", "nil");
	argcheck(xPos, 6, "number");
	argcheck(yPos, 7, "number");
	
	local M, F = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel();
	local nX, nY = self:TranslateWorldMapPosition(mapID, mapFloor, xPos, yPos, M, F);
	
	-- anchor and :Show() the icon if it is within the boundry of the current map, :Hide() it otherwise
	if ( nX and nY and (0 < nX and nX <= 1) and (0 < nY and nY <= 1) ) then
		icon:ClearAllPoints();
		icon:SetPoint("CENTER", worldMapFrame, "TOPLEFT", nX * worldMapFrame:GetWidth(), -nY * worldMapFrame:GetHeight());
		icon:Show();
	else
		icon:Hide();
	end
	return nX, nY;
end


--------------------------------------------------------------------------------------------------------------
-- Handler Scripts
--------------------------------------------------------------------------------------------------------------

function Astrolabe:OnEvent( frame, event )
	if ( event == "MINIMAP_UPDATE_ZOOM" ) then
		-- update minimap zoom scale
		local Minimap = Minimap;
		local curZoom = Minimap:GetZoom();
		if ( GetCVar("minimapZoom") == GetCVar("minimapInsideZoom") ) then
			if ( curZoom < 2 ) then
				Minimap:SetZoom(curZoom + 1);
			else
				Minimap:SetZoom(curZoom - 1);
			end
		end
		if ( GetCVar("minimapZoom")+0 == Minimap:GetZoom() ) then
			self.minimapOutside = true;
		else
			self.minimapOutside = false;
		end
		Minimap:SetZoom(curZoom);
		
		-- re-calculate all Minimap Icon positions
		if ( frame:IsVisible() ) then
			self:CalculateMinimapIconPositions(true);
		end
	
	elseif ( event == "PLAYER_LEAVING_WORLD" ) then
		frame:Hide(); -- yes, I know this is redunant
		self:RemoveAllMinimapIcons(); --dump all minimap icons
		-- TODO: when I uncouple the point buffer from Minimap drawing,
		--       I should consider updating LastPlayerPosition here
	
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		frame:Show();
		if not ( frame:IsVisible() ) then
			-- do the minimap recalculation anyways if the OnShow script didn't execute
			-- this is done to ensure the accuracy of information about icons that were 
			-- inserted while the Player was in the process of zoning
			self:CalculateMinimapIconPositions(true);
		end
	
	elseif ( event == "ZONE_CHANGED_NEW_AREA" ) then
		frame:Hide();
		frame:Show();
	
	end
end

function Astrolabe:OnUpdate( frame, elapsed )
	-- on-edge group changed call-backs
	if ( self.IconsOnEdgeChanged ) then
		self.IconsOnEdgeChanged = false;
		for func in pairs(self.IconsOnEdge_GroupChangeCallbacks) do
			pcall(func);
		end
	end
	
	self:UpdateMinimapIconPositions();
end

function Astrolabe:OnShow( frame )
	-- set the world map to a zoom with a valid player position
	if not ( self.WorldMapVisible ) then
		SetMapToCurrentZone();
	end
	local M, F = Astrolabe:GetCurrentPlayerPosition();
	if ( M and M >= 0 ) then
		SetMapByID(M);
		SetDungeonMapLevel(F);
	else
		frame:Hide();
		return
	end
	
	-- re-calculate minimap icon positions (if needed)
	if ( next(self.MinimapIcons) ) then
		self:CalculateMinimapIconPositions(true);
	else
		-- needed so that the cycle doesn't overwrite an updated LastPlayerPosition
		resetIncrementalUpdate = true;
	end
	
	if ( self.MinimapIconCount <= 0 ) then
		-- no icons left to manage
		frame:Hide();
	end
end

function Astrolabe:OnHide( frame )
	-- dump the new icons cache here
	-- a full update will performed the next time processing is re-actived
	self:DumpNewIconsCache()
end

-- called by AstrolabMapMonitor when all world maps are hidden
function Astrolabe:AllWorldMapsHidden()
	if ( IsLoggedIn() ) then
		self.processingFrame:Hide();
		self.processingFrame:Show();
	end
end


--------------------------------------------------------------------------------------------------------------
-- Library Registration
--------------------------------------------------------------------------------------------------------------

local function harvestMapData( HarvestedMapData )
	local mapData = {}
	local mapName = GetMapInfo();
	local mapID = GetCurrentMapAreaID();
	local numFloors = GetNumDungeonMapLevels();
	mapData.mapName = mapName;
	mapData.cont = (GetCurrentMapContinent()) or -100;
	mapData.zone = (GetCurrentMapZone()) or -100;
	mapData.numFloors = numFloors;
	local _, TLx, TLy, BRx, BRy = GetCurrentMapZone();
	if ( TLx and TLy and BRx and BRy ) then
		mapData[0] = {};
		if not ( TLx < BRx ) then
			TLx = -TLx;
			BRx = -BRx;
		end
		if not ( TLy < BRy) then
			TLy = -TLy;
			BRy = -BRy;
		end
		mapData[0].TLx = TLx;
		mapData[0].TLy = TLy;
		mapData[0].BRx = BRx;
		mapData[0].BRy = BRy;
	end
	if ( numFloors > 0 ) then
		for f = 1, numFloors do
			SetDungeonMapLevel(f);
			local _, TLx, TLy, BRx, BRy = GetCurrentMapDungeonLevel();
			if ( TLx and TLy and BRx and BRy ) then
				mapData[f] = {};
				if not ( TLx < BRx ) then
					TLx = -TLx;
					BRx = -BRx;
				end
				if not ( TLy < BRy) then
					TLy = -TLy;
					BRy = -BRy;
				end
				mapData[f].TLx = TLx;
				mapData[f].TLy = TLy;
				mapData[f].BRx = BRx;
				mapData[f].BRy = BRy;
			end
		end
	end
	HarvestedMapData[mapID] = mapData;
end

local function activate( newInstance, oldInstance )
	if ( oldInstance ) then -- this is an upgrade activate
		if ( oldInstance.DumpNewIconsCache ) then
			oldInstance:DumpNewIconsCache()
		end
		for k, v in pairs(oldInstance) do
			if ( type(v) ~= "function" and (not configConstants[k]) ) then
				newInstance[k] = v;
			end
		end
		-- sync up the current MinimapIconCount value
		local iconCount = 0
		for _ in pairs(newInstance.MinimapIcons) do
			iconCount = iconCount + 1
		end
		newInstance.MinimapIconCount = iconCount
		
		Astrolabe = oldInstance;
	else
		local frame = CreateFrame("Frame");
		newInstance.processingFrame = frame;
		
		newInstance.HarvestedMapData = {};
		local HarvestedMapData = newInstance.HarvestedMapData;
		
		newInstance.ContinentList = { GetMapContinents() };
		for C in pairs(newInstance.ContinentList) do
			local zones = { GetMapZones(C) };
			newInstance.ContinentList[C] = zones;
			SetMapZoom(C, 0);
			zones[0] = GetCurrentMapAreaID();
			harvestMapData(HarvestedMapData);
			for Z in ipairs(zones) do
				SetMapZoom(C, Z);
				zones[Z] = GetCurrentMapAreaID();
				harvestMapData(HarvestedMapData);
			end
		end
		
		for id=1,10000 do
			if not ( HarvestedMapData[id] ) then
				if ( SetMapByID(id) ) then
					harvestMapData(HarvestedMapData);
				end
			end
		end
	end
	configConstants = nil -- we don't need this anymore
	
	local frame = newInstance.processingFrame;
	frame:Hide();
	frame:SetParent("Minimap");
	frame:UnregisterAllEvents();
	frame:RegisterEvent("MINIMAP_UPDATE_ZOOM");
	frame:RegisterEvent("PLAYER_LEAVING_WORLD");
	frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	frame:SetScript("OnEvent",
		function( frame, event, ... )
			Astrolabe:OnEvent(frame, event, ...);
		end
	);
	frame:SetScript("OnUpdate",
		function( frame, elapsed )
			Astrolabe:OnUpdate(frame, elapsed);
		end
	);
	frame:SetScript("OnShow",
		function( frame )
			Astrolabe:OnShow(frame);
		end
	);
	frame:SetScript("OnHide",
		function( frame )
			Astrolabe:OnHide(frame);
		end
	);
	
	setmetatable(Astrolabe.MinimapIcons, MinimapIconsMetatable)
end

DongleStub:Register(Astrolabe, activate)


--------------------------------------------------------------------------------------------------------------
-- Data
--------------------------------------------------------------------------------------------------------------

-- diameter of the Minimap in game yards at
-- the various possible zoom levels
MinimapSize = {
	indoor = {
		[0] = 300, -- scale
		[1] = 240, -- 1.25
		[2] = 180, -- 5/3
		[3] = 120, -- 2.5
		[4] = 80,  -- 3.75
		[5] = 50,  -- 6
	},
	outdoor = {
		[0] = 466 + 2/3, -- scale
		[1] = 400,       -- 7/6
		[2] = 333 + 1/3, -- 1.4
		[3] = 266 + 2/6, -- 1.75
		[4] = 200,       -- 7/3
		[5] = 133 + 1/3, -- 3.5
	},
}

ValidMinimapShapes = {
	-- { upper-left, lower-left, upper-right, lower-right }
	["SQUARE"]                = { false, false, false, false },
	["CORNER-TOPLEFT"]        = { true,  false, false, false },
	["CORNER-TOPRIGHT"]       = { false, false, true,  false },
	["CORNER-BOTTOMLEFT"]     = { false, true,  false, false },
	["CORNER-BOTTOMRIGHT"]    = { false, false, false, true },
	["SIDE-LEFT"]             = { true,  true,  false, false },
	["SIDE-RIGHT"]            = { false, false, true,  true },
	["SIDE-TOP"]              = { true,  false, true,  false },
	["SIDE-BOTTOM"]           = { false, true,  false, true },
	["TRICORNER-TOPLEFT"]     = { true,  true,  true,  false },
	["TRICORNER-TOPRIGHT"]    = { true,  false, true,  true },
	["TRICORNER-BOTTOMLEFT"]  = { true,  true,  false, true },
	["TRICORNER-BOTTOMRIGHT"] = { false, true,  true,  true },
}

-- distances across and offsets of the world maps
-- in game yards
WorldMapSize = {
	[0] = {
		height = 31809.52239,
		system = 0,
		systemParent = 0,
		width = 47714.28663,
		xOffset = 0,
		yOffset = 0,
		[13] = {
			xOffset = -8476.18926,
			yOffset = -18428.5703,
		},
		[14] = {
			xOffset = -36714.28738,
			yOffset = -14761.90436,
		},
		[485] = {
			xOffset = -25238.09554,
			yOffset = -11047.61835,
		},
	},
	[13] = {
		height = 24533.19945,
		systemParent = 0,
		width = 36799.81197,
		xOffset = -17066.60126,
		yOffset = -12799.89961,
	},
	[14] = {
		height = 27149.68748,
		systemParent = 0,
		width = 40741.17907,
		xOffset = -18171.96844,
		yOffset = -11176.34367,
	},
	[321] = {
		{ -- [1]
			height = 1159.5835,
			width = 1739.375,
			xOffset = 3506.354,
			yOffset = -2486.66675,
		},
		{ -- [2]
			height = 241.39025,
			width = 362.08962,
			xOffset = 4163.96713,
			yOffset = -1932.27183,
		},
		xOffset = 8690.02719,
		yOffset = -3623.15183,
	},
	[401] = {
		height = 2825.00046,
		width = 4237.49828,
		xOffset = 0,
		yOffset = 0,
	},
	[443] = {
		height = 764.58325,
		width = 1145.83472,
		xOffset = 0,
		yOffset = 0,
	},
	[461] = {
		height = 1170.83309,
		width = 1756.25023,
		xOffset = 0,
		yOffset = 0,
	},
	[462] = {
		height = 3283.33296,
		width = 4924.99935,
		xOffset = 2087.50023,
		yOffset = -8641.66578,
	},
	[463] = {
		height = 2200.0001,
		width = 3300.00085,
		xOffset = 2883.33272,
		yOffset = -5866.66614,
	},
	[464] = {
		height = 2714.58133,
		width = 4070.83028,
		xOffset = -7099.9985,
		yOffset = -7339.58233,
	},
	[466] = {
		height = 11642.71843,
		systemParent = 466,
		width = 17464.0779,
		xOffset = -12996.03902,
		yOffset = -5821.35914,
	},
	[471] = {
		height = 704.68794,
		width = 1056.7699,
		xOffset = -6533.63241,
		yOffset = -6523.64995,
	},
	[476] = {
		height = 2174.99908,
		width = 3262.50031,
		xOffset = -7525.00003,
		yOffset = -9374.99943,
	},
	[480] = {
		height = 806.7719,
		width = 1211.45871,
		xOffset = 4000.74932,
		yOffset = -7753.70939,
	},
	[482] = {
		height = 1514.58311,
		width = 2270.83529,
		xOffset = 0,
		yOffset = 0,
	},
	[485] = {
		height = 11834.26515,
		systemParent = 0,
		width = 17751.39839,
		xOffset = -9217.15231,
		yOffset = -10593.37487,
	},
	[499] = {
		height = 2218.75027,
		width = 3327.08362,
		xOffset = 2902.08234,
		yOffset = -11168.74965,
	},
	[502] = {
		height = 2108.33411,
		width = 3162.49385,
		xOffset = 0,
		yOffset = 0,
	},
	[504] = {
		{ -- [1]
			height = 553.33995,
			width = 830.01643,
			xOffset = -1052.51109,
			yOffset = -6066.67115,
		},
		{ -- [2]
			height = 375.48927,
			width = 563.22279,
			xOffset = -915.86865,
			yOffset = -5975.33259,
		},
		xOffset = -1270.796,
		yOffset = -11581.57677,
	},
	[512] = {
		height = 1162.50002,
		width = 1743.74946,
		xOffset = 0,
		yOffset = 0,
	},
	[521] = {
		{ -- [1]
			height = 1216.66649,
			width = 1824.99985,
			xOffset = 435.33678,
			yOffset = 2235.80349,
		},
	},
	[529] = {
		{ -- [1]
			height = 2191.66598,
			width = 3287.50074,
			xOffset = -1804.35279,
			yOffset = 2062.9701,
		},
	},
	[531] = {
		height = 774.99991,
		width = 1162.49961,
		xOffset = 0,
		yOffset = 0,
	},
	[540] = {
		height = 1766.66716,
		width = 2650.00164,
		xOffset = 0,
		yOffset = 0,
	},
	[544] = {
		system = 544,
	},
	[545] = {
		height = 2097.91669,
		width = 3145.83325,
		xOffset = 0,
		yOffset = 0,
	},
	[602] = {
		height = 1022.91668,
		width = 1533.33347,
		xOffset = 0,
		yOffset = 0,
	},
	[605] = {
		system = 605,
	},
	[609] = {
		height = 502.08329,
		width = 752.08331,
		xOffset = 0,
		yOffset = 0,
	},
	[611] = {
		height = 593.74988,
		width = 889.58325,
		xOffset = 0,
		yOffset = 0,
	},
	[640] = {
		system = 640,
	},
	[677] = {
		height = 593.74988,
		width = 889.58325,
		xOffset = 0,
		yOffset = 0,
	},
	[678] = {
		height = 2097.91669,
		width = 3145.83325,
		xOffset = 0,
		yOffset = 0,
	},
	[679] = {
		height = 2097.91669,
		width = 3145.83325,
		xOffset = 0,
		yOffset = 0,
	},
	[681] = {
		height = 3010.41666,
		width = 4514.58301,
		xOffset = 0,
		yOffset = 0,
	},
	[682] = {
		height = 3010.41666,
		width = 4514.58301,
		xOffset = 0,
		yOffset = 0,
	},
	[686] = {
		height = 922.9166,
		width = 1383.33334,
		xOffset = 0,
		yOffset = 0,
	},
	[708] = {
		height = 1343.75002,
		width = 2014.58153,
		xOffset = -4810.41584,
		yOffset = 2160.41647,
	},
	[709] = {
		height = 1224.99954,
		width = 1837.49974,
		xOffset = -5212.4997,
		yOffset = 1222.91666,
	},
	[717] = {
		height = 1674.99988,
		width = 2512.4912,
		xOffset = 0,
		yOffset = 0,
	},
	[737] = {
		system = 737,
	},
}

local function zeroDataFunc(tbl, key)
	if ( type(key) == "number" ) then
		return zeroData;
	else
		return 0;
	end
end

zeroData = { xOffset = 0, height = 0, yOffset = 0, width = 0, __index = zeroDataFunc };
setmetatable(zeroData, zeroData);

local function printError( ... )
	if ( ASTROLABE_VERBOSE) then
		print(...)
	end
end

for mapID, harvestedData in pairs(Astrolabe.HarvestedMapData) do
	local mapData = WorldMapSize[mapID];
	if ( mapData ) then
		if ( harvestedData.numFloors > 0 ) then
			for f, harvData in pairs(harvestedData) do
				if ( type(f) == "number" and f > 0 ) then
					if not ( mapData[f] ) then
						mapData[f] = {};
					end
					local floorData = mapData[f]
					if not ( floorData.width ) then
						floorData.width = harvData.BRx - harvData.TLx
					end
					if not ( floorData.height ) then
						floorData.height = harvData.BRy - harvData.TLy
					end
					if not ( floorData.xOffset ) then
						floorData.xOffset = harvData.TLx
					end
					if not ( floorData.yOffset ) then
						floorData.yOffset = harvData.TLy
					end
				end
			end
			for f = 1, harvestedData.numFloors do
				if not ( mapData[f] ) then
					printError(("Astrolabe is missing data for %s [%d], floor %d."):format(harvestedData.mapName, mapID, f));
				end
			end
			-- TODO: handle floored world maps
		
		else
			local harvData = harvestedData[0]
			if not ( mapData.width ) then
				mapData.width = harvData.BRx - harvData.TLx
			end
			if not ( mapData.height ) then
				mapData.height = harvData.BRy - harvData.TLy
			end
			if not ( mapData.xOffset ) then
				mapData.xOffset = harvData.TLx
			end
			if not ( mapData.yOffset ) then
				mapData.yOffset = harvData.TLy
			end
		
		end
	
	else
		mapData = {};
		
		if ( harvestedData.numFloors > 0 ) then
			for f, harvData in pairs(harvestedData) do
				if ( type(f) == "number" and f > 0 ) then
					mapData[f] = {};
					local floorData = mapData[f]
					floorData.width = harvData.BRx - harvData.TLx
					floorData.height = harvData.BRy - harvData.TLy
					floorData.xOffset = harvData.TLx
					floorData.yOffset = harvData.TLy
				end
			end
			for f = 1, harvestedData.numFloors do
				if not ( mapData[f] ) then
					printError(("Astrolabe is missing data for %s [%d], floor %d."):format(harvestedData.mapName, mapID, f));
				end
			end
		
		else
			local harvData = harvestedData[0]
			if ( harvData ) then
				mapData.width = harvData.BRx - harvData.TLx
				mapData.height = harvData.BRy - harvData.TLy
				mapData.xOffset = harvData.TLx
				mapData.yOffset = harvData.TLy
			
			else
				printError(("Astrolabe is missing data for %s [%d]."):format(harvestedData.mapName, mapID));
			
			end
		
		end
		
		-- if we don't have any data, we're gonna use zeroData, but we also need to 
		-- setup the system and systemParent IDs so things don't get confused
		if not ( next(mapData, nil) ) then
			mapData = { xOffset = 0, height = 0, yOffset = 0, width = 0 };
			-- if this is an outside continent level or world map then throw up an extra warning
			if ( harvestedData.cont > 0 and harvestedData.zone == 0 ) then
				printError(("Astrolabe is missing data for world map %s [%d] (%d, %d)."):format(harvestedData.mapName, mapID, harvestedData.cont, harvestedData.zone));
			end
		end
		
		-- store the data in the WorldMapSize DB
		WorldMapSize[mapID] = mapData;
	
	end
	
	-- setup system and systemParent IDs
	if ( mapData and mapData ~= zeroData ) then
		if not ( mapData.system ) then
			mapData.system = mapID;
			
			if ( harvestedData.cont > 0 and harvestedData.zone > 0 ) then
				mapData.system = Astrolabe:GetMapID(harvestedData.cont, nil);
			end
		end
		if not ( mapData.systemParent ) then
			mapData.systemParent = mapID;
			
			local systemData = WorldMapSize[mapData.system];
			if ( systemData and systemData.systemParent ) then
				mapData.systemParent = systemData.systemParent;
			end
		end
		
		-- systemParent sanity checks
		if ( mapData.system ~= mapData.systemParent ) then
			if not ( WorldMapSize[mapData.systemParent] and WorldMapSize[mapData.systemParent][mapData.system] ) then
				printError("Astrolabe detected a child system that the parent doesn't know about.  VERY BAD!!!");
			end
		end
		
		setmetatable(mapData, zeroData);
	end
end

setmetatable(WorldMapSize[0], zeroData); -- special case for World Map

-- make sure we don't have any EXTRA data hanging around
for mapID, mapData in pairs(WorldMapSize) do
	if ( getmetatable(mapData) ~= zeroData ) then
		printError("Astrolabe has hard coded data for an invalid map ID", mapID);
	end
end

setmetatable(WorldMapSize, zeroData); -- setup the metatable so that invalid map IDs don't cause Lua errors

-- register this library with AstrolabeMapMonitor, this will cause a full update if PLAYER_LOGIN has already fired
local AstrolabeMapMonitor = DongleStub("AstrolabeMapMonitor");
AstrolabeMapMonitor:RegisterAstrolabeLibrary(Astrolabe, LIBRARY_VERSION_MAJOR);
