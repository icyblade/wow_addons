﻿local E, L, V, P, G = unpack(select(2, ...))
local Sticky = E.Libs.SimpleSticky

local _G = _G
local type, unpack, pairs, error = type, unpack, pairs, error
local format, split, find = format, strsplit, strfind

local CreateFrame = CreateFrame
local IsShiftKeyDown = IsShiftKeyDown
local InCombatLockdown = InCombatLockdown
local IsControlKeyDown = IsControlKeyDown
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT

E.CreatedMovers = {}
E.DisabledMovers = {}

local function SizeChanged(frame)
	if InCombatLockdown() then return end

	if frame.dirtyWidth and frame.dirtyHeight then
		frame.mover:Size(frame.dirtyWidth, frame.dirtyHeight)
	else
		frame.mover:Size(frame:GetSize())
	end
end

local function GetPoint(obj)
	local point, anchor, secondaryPoint, x, y = obj:GetPoint()
	if not anchor then anchor = E.UIParent end

	return format("%s,%s,%s,%d,%d", point, anchor:GetName(), secondaryPoint, x and E:Round(x) or 0, y and E:Round(y) or 0)
end

local function GetSettingPoints(name)
	local db = E.db.movers and E.db.movers[name]
	if db then
		local delim = (find(db, "\031") and "\031") or ","
		return split(delim, db)
	end
end

local function UpdateCoords(self)
	local mover = self.child
	local x, y, _, nudgePoint, nudgeInversePoint = E:CalculateMoverPoints(mover)

	local coordX, coordY = E:GetXYOffset(nudgeInversePoint, 1)
	local nudgeFrame = _G.ElvUIMoverNudgeWindow

	nudgeFrame:ClearAllPoints()
	nudgeFrame:Point(nudgePoint, mover, nudgeInversePoint, coordX, coordY)
	E:UpdateNudgeFrame(mover, x, y)
end

function E:SetMoverPoints(name, parent)
	local holder = E.CreatedMovers[name]
	if not holder then return end

	local point1, relativeTo1, relativePoint1, xOffset1, yOffset1 = unpack(holder.parentPoint)
	local point2, relativeTo2, relativePoint2, xOffset2, yOffset2 = GetSettingPoints(name)
	if not _G[relativeTo2] then -- fallback to the parents original point (on create) if the setting doesn't exist
		point2, relativeTo2, relativePoint2, xOffset2, yOffset2 = point1, relativeTo1, relativePoint1, xOffset1, yOffset1
	end

	if point2 then
		holder.mover:ClearAllPoints()
		holder.mover:Point(point2, relativeTo2, relativePoint2, xOffset2, yOffset2)
	end

	if parent then
		parent:ClearAllPoints()
		parent:Point(point1, parent.mover, 0, 0)
	end
end

local isDragging = false
local coordFrame = CreateFrame("Frame")
coordFrame:SetScript("OnUpdate", UpdateCoords)
coordFrame:Hide()

