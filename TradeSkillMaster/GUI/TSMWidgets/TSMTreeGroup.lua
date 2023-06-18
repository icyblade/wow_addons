-- ------------------------------------------------------------------------------ --
--                                TradeSkillMaster                                --
--                http://www.curse.com/addons/wow/tradeskill-master               --
--                                                                                --
--             A TradeSkillMaster Addon (http://tradeskillmaster.com)             --
--    All Rights Reserved* - Detailed license information included with addon.    --
-- ------------------------------------------------------------------------------ --

-- Much of this code is copied from .../AceGUI-3.0/widgets/AceGUIContainer-TreeGroup.lua
-- This TreeGroup container is modified to fit TSM's theme / needs
local TSM = select(2, ...)
local Type, Version = "TSMTreeGroup", 2
local AceGUI = LibStub("AceGUI-3.0")
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local next, pairs, ipairs, assert, type = next, pairs, ipairs, assert, type
local math_min, math_max, floor = math.min, math.max, floor
local select, tremove, unpack, tconcat = select, table.remove, unpack, table.concat

-- WoW APIs
local CreateFrame, UIParent = CreateFrame, UIParent

-- Recycling functions
local new, del
do
	local pool = setmetatable({},{__mode='k'})
	function new()
		local t = next(pool)
		if t then
			pool[t] = nil
			return t
		else
			return {}
		end
	end
	function del(t)
		for k in pairs(t) do
			t[k] = nil
		end	
		pool[t] = true
	end
end

local DEFAULT_TREE_WIDTH = 175
local DEFAULT_TREE_SIZABLE = true
local HIGHLIGHT_COLOR = {80/255, 180/255, 180/255}


--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]

local function GetButtonUniqueValue(line)
	local parent = line.parent
	if parent and parent.value then
		return GetButtonUniqueValue(parent).."\001"..line.value
	else
		return line.value
	end
end

local function UpdateButton(button, treeline, selected, canExpand, isExpanded)
	local self = button.obj
	local toggle = button.toggle
	local frame = self.frame
	local text = treeline.text or ""
	local icon = treeline.icon
	local iconCoords = treeline.iconCoords
	local level = treeline.level
	local value = treeline.value
	local uniquevalue = treeline.uniquevalue
	local disabled = treeline.disabled
	
	button.treeline = treeline
	button.value = value
	button.uniquevalue = uniquevalue
	if selected then
		button:LockHighlight()
		button.selected = true
	else
		button:UnlockHighlight()
		button.selected = false
	end
	local normalTexture = button:GetNormalTexture()
	local line = button.line
	button.level = level
	if level == 1 then
		button.text:SetFont(TSMAPI.Design:GetBoldFont(), 15)
		TSMAPI.Design:SetTitleTextColor(button.text)
		button.text:SetPoint("LEFT", (icon and 16 or 0) + 8, 2)
	else
		button.text:SetFont(TSMAPI.Design:GetContentFont("normal"))
		TSMAPI.Design:SetWidgetLabelColor(button.text)
		button.text:SetPoint("LEFT", (icon and 16 or 0) + 8 * level, 2)
	end
	
	if disabled then
		button:EnableMouse(false)
		button.text:SetText("|cff808080"..text..FONT_COLOR_CODE_CLOSE)
	else
		button.text:SetText(text)
		button:EnableMouse(true)
	end
	
	if icon then
		button.icon:SetTexture(icon)
		button.icon:SetPoint("LEFT", 8 * level, (level == 1) and 0 or 1)
	else
		button.icon:SetTexture(nil)
	end
	
	if iconCoords then
		button.icon:SetTexCoord(unpack(iconCoords))
	else
		button.icon:SetTexCoord(0, 1, 0, 1)
	end
	
	if canExpand then
		if not isExpanded then
			toggle.text:SetFont(TSMAPI.Design:GetBoldFont(), 24)
			toggle.text:SetText("+")
		else
			toggle.text:SetFont(TSMAPI.Design:GetBoldFont(), 30)
			toggle.text:SetText("-")
		end
		toggle:Show()
	else
		toggle:Hide()
	end
