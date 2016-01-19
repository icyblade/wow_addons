--[[ File
NAME: TitanMovable.lua
DESC: Contains the routines to adjust the Blizzard frames to make room for the Titan bars the user has selected.
There are a select set of Blizzard frames at the top of screen and at the bottom of the screen that Titan will move.
Each frame adjusted has an entry in TitanMovableData. TitanMovableData is local and not directly accessible via addons.
However addons can tell Titan to not adjust some or all frames using TitanUtils_AddonAdjust(frame, bool). Addons that replace all or parts of the Blizzard UI use this.

The user can turn turn on / off the adjusting of all top frames or all bottom frames.
In addition the user can select to turn off / on adjusting of select top frames (minimap or ticket frame) or select bottom frames (chat / log or bags)
:DESC
--]]
-- Globals

-- Locals
local _G = getfenv(0);
local InCombatLockdown	= _G.InCombatLockdown;

--[[ Titan
Declare the Ace routines
 local AceTimer = LibStub("AceTimer-3.0")
 i.e. TitanPanelAce.ScheduleTimer("LDBToTitanSetText", TitanLDBRefreshButton, 2);
 or
 i.e. TitanPanelAce:ScheduleTimer(TitanLDBRefreshButton, 2);

 Be careful that the 'self' is proper to cancel timers!!!
--]]
local TitanPanelAce = LibStub("AceAddon-3.0"):NewAddon("TitanPanel", "AceHook-3.0", "AceTimer-3.0")

--Determines the optimal magic number based on resolution
--local menuBarTop = 55;
--local width, height = string.match((({GetScreenResolutions()})[GetCurrentResolution()] or ""), "(%d+).-(%d+)");
--if ( tonumber(width) / tonumber(height ) > 4/3 ) then
	--Widescreen resolution
--	menuBarTop = 75;
--end


--[[ Titan
TitanMovable is a local table that is cleared then filled with the frames Titan needs to check and adjust, if necessary, with each 'adjust frame' check.
--]]
local TitanMovable = {};
--[[ Titan
NAME: TitanMovableData table
DESC: TitanMovableData is a local table that holds each frame Titan may need to adjust. It also has the anchor points and offsets needed to make room for the Titan bar(s)

The index is the frame name. Each record contains:
frameName - frame name (string) to adjust
frameArchor - the frame anchor point
xArchor - anchor relative to the frameName
y - any additional adjustment in the y axis
position - top or bottom
addonAdj - true if another addon is taking responsibility of adjusting this frame, if false Titan will use the user setttings to adjust or not
:DESC
--]]
local TitanMovableData = {
	PlayerFrame = {frameName = "PlayerFrame", frameArchor = "TOPLEFT", xArchor = "LEFT", y = -4, 
		position = TITAN_PANEL_PLACE_TOP, addonAdj = false},
	TargetFrame = {frameName = "TargetFrame", frameArchor = "TOPLEFT", xArchor = "LEFT", y = -4, 
		position = TITAN_PANEL_PLACE_TOP, addonAdj = false},
	PartyMemberFrame1 = {frameName = "PartyMemberFrame1", frameArchor = "TOPLEFT", xArchor = "LEFT", y = -128, 
		position = TITAN_PANEL_PLACE_TOP, addonAdj = false},
	TicketStatusFrame = {frameName = "TicketStatusFrame", frameArchor = "TOPRIGHT", xArchor = "RIGHT", y = 0, 
		position = TITAN_PANEL_PLACE_TOP, addonAdj = false},
	BuffFrame = {frameName = "BuffFrame", frameArchor = "TOPRIGHT", xArchor = "RIGHT", y = -13, 
		position = TITAN_PANEL_PLACE_TOP, addonAdj = false},
	MinimapCluster = {frameName = "MinimapCluster", frameArchor = "TOPRIGHT", xArchor = "RIGHT", y = 0, 
		position = TITAN_PANEL_PLACE_TOP, addonAdj = false},
	WorldStateAlwaysUpFrame = {frameName = "WorldStateAlwaysUpFrame", frameArchor = "TOP", xArchor = "CENTER", y = -15, 
		position = TITAN_PANEL_PLACE_TOP, addonAdj = false},
	MainMenuBar = {frameName = "MainMenuBar", frameArchor = "BOTTOM", xArchor = "CENTER", y = 0, 
		position = TITAN_PANEL_PLACE_BOTTOM, addonAdj = false},
	MultiBarRight = {frameName = "MultiBarRight", frameArchor = "BOTTOMRIGHT", xArchor = "RIGHT", y = 98, 
		position = TITAN_PANEL_PLACE_BOTTOM, addonAdj = false},
	OverrideActionBar = {frameName = "OverrideActionBar", frameArchor = "BOTTOM", xArchor = "CENTER", y = 0, 
		position = TITAN_PANEL_PLACE_BOTTOM, addonAdj = false},	
--	BonusActionBarFrame = {frameName = "BonusActionBarFrame", frameArchor = "BOTTOM", xArchor = "CENTER", y = 0, 
--		position = TITAN_PANEL_PLACE_BOTTOM, addonAdj = false},
}

