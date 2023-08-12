local VIEW_NAME = "GridButtons"

local Hermes = LibStub("AceAddon-3.0"):GetAddon("Hermes")
local UI = LibStub("AceAddon-3.0"):GetAddon("Hermes-UI")
local L = LibStub('AceLocale-3.0'):GetLocale('Hermes-UI')
local ViewManager = UI:GetModule("ViewManager")
local LBF  = LibStub("LibButtonFacade",true)
local LBFName = "Hermes-UI-"..VIEW_NAME
local mod = ViewManager:NewModule(VIEW_NAME)

local function LBFRegisterCallback(arg, skin, gloss, backdrop, viewName, button, colors)
	if viewName then
		local view, profile = ViewManager:GetViewTablesFromName(viewName)
		if view and profile and view.name == viewName then
			local frame = view.frame
			frame.profile.lbf.skin = skin
			frame.profile.lbf.gloss = gloss
			frame.profile.lbf.backdrop = backdrop
			frame.profile.lbf.colors = colors
			mod:UpdateButtonBorders(frame, nil)
		end
	end
end

-----------------------------------------------------------------------
-- LOCALS
-----------------------------------------------------------------------
local FRAMEPOOL = nil
local CELLPOOL = nil
local FRAME_MINWIDTH = 250
local FRAME_MINHEIGHT = 150
local ICONSIZE = 36 --it's very important that this is actually 36, otherwise you start having some challenges with LBF
local RESIZER_SIZE = 20
local UNIQUE_CELL_COUNT = 0
local UNIQUE_FRAME_COUNT = 0
local VERTEX_COLOR_UNAVAILABLE = {0.5, 0.5, 0.5, 1.0}
local IMAGE_RESIZE = "Interface\\Addons\\Hermes-UI\\Resize.tga"
local ICON_STATUS_NOTREADY = "Interface\\RAIDFRAME\\ReadyCheck-NotReady.blp"
local ICON_STATUS_READY = "Interface\\RAIDFRAME\\ReadyCheck-Ready.blp"
local TOOLTIP_HOVER_THROTTLE = 0.1

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
	CELLPOOL:SetWidth(ICONSIZE)
	CELLPOOL:SetHeight(ICONSIZE)
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
	
	--cleanup the merged cell
	local mergedcell = frame.mergedcell
	if LBF then
		LBF:Group(LBFName, frame.view.name):RemoveButton(mergedcell.button)
	end

	CooldownFrame_SetTimer(mergedcell.button.cooldown, 0, 0, 1)
	
	mergedcell:Hide()
	mergedcell:ClearAllPoints()

	mergedcell.button.icon:SetTexture("")
	mergedcell.button.icon:SetDesaturated(true)
	
	while #frame.cells > 0 do
		self:RecycleCell(frame, frame.cells[1])
	end

	wipe(frame.cells)
	
	if LBF then
		local group = LBF:Group(LBFName, frame.view.name)
		group:Delete()
	end
	
	tinsert(FRAMEPOOL.Frames, frame)
	frame:Hide()
	frame:SetParent(FRAMEPOOL)
	frame:ClearAllPoints()
	frame.VirtualWidth = FRAME_MINWIDTH
	frame.VirtualHeight = FRAME_MINHEIGHT
end

function mod:InitializeFrame(frame, profile)
	frame.timer = 0
	frame.profile = profile
	frame:SetParent(UIParent)
	frame:SetScale(profile.scale)
	frame:SetMinResize(ICONSIZE, ICONSIZE)
	self:RestoreFramePosition(frame)
	self:UpdateFrameResizerPosition(frame)
	self:LockFrame(frame)
	frame.mergedcell.button.icon:SetTexture(profile.mergedicon)
	frame:SetScript("OnUpdate", OnFrameUpdate) --enable the tooltip
end