local function UpdateMover(parent, name, text, overlay, snapOffset, postdrag, shouldDisable, configString, perferCorners)
	if not parent then return end --If for some reason the parent isnt loaded yet
	local holder = E.CreatedMovers[name]
	if holder.Created then return end
	holder.Created = true

	if overlay == nil then overlay = true end

	--Use dirtyWidth / dirtyHeight to set initial size if possible
	local width = parent.dirtyWidth or parent:GetWidth()
	local height = parent.dirtyHeight or parent:GetHeight()

	local f = CreateFrame("Button", name, E.UIParent)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton", "RightButton")
	f:SetFrameLevel(parent:GetFrameLevel() + 1)
	f:SetFrameStrata(overlay and "DIALOG" or "BACKGROUND")
	f:EnableMouseWheel(true)
	f:SetMovable(true)
	f:SetTemplate("Transparent", nil, nil, true)
	f:Size(width, height)
	f:Hide()

	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:FontTemplate()
	fs:Point("CENTER")
	fs:SetText(text or name)
	fs:SetTextColor(unpack(E.media.rgbvaluecolor))
	fs:SetJustifyH("CENTER")
	f:SetFontString(fs)

	f.text = fs
	f.name = name
	f.parent = parent
	f.overlay = overlay
	f.postdrag = postdrag
	f.textString = text or name
	f.snapOffset = snapOffset or -2
	f.shouldDisable = shouldDisable
	f.configString = configString
	f.perferCorners = perferCorners

	holder.mover = f
	parent.mover = f
	E.snapBars[#E.snapBars + 1] = f

	parent:SetScript("OnSizeChanged", SizeChanged)
	E:SetMoverPoints(name, parent)

	local function OnDragStart(self)
		if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT) return end

		if ElvUIGrid then
			E:UIFrameFadeIn(ElvUIGrid, 0.75, ElvUIGrid:GetAlpha(), 1)
		end

		if E.db.general.stickyFrames then
			Sticky:StartMoving(self, E.snapBars, f.snapOffset, f.snapOffset, f.snapOffset, f.snapOffset)
		else
			self:StartMoving()
		end

		coordFrame.child = self
		coordFrame:Show()
		isDragging = true
	end

	local function OnDragStop(self)
		if InCombatLockdown() then E:Print(ERR_NOT_IN_COMBAT) return end

		if ElvUIGrid and E.ConfigurationMode then
			E:UIFrameFadeOut(ElvUIGrid, 0.75, ElvUIGrid:GetAlpha(), 0.4)
		end

		isDragging = false
		if E.db.general.stickyFrames then
			Sticky:StopMoving(self)
		else
			self:StopMovingOrSizing()
		end

		local x2, y2, p2 = E:CalculateMoverPoints(self)
		self:ClearAllPoints()
		self:Point(p2, E.UIParent, p2, x2, y2)

		E:SaveMoverPosition(name)


		coordFrame.child = nil
		coordFrame:Hide()

		if postdrag and type(postdrag) == "function" then
			postdrag(self, E:GetScreenQuadrant(self))
		end

		self:SetUserPlaced(false)
	end

	local function OnEnter(self)
		if isDragging then return end
		for _, frame in pairs(E.CreatedMovers) do
			local mover = frame.mover
			if mover:IsShown() and mover ~= self then
				E:UIFrameFadeOut(mover, 0.75, mover:GetAlpha(), 0.5)
			end
		end

		self.text:SetTextColor(1, 1, 1)
		E.AssignFrameToNudge(self)
		coordFrame.child = self
		coordFrame:GetScript("OnUpdate")(coordFrame)
	end

	local function OnLeave(self)
		if isDragging then return end
		for _, frame in pairs(E.CreatedMovers) do
			local mover = frame.mover
			if mover:IsShown() and mover ~= self then
				E:UIFrameFadeIn(mover, 0.75, mover:GetAlpha(), 1)
			end
		end

		self.text:SetTextColor(unpack(E.media.rgbvaluecolor))
	end

	local function OnMouseUp(_, button)
		if button == "LeftButton" and not isDragging then
			ElvUIMoverNudgeWindow:SetShown(not ElvUIMoverNudgeWindow:IsShown())
		end
	end

	local function OnMouseDown(self, button)
		if button == "RightButton" then
			--Allow resetting of anchor by Ctrl+RightClick
			if IsControlKeyDown() and self.textString then
				E:ResetMovers(self.textString)
			elseif IsShiftKeyDown() then --Allow hiding a mover temporarily
				self:Hide()
			elseif self.configString then --OpenConfig
				E:ToggleOptionsUI(self.configString)
			end
		end
	end

	local function OnShow(self)
		self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
		self.text:FontTemplate()
	end

	local function OnMouseWheel(_, delta)
		if IsShiftKeyDown() then
			E:NudgeMover(delta)
		else
			E:NudgeMover(nil, delta)
		end
	end

	f:SetScript("OnDragStart", OnDragStart)
	f:SetScript("OnMouseUp", E.AssignFrameToNudge)
	f:SetScript("OnDragStop", OnDragStop)
	f:SetScript("OnEnter", OnEnter)
	f:SetScript("OnMouseUp", OnMouseUp)
	f:SetScript("OnMouseDown", OnMouseDown)
	f:SetScript("OnLeave", OnLeave)
	f:SetScript("OnShow", OnShow)
	f:SetScript("OnMouseWheel", OnMouseWheel)

	if postdrag and type(postdrag) == "function" then
		f:RegisterEvent("PLAYER_ENTERING_WORLD")
		f:SetScript("OnEvent", function(self)
			postdrag(f, E:GetScreenQuadrant(f))
			self:UnregisterAllEvents()
		end)
	end
end

function E:CalculateMoverPoints(mover, nudgeX, nudgeY)
	local screenWidth, screenHeight = E.UIParent:GetRight(), E.UIParent:GetTop()
	local screenCenterX, screenCenterY = E.UIParent:GetCenter()
	local x, y = mover:GetCenter()

	local point, nudgePoint, nudgeInversePoint
	if y >= screenCenterY then -- TOP: 1080p = 540
		point = "TOP"
		nudgePoint = "TOP"
		nudgeInversePoint = "BOTTOM"
		y = -(screenHeight - mover:GetTop())
	else
		point = "BOTTOM"
		nudgePoint = "BOTTOM"
		nudgeInversePoint = "TOP"
		y = mover:GetBottom()
	end

	if x >= (screenWidth * 2 / 3) then -- RIGHT: 1080p = 1280
		point = point.."RIGHT"
		nudgePoint = "RIGHT"
		nudgeInversePoint = "LEFT"
		x = mover:GetRight() - screenWidth
	elseif x <= (screenWidth / 3) or mover.perferCorners then -- LEFT: 1080p = 640
		point = point.."LEFT"
		nudgePoint = "LEFT"
		nudgeInversePoint = "RIGHT"
		x = mover:GetLeft()
	else
		x = x - screenCenterX
	end

	--Update coordinates if nudged
	x = x + (nudgeX or 0)
	y = y + (nudgeY or 0)

	return x, y, point, nudgePoint, nudgeInversePoint
end

function E:HasMoverBeenMoved(name)
	return E.db.movers and E.db.movers[name]