--[[ local
NAME: TitanMovableFrame_CheckThisFrame
DESC: Add the given frame to the list so it will be checked. Once 'full' the table will be looped through to see if the frame must be moved or not.
VAR: frameName - frame to check
OUT: None
NOTE: 
-  The frame is added to TitanMovable.
:NOTE
--]]
local function TitanMovableFrame_CheckThisFrame(frameName)
	-- For safety check if the frame is in the table to adjust
	if TitanMovableData[frameName] then
		table.insert(TitanMovable, frameName)
	end
end

--[[ Titan
NAME: TitanMovable_AdjustTimer
DESC: Cancel then add the given timer. The timer must be in TitanTimers.
VAR: ttype - The timer type (string) as defined in TitanTimers
OUT:  None
--]]
function TitanMovable_AdjustTimer(ttype)
	local timer = TitanTimers[ttype]
	if timer then
		TitanPanelAce.CancelAllTimers(timer.obj)
		TitanPanelAce.ScheduleTimer(timer.obj, timer.callback, timer.delay)
	end
end

--[[ Titan
NAME: TitanMovable_AddonAdjust
DESC: Set the given frame to be adjusted or not by another addon. This is called from TitanUtils for a developer API.
VAR: frame - frame name (string)
VAR: bool - true (addon will adjust) or false (Titan will use its settings) 
OUT:  None
--]]
function TitanMovable_AddonAdjust(frame, bool)
	for index, value in pairs(TitanMovableData) do						
		frameData = value
		if frameData then
			frameName = frameData.frameName;
		end

		if (frame == frameName) then
			frameData.addonAdj = bool
		end
	end
end

--[[ API
NAME: TitanMovable_GetPanelYOffset
DESC: Get the Y axis offset Titan needs (1 or 2 bars) at the given position - top or bottom.
VAR: framePosition - TITAN_PANEL_PLACE_TOP or TITAN_PANEL_PLACE_BOTTOM
OUT: Y axis offset, in pixels
NOTE:
- The prefered method to determine the Y offset needed by using TitanUtils_GetBarAnchors().
:NOTE
--]]
function TitanMovable_GetPanelYOffset(framePosition) -- used by other addons
	-- Both top & bottom are figured out but only the
	-- requested postion is returned
	local barnum_top = 0;
	local barnum_bot = 0

	-- If user has the top adjust set then determine the
	-- top offset
	if not TitanPanelGetVar("ScreenAdjust") then
		if TitanPanelGetVar("Bar_Show") then
			barnum_top = 1
		end
		if TitanPanelGetVar("Bar2_Show") then
			barnum_top = 2
		end
	end
	-- If user has the top adjust set then determine the
	-- bottom offset
	if not TitanPanelGetVar("AuxScreenAdjust") then
		if TitanPanelGetVar("AuxBar_Show") then
			barnum_bot = 1
		end
		if TitanPanelGetVar("AuxBar2_Show") then
			barnum_bot = 2
		end
	end
	
	local scale = TitanPanelGetVar("Scale")
	-- return the requested offset
	-- 0 will be returned if the user has not bars showing
	-- or the scale is not valid
	if scale and framePosition then
		if framePosition == TITAN_PANEL_PLACE_TOP then
			return (-TITAN_PANEL_BAR_HEIGHT * scale)*(barnum_top);
		elseif framePosition == TITAN_PANEL_PLACE_BOTTOM then
			return (TITAN_PANEL_BAR_HEIGHT * scale)*(barnum_bot)-1; 
			-- no idea why -1 is needed... seems anchoring to bottom is off a pixel
		end
	end
	return 0