function mod:UpdateButtonBorders(frame, cell)
	if(cell) then
		--if(cell.ability.class and cell.ability.class ~= "ANY") then
			local c = Hermes:GetClassColorRGB(cell.ability.class)
			if LBF then
				--backup the original color if not already exists
				if(not cell.button.lbf_nvcd) then
					cell.button.lbf_nvcd = {}
					cell.button.lbf_nvcd.r, cell.button.lbf_nvcd.g, cell.button.lbf_nvcd.b, cell.button.lbf_nvcd.a = LBF:GetNormalVertexColor(cell.button)
				end
					
				if(frame.profile.coloredBorders == true) then
					LBF:SetNormalVertexColor(cell.button, c.r, c.g, c.b, c.a)
				else
					LBF:SetNormalVertexColor(cell.button,
						cell.button.lbf_nvcd.r,
						cell.button.lbf_nvcd.g,
						cell.button.lbf_nvcd.b,
						cell.button.lbf_nvcd.a)
				end
			else
				if(frame.profile.coloredBorders == true) then
					cell.button.normaltexture:SetVertexColor(c.r, c.g, c.b, c.a)
				else
					cell.button.normaltexture:SetVertexColor(
						cell.button.nvcd.r,
						cell.button.nvcd.g,
						cell.button.nvcd.b,
						cell.button.nvcd.a)
				end
			end
		--end
	else
		for _, c in ipairs(frame.cells) do
			self:UpdateButtonBorders(frame, c)
		end
	end
end

function mod:FetchFrame(profile)
	--get cached or new container
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
	frame.mergedcell = self:CreateMergedCell(frame)
	
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
	
	if(width <= (ICONSIZE + RESIZER_SIZE / 3)) then
		width = ICONSIZE + (RESIZER_SIZE / 3) --always make sure the resizer is clickable
	end
	
	if(height <= (ICONSIZE + RESIZER_SIZE / 3)) then
		height = ICONSIZE + (RESIZER_SIZE / 3) --always make sure the resizer is clickable
	end

	frame.VirtualWidth = width
	frame.VirtualHeight = height
end

function mod:GetCellSize(frame)
	return ICONSIZE + frame.profile.padding, ICONSIZE + frame.profile.padding, ICONSIZE, ICONSIZE
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
function mod:RecycleCell(frame, cell)
	--LBF SUPPORT
	if LBF then
		LBF:Group(LBFName, frame.view.name):RemoveButton(cell.button)
	end
	
	--kill any animations if it's still running, we don't want it to popup on a cell that got restored from this one
	--TODO: This isn't working and I can't figure it out, moving on.
	CooldownFrame_SetTimer(cell.button.cooldown, 0, 0, 1)
	
	_deleteFromIndexedTable(frame.cells, cell)
	tinsert(CELLPOOL.Cells, cell)
	
	---------------------------------------------------------------
	-- CELL
	---------------------------------------------------------------
	cell.hide = true
	cell:Hide()
	cell:ClearAllPoints()
	cell:SetParent(CELLPOOL)
	cell.ability = nil
	cell.frame = nil

	---------------------------------------------------------------
	-- CELL.BUTTON
	---------------------------------------------------------------
	cell.button.icon:SetTexture("")
	cell.button.icon:SetDesaturated(true)
end

function mod:InitializeCell(frame, cell, ability)
	tinsert(frame.cells, cell)
	cell.ability = ability
	cell.button.icon:SetTexture(ability.icon)

	--configure cell
	cell.frame = frame
	cell:SetParent(frame)
	cell:ClearAllPoints()
	
	self:UpdateCellStyle(cell)
	
	--it's really important that we set a point, and a width and height BEFORE we skin this button with buttonfacade
	--if we don't do this, then the size of the buttons gets fairly well jacked up and in weird states. There
	--are a couple other places where I do this, such as the CELLPOOL frame. This took hours of troubleshooting to figure out
	--cell:SetPoint("CENTER", 0, 0)
	--cell:SetWidth(ICONSIZE)
	--cell:SetHeight(ICONSIZE)
	
	--LBF SUPPORT
	if LBF then
		LBF:Group(LBFName, frame.view.name):AddButton(cell.button)
	else
		--we don't want to see the normal texture (which acts like a border for a checkbox) if we don't have button facade running)
		--hide doesn' work because once we click the button it'll show again, but we can clear all the points so it won't show
		cell.button.normaltexture:ClearAllPoints()
		cell.button.normaltexture:Hide()
	end

	self:UpdateButtonBorders(frame, cell)
end

