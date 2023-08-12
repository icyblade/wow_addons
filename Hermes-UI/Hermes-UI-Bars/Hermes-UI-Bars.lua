local VIEW_NAME = "Bars"

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
local FRAME_HEIGHT = 18
local FRAME_WIDTH = 100
local UNIQUE_CELL_COUNT = 0
local UNIQUE_FRAME_COUNT = 0
local BAR_SPARK_WIDTH = 25
local BAR_SPARK_HEIGHT = 10
local STATUS_PADDING = 2
local ICON_OFFSET = 1
local ICON_STATUS_NOTREADY = "Interface\\RAIDFRAME\\ReadyCheck-NotReady.blp"
local ICON_STATUS_READY = "Interface\\RAIDFRAME\\ReadyCheck-Ready.blp"
local NEW_INSTANCE_THRESHOLD = 1 --catch when an instance going on cooldown should animate using 2ndcooldown metadata or not

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
	CELLPOOL:SetWidth(30)
	CELLPOOL:SetHeight(30)
	CELLPOOL:Hide()

	CELLPOOL:EnableMouse(false)
	CELLPOOL:SetMovable(false)
	CELLPOOL:SetToplevel(false)
	CELLPOOL.Cells = {}
end

-----------------------------------------------------------------------
-- FRAME
-----------------------------------------------------------------------
function mod:SetFrameSize(frame)
	local profile = frame.profile
	frame:SetWidth(FRAME_WIDTH)
	frame:SetHeight(FRAME_HEIGHT)
end

function mod:RestoreFramePosition(frame)				--sets the starting point for all window positions based on profile settings (if it exists)
	if(not frame.profile.x or not frame.profile.y) then
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "CENTER")
		frame.profile.x = frame:GetLeft()
		frame.profile.y = frame:GetTop()
	else
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT",
			frame.profile.x,
			frame.profile.y
		)
	end

	self:SetFrameSize(frame)
	frame:SetUserPlaced(nil)
end

function mod:RecycleFrame(frame)
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
end

function mod:InitializeFrame(frame, profile)
	frame.profile = profile
	frame:SetParent(UIParent)
	frame:SetScale(profile.scale)
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
	mod:SaveFramePosition(frame)
end

function mod:SaveFramePosition(frame)
	frame.profile.x = frame:GetLeft()
	frame.profile.y = frame:GetTop()
	frame:SetUserPlaced(false)
end

function mod:CreateFrame()
	UNIQUE_FRAME_COUNT = UNIQUE_FRAME_COUNT + 1
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide() --hide frame by default
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetResizable(false)
	frame:SetUserPlaced(false)
	frame:SetToplevel(false)
	frame:SetWidth(100)
	frame:SetHeight(FRAME_HEIGHT)
	frame:RegisterForDrag("LeftButton");
	frame:SetScript("OnDragStart", OnFrameDragStart)
	frame:SetScript("OnDragStop", OnFrameDragStop)
	frame:SetScript("OnHide", function() frame:StopMovingOrSizing() end) -- prevents stuck dragging
	
	frame.text = frame:CreateFontString(nil, "ARTWORK")
	frame.text:Hide()
	frame.text:SetFontObject(GameFontNormalSmall);
	frame.text:SetTextColor(0.9, 0.9, 0.9, 1)
	frame.text:SetText("")
	frame.text:SetWordWrap(false)
	frame.text:SetNonSpaceWrap(false)
	frame.text:SetJustifyH("CENTER");
	frame.text:SetJustifyV("CENTER");
	frame.text:SetAllPoints();
	
	frame.cells = {}
	frame.mergedcell = nil
	
	return frame
end

function mod:GetCellSize(cell)
	local frame = cell.frame
	local width, height
	local profile = frame.profile
	local num_bars = #cell.bars
	
	if profile.barLocation == "TOP" or profile.barLocation == "BOTTOM" then
		--vertical bars
		width = profile.barW
		--height = ((profile.barH + profile.barGap) * num_bars) + profile.barPadding
		height = (profile.barH + profile.barGap) * num_bars

		if profile.npUseNameplate == true then 
			height = height + profile.npH
		end
	else
		--horizontal bars
		width = (profile.barW + profile.barGap) * num_bars
		--height = profile.barH + profile.barPadding
		height = profile.barH

		if profile.npUseNameplate == true then 
			width = width + profile.npW
		end
	end

	return width, height
end