end

local function ShouldDisplayLevel(tree)
	local result = false
	for k, v in ipairs(tree) do
		if v.children == nil and v.visible ~= false then
			result = true
		elseif v.children then
			result = result or ShouldDisplayLevel(v.children)
		end
		if result then return result end
	end
	return false
end

local function addLine(self, v, tree, level, parent)
	local line = new()
	line.value = v.value
	line.text = v.text
	line.icon = v.icon
	line.iconCoords = v.iconCoords
	line.disabled = v.disabled
	line.tree = tree
	line.level = level
	line.parent = parent
	line.visible = v.visible
	line.uniquevalue = GetButtonUniqueValue(line)
	if v.children then
		line.hasChildren = true
	else
		line.hasChildren = nil
	end
	self.lines[#self.lines+1] = line
	return line
end

--fire an update after one frame to catch the treeframes height
local function FirstFrameUpdate(frame)
	local self = frame.obj
	frame:SetScript("OnUpdate", nil)
	self:RefreshTree()
end

local function BuildUniqueValue(...)
	local n = select('#', ...)
	if n == 1 then
		return ...
	else
		return (...).."\001"..BuildUniqueValue(select(2,...))
	end
end


--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]

local function Expand_OnClick(frame)
	local button = frame.button
	local self = button.obj
	local status = (self.status or self.localstatus).groups
	status[button.uniquevalue] = not status[button.uniquevalue]
	self:RefreshTree()
end

local function Button_OnClick(frame)
	local self = frame.obj
	self:Fire("OnClick", frame.uniquevalue, frame.selected)
	if not frame.selected then
		self:SetSelected(frame.uniquevalue)
		frame.selected = true
		frame:LockHighlight()
		self:RefreshTree()
	end
	AceGUI:ClearFocus()
end

local function Button_OnDoubleClick(button)
	local self = button.obj
	local status = self.status or self.localstatus
	local status = (self.status or self.localstatus).groups
	status[button.uniquevalue] = not status[button.uniquevalue]
	self:RefreshTree()
end

local function Button_OnEnter(frame)
	local self = frame.obj
	self:Fire("OnButtonEnter", frame.uniquevalue, frame)

	if self.enabletooltips then
		GameTooltip:SetOwner(frame, "ANCHOR_NONE")
		GameTooltip:SetPoint("LEFT",frame,"RIGHT")
		-- strip out color codes
		local text = frame.text:GetText() or ""
		text = gsub(text, "|cff[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]", "")
		text = gsub(text, "|r", "")
		GameTooltip:SetText(text, 1, .82, 0, 1)
		GameTooltip:Show()
	end
end

local function Button_OnLeave(frame)
	local self = frame.obj
	self:Fire("OnButtonLeave", frame.uniquevalue, frame)

	if self.enabletooltips then
		GameTooltip:Hide()
	end
end

local function OnScrollValueChanged(frame, value)
	if frame.obj.noupdate then return end
	local self = frame.obj
	local status = self.status or self.localstatus
	status.scrollvalue = floor(value + 0.5)
	self:RefreshTree()
	AceGUI:ClearFocus()
end

local function Tree_OnSizeChanged(frame)
	frame.obj:RefreshTree()
end

local function Tree_OnMouseWheel(frame, delta)
	local self = frame.obj
	if self.showscroll then
		local scrollbar = self.scrollbar
		local min, max = scrollbar:GetMinMaxValues()
		local value = scrollbar:GetValue()
		local newvalue = math_min(max,math_max(min,value - delta))
		if value ~= newvalue then
			scrollbar:SetValue(newvalue)
		end
	end
end