end

--[[ local
NAME: TitanMovableFrame_GetXOffset
DESC: Get the x axis offset Titan needs to adjust the given frame.
VAR: frame - frame object
VAR: point - "LEFT" / "RIGHT" / "TOP" / "BOTTOM" / "CENTER"
OUT: int - X axis offset, in pixels
--]]
local function TitanMovableFrame_GetXOffset(frame, point)
	-- A valid frame and point is required
	-- Determine a proper X offset using the given point (position)
	local ret = 0 -- In case the inputs were invalid or the point was not relevant to the frame then return 0
	if frame and point then
		if point == "LEFT" and frame:GetLeft() and UIParent:GetLeft() then
			ret = frame:GetLeft() - UIParent:GetLeft();
		elseif point == "RIGHT" and frame:GetRight() and UIParent:GetRight() then
			ret = frame:GetRight() - UIParent:GetRight();			
		elseif point == "TOP" and frame:GetTop() and UIParent:GetTop() then
			ret = frame:GetTop() - UIParent:GetTop();
		elseif point == "BOTTOM" and frame:GetBottom() and UIParent:GetBottom() then
			ret = frame:GetBottom() - UIParent:GetBottom();
		elseif point == "CENTER" and frame:GetLeft() and frame:GetRight() 
		and UIParent:GetLeft() and UIParent:GetRight() then
		   local framescale = frame.GetScale and frame:GetScale() or 1;
			ret = (frame:GetLeft()* framescale + frame:GetRight()
				* framescale - UIParent:GetLeft() - UIParent:GetRight()) / 2;
		end
	end

	return ret
end

--[[ Titan
NAME: TitanMovableFrame_CheckFrames
DESC: Determine the frames that may need to be moved at the given position.
VAR: position - TITAN_PANEL_PLACE_TOP / TITAN_PANEL_PLACE_BOTTOM / TITAN_PANEL_PLACE_BOTH
OUT: None
--]]
function TitanMovableFrame_CheckFrames(position)
	-- reset the frames to move
	TitanMovable = {};

	-- check top as requested
	if (position == TITAN_PANEL_PLACE_TOP) 
	or position == TITAN_PANEL_PLACE_BOTH then
		-- Move PlayerFrame		
		TitanMovableFrame_CheckThisFrame(PlayerFrame:GetName())
			
		-- Move TargetFrame		
		TitanMovableFrame_CheckThisFrame(TargetFrame:GetName())		

		-- Move PartyMemberFrame		
		TitanMovableFrame_CheckThisFrame(PartyMemberFrame1:GetName())

		-- Move TicketStatusFrame
		if TitanPanelGetVar("TicketAdjust") then
			TitanMovableFrame_CheckThisFrame(TicketStatusFrame:GetName())
		end
		
		-- Move MinimapCluster
		if not CleanMinimap then
			if not TitanPanelGetVar("MinimapAdjust") then
				TitanMovableFrame_CheckThisFrame(MinimapCluster:GetName())
			end
		end
		-- Move BuffFrame
		TitanMovableFrame_CheckThisFrame(BuffFrame:GetName())

		-- Move WorldStateAlwaysUpFrame				
		TitanMovableFrame_CheckThisFrame(WorldStateAlwaysUpFrame:GetName());
	end
	
	-- check bottom as requested
	if (position == TITAN_PANEL_PLACE_BOTTOM) 
	or position == TITAN_PANEL_PLACE_BOTH then
		
		-- Move MainMenuBar		
		TitanMovableFrame_CheckThisFrame(MainMenuBar:GetName());
	
		-- Move OverrideActionBar		
		TitanMovableFrame_CheckThisFrame(OverrideActionBar:GetName());
		
		-- Move BonusActionBarFrame		
--		TitanMovableFrame_CheckThisFrame(BonusActionBarFrame:GetName());
	end
end