end

function E:SaveMoverPosition(name)
	local holder = E.CreatedMovers[name]
	if not holder then return end
	if not E.db.movers then E.db.movers = {} end
	E.db.movers[name] = GetPoint(holder.mover)
end

function E:SetMoverSnapOffset(name, offset)
	local holder = E.CreatedMovers[name]
	if not holder then return end

	holder.mover.snapOffset = offset or -2
	holder.snapoffset = offset or -2
end

function E:SetMoverLayoutPositionPoint(holder, name, parent)
	local layout = E.LayoutMoverPositions[E.db.layoutSetting]
	local layoutPoint = (layout and layout[name]) or E.LayoutMoverPositions.ALL[name]
	holder.layoutPoint = layoutPoint
	holder.point = layoutPoint or GetPoint(parent or holder.mover)

	if parent then -- CreateMover call
		holder.parentPoint = {parent:GetPoint()}
	end
end

function E:SaveMoverDefaultPosition(name)
	local holder = E.CreatedMovers[name]
	if not holder then return end

	E:SetMoverLayoutPositionPoint(holder, name)

	if holder.postdrag and type(holder.postdrag) == "function" then
		holder.postdrag(holder.mover, E:GetScreenQuadrant(holder.mover))
	end
end

function E:CreateMover(parent, name, text, overlay, snapoffset, postdrag, moverTypes, shouldDisable, configString, perferCorners)
	if not moverTypes then moverTypes = "ALL,GENERAL" end

	local holder = E.CreatedMovers[name]
	if holder == nil then
		holder = {}
		holder.type = {}

		for _, moverType in ipairs({split(",", moverTypes)}) do
			holder.type[moverType] = true
		end

		E:SetMoverLayoutPositionPoint(holder, name, parent)
		E.CreatedMovers[name] = holder
	end

	UpdateMover(parent, name, text, overlay, snapoffset, postdrag, shouldDisable, configString, perferCorners)
end

function E:ToggleMovers(show, moverType)
	self.configMode = show

	for _, holder in pairs(E.CreatedMovers) do
		if show and holder.type[moverType] then
			holder.mover:Show()
		else
			holder.mover:Hide()
		end
	end
end

function E:GetMoverHolder(name)
	local created = self.CreatedMovers[name]
	local disabled = self.DisabledMovers[name]
	return created or disabled, not not disabled
end

function E:DisableMover(name)
	if self.DisabledMovers[name] then return end

	local holder = self.CreatedMovers[name]
	if not holder then
		error(format("mover %s doesnt exist", name or "nil"))
	end

	self.DisabledMovers[name] = {}
	for x, y in pairs(holder) do
		self.DisabledMovers[name][x] = y
	end

	if self.configMode then
		holder.mover:Hide()
	end

	self.CreatedMovers[name] = nil
end

function E:EnableMover(name)
	if self.CreatedMovers[name] then return end

	local holder = self.DisabledMovers[name]
	if not holder then
		error(format("mover %s doesnt exist", name or "nil"))
	end

	self.CreatedMovers[name] = {}
	for x, y in pairs(holder) do
		self.CreatedMovers[name][x] = y
	end

	if self.configMode then
		holder.mover:Show()
	end

	self.DisabledMovers[name] = nil
end

function E:ResetMovers(arg)
	local all = not arg or arg == ""
	if all then self.db.movers = nil end

	for name, holder in pairs(E.CreatedMovers) do
		if all or (holder.mover and holder.mover.textString == arg) then
			local point, anchor, secondaryPoint, x, y = split(",", holder.point)

			local frame = holder.mover
			if point then
				frame:ClearAllPoints()
				frame:Point(point, anchor, secondaryPoint, x, y)
			end

			if holder.postdrag and type(holder.postdrag) == "function" then
				holder.postdrag(frame, E:GetScreenQuadrant(frame))
			end

			if all then
				E:SaveMoverPosition(name)
				self.db.movers = nil
			else
				if holder.layoutPoint then
					E:SaveMoverPosition(name)
				elseif self.db.movers then
					self.db.movers[name] = nil
				end
				break
			end
		end
	end
end

--Profile Change
function E:SetMoversPositions()
	--E:SetMoversPositions() is the first function called in E:UpdateAll().
	--Because of that, we can allow ourselves to re-enable all disabled movers here,
	--as the subsequent updates to these elements will disable them again if needed.
	for name in pairs(E.DisabledMovers) do
		local disable = E.DisabledMovers[name].shouldDisable
		local shouldDisable = (disable and disable()) or false
		if not shouldDisable then E:EnableMover(name) end
	end

	for name in pairs(E.CreatedMovers) do
		E:SetMoverPoints(name)
	end
end

function E:SetMoversClampedToScreen(value)
	for _, holder in pairs(E.CreatedMovers) do
		holder.mover:SetClampedToScreen(value)
	end
end

function E:LoadMovers()
	for name, t in pairs(E.CreatedMovers) do
		UpdateMover(t.parent, name, t.text, t.overlay, t.snapoffset, t.postdrag, t.shouldDisable, t.configString, t.perferCorners)
	end
end