local function Dragger_OnLeave(frame)
	frame:SetBackdropColor(1, 1, 1, 0)
end

local function Dragger_OnEnter(frame)
	frame:SetBackdropColor(1, 1, 1, 0.8)
end

local function Dragger_OnMouseDown(frame)
	local treeframe = frame:GetParent()
	treeframe:StartSizing("RIGHT")
end

local function Dragger_OnMouseUp(frame)
	local treeframe = frame:GetParent()
	local self = treeframe.obj
	local frame = treeframe:GetParent()
	treeframe:StopMovingOrSizing()
	treeframe:SetUserPlaced(false)
	--Without this :GetHeight will get stuck on the current height, causing the tree contents to not resize
	treeframe:SetHeight(0)
	treeframe:SetPoint("TOPLEFT", frame, "TOPLEFT",0,0)
	treeframe:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT",0,0)
	
	local status = self.status or self.localstatus
	status.treewidth = treeframe:GetWidth()
	
	treeframe.obj:Fire("OnTreeResize",treeframe:GetWidth())
	-- recalculate the content width
	treeframe.obj:OnWidthSet(status.fullwidth)
	-- update the layout of the content
	treeframe.obj:DoLayout()
end


--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]

local methods = {
	["OnAcquire"] = function(self)
		self:SetTreeWidth(DEFAULT_TREE_WIDTH, DEFAULT_TREE_SIZABLE)
		self:EnableButtonTooltips(true)
	end,

	["OnRelease"] = function(self)
		self.status = nil
		for k, v in pairs(self.localstatus) do
			if k == "groups" then
				for k2 in pairs(v) do
					v[k2] = nil
				end
			else
				self.localstatus[k] = nil
			end
		end
		self.localstatus.scrollvalue = 0
		self.localstatus.treewidth = DEFAULT_TREE_WIDTH
		self.localstatus.treesizable = DEFAULT_TREE_SIZABLE
	end,

	["EnableButtonTooltips"] = function(self, enable)
		self.enabletooltips = enable
	end,

	["CreateButton"] = function(self)
		local num = AceGUI:GetNextWidgetNum("TreeGroupButton")
		local button = CreateFrame("Button", ("TSMTreeButton%d"):format(num), self.treeframe, "OptionsListButtonTemplate")
		button.obj = self

		local icon = button:CreateTexture(nil, "OVERLAY")
		icon:SetWidth(14)
		icon:SetHeight(14)
		button.icon = icon

		button.text:SetShadowColor(0, 0, 0, 0)
		button.text:SetPoint("CENTER")

		button:SetScript("OnClick",Button_OnClick)
		button:SetScript("OnDoubleClick", Button_OnDoubleClick)
		button:SetScript("OnEnter",Button_OnEnter)
		button:SetScript("OnLeave",Button_OnLeave)
		
		HIGHLIGHT_COLOR[4] = .5
		button.highlight:SetVertexColor(unpack(HIGHLIGHT_COLOR))

		button.toggle.button = button
		button.toggle:SetScript("OnClick", Expand_OnClick)
		local tex = button.toggle:CreateTexture()
		tex:SetTexture(0, 0, 0, 0)
		button.toggle:SetNormalTexture(tex)
		button.toggle:SetPushedTexture(tex)
		HIGHLIGHT_COLOR[4] = 1
		button.toggle:GetHighlightTexture():SetVertexColor(unpack(HIGHLIGHT_COLOR))
		button.toggle:GetHighlightTexture():SetBlendMode("ADD")
		local text = button.toggle:CreateFontString()
		TSMAPI.Design:SetWidgetLabelColor(text)
		text:SetPoint("CENTER")
		button.toggle.text = text

		return button
	end,

	["SetStatusTable"] = function(self, status)
		assert(type(status) == "table")
		self.status = status
		if not status.groups then
			status.groups = {}
		end
		if not status.scrollvalue then
			status.scrollvalue = 0
		end
		if not status.treewidth then
			status.treewidth = DEFAULT_TREE_WIDTH
		end
		if status.treesizable == nil then
			status.treesizable = DEFAULT_TREE_SIZABLE
		end
		self:SetTreeWidth(status.treewidth,status.treesizable)
		self:RefreshTree()
	end,

	--sets the tree to be displayed
	["SetTree"] = function(self, tree, filter)
		self.filter = filter
		if tree then 
			assert(type(tree) == "table") 
		end
		self.tree = tree
		self:RefreshTree()
	end,

	["BuildLevel"] = function(self, tree, level, parent)
		local groups = (self.status or self.localstatus).groups
		local hasChildren = self.hasChildren
		
		for i, v in ipairs(tree) do
			if v.children then
				if not self.filter or ShouldDisplayLevel(v.children) then
					local line = addLine(self, v, tree, level, parent)
					if groups[line.uniquevalue] then
						self:BuildLevel(v.children, level+1, line)
					end
				end
			elseif v.visible ~= false or not self.filter then
				addLine(self, v, tree, level, parent)
			end
		end
	end,

	["RefreshTree"] = function(self,scrollToSelection)
		local buttons = self.buttons 
		local lines = self.lines

		for i, v in ipairs(buttons) do
			v:Hide()
		end
		while lines[1] do
			local t = tremove(lines)
			for k in pairs(t) do
				t[k] = nil
			end
			del(t)
		end

		if not self.tree then return end
		--Build the list of visible entries from the tree and status tables
		local status = self.status or self.localstatus
		local groupstatus = status.groups
		local tree = self.tree

		local treeframe = self.treeframe
		
		status.scrollToSelection = status.scrollToSelection or scrollToSelection	-- needs to be cached in case the control hasn't been drawn yet (code bails out below)

		self:BuildLevel(tree, 1)

		local numlines = #lines

		local maxlines = (floor(((self.treeframe:GetHeight()or 0) - 20 ) / 18))
		if maxlines <= 0 then return end

		local first, last
		
		scrollToSelection = status.scrollToSelection
		status.scrollToSelection = nil

		if numlines <= maxlines then
			--the whole tree fits in the frame
			status.scrollvalue = 0
			self:ShowScroll(false)
			first, last = 1, numlines
		else
			self:ShowScroll(true)
			--scrolling will be needed
			self.noupdate = true
			self.scrollbar:SetMinMaxValues(0, numlines - maxlines)
			--check if we are scrolled down too far
			if numlines - status.scrollvalue < maxlines then
				status.scrollvalue = numlines - maxlines
			end
			self.noupdate = nil
			first, last = status.scrollvalue+1, status.scrollvalue + maxlines
			--show selection?
			if scrollToSelection and status.selected then
				local show
				for i,line in ipairs(lines) do	-- find the line number
					if line.uniquevalue==status.selected then
						show=i
					end
				end
				if not show then
					-- selection was deleted or something?
				elseif show>=first and show<=last then
					-- all good
				else
					-- scrolling needed!
					if show<first then
						status.scrollvalue = show-1
					else
						status.scrollvalue = show-maxlines
					end
					first, last = status.scrollvalue+1, status.scrollvalue + maxlines
				end
			end
			if self.scrollbar:GetValue() ~= status.scrollvalue then
				self.scrollbar:SetValue(status.scrollvalue)
			end
		end

		local buttonnum = 1
		for i = first, min(last, #lines) do
			local line = lines[i]
			local button = buttons[buttonnum]
			if not button then
				button = self:CreateButton()

				buttons[buttonnum] = button
				button:SetParent(treeframe)
				button:SetFrameLevel(treeframe:GetFrameLevel()+1)
				button:ClearAllPoints()
				if buttonnum == 1 then
					if self.showscroll then
						button:SetPoint("TOPRIGHT", -22, -10)
						button:SetPoint("TOPLEFT", 0, -10)
					else
						button:SetPoint("TOPRIGHT", 0, -10)
						button:SetPoint("TOPLEFT", 0, -10)
					end
				else
					button:SetPoint("TOPRIGHT", buttons[buttonnum-1], "BOTTOMRIGHT",0,0)
					button:SetPoint("TOPLEFT", buttons[buttonnum-1], "BOTTOMLEFT",0,0)
				end
			end

			UpdateButton(button, line, status.selected == line.uniquevalue, line.hasChildren, groupstatus[line.uniquevalue] )
			button:Show()
			buttonnum = buttonnum + 1
		end
		
	end,
	
	["SetSelected"] = function(self, value)
		local status = self.status or self.localstatus
		if status.selected ~= value then
			status.selected = value
			self:Fire("OnGroupSelected", value)
		end
	end,

	["Select"] = function(self, uniquevalue, ...)
		self.filter = false
		local status = self.status or self.localstatus
		local groups = status.groups
		local path = {...}
		for i = 1, #path do
			groups[tconcat(path, "\001", 1, i)] = true
		end
		status.selected = uniquevalue
		self:RefreshTree(true)
		self:Fire("OnGroupSelected", uniquevalue)
	end,

	["SelectByPath"] = function(self, ...)
		self:Select(BuildUniqueValue(...), ...)
	end,

	["SelectByValue"] = function(self, uniquevalue)
		self:Select(uniquevalue, ("\001"):split(uniquevalue))
	end,

	["ShowScroll"] = function(self, show)
		self.showscroll = show
		if show then
			self.scrollbar:Show()
			if self.buttons[1] then
				self.buttons[1]:SetPoint("TOPRIGHT", self.treeframe,"TOPRIGHT",-22,-10)
			end
		else
			self.scrollbar:Hide()
			if self.buttons[1] then
				self.buttons[1]:SetPoint("TOPRIGHT", self.treeframe,"TOPRIGHT",0,-10)
			end
		end
	end,

	["OnWidthSet"] = function(self, width)
		local content = self.content
		local treeframe = self.treeframe
		local status = self.status or self.localstatus
		status.fullwidth = width
		
		local contentwidth = width - status.treewidth - 20
		if contentwidth < 0 then
			contentwidth = 0
		end
		content:SetWidth(contentwidth)
		content.width = contentwidth
		
		local maxtreewidth = math_min(400, width - 50)
		
		if maxtreewidth > 100 and status.treewidth > maxtreewidth then
			self:SetTreeWidth(maxtreewidth, status.treesizable)
		end
		treeframe:SetMaxResize(maxtreewidth, 1600)
	end,

	["OnHeightSet"] = function(self, height)
		local content = self.content
		local contentheight = height - 20
		if contentheight < 0 then
			contentheight = 0
		end
		content:SetHeight(contentheight)
		content.height = contentheight
	end,

	["SetTreeWidth"] = function(self, treewidth, resizable)
		if not resizable then
			if type(treewidth) == 'number' then
				resizable = false
			elseif type(treewidth) == 'boolean' then
				resizable = treewidth
				treewidth = DEFAULT_TREE_WIDTH
			else
				resizable = false
				treewidth = DEFAULT_TREE_WIDTH 
			end
		end
		self.treeframe:SetWidth(treewidth)
		self.dragger:EnableMouse(resizable)
		
		local status = self.status or self.localstatus
		status.treewidth = treewidth
		status.treesizable = resizable
		
		-- recalculate the content width
		if status.fullwidth then
			self:OnWidthSet(status.fullwidth)
		end
	end,

	["GetTreeWidth"] = function(self)
		local status = self.status or self.localstatus
		return status.treewidth or DEFAULT_TREE_WIDTH
	end,

	["LayoutFinished"] = function(self, width, height)
		if self.noAutoHeight then return end
		self:SetHeight((height or 0) + 20)
	end
}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]