--[[ Titan
NAME: TitanMovableFrame_MoveFrames
DESC: Actually adjust the frames at the given position.
VAR: position - TITAN_PANEL_PLACE_TOP / TITAN_PANEL_PLACE_BOTTOM / TITAN_PANEL_PLACE_BOTH
OUT: None
--]]
function TitanMovableFrame_MoveFrames(position)
	-- Once the frames to check have been collected, 
	-- move them as needed.
	local frameData, frame, frameName, frameArchor, xArchor, y, xOffset, yOffset, panelYOffset;

	-- Collect the frames we need to move
	TitanMovableFrame_CheckFrames(position);
	
	-- move them...
	if not InCombatLockdown() then
		local adj_frame = true
		for index, value in pairs(TitanMovable) do						
			adj_frame = true -- assume the frame is to be adjusted
			frameData = TitanMovableData[value];
			if frameData then
				frame = _G[frameData.frameName];
				frameName = frameData.frameName;
				frameArchor = frameData.frameArchor;
			end

			if (frame and (frame:IsUserPlaced())) 
			then
				-- The user has positioned the frame
				adj_frame = false
			end
			if frameData.addonAdj then
				-- An addon has taken control of the frame
				adj_frame = false
			end
			
			if adj_frame then
				xArchor = frameData.xArchor;
				y = frameData.y;
				
				panelYOffset = TitanMovable_GetPanelYOffset(frameData.position);
				xOffset = TitanMovableFrame_GetXOffset(frame, xArchor);
				
				-- properly adjust buff frame(s) if GM Ticket is visible

				-- Use IsShown rather than IsVisible. In some cases (after closing
				-- full screen map) the ticket may not yet be visible.
				if (frameName == "BuffFrame")
				and TicketStatusFrame:IsShown()
				and TitanPanelGetVar("TicketAdjust") then
					yOffset = (-TicketStatusFrame:GetHeight()) 
								+ panelYOffset
				else
					yOffset = y + panelYOffset;
				end

				-- properly adjust MinimapCluster if its border is hidden
				if frameName == "MinimapCluster" 
				and MinimapBorderTop 
				and not MinimapBorderTop:IsShown() then					
					yOffset = yOffset + (MinimapBorderTop:GetHeight() * 3/5) - 5
				end
				
				-- adjust the MainMenuBar according to its scale
				if  frameName == "MainMenuBar" and MainMenuBar:IsVisible() then
					local framescale = MainMenuBar:GetScale() or 1;
				    yOffset =  yOffset / framescale;
				end
				
				-- account for Reputation Status Bar (doh)
				local playerlevel = UnitLevel("player");
				if frameName == "MultiBarRight" 
				and ReputationWatchStatusBar:IsVisible() 
				and playerlevel < _G["MAX_PLAYER_LEVEL"] then
					yOffset = yOffset + 8;
				end

				frame:ClearAllPoints();		
				frame:SetPoint(frameArchor, "UIParent", frameArchor, 
					xOffset, yOffset);
			else
				--Leave frame where it is as it has been moved by a user
			end
			-- Move bags as needed
			UpdateContainerFrameAnchors();
		end
	else
		-- nothing to do
	end
end

--[[ Titan
NAME: TitanAdjustBottomFrames
DESC: Adjust the frames at TITAN_PANEL_PLACE_BOTTOM.
VAR:  None
OUT:  None
--]]
function TitanAdjustBottomFrames()
	TitanPanel_AdjustFrames(TITAN_PANEL_PLACE_BOTTOM, true)
end

--[[ Titan
NAME: Titan_FCF_UpdateDockPosition
DESC: Secure post hook to help adjust the chat / log frame.
VAR:  None
OUT:  None
NOTE:
- This is required because Blizz adjusts the chat frame relative to other frames so some of the Blizz code is copied.
- If in combat or if the user has moved the chat frame then no action is taken.
- The frame is adjusted in the Y axis only.
:NOTE
--]]
local function Titan_FCF_UpdateDockPosition()
	if not Titan__InitializedPEW
	or not TitanPanelGetVar("LogAdjust") 
	or TitanPanelGetVar("AuxScreenAdjust") then 
		return 
	end
	
	if not InCombatLockdown() or (InCombatLockdown() 
	and not _G["DEFAULT_CHAT_FRAME"]:IsProtected()) then
		local panelYOffset = TitanMovable_GetPanelYOffset(TITAN_PANEL_PLACE_BOTTOM);
		local scale = TitanPanelGetVar("Scale");
		if scale then
			panelYOffset = panelYOffset + (24 * scale) -- after 3.3.5 an additional adjust was needed. why? idk
		end

