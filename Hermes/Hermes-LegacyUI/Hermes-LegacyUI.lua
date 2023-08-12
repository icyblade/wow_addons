local Hermes = LibStub("AceAddon-3.0"):GetAddon("Hermes")
local MODNAME = "LegacyUI"
local LegacyUI = Hermes:NewModule(MODNAME, "AceEvent-3.0", "AceTimer-3.0")

local L = LibStub('AceLocale-3.0'):GetLocale('Hermes-LegacyUI')
local LIB_LibSharedMedia = LibStub("LibSharedMedia-3.0") or error("Required library LibSharedMedia-3.0 not found")
local LIB_AceConfigDialog = LibStub("AceConfigDialog-3.0")  or error("Required library AceConfigDialog-3.0 not found")
local LIB_AceConfigRegistry = LibStub("AceConfigRegistry-3.0") or error("Required library AceConfigRegistry-3.0 not found")

--LibButtonFacade support
local LBF  = LibStub("LibButtonFacade",true)
local LBFLegacyUI = {} 
LBFLegacyUI.Name = MODNAME

--ToolTip
local QTip	= LibStub("LibQTip-1.0")
local ToolTip = nil
local SpellIdFont = nil

--global to local performance improvements
local GetTime = GetTime
local format, floor = format, floor
local tinsert, tremove, pairs, ipairs, wipe, type, tonumber, sort, tostring = tinsert, tremove, pairs, ipairs, wipe, type, tonumber, sort, tostring

------------------------------------------------------------------
--OPTIONS / SETTINGS
------------------------------------------------------------------
--frames
local Containers = { }
local DefaultContainer = nil
local RecycledContainers = nil
local RecycledCells = nil
local RecycledBars = nil

local UNIQUE_CELL_COUNT = 1
local UNIQUE_FRAME_COUNT = 1
local LAYOUT_FRAME_MINWIDTH = 250
local LAYOUT_FRAME_MINHEIGHT = 150
local STATUS_PADDING = 2
local ICON_OFFSET = 1
local ICONSIZE_LARGE = 32
local RESIZER_SIZE = 20

--textures and colors
local ICON_STATUS_NOTREADY = "Interface\\RAIDFRAME\\ReadyCheck-NotReady.blp"
local ICON_STATUS_READY = "Interface\\RAIDFRAME\\ReadyCheck-Ready.blp"
local ICON_STATUS_UNKNOWN = "Interface\\RAIDFRAME\\ReadyCheck-Waiting.blp"
local IMAGE_RESIZE = "Interface\\Addons\\Hermes-LegacyUI\\Resize.tga"
local VertexColorUnavailable = {0.5, 0.5, 0.5, 1.0}
local VertexColorDoesntExist = {1.0, 1.0, 1.0, 0.5}
local BGCOLOR_DRAGDROP_DROPTARGET = {0, 0.75, 0, 0.5}
local BGCOLOR_DRAGDROP_NOTDROPTARGET = {0, 0, 0, 0.3}
local BAR_SPARK_WIDTH = 25
local BAR_SPARK_HEIGHT = 10
	
--drag and drop support
local DragHandler = nil

local CONTAINER_ONUPDATETHROTTLE = 0.1
--reference to profile table for this mod
local dbp = { }