function mod:CreateMergedCell(frame)
	--create
	local cell = CreateFrame("Frame", nil, nil)
	cell.frame = frame
	cell:Hide()
	cell:EnableMouse(false)
	cell:SetMovable(true)
	cell:SetResizable(false)
	cell:SetScript("OnHide", function() cell:StopMovingOrSizing() end) --this is a precautionary measure to HOPEFULLY avoid any frames stuck to cursor issues while dragging if the frame gets hidden while dragging it (due to combat events)
	cell:SetToplevel(true)
	cell:SetUserPlaced(nil)
	cell:RegisterForDrag("LeftButton");
	cell:SetParent(frame)
	
	cell.button = CreateFrame("Button", "Hermes-UI-"..VIEW_NAME.."MergedButton"..tostring(UNIQUE_FRAME_COUNT), cell, "ActionButtonTemplate")
	cell.button.icon = _G[cell.button:GetName().."Icon"]
	cell.button.flash = _G[cell.button:GetName().."Flash"]
	cell.button.count = _G[cell.button:GetName().."Count"]
	cell.button.name = _G[cell.button:GetName().."Name"]
	cell.button.border = _G[cell.button:GetName().."Border"]
	cell.button.cooldown = _G[cell.button:GetName().."Cooldown"]
	cell.button.normaltexture = _G[cell.button:GetName().."NormalTexture"]
	cell.button.pushedtexture = _G[cell.button:GetName().."PushedTexture"]
	cell.button.highlighttexture = _G[cell.button:GetName().."HighlightTexture"]
	cell.button.checkedtexture = _G[cell.button:GetName().."CheckedTexture"]
	cell.button.nvcd = {}
	cell.button.nvcd.r, cell.button.nvcd.g, cell.button.nvcd.b, cell.button.nvcd.a = cell.button.normaltexture:GetVertexColor()
	cell.button:EnableMouse(false)
	cell.button:SetMovable(true)
	cell.button:SetResizable(false)
	cell.button:RegisterForClicks("AnyUp")
	cell.button:SetMotionScriptsWhileDisabled(true)
	cell.button:SetToplevel(true)
	cell.button:SetUserPlaced(nil)
	cell.button:SetAllPoints(cell) --set all points to parent frame
	
	--init
	cell.button.icon:SetTexture("")

	--LBF SUPPORT
	if not LBF then
		--we don't want to see the normal texture (which acts like a border for a checkbox) if we don't have button facade running)
		--hide doesn't work because once we click the button it'll show again, but we can clear all the points so it won't show
		cell.button.normaltexture:ClearAllPoints()
		cell.button.normaltexture:Hide()
	end
	
	return cell
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

	---------------------------------------------------------------
	-- CELL.BUTTON
	---------------------------------------------------------------
	cell.button = CreateFrame("Button", "Hermes-UI-"..VIEW_NAME.."Button"..tostring(UNIQUE_CELL_COUNT), cell, "ActionButtonTemplate")
	cell.button.icon = _G[cell.button:GetName().."Icon"]
	cell.button.flash = _G[cell.button:GetName().."Flash"]
	cell.button.count = _G[cell.button:GetName().."Count"]
	cell.button.name = _G[cell.button:GetName().."Name"]
	cell.button.border = _G[cell.button:GetName().."Border"]
	cell.button.cooldown = _G[cell.button:GetName().."Cooldown"]
	cell.button.normaltexture = _G[cell.button:GetName().."NormalTexture"]
	cell.button.pushedtexture = _G[cell.button:GetName().."PushedTexture"]
	cell.button.highlighttexture = _G[cell.button:GetName().."HighlightTexture"]
	cell.button.checkedtexture = _G[cell.button:GetName().."CheckedTexture"]
	cell.button.nvcd = {}
	cell.button.nvcd.r, cell.button.nvcd.g, cell.button.nvcd.b, cell.button.nvcd.a = cell.button.normaltexture:GetVertexColor()
	cell.button:EnableMouse(false)
	cell.button:SetMovable(true)
	cell.button:SetResizable(false)
	cell.button:RegisterForClicks("AnyUp")
	cell.button:SetMotionScriptsWhileDisabled(true)
	cell.button:SetToplevel(true)
	cell.button:SetUserPlaced(nil)
	cell.button:SetAllPoints(cell) --set all points to parent frame
	
	return cell