--[[ Blizz code
		if _G["DEFAULT_CHAT_FRAME"]:IsUserPlaced() then
			if _G["SIMPLE_CHAT"] ~= "1" then return end
		end
		
		local chatOffset = 85 + panelYOffset;
		if GetNumShapeshiftForms() > 0 or HasPetUI() or PetHasActionBar() then
			if MultiBarBottomLeft:IsVisible() then
				chatOffset = chatOffset + 55;
			else
				chatOffset = chatOffset + 15;
			end
		elseif MultiBarBottomLeft:IsVisible() then
			chatOffset = chatOffset + 15;
		end
		_G["DEFAULT_CHAT_FRAME"]:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 32, chatOffset);
		FCF_DockUpdate();
--]]
		if ( DEFAULT_CHAT_FRAME:IsUserPlaced() ) then
			return;
		end
		
		local chatOffset = 85 + panelYOffset; -- Titan change to adjust Y offset
		if ( GetNumShapeshiftForms() > 0 or HasPetUI() or PetHasActionBar() ) then
			if ( MultiBarBottomLeft:IsShown() ) then
				chatOffset = chatOffset + 55;
			else
				chatOffset = chatOffset + 15;
			end
		elseif ( MultiBarBottomLeft:IsShown() ) then
			chatOffset = chatOffset + 15;
		end
		DEFAULT_CHAT_FRAME:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 
			32, chatOffset);
		FCF_DockUpdate();
	end
end

--[[ Titan
NAME: Titan_ContainerFrames_Relocate
DESC: Secure post hook to help adjust the bag frames.
VAR:  None
OUT:  None
NOTE:
- The frame is adjusted in the Y axis only.
- The Blizz routine "ContainerFrames_Relocate" should be examined for any conditions it checks and any changes to the SetPoint.
If Blizz changes the anchor points the SetPoint here must change as well!!
The Blizz routine calculates X & Y offsets to UIParent (screen) so there is not need to store the prior offsets.
Like the Blizz routine we search through the visible bags. Unlike the Blizz routine we only care about the first of each column to adjust for Titan.
This way the Blizz code does not need to be copied here.
:NOTE
--]]
local function Titan_ContainerFrames_Relocate()
	if not TitanPanelGetVar("BagAdjust") then 
		return 
	end

	local panelYOffset = TitanMovable_GetPanelYOffset(TITAN_PANEL_PLACE_BOTTOM)
	local off_y = 10000 -- something ridiculously high
	local bottom_y = 0
	local right_x = 0

	for index, frameName in ipairs(ContainerFrame1.bags) do
		frame = _G[frameName];
		bottom_y = frame:GetBottom()
		if ( bottom_y < off_y ) then
			-- Start a new column
			right_x = frame:GetRight()
			frame:ClearAllPoints();		
			frame:SetPoint("BOTTOMRIGHT", frame:GetParent(), 
				"BOTTOMLEFT", -- changed because we are taking the current x value
				right_x, -- x is not adjusted
				bottom_y + panelYOffset -- y
			)
		end
		off_y = bottom_y
	end
end

--[[ Titan
NAME: TitanMovableFrame_AdjustBlizzardFrames
DESC: Calls the helper routines to adjust the chat / log frame and bag frames.
VAR:  None
OUT:  None
NOTE:
- This is required because Blizz (or addons) could adjust the chat frame outside the events that Titan registers for.
- If in combat or if the user has moved the chat frame then no action is taken.
- The frame is adjusted in the Y axis only.
:NOTE
--]]
local function TitanMovableFrame_AdjustBlizzardFrames()
	if not InCombatLockdown() then
		Titan_FCF_UpdateDockPosition();
		Titan_ContainerFrames_Relocate();
	end
end