-- helpers
local function strim (s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

local function FindTableIndex(tbl, item)
	for index, i in ipairs(tbl) do
		if(i == item) then
			return index
		end
	end

	return nil
end

local function MoveIndexedCell(tbl, item, newIndex)
	if not newIndex then error("nil index") end
	local oldIndex = FindTableIndex(tbl, item)
	if not oldIndex then error("failed to locate item") end
	if oldIndex == newIndex then return end
	
	--remove from old location
	tremove(tbl, oldIndex)
	
	--add to new location
	tinsert(tbl, newIndex, item)
end

local function DeleteFromIndexedTable(tbl, item)
	local index = FindTableIndex(tbl, item) 
	if not index then error("failed to locate item in table") end
	tremove(tbl, index)
end

local function deepcopy(object)
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

local function _round(num, idp)
	local mult = 10^(idp or 0)
	return floor(num * mult + 0.5) / mult
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

------------------------------------------------------------------
--DRAG AND DROP
------------------------------------------------------------------
function LegacyUI:GetRealCell(cell)
	if cell.IsDragPlaceHolder then
		return cell.realCell
	else
		return cell
	end
end

function LegacyUI:CreateDragPlaceHolderFrame(container)
	local dph = CreateFrame("Frame", nil, container)
	dph:Show()
	dph:SetAlpha(1)
	dph.texture = dph:CreateTexture(nil, "BACKGROUND")
	dph.texture:SetTexture(
		BGCOLOR_DRAGDROP_DROPTARGET[1],
		BGCOLOR_DRAGDROP_DROPTARGET[2],
		BGCOLOR_DRAGDROP_DROPTARGET[3],
		BGCOLOR_DRAGDROP_DROPTARGET[4])
	dph.texture:SetAllPoints()
		
	dph:SetMovable(true)
	dph:SetResizable(true)
	dph:SetToplevel(true)
	dph:SetUserPlaced(nil)
	
	dph.IsDragPlaceHolder = 1 --this bit gets checked when positoning cells and processing dragging.
	
	return dph
end

function LegacyUI:CreateDragHandler()
	if not DragHandler then
		DragHandler = CreateFrame("Frame")
		DragHandler.timer = 0
		DragHandler.frequency = 0.05
	end
end

local function SwapCellWithDragHolder(container, cell)
	local index = FindTableIndex(container.cells, cell)
	tremove(container.cells, index)
	tinsert(container.cells, index, container.dragPlaceHolder)
	container.dragPlaceHolder.realCell = cell
	--show the drag holder
	container.dragPlaceHolder:Show()
end

local function SwapDragHolderWithCell(container, cell)
	local index = FindTableIndex(container.cells, container.dragPlaceHolder)
	tremove(container.cells, index)
	tinsert(container.cells, index, cell)
	container.dragPlaceHolder.realCell = nil
	--hide the drag holder
	container.dragPlaceHolder:Hide()
end

local function MoveDragHolderBeforeCell(container, cell)
	if not cell then
		--move to end
		MoveIndexedCell(container.cells, container.dragPlaceHolder, #container.cells)
	else
		local index = FindTableIndex(container.cells, cell)
		MoveIndexedCell(container.cells, container.dragPlaceHolder, index)
	end
end

local function RemoveDragHolderForContainer(container)
	local index = FindTableIndex(container.cells, container.dragPlaceHolder)
	tremove(container.cells, index)
	--hide the drag holder
	container.dragPlaceHolder:Hide()
end

local function AddDragHolderForContainer(container)
	--just add it to the end
	tinsert(container.cells, container.dragPlaceHolder)
	--show the drag holder
	container.dragPlaceHolder:Show()
end

local function ProcessContainerDragState(prevCont, currCont, prevCell, currCell)
	--first handle container changes
	if prevCont and not currCont then
		RemoveDragHolderForContainer(prevCont)
	elseif not prevCont and currCont then
		AddDragHolderForContainer(currCont)
	else
		if prevCont == currCont then
			--do nothing
		else
			--completely jumped to new container with no space in between
			RemoveDragHolderForContainer(prevCont)
			AddDragHolderForContainer(currCont)
		end
	end
	
	--now handle cell changes
	if not prevCell and not currCell then
		--if there's an existing container, then we need to update the cells. We're just not actually hovering over a cell in the new container
		if currCont then
			MoveDragHolderBeforeCell(currCont, nil)
			--LegacyUI:RefreshAbilityOrder(currCont)
		end
		
	elseif prevCell and not currCell then
		--if there's an existing container, then we need to update the cells. We're just not actually hovering over a cell in the new container
		if currCont then
			MoveDragHolderBeforeCell(currCont, nil)
			--LegacyUI:RefreshAbilityOrder(currCont)
		end
	elseif not prevCell and currCell then
		--make sure it's not hovering over the dragPlaceHolder
		if currCell ~= currCont.dragPlaceHolder then
			MoveDragHolderBeforeCell(currCont, currCell)
			--LegacyUI:RefreshAbilityOrder(currCont)
		end
	else --both prevCell and currCell are not nil
		if prevCell == currCell then
			error("unexpected condition")
		else
			MoveDragHolderBeforeCell(currCont, currCell)
			--LegacyUI:RefreshAbilityOrder(currCont)
		end
	end
	
	--now reposition the cells in the containers that changed
	if prevCont then
		LegacyUI:PositionCells(prevCont)
	end
	
	if currCont then
		LegacyUI:PositionCells(currCont)
	end
end

local function OnDragHandlerUpdate(self, elapsed)
	DragHandler.timer = DragHandler.timer + elapsed
	if DragHandler.timer >= DragHandler.frequency then
	
		local prevCont = DragHandler.dropCont
		local prevCell = DragHandler.dropCell
		
		DragHandler.dropCont, DragHandler.dropCell = LegacyUI:GetMouseOverContainerFrameAndCell(DragHandler.dragCell) --ignore DragHandler.dragCell from matches

		--if the container or cell changed since last update
		if prevCont ~= DragHandler.dropCont or prevCell ~= DragHandler.dropCell then
			--go ahead and refresh the cell sort order on the original container if possibly needed
			--really important to not that we do not want to touch anything but the drag source container,
			--as MoveCellBetweenContainers takes care of things there
			if DragHandler.dropCont == DragHandler.dragCont then
				LegacyUI:RefreshAbilityOrder(DragHandler.dragCont)
			end
			
			--process the changes
			ProcessContainerDragState(prevCont, DragHandler.dropCont, prevCell, DragHandler.dropCell)
			
			--double check highlighting
			LegacyUI:HighlightContainers(true, DragHandler.dropCont)
		end
		
		DragHandler.timer = 0
		
	end
end

local function OnCellDragStart(cell, mouseButton)
	DragHandler.dragging = 1
	
	if(ToolTip) then
		QTip:Release(ToolTip)
		ToolTip = nil
	end

	--highlight the containers with a greenish color so we know where to drag
	LegacyUI:HighlightContainers(true, cell.container)
	
	--upate the drag handler properties before we start dragging
	DragHandler.dragCell = cell
	DragHandler.dragCont = cell.container --always starts over the container of the button
	DragHandler.dropCell = cell
	DragHandler.dropCont = cell.container
	
	--remove the cell from it's container.cells and add the placeholder in it's place
	SwapCellWithDragHolder(cell.container, cell)

	DragHandler:SetScript("OnUpdate", OnDragHandlerUpdate)
	cell:SetAlpha(0.5)
	
	--position the drag button on top of the button being dragged
	--this funky scaling code is due to the fact that frames with different scales cause issues. This fixes it
	cell:ClearAllPoints()

	local x, y = GetCursorPosition();
	local effScale = cell:GetEffectiveScale()
	local offsetx = 0
	local offsety = 0
	cell:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT",(x / effScale + offsetx),(y / effScale + offsety))

	--allow it to take mouse movement
	cell:StartMoving()

	--update all containers due to cell dragging to ensure all cells are shown
	--LegacyUI:PositionCells(cell.container)
	for _, c in ipairs(Containers) do
		LegacyUI:PositionCells(c)
	end
end

local function OnCellDragStop(cell, mouseButton)
	DragHandler:SetScript("OnUpdate", nil)
	
	cell:SetAlpha(1)
	cell:StopMovingOrSizing()

	--remember the current valies
	local dragCont = DragHandler.dragCont
	local dragCell = DragHandler.dragCell
	local dropCont = DragHandler.dropCont
	local dropCell = DragHandler.dropCell
	
	--reset these values which indicates we're no longer dragging
	DragHandler.dragging = nil
	DragHandler.dragCell = nil
	DragHandler.dragCont = nil
	
	if dropCont then
		-- mouse was released over a container
		if dropCont ~= dragCont then
			--mouse was released over a different container than the button originated from
			local desiredIndex
			if dropCell then
				desiredIndex = FindTableIndex(dropCont.cells, dropCell)
			else
				desiredIndex = nil --last
			end
			
			RemoveDragHolderForContainer(dropCont)
			LegacyUI:MoveCellBetweenContainers(cell, dropCont, desiredIndex)
		else
			--mouse was released over the same container it originated from
			SwapDragHolderWithCell(dragCont, dragCell)
		end
	else
		--mouse was released while not over a container
		--add the cell back to the container and resort by last saved sort order
		tinsert(cell.container.cells, cell) --last
		LegacyUI:SortContainerCells(cell.container)
		LegacyUI:PositionCells(cell.container)
	end
	
	LegacyUI:HighlightContainers(false, nil)
	
	--this is a bit wasteful, we really only need to respoition containers who aren't hiding spells or who were'nt reposioted above. I can improve this later
	for _, c in ipairs(Containers) do
		LegacyUI:PositionCells(c)
	end
end

function LegacyUI:GetMouseOverContainerFrameAndCell(ignoreFrame) --avoid hits on ignore frrame (it could be the one we're dragging
	local mx, my = GetCursorPosition();
	local return_container = nil
	local return_cell = nil
	for _, container in ipairs(Containers) do
		local cons = container:GetEffectiveScale()
		conx, cony = mx/cons, my/cons;
		if ((conx >= container:GetLeft()) and (conx <= container:GetRight()) and (cony >= container:GetBottom()) and (cony <= container:GetTop())) then
			return_container = container
			--now see if we're hovering over a cell
			for _, cell in ipairs(container.cells) do
				--only count if the cell isn't hidden and not equal to itself (that's what ignoreFrame is for
				if cell ~= ignoreFrame and cell:IsVisible() then
					local cells = cell:GetEffectiveScale()
					cellx, celly = mx/cells, my/cells;
					if (cellx >= cell:GetLeft() - container.dbp.padding) and (cellx <= cell:GetRight() + container.dbp.padding) and (celly >= cell:GetBottom() - container.dbp.padding) and (celly <= cell:GetTop() + container.dbp.padding) then
						return_cell = cell
						break; -- no need to keep looping
					end
				end
			end
			break; --no need to keep looping
		end
	end
	
	return return_container, return_cell
end

function LegacyUI:HighlightContainers(dragging, currentTarget)
	for _, container in ipairs(Containers) do
		if(dragging) then
			if(currentTarget and container == currentTarget) then
				container:SetBackdropColor(
					BGCOLOR_DRAGDROP_DROPTARGET[1],
					BGCOLOR_DRAGDROP_DROPTARGET[2],
					BGCOLOR_DRAGDROP_DROPTARGET[3],
					BGCOLOR_DRAGDROP_DROPTARGET[4])
			else
				container:SetBackdropColor(
					BGCOLOR_DRAGDROP_NOTDROPTARGET[1],
					BGCOLOR_DRAGDROP_NOTDROPTARGET[2],
					BGCOLOR_DRAGDROP_NOTDROPTARGET[3],
					BGCOLOR_DRAGDROP_NOTDROPTARGET[4])
			end
		else
			--reset all the colors back to normal
			self:UpdateContainerLocking(container)
		end
	end
end

function LegacyUI:RefreshAbilityOrder(container)
	container.dbp.abilities = {}
	
	--see if it belongs to any containers in the profile
	for _, c in ipairs(container.cells) do
		tinsert(container.dbp.abilities, self:GetRealCell(c).ability.id)
	end
end

function LegacyUI:MoveCellBetweenContainers(cell, newContainer, desiredIndex)
	local oldContainer = cell.container
	local oldContainerIndex = FindTableIndex(Containers, oldContainer)
	local cellIndex = FindTableIndex(oldContainer.cells, cell)
	
	-- note: there is no need to tremove from the old container because that happens during OnDragHandlerUpdate
	-- because the cell gets swapped with the place holder, and when you exit the container the place holder gets removed, so does the cell
	
	if desiredIndex then
		tinsert(newContainer.cells, desiredIndex, cell)
	else
		tinsert(newContainer.cells, cell) --last
	end

	cell.container = newContainer --set properties
	cell:SetParent(newContainer) --set the new UI parent so that scaling and all that jazz works
	
	--update all the cell stuff
	self:ApplyContainerStyleToCell(cell)
	self:UpdateCellStyle(cell)
	self:UpdateCellButtonStyle(cell)
	self:UpdateButtonBorders(cell.container, cell)
	self:UpdateNamePlateVisuals(cell.nameplate)
	self:ReleaseExtraBars(cell)
	self:EnsureMinimumBarCount(cell)
	self:SetCellVisibilityForCell(cell) --ensures the hide bit gets reset due to container change
	
	for _, bar in ipairs(cell.bars) do
		self:UpdateSpellBarVisuals(bar)
		self:SetSpellBarStyle(bar)
		self:UpdateSpellBarAnimations(bar)
	end
	
	self:RefreshAbilityOrder(oldContainer)
	self:RefreshAbilityOrder(newContainer)
	
	self:PositionCells(oldContainer)
	self:PositionCells(newContainer)
	
	self:PositionSpellBars(cell)
	
	--this will force the container frame size to match that of the values since adding the button
	self:SetContainerToVirtualSize(oldContainer)
	self:SetContainerToVirtualSize(newContainer)
end

------------------------------------------------------------------
--TOOLTIP
------------------------------------------------------------------
function LegacyUI:RefreshTooltip()
	if(ToolTip ~= nil) then
		ToolTip:Clear()
		
		local spellLine = ToolTip:AddLine("", "", "", "", "")
		ToolTip:SetCell(spellLine, 1, ToolTip.cell.ability.name, nil, "LEFT", nil, nil, 1, nil, 130, nil)
		ToolTip:SetCell(spellLine, 5, tostring(Hermes:AbilityIdToBlizzId(ToolTip.cell.ability.id)), SpellIdFont, "RIGHT", nil, nil, nil, 1, nil, nil)
		ToolTip:SetLineColor(spellLine,
			1,
			1,
			1,
			0.4)
		
		if(#ToolTip.cell.bars == 0) then
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
		
			for _, bar in ipairs(ToolTip.cell.bars) do
				if bar.instance then
					local sender = bar.instance.sender
					local instance = bar.instance
				
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
end

function LegacyUI:ShowTooltip(cell, anchor)
	if ToolTip == nil and not DragHandler.dragging then --don't show the tooltip if we're in the middle of dragging
		ToolTip = QTip:Acquire(MODNAME.." Tooltip", 5, "LEFT", "RIGHT", "RIGHT", "RIGHT", "RIGHT", "RIGHT")
		ToolTip:ClearAllPoints()
		ToolTip:SmartAnchorTo(anchor)
		ToolTip.cell = cell
		self:RefreshTooltip()
		ToolTip:Show()
	end
end

function LegacyUI:SetupToolTipFonts()
	if not SpellIdFont then
		SpellIdFont = CreateFont("LegacyUISpellIdFont")
		local gfns = GameFontNormalSmall
		local filename, size, flags = gfns:GetFont()
		SpellIdFont:SetFont(filename, size, flags)
		local r, g, b, a = gfns:GetTextColor()
		local sr, sg, sb, sa = gfns:GetShadowColor()
		SpellIdFont:SetTextColor(r, g, b, a)
		SpellIdFont:SetShadowColor(sr, sg, sb, sa)
	end
end

------------------------------------------------------------------
--OPTIONS
------------------------------------------------------------------
local NEW_CONTAINER_DEFAULTS = {
	name = nil,
	scale = 1,
	padding = 6,
	style = "Buttons",
	
	cellHideNoSender = false,
	cellHideNoAvailSender = false,
	cellAnchor = "TOPLEFT",
	cellMax = 5,
	cellDir = false,
	cellSide = false,
	cellBGColor = {r = 0, g = 0, b = 0, a = 0 },
	
	barFontSize = 0.6,
	barW = 152,
	barH = 20,
	barGap = 0,
	barPadding = 0,
	barTexture = "Blizzard",
	barFont = "Friz Quadrata TT",
	
	barCCA = true,
	barCCC = false,
	barCCU = false,
	
	barColorA = {r = 0.94, g = 0.94, b = 0.94, a = 1 },
	barColorC = {r = 0.55, g = 0.55, b = 0.55, a = 0.82 },
	barColorU = {r = 0.22, g = 0.22, b = 0.22, a = 0.41 },
	
	barBGCCC = false,
	barBGColorC = {r = 0, g = 0, b = 0, a = 0.3 },
	
	barCCAFont = true,
	barCCCFont = false,
	barCCUFont = false,
	
	barColorAFont = {r = 0.94, g = 0.94, b = 0.94, a = 1 },
	barColorCFont = {r = 1, g = 1, b = 1, a = 0.77 },
	barColorUFont = {r = 1, g = 1, b = 1, a = 0.77 },
	
	barTextRatio = 50,
	barOutlineFont = false,
	
	btnColor = false,
	
	npH = 20,
	npW = 100,
	npFontSize = 0.6,
	npTexColor = {r = 0.17, g = 0.17, b = 0.17, a = 1 },
	npCCBar = false,
	npCCFont = true,
	npFontColor = {r = 1, g = 1, b = 1, a = 1 },
	npBarColor = {r = 0, g = 1, b = 0, a = 1 },
	npTexture = "Blizzard",
	npFont = "Friz Quadrata TT",
	npOutlineFont = false,
	npUseIcon = true,
	npUseNameplate = true,
	
	enableTooltip = true,
	
	abilities = {}, -- all the abilities currently being displayed in the container
}

function LegacyUI:ApplyThemeToContainer(container, theme)
	local dbp = container.dbp
	for k, v in pairs(theme) do
		if LegacyUI.THEMEABLE[k] ~= nil then
			if type(v) == "table" then
				dbp[k] = deepcopy(v)
			else
				dbp[k] = v
			end
		end
	end
end

function LegacyUI:GetDefaultOptions()
	local defaults = {
		locked = false,
		containers = {},
	}
	
	--create the default container
	tinsert(defaults.containers, deepcopy(NEW_CONTAINER_DEFAULTS))

	return defaults
end

--used to store dynamic theme collection set, since Ace doesn't allow table's as keys, and I want to use fancy names. This is a workaround
local themeCollection

function LegacyUI:GetBlizzOptionsTable()
	local options = {
		name = "LegacyUI",
		type="group",
		childGroups="tree",
		inline = false,
		args = {
		},
	}
	
	options.args.common = {
		type="group",
		name=" ",
		inline = true,
		order = 0,
		args = {
			LockContainers = {
				type = "toggle",
				name = L["Lock Containers"],
				width = "normal",
				get = function(info) return dbp.locked end,
				order = 0,
				set = function(info, value)
					dbp.locked = value
					self:UpdateContainerLocking()
				end,
			},
			Add = {
				type = "execute",
				name = L["Add"],
				width = "normal",
				order = 2,
				func = function()
					--generate a unique name for the container
					local name = self:GenerateUniqueContainerName(Containers, L["Container"].." ")
					--clone defaults for the container
					local db = deepcopy(NEW_CONTAINER_DEFAULTS)
					--make sure to set the container name!!
					db.name = name
					--add container db values to settings
					tinsert(dbp.containers, db)
					--add container to display, need to copy the defaults again due to profile changes
					local container = self:CreateContainer(db)
					--unlock windows, pure convenience...
					dbp.locked = false
					--force all containers to unlock themselves
					self:UpdateContainerLocking()
					 --required as this ends up calling UpdateContainerProfilePosition which sets the X and Y in the profile. Without it the reload of the options tble will result in error where it tries to Round x and y
					self:SaveContainerPosition(container)
					--only show the container if we're receiving
					if Hermes:IsReceiving() then
						container:Show()
					end
					--force the config window to update with latest container added
					Hermes:ReloadBlizzPluginOptions()
					LIB_AceConfigDialog:SelectGroup(Hermes.HERMES_VERSION_STRING, MODNAME, name)
				end,
			}
		}
	}
	
	for k, container in ipairs(Containers) do
		--name of default container is nil
		local containerName
		if not container.dbp.name then containerName = L["Default"] else containerName = container.dbp.name end
		options.args[containerName] = {
			name = containerName,
			type = "group",
			inline = false,
			childGroups = "tree",
			args = {
			
				-- INLINE -- 
				
				Container = {
					name = L["Container"],
					type = "group",
					inline = true,
					hidden = function() return containerName == L["Default"] end,
					order = 0,
					args = {
						Name = {
							type = "input",
							name = "",
							width = "full",
							order = 5,
							get = function()
								return containerName
							end,
							validate = function(info, value)
							
								--make sure value is entered
								local text = strim(value)
								if(string.len(text) == 0) then
									return "Value required"
								end
								
								--make sure not renaiming to default container
								if text == L["Default"] then
									return "Container name exists"
								end
								
								--check for duplicates
								for k, v in pairs(dbp.containers) do
									if text == k and dbp.containers[k].name ~= k then
										return "Container name exists"
									end
								end
								
								return true
							end,
							set = function(info, value)
								local text = strim(value)
								container.dbp.name = text
								Hermes:ReloadBlizzPluginOptions()
								LIB_AceConfigDialog:SelectGroup(Hermes.HERMES_VERSION_STRING, MODNAME, container.dbp.name)
							end,
						},
						Delete = {
							type = "execute",
							name = L["Delete"],
							width = "full",
							order = 10,
							disabled = function() return container.dbp.name == nil end,
							confirm = function() return L["Container will be deleted and its abilities placed into the Default container. Continue?"] end,
							func = function()
								if(container.dbp.name == nil) then
									error("Attempt to delete Default frame, should not have been possible")
								end
								
								--move any buttons to default container
								while #container.cells > 0 do
									local cell = container.cells[1]
									tremove(container.cells, 1)
									self:MoveCellBetweenContainers(cell, DefaultContainer) --move all buttons in container to nil container
								end
								
								--recycle the container
								self:RecycleContainer(container)
								
								--remove the container from db
								local index = nil
								for i, c in ipairs(dbp.containers) do
									if(c.name and c.name == containerName) then
										index = i
										break
									end
								end
								
								if(not index) then
									error("Unexpected error trying to delete container from profile. Data consistency issue could mean more problems")
								end
								
								--delete from profile
								tremove(dbp.containers, index)
								
								--update config display
								LIB_AceConfigRegistry:NotifyChange("Hermes")
								Hermes:ReloadBlizzPluginOptions()
							end,
						},
					},
				},
				Theme = {
					name = L["Theme"],
					type = "group",
					inline = true,
					childGroups = "tab",
					order = 5,
					args = {
						DefaultThemes = {
							type = "select",
							name = L["Apply Theme"],
							width = "full",
							get = 
								function(info)
									return nil
								end,
							order = 5,
							confirm = function() return L["Properties will be changed to match the selected theme. Continue?"] end,
							style = "dropdown",
							values = function()
								if not themeCollection then
									themeCollection = { }
								else
									wipe(themeCollection)
								end
								
								--add current container list
								for _, c in ipairs(Containers) do
									if c.dbp.name ~= container.dbp.name then
										local key
										if c.dbp.name == nil then
											key = L["From"].." |cFF00FF00"..L["Default"].."|r"
										else
											key = L["From"].." |cFF00FF00"..c.dbp.name.."|r"
										end
										tinsert(themeCollection, {key = key, theme = c.dbp})
									else
									end
								end
								
								--add prebuilt themes
								for key, v in ipairs(LegacyUI.THEME_NAMES) do
									local k = L["Theme"].." |cFFFFB90F"..v.."|r"
									tinsert(themeCollection, {key = k, theme = LegacyUI.THEMES[LegacyUI.THEME_NAMES[key]]})
								end
								
								--sort themeCollection
								sort(themeCollection, function(a, b) return a.key < b.key end)
								
								--now create a list usable by Ace from the key/value pair
								local themes = {}
								for k, v in ipairs(themeCollection) do
									tinsert(themes, v.key)
								end
								
								return themes
							end,
							set = function(info, value)
								if value then
									--apply the theme to the current setup
									self:ApplyThemeToContainer(container, themeCollection[value].theme)
									
									--update all the cells in the container
									for _, cell in ipairs(container.cells) do
										--update all the bars in the cell
										self:ApplyContainerStyleToCell(cell)
										self:UpdateCellStyle(cell)
										self:UpdateCellButtonStyle(cell)
										self:UpdateButtonBorders(container, cell)
										self:PositionSpellBars(cell)
										self:UpdateNamePlateVisuals(cell.nameplate)
										for _, bar in ipairs(cell.bars) do
											self:UpdateSpellBarVisuals(bar)
											self:SetSpellBarStyle(bar)
											self:UpdateSpellBarAnimations(bar)
										end
									end
								
									self:PositionCells(container)
									self:UpdateContainerTooltipEnabledState(container)
									self:SetContainerToVirtualSize(container)
									self:UpdateContainerResizerPosition(container)

									--reload the options
									Hermes:ReloadBlizzPluginOptions()
									LIB_AceConfigDialog:SelectGroup(Hermes.HERMES_VERSION_STRING, MODNAME, containerName)
								end
							end,
						},
						CellStyle = {
							type = "select",
							name = L["Display Style"],
							width = "full",
							get = function(info) return container.dbp.style end,
							order = 10,
							style = "dropdown",
							values = {
								["Buttons"] = L["Buttons"],
								["Bars"] = L["Bars"],
							},
							set = function(info, value)
								container.dbp.style = value

								--update all the cells in the container
								for _, cell in ipairs(container.cells) do
									self:ApplyContainerStyleToCell(cell)
									self:PositionSpellBars(cell)
								end
										
								--force the container to reset itself
								self:UpdateContainerResizerPosition(container)
								self:PositionCells(container)
								self:SetContainerToVirtualSize(container)
								
								--reload the options pane
								Hermes:ReloadBlizzPluginOptions()
								LIB_AceConfigDialog:SelectGroup(Hermes.HERMES_VERSION_STRING, MODNAME, containerName)
							end,
						},
					},
				},
				Tooltip = {
					name = L["Tooltip"],
					type = "group",
					inline = true,
					order = 7,
					args = {
						Enable = {
							type = "toggle",
							name = L["Enabled"],
							width = "normal",
							get = function(info) return container.dbp.enableTooltip end,
							order = 0,
							set = function(info, value)
								container.dbp.enableTooltip = value
								self:UpdateContainerTooltipEnabledState(container)
							end,
						},
					},
				},
				Positioning = {
					name = L["Size and Position"],
					type = "group",
					inline = true,
					order = 10,
					args = {
						Scale = {
							type = "range",
							min = 0.1, max = 3, step = 0.01,
							name = L["Scale"],
							order = 4,
							width = "full",
							get = function(info) return container.dbp.scale end,
							set =
								function(info, value)
									container.dbp.scale = value
									container:SetScale(container.dbp.scale)
								end
						},
						XPos = {
							type = "input",
							name = "X",
							width = "normal",
							get = 
								function(info)
									local x, y = self:GetPositionRelativeToCellAnchor(container)
									return tostring(_round(x))
								end,
							order = 8,
							validate = function(info, value)
								local text = strim(value)
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
								local x, y = self:GetPositionRelativeToCellAnchor(container)
								self:SetPositionRelativeToCellAnchor(container, tonumber(strim(value)), y)
							end,
						},
						YPos = {
							type = "input",
							name = "Y",
							width = "normal",
							get = 
								function(info)
									local x, y = self:GetPositionRelativeToCellAnchor(container)
									return tostring(_round(y))
								end,
							order = 10,
							validate = function(info, value)
								local text = strim(value)
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
								local x, y = self:GetPositionRelativeToCellAnchor(container)
								self:SetPositionRelativeToCellAnchor(container, x, tonumber(strim(value)))
							end,
						},
						ResetPosition = {
							type = "execute",
							name = L["Reset Position"],
							width = "full",
							order = 14,
							func =
								function(info, value)
									container:ClearAllPoints()
									container:SetPoint("CENTER", UIParent, "CENTER")
									container.dbp.x = container:GetLeft()
									container.dbp.y = container:GetTop()
									self:SaveContainerPosition(container)
								end,
						},
					},
				},
				
				--SUB TREES --
				
				CellBehavior = {
					name = L["Cells"],
					type = "group",
					inline = false,
					order = 15,
					args = {
						cellHideNoSender = {
							type = "toggle",
							name = L["Hide Abilities without Senders"],
							width = "full",
							get = function(info) return container.dbp.cellHideNoSender end,
							order = 5,
							set =
								function(info, value)
									container.dbp.cellHideNoSender = value
									--first handle cells
									if self:SetCellVisibilityForAllCells(container) == true then
										self:PositionCells(container)
										self:SetContainerToVirtualSize(container)
									end
									--now handle spell bars
									for _, cell in ipairs(container.cells) do
										for _, bar in ipairs(cell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end
								end,
						},
						cellHideNoAvailSender = {
							type = "toggle",
							name = L["Hide Abilities without available Senders"],
							width = "full",
							get = function(info) return container.dbp.cellHideNoAvailSender end,
							order = 10,
							set =
								function(info, value)
									container.dbp.cellHideNoAvailSender = value
									--first handle cells
									--if self:SetCellVisibilityForAllCells(container) == true then
										self:SetCellVisibilityForAllCells(container)
										self:PositionCells(container)
										self:SetContainerToVirtualSize(container)
									--end
									--now handle spell bars
									for _, cell in ipairs(container.cells) do
										for _, bar in ipairs(cell.bars) do
											self:SetSpellBarStyle(bar)
										end
									end
								end,
						},
						cellAnchor = {
							type = "select",
							name = L["Cell Anchor"],
							width = "full",
							get = function(info) return container.dbp.cellAnchor end,
							order = 15,
							style = "dropdown",
							set = 
								function(info, value)
									container.dbp.cellAnchor = value
									self:UpdateContainerResizerPosition(container)
									self:PositionCells(container)
									self:SetContainerToVirtualSize(container)
								end,
							values = {
								["TOPLEFT"] = L["Top Left"],
								["TOPRIGHT"] = L["Top Right"],
								["BOTTOMLEFT"] = L["Bottom Left"],
								["BOTTOMRIGHT"] = L["Bottom Right"],
							},
						},
						CellPadding = {
							type = "range", min = 0, max = 100, step = 1,
							name = L["Padding"],
							width = "full",
							get = function(info) return container.dbp.padding end,
							order = 20,
							set = 
								function(info, value)
									container.dbp.padding = value
									self:PositionCells(container)
									self:SetContainerToVirtualSize(container)
								end,
						},
					},
				},
				Buttons = {
					name = L["Buttons Style"],
					type = "group",
					inline = false,
					order = 20,
					disabled = function() return container.dbp.style ~= "Buttons" end,
					args = {
						btnColor = {
							type = "toggle",
							name = L["Class Colored Borders"],
							width = "normal",
							get = function(info) return container.dbp.btnColor end,
							order = 15,
							set = 
								function(info, value)
									container.dbp.btnColor = value
									self:UpdateButtonBorders(container, nil)
								end,
						},
					},
				},
				Bars = {
					name = L["Bars Style"],
					type = "group",
					inline = false,
					order = 25,
					disabled = function() return container.dbp.style ~= "Bars" end,
					args = {
						hideNoCooldown = {
							type = "toggle",
							name = L["Only show bar when spell is on cooldown"],
							width = "full",
							get = function(info) return container.dbp.hideNoCooldown end,
							order = 3,
							set = function(info, value)
								container.dbp.hideNoCooldown = value
								--now handle spell bars
								for _, cell in ipairs(container.cells) do
									self:PositionSpellBars(cell)
								end
							end,
						},
						TicTacLocation= {
							type = "select",
							name = L["Bar Direction"],
							order = 5,
							style = "dropdown",
							width = "full",
							get = function(info)
								if(container.dbp.cellDir == false and container.dbp.cellSide == false) then
									return "TOP TO BOTTOM"
								elseif(container.dbp.cellDir == false and container.dbp.cellSide == true) then
									return "BOTTOM TO TOP"
								elseif(container.dbp.cellDir == true and container.dbp.cellSide == false) then
									return "LEFT TO RIGHT"
								elseif(container.dbp.cellDir == true and container.dbp.cellSide == true) then
									return "RIGHT TO LEFT"
								end
							end,
							set = 
								function(info, value)
									if(value == "TOP TO BOTTOM") then
										container.dbp.cellDir = false
										container.dbp.cellSide = false

									elseif(value == "BOTTOM TO TOP") then
										container.dbp.cellDir = false
										container.dbp.cellSide = true

									elseif(value == "LEFT TO RIGHT") then
										container.dbp.cellDir = true
										container.dbp.cellSide = false

									elseif(value == "RIGHT TO LEFT") then
										container.dbp.cellDir = true
										container.dbp.cellSide = true

									end

									for _, cell in ipairs(container.cells) do
										self:PositionSpellBars(cell)
									end
									self:PositionCells(container)
									self:SetContainerToVirtualSize(container)
									
									--reload the options pane due to some controls that change based on direction
									Hermes:ReloadBlizzPluginOptions()
									LIB_AceConfigDialog:SelectGroup(Hermes.HERMES_VERSION_STRING, MODNAME, containerName, "Bars")
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
							order = 10,
							width = "full",
							get = function(info) return container.dbp.cellMax end,
							set = 
								function(info, value)
									container.dbp.cellMax = value

									for _, cell in ipairs(container.cells) do
										self:ReleaseExtraBars(cell)
										self:EnsureMinimumBarCount(cell)
										self:PositionSpellBars(cell)
									end
									
									self:PositionCells(container)
									self:SetContainerToVirtualSize(container)
								end,
						},
						barPadding = {
							type = "range",
							min = 0,
							max = 20,
							step = 1,
							name = L["Padding"],
							order = 15,
							width = "full",
							get = function(info) return container.dbp.barPadding end,
							set = 
								function(info, value)
									container.dbp.barPadding = value
									for _, cell in ipairs(container.cells) do
										self:PositionSpellBars(cell)
									end
									self:PositionCells(container)
									self:SetContainerToVirtualSize(container)
								end,
						},
						BackgroundColor = {
							name = L["Color"],
							type = "group",
							inline = true,
							order = 20,
							args = {
								Color = {
									type = "color",
									hasAlpha = true,
									order = 20,
									name = L["Background"],
									width = "normal",
									get = function(info) return
										container.dbp.cellBGColor.r,
										container.dbp.cellBGColor.g,
										container.dbp.cellBGColor.b,
										container.dbp.cellBGColor.a
									end,
									set = 
										function(info, r, g, b, a)
											container.dbp.cellBGColor.r = r
											container.dbp.cellBGColor.g = g
											container.dbp.cellBGColor.b = b
											container.dbp.cellBGColor.a = a
											
											--update all the cells in the container
											for _, cell in ipairs(container.cells) do
												self:UpdateCellStyle(cell)
											end
										end,
								},
							},
						},
						NameplateOptions = {
							name = L["Nameplate"],
							type = "group",
							inline = false,
							order = 5,
							childGroups = "tab",
							args = {
								npUseNameplate = {
									type = "toggle",
									name = L["Show Nameplate"],
									width = "normal",
									get = function(info) return container.dbp.npUseNameplate end,
									order = 3,
									set =
										function(info, value)
											container.dbp.npUseNameplate = value
											for _, cell in ipairs(container.cells) do
												self:PositionSpellBars(cell)
											end
											self:PositionCells(container)
											self:SetContainerToVirtualSize(container)
										end,
								},
								npUseIcon = {
									type = "toggle",
									name = L["Show Icon"],
									width = "normal",
									disabled = function(info) return container.dbp.npUseNameplate == false end,
									get = function(info) return container.dbp.npUseIcon end,
									order = 4,
									set =
										function(info, value)
											container.dbp.npUseIcon = value
											for _, cell in ipairs(container.cells) do
												self:PositionSpellBars(cell)
											end
										end,
								},
								Size = {
									name = L["Size"],
									type = "group",
									inline = false,
									order = 5,
									disabled = function(info) return container.dbp.npUseNameplate == false end,
									args = {
										npH = {
											type = "range",
											min = 8,
											max = 50,
											step = 1,
											name = L["Height"],
											order = 0,
											width = "full",
											disabled = container.dbp.cellDir == true,
											get = function(info) return container.dbp.npH end,
											set = 
												function(info, value)
													container.dbp.npH = value
													for _, cell in ipairs(container.cells) do
														self:PositionSpellBars(cell)
														--because font size is attached to bar height, we need to update this too
														self:UpdateNamePlateVisuals(cell.nameplate)
													end
													self:PositionCells(container)
													self:SetContainerToVirtualSize(container)
												end,
										},
										npW = {
											type = "range",
											min = 1,
											max = 400,
											step = 1,
											name = L["Width"],
											order = 2,
											width = "full",
											disabled = container.dbp.cellDir == false,
											get = function(info) return container.dbp.npW end,
											set = 
												function(info, value)
													container.dbp.npW = value
													for _, cell in ipairs(container.cells) do
														self:PositionSpellBars(cell)
													end
													self:PositionCells(container)
													self:SetContainerToVirtualSize(container)
												end,
										},
									},
								},
								Texture = {
									name = L["Texture"],
									type = "group",
									inline = false,
									order = 10,
									disabled = function(info) return container.dbp.npUseNameplate == false end,
									args = {
										npTexture = {
											type = 'select',
											order = 5,
											dialogControl = 'LSM30_Statusbar',
											name = L["Texture"],
											values = AceGUIWidgetLSMlists.statusbar,
											width = "full",
											get = function() return container.dbp.npTexture end,
											set = 
												function(info, value)
													container.dbp.npTexture = value
													
													--update all the cells in the container
													for _, cell in ipairs(container.cells) do
														self:UpdateNamePlateVisuals(cell.nameplate)
													end
												end
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
														container.dbp.npTexColor.r,
														container.dbp.npTexColor.g,
														container.dbp.npTexColor.b,
														container.dbp.npTexColor.a
													end,
													set = 
														function(info, r, g, b, a)
															container.dbp.npTexColor.r = r
															container.dbp.npTexColor.g = g
															container.dbp.npTexColor.b = b
															container.dbp.npTexColor.a = a
															
															--update all the cells in the container
															for _, cell in ipairs(container.cells) do
																self:UpdateNamePlateVisuals(cell.nameplate)
															end
														end,
												},
												npCCBar = {
													type = "toggle",
													name = L["Use Class Color"],
													get = function() return container.dbp.npCCBar end,
													order = 10,
													width = "normal",
													set = 
														function(info, value)
															container.dbp.npCCBar = value
															
															--update all the cells in the container
															for _, cell in ipairs(container.cells) do
																self:UpdateNamePlateVisuals(cell.nameplate)
															end
														end
												},
											},
										},
									},
								},
								Font = {
									name = L["Font"],
									type = "group",
									inline = false,
									order = 15,
									disabled = function(info) return container.dbp.npUseNameplate == false end,
									args = {
										npFont = {
											type = "select",
											dialogControl = 'LSM30_Font',
											order = 5,
											name = L["Font"],
											width = "full",
											values = AceGUIWidgetLSMlists.font,
											get = function(info) return container.dbp.npFont end,
											set = 
												function(info, value)
													container.dbp.npFont = value
													
													--update all the cells in the container
													for _, cell in ipairs(container.cells) do
														self:UpdateNamePlateVisuals(cell.nameplate)
													end
												end
										},
										npOutlineFont = {
											type = "toggle",
											name = L["Outline"],
											get = function() return container.dbp.npOutlineFont end,
											order = 7,
											width = "normal",
											set = 
												function(info, value)
													container.dbp.npOutlineFont = value
													
													--update all the cells in the container
													for _, cell in ipairs(container.cells) do
														self:UpdateNamePlateVisuals(cell.nameplate)
													end
												end
										},
										npFontSize = {
											type = "range",
											min = 0.1, max = 2, step = 0.01,
											name = L["Font Size"],
											width = "full",
											get = function(info) return container.dbp.npFontSize end,
											order = 10,
											set = 
												function(info, value)
													container.dbp.npFontSize = value
													--update all the cells in the container
													for _, cell in ipairs(container.cells) do
														self:UpdateNamePlateVisuals(cell.nameplate)
													end
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
														container.dbp.npFontColor.r,
														container.dbp.npFontColor.g,
														container.dbp.npFontColor.b,
														container.dbp.npFontColor.a
													end,
													set = 
														function(info, r, g, b, a)
															container.dbp.npFontColor.r = r
															container.dbp.npFontColor.g = g
															container.dbp.npFontColor.b = b
															container.dbp.npFontColor.a = a
															
															--update all the cells in the container
															for _, cell in ipairs(container.cells) do
																self:UpdateNamePlateVisuals(cell.nameplate)
															end
														end,
												},
												npCCFont = {
													type = "toggle",
													name = L["Use Class Color"],
													get = function() return container.dbp.npCCFont end,
													order = 10,
													width = "normal",
													set = 
														function(info, value)
															container.dbp.npCCFont = value
															
															--update all the cells in the container
															for _, cell in ipairs(container.cells) do
																self:UpdateNamePlateVisuals(cell.nameplate)
															end
														end
												},
											},
										},
									},
								},
							},
						},
						BarOptions = {
							name = L["Bars"],
							type = "group",
							inline = false,
							order = 10,
							childGroups = "tab",
							args = {
								Size = {
									name = L["Size"],
									type = "group",
									inline = false,
									order = 5,
									args = {
										barW = {
											type = "range",
											min = 1, max = 400, step = 1,
											name = L["Width"],
											width = "full",
											get = function(info) return container.dbp.barW end,
											order = 5,
											set = 
												function(info, value)
													container.dbp.barW = value
													for _, cell in ipairs(container.cells) do
														self:PositionSpellBars(cell)
													end
													self:PositionCells(container)
													self:SetContainerToVirtualSize(container)
												end,
										},
										barH = {
											type = "range",
											min = 1, max = 50, step = 1,
											name = L["Height"],
											width = "full",
											get = function(info) return container.dbp.barH end,
											order = 10,
											set = 
												function(info, value)
													container.dbp.barH = value
													for _, cell in ipairs(container.cells) do
														self:UpdateNamePlateVisuals(cell.nameplate) --if bars or horizontal, then the size of the nameplate also changes, so need to update font size there too
														self:PositionSpellBars(cell)
														--because font size is attached to bar height, we need to update the bars too
														for _, bar in ipairs(cell.bars) do
															self:UpdateSpellBarVisuals(bar)
														end
													end
													self:PositionCells(container)
													self:SetContainerToVirtualSize(container)
												end,
										},
										barGap = {
											type = "range",
											min = 0, max = 50, step = 1,
											name = L["Gap Between Bars"],
											width = "full",
											get = function(info) return container.dbp.barGap end,
											order = 15,
											set = 
												function(info, value)
													container.dbp.barGap = value
													for _, cell in ipairs(container.cells) do
														self:PositionSpellBars(cell)
													end
													self:PositionCells(container)
													self:SetContainerToVirtualSize(container)
												end,
										},
									},
								},
								Texture = {
									name = L["Texture"],
									type = "group",
									inline = false,
									order = 10,
									args = {
										barTexture = {
											type = 'select',
											order = 5,
											dialogControl = 'LSM30_Statusbar',
											name = L["Texture"],
											width = "full",
											values = AceGUIWidgetLSMlists.statusbar,
											get = function() return container.dbp.barTexture end,
											set = 
												function(info, value)
													container.dbp.barTexture = value
													for _, cell in ipairs(container.cells) do
														for _,bar in ipairs(cell.bars) do
															self:UpdateSpellBarVisuals(bar)
														end
													end
												end
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
														container.dbp.barColorA.r,
														container.dbp.barColorA.g,
														container.dbp.barColorA.b,
														container.dbp.barColorA.a
													end,
													set = 
														function(info, r, g, b, a)
															container.dbp.barColorA.r = r
															container.dbp.barColorA.g = g
															container.dbp.barColorA.b = b
															container.dbp.barColorA.a = a
															
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end,
												},
												barCCA = {
													type = "toggle",
													name = L["Use Class Color"],
													get = function() return container.dbp.barCCA end,
													order = 10,
													width = "normal",
													set = 
														function(info, value)
															container.dbp.barCCA = value
															
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end
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
													disabled = function() return container.dbp.cellHideNoAvailSender end,
													get = function(info) return
														container.dbp.barColorC.r,
														container.dbp.barColorC.g,
														container.dbp.barColorC.b,
														container.dbp.barColorC.a
													end,
													set = 
														function(info, r, g, b, a)
															container.dbp.barColorC.r = r
															container.dbp.barColorC.g = g
															container.dbp.barColorC.b = b
															container.dbp.barColorC.a = a
															
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end,
												},
												barCCC = {
													type = "toggle",
													name = L["Use Class Color"],
													get = function() return container.dbp.barCCC end,
													order = 10,
													width = "normal",
													disabled = function() return container.dbp.cellHideNoAvailSender end,
													set = 
														function(info, value)
															container.dbp.barCCC = value
															
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end
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
														container.dbp.barBGColorC.r,
														container.dbp.barBGColorC.g,
														container.dbp.barBGColorC.b,
														container.dbp.barBGColorC.a
													end,
													set = 
														function(info, r, g, b, a)
															container.dbp.barBGColorC.r = r
															container.dbp.barBGColorC.g = g
															container.dbp.barBGColorC.b = b
															container.dbp.barBGColorC.a = a
															
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end,
												},
												barBGCCC = {
													type = "toggle",
													name = L["Use Class Color"],
													get = function() return container.dbp.barBGCCC end,
													order = 20,
													width = "normal",
													set = 
														function(info, value)
															container.dbp.barBGCCC = value
															
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end
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
														container.dbp.barColorU.r,
														container.dbp.barColorU.g,
														container.dbp.barColorU.b,
														container.dbp.barColorU.a
													end,
													set = 
														function(info, r, g, b, a)
															container.dbp.barColorU.r = r
															container.dbp.barColorU.g = g
															container.dbp.barColorU.b = b
															container.dbp.barColorU.a = a
															
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end,
												},
												barCCU = {
													type = "toggle",
													name = L["Use Class Color"],
													get = function() return container.dbp.barCCU end,
													order = 10,
													width = "normal",
													disabled = function() return container.dbp.cellHideNoAvailSender end,
													set = 
														function(info, value)
															container.dbp.barCCU = value
															
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end
												},
											},
										},
									},
								},
								Font = {
									name = L["Font"],
									type = "group",
									inline = false,
									order = 15,
									args = {
										barFont = {
											type = "select",
											dialogControl = 'LSM30_Font',
											order = 5,
											name = L["Font"],
											width = "full",
											values = AceGUIWidgetLSMlists.font,
											get = function(info) return container.dbp.barFont end,
											set = 
												function(info, value)
													container.dbp.barFont = value
													for _, cell in ipairs(container.cells) do
														for _,bar in ipairs(cell.bars) do
															self:UpdateSpellBarVisuals(bar)
														end
													end
												end
										},
										barOutlineFont = {
											type = "toggle",
											name = L["Outline"],
											get = function() return container.dbp.barOutlineFont end,
											order = 7,
											width = "normal",
											set = 
												function(info, value)
													container.dbp.barOutlineFont = value
													for _, cell in ipairs(container.cells) do
														for _,bar in ipairs(cell.bars) do
															self:UpdateSpellBarVisuals(bar)
														end
													end
												end
										},
										FontSizeMultiplier = {
											type = "range",
											min = 0.1, max = 2, step = 0.01,
											name = L["Font Size"],
											width = "full",
											get = function(info) return container.dbp.barFontSize end,
											order = 10,
											set = 
												function(info, value)
													container.dbp.barFontSize = value
													for _, cell in ipairs(container.cells) do
														for _,bar in ipairs(cell.bars) do
															self:UpdateSpellBarVisuals(bar)
														end
													end
												end,
										},
										barTextRatio = {
											type = "range",
											min = 0, max = 100, step = 1,
											name = L["Player/Duration Width Ratio (%)"],
											width = "full",
											get = function(info) return container.dbp.barTextRatio end,
											order = 15,
											set = 
												function(info, value)
													container.dbp.barTextRatio = value
													for _, cell in ipairs(container.cells) do
														self:PositionSpellBars(cell)
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
														container.dbp.barColorAFont.r,
														container.dbp.barColorAFont.g,
														container.dbp.barColorAFont.b,
														container.dbp.barColorAFont.a
													end,
													set = 
														function(info, r, g, b, a)
															container.dbp.barColorAFont.r = r
															container.dbp.barColorAFont.g = g
															container.dbp.barColorAFont.b = b
															container.dbp.barColorAFont.a = a
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end,
												},
												barCCAFont = {
													type = "toggle",
													name = L["Use Class Color"],
													get = function() return container.dbp.barCCAFont end,
													order = 10,
													width = "normal",
													set = 
														function(info, value)
															container.dbp.barCCAFont = value
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end
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
														container.dbp.barColorCFont.r,
														container.dbp.barColorCFont.g,
														container.dbp.barColorCFont.b,
														container.dbp.barColorCFont.a
													end,
													set = 
														function(info, r, g, b, a)
															container.dbp.barColorCFont.r = r
															container.dbp.barColorCFont.g = g
															container.dbp.barColorCFont.b = b
															container.dbp.barColorCFont.a = a
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end,
												},
												barCCCFont = {
													type = "toggle",
													name = L["Use Class Color"],
													get = function() return container.dbp.barCCCFont end,
													order = 10,
													width = "normal",
													set = 
														function(info, value)
															container.dbp.barCCCFont = value
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end
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
													disabled = function() return container.dbp.cellHideNoAvailSender end,
													get = function(info) return
														container.dbp.barColorUFont.r,
														container.dbp.barColorUFont.g,
														container.dbp.barColorUFont.b,
														container.dbp.barColorUFont.a
													end,
													set = 
														function(info, r, g, b, a)
															container.dbp.barColorUFont.r = r
															container.dbp.barColorUFont.g = g
															container.dbp.barColorUFont.b = b
															container.dbp.barColorUFont.a = a
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end,
												},
												barCCUFont = {
													type = "toggle",
													name = L["Use Class Color"],
													get = function() return container.dbp.barCCUFont end,
													order = 10,
													width = "normal",
													disabled = function() return container.dbp.cellHideNoAvailSender end,
													set = 
														function(info, value)
															container.dbp.barCCUFont = value
															for _, cell in ipairs(container.cells) do
																for _,bar in ipairs(cell.bars) do
																	self:UpdateSpellBarVisuals(bar)
																	self:SetSpellBarStyle(bar)
																	self:UpdateSpellBarAnimations(bar)
																end
															end
														end
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
	end

	return options
end

-----------------------------------------------------------------
--HERMESUI MOD
------------------------------------------------------------------
function LegacyUI:OnEnable() -- Hermes calls this after OnInitProfile is called
	--setup	all the containers, the profile has been loaded at this point
	self:InitializeContainers()
	
	--provide events for starting and stopping receiving, which is when we'll want to show the UI
	Hermes:RegisterHermesEvent("OnStartSending", MODNAME, function() self:OnStartSending() end)
	Hermes:RegisterHermesEvent("OnStopSending", MODNAME, function() self:OnStopSending() end)
	Hermes:RegisterHermesEvent("OnStartReceiving", MODNAME, function() self:OnStartReceiving() end)
	Hermes:RegisterHermesEvent("OnStopReceiving", MODNAME, function() self:OnStopReceiving() end)
end

function LegacyUI:OnDisable()
	Hermes:UnregisterHermesEvent("OnStartSending", MODNAME)
	Hermes:UnregisterHermesEvent("OnStopSending", MODNAME)
	Hermes:UnregisterHermesEvent("OnStartReceiving", MODNAME)
	Hermes:UnregisterHermesEvent("OnStopReceiving", MODNAME)
	
	self:OnStopReceiving()

	--teardown all UI components to scratch	
	self:RecycleContainers()
end

function LegacyUI:OnInitialize() --called whnen addon first loads, unfortunately profile information isn't loaded yet so can't do much
	--setup all one time UI components from scratch, nothing here can rely on a profile
	self:SetupToolTipFonts()
	self:CreateRecycledContainerFrame()
	self:CreateRecycledCellFrame()
	self:CreateRecycledBarFrame()
	self:CreateDragHandler()
	--self:CreateDragPlaceHolder()
	
	if(LBF) then
		self:SetupLBFGroup()
		LBF:RegisterSkinCallback(LBFLegacyUI.Name, LBFLegacyUI.RegisterSkin, LBFLegacyUI)
	end
	
	LIB_LibSharedMedia.RegisterCallback(self, "LibSharedMedia_Registered", "UpdateUsedMedia") --register for media update callbacks
	
	Hermes:RegisterHermesPlugin(
		MODNAME,
		function () self:Enable() end,
		function () self:Disable() end,
		function (dbplugins) self:OnSetHermesPluginProfile(dbplugins) end,
		function () return self:GetBlizzOptionsTable() end
	)
end

function LegacyUI:HookEvents(hook)
	if hook and hook == true then
		Hermes:RegisterHermesEvent("OnSenderAdded", MODNAME, function(sender) self:OnSenderAdded(sender) end)
		Hermes:RegisterHermesEvent("OnSenderRemoved", MODNAME, function(sender) self:OnSenderRemoved(sender) end)
		Hermes:RegisterHermesEvent("OnSenderVisibilityChanged", MODNAME, function(sender) self:OnSenderVisibilityChanged(sender) end)
		Hermes:RegisterHermesEvent("OnSenderOnlineChanged", MODNAME, function(sender) self:OnSenderOnlineChanged(sender) end)
		Hermes:RegisterHermesEvent("OnSenderDeadChanged", MODNAME, function(sender) self:OnSenderDeadChanged(sender) end)
		Hermes:RegisterHermesEvent("OnSenderAvailabilityChanged", MODNAME, function(sender) self:OnSenderAvailabilityChanged(sender) end)
		
		Hermes:RegisterHermesEvent("OnPlayerGroupStatusChanged", MODNAME, function(isInGroup) self:OnPlayerGroupStatusChanged(isInGroup) end)
		
		Hermes:RegisterHermesEvent("OnAbilityAdded", MODNAME, function(ability) self:OnAbilityAdded(ability) end)
		Hermes:RegisterHermesEvent("OnAbilityRemoved", MODNAME, function(ability) self:OnAbilityRemoved(ability) end)
		Hermes:RegisterHermesEvent("OnAbilityAvailableSendersChanged", MODNAME, function(ability) self:OnAbilityAvailableSendersChanged(ability) end)
		Hermes:RegisterHermesEvent("OnAbilityTotalSendersChanged", MODNAME, function(ability) self:OnAbilityTotalSendersChanged(ability) end)
		
		Hermes:RegisterHermesEvent("OnAbilityInstanceAdded", MODNAME, function(instance) self:OnAbilityInstanceAdded(instance) end)
		Hermes:RegisterHermesEvent("OnAbilityInstanceRemoved", MODNAME, function(instance) self:OnAbilityInstanceRemoved(instance)end)
		Hermes:RegisterHermesEvent("OnAbilityInstanceStartCooldown", MODNAME, function(instance) LegacyUI:OnAbilityInstanceStartCooldown(instance) end)
		Hermes:RegisterHermesEvent("OnAbilityInstanceUpdateCooldown", MODNAME, function(instance) LegacyUI:OnAbilityInstanceUpdateCooldown(instance) end)
		Hermes:RegisterHermesEvent("OnAbilityInstanceStopCooldown", MODNAME, function(instance) LegacyUI:OnAbilityInstanceStopCooldown(instance) end)
		Hermes:RegisterHermesEvent("OnAbilityInstanceAvailabilityChanged", MODNAME, function(instance) LegacyUI:OnAbilityInstanceAvailabilityChanged(instance) end)

	else
		Hermes:UnregisterHermesEvent("OnSenderAdded", MODNAME)
		Hermes:UnregisterHermesEvent("OnSenderRemoved", MODNAME)
		Hermes:UnregisterHermesEvent("OnSenderVisibilityChanged", MODNAME)
		Hermes:UnregisterHermesEvent("OnSenderOnlineChanged", MODNAME)
		Hermes:UnregisterHermesEvent("OnSenderDeadChanged", MODNAME)
		Hermes:UnregisterHermesEvent("OnSenderAvailabilityChanged", MODNAME)
		
		Hermes:UnregisterHermesEvent("OnPlayerGroupStatusChanged", MODNAME)
		
		Hermes:UnregisterHermesEvent("OnAbilityAdded", MODNAME)
		Hermes:UnregisterHermesEvent("OnAbilityRemoved", MODNAME)
		Hermes:UnregisterHermesEvent("OnAbilityAvailableSendersChanged", MODNAME)
		Hermes:UnregisterHermesEvent("OnAbilityTotalSendersChanged", MODNAME)
		
		Hermes:UnregisterHermesEvent("OnAbilityInstanceAdded", MODNAME)
		Hermes:UnregisterHermesEvent("OnAbilityInstanceRemoved", MODNAME)
		Hermes:UnregisterHermesEvent("OnAbilityInstanceStartCooldown", MODNAME)
		Hermes:UnregisterHermesEvent("OnAbilityInstanceUpdateCooldown", MODNAME)
		Hermes:UnregisterHermesEvent("OnAbilityInstanceStopCooldown", MODNAME)
		Hermes:UnregisterHermesEvent("OnAbilityInstanceAvailabilityChanged", MODNAME)
	end
end

------------------------------------------------------------------
--HERMES PLUGIN CALLBACKS
------------------------------------------------------------------
function LegacyUI:UpdateFromDefaultUIName(dbplugins)

end

function LegacyUI:OnSetHermesPluginProfile(dbplugins)
	if not dbplugins[MODNAME] then
		--see if there is an option table for the DefaultUI (from old versions of Hermes) then potentially copy that table instead
		if dbplugins["DefaultUI"] then
			--copy it
			dbplugins[MODNAME] = deepcopy(dbplugins["DefaultUI"])
			--remove it
			dbplugins["DefaultUI"] = nil
		else
			--otherwise use defaults
			dbplugins[MODNAME] = self:GetDefaultOptions()
		end
	end
	
	dbp = dbplugins[MODNAME]
	
	--upgrade all the container with latest options
	for _, container in ipairs(dbp.containers) do
		--post v2.1
		if container.barBGCCC == nil then
			container.barBGCCC = false
		end
		if not container.barBGColorC then
			container.barBGColorC = {r = 0, g = 0, b = 0, a = 0.3 }
		end
		if container.enableTooltip == nil then
			container.enableTooltip = true
		end
	end
end

------------------------------------------------------------------
--HERMES EVENTS
------------------------------------------------------------------
function LegacyUI:OnStartReceiving()
	--show all the containers as applicable
	for _, container in ipairs(Containers) do
		container:Show()
	end
	
	--start capturing events
	self:HookEvents(true)
end

function LegacyUI:OnStopReceiving()
	--stop capturing events
	self:HookEvents(false)
	
	--remove all cells from containers and hide the containers
	for _, container in ipairs(Containers) do
		container:Hide()
		self:RecycleCells(container)
	end
end

function LegacyUI:OnStartSending()

end

function LegacyUI:OnStopSending()

end

------------------------------------------------------------------
--SENDER EVENTS
------------------------------------------------------------------
function LegacyUI:OnSenderAdded(sender)
	
end

function LegacyUI:OnSenderRemoved(sender)
	
end

function LegacyUI:OnSenderVisibilityChanged(sender)
	
end

function LegacyUI:OnSenderOnlineChanged(sender)
	
end

function LegacyUI:OnSenderDeadChanged(sender)
	
end

function LegacyUI:OnSenderAvailabilityChanged(sender)
	
end

------------------------------------------------------------------
--PLAYER EVENTS
------------------------------------------------------------------
function LegacyUI:OnPlayerGroupStatusChanged(isInGroup)
	
end

------------------------------------------------------------------
--ABILITY EVENTS
------------------------------------------------------------------
function LegacyUI:SortContainerCells(container)
	sort(container.cells,
		function(a, b)
			local dbpIndexA = FindTableIndex(container.dbp.abilities, a.ability.id)
			local dbpIndexB = FindTableIndex(container.dbp.abilities, b.ability.id)
			return dbpIndexA < dbpIndexB
		end
	)
end

function LegacyUI:OnAbilityAdded(ability)
	local container
	
	--see if it belongs to any containers in the profile
	for _, c in ipairs(Containers) do
		for i, id in ipairs(c.dbp.abilities) do
			if id == ability.id then
				--it belongs to this continer
				container = c
				break
			end
		end
	end
	
	--add it to default container
	if not container then
		container = DefaultContainer
		tinsert(container.dbp.abilities, ability.id) --add it to the sort profile at the end
	end
	
	--get an available cell
	local cell = self:GetFreeCell(ability)
	
	--remove cell from RecycledContainers
	DeleteFromIndexedTable(RecycledCells.Cells, cell)
	
	--add cell to container
	tinsert(container.cells, cell)
	
	--setup initiail cell properties based on container profile and ability
	self:InitializeCell(container, cell, ability)

	--sort the cells by profile sort order
	self:SortContainerCells(container)
	
	self:PositionCells(container)
	
	self:SetContainerToVirtualSize(container)
end

function LegacyUI:OnAbilityRemoved(ability)
	--locate the container and cell for the ability
	local container, cell = LegacyUI:GetContainerAndCellForExistingAbility(ability)
	
	--recycle the cell
	LegacyUI:RecycleCell(container, cell)
	
	--sort the cells by profile sort order
	self:SortContainerCells(container)
	
	--update display
	self:PositionCells(container)
	
	self:SetContainerToVirtualSize(container)
end

function LegacyUI:OnAbilityAvailableSendersChanged(ability)
	local container, cell = LegacyUI:GetContainerAndCellForExistingAbility(ability)
	--first change the style as needed
	self:UpdateCellButtonStyle(cell)
	if self:SetCellVisibilityForCell(cell) == true then
		self:PositionCells(cell.container)
	end
	
	if(ToolTip and ToolTip.cell and ToolTip.cell == cell) then
		--refresh the tooltip since it's being displayed for this cell
		self:RefreshTooltip()
	end
end

function LegacyUI:OnAbilityTotalSendersChanged(ability)
	local container, cell = LegacyUI:GetContainerAndCellForExistingAbility(ability)
	
	--first change the style as needed
	self:UpdateCellButtonStyle(cell)
	if self:SetCellVisibilityForCell(cell) == true then
		self:PositionCells(cell.container)
	end
	
	if(ToolTip and ToolTip.cell and ToolTip.cell == cell) then
		--refresh the tooltip since it's being displayed for this cell
		self:RefreshTooltip()
	end
end

------------------------------------------------------------------
--ABILITYINSTANCE EVENTS
------------------------------------------------------------------
function LegacyUI:OnAbilityInstanceAdded(instance)
	local container, cell = LegacyUI:GetContainerAndCellForExistingAbility(instance.ability)
	
	--we need to figure out if there's an empty bar we can use or if we need to create a new one
	local bar
	
	for _, b in ipairs(cell.bars) do
		if not b.instance then
			--this one's available
			bar = b
			break
		end
	end
	
	if not bar then
		--grab a fresh one
		bar = self:GetFreeBar()
		DeleteFromIndexedTable(RecycledBars.Bars, bar)
		tinsert(cell.bars, bar)
	end
	
	self:InitializeSpellBar(cell, bar, instance)
	self:SortBars(cell)
	self:PositionSpellBars(cell)
	
	if(ToolTip and ToolTip.cell and ToolTip.cell == cell) then
		--refresh the tooltip since it's being displayed for this cell
		self:RefreshTooltip()
	end
end

function LegacyUI:OnAbilityInstanceRemoved(instance)
	local container, cell = LegacyUI:GetContainerAndCellForExistingAbility(instance.ability)
	local bar = self:GetBarForInstance(cell, instance)
	self:InitializeSpellBar(cell, bar, nil)
	self:ReleaseExtraBars(cell)
	self:SortBars(cell)
	self:PositionSpellBars(cell)
	
	if(ToolTip and ToolTip.cell and ToolTip.cell == cell) then
		--refresh the tooltip since it's being displayed for this cell
		self:RefreshTooltip()
	end
end

function LegacyUI:OnAbilityInstanceStartCooldown(instance)
	local container, cell = LegacyUI:GetContainerAndCellForExistingAbility(instance.ability)
	local bar = self:GetBarForInstance(cell, instance)
	self:SortBars(cell)	
	self:PositionSpellBars(cell)
	self:SetSpellBarStyle(bar)
	self:UpdateSpellBarAnimations(bar)
	
	if(ToolTip and ToolTip.cell and ToolTip.cell == bar.cell) then
		--refresh the tooltip since it's being displayed for this cell
		self:RefreshTooltip()
	end
end

function LegacyUI:OnAbilityInstanceUpdateCooldown(instance)
	local container, cell = LegacyUI:GetContainerAndCellForExistingAbility(instance.ability)
	local bar = self:GetBarForInstance(cell, instance)
	self:UpdateSpellBarAnimations(bar)
	
	if(ToolTip and ToolTip.cell and ToolTip.cell == bar.cell) then
		--refresh the tooltip since it's being displayed for this cell
		self:RefreshTooltip()
	end
end

function LegacyUI:OnAbilityInstanceStopCooldown(instance)
	local container, cell = LegacyUI:GetContainerAndCellForExistingAbility(instance.ability)
	local bar = self:GetBarForInstance(cell, instance)
	bar.rtext:SetText(nil)
	self:SortBars(cell)	
	self:PositionSpellBars(cell)
	self:SetSpellBarStyle(bar)
	self:UpdateSpellBarAnimations(bar)
	
	if(ToolTip and ToolTip.cell and ToolTip.cell == bar.cell) then
		--refresh the tooltip since it's being displayed for this cell
		self:RefreshTooltip()
	end
end

function LegacyUI:OnAbilityInstanceAvailabilityChanged(instance)
	local container, cell = LegacyUI:GetContainerAndCellForExistingAbility(instance.ability)
	local bar = self:GetBarForInstance(cell, instance)
	self:SortBars(cell)	
	self:PositionSpellBars(cell)
	self:SetSpellBarStyle(bar)
	self:UpdateSpellBarAnimations(bar)
	
	if(ToolTip and ToolTip.cell and ToolTip.cell == bar.cell) then
		--refresh the tooltip since it's being displayed for this cell
		self:RefreshTooltip()
	end
end

------------------------------------------------------------------
--LibSharedMedia
------------------------------------------------------------------
function LegacyUI:UpdateUsedMedia(event, mediatype, key)
	--update all the cells in the container
	if mediatype == "statusbar" or mediatype == "font" then
		if Containers then
			for _, container in ipairs(Containers) do
				for _, cell in ipairs(container.cells) do
					local realCell = self:GetRealCell(cell)
					self:UpdateCellStyle(realCell)
					self:UpdateCellButtonStyle(realCell)
					self:UpdateNamePlateVisuals(realCell.nameplate)
										
					for _, bar in ipairs(realCell.bars) do
						self:UpdateSpellBarVisuals(bar)
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------
--LibButtonFacade
--------------------------------------------------------------------
function LBFLegacyUI.SetupGroup()
	local group = LBF:Group(LBFLegacyUI.Name, MODNAME);
end

function LBFLegacyUI.RegisterSkin(arg, skin, gloss, backdrop, group, button, colors)
	if(group and group == MODNAME) then
		LegacyUI:UpdateButtonBorders(nil, nil)
	end
end

function LegacyUI:SetupLBFGroup()
	LBFLegacyUI.SetupGroup()
end

function LegacyUI:UpdateButtonBorders(container, cell)
	if(container) then
		if(cell) then
			local realCell = self:GetRealCell(cell)
			if(realCell.ability.class and realCell.ability.class ~= "ANY") then
				local c = Hermes:GetClassColorRGB(realCell.ability.class)
				if(LBF) then
					--backup the original color if not already exists
					if(not realCell.button.lbf_nvcd) then
						realCell.button.lbf_nvcd = {}
						realCell.button.lbf_nvcd.r, realCell.button.lbf_nvcd.g, realCell.button.lbf_nvcd.b, realCell.button.lbf_nvcd.a = LBF:GetNormalVertexColor(realCell.button)
					end
					
					if(container.dbp.btnColor and container.dbp.btnColor == true) then
						LBF:SetNormalVertexColor(realCell.button, c.r, c.g, c.b, c.a)
					else
						LBF:SetNormalVertexColor(realCell.button,
							realCell.button.lbf_nvcd.r,
							realCell.button.lbf_nvcd.g,
							realCell.button.lbf_nvcd.b,
							realCell.button.lbf_nvcd.a)
					end
				else
					if(container.dbp.btnColor and container.dbp.btnColor == true) then
						realCell.button.normaltexture:SetVertexColor(c.r, c.g, c.b, c.a)
					else
						realCell.button.normaltexture:SetVertexColor(
							realCell.button.nvcd.r,
							realCell.button.nvcd.g,
							realCell.button.nvcd.b,
							realCell.button.nvcd.a)
					end
				end
			end	
		else
			for _, c in ipairs(container.cells) do
				self:UpdateButtonBorders(container, c)
			end
		end
	else
		for _, c in ipairs(Containers) do
			self:UpdateButtonBorders(c, nil)
		end
	end
end

------------------------------------------------------------------
--HELPERS
------------------------------------------------------------------
function LegacyUI:GetContainerAndCellForExistingAbility(ability)
	local container = nil
	local cell = nil
	for _, x in ipairs(Containers) do
		for _, y in ipairs(x.cells) do
			if y.ability == ability then
				container = x
				cell = y
				break
			end
		end
	end

	--we didn't find the cell, maybe it's being dragged
	if not container and not cell then
		if DragHandler.dragCell and DragHandler.dragCell.ability == ability then
			container = DragHandler.dragCell.container
			cell = DragHandler.dragCell
		end
	end
	
	if not container then error("failed to locate container for ability") end
	if not cell then error("failed to locate cell for ability") end
	
	return container, cell
end

------------------------------------------------------------------
--VIRTUAL GRID PROVIDER
------------------------------------------------------------------
function LegacyUI:VGP_GetCellSize(container)
	local v_width, v_height, a_width, a_height
	local num_bars = container.dbp.cellMax
	
	if(container.dbp.style == "Bars" and container.dbp.cellDir == false) then
		--vertical tictacs
		v_width = container.dbp.barW + container.dbp.padding + (container.dbp.barPadding * 2)
		a_width = container.dbp.barW + (container.dbp.barPadding * 2)
		
		v_height = ((container.dbp.barH + container.dbp.barGap) * num_bars) + container.dbp.padding + (container.dbp.barPadding * 2)
		a_height = ((container.dbp.barH + container.dbp.barGap) * num_bars) + (container.dbp.barPadding * 2)
		
		--reduce height by one gap amount so that we don't have extra gap after the last tictac
		v_height = v_height - container.dbp.barGap
		a_height = a_height - container.dbp.barGap

		if container.dbp.npUseNameplate == true then 
			--add the height of the nameplate + the size of the BARFRAME_INSET_SIZE
			v_height = v_height + container.dbp.npH + container.dbp.barPadding
			a_height = a_height + container.dbp.npH + container.dbp.barPadding
		else
			
		end
		
	elseif(container.dbp.style == "Bars" and container.dbp.cellDir == true) then
		--horizontal tictacs
		v_width = ((container.dbp.barW + container.dbp.barGap) * num_bars) + container.dbp.padding + (container.dbp.barPadding * 2)
		a_width = ((container.dbp.barW + container.dbp.barGap) * num_bars) + (container.dbp.barPadding * 2)
		
		v_height = container.dbp.barH + container.dbp.padding + (container.dbp.barPadding * 2)
		a_height = container.dbp.barH + (container.dbp.barPadding * 2)
		
		--reduce width by one gap amount so that we don't have extra gap after the last tictac
		v_width = v_width - container.dbp.barGap
		a_width = a_width - container.dbp.barGap

		if container.dbp.npUseNameplate == true then 
			--add the width of the nameplate + the size of the BARFRAME_INSET_SIZE
			v_width = v_width + container.dbp.npW + container.dbp.barPadding
			a_width = a_width + container.dbp.npW + container.dbp.barPadding
		else
		
		end
	else
		--no bars
		v_width = ICONSIZE_LARGE + container.dbp.padding
		a_width = ICONSIZE_LARGE
		v_height = ICONSIZE_LARGE + container.dbp.padding
		a_height = ICONSIZE_LARGE
	end

	return v_width, v_height, a_width, a_height
end

function LegacyUI:VGP_GetCellCoordinates(container, column, row)
	local anchor, multY, multX = self:GetCellAnchor(container)
	local v_width, v_height, a_width, a_height = self:VGP_GetCellSize(container)
	local x, y

	local cellcenterX = ((column - 1) * v_width) + (v_width / 2)
	local cellcenterY = ((row - 1) * v_height) + (v_height / 2)

	x = ( cellcenterX - (v_width / 2)) * multX
	y = ( cellcenterY - (v_height / 2)) * multY

	return anchor, x, y
end

------------------------------------------------------------------
--CONTAINER
------------------------------------------------------------------
function LegacyUI:GetPositionRelativeToCellAnchor(container)
	if(container.dbp.cellAnchor == "TOPLEFT") then
		return container:GetLeft(), container:GetTop()
	elseif(container.dbp.cellAnchor == "TOPRIGHT") then
		return container:GetRight(), container:GetTop()
	elseif(container.dbp.cellAnchor == "BOTTOMLEFT") then
		return container:GetLeft(), container:GetBottom()
	elseif(container.dbp.cellAnchor == "BOTTOMRIGHT") then
		return container:GetRight(), container:GetBottom()
	end
end

function LegacyUI:SetPositionRelativeToCellAnchor(container, x, y)
	--this is a matter of setting the window topleft corner relative to the anchor
	if(container.dbp.cellAnchor == "TOPLEFT") then
		--just set x and y
		container.dbp.x = x
		container.dbp.y = y
	elseif(container.dbp.cellAnchor == "TOPRIGHT") then
		local deltaX = container:GetRight() - x
		local deltaY = container:GetTop() - y
		container.dbp.x = container.dbp.x - deltaX
		container.dbp.y = container.dbp.y - deltaY
	elseif(container.dbp.cellAnchor == "BOTTOMLEFT") then
		local deltaX = container:GetLeft() - x
		local deltaY = container:GetBottom() - y
		container.dbp.x = container.dbp.x - deltaX
		container.dbp.y = container.dbp.y - deltaY
	elseif(container.dbp.cellAnchor == "BOTTOMRIGHT") then
		local deltaX = container:GetRight() - x
		local deltaY = container:GetBottom() - y
		container.dbp.x = container.dbp.x - deltaX
		container.dbp.y = container.dbp.y - deltaY
	end
	
	self:RestoreContainerPosition(container) --nothing fancy required, it's already top left
	self:PositionCells(container)
end

function LegacyUI:RecycleContainers()
	while #Containers > 0 do
		self:RecycleContainer(Containers[1])
	end
end

function LegacyUI:RecycleContainer(container)
	container:SetScript("OnUpdate", nil)
	container.timer = 0
	self:RecycleCells(container)
	DeleteFromIndexedTable(Containers, container)
	tinsert(RecycledContainers.Containers, container)
	
	container:SetParent(RecycledContainers)
	container:ClearAllPoints()
	container.dbp = nil -- IS THIS GOING TO JACK THE OPTIONS?
	container.VirtualWidth = LAYOUT_FRAME_MINWIDTH
	container.VirtualHeight = LAYOUT_FRAME_MINHEIGHT
end

local function OnContainerDragStart(container, button)
	if(dbp.locked == false) then
		container:StartMoving()
	end
end

local function OnContainerDragStop(container, button)
	container:StopMovingOrSizing()
	container.resizer:StopMovingOrSizing()
	LegacyUI:SaveContainerPosition(container)
end

local function OnContainerSizeChanged(container, width, height)
	LegacyUI:PositionCells(container)
end

function LegacyUI:GetCellAnchor(container)
	local cellanchor = container.dbp.cellAnchor
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

function LegacyUI:PositionCells(container)
	local v_width, v_height, a_width, a_height = self:VGP_GetCellSize(container)

	local columnsPerRow = floor(container:GetWidth() / v_width)

	if(columnsPerRow <= 0) then
		columnsPerRow = 1
	end
	
	--these values are used for determining virtual layout size
	local maxRows = 1 --always make sure there is at least 1, even if there isn't
	local maxColumns = 1 --always make sure there is at least 1, even if there isn't
	
	local row = 1
	local column = 1
	
	for i, cell in ipairs(container.cells) do
		if cell.hide ~= true or DragHandler.dragging then --show all cells if we're dragging
			local anchor, x, y = self:VGP_GetCellCoordinates(container, column, row)
			self:PositionCell(container, cell, anchor, x, y, a_width, a_height)
			--increment columns/row counts
			if(i < #container.cells) then
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

	self:UpdateContainerVirtualSize(container, maxRows, maxColumns, v_width, v_height)
end

function LegacyUI:PositionCell(container, cell, anchor, x, y, width, height)
	cell:ClearAllPoints()
	cell:SetPoint(anchor, container, anchor, x, y)
	cell:SetHeight(height)
	cell:SetWidth(width)
end

function LegacyUI:UpdateContainerVirtualSize(container, numRows, numColumns, cellw, cellh)
	local width, height
	
	width = cellw * numColumns
	height = cellh * numRows
	
	width = width + (RESIZER_SIZE / 3)
	height = height + (RESIZER_SIZE / 3)
	
	if(container:GetWidth() > width) then
		width = container:GetWidth()
	end
	if(container:GetHeight() > height) then
		height = container:GetHeight()
	end
	
	if(width <= (ICONSIZE_LARGE + RESIZER_SIZE / 3)) then
		width = ICONSIZE_LARGE + (RESIZER_SIZE / 3) --always make sure the resizer is clickable
	end
	
	if(height <= (ICONSIZE_LARGE + RESIZER_SIZE / 3)) then
		height = ICONSIZE_LARGE + (RESIZER_SIZE / 3) --always make sure the resizer is clickable
	end

	container.VirtualWidth = width
	container.VirtualHeight = height
end

function LegacyUI:SetContainerToVirtualSize(container)
	local left = container:GetLeft()
	local top = container:GetTop()
	local right = container:GetRight()
	local bottom = container:GetBottom()
	
	container:ClearAllPoints()
	if container.dbp.cellAnchor == "TOPLEFT" then
		container:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
		container:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", left + container.VirtualWidth, top - container.VirtualHeight)

	elseif container.dbp.cellAnchor == "TOPRIGHT" then
		container:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", right, top)
		container:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", right - container.VirtualWidth, top - container.VirtualHeight)
		
	elseif container.dbp.cellAnchor == "BOTTOMLEFT" then
		container:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bottom)
		container:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", left + container.VirtualWidth, bottom + container.VirtualHeight)

	elseif container.dbp.cellAnchor == "BOTTOMRIGHT" then
		container:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", right, bottom)
		container:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", right - container.VirtualWidth, bottom + container.VirtualHeight)
	end

	container:SetHeight(container.VirtualHeight) --this is VERY important. You'd think it would be obsolete but without it the position saving detects the wrong width and height. No doubt a consequence on me trying to keep the window from moving 
	container:SetWidth(container.VirtualWidth) --this is VERY important. You'd think it would be obsolete but without it the position saving detects the wrong width and height. No doubt a consequence on me trying to keep the window from moving 

	LegacyUI:SaveContainerPosition(container)
end

function LegacyUI:SaveContainerPosition(container)
	container.dbp.x = container:GetLeft()
	container.dbp.y = container:GetTop()
	container.dbp.w = container:GetWidth()
	container.dbp.h = container:GetHeight()
	container:SetUserPlaced(false)
end

function LegacyUI:CreateRecycledContainerFrame()
	--only create if not already exists
	if not RecycledContainers then
		RecycledContainers = CreateFrame("Frame", nil, UIParent)
		RecycledContainers:SetPoint("CENTER")
		RecycledContainers:SetWidth(50)
		RecycledContainers:SetHeight(50)
		RecycledContainers:Hide()

		RecycledContainers:EnableMouse(false)
		RecycledContainers:SetMovable(false)
		RecycledContainers:SetToplevel(false)
		RecycledContainers.Containers = {}
	end
end

function LegacyUI:UpdateContainerLocking(container)
	if(container) then
		if(dbp.locked == false) then
			container:SetBackdropColor(
				0,
				0,
				0,
				0.3)
			container:EnableMouse(true)
			container.resizer:EnableMouse(true)
			container.resizer:Show()
		else
			container:SetBackdropColor(
				0,
				0,
				0,
				0)
			container:EnableMouse(false) --allow to click through the frame with mouse
			container.resizer:EnableMouse(false)
			container.resizer:Hide()
		end
		
		for _, cell in ipairs(container.cells) do
			self:UpdateCellLocking(cell)
		end
	else
		for _, c in ipairs(Containers) do
			self:UpdateContainerLocking(c)
		end
	end
end

local function OnContainerUpdate(container, elapsed)
	container.timer = container.timer + elapsed
	if container.timer >= CONTAINER_ONUPDATETHROTTLE then
		if not DragHandler.dragging and container:IsMouseOver() then --don't bother if we're dragging
			--see if it's over any cells
			for _, cell in ipairs(container.cells) do
				if cell:IsMouseOver() then
					--release the tooltip as the cell changed
					if ToolTip and ToolTip.cell ~= cell then
						QTip:Release(ToolTip)
						ToolTip = nil
					end
					--don't show the tooltip if we're dragging or it's already being shown for the same cell
					if not ToolTip then
						LegacyUI:ShowTooltip(cell, cell)
					end
					container.timer = 0
					return --break here to ensure we don't later release the tooltip
				end
			end
			
			--if we've made it here, then we're not hovering over any cells in the container, so release the toolti if it exists
			if ToolTip then
				QTip:Release(ToolTip)
				ToolTip = nil
			end
		else
			--we're not over this container, let's see if the tooltip needs to be released or not.
			--it's possible it's being shown for a cell in a different container, so only release if the container matches this one.
			if ToolTip and ToolTip.cell.container == container then
				QTip:Release(ToolTip)
				ToolTip = nil
			end
		end
		
		--reset the timer if not already reset
		container.timer = 0
	end
end

function LegacyUI:UpdateContainerTooltipEnabledState(container)
	if container.dbp.enableTooltip == true then
		--enable tooltip scanning
		container:SetScript("OnUpdate", OnContainerUpdate)
	else
		--disable tooltip scanning
		container:SetScript("OnUpdate", nil)
	end
end

function LegacyUI:InitializeContainerFromProfile(container, dbp)
	container.dbp = dbp
	container:SetParent(UIParent)
	container:SetScale(dbp.scale)
	container:SetMinResize(ICONSIZE_LARGE, ICONSIZE_LARGE)

	container.timer = 0
	self:UpdateContainerTooltipEnabledState(container)
	self:RestoreContainerPosition(container)
	self:UpdateContainerResizerPosition(container)
	self:UpdateContainerLocking(container)
	
	container:Hide()
end

local function RotateTexture(self, angle)
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

function LegacyUI:UpdateContainerResizerPosition(container)
	local anchor

	if container.dbp.cellAnchor == "TOPLEFT" then --good
		anchor = "BOTTOMRIGHT"
		RotateTexture(container.resizer.texture, 0)
		
	elseif container.dbp.cellAnchor == "TOPRIGHT" then --good
		anchor = "BOTTOMLEFT"
		RotateTexture(container.resizer.texture, -90)
		
	elseif container.dbp.cellAnchor == "BOTTOMLEFT" then --good
		anchor = "TOPRIGHT"
		RotateTexture(container.resizer.texture, 90)
		
	elseif container.dbp.cellAnchor == "BOTTOMRIGHT" then
		anchor = "TOPLEFT"
		RotateTexture(container.resizer.texture, 180)
		
	else
		anchor = "BOTTOMRIGHT"
		RotateTexture(container.resizer.texture, 0)
		
	end
	
	container.resizer:ClearAllPoints()
	container.resizer:SetPoint(anchor)
	container.resizer:SetScript("OnMouseDown", function() container.resizer:StopMovingOrSizing() container:StopMovingOrSizing() container:StartSizing(anchor) end)
end

function LegacyUI:RestoreContainerPosition(container)				--sets the starting point for all window positions based on profile settings (if it exists)
	if(not container.dbp.x or not container.dbp.y) then
		container:ClearAllPoints()
		container:SetPoint("CENTER", UIParent, "CENTER")
		container:SetWidth(LAYOUT_FRAME_MINWIDTH)
		container:SetHeight(LAYOUT_FRAME_MINHEIGHT)
		container.dbp.x = container:GetLeft()
		container.dbp.y = container:GetTop()
		container.dbp.w = LAYOUT_FRAME_MINWIDTH
		container.dbp.h = LAYOUT_FRAME_MINHEIGHT
	else
		container:ClearAllPoints()
		container:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT",
			container.dbp.x,
			container.dbp.y
		)
		container:SetWidth(container.dbp.w)
		container:SetHeight(container.dbp.h)
		self:PositionCells(container)
	end

	container:SetUserPlaced(nil)
end

function LegacyUI:GetFreeContainer()
	--get cached or new container
	local container
	if(RecycledContainers.Containers and #RecycledContainers.Containers > 0) then
		container = RecycledContainers.Containers[1]
	else
		container = self:CreateContainerFrame()
	end
	
	--remove from RecycledContainers
	DeleteFromIndexedTable(RecycledContainers.Containers, container)
	
	--add to Containers
	tinsert(Containers, container)

	return container
end

function LegacyUI:CreateContainerFrame()
	local container = CreateFrame("Frame", nil, UIParent)
	container.id = UNIQUE_FRAME_COUNT
	container:Hide()
	container:EnableMouse(true)
	container:SetMovable(true)
	container:SetResizable(true)
	container:SetUserPlaced(false)
	container:SetToplevel(false)
	container:SetWidth(LAYOUT_FRAME_MINWIDTH)
	container:SetHeight(LAYOUT_FRAME_MINHEIGHT)
	container:RegisterForDrag("LeftButton");
	container:SetScript("OnDragStart", OnContainerDragStart)
	container:SetScript("OnDragStop", OnContainerDragStop)
	container:SetScript("OnSizeChanged", OnContainerSizeChanged)
	container:SetScript("OnHide", function() container:StopMovingOrSizing() end) --this is a precautionary measure to HOPEFULLY avoid any frames stuck to cursor issues while dragging if the frame gets hidden while dragging it (due to combat events)
	container:SetBackdrop({
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
		
	container.cells = {}
	
	container.resizer = CreateFrame("Frame", nil, container)
	container.resizer:SetWidth(RESIZER_SIZE)
	container.resizer:SetHeight(RESIZER_SIZE)
	container.resizer:EnableMouse(true)
	container.resizer:RegisterForDrag("LeftButton")
	container.resizer:SetPoint("BOTTOMRIGHT")
	container.resizer:SetScript("OnMouseDown", function() container.resizer:StopMovingOrSizing() container:StopMovingOrSizing() container:StartSizing() end)
	container.resizer:SetScript("OnMouseUp", function() container.resizer:StopMovingOrSizing() container:StopMovingOrSizing() LegacyUI:SetContainerToVirtualSize(container) end)
	container.resizer.texture = container.resizer:CreateTexture()
	container.resizer.texture:SetTexture(IMAGE_RESIZE)
	container.resizer.texture:SetDrawLayer("OVERLAY")
	container.resizer.texture:SetAllPoints()

	container.dragPlaceHolder = self:CreateDragPlaceHolderFrame(container)
	
	tinsert(RecycledContainers.Containers, container)
	UNIQUE_FRAME_COUNT = UNIQUE_FRAME_COUNT + 1
	
	return container
end

function LegacyUI:InitializeContainers()
	if(not Containers) then
		Containers = {}
	end
	
	for i, db in ipairs(dbp.containers) do
		local container = self:CreateContainer(db)
		if(not container.dbp.name) then
			DefaultContainer = container --store handy reference to default container
		end
	end
end

function LegacyUI:CreateContainer(db)
	local container = self:GetFreeContainer()
	self:InitializeContainerFromProfile(container, db)
	return container
end

function LegacyUI:ApplyContainerStyleToCell(cell)
	if cell.container.dbp.style == "Buttons" then
		--buttons
		cell.button:Show()
		cell.nameplate:Hide()
		self:ShowSpellBars(cell, false)
	else
		--bars
		cell.button:Hide()
		cell.nameplate:Show()
		self:ShowSpellBars(cell, true)
	end
end

------------------------------------------------------------------
--CELL
------------------------------------------------------------------
function LegacyUI:UpdateCellStyle(cell)
	cell.backgroundTexture:SetTexture(
		cell.container.dbp.cellBGColor.r,
		cell.container.dbp.cellBGColor.g,
		cell.container.dbp.cellBGColor.b,
		cell.container.dbp.cellBGColor.a)
end

function LegacyUI:EnsureMinimumBarCount(cell)
	local countChanged = false
	while #cell.bars < cell.container.dbp.cellMax do
		local bar = self:GetFreeBar()
		DeleteFromIndexedTable(RecycledBars.Bars, bar)
		tinsert(cell.bars, bar)
		self:InitializeSpellBar(cell, bar, nil)
		countChanged = true
	end
	
	if countChanged == true then
		self:SortBars(cell)
	end
end

function LegacyUI:ReleaseExtraBars(cell) -- recursive function that removes unneeded bars (recycles them)
	local deletedBar = nil
	
	--if the amount of existing bars is greater than the max viewable bars
	if #cell.bars > cell.container.dbp.cellMax then
		for _, bar in ipairs(cell.bars) do
			if not bar.instance then
				deletedBar = bar
				break
			end
		end
	end
	
	if deletedBar then
		LegacyUI:RecycleSpellBar(deletedBar)
		--we need to reposition/draw the bars now
		self:SortBars(cell)
		self:PositionSpellBars(cell)
		--cal again recursively
		self:ReleaseExtraBars(cell)
	end
end

function LegacyUI:SetCellVisibilityForAllCells(container)
	local changed = false
	
	for _, cell in ipairs(container.cells) do
		changed = self:SetCellVisibilityForCell(cell) == true or changed
	end
	
	return changed
end

function LegacyUI:SetCellVisibilityForCell(cell)
	local realCell = self:GetRealCell(cell)
	
	local wasHidden = realCell.hide

	local min_time, total, oncooldown, available, unavailable = Hermes:GetAbilityStats(realCell.ability)
	
	--figure out new style
	if total == 0 then
		realCell.hide = realCell.container.dbp.cellHideNoSender == true --always hide if no senders
	else
		realCell.hide = (total == unavailable) and (realCell.container.dbp.cellHideNoAvailSender == true) --hide if no available senders
	end
	
	if (wasHidden ~= realCell.hide) then
		return true
	end
	
	return false
end

function LegacyUI:UpdateCellLocking(cell)
	--if dbp.locked == false or cell.container.dbp.style == "Buttons" then
	if dbp.locked == false then
		cell:EnableMouse(true)
	else
		cell:EnableMouse(false)
	end
end

function LegacyUI:UpdateCellButtonStyle(cell)
	local oldStyle = cell.style --nil if style never configured before
	
	local min_time, total, oncooldown, available, unavailable = Hermes:GetAbilityStats(cell.ability)
	
	if total == 0 then
		cell.style = "nosenders"
		self:UpdateCellButtonStyleNoSenders(cell, oldStyle ~= cell.style)
	else
		if available > 0 then
			cell.style = "available"
			self:UpdateCellButtonStyleAvailable(cell, min_time, available, oldStyle ~= cell.style)
		else
			--available = 0
			if oncooldown > 0 then
				cell.style = "oncooldown"
				self:UpdateCellButtonStyleOnCooldown(cell, min_time, available, oldStyle ~= cell.style)
			else
				cell.style = "unavailable"
				self:UpdateCellButtonStyleUnavailable(cell, oldStyle ~= cell.style)
			end
		end
	end
end

function LegacyUI:UpdateCellButtonStyleAvailable(cell, min_time, available, full)
	--style
	if full == true then
		cell.button.icon:SetDesaturated(false)
		cell.button.icon:SetVertexColor(1, 1, 1, 1)
	end
		
	--properties
	cell.button.count:SetText(tostring(available))
	
	--this change was made as it no longer seems critical to check for a min_time. Also, I noticed
	--that if a warlock casts Ritual of Summoning, but cancels, and the spell becomes available again,
	--that hermes would show the button timer still, even though everything else was correct.
	
	--REVERTED above change ^^
	
	--stop the cooldown timer if needed. The reason for the 2 second check is to basically allow any prior animations to finsh animating.
	--2 seconds is arbritrary but seems fine.
	--if min_time and min_time > 2 then
	CooldownFrame_SetTimer(cell.button.cooldown, 0, 0, 0) --stop cooldown if it's running
	--end
end

function LegacyUI:UpdateCellButtonStyleOnCooldown(cell, min_time, available, full)
	--style
	if full == true then
		cell.button.count:SetText(nil)
		cell.button.icon:SetDesaturated(false)
		cell.button.icon:SetVertexColor(
			VertexColorUnavailable[1],
			VertexColorUnavailable[2],
			VertexColorUnavailable[3],
			VertexColorUnavailable[4])
	end
	
	CooldownFrame_SetTimer(cell.button.cooldown, GetTime(), min_time, 1) --start/reset cooldown
end

function LegacyUI:UpdateCellButtonStyleUnavailable(cell, full)
	--style
	if full == true then
		cell.button.count:SetText(nil)
		cell.button.icon:SetDesaturated(false)
		cell.button.icon:SetVertexColor(
			VertexColorUnavailable[1],
			VertexColorUnavailable[2],
			VertexColorUnavailable[3],
			VertexColorUnavailable[4])
	end
	
	CooldownFrame_SetTimer(cell.button.cooldown, 0, 0, 0) --stop cooldown if it's running
end

function LegacyUI:UpdateCellButtonStyleNoSenders(cell, full)
	--style
	if full == true then
		cell.button.count:SetText(nil)
		cell.button.icon:SetDesaturated(true)
		cell.button.icon:SetVertexColor(
			VertexColorUnavailable[1],
			VertexColorUnavailable[2],
			VertexColorUnavailable[3],
			VertexColorUnavailable[4])
	end
	
	CooldownFrame_SetTimer(cell.button.cooldown, 0, 0, 0) --stop cooldown if it's running
end

function LegacyUI:CreateRecycledCellFrame()
	if not RecycledCells then
		RecycledCells = CreateFrame("Frame", nil, UIParent)
		RecycledCells:SetPoint("CENTER")
		RecycledCells:SetWidth(50)
		RecycledCells:SetHeight(50)
		RecycledCells:Hide()

		RecycledCells:EnableMouse(false)
		RecycledCells:SetMovable(false)
		RecycledCells:SetToplevel(false)
		RecycledCells.Cells = {}
	end
end

function LegacyUI:InitializeCell(container, cell, ability)
	--Initializes the cell, but it will not become visible until points are set and it's shown
	---------------------------------------------------------------
	-- CELL
	---------------------------------------------------------------
	cell.container = container
	cell.ability = ability
	cell:SetParent(container)
	cell:ClearAllPoints()
	
	cell:SetScript("OnDragStart", OnCellDragStart)
	cell:SetScript("OnDragStop", OnCellDragStop)
	--cell:SetScript("OnEnter", OnCellEnter)
	--cell:SetScript("OnLeave", OnCellLeave)
	
	self:UpdateCellLocking(cell)
	
	---------------------------------------------------------------
	-- CELL.BUTTON
	---------------------------------------------------------------
	cell.button.icon:SetTexture(ability.icon)
	
	---------------------------------------------------------------
	-- CELL.BACKGROUNDTEXTURE
	---------------------------------------------------------------
	self:UpdateCellStyle(cell)
	
	---------------------------------------------------------------
	-- CELL.NAMEPLATE
	---------------------------------------------------------------
	cell.nameplate = self:GetFreeBar()
	DeleteFromIndexedTable(RecycledBars.Bars, cell.nameplate)
	self:InitializeNameplateBar(cell, cell.nameplate, ability)
	
	---------------------------------------------------------------
	-- CELL.BARS
	---------------------------------------------------------------
	self:EnsureMinimumBarCount(cell) --creates and initializes spell bars

	self:SetCellVisibilityForCell(cell)
	self:UpdateCellButtonStyle(cell)
	
	--arrange the nameplate and spell bars
	self:PositionSpellBars(cell)	

	self:UpdateButtonBorders(container, cell)
	
	--hides/shows winows based on style
	self:ApplyContainerStyleToCell(cell)
end

function LegacyUI:RecycleCell(container, cell)
	--move cell to recycled cells
	DeleteFromIndexedTable(container.cells, cell)
	tinsert(RecycledCells.Cells, cell)
	
	---------------------------------------------------------------
	-- CELL
	---------------------------------------------------------------
	cell:Hide()
	cell.hide = true
	cell.style = nil
	cell:SetParent(RecycledCells)
	cell:SetAllPoints()
	cell.container = nil
	cell.ability = nil
	
	cell:SetScript("OnDragStart", nil)
	cell:SetScript("OnDragStop", nil)
	--cell:SetScript("OnEnter", nil)
	--cell:SetScript("OnLeave", nil)

	---------------------------------------------------------------
	-- CELL.BUTTON
	---------------------------------------------------------------
	cell.button.icon:SetTexture("")
	cell.button.icon:SetDesaturated(true)
	
	---------------------------------------------------------------
	-- CELL.BACKGROUNDTEXTURE
	---------------------------------------------------------------
	cell.backgroundTexture:SetTexture("")
	
	---------------------------------------------------------------
	-- CELL.NAMEPLATE
	---------------------------------------------------------------
	self:RecycleNameplateBar(cell.nameplate)
	
	---------------------------------------------------------------
	-- CELL.BARS
	---------------------------------------------------------------
	while #cell.bars > 0 do
		self:RecycleSpellBar(cell.bars[1])
	end
end

function LegacyUI:RecycleCells(container)
	if container.cells then
		while #container.cells > 0 do
			self:RecycleCell(container, container.cells[1])
		end
	end
end

function LegacyUI:CreateCellFrame()
	---------------------------------------------------------------
	-- CELL
	---------------------------------------------------------------
	local cell = CreateFrame("Frame", nil, RecycledCells)
	cell:Hide()
	cell.hide = true
	cell.style = nil
	cell.id = UNIQUE_CELL_COUNT
	cell:EnableMouse(true)
	cell:SetMovable(true)
	cell:SetResizable(false)
	cell:SetScript("OnHide", function() cell:StopMovingOrSizing() end) --this is a precautionary measure to HOPEFULLY avoid any frames stuck to cursor issues while dragging if the frame gets hidden while dragging it (due to combat events)
	cell:SetToplevel(true)
	cell:SetUserPlaced(nil)
	cell:RegisterForDrag("LeftButton");
	tinsert(RecycledCells.Cells, cell)
	UNIQUE_CELL_COUNT = UNIQUE_CELL_COUNT + 1
	
	---------------------------------------------------------------
	-- CELL.BUTTON
	---------------------------------------------------------------
	cell.button = CreateFrame("Button", "LegacyUIDisplayButton"..tostring(cell.id), cell, "ActionButtonTemplate")
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
	
	--LBF SUPPORT
	if(LBF) then
		LBF:Group(LBFLegacyUI.Name, MODNAME):AddButton(cell.button)
	else
		--we don't want to see the normal texture (which acts like a border for a checkbox) if we don't have button facade running)
		--hide doesn' work because once we click the button it'll show again, but we can clear all the points so it won't show
		cell.button.normaltexture:ClearAllPoints()
		cell.button.normaltexture:Hide()
	end
	
	cell.button:SetAllPoints(cell) --set all points to parent frame

	---------------------------------------------------------------
	-- CELL.BACKGROUNDTEXTURE
	---------------------------------------------------------------
	cell.backgroundTexture = cell:CreateTexture(nil, "BACKGROUND")
	cell.backgroundTexture:SetTexture("")
	cell.backgroundTexture:SetAllPoints(cell)
	
	---------------------------------------------------------------
	-- CELL.NAMEPLATE
	---------------------------------------------------------------
	cell.nameplate = nil
	
	---------------------------------------------------------------
	-- CELL.BARS
	---------------------------------------------------------------
	cell.bars = {}
	
	return cell
end

function LegacyUI:GetFreeCell()
	local cell
	if(#RecycledCells.Cells > 0) then
		cell = RecycledCells.Cells[1]
	else
		cell = self:CreateCellFrame()
	end

	return cell
end

function LegacyUI:PositionSpellBars(cell)
	--position the bars
	if cell.container.dbp.cellDir == false then
		self:PositionSpellBarsVertical(cell)
	else
		self:PositionSpellBarsHorizontal(cell)
	end
end

function LegacyUI:PositionSpellBarsVertical(cell)
	local dbp = cell.container.dbp
	
	local height = dbp.barH
	local width = dbp.barW
	local bars_to_display = dbp.cellMax
	
	cell.nameplate:ClearAllPoints()
	
	--first position the nameplate
	if dbp.npUseNameplate == true and dbp.style == "Bars" then 
		if(dbp.cellSide == false) then --down
			cell.nameplate:SetPoint("TOPLEFT", cell, "TOPLEFT", dbp.barPadding, -dbp.barPadding)
			cell.nameplate:SetPoint("TOPRIGHT", cell, "TOPRIGHT", -dbp.barPadding, -dbp.barPadding)
			cell.nameplate:SetHeight(dbp.npH)
			
			cell.nameplate.bgtexture:ClearAllPoints()
			cell.nameplate.bgtexture:SetPoint("TOPLEFT", cell, "TOPLEFT", dbp.barPadding, -dbp.barPadding)
			cell.nameplate.bgtexture:SetPoint("TOPRIGHT", cell, "TOPRIGHT", -dbp.barPadding, -dbp.barPadding)
			cell.nameplate.bgtexture:SetHeight(cell.container.dbp.npH)
			
			cell.nameplate.fgtexture:ClearAllPoints()
			cell.nameplate.fgtexture:SetPoint("TOPLEFT", cell, "TOPLEFT", dbp.barPadding, -dbp.barPadding)
			cell.nameplate.fgtexture:SetPoint("TOPRIGHT", cell, "TOPRIGHT", -dbp.barPadding, -dbp.barPadding)
			cell.nameplate.fgtexture:SetHeight(cell.container.dbp.npH)

			cell.nameplate.icon:ClearAllPoints()
			cell.nameplate.ltext:ClearAllPoints()
			
			if dbp.npUseIcon == true then
				cell.nameplate.icon:SetPoint("TOPLEFT", cell.nameplate, "TOPLEFT", ICON_OFFSET, -ICON_OFFSET)
				cell.nameplate.icon:SetHeight((dbp.npH) - (ICON_OFFSET * 2))
				cell.nameplate.icon:SetWidth((dbp.npH) - (ICON_OFFSET * 2))
				cell.nameplate.icon:Show()
				
				cell.nameplate.ltext:SetPoint("LEFT", cell.nameplate.icon, "RIGHT", STATUS_PADDING, 0)
				cell.nameplate.ltext:SetPoint("RIGHT", cell.nameplate, "RIGHT", -STATUS_PADDING, 0)
				cell.nameplate.ltext:SetHeight(dbp.npH - (STATUS_PADDING * 2))
			else
				cell.nameplate.icon:Hide()
			
				cell.nameplate.ltext:SetPoint("LEFT", cell.nameplate, "LEFT", STATUS_PADDING, 0)
				cell.nameplate.ltext:SetPoint("RIGHT", cell.nameplate, "RIGHT", -STATUS_PADDING, 0)
				cell.nameplate.ltext:SetHeight(dbp.npH - (STATUS_PADDING * 2))
			end
			
			cell.nameplate.rtext:ClearAllPoints()
		else --up
			cell.nameplate:SetPoint("BOTTOMLEFT", cell, "BOTTOMLEFT", dbp.barPadding, dbp.barPadding)
			cell.nameplate:SetPoint("BOTTOMRIGHT", cell, "BOTTOMRIGHT", -dbp.barPadding, dbp.barPadding)
			cell.nameplate:SetHeight(dbp.npH)
			
			cell.nameplate.bgtexture:ClearAllPoints()
			cell.nameplate.bgtexture:SetPoint("BOTTOMLEFT", cell, "BOTTOMLEFT", dbp.barPadding, dbp.barPadding)
			cell.nameplate.bgtexture:SetPoint("BOTTOMRIGHT", cell, "BOTTOMRIGHT", -dbp.barPadding, dbp.barPadding)
			cell.nameplate.bgtexture:SetHeight(dbp.npH)
			
			cell.nameplate.fgtexture:ClearAllPoints()
			cell.nameplate.fgtexture:SetPoint("BOTTOMLEFT", cell, "BOTTOMLEFT", dbp.barPadding, dbp.barPadding)
			cell.nameplate.fgtexture:SetPoint("BOTTOMRIGHT", cell, "BOTTOMRIGHT", -dbp.barPadding, dbp.barPadding)
			cell.nameplate.fgtexture:SetHeight(dbp.npH)

			cell.nameplate.icon:ClearAllPoints()
			cell.nameplate.ltext:ClearAllPoints()
			
			if dbp.npUseIcon == true then
				cell.nameplate.icon:SetPoint("TOPLEFT", cell.nameplate, "TOPLEFT", ICON_OFFSET, -ICON_OFFSET)
				cell.nameplate.icon:SetHeight((dbp.npH) - (ICON_OFFSET * 2))
				cell.nameplate.icon:SetWidth((dbp.npH) - (ICON_OFFSET * 2))
				cell.nameplate.icon:Show()
				
				cell.nameplate.ltext:SetPoint("LEFT", cell.nameplate.icon, "RIGHT", STATUS_PADDING, 0)
				cell.nameplate.ltext:SetPoint("RIGHT", cell.nameplate, "RIGHT", -STATUS_PADDING, 0)
				cell.nameplate.ltext:SetHeight(dbp.npH - (STATUS_PADDING * 2))
			else
				cell.nameplate.icon:Hide()
				
				cell.nameplate.ltext:SetPoint("LEFT", cell.nameplate, "LEFT", STATUS_PADDING, 0)
				cell.nameplate.ltext:SetPoint("RIGHT", cell.nameplate, "RIGHT", -STATUS_PADDING, 0)
				cell.nameplate.ltext:SetHeight(dbp.npH - (STATUS_PADDING * 2))
			end
			
			cell.nameplate.rtext:ClearAllPoints()
		end
		
		cell.nameplate:Show()
	else
		cell.nameplate:Hide()
	end
	
	local count = 1
	local namePlateOffset = dbp.npH
	if dbp.npUseNameplate == false then
		namePlateOffset = 0
	end
	
	for _, bar in ipairs(cell.bars) do
		if count <= bars_to_display then
			if dbp.hideNoCooldown == true and bar.instance and not bar.instance.remaining then
				--skip bars if hiding when not on cooldown
				count = count - 1
				bar:Hide()
				bar:ClearAllPoints()
			else
				local offsety, anchorTicTac, anchorNamePlate
				if(dbp.cellSide == false) then
					--down
					offsety = (((( count - 1 ) * (height + dbp.barGap)) * -1)) - (dbp.barPadding * 2) - namePlateOffset
					anchorTicTac = "TOP"
					anchorNamePlate = "TOP"
				else --up
					anchorTicTac = "BOTTOM"
					anchorNamePlate = "BOTTOM"
					offsety = ((( count - 1 ) * (height + dbp.barGap))) + (dbp.barPadding * 2) + namePlateOffset
				end

				bar:ClearAllPoints()
				bar:SetPoint(anchorTicTac, cell, anchorNamePlate, 0, offsety) --TOP assignment
				bar:SetPoint("LEFT", cell, "LEFT", dbp.barPadding, 0) --LEFT offset
				bar:SetPoint("RIGHT", cell, "RIGHT", -dbp.barPadding, 0) --RIGHT offset
				bar:SetHeight(height)
				
				bar.bgtexture:ClearAllPoints()
				bar.bgtexture:SetPoint(anchorTicTac, cell, anchorNamePlate, 0, offsety) --TOP assignment
				bar.bgtexture:SetPoint("LEFT", cell, "LEFT", dbp.barPadding, 0) --LEFT offset
				bar.bgtexture:SetHeight(height)
				
				bar.fgtexture:ClearAllPoints()
				bar.fgtexture:SetPoint(anchorTicTac, cell, anchorNamePlate, 0, offsety) --TOP assignment
				bar.fgtexture:SetPoint("LEFT", cell, "LEFT", dbp.barPadding, 0) --LEFT offset
				bar.fgtexture:SetHeight(height)
				
				self:UpdateSpellBarAnimations(bar)
				
				local w_player, w_duration = self:GetPlayerDurationWidthsForContainer(cell.container)
			
				bar.ltext:ClearAllPoints()
			
				if w_player > 0 then
					bar.ltext:SetPoint("LEFT", bar, "LEFT", STATUS_PADDING, 0)
					bar.ltext:SetWidth(w_player)
				end

				bar.rtext:ClearAllPoints()
			
				if w_duration > 0 then
					bar.rtext:SetPoint("RIGHT", bar, "RIGHT", -STATUS_PADDING, 0)
					bar.rtext:SetWidth(w_duration)
				end

				if dbp.style == "Bars" then
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

function LegacyUI:PositionSpellBarsHorizontal(cell)
	local dbp = cell.container.dbp
	
	local height = dbp.barH
	local width = dbp.barW
	local bars_to_display = dbp.cellMax
	
	cell.nameplate:ClearAllPoints()
	
	--first position the nameplate
	if dbp.npUseNameplate == true and dbp.style == "Bars" then
		if(dbp.cellSide == false) then --name plate on left
			cell.nameplate:SetPoint("TOPLEFT", cell, "TOPLEFT", dbp.barPadding, -dbp.barPadding)
			cell.nameplate:SetPoint("BOTTOMLEFT", cell, "TOPLEFT", dbp.barPadding, -dbp.barPadding - height)
			cell.nameplate:SetWidth(dbp.npW)
			
			cell.nameplate.bgtexture:ClearAllPoints()
			cell.nameplate.bgtexture:SetPoint("TOPLEFT", cell, "TOPLEFT", dbp.barPadding, -dbp.barPadding)
			cell.nameplate.bgtexture:SetPoint("BOTTOMLEFT", cell, "TOPLEFT", dbp.barPadding, -dbp.barPadding - height)
			cell.nameplate.bgtexture:SetWidth(dbp.npW)
			
			cell.nameplate.fgtexture:ClearAllPoints()
			cell.nameplate.fgtexture:SetPoint("TOPLEFT", cell, "TOPLEFT", dbp.barPadding, -dbp.barPadding)
			cell.nameplate.fgtexture:SetPoint("BOTTOMLEFT", cell, "TOPLEFT", dbp.barPadding, -dbp.barPadding - height)
			cell.nameplate.fgtexture:SetWidth(dbp.npW)
			
			cell.nameplate.icon:ClearAllPoints()
			cell.nameplate.ltext:ClearAllPoints()
			
			if dbp.npUseIcon == true then
				cell.nameplate.icon:SetPoint("TOPLEFT", cell.nameplate, "TOPLEFT", ICON_OFFSET, -ICON_OFFSET)
				cell.nameplate.icon:SetHeight((height) - (ICON_OFFSET * 2))
				cell.nameplate.icon:SetWidth((height) - (ICON_OFFSET * 2))
				cell.nameplate.icon:Show()
				
				cell.nameplate.ltext:SetPoint("LEFT", cell.nameplate.icon, "RIGHT", STATUS_PADDING, 0)
				cell.nameplate.ltext:SetPoint("RIGHT", cell.nameplate, "RIGHT", -STATUS_PADDING, 0)
				cell.nameplate.ltext:SetHeight(height - (STATUS_PADDING * 2))
			else
				cell.nameplate.icon:Hide()

				cell.nameplate.ltext:SetPoint("LEFT", cell.nameplate, "LEFT", STATUS_PADDING, 0)
				cell.nameplate.ltext:SetPoint("RIGHT", cell.nameplate, "RIGHT", -STATUS_PADDING, 0)
				cell.nameplate.ltext:SetHeight(height - (STATUS_PADDING * 2))
			end
			
			cell.nameplate.rtext:ClearAllPoints()
			
		else --name plate on the right
			cell.nameplate:SetPoint("TOPRIGHT", cell, "TOPRIGHT", -dbp.barPadding, -dbp.barPadding)
			cell.nameplate:SetPoint("BOTTOMRIGHT", cell, "TOPRIGHT", -dbp.barPadding, -dbp.barPadding - height)
			cell.nameplate:SetWidth(dbp.npW)
			
			cell.nameplate.bgtexture:ClearAllPoints()
			cell.nameplate.bgtexture:SetPoint("TOPRIGHT", cell, "TOPRIGHT", -dbp.barPadding, -dbp.barPadding)
			cell.nameplate.bgtexture:SetPoint("BOTTOMRIGHT", cell, "TOPRIGHT", -dbp.barPadding, -dbp.barPadding - height)
			cell.nameplate.bgtexture:SetWidth(dbp.npW)
			
			cell.nameplate.fgtexture:ClearAllPoints()
			cell.nameplate.fgtexture:SetPoint("TOPRIGHT", cell, "TOPRIGHT", -dbp.barPadding, -dbp.barPadding)
			cell.nameplate.fgtexture:SetPoint("BOTTOMRIGHT", cell, "TOPRIGHT", -dbp.barPadding, -dbp.barPadding - height)
			cell.nameplate.fgtexture:SetWidth(dbp.npW)
			
			cell.nameplate.icon:ClearAllPoints()
			cell.nameplate.ltext:ClearAllPoints()
			
			if dbp.npUseIcon == true then
				cell.nameplate.icon:SetPoint("TOPRIGHT", cell.nameplate, "TOPRIGHT", -ICON_OFFSET, -ICON_OFFSET)
				cell.nameplate.icon:SetHeight((height) - (ICON_OFFSET * 2))
				cell.nameplate.icon:SetWidth((height) - (ICON_OFFSET * 2))
				cell.nameplate.icon:Show()
				
				cell.nameplate.ltext:SetPoint("LEFT", cell.nameplate, "LEFT", STATUS_PADDING, 0)
				cell.nameplate.ltext:SetPoint("RIGHT", cell.nameplate.icon, "LEFT", -STATUS_PADDING, 0)
				cell.nameplate.ltext:SetHeight(height - (STATUS_PADDING * 2))
			else
				cell.nameplate.icon:Hide()
				
				cell.nameplate.ltext:SetPoint("LEFT", cell.nameplate, "LEFT", STATUS_PADDING, 0)
				cell.nameplate.ltext:SetPoint("RIGHT", cell.nameplate, "RIGHT", -STATUS_PADDING, 0)
				cell.nameplate.ltext:SetHeight(height - (STATUS_PADDING * 2))
			end
		end
		cell.nameplate:Show()
	else
		cell.nameplate:Hide()
	end
	
	
	local count = 1
	local namePlateOffset = dbp.npW
	if dbp.npUseNameplate == false then
		namePlateOffset = 0
	end
	
	for _, bar in ipairs(cell.bars) do
		if count <= bars_to_display then
			if dbp.hideNoCooldown == true and bar.instance and not bar.instance.remaining then
				--skip bars if hiding when not on cooldown
				count = count - 1
				bar:Hide()
				bar:ClearAllPoints()
			else
				local offsetx, anchorTicTac, anchorNamePlate
				if(dbp.cellSide == false) then
					--name plate on left
					offsetx = (( count - 1 ) * (dbp.barW + dbp.barGap)) + (dbp.barPadding * 2) + namePlateOffset
					anchorTicTac = "LEFT"
					anchorNamePlate = "LEFT"
				else
					--name plate on right
					offsetx = ((( count - 1 ) * (dbp.barW + dbp.barGap)) + (dbp.barPadding * 2) + namePlateOffset) * -1
					anchorTicTac = "RIGHT"
					anchorNamePlate = "RIGHT"
				end

				bar:ClearAllPoints()
				bar:SetPoint(anchorTicTac, cell, anchorNamePlate, offsetx, 0) --LEFT
				bar:SetHeight(height)
				bar:SetWidth(width)
				
				bar.bgtexture:ClearAllPoints()
				bar.bgtexture:SetPoint(anchorTicTac, cell, anchorNamePlate, offsetx, 0) --LEFT
				bar.bgtexture:SetHeight(height)
				
				bar.fgtexture:ClearAllPoints()
				bar.fgtexture:SetPoint(anchorTicTac, cell, anchorNamePlate, offsetx, 0) --LEFT
				bar.fgtexture:SetHeight(height)
				
				self:UpdateSpellBarAnimations(bar)
				
				local w_player, w_duration = self:GetPlayerDurationWidthsForContainer(cell.container)
			
				bar.ltext:ClearAllPoints()
			
				if w_player > 0 then
					--bar.ltext:SetFont(select(1, bar.ltext:GetFont()), bar:GetHeight() * dbp.barFontSize, flags)
					bar.ltext:SetPoint("LEFT", bar, "LEFT", STATUS_PADDING, 0)
					bar.ltext:SetWidth(w_player)
				end

				bar.rtext:ClearAllPoints()
			
				if w_duration > 0 then
					--bar.rtext:SetFont(select(1, bar.rtext:GetFont()), bar:GetHeight() * dbp.barFontSize, flags)
					bar.rtext:SetPoint("RIGHT", bar, "RIGHT", -STATUS_PADDING, 0)
					bar.rtext:SetWidth(w_duration)
				end
				
				if dbp.style == "Bars" then
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

------------------------------------------------------------------
--BAR
------------------------------------------------------------------
function LegacyUI:CreateRecycledBarFrame()
	if not RecycledBars then
		RecycledBars = CreateFrame("Frame", nil, UIParent)
		RecycledBars:SetPoint("CENTER")
		RecycledBars:SetWidth(50)
		RecycledBars:SetHeight(50)
		RecycledBars:Hide()

		RecycledBars:EnableMouse(false)
		RecycledBars:SetMovable(false)
		RecycledBars:SetToplevel(false)
		RecycledBars.Bars = {}
	end
end

function LegacyUI:CreateBarFrame()
	--bar frame
	local bar = CreateFrame("Frame", nil, RecycledBars)
	bar:Hide() -- hide by default
	bar:ClearAllPoints()
	bar.style = nil
	bar.instance = nil
	bar.ability = nil
	bar:EnableMouse(false) --allow clickthrough
	bar:SetMovable(false)
	bar:SetResizable(false)
	bar:SetToplevel(true)
	
	--bar bgtexture
	bar.bgtexture = bar:CreateTexture(nil, "BACKGROUND")
	bar.bgtexture:ClearAllPoints()
	
	--bar fgtexture
	bar.fgtexture = bar:CreateTexture(nil, "BORDER")
	bar.fgtexture:ClearAllPoints()

	--bar icon
	bar.icon = bar:CreateTexture(nil, "OVERLAY")
	bar.icon:ClearAllPoints()
	bar.icon:SetTexture("")
	bar.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	
	--bar ltext
	bar.ltext = bar:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	bar.ltext:ClearAllPoints()
	bar.ltext:SetWordWrap(false)
	bar.ltext:SetJustifyV("CENTER");
	bar.ltext:SetJustifyH("LEFT");
	bar.ltext:SetText("")
	bar.ltext:SetTextColor(0, 0, 0, 0)
	
	--bar rtext
	bar.rtext = bar:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	bar.rtext:ClearAllPoints()
	bar.rtext:SetWordWrap(false)
	bar.rtext:SetJustifyV("CENTER");
	bar.rtext:SetJustifyH("RIGHT");
	bar.rtext:SetText("")
	bar.rtext:SetTextColor(0, 0, 0, 0)

	--spark for internal cooldowns
	bar.spark = bar:CreateTexture(nil, "OVERLAY")
	bar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	bar.spark:SetWidth(BAR_SPARK_WIDTH)
	bar.spark:SetBlendMode("ADD")
	bar.spark:Hide() --make sure it's not initially visible
	bar.spark:SetPoint("TOP", bar, "TOP", 0, BAR_SPARK_HEIGHT) --make it slightly taller than the bar so it's easier to see
	bar.spark:SetPoint("BOTTOM", bar, "BOTTOM", 0, -BAR_SPARK_HEIGHT) --make it slightly taller than the bar so it's easier to see
	
	tinsert(RecycledBars.Bars, bar)
	
	return bar
end

function LegacyUI:GetFreeBar()
	local bar
	if(#RecycledBars.Bars > 0) then
		bar = RecycledBars.Bars[1]
	else
		bar = self:CreateBarFrame()
	end

	return bar
end

function LegacyUI:GetBarForInstance(cell, instance)
	for _, bar in ipairs(cell.bars) do
		if bar.instance == instance then
			return bar
		end
	end
	
	error("failed to locate bar for instance")
end

------------------------------------------------------------------
--NAMEPLATE BAR
------------------------------------------------------------------
function LegacyUI:InitializeNameplateBar(cell, nameplate, ability)
	nameplate.cell = cell
	nameplate.ability = ability
	nameplate:SetParent(cell)
	self:UpdateNamePlateVisuals(nameplate)
end

function LegacyUI:UpdateNamePlateVisuals(nameplate)
	local dbp = nameplate.cell.container.dbp
	local bgcolor = {}
	local txcolor = {}
	
	if dbp.npCCBar == true then
		bgcolor = deepcopy(Hermes:GetClassColorRGB(nameplate.cell.ability.class))
		bgcolor.a = dbp.npTexColor.a --use alpha of the specfied color
	else
		bgcolor.r = dbp.npTexColor.r
		bgcolor.g = dbp.npTexColor.g
		bgcolor.b = dbp.npTexColor.b
		bgcolor.a = dbp.npTexColor.a
	end
	
	if dbp.npCCFont == true then
		txcolor = deepcopy(Hermes:GetClassColorRGB(nameplate.cell.ability.class))
		txcolor.a = dbp.npFontColor.a --use alpha of the specfied color
	else
		txcolor.r = dbp.npFontColor.r
		txcolor.g = dbp.npFontColor.g
		txcolor.b = dbp.npFontColor.b
		txcolor.a = dbp.npFontColor.a
	end
	
	--not used for nameplates
	nameplate.bgtexture:SetTexture("")
	nameplate.bgtexture:SetVertexColor(0, 0, 0, 0)
	
	nameplate.fgtexture:SetTexture(LIB_LibSharedMedia:Fetch("statusbar", dbp.npTexture))
	nameplate.fgtexture:SetVertexColor(bgcolor.r, bgcolor.g, bgcolor.b, bgcolor.a)
	
	local font = LIB_LibSharedMedia:Fetch("font", dbp.npFont)
	
	local flags = ""
	if dbp.npOutlineFont == true then
		flags = "OUTLINE"
	end
	
	if dbp.cellDir == true then
		--horizontal alignment, font size is controlled by bar height instead of nameplate height
		nameplate.ltext:SetFont(font, dbp.barH * dbp.npFontSize, flags)
	else
		--vertical alignment, font size is controlled by bar height instead of nameplate height
		nameplate.ltext:SetFont(font, dbp.npH * dbp.npFontSize, flags)
	end
	
	nameplate.ltext:SetTextColor(txcolor.r, txcolor.g, txcolor.b, txcolor.a)
	nameplate.ltext:SetText(nameplate.ability.name)
	
	nameplate.rtext:ClearAllPoints()
	
	nameplate.icon:SetTexture(nameplate.ability.icon)
end

function LegacyUI:RecycleNameplateBar(nameplate)
	tinsert(RecycledBars.Bars, nameplate)
	
	---------------------------------------------------------------
	-- BAR
	---------------------------------------------------------------
	nameplate:Hide()
	nameplate.style = nil
	nameplate.instance = nil
	nameplate.cell = nil
	nameplate.ability = nil
	
	nameplate.bgtexture:SetTexture("")
	nameplate.bgtexture:ClearAllPoints()
	nameplate.fgtexture:SetTexture("")
	nameplate.fgtexture:ClearAllPoints()
	nameplate.icon:SetTexture("")
	nameplate.icon:ClearAllPoints()
	--nameplate.icon:SetVertexColor(0, 0, 0, 0)
	nameplate.ltext:SetText(nil)
	nameplate.ltext:ClearAllPoints()
	nameplate.rtext:SetText(nil)
	nameplate.rtext:ClearAllPoints()
	
	nameplate:SetParent(RecycledBars)
	nameplate:SetAllPoints()
end

------------------------------------------------------------------
--SPELL BAR
------------------------------------------------------------------
function LegacyUI:SetSpellBarStyleEmpty(bar)
	local dbp = bar.cell.container.dbp
	
	--hide the spark
	bar.spark:Hide()
	bar.spark:SetVertexColor(0, 0, 0, 0)
	
	--fix the width 
	bar.fgtexture:SetWidth(dbp.barW)
	
	-- bgtexture color
	bar.bgtexture:SetVertexColor(0, 0, 0, 0)
	
	-- fgtexture color
	bar.fgtexture:SetVertexColor(
		0,
		0,
		0,
		0)

	--duration text
	bar.rtext:SetTextColor(
		0,
		0,
		0,
		0)
	
	--player name text
	bar.ltext:SetTextColor(
		0,
		0,
		0,
		0)
	
	--clear or set sender name and duration
	bar.ltext:SetText(nil)
	bar.rtext:SetText(nil)
	
	--using this for performance reasons during animations
	bar.isStyleEmpty = 1
end

function LegacyUI:SetSpellBarStyleAvailable(bar)
	local dbp = bar.cell.container.dbp

	--hide the spark
	bar.spark:Hide()
	
	-- bgtexture color
	bar.bgtexture:SetVertexColor(0, 0, 0, 0)
	
	if dbp.barCCA == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		bar.fgtexture:SetVertexColor(
			color.r,
			color.g,
			color.b,
			dbp.barColorA.a)
		bar.spark:SetVertexColor(
			color.r,
			color.g,
			color.b,
			dbp.barColorA.a)
	else
		bar.fgtexture:SetVertexColor(
			dbp.barColorA.r,
			dbp.barColorA.g,
			dbp.barColorA.b,
			dbp.barColorA.a)
		bar.spark:SetVertexColor(
			dbp.barColorA.r,
			dbp.barColorA.g,
			dbp.barColorA.b,
			dbp.barColorA.a)
	end
	
	if dbp.barCCAFont == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		bar.ltext:SetTextColor(
			color.r,
			color.g,
			color.b,
			dbp.barColorAFont.a)
		bar.rtext:SetTextColor(
			color.r,
			color.g,
			color.b,
			dbp.barColorAFont.a)
	else
		bar.ltext:SetTextColor(
			dbp.barColorAFont.r,
			dbp.barColorAFont.g,
			dbp.barColorAFont.b,
			dbp.barColorAFont.a)
		bar.rtext:SetTextColor(
			dbp.barColorAFont.r,
			dbp.barColorAFont.g,
			dbp.barColorAFont.b,
			dbp.barColorAFont.a)
	end
	
	--clear or set sender name and duration
	bar.ltext:SetText(bar.instance.sender.name)
	bar.rtext:SetText(nil)
	bar.isStyleEmpty = nil
end

function LegacyUI:SetSpellBarStyleOnCooldown(bar)
	local dbp = bar.cell.container.dbp

	--show the spark
	bar.spark:Show()
	
	if dbp.barBGCCC == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		bar.bgtexture:SetVertexColor(
			color.r,
			color.g,
			color.b,
			dbp.barBGColorC.a)
	else
		bar.bgtexture:SetVertexColor(
			dbp.barBGColorC.r,
			dbp.barBGColorC.g,
			dbp.barBGColorC.b,
			dbp.barBGColorC.a)
	end
	
	if dbp.barCCC == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		bar.fgtexture:SetVertexColor(
			color.r,
			color.g,
			color.b,
			dbp.barColorC.a)
		bar.spark:SetVertexColor(
			color.r,
			color.g,
			color.b,
			dbp.barColorC.a)
	else
		bar.fgtexture:SetVertexColor(
			dbp.barColorC.r,
			dbp.barColorC.g,
			dbp.barColorC.b,
			dbp.barColorC.a)
		bar.spark:SetVertexColor(
			dbp.barColorC.r,
			dbp.barColorC.g,
			dbp.barColorC.b,
			dbp.barColorC.a)
	end
	
	if dbp.barCCCFont == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		bar.ltext:SetTextColor(
			color.r,
			color.g,
			color.b,
			dbp.barColorCFont.a)
		bar.rtext:SetTextColor(
			color.r,
			color.g,
			color.b,
			dbp.barColorCFont.a)
	else
		bar.ltext:SetTextColor(
			dbp.barColorCFont.r,
			dbp.barColorCFont.g,
			dbp.barColorCFont.b,
			dbp.barColorCFont.a)
		bar.rtext:SetTextColor(
			dbp.barColorCFont.r,
			dbp.barColorCFont.g,
			dbp.barColorCFont.b,
			dbp.barColorCFont.a)
	end
	
	--clear or set sender name and duration
	bar.ltext:SetText(bar.instance.sender.name)
	bar.rtext:SetText(nil)
	bar.isStyleEmpty = nil
end

function LegacyUI:SetSpellBarStyleUnavailable(bar)
	local dbp = bar.cell.container.dbp

	--hide the spark
	bar.spark:Hide()
	bar.spark:SetVertexColor(0, 0, 0, 0)
	
	bar.bgtexture:SetVertexColor(0, 0, 0, 0)
	
	if dbp.barCCU == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		bar.fgtexture:SetVertexColor(
			color.r,
			color.g,
			color.b,
			dbp.barColorU.a)
	else
		bar.fgtexture:SetVertexColor(
			dbp.barColorU.r,
			dbp.barColorU.g,
			dbp.barColorU.b,
			dbp.barColorU.a)
	end
	
	if dbp.barCCUFont == true then
		local color = Hermes:GetClassColorRGB(bar.instance.sender.class)
		bar.ltext:SetTextColor(
			color.r,
			color.g,
			color.b,
			dbp.barColorUFont.a)
		bar.rtext:SetTextColor(
			color.r,
			color.g,
			color.b,
			dbp.barColorUFont.a)
	else
		bar.ltext:SetTextColor(
			dbp.barColorUFont.r,
			dbp.barColorUFont.g,
			dbp.barColorUFont.b,
			dbp.barColorUFont.a)
		bar.rtext:SetTextColor(
			dbp.barColorUFont.r,
			dbp.barColorUFont.g,
			dbp.barColorUFont.b,
			dbp.barColorUFont.a)
	end
	
	local status = bar.instance.sender.name
	
	if bar.instance.sender.online == false then
		status = status.." ("..L["offline"]..")"
	elseif bar.instance.sender.dead == true then
		status = status.." ("..L["dead"]..")"
	elseif not bar.instance.sender.visible then
		status = status.." ("..L["range"]..")"
	end
	--clear or set sender name and duration
	bar.ltext:SetText(status)
	
	bar.isStyleEmpty = nil
end

function LegacyUI:SetSpellBarStyle(bar) -- called when the state of a button changed, and thus colors need to be changed
	local dbp = bar.cell.container.dbp
	local instance, available, cooldown = self:GetSpellBarInstanceState(bar.instance)
	
	if not instance or (available == false and dbp.cellHideNoAvailSender == true) then
		self:SetSpellBarStyleEmpty(bar)
		return
	end
	
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

function LegacyUI:UpdateSpellBarAnimations(bar)
	local totalwidth = bar.cell.container.dbp.barW
	
	--always keep the background the full width of the bar
	bar.bgtexture:SetWidth(totalwidth)
		
	if not bar.isStyleEmpty then
		local width = totalwidth
		if bar.instance and bar.instance.remaining then
			width = totalwidth - ((bar.instance.remaining / bar.instance.initialDuration) * totalwidth)
		end
		
		--set the width of the textures, blizz doesn't allow width of 0, so hide it if zero
		if width > 0 then
			bar.fgtexture:SetWidth(width)
			bar.fgtexture:Show()
		else
			bar.fgtexture:Hide()
			bar.fgtexture:SetWidth(totalwidth)
		end
		
		if bar.instance and bar.instance.remaining then
			local h, m, s = _secondsToClock(bar.instance.remaining)
			
			--it might seem dumb to not just format the string inside of _secondsToClock
			--but the reason I do it this way is because no memory is allocated for strings
			--using this technique. Also, the CPU required is reduced by roughly 1/3rd
			if h then
				bar.rtext:SetFormattedText("%d:%02.f:%02.f", h, m, s)
			elseif m then
				bar.rtext:SetFormattedText("%d:%02.f", m, s)
			else
				bar.rtext:SetFormattedText("%d", s)
			end
					
			-- the bar is on cooldown, so reposition the spark
			bar.spark:SetPoint("LEFT", bar, "LEFT", width - (BAR_SPARK_WIDTH / 2), 0) --width - N where N is half the size of width, minue one more...looks better to me.
		else
			bar.rtext:SetText("")
		end
	else
		bar.fgtexture:SetWidth(totalwidth)
	end
end

function LegacyUI:GetSpellBarInstanceState(instance)
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

function LegacyUI:InitializeSpellBar(cell, bar, instance)
	bar.cell = cell
	bar.instance = instance
	bar:SetParent(cell)
	self:UpdateSpellBarVisuals(bar)
	self:SetSpellBarStyle(bar)
	self:UpdateSpellBarAnimations(bar)
end

function LegacyUI:UpdateSpellBarVisuals(bar) --call when textures or fonts change for a bar
	local dbp = bar.cell.container.dbp
	--local exists, available, cooldown = self:GetSpellBarInstanceState(bar.instance)
	--local barcolor, color = self:GetSpellBarColors(bar, exists, available, cooldown)
	
	--set the fonts
	local flags = ""
	if dbp.barOutlineFont == true then
		flags = "OUTLINE"
	end
	
	local font = LIB_LibSharedMedia:Fetch("font", dbp.barFont)
	bar.ltext:SetFont(font, dbp.barH * dbp.barFontSize, flags)
	bar.rtext:SetFont(font, dbp.barH * dbp.barFontSize, flags)

	--not used
	bar.icon:SetTexture("");
	--bar.icon:SetVertexColor(0, 0, 0, 0)
	bar.icon:ClearAllPoints()
	
	--self:SetSpellBarStateChanged(bar)
	
	bar.bgtexture:SetTexture(LIB_LibSharedMedia:Fetch("statusbar", dbp.barTexture))
	bar.fgtexture:SetTexture(LIB_LibSharedMedia:Fetch("statusbar", dbp.barTexture))
	
	--bar.rtext:SetText(nil) -- is this needed?
end

function LegacyUI:RecycleSpellBar(bar)
	DeleteFromIndexedTable(bar.cell.bars, bar)
	tinsert(RecycledBars.Bars, bar)
	
	---------------------------------------------------------------
	-- BAR
	---------------------------------------------------------------
	bar:Hide()
	bar.style = nil
	bar.instance = nil
	bar.cell = nil
	bar.ability = nil
	
	bar.bgtexture:SetTexture("")
	bar.bgtexture:SetVertexColor(0, 0, 0, 0)
	bar.bgtexture:ClearAllPoints()
	bar.fgtexture:SetTexture("")
	bar.fgtexture:SetVertexColor(0, 0, 0, 0)
	bar.fgtexture:ClearAllPoints()
	bar.icon:SetTexture("")
	bar.icon:ClearAllPoints()
	--bar.icon:SetVertexColor(0, 0, 0, 0)
	bar.ltext:SetText(nil)
	bar.ltext:ClearAllPoints()
	bar.rtext:SetText(nil)
	bar.rtext:ClearAllPoints()
	
	bar:SetParent(RecycledBars)
	bar:ClearAllPoints()
end

function LegacyUI:ShowSpellBars(cell, show)
	if(cell.bars) then
		if(show and show == true) then
			local cnt = 0
			for _, bar in ipairs(cell.bars) do
				--never show more tick tacks than what the max is set to!
				if(cnt < cell.container.dbp.cellMax) then
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

function LegacyUI:GetPlayerDurationWidthsForContainer(container)
	local w_available = (container.dbp.barW - (STATUS_PADDING * 2)) - (ICON_OFFSET * 2)
	local w_player, w_duration
	
	--account for 0% player name ratio
	if container.dbp.barTextRatio <= 0 then
		w_player = 0
		w_duration = w_available
	elseif container.dbp.barTextRatio >= 100 then
		w_player = w_available
		w_duration = 0
	else
		w_player = w_available * (container.dbp.barTextRatio / 100)
		w_duration = w_available - w_player
	end
	
	return w_player, w_duration
end

------------------------------------------------------------------
--SORTING
------------------------------------------------------------------
local function SortByName(a, b)
	return a.instance.sender.name < b.instance.sender.name --sort by name if duration is the same
end

local function SortByDuration(a, b)
	local durationA 
	local durationB

	if(not a.instance.remaining) then
		durationA = 0
	else
		durationA = a.instance.remaining
	end
	
	if(not b.instance.remaining) then
		durationB = 0
	else
		durationB = b.instance.remaining
	end

	if(durationA == durationB) then
		return SortByName(a, b)
	else
		return durationA < durationB --sort by duration
	end
end

local function SortSendersByAvailability(a, b)
	local senderAAvailable = Hermes:IsSenderAvailable(a.instance.sender)
	local senderBAvailable = Hermes:IsSenderAvailable(b.instance.sender)
	
	--online
	if(senderAAvailable == false and senderBAvailable == true) then
		return false --A below B
	end
	if(senderAAvailable == true and senderBAvailable == false) then
		return true --A above B
	end

	--they're both available, sort by duration
	return SortByDuration(a, b)
end

local function SortByHasInstance(a, b)
	if(not a.instance and b.instance) then
		return false --A below B
	end
	if(a.instance and not b.instance) then
		return true --A above B
	end
	if(not a.instance and not a.instance) then
		return false
	end
	
	return SortSendersByAvailability(a, b)
end

function LegacyUI:SortBars(cell)
	sort(cell.bars, function(a, b) return SortByHasInstance(a, b) end)
end

function LegacyUI:GenerateUniqueContainerName(containers, startWith)
	local exists = true
	local count = 1
	local name

	while (exists == true) do
		name = startWith..format("%.0f", count)
		local match = false
		for _, container in ipairs(containers) do
			if(container.dbp.name == name) then
				match = true
			end
		end
		
		if(match == false) then
			exists = false
		end
		count = count + 1
	end
	return name
end