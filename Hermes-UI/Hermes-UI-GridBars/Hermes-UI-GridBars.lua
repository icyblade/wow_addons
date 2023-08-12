--[[

]]--
local VIEW_NAME = "GridBars"

local Hermes = LibStub("AceAddon-3.0"):GetAddon("Hermes")
local UI = LibStub("AceAddon-3.0"):GetAddon("Hermes-UI")
local LIB_LibSharedMedia = LibStub("LibSharedMedia-3.0") or error("Required library LibSharedMedia-3.0 not found")
local ViewManager = UI:GetModule("ViewManager")
local LIBBars = LibStub("LibHermesUICooldownBars-1.0") or error("Required library LibHermesUICooldownBars-1.0 not found")
local L = LibStub('AceLocale-3.0'):GetLocale('Hermes-UI')
local mod = ViewManager:NewModule(VIEW_NAME)

-----------------------------------------------------------------------
-- LOCALS
-----------------------------------------------------------------------
local FRAMEPOOL = nil
local CELLPOOL = nil
local FRAME_MINWIDTH = 36
local FRAME_MINHEIGHT = 36
local RESIZER_SIZE = 20
local UNIQUE_CELL_COUNT = 0
local UNIQUE_FRAME_COUNT = 0
local IMAGE_RESIZE = "Interface\\Addons\\Hermes-UI\\Resize.tga"
local BAR_SPARK_WIDTH = 25
local BAR_SPARK_HEIGHT = 10
local STATUS_PADDING = 2
local ICON_OFFSET = 1
local TOOLTIP_HOVER_THROTTLE = 0.1
local ICON_STATUS_NOTREADY = "Interface\\RAIDFRAME\\ReadyCheck-NotReady.blp"
local ICON_STATUS_READY = "Interface\\RAIDFRAME\\ReadyCheck-Ready.blp"
local NEW_INSTANCE_THRESHOLD = 1 --catch when an instance going on cooldown should animate using 2ndcooldown metadata or not

--ToolTip
local QTip	= LibStub("LibQTip-1.0")
local ToolTip = nil
local SpellIdFont = nil
-----------------------------------------------------------------------
-- HELPERS
-----------------------------------------------------------------------
local function _deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

local function _findTableIndex(tbl, item)
	for index, i in ipairs(tbl) do
		if(i == item) then
			return index
		end
	end

	return nil
end

local function _deleteFromIndexedTable(tbl, item)
	local index = _findTableIndex(tbl, item) 
	if not index then error("failed to locate item in table") end
	tremove(tbl, index)
end

local function _rotateTexture(self, angle)
	local function GetCorner(angle)
		local Root2 = 2 ^ 0.5;
		return 0.5 + cos( angle ) / Root2, 0.5 + sin( angle ) / Root2;
	end

	local LRx, LRy = GetCorner( angle + 45 );
	local LLx, LLy = GetCorner( angle + 135 );
	local ULx, ULy = GetCorner( angle - 135 );
	local URx, URy = GetCorner( angle - 45 );
	self:SetTexCoord( ULx, ULy, LLx, LLy, URx, URy, LRx, LRy );
end

local function _secondsToClock(sSeconds)
	local nSeconds = tonumber(sSeconds)
	if not nSeconds then
		return nil
	end
	if nSeconds < 60 then
		--seconds
		return nil, nil, floor(nSeconds)
	else
		if(nSeconds > 3600) then
			--hours
			local nHours = floor(nSeconds / 3600)
			local nMins = floor(nSeconds / 60 - (nHours * 60))
			local nSecs = floor(nSeconds - nHours * 3600 - nMins * 60)
			--return ("%02.f:%02.f:%02.f"):format(nHours, nMins, nSecs)
			return nHours, nMins, nSecs
		else
			--minutes
			local nMins = floor(nSeconds / 60)
			local nSecs = floor(nSeconds - nMins * 60)
			--return ("%02.f:%02.f"):format(nMins, nSecs)
			return nil, nMins, nSecs
		end
	end
	
	--catch all to avoid any accidental nil errors
	return nil, nil, 0
end

local function _round(num, idp)
	local mult = 10^(idp or 0)
	return floor(num * mult + 0.5) / mult
end

local function _isBarNew(bar)
	--the purpose of this function is to detect when a Hermes instance was likely
	--created just after a sender registered itself, or an ability was added,
	--such as what happens when you reload your UI and existing instances are
	--loaded. if it returns true, then in the case of this addon, we don't want
	--to fire any second animations in the LBBars. Other ways this can happen
	--is when a view is disabled/enabled, etc.

	if (GetTime() - bar.created <= NEW_INSTANCE_THRESHOLD) then
		return 1
	end
end
-----------------------------------------------------------------------
-- FRAME POOL
-----------------------------------------------------------------------
function mod:CreateFramePool()
	FRAMEPOOL = CreateFrame("Frame", nil, UIParent)
	FRAMEPOOL:SetPoint("CENTER")
	FRAMEPOOL:SetWidth(50)
	FRAMEPOOL:SetHeight(50)
	FRAMEPOOL:Hide()
	FRAMEPOOL:EnableMouse(false)
	FRAMEPOOL:SetMovable(false)
	FRAMEPOOL:SetToplevel(false)
	FRAMEPOOL.Frames = {}
end

-----------------------------------------------------------------------
-- CELL POOL
-----------------------------------------------------------------------
function mod:CreateCellPool()
	CELLPOOL = CreateFrame("Frame", nil, UIParent)
	CELLPOOL:SetPoint("CENTER")
	CELLPOOL:SetWidth(FRAME_MINWIDTH)
	CELLPOOL:SetHeight(FRAME_MINHEIGHT)
	CELLPOOL:Hide()

	CELLPOOL:EnableMouse(false)
	CELLPOOL:SetMovable(false)
	CELLPOOL:SetToplevel(false)
	CELLPOOL.Cells = {}
end

-----------------------------------------------------------------------
-- FRAME
-----------------------------------------------------------------------
local function OnFrameUpdate(frame, elapsed)
	frame.timer = frame.timer + elapsed
	if frame.timer >= TOOLTIP_HOVER_THROTTLE then
		if frame:IsMouseOver() then --don't bother if we're dragging
			if frame.profile.merged == false then
				--see if it's over any cells
				for _, cell in ipairs(frame.cells) do
					if cell.hide ~= true and cell:IsMouseOver() then
						--release the tooltip as the cell changed
						if ToolTip and ToolTip.cell ~= cell then
							QTip:Release(ToolTip)
							ToolTip = nil
						end
						--don't show the tooltip if we're dragging or it's already being shown for the same cell
						if not ToolTip then
							mod:ShowTooltip(cell, cell)
						end
						frame.timer = 0
						return --break here to ensure we don't later release the tooltip
					end
				end
			else
				--see if it's over the merged cell
				if frame.mergedcell:IsMouseOver() then
					--release the tooltip as the cell changed
					if ToolTip and ToolTip.cell ~= frame.mergedcell then
						QTip:Release(ToolTip)
						ToolTip = nil
					end
					--don't show the tooltip if we're dragging or it's already being shown for the same cell
					if not ToolTip then
						mod:ShowTooltip(frame.mergedcell, frame.mergedcell)
					end
					frame.timer = 0
					return --break here to ensure we don't later release the tooltip
				end
			end
			
			--if we've made it here, then we're not hovering over any cells in the frame, so release the toolti if it exists
			if ToolTip then
				QTip:Release(ToolTip)
				ToolTip = nil
			end
		else
			--we're not over this frame, let's see if the tooltip needs to be released or not.
			--it's possible it's being shown for a cell in a different frame, so only release if the frame matches this one.
			if ToolTip and ToolTip.cell.frame == frame then
				QTip:Release(ToolTip)
				ToolTip = nil
			end
		end
		
		--reset the timer if not already reset
		frame.timer = 0
	end
end

function mod:RestoreFramePosition(frame)				--sets the starting point for all window positions based on profile settings (if it exists)
	if(not frame.profile.x or not frame.profile.y) then
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "CENTER")
		frame:SetWidth(FRAME_MINWIDTH)
		frame:SetHeight(FRAME_MINHEIGHT)
		frame.profile.x = frame:GetLeft()
		frame.profile.y = frame:GetTop()
		frame.profile.w = FRAME_MINWIDTH
		frame.profile.h = FRAME_MINHEIGHT
	else
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT",
			frame.profile.x,
			frame.profile.y
		)
		frame:SetWidth(frame.profile.w)
		frame:SetHeight(frame.profile.h)
	end

	frame:SetUserPlaced(nil)
end

function mod:UpdateFrameResizerPosition(frame)
	local anchor

	if frame.profile.cellAnchor == "TOPLEFT" then --good
		anchor = "BOTTOMRIGHT"
		_rotateTexture(frame.resizer.texture, 0)
		
	elseif frame.profile.cellAnchor == "TOPRIGHT" then --good
		anchor = "BOTTOMLEFT"
		_rotateTexture(frame.resizer.texture, -90)
		
	elseif frame.profile.cellAnchor == "BOTTOMLEFT" then --good
		anchor = "TOPRIGHT"
		_rotateTexture(frame.resizer.texture, 90)
		
	elseif frame.profile.cellAnchor == "BOTTOMRIGHT" then
		anchor = "TOPLEFT"
		_rotateTexture(frame.resizer.texture, 180)
		
	else
		anchor = "BOTTOMRIGHT"
		_rotateTexture(frame.resizer.texture, 0)
		
	end
	
	frame.resizer:ClearAllPoints()
	frame.resizer:SetPoint(anchor)
	frame.resizer:SetScript("OnMouseDown", function() frame.resizer:StopMovingOrSizing() frame:StopMovingOrSizing() frame:StartSizing(anchor) end)
end

function mod:RecycleFrame(frame)
	frame:SetScript("OnUpdate", nil)
	frame.timer = 0
	
	while #frame.cells > 0 do
		self:RecycleCell(frame, frame.cells[1])
	end
	
	wipe(frame.cells)

	frame.mergedcell:Hide()
	frame.mergedcell:ClearAllPoints()
	--Clear all the bars too
	while #frame.mergedcell.bars > 0 do
		self:ReleaseBar(frame.mergedcell.bars[1])
		tremove(frame.mergedcell.bars, 1)
	end
	
	self:RecycleCell(frame, frame.mergedcell, 1)
	frame.mergedcell = nil
	
	tinsert(FRAMEPOOL.Frames, frame)
	frame:Hide()
	frame:SetParent(FRAMEPOOL)
	frame:ClearAllPoints()
	frame.VirtualWidth = FRAME_MINWIDTH
	frame.VirtualHeight = FRAME_MINHEIGHT
end

function mod:EnableTooltip(frame)
	if frame.profile.enableTooltip == true then
		--enable tooltip scanning
		frame:SetScript("OnUpdate", OnFrameUpdate)
	else
		--disable tooltip scanning
		frame:SetScript("OnUpdate", nil)
	end
end

function mod:InitializeFrame(frame, profile)
	frame.timer = 0
	frame.profile = profile
	frame:SetParent(UIParent)
	frame:SetScale(profile.scale)
	frame:SetMinResize(FRAME_MINWIDTH, FRAME_MINHEIGHT)
end

function mod:FetchFrame(profile)
	local frame
	if(#FRAMEPOOL.Frames > 0) then
		frame = FRAMEPOOL.Frames[1]
		_deleteFromIndexedTable(FRAMEPOOL.Frames, frame)
	else
		frame = self:CreateFrame()
	end
	
	self:InitializeFrame(frame, profile)
	
	return frame
end

local function OnFrameDragStart(frame, button)
	if(frame.profile.locked == false) then
		frame:StartMoving()
	end
end

local function OnFrameDragStop(frame, button)
	frame:StopMovingOrSizing()
	frame.resizer:StopMovingOrSizing()
	mod:SaveFramePosition(frame)
end

local function OnFrameSizeChanged(frame, width, height)
	mod:PositionCells(frame)
end

function mod:SaveFramePosition(frame)
	frame.profile.x = frame:GetLeft()
	frame.profile.y = frame:GetTop()
	frame.profile.w = frame:GetWidth()
	frame.profile.h = frame:GetHeight()
	frame:SetUserPlaced(false)
end

function mod:CreateFrame()
	UNIQUE_FRAME_COUNT = UNIQUE_FRAME_COUNT + 1
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide() --hide frame by default
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:SetUserPlaced(false)
	frame:SetToplevel(false)
	frame:SetWidth(FRAME_MINWIDTH)
	frame:SetHeight(FRAME_MINHEIGHT)
	frame:RegisterForDrag("LeftButton");
	frame:SetScript("OnDragStart", OnFrameDragStart)
	frame:SetScript("OnDragStop", OnFrameDragStop)
	frame:SetScript("OnSizeChanged", OnFrameSizeChanged)
	frame:SetScript("OnHide", function() frame:StopMovingOrSizing() end) -- prevents stuck dragging
	
	frame:SetBackdrop({
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
			tile = false,
			tileSize = 32,
			edgeSize = 10,
			insets = {
				left = -1,
				right = -1,
				top = -1,
				bottom = -1
			}
		})

	frame.resizer = CreateFrame("Frame", nil, frame)
	frame.resizer:SetWidth(RESIZER_SIZE)
	frame.resizer:SetHeight(RESIZER_SIZE)
	frame.resizer:EnableMouse(true)
	frame.resizer:RegisterForDrag("LeftButton")
	frame.resizer:SetPoint("BOTTOMRIGHT")
	frame.resizer:SetScript("OnMouseDown", function() frame.resizer:StopMovingOrSizing() frame:StopMovingOrSizing() frame:StartSizing() end)
	frame.resizer:SetScript("OnMouseUp", function() frame.resizer:StopMovingOrSizing() frame:StopMovingOrSizing() mod:SetFrameToVirtualSize(frame) end)
	frame.resizer.texture = frame.resizer:CreateTexture()
	frame.resizer.texture:SetTexture(IMAGE_RESIZE)
	frame.resizer.texture:SetDrawLayer("OVERLAY")
	frame.resizer.texture:SetAllPoints()
	
	frame.cells = {}
	frame.mergedcell = nil
	
	return frame
end

function mod:SetFrameToVirtualSize(frame)
	local left = frame:GetLeft()
	local top = frame:GetTop()
	local right = frame:GetRight()
	local bottom = frame:GetBottom()
	
	frame:ClearAllPoints()
	if frame.profile.cellAnchor == "TOPLEFT" then
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
		frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", left + frame.VirtualWidth, top - frame.VirtualHeight)

	elseif frame.profile.cellAnchor == "TOPRIGHT" then
		frame:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", right, top)
		frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", right - frame.VirtualWidth, top - frame.VirtualHeight)
		
	elseif frame.profile.cellAnchor == "BOTTOMLEFT" then
		frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bottom)
		frame:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", left + frame.VirtualWidth, bottom + frame.VirtualHeight)

	elseif frame.profile.cellAnchor == "BOTTOMRIGHT" then
		frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", right, bottom)
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", right - frame.VirtualWidth, bottom + frame.VirtualHeight)
	end

	frame:SetHeight(frame.VirtualHeight) --this is VERY important. You'd think it would be obsolete but without it the position saving detects the wrong width and height. No doubt a consequence on me trying to keep the window from moving 
	frame:SetWidth(frame.VirtualWidth) --this is VERY important. You'd think it would be obsolete but without it the position saving detects the wrong width and height. No doubt a consequence on me trying to keep the window from moving 


	mod:SaveFramePosition(frame)