end

function mod:UpdateCellStyle(cell)
	local min_time, total, oncooldown, available, unavailable = ViewManager:GetAbilityStats(cell.frame.view, cell.ability)
	
	if total == 0 then
		self:UpdateCellStyleNoSenders(cell)
	else
		if available > 0 then
			self:UpdateCellStyleAvailable(cell, min_time, available)
		else
			if oncooldown > 0 then
				self:UpdateCellStyleOnCooldown(cell, min_time, available)
			else
				self:UpdateCellStyleUnavailable(cell)
			end
		end
	end
end

function mod:UpdateCellStyleAvailable(cell, min_time, available)
	--style
	cell.button.icon:SetDesaturated(false)
	cell.button.icon:SetVertexColor(1, 1, 1, 1)
		
	--properties
	cell.button.count:SetText(tostring(available))
		
	CooldownFrame_SetTimer(cell.button.cooldown, 0, 0, 0) --stop cooldown if it's running
end

function mod:UpdateCellStyleOnCooldown(cell, min_time, available)
	--style
	cell.button.count:SetText(nil)
	cell.button.icon:SetDesaturated(false)
	cell.button.icon:SetVertexColor(1, 1, 1, 1)
	
	CooldownFrame_SetTimer(cell.button.cooldown, GetTime(), min_time, 1) --start/reset cooldown
end

function mod:UpdateCellStyleUnavailable(cell)
	local profile = cell.frame.profile
	--style
	cell.button.count:SetText(nil)
	cell.button.icon:SetDesaturated(false)
	cell.button.icon:SetVertexColor(
		profile.colorU.r,
		profile.colorU.g,
		profile.colorU.b,
		profile.colorU.a)
	
	CooldownFrame_SetTimer(cell.button.cooldown, 0, 0, 0) --stop cooldown if it's running
end

function mod:UpdateCellStyleNoSenders(cell)
	local profile = cell.frame.profile
	--style
	cell.button.count:SetText(nil)
	cell.button.icon:SetDesaturated(true)
	cell.button.icon:SetVertexColor(
		profile.colorNS.r,
		profile.colorNS.g,
		profile.colorNS.b,
		profile.colorNS.a)
	
	CooldownFrame_SetTimer(cell.button.cooldown, 0, 0, 0) --stop cooldown if it's running
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

-----------------------------------------------------------------------
-- TOOLTIP
-----------------------------------------------------------------------
function mod:ShouldRefreshTooltip(frame, cell)
	if ToolTip and ToolTip.cell and (ToolTip.cell == cell or ToolTip.cell == frame.mergedcell) then
		return 1
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
-- MERGED VIEW
-----------------------------------------------------------------------
local EMPTY_ABILITY_BORDER = { class = "ANY" }
function mod:UpdateMergedCellStyle(frame)
	--this method will be called for the following events:
	--	OnInstanceAdded
	--	OnInstanceRemoved
	--	OnInstanceStartCooldown
	--	OnInstanceStopCooldown
	--	OnInstanceAvailabilityChanged
	--	OnAbilityAvailableSendersChanged
	--	OnAbilityTotalSendersChanged
	local view = frame.view
	local m, t, c, a, u = ViewManager:GetTotalAbilityStats(view)
	
	local cell = frame.mergedcell
	
	if t == 0 then
		self:UpdateCellStyleNoSenders(cell)
	else
		if a > 0 then
			self:UpdateCellStyleAvailable(cell, m, a)
		else
			if c > 0 then
				self:UpdateCellStyleOnCooldown(cell, m, a)
			else
				self:UpdateCellStyleUnavailable(cell)
			end
		end
	end
	
	--this is a complete hack, but it's simple for now at least. I'm simulating an ability on the cell in order
	--to colorcode it based on the next available class. Not sure if I really want to do this though.
	
	
	local instances = frame.view.instances["all"]
	local ability = EMPTY_ABILITY_BORDER
	if instances then
		if #instances > 0 then
			ability = instances[1].ability
		end
	end
	frame.mergedcell.ability = ability --set the ability
	self:UpdateButtonBorders(frame, frame.mergedcell)
	frame.mergedcell.ability = nil --remove it