--[[ Titan
NAME: Titan_AdjustUIScale
DESC: Adjust the scale of Titan bars and plugins to the user selected scaling. This is called by the secure post hooks to the 'Video Options Frame'.
VAR:  None
OUT:  None
--]]
local function Titan_AdjustUIScale()	
	Titan_AdjustScale()
end

--[[ Titan
NAME: Titan_Hook_Adjust_Both
DESC: Adjust top and bottom frames. This is called by the secure post hooks.
VAR:  None
OUT:  None
NOTE:
- Starts a timer () which is a callback to Titan_ManageFramesNew.
- These could arrive quickly. To prevent many adjusts from stacking, cancel any pending then queue this one.
:NOTE
--]]
local function Titan_Hook_Adjust_Both()
	TitanMovable_AdjustTimer("Adjust") 
end

--[[ Titan
NAME: TitanPanel_AdjustFrames
DESC: Adjust the frames at the given position.
VAR: position - TITAN_PANEL_PLACE_TOP / TITAN_PANEL_PLACE_BOTTOM / TITAN_PANEL_PLACE_BOTH
VAR: blizz - true or false
OUT:  None
NOTE:
- if blizz is true then the post hook code for chat / log frame and the bag frames is run
:NOTE
--]]
function TitanPanel_AdjustFrames(position, blizz)
	-- Adjust frame positions top only, bottom only, or both
	TitanMovableFrame_MoveFrames(position)

	-- move the Blizzard frames if requested
	if blizz and position == (TITAN_PANEL_PLACE_BOTTOM or TITAN_PANEL_PLACE_TOP) then
		TitanMovableFrame_AdjustBlizzardFrames()
	end
end

--[[ Titan
NAME: Titan_ManageFramesNew
DESC: Adjust the frames at TITAN_PANEL_PLACE_BOTH.
VAR:  None
OUT:  None
--]]
function Titan_ManageFramesNew()
	TitanPanel_AdjustFrames(TITAN_PANEL_PLACE_BOTH, false)
	return
end

--[[ Titan
NAME: Titan_AdjustScale
DESC: Update the bars and plugins to the user selected scale.
VAR:  None
OUT:  None
NOTE:
- Ensure Titan has done its initialization before this is run.
:NOTE
--]]
function Titan_AdjustScale()
	-- Only adjust if Titan is fully initialized
	if Titan__InitializedPEW then 
		TitanPanel_SetScale();
		
		TitanPanel_ClearAllBarTextures()
		TitanPanel_CreateBarTextures()

		for idx,v in pairs (TitanBarData) do
			TitanPanel_SetTexture(TITAN_PANEL_DISPLAY_PREFIX..TitanBarData[idx].name
				, TITAN_PANEL_PLACE_TOP);
		end

		TitanPanelBarButton_DisplayBarsWanted()
		TitanPanel_RefreshPanelButtons();
	end
end

function Titan_ManageFramesTest1()
	if Titan__InitializedPEW then
		-- We know the desired bars are now drawn so we can adjust
		if InCombatLockdown() then
		else
--TitanDebug ("Titan_ManageFramesTest1 ")
	left = floor(OverrideActionBar:GetLeft() + 0.5)
	left = GetScreenWidth() / 2
	bot = floor(OverrideActionBar:GetBottom() + 0.5)
TitanDebug("... OverrideActionBar "
..(bot or "?").." "
..(left or "?").." "
)
	point, relFrame, relPoint, xOff, yOff = OverrideActionBar:GetPoint(OverrideActionBar:GetNumPoints())
	OverrideActionBar:ClearAllPoints()
	OverrideActionBar:SetPoint("BOTTOM", TitanPanelBottomAnchor, "TOP", left, 0)
	OverrideActionBar:SetPoint(point, relFrame, relPoint, xOff, TitanPanelBottomAnchor:GetTop()+0)
	left, _ = OverrideActionBar:GetCenter()
	bot = OverrideActionBar:GetBottom()
TitanDebug("... OverrideActionBar "
..(bot or "?").." "
..(left or "?").." "
)

		end
	end
-- There is a chance the person stays in combat so this could
-- keep looping...
end