end

function mod:UpdateFrameVirtualSize(frame, numRows, numColumns, cellw, cellh)
	local width, height
	
	width = cellw * numColumns
	height = cellh * numRows
	
	width = width + (RESIZER_SIZE / 3)
	height = height + (RESIZER_SIZE / 3)
	
	if(frame:GetWidth() > width) then
		width = frame:GetWidth()
	end
	if(frame:GetHeight() > height) then
		height = frame:GetHeight()
	end
	
	if(width <= (FRAME_MINWIDTH + RESIZER_SIZE / 3)) then
		width = FRAME_MINWIDTH + (RESIZER_SIZE / 3) --always make sure the resizer is clickable
	end
	
	if(height <= (FRAME_MINHEIGHT + RESIZER_SIZE / 3)) then
		height = FRAME_MINHEIGHT + (RESIZER_SIZE / 3) --always make sure the resizer is clickable
	end

	frame.VirtualWidth = width
	frame.VirtualHeight = height
end

function mod:GetCellSize(frame)
	local v_width, v_height, a_width, a_height
	local profile = frame.profile
	local num_bars = profile.cellMax
	
	if profile.cellDir == false then
		--vertical tictacs
		v_width = profile.barW + profile.padding + (profile.barPadding * 2)
		a_width = profile.barW + (profile.barPadding * 2)
		
		v_height = ((profile.barH + profile.barGap) * num_bars) + profile.padding + (profile.barPadding * 2)
		a_height = ((profile.barH + profile.barGap) * num_bars) + (profile.barPadding * 2)
		
		--reduce height by one gap amount so that we don't have extra gap after the last tictac
		v_height = v_height - profile.barGap
		a_height = a_height - profile.barGap

		if profile.npUseNameplate == true then 
			--add the height of the nameplate + the size of the BARFRAME_INSET_SIZE
			v_height = v_height + profile.npH + profile.barPadding
			a_height = a_height + profile.npH + profile.barPadding
		end
		
	else
		--horizontal tictacs
		v_width = ((profile.barW + profile.barGap) * num_bars) + profile.padding + (profile.barPadding * 2)
		a_width = ((profile.barW + profile.barGap) * num_bars) + (profile.barPadding * 2)
		
		v_height = profile.barH + profile.padding + (profile.barPadding * 2)
		a_height = profile.barH + (profile.barPadding * 2)
		
		--reduce width by one gap amount so that we don't have extra gap after the last tictac
		v_width = v_width - profile.barGap
		a_width = a_width - profile.barGap

		if profile.npUseNameplate == true then 
			--add the width of the nameplate + the size of the BARFRAME_INSET_SIZE
			v_width = v_width + profile.npW + profile.barPadding
			a_width = a_width + profile.npW + profile.barPadding
		end
	end

	return v_width, v_height, a_width, a_height
end

function mod:GetCellAnchor(frame)
	local cellanchor = frame.profile.cellAnchor
	local anchor, multY, multX
	if cellanchor == "TOPLEFT" then
		anchor = "TOPLEFT"
		multY = -1
		multX = 1
	elseif cellanchor == "TOPRIGHT" then
		anchor = "TOPRIGHT"
		multY = -1
		multX = -1
	elseif cellanchor == "BOTTOMLEFT" then
		anchor = "BOTTOMLEFT"
		multY = 1
		multX = 1
	elseif cellanchor == "BOTTOMRIGHT" then
		anchor = "BOTTOMRIGHT"
		multY = 1
		multX = -1
	else
		anchor = "TOPLEFT"
		multY = -1
		multX = 1
	end

	return anchor, multY, multX
end

function mod:GetCellCoordinates(frame, column, row)
	local anchor, multY, multX = self:GetCellAnchor(frame)
	local v_width, v_height, a_width, a_height = self:GetCellSize(frame)
	local x, y

	local cellcenterX = ((column - 1) * v_width) + (v_width / 2)
	local cellcenterY = ((row - 1) * v_height) + (v_height / 2)

	x = ( cellcenterX - (v_width / 2)) * multX
	y = ( cellcenterY - (v_height / 2)) * multY

	return anchor, x, y
end