end

-----------------------------------------------------------------------
-- VIEW
-----------------------------------------------------------------------
function mod:GetViewDisplayName() --REQUIRED
	return "GridButtons"
end

function mod:GetViewDisplayDescription() --REQUIRED
	return L["GRIDBUTTONS_VIEW_DESCRIPTION"]
end

function mod:GetViewDefaults() --REQUIRED
	local defaults = {
		coloredBorders = true,
		locked = false,
		scale = 1,
		cellAnchor = "TOPLEFT",
		padding = 5,
		hideNoSender = false,
		merged = false,
		mergedicon = "Interface\\ICONS\\INV_Misc_QuestionMark",
		colorU = {r = 0.5, g = 0.5, b = 0.5, a = 1},
		colorNS = {r = 0.5, g = 0.5, b = 0.5, a = 0.75},
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
			order = 15,
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
				padding = {
					type = "range", min = 0, max = 100, step = 1,
					name = L["Padding"],
					width = "full",
					get = function(info) return profile.padding end,
					order = 10,
					set = function(info, value)
						profile.padding = value
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
			order = 20,
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
				merged = {
					type = "toggle",
					name = L["Merge Spells"],
					width = "full",
					get = function(info) return profile.merged end,
					order = 10,
					set = function(info, value)
						profile.merged = value
						self:SetCellVisibilityForAllCells(frame)
						self:PositionCells(frame)
						self:UpdateMergedCellStyle(frame)
						self:SetFrameToVirtualSize(frame)
						ViewManager:UpdateViewModuleTable()
					end,
				},
				mergedicon = {
					type = "input",
					name = L["Icon Texture"],
					width = "full",
					hidden = profile.merged == false,
					disabled = profile.merged == false,
					order = 15,
					get = function()
						return profile.mergedicon
					end,
					validate = function(info, value)
						--make sure value is entered
						local text = strtrim(value)
						if(string.len(text) == 0) then
							return "Value required"
						end
						
						return true
					end,
					set = function(info, value)
						--update profile
						profile.mergedicon = strtrim(value)
						frame.mergedcell.button.icon:SetTexture(profile.mergedicon)
					end,
				},
				icons = {
					type = "select",
					name = L["Select from loaded textures"],
					width = "full",
					order = 20,
					hidden = profile.merged == false,
					disabled = profile.merged == false,
					get = function()
						return nil
					end,
					values = function()
						local icons = {}
						for id, enabled in pairs(Hermes:GetInventoryList()) do
							local _, name, _, icon, _ = Hermes:GetInventoryDetail(id)
							icons[icon] = "|T"..icon..":0:0:0:0|t "..name
						end
						return icons
					end,
					set = function(info, icon)
						profile.mergedicon = icon
						frame.mergedcell.button.icon:SetTexture(profile.mergedicon)
					end,
				},
				
			},
		},
		color = {
			name = L["Color"],
			type = "group",
			inline = false,
			order = 25,
			args = {
				colorU = {
					type = "color",
					hasAlpha = true,
					order = 5,
					name = L["Vertex Color Unavailable"],
					width = "normal",
					get = function(info) return
						profile.colorU.r,
						profile.colorU.g,
						profile.colorU.b,
						profile.colorU.a
					end,
					set = function(info, r, g, b, a)
						profile.colorU.r = r
						profile.colorU.g = g
						profile.colorU.b = b
						profile.colorU.a = a
							
						for _, cell in ipairs(frame.cells) do
							self:UpdateCellStyle(cell)
						end
						
						--handle mergedcell
						self:UpdateCellStyle(frame.mergedcell)
					end,
				},
				colorNS = {
					type = "color",
					hasAlpha = true,
					order = 10,
					name = L["Vertex Color No Senders"],
					width = "normal",
					get = function(info) return
						profile.colorNS.r,
						profile.colorNS.g,
						profile.colorNS.b,
						profile.colorNS.a
					end,
					set = function(info, r, g, b, a)
						profile.colorNS.r = r
						profile.colorNS.g = g
						profile.colorNS.b = b
						profile.colorNS.a = a
							
						for _, cell in ipairs(frame.cells) do
							self:UpdateCellStyle(cell)
						end
						
						--handle mergedcell
						self:UpdateCellStyle(frame.mergedcell)
					end,
				},
			},
		},
	}
	
	--special handling for LBF
	if LBF then
		options.buttonfacade = {
			name = "ButtonFacade",
			type = "group",
			inline = false,
			order = 25,
			args = {
				skin = {
					type = "select",
					name = "Skin",
					width = "normal",
					get = function(info) return profile.lbf.skin end,
					order = 5,
					style = "dropdown",
					hidden = LBF:ListSkins() == nil, --Masque deprecated a few LBF methods, and this is one of them. If LBF exists, and ListSkins doesn't return proper value, then it means masque is running and not LBF
					set = function(info, value)
						profile.lbf.skin = value
						local group = LBF:Group(LBFName, view.name)
						--skin it
						group:Skin(
							profile.lbf.skin,
							profile.lbf.gloss,
							profile.lbf.backdrop,
							profile.lbf.colors)
						--reskinning kills the border colors, so redo that too
						self:UpdateButtonBorders(frame, nil)
					end,
					values = function()
						local values = LBF:ListSkins()
						if not values then
							--Masque is actually installed, not LBF
							return nil
						else
							--LBF is properly running, not Masque
							return values
						end
					end
				},
				coloredBorders = {
					type = "toggle",
					name = L["Class Colored Borders"],
					width = "full",
					get = function(info) return profile.coloredBorders end,
					order = 10,
					set = function(info, value)
						profile.coloredBorders = value
						self:UpdateMergedCellStyle(frame)
						self:UpdateButtonBorders(frame, nil)
					end,
				},
			},
		}
	end
	return options