function Titan_GetFrameOrigPositions()
	local orig = {}
	local frameData
	local point, relTo, relPoint, xOff, yOff = "", {}, "", 0, 0
	local relFrame = ""
	for index, value in pairs(TitanMovableData) do						
		frameData = TitanMovableData[index];
		if frameData then
			point, relTo, relPoint, xOff, yOff = "", {}, "", 0, 0
			frame = _G[frameData.frameName];
			point, relTo, relPoint, xOff, yOff = frame:GetPoint(frame:GetNumPoints())
TitanDebug("Orig: "
..frameData.frameName.." "
..relTo:GetName() or "?".." "
)
			orig = {
				point = point, 
				relTo = relTo, 
				relPoint = relPoint, 
				xOff = xOff, 
				yOff = yOff,
			}
			TitanMovableOrig[frameData.frameName] = orig
		end
	end
end

function Titan_SetFrameOrigPositions()
	local left = 0
	local bot = 0
	-- TESTING!!!
TitanDebug("TESTING!!: Setting frames to Titan anchor "
..(TitanPanelBottomAnchor:GetTop() or "?").." "
)
	left = MainMenuBar:GetLeft()
	left = GetScreenWidth() / 2
	bot = MainMenuBar:GetBottom()
TitanDebug("... MainMenuBar "
..(bot or "?").." "
..(left or "?").." "
)
--	local point, relFrame, relPoint, xOff, yOff = MainMenuBar:GetPoint(MainMenuBar:GetNumPoints())
	MainMenuBar:ClearAllPoints()
	MainMenuBar:SetPoint("BOTTOM", TitanPanelBottomAnchor, "TOP", left, 0)
--	MainMenuBar:SetPoint(point, relFrame, relPoint, xOff, TitanPanelBottomAnchor:GetTop()+0)
	left = MainMenuBar:GetLeft()
	bot = MainMenuBar:GetBottom()
TitanDebug("... MainMenuBar "
..(bot or "?").." "
..(left or "?").." "
)
	
	left = floor(OverrideActionBar:GetLeft() + 0.5)
	left = GetScreenWidth() / 2
	bot = floor(OverrideActionBar:GetBottom() + 0.5)
TitanDebug("... OverrideActionBar "
..(bot or "?").." "
..(left or "?").." "
)
--	point, relFrame, relPoint, xOff, yOff = OverrideActionBar:GetPoint(OverrideActionBar:GetNumPoints())
	OverrideActionBar:ClearAllPoints()
	OverrideActionBar:SetPoint("BOTTOM", TitanPanelBottomAnchor, "TOP", left, 0)
--	OverrideActionBar:SetPoint(point, relFrame, relPoint, xOff, TitanPanelBottomAnchor:GetTop()+0)
	left, _ = OverrideActionBar:GetCenter()
	bot = OverrideActionBar:GetBottom()
TitanDebug("... OverrideActionBar "
..(bot or "?").." "
..(left or "?").." "
)

if false then
	left = MultiBarRight:GetLeft()
	MultiBarRight:ClearAllPoints()
	MultiBarRight:SetPoint("BOTTOMLEFT", TitanPanelBottomAnchor, "TOP", left, 98)

	left = TargetFrame:GetLeft()
	TargetFrame:ClearAllPoints()
	TargetFrame:SetPoint("TOPLEFT", TitanPanelTopAnchor, "BOTTOM", left, -4)
	
	left = PlayerFrame:GetLeft()
	PlayerFrame:ClearAllPoints()
	PlayerFrame:SetPoint("TOPLEFT", TitanPanelTopAnchor, "BOTTOM", left, -4)
	
	left = PartyMemberFrame1:GetLeft()
	PartyMemberFrame1:ClearAllPoints()
	PartyMemberFrame1:SetPoint("TOPLEFT", TitanPanelTopAnchor, "BOTTOM", left, -128)
	
	left = TicketStatusFrame:GetLeft()
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOPLEFT", TitanPanelTopAnchor, "BOTTOM", left, 0)
	
	left = BuffFrame:GetLeft()
	BuffFrame:ClearAllPoints()
	BuffFrame:SetPoint("TOPLEFT", TitanPanelTopAnchor, "BOTTOM", left, -13)
	
	left = MinimapCluster:GetLeft()
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("TOPLEFT", TitanPanelTopAnchor, "BOTTOM", left, 0)
end
end