function mod:PositionCells(frame)
	local v_width, v_height, a_width, a_height = self:GetCellSize(frame)

	local columnsPerRow = floor(frame:GetWidth() / v_width)

	if(columnsPerRow <= 0) then
		columnsPerRow = 1
	end
	
	--these values are used for determining virtual layout size
	local maxRows = 1 --always make sure there is at least 1, even if there isn't
	local maxColumns = 1 --always make sure there is at least 1, even if there isn't
	
	local row = 1
	local column = 1
	
	local profile = frame.profile
	
	--this hides or shows cells as needed, and positions them
	for i, cell in ipairs(frame.cells) do
		if profile.merged == false and cell.hide ~= true then
			local anchor, x, y = self:GetCellCoordinates(frame, column, row)
			self:PositionCell(frame, cell, anchor, x, y, a_width, a_height)
			--increment columns/row counts
			if(i < #frame.cells) then
				column = column + 1
				if(column == columnsPerRow + 1) then
					row = row + 1
					column = 1
				end
			end
			cell:Show()
		else
			cell:ClearAllPoints()
			cell:Hide()
		end

		if row > maxRows then maxRows = row end
		if column > maxColumns then maxColumns = column end
	end
	
	--show/hide and position mergedcell
	if profile.merged == true then
		local anchor, x, y = self:GetCellCoordinates(frame, 1, 1)
		self:PositionCell(frame, frame.mergedcell, anchor, x, y, a_width, a_height)
		frame.mergedcell:Show()
	else
		frame.mergedcell:ClearAllPoints()
		frame.mergedcell:Hide()
	end
	
	self:UpdateFrameVirtualSize(frame, maxRows, maxColumns, v_width, v_height)
end

function mod:PositionCell(frame, cell, anchor, x, y, width, height)
	cell:ClearAllPoints()
	cell:SetPoint(anchor, frame, anchor, x, y)
	cell:SetHeight(height)
	cell:SetWidth(width)
end

function mod:GetFramePosRelativeToAnchor(frame)
	local profile = frame.profile
	if(profile.cellAnchor == "TOPLEFT") then
		return frame:GetLeft(), frame:GetTop()
	elseif(profile.cellAnchor == "TOPRIGHT") then
		return frame:GetRight(), frame:GetTop()
	elseif(profile.cellAnchor == "BOTTOMLEFT") then
		return frame:GetLeft(), frame:GetBottom()
	elseif(profile.cellAnchor == "BOTTOMRIGHT") then
		return frame:GetRight(), frame:GetBottom()
	end
end

function mod:SetFramePosRelativeToAnchor(frame, x, y)
	--this is a matter of setting the window topleft corner relative to the anchor
	local profile = frame.profile
	if(profile.cellAnchor == "TOPLEFT") then
		--just set x and y
		profile.x = x
		profile.y = y
	elseif(profile.cellAnchor == "TOPRIGHT") then
		local deltaX = frame:GetRight() - x
		local deltaY = frame:GetTop() - y
		profile.x = profile.x - deltaX
		profile.y = profile.y - deltaY
	elseif(profile.cellAnchor == "BOTTOMLEFT") then
		local deltaX = frame:GetLeft() - x
		local deltaY = frame:GetBottom() - y
		profile.x = profile.x - deltaX
		profile.y = profile.y - deltaY
	elseif(profile.cellAnchor == "BOTTOMRIGHT") then
		local deltaX = frame:GetRight() - x
		local deltaY = frame:GetBottom() - y
		profile.x = profile.x - deltaX
		profile.y = profile.y - deltaY
	end
	
	self:RestoreFramePosition(frame) --nothing fancy required, it's already top left
	self:PositionCells(frame)
end

function mod:SetCellVisibilityForAllCells(frame)
	local changed = false
	
	for _, cell in ipairs(frame.cells) do
		changed = self:SetCellVisibility(cell) == true or changed
	end
	
	return changed
end

function mod:LockFrame(frame)
	local profile = frame.profile
	if(profile.locked == false) then
		frame:SetBackdropColor(
			0,
			0,
			0,
			0.3)
		frame:EnableMouse(true)
		frame.resizer:EnableMouse(true)
		frame.resizer:Show()
	else
		frame:SetBackdropColor(
			0,
			0,
			0,
			0)
		frame:EnableMouse(false) --allow to click through the frame with mouse
		frame.resizer:EnableMouse(false)
		frame.resizer:Hide()
	end
end

-----------------------------------------------------------------------
-- CELL
-----------------------------------------------------------------------
function mod:RecycleCell(frame, cell, ismerged)
	cell.backgroundTexture:SetTexture("")
	self:ReleaseBar(cell.nameplate)
	cell.nameplate = nil
	while #cell.bars > 0 do
		self:ReleaseBar(cell.bars[1])
		tremove(cell.bars, 1)
	end
	
	if not ismerged then
		_deleteFromIndexedTable(frame.cells, cell)
	end
	
	tinsert(CELLPOOL.Cells, cell)
	
	---------------------------------------------------------------
	-- CELL
	---------------------------------------------------------------
	cell.style = nil
	cell.hide = true
	cell:Hide()
	cell:ClearAllPoints()
	cell:SetParent(CELLPOOL)
	cell.ability = nil
	cell.frame = nil
end

function mod:InitializeCell(frame, cell, ability, ismerged)
	--merged cell isn't part of cell table
	if not ismerged then
		tinsert(frame.cells, cell)
	end

	--configure cell
	cell.frame = frame
	cell.ability = ability
	cell:SetParent(frame)
	cell:ClearAllPoints()
	
	cell.backgroundTexture:SetTexture(
		frame.profile.cellBGColor.r,
		frame.profile.cellBGColor.g,
		frame.profile.cellBGColor.b,
		frame.profile.cellBGColor.a)
								
	cell.nameplate = self:AcquireNameplateBar(cell, ability, ismerged)
	self:EnsureMinimumBarCount(cell)
	self:SortBars(cell)
	self:PositionSpellBars(cell)
end

function mod:FetchCell()
	local cell
	if(#CELLPOOL.Cells > 0) then
		cell = CELLPOOL.Cells[1]
		_deleteFromIndexedTable(CELLPOOL.Cells, cell)
	else
		cell = self:CreateCell()
	end
	
	return cell
end

function mod:CreateCell()
	UNIQUE_CELL_COUNT = UNIQUE_CELL_COUNT + 1
	
	---------------------------------------------------------------
	-- CELL
	---------------------------------------------------------------
	local cell = CreateFrame("Frame", nil, nil)
	cell:Hide()
	cell.hide = true
	cell:EnableMouse(false)
	cell:SetMovable(true)
	cell:SetResizable(false)
	cell:SetScript("OnHide", function() cell:StopMovingOrSizing() end) --this is a precautionary measure to HOPEFULLY avoid any frames stuck to cursor issues while dragging if the frame gets hidden while dragging it (due to combat events)
	cell:SetToplevel(true)
	cell:SetUserPlaced(nil)
	cell:RegisterForDrag("LeftButton");

	cell.backgroundTexture = cell:CreateTexture(nil, "BACKGROUND")
	cell.backgroundTexture:SetTexture("")
	cell.backgroundTexture:SetAllPoints(cell)
	
	cell.nameplate = nil
	cell.bars = {}
	
	return cell
end

function mod:SetCellVisibility(cell)
	local wasHidden = cell.hide

	local min_time, total, oncooldown, available, unavailable = ViewManager:GetAbilityStats(cell.frame.view, cell.ability)
	
	--figure out new style
	if total == 0 then
		cell.hide = cell.frame.profile.hideNoSender == true --always hide if no senders
	else
		cell.hide = false
	end
	
	if (wasHidden ~= cell.hide) then
		return true
	end
	
	return false
end

function mod:GetCellForAbility(frame, ability)
	for _, cell in ipairs(frame.cells) do
		if cell.ability == ability then
			return cell
		end
	end
	
	error("failed to locate cell for ability")
end

function mod:SortCells(frame)
	sort(frame.cells,
		function(a, b)
			local ia = _findTableIndex(frame.view.abilities, a.ability)
			local ib = _findTableIndex(frame.view.abilities, b.ability)
			return ia < ib
		end
	)
end

------------------------------------------------------------------
--BAR
------------------------------------------------------------------
function mod:AcquireSpellBar(cell)
	local bar = LIBBars:AcquireBar()
	tinsert(cell.bars, bar)
	bar.cell = cell
	bar:SetParent(cell)
	return bar
end

function mod:InitializeSpellBarInstance(bar, instance)
	bar.instance = instance
	bar.created = GetTime() --we need this to know when the bar was created relative to the instance in order to determine whether to fire a secondary animation for instances on cooldown
	local profile = bar.cell.frame.profile
	
	--set static values
	self:UpdateSpellBarFont(bar)

	local texture = LIB_LibSharedMedia:Fetch("statusbar", profile.barTexture)
	LIBBars:SetBackgroundTexture(bar, texture)
	LIBBars:SetForegroundTexture(bar, texture)

	LIBBars:SetOneShotTextureColor(
		bar,
		profile.osFGColor.r,
		profile.osFGColor.g,
		profile.osFGColor.b,
		profile.osFGColor.a)
	
	--instance could be nil, in the case of an empty bar
	if instance then
		LIBBars:SetIconTexture(bar, instance.ability.icon)
	else
		LIBBars:SetIconTexture(bar, "")
	end
	
	self:SetSpellBarStyle(bar)
	
	if bar.cell == bar.cell.frame.mergedcell then
		LIBBars:Draw(bar,
			profile.barW,
			profile.barH,
			profile.barIconMerged, --different if merged nameplate
			profile.barTextSide,
			profile.barTextRatio,
			profile.barCooldownDirection,
			profile.barCooldownStyle,
			profile.osCooldownDirection,
			profile.osCooldownStyle)
	else
		LIBBars:Draw(bar,
			profile.barW,
			profile.barH,
			profile.barIcon,  --different if merged nameplate
			profile.barTextSide,
			profile.barTextRatio,
			profile.barCooldownDirection,
			profile.barCooldownStyle,
			profile.osCooldownDirection,
			profile.osCooldownStyle)
	end
end

function mod:UpdateSpellBarFont(bar)
	local profile = bar.cell.frame.profile
	local font = LIB_LibSharedMedia:Fetch("font", profile.barFont)
	LIBBars:SetFont(bar, font, profile.barFontSize, profile.barOutlineFont, profile.barThickFont)
end

function mod:GetNameplateDisplaySize(frame)
	local profile = frame.profile
	--display size depends on layout
	if profile.cellDir == false then --vertical layout
		--width controlled by bars, height controlled by nameplate
		return profile.barW, profile.npH
	else --horizontal layout
		--width controlled by nameplate, height controlled by bars
		return profile.npW, profile.barH
	end
end

function mod:UpdateNameplateVisuals(bar, ismerged)
	local profile = bar.cell.frame.profile
	local font = LIB_LibSharedMedia:Fetch("font", profile.npFont)
	LIBBars:SetFont(bar, font, profile.npFontSize, profile.npOutlineFont, profile.npThickFont)
	
	local bgcolor = {}
	local txcolor = {}
	
	if profile.npCCBar == true and not ismerged then
		bgcolor = _deepcopy(Hermes:GetClassColorRGB(bar.ability.class))
		bgcolor.a = profile.npTexColor.a --use alpha of the specfied color
	else
		bgcolor.r = profile.npTexColor.r
		bgcolor.g = profile.npTexColor.g
		bgcolor.b = profile.npTexColor.b
		bgcolor.a = profile.npTexColor.a
	end
	
	local texture = LIB_LibSharedMedia:Fetch("statusbar", profile.npTexture)
	LIBBars:SetBackgroundTexture(bar, texture)
	LIBBars:SetForegroundTexture(bar, texture)
	
	LIBBars:SetBackgroundTextureColor(bar, bgcolor.r, bgcolor.g, bgcolor.b, bgcolor.a)
	LIBBars:SetForegroundTextureColor(bar, bgcolor.r, bgcolor.g, bgcolor.b, bgcolor.a)
	
	if profile.npCCFont == true and not ismerged then
		txcolor = _deepcopy(Hermes:GetClassColorRGB(bar.ability.class))
		txcolor.a = profile.npFontColor.a --use alpha of the specfied color
	else
		txcolor.r = profile.npFontColor.r
		txcolor.g = profile.npFontColor.g
		txcolor.b = profile.npFontColor.b
		txcolor.a = profile.npFontColor.a
	end
	
	LIBBars:SetFontColorText(bar, txcolor.r, txcolor.g, txcolor.b, txcolor.a)
	LIBBars:SetFontColorDuration(bar, txcolor.r, txcolor.g, txcolor.b, txcolor.a)
	
	--nameplate width and height values depends on display layout
	local npwidth, npheight = self:GetNameplateDisplaySize(bar.cell.frame)
	
	if not ismerged then
		if profile.npShowLabel == true then
			bar.text:SetText(bar.ability.name)
		else
			bar.text:SetText("")
		end
		LIBBars:SetIconTexture(bar, bar.ability.icon)
		LIBBars:Draw(bar,
			npwidth,
			npheight,
			profile.npIcon,
			profile.npTextSide,
			100,
			"right", --N/A
			"empty", --N/A
			"right", --N/A
			"empty") --N/A
	else
		if profile.npShowLabel == true then
			bar.text:SetText(bar.cell.frame.view.name)
		else
			bar.text:SetText("")
		end
		LIBBars:SetIconTexture(bar, "")
		LIBBars:Draw(bar,
			npwidth,
			npheight,
			"none", -- always hide icon of merged cell nameplates
			profile.npTextSide,
			100,
			"right", --N/A
			"empty", --N/A
			"right", --N/A
			"empty") --N/A
	end
end

function mod:AcquireNameplateBar(cell, ability, ismerged)
	local bar = LIBBars:AcquireBar()
	bar.cell = cell
	bar.ability = ability
	bar:SetParent(cell)
	
	local profile = cell.frame.profile

	self:UpdateNameplateVisuals(bar, ismerged)
	
	return bar
end

function mod:ReleaseBar(bar)
	bar.instance = nil
	bar.created = nil
	bar.cell = nil
	bar.ability = nil
	LIBBars:ReleaseBar(bar)
end

function mod:GetBarForInstance(cell, instance)
	for _, bar in ipairs(cell.bars) do
		if bar.instance == instance then
			return bar
		end
	end
	
	error("failed to locate bar for instance")
end

function mod:EnsureMinimumBarCount(cell)
	local countChanged = false
	local profile = cell.frame.profile
	while #cell.bars < profile.cellMax do
		local bar = self:AcquireSpellBar(cell)
		self:InitializeSpellBarInstance(bar, nil)
		countChanged = true
	end
	
	return countChanged
end

function mod:ReleaseExtraBars(cell) -- recursive function that removes unneeded bars (recycles them)
	local deletedBar = nil
	local profile = cell.frame.profile
	
	--if the amount of existing bars is greater than the max viewable bars
	if #cell.bars > profile.cellMax then
		for _, bar in ipairs(cell.bars) do
			if not bar.instance then
				deletedBar = bar
				break
			end
		end
	end
	
	if deletedBar then
		self:ReleaseBar(deletedBar)
		_deleteFromIndexedTable(cell.bars, deletedBar)
		self:SortBars(cell)
		self:PositionSpellBars(cell)
		self:ReleaseExtraBars(cell)
	end
end

function mod:SortBars(cell)
	sort(cell.bars,
		function(a, b)
			if(not a.instance and b.instance) then
				return false
			end
			if(a.instance and not b.instance) then
				return true --A above B
			end
			if(not a.instance and not a.instance) then
				return false
			end
			
			--they both have an instance, sort compared to instances
			if cell == cell.frame.mergedcell then
				--this is the merged cell, sort by "all" instances
				local instancesA = cell.frame.view.instances["all"]
				local instancesB = cell.frame.view.instances["all"]
				local ia = _findTableIndex(instancesA, a.instance)
				local ib = _findTableIndex(instancesB, b.instance)
				return ia < ib
			else
				local instancesA = cell.frame.view.instances[a.instance.ability]
				local instancesB = cell.frame.view.instances[b.instance.ability]
				local ia = _findTableIndex(instancesA, a.instance)
				local ib = _findTableIndex(instancesB, b.instance)
				return ia < ib
			end
		end
	)
end

------------------------------------------------------------------
--SPELL BAR
------------------------------------------------------------------
function mod:GetSpellBarNameText(bar)
	local profile = bar.cell.frame.profile
	
	if profile.barShowPlayerName == true and profile.barShowSpellName == true then
		return bar.instance.sender.name.."-"..bar.instance.ability.name
	elseif profile.barShowPlayerName == true and profile.barShowSpellName == false then
		return bar.instance.sender.name
	elseif profile.barShowPlayerName == false and profile.barShowSpellName == true then
		return bar.instance.ability.name
	else
		return ""
	end
end

function mod:SetSpellBarStyle(bar)
	local profile = bar.cell.frame.profile
	local instance, available, cooldown = self:GetSpellBarInstanceState(bar.instance)
	
	if not instance or (available == false and profile.hideNoAvailSender == true) then
		self:SetSpellBarStyleEmpty(bar)
		bar:Hide()
		return
	end
	
	if available == true and cooldown == false then
		self:SetSpellBarStyleAvailable(bar)
		if profile.hideNoCooldown == true and not bar.instance.remaining then
			bar:Hide()
		else
			bar:Show()
		end
		return
	end
	
	if available == true and cooldown == true then
		self:SetSpellBarStyleOnCooldown(bar)
		bar:Show()
		return
	end
	
	self:SetSpellBarStyleUnavailable(bar)
	if profile.hideNoCooldown == true and not bar.instance.remaining then
		bar:Hide()
	else
		bar:Show()
	end
end

function mod:SetSpellBarStyleEmpty(bar)
	LIBBars:StopForegroundAnimation(bar)
	bar.text:SetText("")
	bar.isStyleEmpty = 1
end

function mod:SetSpellBarStyleAvailable(bar)
	local profile = bar.cell.frame.profile

	LIBBars:StopForegroundAnimation(bar)
	
	if profile.barCCA == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		LIBBars:SetForegroundTextureColor(bar,
			color.r,
			color.g,
			color.b,
			profile.barColorA.a)
	else
		LIBBars:SetForegroundTextureColor(bar, 
			profile.barColorA.r,
			profile.barColorA.g,
			profile.barColorA.b,
			profile.barColorA.a)
	end
	
	if profile.barCCAFont == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		LIBBars:SetFontColorText(bar,
			color.r,
			color.g,
			color.b,
			profile.barColorAFont.a)
	else
		LIBBars:SetFontColorText(bar,
			profile.barColorAFont.r,
			profile.barColorAFont.g,
			profile.barColorAFont.b,
			profile.barColorAFont.a)
	end
	
	--clear or set sender name and duration
	bar.text:SetText(self:GetSpellBarNameText(bar))
	bar.isStyleEmpty = nil
end

function mod:SetSpellBarStyleOnCooldown(bar)
	local profile = bar.cell.frame.profile
	
	if profile.barBGCCC == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		LIBBars:SetBackgroundTextureColor(bar,
			color.r,
			color.g,
			color.b,
			profile.barBGColorC.a)
	else
		LIBBars:SetBackgroundTextureColor(bar,
			profile.barBGColorC.r,
			profile.barBGColorC.g,
			profile.barBGColorC.b,
			profile.barBGColorC.a)
	end
	
	if profile.barCCC == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		LIBBars:SetForegroundTextureColor(bar,
			color.r,
			color.g,
			color.b,
			profile.barColorC.a)
	else
		LIBBars:SetForegroundTextureColor(bar,
			profile.barColorC.r,
			profile.barColorC.g,
			profile.barColorC.b,
			profile.barColorC.a)
	end
	
	if profile.barCCCFont == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		LIBBars:SetFontColorText(bar,
			color.r,
			color.g,
			color.b,
			profile.barColorCFont.a)
		LIBBars:SetFontColorDuration(bar,
			color.r,
			color.g,
			color.b,
			profile.barColorCFont.a)
	else
		LIBBars:SetFontColorText(bar,
			profile.barColorCFont.r,
			profile.barColorCFont.g,
			profile.barColorCFont.b,
			profile.barColorCFont.a)
		LIBBars:SetFontColorDuration(bar,
			profile.barColorCFont.r,
			profile.barColorCFont.g,
			profile.barColorCFont.b,
			profile.barColorCFont.a)
	end
	
	--clear or set sender name and duration
	bar.text:SetText(self:GetSpellBarNameText(bar))
	bar.isStyleEmpty = nil
end

function mod:SetSpellBarStyleUnavailable(bar)
	local profile = bar.cell.frame.profile
	
	--don't stop the cooldown if the animation is still running!!
	if profile.barBGCCU == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		LIBBars:SetBackgroundTextureColor(bar,
			color.r,
			color.g,
			color.b,
			profile.barBGColorU.a)
	else
		LIBBars:SetBackgroundTextureColor(bar,
			profile.barBGColorU.r,
			profile.barBGColorU.g,
			profile.barBGColorU.b,
			profile.barBGColorU.a)
	end
	
	if profile.barCCU == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		LIBBars:SetForegroundTextureColor(bar,
			color.r,
			color.g,
			color.b,
			profile.barColorU.a)
	else
		LIBBars:SetForegroundTextureColor(bar,
			profile.barColorU.r,
			profile.barColorU.g,
			profile.barColorU.b,
			profile.barColorU.a)
	end
	
	if profile.barCCUFont == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		LIBBars:SetFontColorText(bar,
			color.r,
			color.g,
			color.b,
			profile.barColorUFont.a)
		LIBBars:SetFontColorDuration(bar,
			color.r,
			color.g,
			color.b,
			profile.barColorUFont.a)
	else
		LIBBars:SetFontColorText(bar,
			profile.barColorUFont.r,
			profile.barColorUFont.g,
			profile.barColorUFont.b,
			profile.barColorUFont.a)
		LIBBars:SetFontColorDuration(bar,
			profile.barColorUFont.r,
			profile.barColorUFont.g,
			profile.barColorUFont.b,
			profile.barColorUFont.a)
	end
	
	local status = self:GetSpellBarNameText(bar)
	
	if bar.instance.sender.online == false then
		status = status.." ("..L["offline"]..")"
	elseif bar.instance.sender.dead == true then
		status = status.." ("..L["dead"]..")"
	elseif not bar.instance.sender.visible then
		status = status.." ("..L["range"]..")"
	end
	--clear or set sender name and duration
	bar.text:SetText(status)
	
	bar.isStyleEmpty = nil
end

function mod:UpdateSpellBarAnimations(bar)
	if bar.instance and bar.instance.remaining then
		LIBBars:AnimateForegroundTexture(bar, bar.instance.initialDuration, bar.instance.remaining, bar.cell.frame.profile.barShowTime)
	else
		LIBBars:StopForegroundAnimation(bar)
	end
end

function mod:GetSpellBarInstanceState(instance)
	local exists
	local available
	local cooldown
			
	if not instance then
		exists = false
		available = false
		cooldown = false
	else
		exists = true
		--only mark available if the sender is available
		available = Hermes:IsSenderAvailable(instance.sender)
		cooldown = instance.remaining ~= nil
	end
	
	return exists, available, cooldown
end

function mod:ShowSpellBars(cell, show)
	if cell.bars then
		local profile = cell.frame.profile
		if show and show == true then
			local cnt = 0
			for _, bar in ipairs(cell.bars) do
				--never show more tick tacks than what the max is set to!
				if(cnt < profile.cellMax) then
					bar:Show()
				else
					bar:Hide()
				end
				cnt =  cnt + 1
			end
		else
			for _, bar in ipairs(cell.bars) do
				bar:Hide()
			end
		end
	end
end

function mod:PositionSpellBars(cell)
	--position the bars
	if cell.frame.profile.cellDir == false then
		self:PositionSpellBarsVertical(cell)
	else
		self:PositionSpellBarsHorizontal(cell)
	end
end

function mod:PositionSpellBarsVertical(cell)
	local profile = cell.frame.profile
	
	local height = profile.barH
	local width = profile.barW
	local bars_to_display = profile.cellMax
	
	cell.nameplate:ClearAllPoints()
	
	--first position the nameplate
	if profile.npUseNameplate == true then 
		if profile.cellSide == false then --down
			cell.nameplate:SetPoint("TOPLEFT", cell, "TOPLEFT", profile.barPadding, -profile.barPadding)
		else --up
			cell.nameplate:SetPoint("BOTTOMLEFT", cell, "BOTTOMLEFT", profile.barPadding, profile.barPadding)
		end
		
		cell.nameplate:Show()
	else
		cell.nameplate:Hide()
	end

	local count = 1
	local namePlateOffset = profile.npH
	if profile.npUseNameplate == false then
		namePlateOffset = 0
	end
	
	for _, bar in ipairs(cell.bars) do
		if count <= bars_to_display then
			if profile.hideNoCooldown == true and bar.instance and not bar.instance.remaining then
				--skip bars if hiding when not on cooldown
				count = count - 1
				bar:Hide()
				bar:ClearAllPoints()
			else
				local offsety, anchorTicTac, anchorNamePlate
				if(profile.cellSide == false) then
					--down
					offsety = (((( count - 1 ) * (height + profile.barGap)) * -1)) - (profile.barPadding * 2) - namePlateOffset
					anchorTicTac = "TOP"
					anchorNamePlate = "TOP"
				else --up
					anchorTicTac = "BOTTOM"
					anchorNamePlate = "BOTTOM"
					offsety = ((( count - 1 ) * (height + profile.barGap))) + (profile.barPadding * 2) + namePlateOffset
				end

				bar:ClearAllPoints()
				bar:SetPoint(anchorTicTac, cell, anchorNamePlate, 0, offsety) --TOP assignment
				bar:SetPoint("LEFT", cell, "LEFT", profile.barPadding, 0) --LEFT offset
				
				--only show the bar if it's not empty
				if not bar.isStyleEmpty then
					bar:Show()
				end
			end
		else
			bar:Hide()
			bar:ClearAllPoints()
		end
		
		count = count + 1
	end
end

function mod:PositionSpellBarsHorizontal(cell)
	local profile = cell.frame.profile
	
	local height = profile.barH
	local width = profile.barW
	local bars_to_display = profile.cellMax
	
	cell.nameplate:ClearAllPoints()
	
	--first position the nameplate
	if profile.npUseNameplate == true then
		if(profile.cellSide == false) then --name plate on left
			cell.nameplate:SetPoint("TOPLEFT", cell, "TOPLEFT", profile.barPadding, -profile.barPadding)
		else --name plate on the right
			cell.nameplate:SetPoint("TOPRIGHT", cell, "TOPRIGHT", -profile.barPadding, -profile.barPadding)
		end
		cell.nameplate:Show()
	else
		cell.nameplate:Hide()
	end
	
	local count = 1
	local namePlateOffset = profile.npW
	if profile.npUseNameplate == false then
		namePlateOffset = 0
	end
	
	for _, bar in ipairs(cell.bars) do
		if count <= bars_to_display then
			if profile.hideNoCooldown == true and bar.instance and not bar.instance.remaining then
				--skip bars if hiding when not on cooldown
				count = count - 1
				bar:Hide()
				bar:ClearAllPoints()
			else
				local offsetx, anchorTicTac, anchorNamePlate
				if(profile.cellSide == false) then
					--name plate on left
					offsetx = (( count - 1 ) * (profile.barW + profile.barGap)) + (profile.barPadding * 2) + namePlateOffset
					anchorTicTac = "LEFT"
					anchorNamePlate = "LEFT"
				else
					--name plate on right
					offsetx = ((( count - 1 ) * (profile.barW + profile.barGap)) + (profile.barPadding * 2) + namePlateOffset) * -1
					anchorTicTac = "RIGHT"
					anchorNamePlate = "RIGHT"
				end

				bar:ClearAllPoints()
				bar:SetPoint(anchorTicTac, cell, anchorNamePlate, offsetx, 0) --LEFT
				
				--only show the bar if it's not empty
				if not bar.isStyleEmpty then
					bar:Show()
				end
			end
		else
			bar:Hide()
			bar:ClearAllPoints()
		end
		
		count = count + 1
	end
end

-----------------------------------------------------------------------
-- TOOLTIP
-----------------------------------------------------------------------
function mod:ShouldRefreshTooltip(frame, cell)
	if ToolTip and ToolTip.cell and (ToolTip.cell == cell or ToolTip.cell == frame.mergedcell) then
		return 1
	end
end

function mod:RefreshTooltip()
	if(ToolTip ~= nil) then
		ToolTip:Clear()
		local cell = ToolTip.cell
		local profile = cell.frame.profile
		
		if profile.merged == true then
			self:RefreshTooltipMerged()
			return
		end
		
		local ability = cell.ability
		instances = cell.frame.view.instances[ability]
		
		local spellLine = ToolTip:AddLine("", "", "", "", "")
		ToolTip:SetCell(spellLine, 1, ability.name, nil, "LEFT", nil, nil, 1, nil, 130, nil)
		ToolTip:SetCell(spellLine, 5, tostring(Hermes:AbilityIdToBlizzId(ability.id)), SpellIdFont, "RIGHT", nil, nil, nil, 1, nil, nil)
		ToolTip:SetLineColor(spellLine,
			1,
			1,
			1,
			0.4)

		if(#instances == 0) then
			ToolTip:AddSeparator(1)
			local line = ToolTip:AddLine("", "", "", "", "")
			ToolTip:SetCell(line, 1, L["None found"], nil, "LEFT", 5) --set the id
		else
			ToolTip:AddLine(
				" ",
				L["Time"],
				L["Alive"],
				L["Conn"],
				L["Range"])
				
			ToolTip:AddSeparator(1)
		
			for _, instance in ipairs(instances) do
				local sender = instance.sender
			
				--available, playername, duration, alive, visibility, online
				local iconAvailable
				if not instance.remaining and sender.dead == false and sender.online == true and sender.visible then
					iconAvailable = "|T"..ICON_STATUS_READY..":0:0:0:0|t"
				else
					iconAvailable = "|T"..ICON_STATUS_NOTREADY..":0:0:0:0|t"
				end
			
				local iconDead
				if(sender.dead) then
					iconDead = "|T"..ICON_STATUS_NOTREADY..":0:0:0:0|t"
				else
					iconDead = "|T"..ICON_STATUS_READY..":0:0:0:0|t"
				end
			
				local iconOnline
				if(sender.online == true) then
					iconOnline = "|T"..ICON_STATUS_READY..":0:0:0:0|t"
				else
					iconOnline = "|T"..ICON_STATUS_NOTREADY..":0:0:0:0|t"
				end
			
				local iconRange
				if sender.visible then
					iconRange = "|T"..ICON_STATUS_READY..":0:0:0:0|t"
				else
					iconRange = "|T"..ICON_STATUS_NOTREADY..":0:0:0:0|t"
				end
			
				local h, m, s = _secondsToClock(instance.remaining)
				local durationText, timeLeft
				
				if not h and not m and not s then
					--no remaining
					timeLeft = nil
				elseif h then
					timeLeft = format("%d:%02.f:%02.f", h, m, s)
				elseif m then
					timeLeft = format("%d:%02.f", m, s)
				else
					timeLeft = format("%d", s)
				end
				
				if sender.dead == true or sender.online == false or not sender.visible then
					--special case if the user is not connected, dead, or not visible
					if(instance.remaining) then
						durationText = "|cFFFF0000"..timeLeft.."|r" --red
					else
						durationText = "|cFFFF0000"..L["Ready"].."|r" --red
					end
				elseif(instance.remaining == nil) then
					durationText = "|cFF00FF00"..L["Ready"].."|r"							--green
				elseif(instance.remaining < 10) then
					durationText = "|cFFFFFF00"..timeLeft.."|r" --yellow
				else
					durationText = "|cFFFF0000"..timeLeft.."|r" --red
				end
			
				local line = ToolTip:AddLine(
					Hermes:GetClassColorString(sender.name, sender.class),
					" "..durationText,
					" "..iconDead,
					" "..iconOnline,
					" "..iconRange
				)
			end
		end
	end
end

function mod:RefreshTooltipMerged()
	local cell = ToolTip.cell
	local instances = cell.frame.view.instances["all"]
			
	local spellLine = ToolTip:AddLine("", "", "", "", "")
	ToolTip:SetCell(spellLine, 1, cell.frame.view.name, nil, "LEFT", nil, nil, 1, nil, 130, nil)
	ToolTip:SetCell(spellLine, 5, "", SpellIdFont, "RIGHT", nil, nil, nil, 1, nil, nil)
	ToolTip:SetLineColor(spellLine,
		1,
		1,
		1,
		0.4)

	if(not instances or #instances == 0) then
		ToolTip:AddSeparator(1)
		local line = ToolTip:AddLine("", "", "", "", "")
		ToolTip:SetCell(line, 1, L["None found"], nil, "LEFT", 5) --set the id
	else
		ToolTip:AddLine(
			" ",
			L["Time"],
			L["Alive"],
			L["Conn"],
			L["Range"])
				
		ToolTip:AddSeparator(1)
		
		for _, instance in ipairs(instances) do
			local sender = instance.sender
			
			--available, playername, duration, alive, visibility, online
			local iconAvailable
			if not instance.remaining and sender.dead == false and sender.online == true and sender.visible then
				iconAvailable = "|T"..ICON_STATUS_READY..":0:0:0:0|t"
			else
				iconAvailable = "|T"..ICON_STATUS_NOTREADY..":0:0:0:0|t"
			end
			
			local iconDead
			if(sender.dead) then
				iconDead = "|T"..ICON_STATUS_NOTREADY..":0:0:0:0|t"
			else
				iconDead = "|T"..ICON_STATUS_READY..":0:0:0:0|t"
			end
		
			local iconOnline
			if(sender.online == true) then
				iconOnline = "|T"..ICON_STATUS_READY..":0:0:0:0|t"
			else
				iconOnline = "|T"..ICON_STATUS_NOTREADY..":0:0:0:0|t"
			end
		
			local iconRange
			if sender.visible then
				iconRange = "|T"..ICON_STATUS_READY..":0:0:0:0|t"
			else
				iconRange = "|T"..ICON_STATUS_NOTREADY..":0:0:0:0|t"
			end
		
			local h, m, s = _secondsToClock(instance.remaining)
			local durationText, timeLeft
			
			if not h and not m and not s then
				--no remaining
				timeLeft = nil
			elseif h then
				timeLeft = format("%d:%02.f:%02.f", h, m, s)
			elseif m then
				timeLeft = format("%d:%02.f", m, s)
			else
				timeLeft = format("%d", s)
			end
			
			if sender.dead == true or sender.online == false or not sender.visible then
				--special case if the user is not connected, dead, or not visible
				if(instance.remaining) then
					durationText = "|cFFFF0000"..timeLeft.."|r" --red
				else
					durationText = "|cFFFF0000"..L["Ready"].."|r" --red
				end
			elseif(instance.remaining == nil) then
				durationText = "|cFF00FF00"..L["Ready"].."|r"	--green
			elseif(instance.remaining < 10) then
				durationText = "|cFFFFFF00"..timeLeft.."|r" --yellow
			else
				durationText = "|cFFFF0000"..timeLeft.."|r" --red
			end
		
			local line = ToolTip:AddLine(
				"|T"..instance.ability.icon..":0:0:0:0|t "..Hermes:GetClassColorString(sender.name, sender.class),
				" "..durationText,
				" "..iconDead,
				" "..iconOnline,
				" "..iconRange
			)
		end
	end
end

function mod:ShowTooltip(cell, anchor)
	if ToolTip == nil then
		ToolTip = QTip:Acquire("ViewManager"..VIEW_NAME.."Tooltip", 5, "LEFT", "RIGHT", "RIGHT", "RIGHT", "RIGHT", "RIGHT")
		ToolTip:ClearAllPoints()
		ToolTip:SmartAnchorTo(anchor)
		ToolTip.cell = cell
		self:RefreshTooltip()
		ToolTip:Show()
	end
end

function mod:SetupToolTipFonts()
	if not SpellIdFont then
		SpellIdFont = CreateFont("ViewManager"..VIEW_NAME.."TooltipFont")
		local gfns = GameFontNormalSmall
		local filename, size, flags = gfns:GetFont()
		SpellIdFont:SetFont(filename, size, flags)
		local r, g, b, a = gfns:GetTextColor()
		local sr, sg, sb, sa = gfns:GetShadowColor()
		SpellIdFont:SetTextColor(r, g, b, a)
		SpellIdFont:SetShadowColor(sr, sg, sb, sa)
	end
end

-----------------------------------------------------------------------
-- VIEW
-----------------------------------------------------------------------
function mod:GetViewDisplayName() --REQUIRED
	return "GridBars"
end

function mod:GetViewDisplayDescription() --REQUIRED
	return L["GRIDBARS_VIEW_DESCRIPTION"]
end

function mod:GetViewDefaults() --REQUIRED
	local defaults = {
		scale = 1,
		locked = false,
		padding = 0,
		enableTooltip = true,
		merged = false,
		--------------
		hideNoSender = false,
		hideNoAvailSender = false,
		cellAnchor = "TOPLEFT",
		cellMax = 3,
		cellDir = false,
		cellSide = false,
		cellBGColor = {r = 0, g = 0, b = 0, a = 0 },
		--------------
		barFontSize = 12,
		barW = 150,
		barH = 14,
		barGap = 2,
		barPadding = 1,
		barTexture = "Blizzard",
		barFont = "Friz Quadrata TT",
		--------------
		barCCA = true,
		barCCC = true,
		barCCU = false,
		--------------
		barColorA = {r = 0.94, g = 0.94, b = 0.94, a = 1 },
		barColorC = {r = 0.55, g = 0.55, b = 0.55, a = 0.74 },
		barColorU = {r = 0, g = 0, b = 0, a = 0.23 },
		--------------
		barBGCCC = true,
		barBGColorC = {r = 0, g = 0, b = 0, a = 0.16 },
		--------------
		barBGCCU = false,
		barBGColorU = {r = 0, g = 0, b = 0, a = 0.16 },
		--------------
		barCCAFont = false,
		barCCCFont = true,
		barCCUFont = false,
		--------------
		barColorAFont = {r = 0.94, g = 0.94, b = 0.94, a = 1 },
		barColorCFont = {r = 1, g = 1, b = 1, a = 1 },
		barColorUFont = {r = 1, g = 1, b = 1, a = 0.3 },
		--------------
		barTextRatio = 65,
		barOutlineFont = true,
		barThickFont = false,
		--------------
		barIcon = "none",
		barIconMerged = "left",
		--------------
		barTextSide = "left",
		barCooldownStyle = "empty",
		barCooldownDirection = "right",
		--------------
		barShowPlayerName = true,
		barShowSpellName = false,
		barShowTime = true,
		--------------
		npH = 15,
		npW = 120,
		npFontSize = 12,
		npTexColor = {r = 0, g = 0, b = 0, a = 0.5 },
		npCCBar = false,
		npCCFont = true,
		npFontColor = {r = 0.92, g = 0.92, b = 0.92, a = 0.76 },
		npTexture = "Blizzard",
		npFont = "Friz Quadrata TT",
		npOutlineFont = true,
		npThickFont = false,
		npUseIcon = true,
		npUseNameplate = true,
		npTextSide = "right",
		npShowLabel = true,
		--------------
		npIcon = "right",
		--------------
		osEnabled = false,
		osCooldownStyle = "empty",
		osCooldownDirection = "right",
		osFGColor = {r = 0, g = 1, b = 0, a = 1 },
	}
	return defaults
end

function mod:GetViewOptionsTable(view) --REQUIRED
	local profile = view.profile
	local frame = view.frame

	local options = {
		locked = {
			type = "toggle",
			name = L["Lock Window"],
			width = "normal",
			get = function(info) return profile.locked end,
			order = 5,
			set = function(info, value)
				profile.locked = value
				self:LockFrame(frame)
			end,
		},
		merged = {
			type = "toggle",
			name = L["Merge Spells"],
			width = "normal",
			get = function(info) return profile.merged end,
			order = 7,
			set = function(info, value)
				profile.merged = value
				self:PositionCells(frame)
				self:SetFrameToVirtualSize(frame)
				ViewManager:UpdateViewModuleTable()
			end,
		},
		window = {
			name = L["Window"],
			type = "group",
			inline = false,
			order = 10,
			args = {
				scale = {
					type = "range",
					min = 0.1, max = 3, step = 0.01,
					name = L["Scale"],
					order = 15,
					width = "full",
					get = function(info) return profile.scale end,
					set = function(info, value)
						profile.scale = value
						frame:SetScale(profile.scale)
					end
				},
				xpos = {
					type = "input",
					name = "X",
					width = "full",
					get = function(info)
						local x, y = self:GetFramePosRelativeToAnchor(frame)
						return tostring(_round(x))
					end,
					order = 20,
					validate = function(info, value)
						local text = strtrim(value)
						if(string.len(text) == 0) then
							return "Value required"
						end
						
						local x = tonumber(text)
						if(x == nil) then
							return "Must enter a number"
						end
						return true
					end,
					set = function(info, value)
						local x, y = self:GetFramePosRelativeToAnchor(frame)
						self:SetFramePosRelativeToAnchor(frame, tonumber(strtrim(value)), y)
					end,
				},
				ypos = {
					type = "input",
					name = "Y",
					width = "full",
					get = function(info)
						local x, y = self:GetFramePosRelativeToAnchor(frame)
						return tostring(_round(y))
					end,
					order = 25,
					validate = function(info, value)
						local text = strtrim(value)
						if(string.len(text) == 0) then
							return "Value required"
						end
						
						local x = tonumber(text)
						if(x == nil) then
							return "Must enter a number"
						end
						return true
					end,
					set = function(info, value)
						local x, y = self:GetFramePosRelativeToAnchor(frame)
						self:SetFramePosRelativeToAnchor(frame, x, tonumber(strtrim(value)))
					end,
				},
				reset = {
					type = "execute",
					name = L["Reset Position"],
					width = "full",
					order = 30,
					func = function(info, value)
						frame:ClearAllPoints()
						frame:SetPoint("CENTER", UIParent, "CENTER")
						frame.profile.x = frame:GetLeft()
						frame.profile.y = frame:GetTop()
						self:SaveFramePosition(frame)
					end,
				},
			},
		},
		layout = {
			name = L["Layout"],
			type = "group",
			inline = false,
			order = 12,
			args = {
				cellAnchor = {
					type = "select",
					name = L["Anchor Point"],
					width = "full",
					get = function(info) return profile.cellAnchor end,
					order = 5,
					style = "dropdown",
					set = function(info, value)
						profile.cellAnchor = value
						self:UpdateFrameResizerPosition(frame)
						self:PositionCells(frame)
						self:SetFrameToVirtualSize(frame)
					end,
					values = {
						["TOPLEFT"] = L["Top Left"],
						["TOPRIGHT"] = L["Top Right"],
						["BOTTOMLEFT"] = L["Bottom Left"],
						["BOTTOMRIGHT"] = L["Bottom Right"],
					},
				},
				direction= {
					type = "select",
					name = L["Bar Direction"],
					order = 10,
					style = "dropdown",
					width = "full",
					get = function(info)
						if(profile.cellDir == false and profile.cellSide == false) then
							return "TOP TO BOTTOM"
						elseif(profile.cellDir == false and profile.cellSide == true) then
							return "BOTTOM TO TOP"
						elseif(profile.cellDir == true and profile.cellSide == false) then
							return "LEFT TO RIGHT"
						elseif(profile.cellDir == true and profile.cellSide == true) then
							return "RIGHT TO LEFT"
						end
					end,
					set = function(info, value)
						if(value == "TOP TO BOTTOM") then
							profile.cellDir = false
							profile.cellSide = false

						elseif(value == "BOTTOM TO TOP") then
							profile.cellDir = false
							profile.cellSide = true

						elseif(value == "LEFT TO RIGHT") then
							profile.cellDir = true
							profile.cellSide = false

						elseif(value == "RIGHT TO LEFT") then
							profile.cellDir = true
							profile.cellSide = true

						end

						--we also need to update the size of the nameplates when switching modes
						local npw, nph = self:GetNameplateDisplaySize(frame)
						
						for _, cell in ipairs(frame.cells) do
							LIBBars:SetSize(cell.nameplate, npw, nph, 1)
							self:PositionSpellBars(cell)
						end
						
						--handle mergedcell
						LIBBars:SetSize(frame.mergedcell.nameplate, npw, nph, 1)
						self:PositionSpellBars(frame.mergedcell)
					
						self:PositionCells(frame)
						self:SetFrameToVirtualSize(frame)
						ViewManager:UpdateViewModuleTable()
					end,
					values = {
						["LEFT TO RIGHT"] = L["Left to Right"],
						["RIGHT TO LEFT"] = L["Right to Left"],
						["TOP TO BOTTOM"] = L["Top to Bottom"],
						["BOTTOM TO TOP"] = L["Bottom to Top"],
					},
				},
				cellMax = {
					type = "range",
					min = 1,
					max = 25,
					step = 1,
					name = L["Bars to Show"],
					order = 15,
					width = "full",
					get = function(info) return profile.cellMax end,
					set = function(info, value)
						profile.cellMax = value
						for _, cell in ipairs(frame.cells) do
							self:ReleaseExtraBars(cell)
							self:EnsureMinimumBarCount(cell)
							self:SortBars(cell)
							self:PositionSpellBars(cell)
						end
						
						--handle mergedcell
						self:ReleaseExtraBars(frame.mergedcell)
						self:EnsureMinimumBarCount(frame.mergedcell)
						self:SortBars(frame.mergedcell)
						self:PositionSpellBars(frame.mergedcell)
						
						self:PositionCells(frame)
						self:SetFrameToVirtualSize(frame)
					end,
				},
				cellpadding = {
					type = "range", min = 0, max = 100, step = 1,
					name = L["Cell Padding"],
					width = "full",
					get = function(info) return profile.padding end,
					order = 20,
					set = function(info, value)
						profile.padding = value
						self:PositionCells(frame)
						self:SetFrameToVirtualSize(frame)
					end,
				},
				innerpadding = {
					type = "range",
					min = 0,
					max = 20,
					step = 1,
					name = L["Inner Padding"],
					order = 25,
					width = "full",
					get = function(info) return profile.barPadding end,
					set = 
						function(info, value)
							profile.barPadding = value
							for _, cell in ipairs(frame.cells) do
								self:PositionSpellBars(cell)
							end
							
							--handle mergedcell
							self:PositionSpellBars(frame.mergedcell)

							self:PositionCells(frame)
							self:SetFrameToVirtualSize(frame)
						end,
				},
				barGap = {
					type = "range",
					min = 0, max = 50, step = 1,
					name = L["Gap Between Bars"],
					width = "full",
					get = function(info) return profile.barGap end,
					order = 30,
					set = 
						function(info, value)
							profile.barGap = value
							for _, cell in ipairs(frame.cells) do
								self:PositionSpellBars(cell)
							end
							
							--handle mergedcell
							self:PositionSpellBars(frame.mergedcell)
							
							self:PositionCells(frame)
							self:SetFrameToVirtualSize(frame)
						end,
				},
			},
		},
		behavior = {
			name = L["Behavior"],
			type = "group",
			inline = false,
			order = 15,
			args = {
				hideNoSender = {
					type = "toggle",
					name = L["Hide Abilities without Senders"],
					width = "full",
					get = function(info) return profile.hideNoSender end,
					order = 5,
					disabled = profile.merged == true,
					set = function(info, value)
						profile.hideNoSender = value
						self:SetCellVisibilityForAllCells(frame)
						self:PositionCells(frame)
						self:SetFrameToVirtualSize(frame)
					end,
				},
				hideNoCooldown = {
					type = "toggle",
					name = L["Only show bar when spell is on cooldown"],
					width = "full",
					get = function(info) return profile.hideNoCooldown end,
					order = 10,
					set = function(info, value)
						profile.hideNoCooldown = value
						--now handle spell bars
						for _, cell in ipairs(frame.cells) do
							self:PositionSpellBars(cell)
						end
						--handle mergedcell
						self:PositionSpellBars(frame.mergedcell)
					end,
				},
			},
		},
		tooltip = {
			name = L["Tooltip"],
			type = "group",
			inline = false,
			order = 20,
			args = {
				enable = {
					type = "toggle",
					name = L["Enabled"],
					width = "normal",
					get = function(info) return profile.enableTooltip end,
					order = 0,
					set = function(info, value)
						profile.enableTooltip = value
						self:EnableTooltip(frame)
					end,
				},
			},
		},
		celloptions = {
			name = L["Cell Options"],
			type = "group",
			inline = false,
			order = 25,
			args = {
				backgroundcolor = {
					type = "color",
					hasAlpha = true,
					order = 20,
					name = L["Color"],
					width = "normal",
					get = function(info) return
						profile.cellBGColor.r,
						profile.cellBGColor.g,
						profile.cellBGColor.b,
						profile.cellBGColor.a
					end,
					set = function(info, r, g, b, a)
						profile.cellBGColor.r = r
						profile.cellBGColor.g = g
						profile.cellBGColor.b = b
						profile.cellBGColor.a = a
									
						--update all the cells in the container
						for _, cell in ipairs(frame.cells) do
							cell.backgroundTexture:SetTexture(
								profile.cellBGColor.r,
								profile.cellBGColor.g,
								profile.cellBGColor.b,
								profile.cellBGColor.a)
						end
						
						--update the mergedcell
						frame.mergedcell.backgroundTexture:SetTexture(
							profile.cellBGColor.r,
							profile.cellBGColor.g,
							profile.cellBGColor.b,
							profile.cellBGColor.a)
					end,
				},
			},
		},
		baroptions = {
			name = L["Bar Options"],
			type = "group",
			inline = false,
			childGroups = "tab",
			order = 30,
			args = {
				layout = {
					name = L["Layout"],
					type = "group",
					inline = false,
					order = 5,
					args = {
						barShowPlayerName = {
							type = "toggle",
							name = L["Show Player Name"],
							width = "full",
							get = function(info) return profile.barShowPlayerName end,
							order = 5,
							set =function(info, value)
								profile.barShowPlayerName = value
								for _, cell in ipairs(frame.cells) do
									for _, bar in ipairs(cell.bars) do
										self:SetSpellBarStyle(bar)
									end
								end
								--handle mergedcell
								for _, bar in ipairs(frame.mergedcell.bars) do
									self:SetSpellBarStyle(bar)
								end
							end,
						},
						barShowSpellName = {
							type = "toggle",
							name = L["Show Spell Name"],
							width = "full",
							get = function(info) return profile.barShowSpellName end,
							order = 10,
							set =function(info, value)
								profile.barShowSpellName = value
								for _, cell in ipairs(frame.cells) do
									for _, bar in ipairs(cell.bars) do
										self:SetSpellBarStyle(bar)
									end
								end
								--handle mergedcell
								for _, bar in ipairs(frame.mergedcell.bars) do
									self:SetSpellBarStyle(bar)
								end
							end,
						},
						barShowTime = {
							type = "toggle",
							name = L["Show Time"],
							width = "full",
							get = function(info) return profile.barShowTime end,
							order = 15,
							set =function(info, value)
								profile.barShowTime = value
								for _, cell in ipairs(frame.cells) do
									for _, bar in ipairs(cell.bars) do
										self:SetSpellBarStyle(bar)
									end
								end
								--handle mergedcell
								for _, bar in ipairs(frame.mergedcell.bars) do
									self:SetSpellBarStyle(bar)
								end
							end,
						},
						barTextSide = {
							type = "toggle",
							name = L["Swap Label Positions"], --replaced Swap Name and Duration with this
							width = "full",
							get = function(info) return profile.barTextSide == "right" end,
							order = 20,
							set =function(info, value)
								if value == true then
									profile.barTextSide = "right"
								else
									profile.barTextSide = "left"
								end
									
								for _, cell in ipairs(frame.cells) do
									for _, bar in ipairs(cell.bars) do
										LIBBars:SetNameSide(bar, profile.barTextSide, 1)
									end
								end
								
								--handle mergedcell
								for _, bar in ipairs(frame.mergedcell.bars) do
									LIBBars:SetNameSide(bar, profile.barTextSide, 1)
								end
								self:PositionSpellBars(frame.mergedcell)
								self:PositionCells(frame)
								self:SetFrameToVirtualSize(frame)
							end,
						},
						icon = {
							type = "select",
							name = L["Icon"],
							width = "full",
							get = function(info)
								if profile.merged then
									return profile.barIconMerged
								else
									return profile.barIcon
								end
							end,
							order = 25,
							style = "dropdown",
							set = function(info, value)
								if profile.merged then
									profile.barIconMerged = value
									for _, bar in ipairs(frame.mergedcell.bars) do
										LIBBars:SetIconLocation(bar, profile.barIconMerged, 1)
									end
								else
									profile.barIcon = value
									for _, cell in ipairs(frame.cells) do
										for _, bar in ipairs(cell.bars) do
											LIBBars:SetIconLocation(bar, profile.barIcon, 1)
										end
									end
								end
							end,
							values = {
								["left"] = L["Left"],
								["right"] = L["Right"],
								["none"] = L["None"],
							},
						},
						barCooldownStyle= {
							type = "select",
							name = L["Cooldown Style"],
							order = 30,
							style = "dropdown",
							width = "full",
							get = function(info)
								return profile.barCooldownStyle
							end,
							set = function(info, value)
								profile.barCooldownStyle = value
								for _, cell in ipairs(frame.cells) do
									for _, bar in ipairs(cell.bars) do
										LIBBars:SetAnimationStyle(bar, profile.barCooldownStyle, 1)
									end
								end
								
								--handle mergedcell
								for _, bar in ipairs(frame.mergedcell.bars) do
									LIBBars:SetAnimationStyle(bar, profile.barCooldownStyle, 1)
								end
							end,
							values = {
								["full"] = L["Starts Full"],
								["empty"] = L["Starts Empty"],
							},
						},
						barCooldownDirection = {
							type = "toggle",
							name = L["Reverse Direction"],
							width = "full",
							get = function(info) return profile.barCooldownDirection == "left" end,
							order = 35,
							set =function(info, value)
								if value == true then
									profile.barCooldownDirection = "left"
								else
									profile.barCooldownDirection = "right"
								end
								for _, cell in ipairs(frame.cells) do
									for _, bar in ipairs(cell.bars) do
										LIBBars:SetAnimationDirection(bar, profile.barCooldownDirection, 1)
									end
								end
								
								--handle mergedcell
								for _, bar in ipairs(frame.mergedcell.bars) do
									LIBBars:SetAnimationDirection(bar, profile.barCooldownDirection, 1)
								end
								self:PositionSpellBars(frame.mergedcell)
								self:PositionCells(frame)
								self:SetFrameToVirtualSize(frame)
							end,
						},
					},
				},
				size = {
					name = L["Size"],
					type = "group",
					inline = false,
					order = 10,
					args = {
						barW = {
							type = "range",
							min = 1, max = 400, step = 1,
							name = L["Width"],
							width = "full",
							get = function(info) return profile.barW end,
							order = 5,
							set = 
								function(info, value)
									profile.barW = value
									for _, cell in ipairs(frame.cells) do
										for _, bar in ipairs(cell.bars) do
											LIBBars:SetWidth(bar, profile.barW, 1)
										end
										
										if profile.cellDir == false then --vertical
											LIBBars:SetWidth(cell.nameplate, profile.barW, 1)
										end
										
										self:PositionSpellBars(cell)
									end
									
									--handle mergedcell
									for _, bar in ipairs(frame.mergedcell.bars) do
										LIBBars:SetWidth(bar, profile.barW, 1)
									end
									
									if profile.cellDir == false then --vertical
										LIBBars:SetWidth(frame.mergedcell.nameplate, profile.barW, 1)
									end
									
									self:PositionSpellBars(frame.mergedcell)
								
									self:PositionCells(frame)
									self:SetFrameToVirtualSize(frame)
								end,
						},
						barH = {
							type = "range",
							min = 1, max = 50, step = 1,
							name = L["Height"],
							width = "full",
							get = function(info) return profile.barH end,
							order = 10,
							set = 
								function(info, value)
									profile.barH = value
									for _, cell in ipairs(frame.cells) do
										for _, bar in ipairs(cell.bars) do
											LIBBars:SetHeight(bar, profile.barH, 1)
										end
										
										if profile.cellDir == true then
											LIBBars:SetHeight(cell.nameplate, profile.barH, 1)
										end
										
										self:PositionSpellBars(cell)
									end
									
									--handle mergedcell
									for _, bar in ipairs(frame.mergedcell.bars) do
										LIBBars:SetHeight(bar, profile.barH, 1)
									end
									
									if profile.cellDir == true then
										LIBBars:SetHeight(frame.mergedcell.nameplate, profile.barH, 1)
									end
									
									self:PositionSpellBars(frame.mergedcell)
								
									self:PositionCells(frame)
									self:SetFrameToVirtualSize(frame)
								end,
						},
					},
				},
				texture = {
					name = L["Texture"],
					type = "group",
					inline = false,
					order = 15,
					args = {
						barTexture = {
							type = 'select',
							order = 5,
							dialogControl = 'LSM30_Statusbar',
							name = L["Texture"],
							width = "full",
							values = AceGUIWidgetLSMlists.statusbar,
							get = function() return profile.barTexture end,
							set = function(info, value)
								profile.barTexture = value
								local texture = LIB_LibSharedMedia:Fetch("statusbar", profile.barTexture)
								for _, cell in ipairs(frame.cells) do
									for _,bar in ipairs(cell.bars) do
										LIBBars:SetBackgroundTexture(bar, texture)
										LIBBars:SetForegroundTexture(bar, texture)
									end
								end
								
								--handle mergedcell
								for _, bar in ipairs(frame.mergedcell.bars) do
									LIBBars:SetBackgroundTexture(bar, texture)
									LIBBars:SetForegroundTexture(bar, texture)
								end
							end,
						},
						AvailableBar = {
							name = L["Available Bar Color"],
							type = "group",
							inline = true,
							order = 10,
							args = {
								barColorA = {
									type = "color",
									hasAlpha = true,
									order = 5,
									name = L["Foreground"],
									width = "normal",
									get = function(info) return
										profile.barColorA.r,
										profile.barColorA.g,
										profile.barColorA.b,
										profile.barColorA.a
									end,
									set = function(info, r, g, b, a)
										profile.barColorA.r = r
										profile.barColorA.g = g
										profile.barColorA.b = b
										profile.barColorA.a = a
											
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _, bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
								barCCA = {
									type = "toggle",
									name = L["Use Class Color"],
									get = function() return profile.barCCA end,
									order = 10,
									width = "normal",
									set = function(info, value)
										profile.barCCA = value
											
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _, bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
							},
						},
						OnCooldownBar = {
							name = L["On Cooldown Bar Color"],
							type = "group",
							inline = true,
							order = 15,
							args = {
								barColorC = {
									type = "color",
									hasAlpha = true,
									order = 5,
									name = L["Foreground"],
									width = "normal",
									disabled = function() return profile.cellHideNoAvailSender end,
									get = function(info) return
										profile.barColorC.r,
										profile.barColorC.g,
										profile.barColorC.b,
										profile.barColorC.a
									end,
									set = function(info, r, g, b, a)
										profile.barColorC.r = r
										profile.barColorC.g = g
										profile.barColorC.b = b
										profile.barColorC.a = a
											
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _, bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
								barCCC = {
									type = "toggle",
									name = L["Use Class Color"],
									get = function() return profile.barCCC end,
									order = 10,
									width = "normal",
									disabled = function() return profile.cellHideNoAvailSender end,
									set = function(info, value)
										profile.barCCC = value
											
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _, bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
								spacer1A = {
									type = "description",
									name = "",
									width = "full",
									order = 12,
								},
								barBGColorC = {
									type = "color",
									hasAlpha = true,
									order = 15,
									name = L["Background"],
									width = "normal",
									get = function(info) return
										profile.barBGColorC.r,
										profile.barBGColorC.g,
										profile.barBGColorC.b,
										profile.barBGColorC.a
									end,
									set = function(info, r, g, b, a)
										profile.barBGColorC.r = r
										profile.barBGColorC.g = g
										profile.barBGColorC.b = b
										profile.barBGColorC.a = a
											
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _, bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
								barBGCCC = {
									type = "toggle",
									name = L["Use Class Color"],
									get = function() return profile.barBGCCC end,
									order = 20,
									width = "normal",
									set = function(info, value)
										profile.barBGCCC = value
											
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _, bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
							},
						},
						UnavialableBar = {
							name = L["Unavailable Bar Color"],
							type = "group",
							inline = true,
							order = 20,
							args = {
								barColorU = {
									type = "color",
									hasAlpha = true,
									order = 5,
									name = L["Foreground"],
									width = "normal",
									get = function(info) return
										profile.barColorU.r,
										profile.barColorU.g,
										profile.barColorU.b,
										profile.barColorU.a
									end,
									set = function(info, r, g, b, a)
										profile.barColorU.r = r
										profile.barColorU.g = g
										profile.barColorU.b = b
										profile.barColorU.a = a
											
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _, bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
								barCCU = {
									type = "toggle",
									name = L["Use Class Color"],
									get = function() return profile.barCCU end,
									order = 10,
									width = "normal",
									disabled = function() return profile.cellHideNoAvailSender end,
									set = function(info, value)
										profile.barCCU = value
											
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _, bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
								spacer1A = {
									type = "description",
									name = "",
									width = "full",
									order = 12,
								},
								barBGColorU = {
									type = "color",
									hasAlpha = true,
									order = 15,
									name = L["Background"],
									width = "normal",
									get = function(info) return
										profile.barBGColorU.r,
										profile.barBGColorU.g,
										profile.barBGColorU.b,
										profile.barBGColorU.a
									end,
									set = function(info, r, g, b, a)
										profile.barBGColorU.r = r
										profile.barBGColorU.g = g
										profile.barBGColorU.b = b
										profile.barBGColorU.a = a
											
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _, bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
								barBGCCU = {
									type = "toggle",
									name = L["Use Class Color"],
									get = function() return profile.barBGCCU end,
									order = 20,
									width = "normal",
									set = function(info, value)
										profile.barBGCCU = value
											
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _, bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
							},
						},
					},
				},
				font = {
					name = L["Font"],
					type = "group",
					inline = false,
					order = 20,
					args = {
						barFont = {
							type = "select",
							dialogControl = 'LSM30_Font',
							order = 5,
							name = L["Font"],
							width = "full",
							values = AceGUIWidgetLSMlists.font,
							get = function(info) return profile.barFont end,
							set = function(info, value)
								profile.barFont = value
								for _, cell in ipairs(frame.cells) do
									for _,bar in ipairs(cell.bars) do
										self:UpdateSpellBarFont(bar)
									end
								end
								
								--handle mergedcell
								for _, bar in ipairs(frame.mergedcell.bars) do
									self:UpdateSpellBarFont(bar)
								end
							end,
						},
						barOutlineFont = {
							type = "toggle",
							name = L["Drop Shadow"],
							get = function() return profile.barOutlineFont end,
							order = 7,
							width = "normal",
							set = function(info, value)
								profile.barOutlineFont = value
								for _, cell in ipairs(frame.cells) do
									for _,bar in ipairs(cell.bars) do
										self:UpdateSpellBarFont(bar)
									end
								end
								
								--handle mergedcell
								for _, bar in ipairs(frame.mergedcell.bars) do
									self:UpdateSpellBarFont(bar)
								end
							end,
						},
						barThickFont = {
							type = "toggle",
							name = L["Outline"],
							get = function() return profile.barThickFont end,
							order = 8,
							width = "normal",
							set = function(info, value)
								profile.barThickFont = value
								for _, cell in ipairs(frame.cells) do
									for _,bar in ipairs(cell.bars) do
										self:UpdateSpellBarFont(bar)
									end
								end
								
								--handle mergedcell
								for _, bar in ipairs(frame.mergedcell.bars) do
									self:UpdateSpellBarFont(bar)
								end
							end,
						},
						FontSizeMultiplier = {
							type = "range",
							min = 1, max = 28, step = 1,
							name = L["Font Size"],
							width = "full",
							get = function(info) return profile.barFontSize end,
							order = 10,
							set = function(info, value)
								profile.barFontSize = value
								for _, cell in ipairs(frame.cells) do
									for _,bar in ipairs(cell.bars) do
										self:UpdateSpellBarFont(bar)
									end
								end
								
								--handle mergedcell
								for _, bar in ipairs(frame.mergedcell.bars) do
									self:UpdateSpellBarFont(bar)
								end
							end,
						},
						barTextRatio = {
							type = "range",
							min = 0, max = 100, step = 1,
							name = L["Player/Duration Width Ratio (%)"],
							width = "full",
							get = function(info) return profile.barTextRatio end,
							order = 15,
							set = function(info, value)
								profile.barTextRatio = value
								for _, cell in ipairs(frame.cells) do
									for _, bar in ipairs(cell.bars) do
										LIBBars:SetTextRatio(bar, profile.barTextRatio, true)
									end
								end
								
								--handle mergedcell
								for _, bar in ipairs(frame.mergedcell.bars) do
									LIBBars:SetTextRatio(bar, profile.barTextRatio, true)
								end
							end,
						},
						AvailableFont = {
							name = L["Available Font Color"],
							type = "group",
							inline = true,
							order = 20,
							args = {
								barColorAFont = {
									type = "color",
									hasAlpha = true,
									order = 5,
									name = "",
									width = "normal",
									get = function(info) return
										profile.barColorAFont.r,
										profile.barColorAFont.g,
										profile.barColorAFont.b,
										profile.barColorAFont.a
									end,
									set = function(info, r, g, b, a)
										profile.barColorAFont.r = r
										profile.barColorAFont.g = g
										profile.barColorAFont.b = b
										profile.barColorAFont.a = a
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _,bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)

										end
									end,
								},
								barCCAFont = {
									type = "toggle",
									name = L["Use Class Color"],
									get = function() return profile.barCCAFont end,
									order = 10,
									width = "normal",
									set = function(info, value)
										profile.barCCAFont = value
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _,bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
							},
						},
						OnCooldownFont = {
							name = L["On Cooldown Font Color"],
							type = "group",
							inline = true,
							order = 25,
							args = {
								barColorCFont = {
									type = "color",
									hasAlpha = true,
									order = 5,
									name = "",
									width = "normal",
									get = function(info) return
										profile.barColorCFont.r,
										profile.barColorCFont.g,
										profile.barColorCFont.b,
										profile.barColorCFont.a
									end,
									set = function(info, r, g, b, a)
										profile.barColorCFont.r = r
										profile.barColorCFont.g = g
										profile.barColorCFont.b = b
										profile.barColorCFont.a = a
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _,bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
								barCCCFont = {
									type = "toggle",
									name = L["Use Class Color"],
									get = function() return profile.barCCCFont end,
									order = 10,
									width = "normal",
									set = function(info, value)
										profile.barCCCFont = value
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _,bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
							},
						},
						UnavailableFont = {
							name = L["Unavailable Font Color"],
							type = "group",
							inline = true,
							order = 30,
							args = {
								barColorUFont = {
									type = "color",
									hasAlpha = true,
									order = 5,
									name = "",
									width = "normal",
									disabled = function() return profile.cellHideNoAvailSender end,
									get = function(info) return
										profile.barColorUFont.r,
										profile.barColorUFont.g,
										profile.barColorUFont.b,
										profile.barColorUFont.a
									end,
									set = function(info, r, g, b, a)
										profile.barColorUFont.r = r
										profile.barColorUFont.g = g
										profile.barColorUFont.b = b
										profile.barColorUFont.a = a
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _,bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
								barCCUFont = {
									type = "toggle",
									name = L["Use Class Color"],
									get = function() return profile.barCCUFont end,
									order = 10,
									width = "normal",
									disabled = function() return profile.cellHideNoAvailSender end,
									set = function(info, value)
										profile.barCCUFont = value
										for _, cell in ipairs(frame.cells) do
											for _,bar in ipairs(cell.bars) do
												self:SetSpellBarStyle(bar)
											end
										end
										
										--handle mergedcell
										for _,bar in ipairs(frame.mergedcell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end,
								},
							},
						},
					},
				},
			},
		},
		nameplateoptions = {
			name = "Nameplate Options",
			type = "group",
			inline = false,
			childGroups = "tab",
			order = 35,
			args = {
				layout = {
					name = L["Layout"],
					type = "group",
					inline = false,
					order = 5,
					args = {
						npUseNameplate = {
							type = "toggle",
							name = L["Show Nameplate"],
							width = "full",
							get = function(info) return profile.npUseNameplate end,
							order = 5,
							set =function(info, value)
								profile.npUseNameplate = value
								
								for _, cell in ipairs(frame.cells) do
									self:PositionSpellBars(cell)
								end
								
								--handle mergedcell
								self:PositionSpellBars(frame.mergedcell)
								self:PositionCells(frame)
								self:SetFrameToVirtualSize(frame)
								ViewManager:UpdateViewModuleTable()
							end,
						},
						npShowLabel = {
							type = "toggle",
							name = L["Show Label"],
							width = "full",
							get = function(info) return profile.npShowLabel end,
							order = 10,
							disabled = profile.npUseNameplate == false,
							set =function(info, value)
								profile.npShowLabel = value
								for _, cell in ipairs(frame.cells) do
									self:UpdateNameplateVisuals(cell.nameplate, nil)
								end
								
								--handle mergedcell
								self:UpdateNameplateVisuals(frame.mergedcell.nameplate, 1)
								ViewManager:UpdateViewModuleTable()
							end,
						},
						npTextSide = {
							type = "toggle",
							name = L["Name on Right"],
							width = "full",
							get = function(info) return profile.npTextSide == "right" end,
							order = 15,
							disabled = profile.npUseNameplate == false or profile.npShowLabel == false,
							set =function(info, value)
								if value == true then
									profile.npTextSide = "right"
								else
									profile.npTextSide = "left"
								end
								for _, cell in ipairs(frame.cells) do
									LIBBars:SetNameSide(cell.nameplate, profile.npTextSide, 1)
								end
								
								--handle mergedcell
								LIBBars:SetNameSide(frame.mergedcell.nameplate, profile.npTextSide, 1)
								self:PositionSpellBars(frame.mergedcell)
								self:PositionCells(frame)
								self:SetFrameToVirtualSize(frame)
							end,
						},
						icon = {
							type = "select",
							name = L["Icon"],
							width = "normal",
							hidden = profile.merged == true,
							disabled = profile.npUseNameplate == false,
							get = function(info)
								return profile.npIcon
							end,
							order = 20,
							style = "dropdown",
							set = function(info, value)
								profile.npIcon = value
								for _, cell in ipairs(frame.cells) do
									LIBBars:SetIconLocation(cell.nameplate, profile.npIcon, 1)
								end
							end,
							values = {
								["left"] = L["Left"],
								["right"] = L["Right"],
								["none"] = L["None"],
							},
						},
					},
				},
				size = {
					name = L["Size"],
					type = "group",
					inline = false,
					order = 10,
					disabled = function(info) return profile.npUseNameplate == false end,
					args = {
						npW = {
							type = "range",
							min = 1,
							max = 400,
							step = 1,
							name = L["Width"],
							order = 5,
							width = "full",
							disabled = profile.cellDir == false,
							get = function(info) return profile.npW end,
							set = function(info, value)
								profile.npW = value
								for _, cell in ipairs(frame.cells) do
									LIBBars:SetWidth(cell.nameplate, profile.npW, 1)
									self:PositionSpellBars(cell)
								end
								
								--handle mergedcell
								LIBBars:SetWidth(frame.mergedcell.nameplate, profile.npW, 1)
								self:PositionSpellBars(frame.mergedcell)
								
								self:PositionCells(frame)
								self:SetFrameToVirtualSize(frame)
							end,
						},
						npH = {
							type = "range",
							min = 8,
							max = 50,
							step = 1,
							name = L["Height"],
							order = 10,
							width = "full",
							disabled = profile.cellDir == true,
							get = function(info) return profile.npH end,
							set = function(info, value)
								profile.npH = value
								for _, cell in ipairs(frame.cells) do
									LIBBars:SetHeight(cell.nameplate, profile.npH, 1)
									self:PositionSpellBars(cell)
								end
								
								--handle mergedcell
								LIBBars:SetHeight(frame.mergedcell.nameplate, profile.npH, 1)
								self:PositionSpellBars(frame.mergedcell)
								
								self:PositionCells(frame)
								self:SetFrameToVirtualSize(frame)
							end,
						},
					},
				},
				texture = {
					name = L["Texture"],
					type = "group",
					inline = false,
					order = 15,
					disabled = function(info) return profile.npUseNameplate == false end,
					args = {
						npTexture = {
							type = 'select',
							order = 5,
							dialogControl = 'LSM30_Statusbar',
							name = L["Texture"],
							values = AceGUIWidgetLSMlists.statusbar,
							width = "full",
							get = function() return profile.npTexture end,
							set = function(info, value)
								profile.npTexture = value
								local texture = LIB_LibSharedMedia:Fetch("statusbar", profile.npTexture)
								--update all the cells in the frame
								for _, cell in ipairs(frame.cells) do
									LIBBars:SetBackgroundTexture(cell.nameplate, texture)
									LIBBars:SetForegroundTexture(cell.nameplate, texture)
								end
								
								--handle mergedcell
								LIBBars:SetBackgroundTexture(frame.mergedcell.nameplate, texture)
								LIBBars:SetForegroundTexture(frame.mergedcell.nameplate, texture)
							end,
						},
						BarColor = {
							name = L["Color"],
							type = "group",
							inline = true,
							order = 10,
							args = {
								npTexColor = {
									type = "color",
									hasAlpha = true,
									order = 5,
									name = L["Foreground"],
									width = "normal",
									get = function(info) return
										profile.npTexColor.r,
										profile.npTexColor.g,
										profile.npTexColor.b,
										profile.npTexColor.a
									end,
									set = function(info, r, g, b, a)
										profile.npTexColor.r = r
										profile.npTexColor.g = g
										profile.npTexColor.b = b
										profile.npTexColor.a = a
										
										--update all the cells in the frame
										for _, cell in ipairs(frame.cells) do
											self:UpdateNameplateVisuals(cell.nameplate)
										end
										
										--handle mergedcell
										self:UpdateNameplateVisuals(frame.mergedcell.nameplate, 1)
									end,
								},
								npCCBar = {
									type = "toggle",
									name = L["Use Class Color"],
									get = function() return profile.npCCBar end,
									order = 10,
									width = "normal",
									hidden = profile.merged == true,
									set = function(info, value)
										profile.npCCBar = value
										
										--update all the cells in the frame
										for _, cell in ipairs(frame.cells) do
											self:UpdateNameplateVisuals(cell.nameplate)
										end
										
										--handle mergedcell
										self:UpdateNameplateVisuals(frame.mergedcell.nameplate, 1)
									end,
								},
							},
						},
					},
				},
				font = {
					name = L["Font"],
					type = "group",
					inline = false,
					order = 20,
					disabled = function(info) return profile.npUseNameplate == false end,
					args = {
						npFont = {
							type = "select",
							dialogControl = 'LSM30_Font',
							order = 5,
							name = L["Font"],
							width = "full",
							values = AceGUIWidgetLSMlists.font,
							get = function(info) return profile.npFont end,
							set = function(info, value)
								profile.npFont = value
								
								--update all the cells in the frame
								for _, cell in ipairs(frame.cells) do
									self:UpdateNameplateVisuals(cell.nameplate, nil)
								end
								
								--handle mergedcell
								self:UpdateNameplateVisuals(frame.mergedcell.nameplate, 1)
							end,
						},
						npOutlineFont = {
							type = "toggle",
							name = L["Drop Shadow"],
							get = function() return profile.npOutlineFont end,
							order = 7,
							width = "normal",
							set = function(info, value)
								profile.npOutlineFont = value
								
								--update all the cells in the frame
								for _, cell in ipairs(frame.cells) do
									self:UpdateNameplateVisuals(cell.nameplate)
								end
								
								--handle mergedcell
								self:UpdateNameplateVisuals(frame.mergedcell.nameplate, 1)
							end,
						},
						npThickFont = {
							type = "toggle",
							name = L["Outline"],
							get = function() return profile.npThickFont end,
							order = 8,
							width = "normal",
							set = function(info, value)
								profile.npThickFont = value
								
								--update all the cells in the frame
								for _, cell in ipairs(frame.cells) do
									self:UpdateNameplateVisuals(cell.nameplate)
								end
								
								--handle mergedcell
								self:UpdateNameplateVisuals(frame.mergedcell.nameplate, 1)
							end,
						},
						npFontSize = {
							type = "range",
							min = 1, max = 28, step = 1,
							name = L["Font Size"],
							width = "full",
							get = function(info) return profile.npFontSize end,
							order = 10,
							set = function(info, value)
								profile.npFontSize = value
								--update all the cells in the frame
								for _, cell in ipairs(frame.cells) do
									self:UpdateNameplateVisuals(cell.nameplate)
								end
								
								--handle mergedcell
								self:UpdateNameplateVisuals(frame.mergedcell.nameplate, 1)
							end,
						},
						FontColor = {
							name = L["Color"],
							type = "group",
							inline = true,
							order = 15,
							args = {
								FontColor = {
									type = "color",
									hasAlpha = true,
									order = 5,
									name = "",
									width = "normal",
									get = function(info) return
										profile.npFontColor.r,
										profile.npFontColor.g,
										profile.npFontColor.b,
										profile.npFontColor.a
									end,
									set = function(info, r, g, b, a)
										profile.npFontColor.r = r
										profile.npFontColor.g = g
										profile.npFontColor.b = b
										profile.npFontColor.a = a
										
										--update all the cells in the frame
										for _, cell in ipairs(frame.cells) do
											self:UpdateNameplateVisuals(cell.nameplate)
										end
										
										--handle mergedcell
										self:UpdateNameplateVisuals(frame.mergedcell.nameplate, 1)
									end,
								},
								npCCFont = {
									type = "toggle",
									name = L["Use Class Color"],
									get = function() return profile.npCCFont end,
									order = 10,
									width = "normal",
									hidden = profile.merged == true,
									set = function(info, value)
										profile.npCCFont = value
										
										--update all the cells in the frame
										for _, cell in ipairs(frame.cells) do
											self:UpdateNameplateVisuals(cell.nameplate)
										end
										
										--handle mergedcell
										self:UpdateNameplateVisuals(frame.mergedcell.nameplate, 1)
									end
								},
							},
						},
					},
				},
			},
		},
		oneshottimer = {
			name = L["Duration Timer"],
			type = "group",
			inline = false,
			childGroups = "tab",
			order = 40,
			args = {
				description = {
					type = "description",
					name = L["Requires spell metadata key duration. If such a key exists, an additional timer bar will be displayed based on it's value. For example. you could supply a duration key with a value of 6 for Divine Guardian's 6 second duration."],
					order = 5,
					width = "full",
					fontSize = "medium",
				},
				osEnabled = {
					type = "toggle",
					name = L["Enabled"],
					width = "full",
					get = function(info) return profile.osEnabled end,
					order = 10,
					set =function(info, value)
						profile.osEnabled = value
						
						for _, cell in ipairs(frame.cells) do
							for _, bar in ipairs(cell.bars) do
								LIBBars:StopOneShotAnimation(bar)
							end
						end
						
						--handle mergedcell
						for _, bar in ipairs(frame.mergedcell.bars) do
							LIBBars:StopOneShotAnimation(bar)
						end
						
						ViewManager:UpdateViewModuleTable()
					end,
				},
				osCooldownStyle= {
					type = "select",
					name = L["Cooldown Style"],
					order = 20,
					style = "dropdown",
					width = "normal",
					disabled = profile.osEnabled ~= true,
					get = function(info)
						return profile.osCooldownStyle
					end,
					set = function(info, value)
						profile.osCooldownStyle = value
						for _, cell in ipairs(frame.cells) do
							for _, bar in ipairs(cell.bars) do
								LIBBars:SetOneShotAnimationStyle(bar, profile.osCooldownStyle, 1)
							end
						end
						
						--handle mergedcell
						for _, bar in ipairs(frame.mergedcell.bars) do
							LIBBars:SetOneShotAnimationStyle(bar, profile.osCooldownStyle, 1)
						end
					end,
					values = {
						["full"] = L["Starts Full"],
						["empty"] = L["Starts Empty"],
					},
				},
				osCooldownDirection = {
					type = "toggle",
					name = L["Reverse Direction"],
					width = "normal",
					get = function(info) return profile.osCooldownDirection == "left" end,
					order = 25,
					disabled = profile.osEnabled ~= true,
					set =function(info, value)
						if value == true then
							profile.osCooldownDirection = "left"
						else
							profile.osCooldownDirection = "right"
						end
						for _, cell in ipairs(frame.cells) do
							for _, bar in ipairs(cell.bars) do
								LIBBars:SetOneShotAnimationDirection(bar, profile.osCooldownDirection, 1)
							end
						end
						
						--handle mergedcell
						for _, bar in ipairs(frame.mergedcell.bars) do
							LIBBars:SetOneShotAnimationDirection(bar, profile.osCooldownDirection, 1)
						end
					end,
				},
				spacer2 = {
					type = "description",
					name = "",
					order = 27,
					width = "full",
				},
				osFGColor = {
					type = "color",
					hasAlpha = true,
					order = 30,
					name = L["Color"],
					width = "normal",
					disabled = profile.osEnabled ~= true,
					get = function(info) return
						profile.osFGColor.r,
						profile.osFGColor.g,
						profile.osFGColor.b,
						profile.osFGColor.a
					end,
					set = function(info, r, g, b, a)
						profile.osFGColor.r = r
						profile.osFGColor.g = g
						profile.osFGColor.b = b
						profile.osFGColor.a = a
							
						for _, cell in ipairs(frame.cells) do
							for _,bar in ipairs(cell.bars) do
								LIBBars:SetOneShotTextureColor(bar,
									profile.osFGColor.r,
									profile.osFGColor.g,
									profile.osFGColor.b,
									profile.osFGColor.a)
							end
						end
						
						--handle mergedcell
						for _, bar in ipairs(frame.mergedcell.bars) do
							LIBBars:SetOneShotTextureColor(bar,
								profile.osFGColor.r,
								profile.osFGColor.g,
								profile.osFGColor.b,
								profile.osFGColor.a)
						end
					end,
				},
			},
		},
	}
	return options
end

function mod:OnViewNameChanged(view, old, new) --OPTIONAL
	local frame = view.frame
	local mergednameplate = frame.mergedcell.nameplate
	mergednameplate.text:SetText(view.name)
end

function mod:OnEnable() --REQUIRED
	--add any code here that needs to run whenever Hermes enables/disables the UI plugin
end

function mod:OnDisable() --REQUIRED
	--add any code here that needs to run whenever Hermes enables/disables the UI plugin
end

function mod:OnInitialize() --REQUIRED
	--be default, do not enable this module
	self:SetEnabledState(false)
	
	self:CreateFramePool()
	self:CreateCellPool()
	self:SetupToolTipFonts()
end

function mod:UpgradeProfile(profile)
	--do db upgrades
	local defaults = self:GetViewDefaults()
	if profile.barBGCCU == nil then
		profile.barBGColorU = _deepcopy(defaults.barBGColorU)
	end
	if profile.barBGCCU == nil then
		profile.barBGCCU = defaults.barBGCCU
	end
	if profile.osEnabled == nil then
		profile.osEnabled = defaults.osEnabled
	end
	if profile.osCooldownStyle == nil then
		profile.osCooldownStyle = defaults.osCooldownStyle
	end
	if profile.osCooldownDirection == nil then
		profile.osCooldownDirection = defaults.osCooldownDirection
	end
	if profile.osFGColor == nil then
		profile.osFGColor = _deepcopy(defaults.osFGColor)
	end
	if profile.barShowPlayerName == nil then
		profile.barShowPlayerName = defaults.barShowPlayerName
	end
	if profile.barShowSpellName == nil then
		profile.barShowSpellName = defaults.barShowSpellName
	end
	if profile.barShowTime == nil then
		profile.barShowTime = defaults.barShowTime
	end
	if profile.npShowLabel == nil then
		profile.npShowLabel = defaults.npShowLabel
	end
	wipe(defaults)
end

function mod:AcquireView(view) --REQUIRED
	local profile = view.profile
	self:UpgradeProfile(profile)
	
	local frame = self:FetchFrame(profile)
	view.frame = frame
	frame.view = view
	
	--needs to be done after frame is initialized
	frame.mergedcell = self:FetchCell()
	self:InitializeCell(frame, frame.mergedcell, nil, 1)
	
	--now do some more init stuff
	self:RestoreFramePosition(frame)
	self:UpdateFrameResizerPosition(frame)
	self:LockFrame(frame)
	self:EnableTooltip(frame)
	
	--now draw everything
	self:PositionCells(frame)
	self:SetFrameToVirtualSize(frame)
	
	return frame
end

function mod:ReleaseView(view) --REQUIRED
	self:RecycleFrame(view.frame)
end

function mod:EnableView(view) --REQUIRED
	local frame = view.frame
	frame:Show()
end

function mod:DisableView(view) --REQUIRED
	local frame = view.frame
	frame:Hide()
end

function mod:OnLibSharedMediaUpdate(view, mediatype, key) --OPTIONAL
	--update all the cells in the container
	if mediatype == "statusbar" or mediatype == "font" then
		local frame = view.frame
		for _, cell in ipairs(frame.cells) do
			self:UpdateNameplateVisuals(cell.nameplate)
			for _, bar in ipairs(cell.bars) do
				self:SetSpellBarStyle(bar)
			end
		end
		
		--handle merged cell
		self:UpdateNameplateVisuals(frame.mergedcell.nameplate, 1)
		for _, bar in ipairs(frame.mergedcell.bars) do
			self:SetSpellBarStyle(bar)
		end
		
	end
end

function mod:OnAbilitySortChanged(view) --OPTIONAL
	local frame = view.frame
	self:SortCells(frame)
	self:PositionCells(frame)
	
	self:SortBars(frame.mergedcell)
	self:PositionSpellBars(frame.mergedcell)
end

function mod:OnInstanceSortChanged(view, ability) --OPTIONAL

end

function mod:OnAbilityAdded(view, ability) --OPTIONAL
	local frame = view.frame
	local cell = self:FetchCell()
	self:InitializeCell(frame, cell, ability, nil) --cell will get associated with the instance
	self:SortBars(frame.mergedcell)
	self:SortCells(frame)
	self:SetCellVisibility(cell)
	self:PositionCells(frame)
	self:SetFrameToVirtualSize(frame)
end

function mod:OnAbilityRemoved(view, ability) --OPTIONAL
	--locate the frame and cell for the ability
	local frame = view.frame
	local cell = self:GetCellForAbility(frame, ability) --this will need to be addressed if viewing merged
	
	self:RecycleCell(frame, cell)
	self:SortBars(frame.mergedcell)
	self:SortCells(frame)
	self:PositionCells(frame)
	self:SetFrameToVirtualSize(frame)
end

function mod:OnInstanceAdded(view, ability, instance) --OPTIONAL
	local frame = view.frame
	
	------------------------------------------
	--handle the merged cell
	------------------------------------------
	local mergedbar = nil
	for _, b in ipairs(frame.mergedcell.bars) do
		if not b.instance then
			--this one's available
			mergedbar = b
			break
		end
	end
	
	if not mergedbar then
		--grab a fresh one
		mergedbar = self:AcquireSpellBar(frame.mergedcell)
	end
	
	self:InitializeSpellBarInstance(mergedbar, instance)
	self:SortBars(frame.mergedcell)
	self:PositionSpellBars(frame.mergedcell)
	
	------------------------------------------
	--now handle the regular cells
	------------------------------------------
	local cell = mod:GetCellForAbility(frame, ability)
	
	--Handle bars
	local bar = nil
	for _, b in ipairs(cell.bars) do
		if not b.instance then
			--this one's available
			bar = b
			break
		end
	end
	
	if not bar then
		--grab a fresh one
		bar = self:AcquireSpellBar(cell)
	end

	self:InitializeSpellBarInstance(bar, instance)
	self:SortBars(cell)
	self:PositionSpellBars(cell)
	
	
	--if overall cell visibility changed, then reposition cells
	if self:SetCellVisibility(cell) == true then
		self:PositionCells(frame)
	end
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
end

function mod:OnInstanceRemoved(view, ability, instance) --OPTIONAL
	local frame = view.frame
	
	------------------------------------------
	--handle the merged cell
	------------------------------------------
	local mergedbar = self:GetBarForInstance(frame.mergedcell, instance)
	mergedbar.instance = nil
	self:SetSpellBarStyle(mergedbar)
	self:ReleaseExtraBars(frame.mergedcell)
	self:SortBars(frame.mergedcell)
	self:PositionSpellBars(frame.mergedcell)
	
	------------------------------------------
	--handle the regular cell
	------------------------------------------
	local cell = mod:GetCellForAbility(frame, ability)
	local bar = self:GetBarForInstance(cell, instance)
	bar.instance = nil
	self:SetSpellBarStyle(bar)
	self:ReleaseExtraBars(cell)
	self:SortBars(cell)
	self:PositionSpellBars(cell)
	
	--if overall cell visibility changed, then reposition cells
	if self:SetCellVisibility(cell) == true then
		self:PositionCells(frame)
	end
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
end

function mod:OnInstanceStartCooldown(view, ability, instance) --OPTIONAL
	local frame = view.frame

	------------------------------------------
	--handle the merged cell
	------------------------------------------
	local mergedbar = self:GetBarForInstance(frame.mergedcell, instance)
	self:SortBars(frame.mergedcell)
	self:SetSpellBarStyle(mergedbar)
	self:PositionSpellBars(frame.mergedcell)
	
	--Never saw this until now, but if a window is hidden the OnEvent events queue up and don't fire
	--until it's shown, that's why the profile check. _isBarNew is there to ensure we don't fire the
	--animation off for a brand new instance detection
	if frame.profile.osEnabled == true then
		--see if there is a "duration" metadata value
		local metadata = Hermes:GetAbilityMetaDataValue(ability.id, "duration") or Hermes:GetAbilityMetaDataValue(ability.id, "2ndcooldown") --legacy treck support
		if metadata and frame.profile.merged == true and not _isBarNew(mergedbar) then
			LIBBars:StartOneShotAnimation(mergedbar, metadata, frame.profile.barShowTime)
		end
	end
	
	self:UpdateSpellBarAnimations(mergedbar)
	
	------------------------------------------
	--handle the regular cell
	------------------------------------------
	local cell = mod:GetCellForAbility(frame, ability)
	local bar = self:GetBarForInstance(cell, instance)
	self:SortBars(cell)	
	self:SetSpellBarStyle(bar)
	self:PositionSpellBars(cell)
	
	if frame.profile.osEnabled == true then
		--see if there is a "duration" metadata value
		local metadata = Hermes:GetAbilityMetaDataValue(ability.id, "duration") or Hermes:GetAbilityMetaDataValue(ability.id, "2ndcooldown") --legacy treck support
		if metadata and frame.profile.merged == false  and not _isBarNew(bar) then
			LIBBars:StartOneShotAnimation(bar, metadata, frame.profile.barShowTime)
		end
	end
	
	self:UpdateSpellBarAnimations(bar)
	
	--if overall cell visibility changed, then reposition cells
	if self:SetCellVisibility(cell) == true then
		self:PositionCells(frame)
	end
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
end

function mod:OnInstanceUpdateCooldown(view, ability, instance) --OPTIONAL
	local frame = view.frame
	
	------------------------------------------
	--handle the merged cell
	------------------------------------------
	local mergedbar = self:GetBarForInstance(frame.mergedcell, instance)
	self:UpdateSpellBarAnimations(mergedbar)
	
	------------------------------------------
	--handle the regular cell
	------------------------------------------
	local cell = mod:GetCellForAbility(frame, ability)
	local bar = self:GetBarForInstance(cell, instance)
	self:UpdateSpellBarAnimations(bar)
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
end

function mod:OnInstanceStopCooldown(view, ability, instance) --OPTIONAL
	local frame = view.frame
	
	------------------------------------------
	--handle the merged cell
	------------------------------------------
	local mergedbar = self:GetBarForInstance(frame.mergedcell, instance)
	self:UpdateSpellBarAnimations(mergedbar)
	self:SetSpellBarStyle(mergedbar)
	self:SortBars(frame.mergedcell)
	self:PositionSpellBars(frame.mergedcell)
	
	------------------------------------------
	--handle the regular cell
	------------------------------------------
	local cell = mod:GetCellForAbility(frame, ability)
	local bar = self:GetBarForInstance(cell, instance)
	self:UpdateSpellBarAnimations(bar)
	self:SetSpellBarStyle(bar)
	self:SortBars(cell)	
	self:PositionSpellBars(cell)
	
	--if overall cell visibility changed, then reposition cells
	if self:SetCellVisibility(cell) == true then
		self:PositionCells(frame)
	end
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
end

function mod:OnInstanceAvailabilityChanged(view, ability, instance) --OPTIONAL
	local frame = view.frame
	
	------------------------------------------
	--handle the merged cell
	------------------------------------------
	local mergedbar = self:GetBarForInstance(frame.mergedcell, instance)
	self:SortBars(frame.mergedcell)	
	self:SetSpellBarStyle(mergedbar)
	self:PositionSpellBars(frame.mergedcell)
	
	------------------------------------------
	--handle the regular cell
	------------------------------------------
	local cell = mod:GetCellForAbility(frame, ability)
	local bar = self:GetBarForInstance(cell, instance)
	self:SortBars(cell)	
	self:SetSpellBarStyle(bar)
	self:PositionSpellBars(cell)
	
	--if overall cell visibility changed, then reposition cells
	if self:SetCellVisibility(cell) == true then
		self:PositionCells(frame)
	end
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
end

function mod:OnAbilityAvailableSendersChanged(view, ability) --OPTIONAL
	local frame = view.frame
	local cell = mod:GetCellForAbility(frame, ability)
	
	--self:SortBars(frame.mergedcell)
	--self:PositionSpellBars(frame.mergedcell)
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
end

function mod:OnAbilityTotalSendersChanged(view, ability) --OPTIONAL
	local frame = view.frame
	local cell = mod:GetCellForAbility(frame, ability)
	
	--I may not need to do anything at all because OnInstanceAvailabilityChanged will fire which covers the same need
	--self:SortBars(frame.mergedcell)
	--self:PositionSpellBars(frame.mergedcell)
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
end