local DraggerBackdrop  = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = nil,
	tile = true, tileSize = 16, edgeSize = 0,
	insets = { left = 3, right = 3, top = 7, bottom = 7 }
}

local function Constructor()
	local num = AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Frame", nil, UIParent)

	local treeframe = CreateFrame("Frame", nil, frame)
	treeframe:SetPoint("TOPLEFT")
	treeframe:SetPoint("BOTTOMLEFT")
	treeframe:SetWidth(DEFAULT_TREE_WIDTH)
	treeframe:EnableMouseWheel(true)
	treeframe:SetResizable(true)
	treeframe:SetMinResize(100, 1)
	treeframe:SetMaxResize(400, 1600)
	treeframe:SetScript("OnUpdate", FirstFrameUpdate)
	treeframe:SetScript("OnSizeChanged", Tree_OnSizeChanged)
	treeframe:SetScript("OnMouseWheel", Tree_OnMouseWheel)
	TSMAPI.Design:SetFrameColor(treeframe)

	local dragger = CreateFrame("Frame", nil, treeframe)
	dragger:SetWidth(10)
	dragger:SetPoint("TOPLEFT", treeframe, "TOPRIGHT")
	dragger:SetPoint("BOTTOMLEFT", treeframe, "BOTTOMRIGHT")
	dragger:SetBackdrop(DraggerBackdrop)
	dragger:SetBackdropColor(1, 1, 1, 0)
	dragger:SetScript("OnEnter", Dragger_OnEnter)
	dragger:SetScript("OnLeave", Dragger_OnLeave)
	dragger:SetScript("OnMouseDown", Dragger_OnMouseDown)
	dragger:SetScript("OnMouseUp", Dragger_OnMouseUp)

	local scrollbar = CreateFrame("Slider", ("TSMTreeGroup%dScrollBar"):format(num), treeframe, "UIPanelScrollBarTemplate")
	scrollbar:SetScript("OnValueChanged", nil)
	scrollbar:SetPoint("TOPRIGHT", -10, -26)
	scrollbar:SetPoint("BOTTOMRIGHT", -10, 26)
	scrollbar:SetMinMaxValues(0,0)
	scrollbar:SetValueStep(1)
	scrollbar:SetValue(0)
	scrollbar:SetWidth(12)
	scrollbar:SetScript("OnValueChanged", OnScrollValueChanged)
	
	local thumbTex = scrollbar:GetThumbTexture()
	thumbTex:SetPoint("CENTER")
	TSMAPI.Design:SetContentColor(thumbTex)
	thumbTex:SetHeight(150)
	thumbTex:SetWidth(scrollbar:GetWidth())

	local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND")
	scrollbg:SetAllPoints(scrollbar)
	TSMAPI.Design:SetFrameColor(scrollbg)
	
	_G[scrollbar:GetName().."ScrollUpButton"]:Hide()
	_G[scrollbar:GetName().."ScrollDownButton"]:Hide()

	local border = CreateFrame("Frame",nil,frame)
	border:SetPoint("TOPLEFT", dragger, "TOPRIGHT", -1, 0)
	border:SetPoint("BOTTOMRIGHT")
	TSMAPI.Design:SetFrameColor(border)

	--Container Support
	local content = CreateFrame("Frame", nil, border)
	content:SetPoint("TOPLEFT", 6, -6)
	content:SetPoint("BOTTOMRIGHT", -6, 6)

	local widget = {
		frame        = frame,
		lines        = {},
		levels       = {},
		buttons      = {},
		hasChildren  = {},
		localstatus  = {groups={}, scrollvalue=0},
		filter       = false,
		treeframe    = treeframe,
		dragger      = dragger,
		scrollbar    = scrollbar,
		border       = border,
		content      = content,
		type         = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end
	treeframe.obj, dragger.obj, scrollbar.obj = widget, widget, widget
	
	return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)