--[[ Titan
NAME: TitanMovable_SecureFrames
DESC: Once Titan is initialized create the post hooks we need to help adjust frames properly.
VAR:  None
OUT:  None
NOTE:
- The secure post hooks are required because Blizz adjusts frames Titan is interested in at times other than the events Titan registers for.
- This used to be inline code but was moved to a routine to avoid errors as Titan loaded.
:NOTE
--]]
function TitanMovable_SecureFrames()
	if not TitanPanelAce:IsHooked("FCF_UpdateDockPosition", Titan_FCF_UpdateDockPosition) then
		TitanPanelAce:SecureHook("FCF_UpdateDockPosition", Titan_FCF_UpdateDockPosition) -- FloatingChatFrame
	end
	if not TitanPanelAce:IsHooked("UIParent_ManageFramePositions", Titan_Hook_Adjust_Both) then
		TitanPanelAce:SecureHook("UIParent_ManageFramePositions", Titan_Hook_Adjust_Both) -- UIParent.lua
		TitanPanel_AdjustFrames(TITAN_PANEL_PLACE_BOTTOM, false)
	end

	if not TitanPanelAce:IsHooked(TicketStatusFrame, "Show", Titan_Hook_Adjust_Both) then
		-- Titan Hooks to Blizzard Frame positioning functions
		--TitanPanelAce:SecureHook("TicketStatusFrame_OnShow", Titan_Hook_Adjust_Both) -- HelpFrame.xml
		--TitanPanelAce:SecureHook("TicketStatusFrame_OnHide", Titan_Hook_Adjust_Both) -- HelpFrame.xml
		TitanPanelAce:SecureHook(TicketStatusFrame, "Show", Titan_Hook_Adjust_Both) -- HelpFrame.xml
		TitanPanelAce:SecureHook(TicketStatusFrame, "Hide", Titan_Hook_Adjust_Both) -- HelpFrame.xml
		TitanPanelAce:SecureHook(MainMenuBar, "Show", Titan_Hook_Adjust_Both) -- HelpFrame.xml
		TitanPanelAce:SecureHook(MainMenuBar, "Hide", Titan_Hook_Adjust_Both) -- HelpFrame.xml
		TitanPanelAce:SecureHook(OverrideActionBar, "Show", Titan_Hook_Adjust_Both) -- HelpFrame.xml
		TitanPanelAce:SecureHook(OverrideActionBar, "Hide", Titan_Hook_Adjust_Both) -- HelpFrame.xml
--		TitanPanelAce:SecureHook(OverrideActionBar, "Show", Titan_ManageFramesTest1) -- HelpFrame.xml
--		TitanPanelAce:SecureHook(OverrideActionBar, "Hide", Titan_ManageFramesTest1) -- HelpFrame.xml
		TitanPanelAce:SecureHook("UpdateContainerFrameAnchors", Titan_ContainerFrames_Relocate) -- ContainerFrame.lua
		TitanPanelAce:SecureHook(WorldMapFrame, "Hide", Titan_Hook_Adjust_Both) -- WorldMapFrame.lua
		TitanPanelAce:SecureHook("BuffFrame_Update", Titan_Hook_Adjust_Both) -- BuffFrame.lua
	end
		
	if not TitanPanelAce:IsHooked("VideoOptionsFrameOkay_OnClick", Titan_AdjustUIScale) then
		-- Properly Adjust UI Scale if set
		-- Note: These are the least intrusive hooks we could think of, to properly adjust the Titan Bar(s)
		-- without having to resort to a SetCvar secure hook. Any addon using SetCvar should make sure to use the 3rd
		-- argument in the API call and trigger the CVAR_UPDATE event with an appropriate argument so that other addons
		-- can detect this behavior and fire their own functions (where applicable).
		TitanPanelAce:SecureHook("VideoOptionsFrameOkay_OnClick", Titan_AdjustUIScale) -- VideoOptionsFrame.lua
		TitanPanelAce:SecureHook(VideoOptionsFrame, "Hide", Titan_AdjustUIScale) -- VideoOptionsFrame.xml
	end
	
--	TitanPanelAce:SecureHook(OverrideActionBar, "SetPoint", Titan_ManageFramesTest1) -- 
end