function mod:PositionCells(frame)
	local profile = frame.profile
	--this hides or shows cells as needed, and positions them
	local offset = 0
	for i, cell in ipairs(frame.cells) do
		if profile.merged == false and (profile.hideNoSender == false or (profile.hideNoSender == true and #cell.bars > 0)) then
			cell:ClearAllPoints()
			local width, height = self:GetCellSize(cell)
			
			--handle left/right anchor points
			if profile.barLocation == "TOP" or profile.barLocation == "BOTTOM" then
				cell:SetPoint("LEFT", frame, "LEFT", 0, 0)
			else
				if profile.barLocation == "LEFT" then
					cell:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
				else
					cell:SetPoint("LEFT", frame, "LEFT", 0, 0)
				end
			end
			
			--handle top/bottom anchor points
			if profile.growUp == true then
				if profile.locked == false then
					cell:SetPoint("BOTTOM", frame, "TOP", 0, offset)
				else
					cell:SetPoint("BOTTOM", frame, "BOTTOM", 0, offset)
				end
			else
				if profile.locked == false then
					cell:SetPoint("TOP", frame, "BOTTOM", 0, -offset)
				else
					cell:SetPoint("TOP", frame, "TOP", 0, -offset)
				end
			end
			
			cell:SetHeight(height)
			cell:SetWidth(width)
			self:PositionSpellBars(cell)
			cell:Show()
			offset = offset + (height + profile.barPadding)
		else
			cell:Hide()
		end
	end
	
	if profile.merged == true then
		local width, height = self:GetCellSize(frame.mergedcell)
		frame.mergedcell:ClearAllPoints()
		
		--handle left/right anchor points
		if profile.barLocation == "TOP" or profile.barLocation == "BOTTOM" then
			frame.mergedcell:SetPoint("LEFT", frame, "LEFT", 0, 0)
		else
			if profile.barLocation == "LEFT" then
				frame.mergedcell:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
			else
				frame.mergedcell:SetPoint("LEFT", frame, "LEFT", 0, 0)
			end
		end
		
		--handle top/bottom anchor points
		if profile.growUp == true then
			if profile.locked == false then
				frame.mergedcell:SetPoint("BOTTOM", frame, "TOP", 0, offset)
			else
				frame.mergedcell:SetPoint("BOTTOM", frame, "BOTTOM", 0, offset)
			end
		else
			if profile.locked == false then
				frame.mergedcell:SetPoint("TOP", frame, "BOTTOM", 0, -offset)
			else
				frame.mergedcell:SetPoint("TOP", frame, "TOP", 0, -offset)
			end
		end
		
		frame.mergedcell:SetHeight(height)
		frame.mergedcell:SetWidth(width)
		self:PositionSpellBars(frame.mergedcell)
		frame.mergedcell:Show()
	else
		frame.mergedcell:ClearAllPoints()
		frame.mergedcell:Hide()
	end
end

function mod:GetFramePosRelativeToAnchor(frame)
	return frame:GetLeft(), frame:GetTop()
end

function mod:SetFramePosRelativeToAnchor(frame, x, y)
	--this is a matter of setting the window topleft corner relative to the anchor
	local profile = frame.profile
	--just set x and y
	profile.x = x
	profile.y = y
	self:RestoreFramePosition(frame)
	self:PositionCells(frame)
end

function mod:LockFrame(frame)
	local profile = frame.profile
	if(profile.locked == true) then
		frame:SetBackdrop(nil)
		frame:SetBackdropColor(0, 0, 0, 0)
		frame:SetBackdropBorderColor(0, 0, 0, 0)
		frame.text:Hide();
		frame:EnableMouse(false)
	else
		frame:EnableMouse(true) --allow to click through the frame with mouse
		frame:SetBackdrop({
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = false,
			tileSize = 32,
			edgeSize = 10,
			insets = {
				left = 0,
				right = 0,
				top = 0,
				bottom = 0,
			}
		})
		frame:SetBackdropColor(0.8, 0.5, 0.5, 0.7)
		frame:SetBackdropBorderColor(0.8, 0.5, 0.5, 0.7)
		frame.text:Show();
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
	
	cell.backgroundTexture:SetTexture(0, 0, 0, 0)
								
	cell.nameplate = self:AcquireNameplateBar(cell, ability, ismerged)
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
	if profile.barLocation == "TOP" or profile.barLocation == "BOTTOM" then --vertical layout
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
	
	if available == true and cooldown == false then
		self:SetSpellBarStyleAvailable(bar)
		return
	end
	
	if available == true and cooldown == true then
		self:SetSpellBarStyleOnCooldown(bar)
		return
	end
	
	self:SetSpellBarStyleUnavailable(bar)
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
			for _, bar in ipairs(cell.bars) do
				bar:Show()
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
	if cell.frame.profile.barLocation == "TOP" or cell.frame.profile.barLocation == "BOTTOM" then
		self:PositionSpellBarsVertical(cell)
	else
		self:PositionSpellBarsHorizontal(cell)
	end
end

function mod:PositionSpellBarsVertical(cell)
	local profile = cell.frame.profile
	
	local height = profile.barH
	local width = profile.barW
	local bars_to_display = #cell.bars
	
	cell.nameplate:ClearAllPoints()
	
	--first position the nameplate
	if profile.npUseNameplate == true then 
		if profile.barLocation == "BOTTOM" then
			cell.nameplate:SetPoint("TOPLEFT", cell, "TOPLEFT", 0, 0)
		else
			cell.nameplate:SetPoint("BOTTOMLEFT", cell, "BOTTOMLEFT", 0, 0)
		end
		LIBBars:SetWidth(cell.nameplate, width, 1)
		LIBBars:SetHeight(cell.nameplate, profile.npH, 1)
		cell.nameplate:Show()
	else
		cell.nameplate:Hide()
	end

	local namePlateOffset = profile.npH
	if profile.npUseNameplate == false then
		namePlateOffset = 0
	end
	
	local count = 1
	for _, bar in ipairs(cell.bars) do
		local offsety, anchorTicTac, anchorNamePlate
		if profile.barLocation == "BOTTOM" then
			--offsety = (((( count - 1 ) * (height + profile.barGap)) * -1)) - namePlateOffset
			offsety = (((( count - 1 ) * height) * -1) - namePlateOffset) - (profile.barGap * count)
			anchorTicTac = "TOP"
			anchorNamePlate = "TOP"
		else
			anchorTicTac = "BOTTOM"
			anchorNamePlate = "BOTTOM"
			--offsety = ((( count - 1 ) * (height + profile.barGap))) + namePlateOffset
			offsety = ((( count - 1 ) * height) + namePlateOffset) + (profile.barGap * count)
		end

		bar:ClearAllPoints()
		bar:SetPoint(anchorTicTac, cell, anchorNamePlate, 0, offsety + 0) --TOP assignment
		bar:SetPoint("LEFT", cell, "LEFT", 0, 0) --LEFT offset
		LIBBars:SetWidth(bar, width, 1)
		LIBBars:SetHeight(bar, height, 1)
		bar:Show()
		count = count + 1
	end
end

function mod:PositionSpellBarsHorizontal(cell)
	local profile = cell.frame.profile
	
	local height = profile.barH
	local width = profile.barW
	local bars_to_display = #cell.bars
	
	cell.nameplate:ClearAllPoints()
	
	--first position the nameplate
	if profile.npUseNameplate == true then
		if(profile.barLocation == "RIGHT") then --name plate on left
			cell.nameplate:SetPoint("TOPLEFT", cell, "TOPLEFT", 0, 0)
		else --name plate on the right
			cell.nameplate:SetPoint("TOPRIGHT", cell, "TOPRIGHT", 0, 0)
		end
		LIBBars:SetWidth(cell.nameplate, profile.npW, 1)
		LIBBars:SetHeight(cell.nameplate, height, 1)
		cell.nameplate:Show()
	else
		cell.nameplate:Hide()
	end

	local namePlateOffset = profile.npW
	if profile.npUseNameplate == false then
		namePlateOffset = 0
	end
	
	local count = 1
	for _, bar in ipairs(cell.bars) do
		local offsetx, anchorTicTac, anchorNamePlate
		if(profile.barLocation == "RIGHT") then
			--name plate on left
			offsetx = ((( count - 1 ) * profile.barW) + namePlateOffset) + (profile.barGap * count)
			anchorTicTac = "LEFT"
			anchorNamePlate = "LEFT"
		else
			--name plate on right
			offsetx = (((( count - 1 ) * profile.barW) + namePlateOffset) + (profile.barGap * count)) * -1
			anchorTicTac = "RIGHT"
			anchorNamePlate = "RIGHT"
		end

		bar:ClearAllPoints()
		bar:SetPoint("TOP", cell, "TOP", 0, 0) --TOP
		bar:SetPoint(anchorTicTac, cell, anchorNamePlate, offsetx, 0) --LEFT
		LIBBars:SetWidth(bar, width, 1)
		LIBBars:SetHeight(bar, height, 1)
		bar:Show()
		count = count + 1
	end
end

-----------------------------------------------------------------------
-- VIEW
-----------------------------------------------------------------------
function mod:GetViewDisplayName() --REQUIRED
	return "Bars"
end

function mod:GetViewDisplayDescription() --REQUIRED
	return L["BARS_VIEW_DESCRIPTION"]
end

function mod:GetViewDefaults() --REQUIRED
	local defaults = {
		scale = 1,
		locked = false,
		merged = false,
		growUp = false,
		barLocation="BOTTOM", --BOTTOM, TOP, LEFT, RIGHT
		hideNoSender = true,
		--------------
		barFontSize = 12,
		barW = 150,
		barH = 14,
		barGap = 1,
		barPadding = 10,
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
				self:PositionCells(frame)
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
				growUp = {
					type = "toggle",
					name = L["Grow Up"],
					width = "full",
					get = function(info) return profile.growUp end,
					order = 5,
					set = function(info, value)
						profile.growUp = value
						self:SetFrameSize(frame)
						self:PositionCells(frame)
					end,
				},
				barLocation= {
					type = "select",
					name = L["Bar Location"],
					order = 10,
					style = "dropdown",
					width = "full",
					get = function(info) return profile.barLocation end,
					set = function(info, value)
						profile.barLocation = value
						self:SetFrameSize(frame)
						self:PositionCells(frame)
						ViewManager:UpdateViewModuleTable()
					end,
					values = {
						["LEFT"] = L["Left"],
						["RIGHT"] = L["Right"],
						["BOTTOM"] = L["Bottom"],
						["TOP"] = L["Top"],
					},
				},
				innerpadding = {
					type = "range",
					min = 0, max = 50, step = 1,
					name = L["Padding"],
					order = 15,
					width = "full",
					get = function(info) return profile.barPadding end,
					set = 
						function(info, value)
							profile.barPadding = value
							self:PositionCells(frame)
						end,
				},
				barGap = {
					type = "range",
					min = 0, max = 50, step = 1,
					name = L["Gap Between Bars"],
					width = "full",
					get = function(info) return profile.barGap end,
					order = 20,
					set = 
						function(info, value)
							profile.barGap = value
							self:PositionCells(frame)
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
						self:PositionCells(frame)
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
									if value < profile.barH + 1 then --force bar no never be less narrow than the height
										profile.barW = profile.barH + 1
									else
										profile.barW = value
									end
									self:SetFrameSize(frame)
									self:PositionCells(frame)
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
									if profile.barW <  profile.barH + 1 then  --force bar no never be less narrow than the height
										profile.barW = profile.barH + 1
									end
									if profile.barLocation == "LEFT" or profile.barLocation == "RIGHT" then
										if profile.npW < profile.barH + 1 then --force bar no never be less narrow than the height
											profile.npW = profile.barH + 1
										end
									end
									self:SetFrameSize(frame)
									self:PositionCells(frame)
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
								self:SetFrameSize(frame)
								self:PositionCells(frame)
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
							disabled = profile.barLocation == "TOP" or profile.barLocation == "BOTTOM",
							get = function(info) return profile.npW end,
							set = function(info, value)
								profile.npW = value
								if profile.barLocation == "LEFT" or profile.barLocation == "RIGHT" then
									if profile.npW < profile.barH + 1 then --force bar no never be less narrow than the height
										profile.npW = profile.barH + 1
									end
								end
								self:SetFrameSize(frame)
								self:PositionCells(frame)
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
							disabled = profile.barLocation == "LEFT" or profile.barLocation == "RIGHT",
							get = function(info) return profile.npH end,
							set = function(info, value)
								profile.npH = value
								if profile.barLocation == "LEFT" or profile.barLocation == "RIGHT" then
									if profile.npW <  profile.barH + 1 then  --force nameplate no never be less narrow than the height of the bar when bars are showing left/right
										profile.npW = profile.barH + 1
									end
								end
								self:SetFrameSize(frame)
								self:PositionCells(frame)
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
	frame.text:SetText(new)
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
end

function mod:UpgradeProfile(profile)
	--do db upgrades
	--local defaults = self:GetViewDefaults()
	--wipe(defaults)
end

function mod:AcquireView(view) --REQUIRED
	local profile = view.profile
	self:UpgradeProfile(profile)
	
	local frame = self:FetchFrame(profile)
	view.frame = frame
	frame.view = view
	frame.text:SetText(view.name)
	
	--needs to be done after frame is initialized
	frame.mergedcell = self:FetchCell()
	self:InitializeCell(frame, frame.mergedcell, nil, 1)
	
	--now do some more init stuff
	self:RestoreFramePosition(frame)
	self:LockFrame(frame)
	
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
	self:PositionCells(frame)
end

function mod:OnInstanceSortChanged(view, ability) --OPTIONAL

end

function mod:OnAbilityAdded(view, ability) --OPTIONAL
	local frame = view.frame
	local cell = self:FetchCell()
	self:InitializeCell(frame, cell, ability, nil) --cell will get associated with the instance
	self:SortBars(frame.mergedcell)
	self:SortCells(frame)
	self:PositionCells(frame)
end

function mod:OnAbilityRemoved(view, ability) --OPTIONAL
	--locate the frame and cell for the ability
	local frame = view.frame
	local cell = self:GetCellForAbility(frame, ability) --this will need to be addressed if viewing merged
	
	self:RecycleCell(frame, cell)
	self:SortBars(frame.mergedcell)
	self:SortCells(frame)
	self:PositionCells(frame)
end

function mod:OnInstanceAdded(view, ability, instance) --OPTIONAL
	local frame = view.frame
	
	------------------------------------------
	--handle the merged cell
	------------------------------------------
	local mergedbar = self:AcquireSpellBar(frame.mergedcell)
	self:InitializeSpellBarInstance(mergedbar, instance)
	self:SortBars(frame.mergedcell)
	
	------------------------------------------
	--now handle the regular cells
	------------------------------------------
	local cell = mod:GetCellForAbility(frame, ability)
	
	--Handle bars
	local bar = self:AcquireSpellBar(cell)
	self:InitializeSpellBarInstance(bar, instance)
	self:SortBars(cell)
	
	--if overall cell visibility changed, then reposition cells
	self:PositionCells(frame)
end

function mod:OnInstanceRemoved(view, ability, instance) --OPTIONAL
	local frame = view.frame
	
	------------------------------------------
	--handle the merged cell
	------------------------------------------
	local mergedbar = self:GetBarForInstance(frame.mergedcell, instance)
	mergedbar.instance = nil
	
	self:ReleaseBar(mergedbar)
	_deleteFromIndexedTable(frame.mergedcell.bars, mergedbar)
	
	------------------------------------------
	--handle the regular cell
	------------------------------------------
	local cell = mod:GetCellForAbility(frame, ability)
	local bar = self:GetBarForInstance(cell, instance)
	bar.instance = nil
	
	self:ReleaseBar(bar)
	_deleteFromIndexedTable(cell.bars, bar)
	
	--if overall cell visibility changed, then reposition cells
	self:PositionCells(frame)
end

function mod:OnInstanceStartCooldown(view, ability, instance) --OPTIONAL
	local frame = view.frame

	------------------------------------------
	--handle the merged cell
	------------------------------------------
	local mergedbar = self:GetBarForInstance(frame.mergedcell, instance)
	self:SortBars(frame.mergedcell)
	self:SetSpellBarStyle(mergedbar)
	
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
	
	if frame.profile.osEnabled == true then
		--see if there is a "duration" metadata value
		local metadata = Hermes:GetAbilityMetaDataValue(ability.id, "duration") or Hermes:GetAbilityMetaDataValue(ability.id, "2ndcooldown") --legacy treck support
		if metadata and frame.profile.merged == false  and not _isBarNew(bar) then
			LIBBars:StartOneShotAnimation(bar, metadata, frame.profile.barShowTime)
		end
	end
	
	self:UpdateSpellBarAnimations(bar)
	
	--if overall cell visibility changed, then reposition cells
	self:PositionCells(frame)
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
	
	------------------------------------------
	--handle the regular cell
	------------------------------------------
	local cell = mod:GetCellForAbility(frame, ability)
	local bar = self:GetBarForInstance(cell, instance)
	self:UpdateSpellBarAnimations(bar)
	self:SetSpellBarStyle(bar)
	self:SortBars(cell)	
	
	--if overall cell visibility changed, then reposition cells
	self:PositionCells(frame)
end

function mod:OnInstanceAvailabilityChanged(view, ability, instance) --OPTIONAL
	local frame = view.frame
	
	------------------------------------------
	--handle the merged cell
	------------------------------------------
	local mergedbar = self:GetBarForInstance(frame.mergedcell, instance)
	self:SortBars(frame.mergedcell)	
	self:SetSpellBarStyle(mergedbar)
	
	------------------------------------------
	--handle the regular cell
	------------------------------------------
	local cell = mod:GetCellForAbility(frame, ability)
	local bar = self:GetBarForInstance(cell, instance)
	self:SortBars(cell)	
	self:SetSpellBarStyle(bar)
	
	--if overall cell visibility changed, then reposition cells
	self:PositionCells(frame)
end

function mod:OnAbilityAvailableSendersChanged(view, ability) --OPTIONAL
	--local frame = view.frame
	--local cell = mod:GetCellForAbility(frame, ability)
end

function mod:OnAbilityTotalSendersChanged(view, ability) --OPTIONAL
	--local frame = view.frame
	--local cell = mod:GetCellForAbility(frame, ability)
end