end

function mod:OnViewNameChanged(view, old, new)
	if LBF then
		local frame = view.frame
		local profile = frame.profile
		--delete existing group
		LBF:Group(LBFName, old):Delete() --this unskins the buttons too
		--create new group
		local group = LBF:Group(LBFName, view.name)
		--skin it
		group:Skin(
			profile.lbf.skin,
			profile.lbf.gloss,
			profile.lbf.backdrop,
			profile.lbf.colors)
		--add buttons to it
		for _, cell in ipairs(frame.cells) do
			LBF:Group(LBFName, view.name):AddButton(cell.button)
			self:UpdateButtonBorders(frame, cell)
		end
		
		group:AddButton(frame.mergedcell.button)
	end
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
	
	if LBF then
		LBF:RegisterSkinCallback(LBFName, LBFRegisterCallback, nil)
	end
end

function mod:UpgradeProfile(profile)
	--do db upgrades
	local defaults = self:GetViewDefaults()
	if profile.colorU == nil then
		profile.colorU = _deepcopy(defaults.colorU)
	end
	if profile.colorNS== nil then
		profile.colorNS = _deepcopy(defaults.colorNS)
	end
	wipe(defaults)
end

function mod:AcquireView(view) --REQUIRED
	local profile = view.profile
	self:UpgradeProfile(profile)
	local frame = self:FetchFrame(profile)
	view.frame = frame
	frame.view = view
	
	--this has to be run after FetchFrame because the view isn't set yet
	self:UpdateMergedCellStyle(frame)
	
	if LBF then
		local group = LBF:Group(LBFName, view.name)
		if not profile.lbf then
			profile.lbf = { skin = "Blizzard", gloss = false, backdrop = false, colors = {} }
		end
		
		group:Skin(
			profile.lbf.skin,
			profile.lbf.gloss,
			profile.lbf.backdrop,
			profile.lbf.colors)
			
		--skin the merged cell
		group:AddButton(frame.mergedcell.button)
	end

	--now draw everything
	self:PositionCells(frame)
	
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

function mod:OnAbilitySortChanged(view) --OPTIONAL
	local frame = view.frame
	self:SortCells(frame)
	self:PositionCells(frame)
end

function mod:OnInstanceSortChanged(view, ability) --OPTIONAL
	local frame = view.frame
	local cell = mod:GetCellForAbility(frame, ability)
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
	
	--Note: Do I need to ever call UpdateMergedCellStyle here? I do not believe so
