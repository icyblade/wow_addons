-- Set Map Scale (Examples: 1 for default, 1.1 through 1.9, 2, etc.)
Minimap:SetScale(1.25)

-- Pass SquareMap Shape Onto Other Addons
function GetMinimapShape()
	return 'SQUARE'
end
Minimap:SetMaskTexture'Interface/Buttons/WHITE8X8'

-- Clear Default Anchors / Enable Movable Map
Minimap:ClearAllPoints()
Minimap:SetMovable(true)
Minimap:EnableMouse(true)
Minimap:RegisterForDrag("LeftButton")
Minimap:SetScript("OnDragStart", function(self)
	if IsAltKeyDown() then self:StartMoving()
	end
end)
Minimap:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
end)
Minimap:SetUserPlaced(true)

-- Set Square Shape For Addon Buttons
function GetMinimapShape()
	return "SQUARE"
end

-- Hide Objects
MinimapZoomIn:Hide()			-- Zoom In Button
MinimapZoomOut:Hide()			-- Zoom Out Button
MiniMapWorldMapButton:Hide()	-- World Map Button
MinimapNorthTag:SetTexture()	-- North Compass Pointer
MinimapZoneTextButton:Hide()	-- Zone Name	
MinimapBorderTop:Hide()			-- Zone Name Border

--	Mail Button Placement
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("TOPLEFT", Minimap, 0, 0)
MiniMapMailFrame:SetScale(1)

-- Voice Chat Button Placement
MiniMapVoiceChatFrame:ClearAllPoints()
MiniMapVoiceChatFrame:SetPoint("TOPLEFT", Minimap, 0, -30)
MiniMapVoiceChatFrame:SetScale(1)

-- LFG / Battleground Button Placement
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("BOTTOMLEFT", Minimap, 0, 0)
QueueStatusMinimapButton:SetScale(1)

-- Garrison Report Button Placement
GarrisonLandingPageMinimapButton:ClearAllPoints()
GarrisonLandingPageMinimapButton:SetPoint("BOTTOMRIGHT", Minimap, -40, -3)
GarrisonLandingPageMinimapButton:SetScale(.7)

-- Tracking Button Placement
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("BOTTOMRIGHT", Minimap, 0, 0)
MiniMapTracking:SetScale(1)

-- Instance Difficulty Button Placement
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, 0, -35)
MiniMapInstanceDifficulty:SetScale(1)

-- Guild Instance Difficulty Button Placement
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, 0, -35)
GuildInstanceDifficulty:SetScale(1)

-- Challenge Mode Instance Difficulty Button Placement
MiniMapChallengeMode:ClearAllPoints()
MiniMapChallengeMode:SetPoint("TOPRIGHT", Minimap, 0, -35)
MiniMapChallengeMode:SetScale(1)

-- Calendar Button Placement
GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT", Minimap, 0, 0)
GameTimeFrame:SetScale(.75)

-- Clock Placement
LoadAddOn('Blizzard_TimeManager')
local clockFrame, clockTime = TimeManagerClockButton:GetRegions()
	clockFrame:Hide()
	clockTime:Show()
	clockTime:SetFont([[FONTS\FRIZQT__.ttf]], 12, 'OUTLINE')
	TimeManagerClockButton:ClearAllPoints()
	TimeManagerClockButton:SetPoint("CENTER", Minimap, "TOP", 0, -8)

-- Set Default Map X/Y Position
Minimap:SetPoint('TOPRIGHT', UIParent, -5, -5)

-- Set Square Map View
MinimapBorder:Hide()
Minimap:SetArchBlobRingScalar(0)
Minimap:SetQuestBlobRingScalar(0)

-- Set Background Texture
Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')

-- Set Boarder Texture
MinimapBackdrop:SetBackdrop({
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = {left = 3, right = 3, top = 3, bottom = 3}
})
MinimapBackdrop:ClearAllPoints()
MinimapBackdrop:SetBackdropBorderColor(0.75, 0.75, 0.75)
MinimapBackdrop:SetBackdropColor(0.15, 0.15, 0.15, 0.0)
MinimapBackdrop:SetAlpha(1.0)
MinimapBackdrop:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -4, 4)
MinimapBackdrop:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 4, -4)

-- Enable Mouse Wheel Scrolling
Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, direction)
local zoom, maxZoom = self:GetZoom() + direction, self:GetZoomLevels()
	self:SetZoom(zoom >= maxZoom and maxZoom or zoom <= 0 and 0 or zoom)
end)