end

function mod:OnAbilityAdded(view, ability) --OPTIONAL
	local frame = view.frame
	local cell = self:FetchCell()
	
	self:InitializeCell(frame, cell, ability) --cell will get associated with the instance
	self:SortCells(frame)
	self:SetCellVisibility(cell)
	self:PositionCells(frame)
	self:SetFrameToVirtualSize(frame)
end

function mod:OnAbilityRemoved(view, ability) --OPTIONAL
	--locate the container and cell for the ability
	local frame = view.frame
	local cell = self:GetCellForAbility(frame, ability) --this will need to be addressed if viewing merged
	
	--recycle the cell
	self:RecycleCell(frame, cell)
	
	--sort the cells by profile sort order
	self:SortCells(frame)

	--update display
	self:PositionCells(frame)
	
	self:SetFrameToVirtualSize(frame)
end

function mod:OnInstanceAdded(view, ability, instance) --OPTIONAL
	local frame = view.frame
	local cell = mod:GetCellForAbility(frame, ability)
	
	if self:SetCellVisibility(cell) == true then
		self:PositionCells(frame)
	end
	
	self:UpdateCellStyle(cell)
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
	
	--update the mergedcell for any changes to instances
	self:UpdateMergedCellStyle(frame)
end

function mod:OnInstanceRemoved(view, ability, instance) --OPTIONAL
	local frame = view.frame
	local cell = mod:GetCellForAbility(frame, ability)
	
	if self:SetCellVisibility(cell) == true then
		self:PositionCells(frame)
	end
	
	self:UpdateCellStyle(cell)
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
	
	--update the mergedcell for any changes to instances
	self:UpdateMergedCellStyle(frame)
end

function mod:OnInstanceStartCooldown(view, ability, instance) --OPTIONAL
	local frame = view.frame
	local cell = mod:GetCellForAbility(frame, ability)
	
	if self:SetCellVisibility(cell) == true then
		self:PositionCells(frame)
	end
	
	self:UpdateCellStyle(cell)
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
	
	--update the mergedcell for any changes to instances
	self:UpdateMergedCellStyle(frame)
end

function mod:OnInstanceUpdateCooldown(view, ability, instance) --OPTIONAL
	local frame = view.frame
	local cell = mod:GetCellForAbility(frame, ability)
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
end

function mod:OnInstanceStopCooldown(view, ability, instance) --OPTIONAL
	local frame = view.frame
	local cell = mod:GetCellForAbility(frame, ability)
	
	if self:SetCellVisibility(cell) == true then
		self:PositionCells(frame)
	end
	
	self:UpdateCellStyle(cell)
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
	
	--update the mergedcell for any changes to instances
	self:UpdateMergedCellStyle(frame)
end

function mod:OnInstanceAvailabilityChanged(view, ability, instance) --OPTIONAL
	local frame = view.frame
	local cell = mod:GetCellForAbility(frame, ability)
	
	if self:SetCellVisibility(cell) == true then
		self:PositionCells(frame)
	end
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
	
	--update the mergedcell for any changes to instances
	self:UpdateMergedCellStyle(frame)
end

function mod:OnAbilityAvailableSendersChanged(view, ability) --OPTIONAL
	local frame = view.frame
	local cell = mod:GetCellForAbility(frame, ability)
	--first change the style as needed
	self:UpdateCellStyle(cell)
	
	if self:SetCellVisibility(cell) == true then
		self:PositionCells(frame)
	end
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
	
	--update the mergedcell for any changes to instances
	self:UpdateMergedCellStyle(frame)
end

function mod:OnAbilityTotalSendersChanged(view, ability) --OPTIONAL
	local frame = view.frame
	local cell = mod:GetCellForAbility(frame, ability)
	--first change the style as needed
	self:UpdateCellStyle(cell)
	if self:SetCellVisibility(cell) == true then
		self:PositionCells(frame)
	end
	
	if self:ShouldRefreshTooltip(frame, cell) then
		self:RefreshTooltip()
	end
	
	--update the mergedcell for any changes to instances
	self:UpdateMergedCellStyle(frame)
end

