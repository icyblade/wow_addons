
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return 
end

local _
--> lua locals
local _rawset = rawset --> lua local
local _rawget = rawget --> lua local
local _setmetatable = setmetatable --> lua local
local _unpack = unpack --> lua local
local _type = type --> lua local
local _math_floor = math.floor --> lua local
local loadstring = loadstring --> lua local

local cleanfunction = function() end
local APIFrameFunctions

do
	local metaPrototype = {
		WidgetType = "panel",
		SetHook = DF.SetHook,
		RunHooksForWidget = DF.RunHooksForWidget,
	}

	_G [DF.GlobalWidgetControlNames ["panel"]] = _G [DF.GlobalWidgetControlNames ["panel"]] or metaPrototype
end

local PanelMetaFunctions = _G [DF.GlobalWidgetControlNames ["panel"]]

------------------------------------------------------------------------------------------------------------
--> metatables

	PanelMetaFunctions.__call = function (_table, value)
		--> nothing to do
		return true
	end

------------------------------------------------------------------------------------------------------------
--> members

	--> tooltip
	local gmember_tooltip = function (_object)
		return _object:GetTooltip()
	end
	--> shown
	local gmember_shown = function (_object)
		return _object:IsShown()
	end
	--> backdrop color
	local gmember_color = function (_object)
		return _object.frame:GetBackdropColor()
	end
	--> backdrop table
	local gmember_backdrop = function (_object)
		return _object.frame:GetBackdrop()
	end
	--> frame width
	local gmember_width = function (_object)
		return _object.frame:GetWidth()
	end
	--> frame height
	local gmember_height = function (_object)
		return _object.frame:GetHeight()
	end
	--> locked
	local gmember_locked = function (_object)
		return _rawget (_object, "is_locked")
	end

	PanelMetaFunctions.GetMembers = PanelMetaFunctions.GetMembers or {}
	PanelMetaFunctions.GetMembers ["tooltip"] = gmember_tooltip
	PanelMetaFunctions.GetMembers ["shown"] = gmember_shown
	PanelMetaFunctions.GetMembers ["color"] = gmember_color
	PanelMetaFunctions.GetMembers ["backdrop"] = gmember_backdrop
	PanelMetaFunctions.GetMembers ["width"] = gmember_width
	PanelMetaFunctions.GetMembers ["height"] = gmember_height
	PanelMetaFunctions.GetMembers ["locked"] = gmember_locked
	
	PanelMetaFunctions.__index = function (_table, _member_requested)

		local func = PanelMetaFunctions.GetMembers [_member_requested]
		if (func) then
			return func (_table, _member_requested)
		end
		
		local fromMe = _rawget (_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return PanelMetaFunctions [_member_requested]
	end
	

	--> tooltip
	local smember_tooltip = function (_object, _value)
		return _object:SetTooltip (_value)
	end
	--> show
	local smember_show = function (_object, _value)
		if (_value) then
			return _object:Show()
		else
			return _object:Hide()
		end
	end
	--> hide
	local smember_hide = function (_object, _value)
		if (not _value) then
			return _object:Show()
		else
			return _object:Hide()
		end
	end
	--> backdrop color
	local smember_color = function (_object, _value)
		local _value1, _value2, _value3, _value4 = DF:ParseColors (_value)
		return _object:SetBackdropColor (_value1, _value2, _value3, _value4)
	end
	--> frame width
	local smember_width = function (_object, _value)
		return _object.frame:SetWidth (_value)
	end
	--> frame height
	local smember_height = function (_object, _value)
		return _object.frame:SetHeight (_value)
	end

	--> locked
	local smember_locked = function (_object, _value)
		if (_value) then
			_object.frame:SetMovable (false)
			return _rawset (_object, "is_locked", true)
		else
			_object.frame:SetMovable (true)
			_rawset (_object, "is_locked", false)
			return
		end
	end	
	
	--> backdrop
	local smember_backdrop = function (_object, _value)
		return _object.frame:SetBackdrop (_value)
	end
	
	--> close with right button
	local smember_right_close = function (_object, _value)
		return _rawset (_object, "rightButtonClose", _value)
	end
	
	PanelMetaFunctions.SetMembers = PanelMetaFunctions.SetMembers or {}
	PanelMetaFunctions.SetMembers["tooltip"] = smember_tooltip
	PanelMetaFunctions.SetMembers["show"] = smember_show
	PanelMetaFunctions.SetMembers["hide"] = smember_hide
	PanelMetaFunctions.SetMembers["color"] = smember_color
	PanelMetaFunctions.SetMembers["backdrop"] = smember_backdrop
	PanelMetaFunctions.SetMembers["width"] = smember_width
	PanelMetaFunctions.SetMembers["height"] = smember_height
	PanelMetaFunctions.SetMembers["locked"] = smember_locked
	PanelMetaFunctions.SetMembers["close_with_right"] = smember_right_close

	PanelMetaFunctions.__newindex = function (_table, _key, _value)
		local func = PanelMetaFunctions.SetMembers [_key]
		if (func) then
			return func (_table, _value)
		else
			return _rawset (_table, _key, _value)
		end
	end

------------------------------------------------------------------------------------------------------------
--> methods

--> right click to close
	function PanelMetaFunctions:CreateRightClickLabel (textType, w, h, close_text)
		local text
		w = w or 20
		h = h or 20
		
		if (close_text) then
			text = close_text
		else
			if (textType) then
				textType = string.lower (textType)
				if (textType == "short") then
					text = "close window"
				elseif (textType == "medium") then
					text = "close window"
				elseif (textType == "large") then
					text = "close window"
				end
			else
				text = "close window"
			end
		end
		
		return DF:NewLabel (self, _, "$parentRightMouseToClose", nil, "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:"..w..":"..h..":0:1:512:512:8:70:328:409|t " .. text)
	end

--> show & hide
	function PanelMetaFunctions:Show()
		self.frame:Show()
		
	end
	function PanelMetaFunctions:Hide()
		self.frame:Hide()
		
	end

-- setpoint
	function PanelMetaFunctions:SetPoint (v1, v2, v3, v4, v5)
		v1, v2, v3, v4, v5 = DF:CheckPoints (v1, v2, v3, v4, v5, self)
		if (not v1) then
			print ("Invalid parameter for SetPoint")
			return
		end
		return self.widget:SetPoint (v1, v2, v3, v4, v5)
	end
	
-- sizes 
	function PanelMetaFunctions:SetSize (w, h)
		if (w) then
			self.frame:SetWidth (w)
		end
		if (h) then
			self.frame:SetHeight (h)
		end
	end
	
-- clear
	function PanelMetaFunctions:HideWidgets()
		for widgetName, widgetSelf in pairs (self) do 
			if (type (widgetSelf) == "table" and widgetSelf.dframework) then
				widgetSelf:Hide()
			end
		end
	end

-- backdrop
	function PanelMetaFunctions:SetBackdrop (background, edge, tilesize, edgesize, tile, left, right, top, bottom)
	
		if (_type (background) == "boolean" and not background) then
			return self.frame:SetBackdrop (nil)
			
		elseif (_type (background) == "table") then
			self.frame:SetBackdrop (background)
			
		else
			local currentBackdrop = self.frame:GetBackdrop() or {edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border", bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", tile=true, tileSize=16, edgeSize=16, insets={left=1, right=0, top=0, bottom=0}}
			currentBackdrop.bgFile = background or currentBackdrop.bgFile
			currentBackdrop.edgeFile = edgeFile or currentBackdrop.edgeFile
			currentBackdrop.tileSize = tilesize or currentBackdrop.tileSize
			currentBackdrop.edgeSize = edgesize or currentBackdrop.edgeSize
			currentBackdrop.tile = tile or currentBackdrop.tile
			currentBackdrop.insets.left = left or currentBackdrop.insets.left
			currentBackdrop.insets.right = left or currentBackdrop.insets.right
			currentBackdrop.insets.top = left or currentBackdrop.insets.top
			currentBackdrop.insets.bottom = left or currentBackdrop.insets.bottom
			self.frame:SetBackdrop (currentBackdrop)
		end
	end
	
-- backdropcolor
	function PanelMetaFunctions:SetBackdropColor (color, arg2, arg3, arg4)
		if (arg2) then
			self.frame:SetBackdropColor (color, arg2, arg3, arg4 or 1)
		else
			local _value1, _value2, _value3, _value4 = DF:ParseColors (color)
			self.frame:SetBackdropColor (_value1, _value2, _value3, _value4)
		end
	end
	
-- border color	
	function PanelMetaFunctions:SetBackdropBorderColor (color, arg2, arg3, arg4)
		if (arg2) then
			return self.frame:SetBackdropBorderColor (color, arg2, arg3, arg4)
		end
		local _value1, _value2, _value3, _value4 = DF:ParseColors (color)
		self.frame:SetBackdropBorderColor (_value1, _value2, _value3, _value4)
	end
	
-- tooltip
	function PanelMetaFunctions:SetTooltip (tooltip)
		if (tooltip) then
			return _rawset (self, "have_tooltip", tooltip)
		else
			return _rawset (self, "have_tooltip", nil)
		end
	end
	function PanelMetaFunctions:GetTooltip()
		return _rawget (self, "have_tooltip")
	end

-- frame levels
	function PanelMetaFunctions:GetFrameLevel()
		return self.widget:GetFrameLevel()
	end
	function PanelMetaFunctions:SetFrameLevel (level, frame)
		if (not frame) then
			return self.widget:SetFrameLevel (level)
		else
			local framelevel = frame:GetFrameLevel (frame) + level
			return self.widget:SetFrameLevel (framelevel)
		end
	end

-- frame stratas
	function PanelMetaFunctions:SetFrameStrata()
		return self.widget:GetFrameStrata()
	end
	function PanelMetaFunctions:SetFrameStrata (strata)
		if (_type (strata) == "table") then
			self.widget:SetFrameStrata (strata:GetFrameStrata())
		else
			self.widget:SetFrameStrata (strata)
		end
	end

------------------------------------------------------------------------------------------------------------
--> scripts
	
	local OnEnter = function (frame)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget ("OnEnter", frame, capsule)
		if (kill) then
			return
		end
		
		if (frame.MyObject.have_tooltip) then 
			GameCooltip2:Reset()
			GameCooltip2:SetType ("tooltip")
			GameCooltip2:SetColor ("main", "transparent")
			GameCooltip2:AddLine (frame.MyObject.have_tooltip)
			GameCooltip2:SetOwner (frame)
			GameCooltip2:ShowCooltip()
		end
	end

	local OnLeave = function (frame)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget ("OnLeave", frame, capsule)
		if (kill) then
			return
		end
		
		if (frame.MyObject.have_tooltip) then 
			GameCooltip2:ShowMe (false)
		end
		
	end
	
	local OnHide = function (frame)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget ("OnHide", frame, capsule)
		if (kill) then
			return
		end
	end
	
	local OnShow = function (frame)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget ("OnShow", frame, capsule)
		if (kill) then
			return
		end
	end
	
	local OnMouseDown = function (frame, button)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget ("OnMouseDown", frame, button, capsule)
		if (kill) then
			return
		end
		
		if (frame.MyObject.container == UIParent) then
			if (not frame.isLocked and frame:IsMovable()) then
				frame.isMoving = true
				frame:StartMoving()
			end
		
		elseif (not frame.MyObject.container.isLocked and frame.MyObject.container:IsMovable()) then
			if (not frame.isLocked and frame:IsMovable()) then
				frame.MyObject.container.isMoving = true
				frame.MyObject.container:StartMoving()
			end
		end
		

	end
	
	local OnMouseUp = function (frame, button)
		local capsule = frame.MyObject
		local kill = capsule:RunHooksForWidget ("OnMouseUp", frame, button, capsule)
		if (kill) then
			return
		end
		
		if (button == "RightButton" and frame.MyObject.rightButtonClose) then
			frame.MyObject:Hide()
		end
		
		if (frame.MyObject.container == UIParent) then
			if (frame.isMoving) then
				frame:StopMovingOrSizing()
				frame.isMoving = false
			end
		else
			if (frame.MyObject.container.isMoving) then
				frame.MyObject.container:StopMovingOrSizing()
				frame.MyObject.container.isMoving = false
			end
		end
	end
	
------------------------------------------------------------------------------------------------------------
--> object constructor
function DF:CreatePanel (parent, w, h, backdrop, backdropcolor, bordercolor, member, name)
	return DF:NewPanel (parent, parent, name, member, w, h, backdrop, backdropcolor, bordercolor)
end

function DF:NewPanel (parent, container, name, member, w, h, backdrop, backdropcolor, bordercolor)

	if (not name) then
		name = "DetailsFrameworkPanelNumber" .. DF.PanelCounter
		DF.PanelCounter = DF.PanelCounter + 1

	elseif (not parent) then
		parent = UIParent
	end
	if (not container) then
		container = parent
	end
	
	if (name:find ("$parent")) then
		name = name:gsub ("$parent", parent:GetName())
	end
	
	local PanelObject = {type = "panel", dframework = true}
	
	if (member) then
		parent [member] = PanelObject
	end
	
	if (parent.dframework) then
		parent = parent.widget
	end
	if (container.dframework) then
		container = container.widget
	end

	--> default members:
		--> misc
		PanelObject.is_locked = true
		PanelObject.container = container
		PanelObject.rightButtonClose = false
	
	PanelObject.frame = CreateFrame ("frame", name, parent, "DetailsFrameworkPanelTemplate")
	PanelObject.widget = PanelObject.frame
	
	if (not APIFrameFunctions) then
		APIFrameFunctions = {}
		local idx = getmetatable (PanelObject.frame).__index
		for funcName, funcAddress in pairs (idx) do 
			if (not PanelMetaFunctions [funcName]) then
				PanelMetaFunctions [funcName] = function (object, ...)
					local x = loadstring ( "return _G['"..object.frame:GetName().."']:"..funcName.."(...)")
					return x (...)
				end
			end
		end
	end
	
	PanelObject.frame:SetWidth (w or 100)
	PanelObject.frame:SetHeight (h or 100)
	
	PanelObject.frame.MyObject = PanelObject
	
	PanelObject.HookList = {
		OnEnter = {},
		OnLeave = {},
		OnHide = {},
		OnShow = {},
		OnMouseDown = {},
		OnMouseUp = {},
	}
	
	--> hooks
		PanelObject.frame:SetScript ("OnEnter", OnEnter)
		PanelObject.frame:SetScript ("OnLeave", OnLeave)
		PanelObject.frame:SetScript ("OnHide", OnHide)
		PanelObject.frame:SetScript ("OnShow", OnShow)
		PanelObject.frame:SetScript ("OnMouseDown", OnMouseDown)
		PanelObject.frame:SetScript ("OnMouseUp", OnMouseUp)
		
	_setmetatable (PanelObject, PanelMetaFunctions)

	if (backdrop) then
		PanelObject:SetBackdrop (backdrop)
	elseif (_type (backdrop) == "boolean") then
		PanelObject.frame:SetBackdrop (nil)
	end
	
	if (backdropcolor) then
		PanelObject:SetBackdropColor (backdropcolor)
	end
	
	if (bordercolor) then
		PanelObject:SetBackdropBorderColor (bordercolor)
	end

	return PanelObject
end

------------fill panel

local button_on_enter = function (self)
	self.MyObject._icon:SetBlendMode ("ADD")
	if (self.MyObject.onenter_func) then
		pcall (self.MyObject.onenter_func, self.MyObject)
	end
end
local button_on_leave = function (self)
	self.MyObject._icon:SetBlendMode ("BLEND")
	if (self.MyObject.onleave_func) then
		pcall (self.MyObject.onleave_func, self.MyObject)
	end
end

local add_row = function (self, t, need_update)
	local index = #self.rows+1
	
	local thisrow = DF:NewPanel (self, self, "$parentHeader_" .. self._name .. index, nil, 1, 20)
	thisrow.backdrop = {bgFile = [[Interface\DialogFrame\UI-DialogBox-Gold-Background]]}
	thisrow.color = "silver"
	thisrow.type = t.type
	thisrow.func = t.func
	thisrow.name = t.name
	thisrow.notext = t.notext
	thisrow.icon = t.icon
	thisrow.iconalign = t.iconalign
	
	thisrow.hidden = t.hidden or false
	
	thisrow.onenter = t.onenter
	thisrow.onleave = t.onleave
	
	local text = DF:NewLabel (thisrow, nil, self._name .. "$parentLabel" .. index, "text")
	text:SetPoint ("left", thisrow, "left", 2, 0)
	text:SetText (t.name)

	tinsert (self._raw_rows, t)
	tinsert (self.rows, thisrow)
	
	if (need_update) then
		self:AlignRows()
	end
end

local align_rows = function (self)

	local rows_shown = 0
	for index, row in ipairs (self.rows) do
		if (not row.hidden) then
			rows_shown = rows_shown + 1
		end
	end

	local cur_width = 0
	local row_width = self._width / rows_shown

	local sindex = 1
	
	wipe (self._anchors)
	
	for index, row in ipairs (self.rows) do
		if (not row.hidden) then
			if (self._autowidth) then
				if (self._raw_rows [index].width) then
					row.width = self._raw_rows [index].width
				else
					row.width = row_width
				end
				row:SetPoint ("topleft", self, "topleft", cur_width, 0)
				tinsert (self._anchors, cur_width)
				cur_width = cur_width + row_width + 1
			else
				row:SetPoint ("topleft", self, "topleft", cur_width, 0)
				row.width = self._raw_rows [index].width
				tinsert (self._anchors, cur_width)
				cur_width = cur_width + self._raw_rows [index].width + 1
			end
			
			row:Show()

			local type = row.type

			if (type == "text") then
				for i = 1, #self.scrollframe.lines do
					local line = self.scrollframe.lines [i]
					local text = tremove (line.text_available)
					if (not text) then
						self:CreateRowText (line)
						text = tremove (line.text_available)
					end
					tinsert (line.text_inuse, text)
					text:SetPoint ("left", line, "left", self._anchors [#self._anchors], 0)
					text:SetWidth (row.width)
					
					DF:SetFontSize (text, row.textsize or 10)
					text:SetJustifyH (row.textalign or "left")
				end
			elseif (type == "entry") then
				for i = 1, #self.scrollframe.lines do
					local line = self.scrollframe.lines [i]
					local entry = tremove (line.entry_available)
					if (not entry) then
						self:CreateRowEntry (line)
						entry = tremove (line.entry_available)
					end
					tinsert (line.entry_inuse, entry)
					entry:SetPoint ("left", line, "left", self._anchors [#self._anchors], 0)
					if (sindex == rows_shown) then
						entry:SetWidth (row.width - 25)
					else
						entry:SetWidth (row.width)
					end
					entry.func = row.func
					
					entry.onenter_func = nil
					entry.onleave_func = nil
					
					if (row.onenter) then
						entry.onenter_func = row.onenter
					end
					if (row.onleave) then
						entry.onleave_func = row.onleave
					end
				end
			elseif (type == "button") then
				for i = 1, #self.scrollframe.lines do
					local line = self.scrollframe.lines [i]
					local button = tremove (line.button_available)
					if (not button) then
						self:CreateRowButton (line)
						button = tremove (line.button_available)
					end
					tinsert (line.button_inuse, button)
					button:SetPoint ("left", line, "left", self._anchors [#self._anchors], 0)
					if (sindex == rows_shown) then
						button:SetWidth (row.width - 25)
					else
						button:SetWidth (row.width)
					end
					
					if (row.icon) then
						button._icon.texture = row.icon
						button._icon:ClearAllPoints()
						if (row.iconalign) then
							if (row.iconalign == "center") then
								button._icon:SetPoint ("center", button, "center")
							elseif (row.iconalign == "right") then
								button._icon:SetPoint ("right", button, "right")
							end
						else
							button._icon:SetPoint ("left", button, "left")
						end
					end
					
					if (row.name and not row.notext) then
						button._text:SetPoint ("left", button._icon, "right", 2, 0)
						button._text.text = row.name
					end
					
					button.onenter_func = nil
					button.onleave_func = nil
					
					if (row.onenter) then
						button.onenter_func = row.onenter
					end
					if (row.onleave) then
						button.onleave_func = row.onleave
					end
					
				end
			elseif (type == "icon") then
				for i = 1, #self.scrollframe.lines do
					local line = self.scrollframe.lines [i]
					local icon = tremove (line.icon_available)
					if (not icon) then
						self:CreateRowIcon (line)
						icon = tremove (line.icon_available)
					end
					tinsert (line.icon_inuse, icon)
					icon:SetPoint ("left", line, "left", self._anchors [#self._anchors] + ( ((row.width or 22) - 22) / 2), 0)
					icon.func = row.func
				end
				
			elseif (type == "texture") then
				for i = 1, #self.scrollframe.lines do
					local line = self.scrollframe.lines [i]
					local texture = tremove (line.texture_available)
					if (not texture) then
						self:CreateRowTexture (line)
						texture = tremove (line.texture_available)
					end
					tinsert (line.texture_inuse, texture)
					texture:SetPoint ("left", line, "left", self._anchors [#self._anchors] + ( ((row.width or 22) - 22) / 2), 0)
				end
				
			end
			
			sindex = sindex + 1
		else
			row:Hide()
		end
	end
	
	if (#self.rows > 0) then
		if (self._autowidth) then
			self.rows [#self.rows]:SetWidth (row_width - rows_shown + 1)
		else
			self.rows [#self.rows]:SetWidth (self._raw_rows [rows_shown].width - rows_shown + 1)
		end
	end
	
	self.showing_amt = rows_shown
end

local update_rows = function (self, updated_rows)

	for i = 1, #updated_rows do
		local t = updated_rows [i]
		local raw = self._raw_rows [i]
		
		if (not raw) then
			self:AddRow (t)
		else
			raw.name = t.name
			raw.hidden = t.hidden or false
			raw.textsize = t.textsize
			raw.textalign = t.textalign
			
			local widget = self.rows [i]
			widget.name = t.name
			widget.textsize = t.textsize
			widget.textalign = t.textalign
			widget.hidden = t.hidden or false
			
			--
			widget.onenter = t.onenter
			widget.onleave = t.onleave
			--
			
			widget.text:SetText (t.name)
			DF:SetFontSize (widget.text, raw.textsize or 10)
			widget.text:SetJustifyH (raw.textalign or "left")
			
		end
	end
	
	for i = #updated_rows+1, #self._raw_rows do
		local raw = self._raw_rows [i]
		local widget = self.rows [i]
		raw.hidden = true
		widget.hidden = true
	end
	
	for index, row in ipairs (self.scrollframe.lines) do
		for i = #row.text_inuse, 1, -1 do
			tinsert (row.text_available, tremove (row.text_inuse, i))
		end
		for i = 1, #row.text_available do
			row.text_available[i]:Hide()
		end
		
		for i = #row.entry_inuse, 1, -1 do
			tinsert (row.entry_available, tremove (row.entry_inuse, i))
		end
		for i = 1, #row.entry_available do
			row.entry_available[i]:Hide()
		end
		
		for i = #row.button_inuse, 1, -1 do
			tinsert (row.button_available, tremove (row.button_inuse, i))
		end
		for i = 1, #row.button_available do
			row.button_available[i]:Hide()
		end
		
		for i = #row.icon_inuse, 1, -1 do
			tinsert (row.icon_available, tremove (row.icon_inuse, i))
		end
		for i = 1, #row.icon_available do
			row.icon_available[i]:Hide()
		end
		
		for i = #row.texture_inuse, 1, -1 do
			tinsert (row.texture_available, tremove (row.texture_inuse, i))
		end
		for i = 1, #row.texture_available do
			row.texture_available[i]:Hide()
		end
	end
	
	self.current_header = updated_rows
	
	self:AlignRows()

end

local create_panel_text = function (self, row)
	row.text_total = row.text_total + 1
	local text = DF:NewLabel (row, nil, self._name .. "$parentLabel" .. row.text_total, "text" .. row.text_total)
	tinsert (row.text_available, text)
end

local create_panel_entry = function (self, row)
	row.entry_total = row.entry_total + 1
	local editbox = DF:NewTextEntry (row, nil, "$parentEntry" .. row.entry_total, "entry", 120, 20)
	editbox.align = "left"
	
	editbox:SetHook ("OnEnterPressed", function()
		editbox.widget.focuslost = true
		editbox:ClearFocus()
		editbox.func (editbox.index, editbox.text)
		return true
	end)
	
	editbox:SetHook ("OnEnter", function()
		if (editbox.onenter_func) then
			pcall (editbox.onenter_func, editbox)
		end
	end)
	editbox:SetHook ("OnLeave", function()
		if (editbox.onleave_func) then
			pcall (editbox.onleave_func, editbox)
		end
	end)
	
	editbox:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]], edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 1})
	editbox:SetBackdropColor (1, 1, 1, 0.1)
	editbox:SetBackdropBorderColor (1, 1, 1, 0.1)
	editbox.editbox.current_bordercolor = {1, 1, 1, 0.1}
	
	tinsert (row.entry_available, editbox)
end

local create_panel_button = function (self, row)
	row.button_total = row.button_total + 1
	local button = DF:NewButton (row, nil, "$parentButton" .. row.button_total, "button" .. row.button_total, 120, 20)

	--> create icon and the text
	local icon = DF:NewImage (button, nil, 20, 20)
	local text = DF:NewLabel (button)
	
	button._icon = icon
	button._text = text

	button:SetHook ("OnEnter", button_on_enter)
	button:SetHook ("OnLeave", button_on_leave)
	
	tinsert (row.button_available, button)
end

local icon_onclick = function (texture, iconbutton)
	iconbutton._icon.texture = texture
	iconbutton.func (iconbutton.index, texture)
end

local create_panel_icon = function (self, row)
	row.icon_total = row.icon_total + 1
	local iconbutton = DF:NewButton (row, nil, "$parentIconButton" .. row.icon_total, "iconbutton", 22, 20)
	iconbutton:InstallCustomTexture()
	
	iconbutton:SetHook ("OnEnter", button_on_enter)
	iconbutton:SetHook ("OnLeave", button_on_leave)
	
	iconbutton:SetHook ("OnMouseUp", function()
		DF:IconPick (icon_onclick, true, iconbutton)
		return true
	end)
	
	local icon = DF:NewImage (iconbutton, nil, 20, 20, "artwork", nil, "_icon", "$parentIcon" .. row.icon_total)
	iconbutton._icon = icon

	icon:SetPoint ("center", iconbutton, "center", 0, 0)

	tinsert (row.icon_available, iconbutton)
end

local create_panel_texture = function (self, row)
	row.texture_total = row.texture_total + 1
	local texture = DF:NewImage (row, nil, 20, 20, "artwork", nil, "_icon" .. row.texture_total, "$parentIcon" .. row.texture_total)
	tinsert (row.texture_available, texture)
end

local set_fill_function = function (self, func)
	self._fillfunc = func
end
local set_total_function = function (self, func)
	self._totalfunc = func
end
local drop_header_function = function (self)
	wipe (self.rows)
end

local fillpanel_update_size = function (self, elapsed)
	local panel = self.MyObject
	
	panel._width = panel:GetWidth()
	panel._height = panel:GetHeight()
		
	panel:UpdateRowAmount()
	if (panel.current_header) then
		update_rows (panel, panel.current_header)
	end
	panel:Refresh()
	
	self:SetScript ("OnUpdate", nil)
end

 -- ~fillpanel
  --alias
function DF:CreateFillPanel (parent, rows, w, h, total_lines, fill_row, autowidth, options, member, name)
	return DF:NewFillPanel (parent, rows, name, member, w, h, total_lines, fill_row, autowidth, options)
end
 
function DF:NewFillPanel (parent, rows, name, member, w, h, total_lines, fill_row, autowidth, options)
	
	local panel = DF:NewPanel (parent, parent, name, member, w, h)
	panel.backdrop = nil
	
	options = options or {rowheight = 20}
	panel.rows = {}
	
	panel.AddRow = add_row
	panel.AlignRows = align_rows
	panel.UpdateRows = update_rows
	panel.CreateRowText = create_panel_text
	panel.CreateRowEntry = create_panel_entry
	panel.CreateRowButton = create_panel_button
	panel.CreateRowIcon = create_panel_icon
	panel.CreateRowTexture = create_panel_texture
	panel.SetFillFunction = set_fill_function
	panel.SetTotalFunction = set_total_function
	panel.DropHeader = drop_header_function
	
	panel._name = name
	panel._width = w
	panel._height = h
	panel._raw_rows = {}
	panel._anchors = {}
	panel._fillfunc = fill_row
	panel._totalfunc = total_lines
	panel._autowidth = autowidth
	
	panel:SetScript ("OnSizeChanged", function() 
		panel:SetScript ("OnUpdate", fillpanel_update_size)
	end)
	
	for index, t in ipairs (rows) do 
		panel.AddRow (panel, t)
	end

	local refresh_fillbox = function (self)
	
		local offset = FauxScrollFrame_GetOffset (self)
		local filled_lines = panel._totalfunc (panel)		
	
		for index = 1, #self.lines do
	
			local row = self.lines [index]
			if (index <= filled_lines) then

				local real_index = index + offset
				local results = panel._fillfunc (real_index, panel)
				
				if (results and results [1]) then
					row:Show()

					local text, entry, button, icon, texture = 1, 1, 1, 1, 1
					
					for index, t in ipairs (panel.rows) do
						if (not t.hidden) then
							if (t.type == "text") then
								local fontstring = row.text_inuse [text]
								text = text + 1
								fontstring:SetText (results [index])
								fontstring.index = real_index
								fontstring:Show()

							elseif (t.type == "entry") then
								local entrywidget = row.entry_inuse [entry]
								entry = entry + 1
								entrywidget.index = real_index
								
								if (type (results [index]) == "table") then
									entrywidget:SetText (results [index].text)
									entrywidget.id = results [index].id
									entrywidget.data1 = results [index].data1
									entrywidget.data2 = results [index].data2
								else
									entrywidget:SetText (results [index])
								end
								
								entrywidget:SetCursorPosition(0)
								
								entrywidget:Show()
								
							elseif (t.type == "button") then
								local buttonwidget = row.button_inuse [button]
								button = button + 1
								buttonwidget.index = real_index

								if (type (results [index]) == "table") then
									if (results [index].text) then
										buttonwidget:SetText (results [index].text)
									end
									
									if (results [index].icon) then
										buttonwidget._icon:SetTexture (results [index].icon)
									end
									
									if (results [index].func) then
										local func = function()
											t.func (real_index, results [index].value)
											panel:Refresh()
										end
										buttonwidget:SetClickFunction (func)
									else
										local func = function()
											t.func (real_index, index)
											panel:Refresh()
										end
										buttonwidget:SetClickFunction (func)
									end
									
									buttonwidget.id = results [index].id
									buttonwidget.data1 = results [index].data1
									buttonwidget.data2 = results [index].data2
									
								else
									local func = function()
										t.func (real_index, index)
										panel:Refresh()
									end
									buttonwidget:SetClickFunction (func)
									buttonwidget:SetText (results [index])
								end
								
								buttonwidget:Show()
								
							elseif (t.type == "icon") then
								local iconwidget = row.icon_inuse [icon]
								icon = icon + 1
								
								iconwidget.line = index
								iconwidget.index = real_index
								
								--print (index, results [index])
								if (type (results [index]) == "string") then
									local result = results [index]:gsub (".-%\\", "")
									iconwidget._icon.texture = results [index]
								else
									iconwidget._icon:SetTexture (results [index])
								end
								
								iconwidget:Show()
								
							elseif (t.type == "texture") then
								local texturewidget = row.texture_inuse [texture]
								texture = texture + 1
								
								texturewidget.line = index
								texturewidget.index = real_index

								if (type (results [index]) == "string") then
									local result = results [index]:gsub (".-%\\", "")
									texturewidget.texture = results [index]
								else
									texturewidget:SetTexture (results [index])
								end
								
								texturewidget:Show()
							end
						end
					end

				else
					row:Hide()
				end
			else
				row:Hide()
			end
		end
	end
	
	function panel:Refresh()
		if (type (panel._totalfunc) == "boolean") then
			--> not yet initialized
			return
		end
		local filled_lines = panel._totalfunc (panel)
		local scroll_total_lines = #panel.scrollframe.lines
		local line_height = options.rowheight
		refresh_fillbox (panel.scrollframe)
		FauxScrollFrame_Update (panel.scrollframe, filled_lines, scroll_total_lines, line_height)
		panel.scrollframe:Show()
	end
	
	local scrollframe = CreateFrame ("scrollframe", name .. "Scroll", panel.widget, "FauxScrollFrameTemplate")
	scrollframe:SetScript ("OnVerticalScroll", function (self, offset) FauxScrollFrame_OnVerticalScroll (self, offset, 20, panel.Refresh) end)
	scrollframe:SetPoint ("topleft", panel.widget, "topleft", 0, -21)
	scrollframe:SetPoint ("topright", panel.widget, "topright", -23, -21)
	scrollframe:SetPoint ("bottomleft", panel.widget, "bottomleft")
	scrollframe:SetPoint ("bottomright", panel.widget, "bottomright", -23, 0)
	scrollframe:SetSize (w, h)
	panel.scrollframe = scrollframe
	scrollframe.lines = {}
	
	--create lines
	function panel:UpdateRowAmount()
		local size = options.rowheight
		local amount = math.floor (((panel._height-21) / size))

		for i = #scrollframe.lines+1, amount do
			local row = CreateFrame ("frame", panel:GetName() .. "Row_" .. i, panel.widget)
			row:SetSize (1, size)
			row.color = {1, 1, 1, .2}
			
			row:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]]})
			
			if (i%2 == 0) then
				row:SetBackdropColor (.5, .5, .5, 0.2)
			else
				row:SetBackdropColor (1, 1, 1, 0.00)
			end
			
			row:SetPoint ("topleft", scrollframe, "topleft", 0, (i-1) * size * -1)
			row:SetPoint ("topright", scrollframe, "topright", 0, (i-1) * size * -1)
			tinsert (scrollframe.lines, row)
			
			row.text_available = {}
			row.text_inuse = {}
			row.text_total = 0
			
			row.entry_available = {}
			row.entry_inuse = {}
			row.entry_total = 0
			
			row.button_available = {}
			row.button_inuse = {}
			row.button_total = 0
			
			row.icon_available = {}
			row.icon_inuse = {}
			row.icon_total = 0

			row.texture_available = {}
			row.texture_inuse = {}
			row.texture_total = 0
		end
	end
	panel:UpdateRowAmount()

	panel.AlignRows (panel)
	
	return panel
end


------------color pick
local color_pick_func = function()
	local r, g, b = ColorPickerFrame:GetColorRGB()
	local a = OpacitySliderFrame:GetValue()
	ColorPickerFrame:dcallback (r, g, b, a, ColorPickerFrame.dframe)
end
local color_pick_func_cancel = function()
	ColorPickerFrame:SetColorRGB (unpack (ColorPickerFrame.previousValues))
	local r, g, b = ColorPickerFrame:GetColorRGB()
	local a = OpacitySliderFrame:GetValue()
	ColorPickerFrame:dcallback (r, g, b, a, ColorPickerFrame.dframe)
end

function DF:ColorPick (frame, r, g, b, alpha, callback)

	ColorPickerFrame:ClearAllPoints()
	ColorPickerFrame:SetPoint ("bottomleft", frame, "topright", 0, 0)
	
	ColorPickerFrame.dcallback = callback
	ColorPickerFrame.dframe = frame
	
	ColorPickerFrame.func = color_pick_func
	ColorPickerFrame.opacityFunc = color_pick_func
	ColorPickerFrame.cancelFunc = color_pick_func_cancel
	
	ColorPickerFrame.opacity = alpha
	ColorPickerFrame.hasOpacity = alpha and true
	
	ColorPickerFrame.previousValues = {r, g, b}
	ColorPickerFrame:SetParent (UIParent)
	ColorPickerFrame:SetFrameStrata ("tooltip")
	ColorPickerFrame:SetColorRGB (r, g, b)
	ColorPickerFrame:Show()

end

------------icon pick
function DF:IconPick (callback, close_when_select, param1, param2)

	if (not DF.IconPickFrame) then 
	
		local string_lower = string.lower
	
		DF.IconPickFrame = CreateFrame ("frame", "DetailsFrameworkIconPickFrame", UIParent)
		tinsert (UISpecialFrames, "DetailsFrameworkIconPickFrame")
		DF.IconPickFrame:SetFrameStrata ("DIALOG")
		
		DF.IconPickFrame:SetPoint ("center", UIParent, "center")
		DF.IconPickFrame:SetWidth (350)
		DF.IconPickFrame:SetHeight (227)
		DF.IconPickFrame:EnableMouse (true)
		DF.IconPickFrame:SetMovable (true)
		
		DF.IconPickFrame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})

		DF.IconPickFrame:SetBackdropBorderColor (0, 0, 0)
		DF.IconPickFrame:SetBackdropColor (24/255, 24/255, 24/255, .8)
		DF.IconPickFrame:SetFrameLevel (1)
		
		DF.IconPickFrame:SetScript ("OnMouseDown", function (self)
			if (not self.isMoving) then
				DF.IconPickFrame:StartMoving()
				self.isMoving = true
			end
		end)
		
		DF.IconPickFrame:SetScript ("OnMouseUp", function (self)
			if (self.isMoving) then
				DF.IconPickFrame:StopMovingOrSizing()
				self.isMoving = nil
			end
		end)
		
		DF.IconPickFrame.emptyFunction = function() end
		DF.IconPickFrame.callback = DF.IconPickFrame.emptyFunction
		
		DF.IconPickFrame.preview =  CreateFrame ("frame", nil, UIParent)
		DF.IconPickFrame.preview:SetFrameStrata ("tooltip")
		DF.IconPickFrame.preview:SetSize (76, 76)
		local preview_image = DF:NewImage (DF.IconPickFrame.preview, nil, 76, 76)
		preview_image:SetAllPoints (DF.IconPickFrame.preview)
		DF.IconPickFrame.preview.icon = preview_image
		DF.IconPickFrame.preview:Hide()
		
		DF.IconPickFrame.searchLabel =  DF:NewLabel (DF.IconPickFrame, nil, "$parentSearchBoxLabel", nil, "search:", font, size, color)
		DF.IconPickFrame.searchLabel:SetPoint ("topleft", DF.IconPickFrame, "topleft", 12, -20)
		DF.IconPickFrame.search = DF:NewTextEntry (DF.IconPickFrame, nil, "$parentSearchBox", nil, 140, 20)
		DF.IconPickFrame.search:SetPoint ("left", DF.IconPickFrame.searchLabel, "right", 2, 0)
		DF.IconPickFrame.search:SetHook ("OnTextChanged", function() 
			DF.IconPickFrame.searching = DF.IconPickFrame.search:GetText()
			if (DF.IconPickFrame.searching == "") then
				DF.IconPickFrameScroll:Show()
				DF.IconPickFrame.searching = nil
				DF.IconPickFrame.updateFunc()
			else
				DF.IconPickFrameScroll:Hide()
				FauxScrollFrame_SetOffset (DF.IconPickFrame, 1)
				DF.IconPickFrame.last_filter_index = 1
				DF.IconPickFrame.updateFunc()
			end
		end)
		
		--> close button
		local close_button = CreateFrame ("button", nil, DF.IconPickFrame, "UIPanelCloseButton")
		close_button:SetWidth (32)
		close_button:SetHeight (32)
		close_button:SetPoint ("TOPRIGHT", DF.IconPickFrame, "TOPRIGHT", -8, -7)
		close_button:SetFrameLevel (close_button:GetFrameLevel()+2)
		
		local MACRO_ICON_FILENAMES = {}
		local SPELLNAMES_CACHE = {}
		
		DF.IconPickFrame:SetScript ("OnShow", function()
			
			MACRO_ICON_FILENAMES [1] = "INV_MISC_QUESTIONMARK";
			local index = 2;
		
			for i = 1, GetNumSpellTabs() do
				local tab, tabTex, offset, numSpells, _ = GetSpellTabInfo (i)
				offset = offset + 1
				local tabEnd = offset + numSpells
				
				for j = offset, tabEnd - 1 do
					--to get spell info by slot, you have to pass in a pet argument
					local spellType, ID = GetSpellBookItemInfo (j, "player")
					if (spellType ~= "FUTURESPELL") then
						MACRO_ICON_FILENAMES [index] = GetSpellBookItemTexture (j, "player") or 0
						index = index + 1;
						
					elseif (spellType == "FLYOUT") then
						local _, _, numSlots, isKnown = GetFlyoutInfo (ID)
						if (isKnown and numSlots > 0) then
							for k = 1, numSlots do 
								local spellID, overrideSpellID, isKnown = GetFlyoutSlotInfo (ID, k)
								if (isKnown) then
									MACRO_ICON_FILENAMES [index] = GetSpellTexture (spellID) or 0
									index = index + 1;
								end
							end
						end
						
					end
				end
			end
			
			GetLooseMacroItemIcons (MACRO_ICON_FILENAMES)
			GetLooseMacroIcons (MACRO_ICON_FILENAMES)
			GetMacroIcons (MACRO_ICON_FILENAMES)
			GetMacroItemIcons (MACRO_ICON_FILENAMES)

		end)
		
		DF.IconPickFrame:SetScript ("OnHide", function()
			wipe (MACRO_ICON_FILENAMES)
			collectgarbage()
		end)
		
		DF.IconPickFrame.buttons = {}
		
		local OnClickFunction = function (self) 
			DF.IconPickFrame.callback (self.icon:GetTexture(), DF.IconPickFrame.param1, DF.IconPickFrame.param2)
			if (DF.IconPickFrame.click_close) then
				close_button:Click()
			end
		end
		
		local onenter = function (self)
			DF.IconPickFrame.preview:SetPoint ("bottom", self, "top", 0, 2)
			DF.IconPickFrame.preview.icon:SetTexture (self.icon:GetTexture())
			DF.IconPickFrame.preview:Show()
			self.icon:SetBlendMode ("ADD")
		end
		local onleave = function (self)
			DF.IconPickFrame.preview:Hide()
			self.icon:SetBlendMode ("BLEND")
		end
		
		local backdrop = {bgFile = DF.folder .. "background", tile = true, tileSize = 16,
		insets = {left = 0, right = 0, top = 0, bottom = 0}, edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]], edgeSize = 10}
		
		for i = 0, 9 do 
			local newcheck = CreateFrame ("Button", "DetailsFrameworkIconPickFrameButton"..(i+1), DF.IconPickFrame)
			local image = newcheck:CreateTexture ("DetailsFrameworkIconPickFrameButton"..(i+1).."Icon", "overlay")
			newcheck.icon = image
			image:SetPoint ("topleft", newcheck, "topleft", 2, -2); image:SetPoint ("bottomright", newcheck, "bottomright", -2, 2)
			newcheck:SetSize (30, 28)
			newcheck:SetBackdrop (backdrop)
			
			newcheck:SetScript ("OnClick", OnClickFunction)
			newcheck.param1 = i+1
			
			newcheck:SetPoint ("topleft", DF.IconPickFrame, "topleft", 12 + (i*30), -40)
			newcheck:SetID (i+1)
			DF.IconPickFrame.buttons [#DF.IconPickFrame.buttons+1] = newcheck
			newcheck:SetScript ("OnEnter", onenter)
			newcheck:SetScript ("OnLeave", onleave)
		end
		for i = 11, 20 do
			local newcheck = CreateFrame ("Button", "DetailsFrameworkIconPickFrameButton"..i, DF.IconPickFrame)
			local image = newcheck:CreateTexture ("DetailsFrameworkIconPickFrameButton"..i.."Icon", "overlay")
			newcheck.icon = image
			image:SetPoint ("topleft", newcheck, "topleft", 2, -2); image:SetPoint ("bottomright", newcheck, "bottomright", -2, 2)
			newcheck:SetSize (30, 28)
			newcheck:SetBackdrop (backdrop)
			
			newcheck:SetScript ("OnClick", OnClickFunction)
			newcheck.param1 = i
			
			newcheck:SetPoint ("topleft", "DetailsFrameworkIconPickFrameButton"..(i-10), "bottomleft", 0, -1)
			newcheck:SetID (i)
			DF.IconPickFrame.buttons [#DF.IconPickFrame.buttons+1] = newcheck
			newcheck:SetScript ("OnEnter", onenter)
			newcheck:SetScript ("OnLeave", onleave)
		end
		for i = 21, 30 do 
			local newcheck = CreateFrame ("Button", "DetailsFrameworkIconPickFrameButton"..i, DF.IconPickFrame)
			local image = newcheck:CreateTexture ("DetailsFrameworkIconPickFrameButton"..i.."Icon", "overlay")
			newcheck.icon = image
			image:SetPoint ("topleft", newcheck, "topleft", 2, -2); image:SetPoint ("bottomright", newcheck, "bottomright", -2, 2)
			newcheck:SetSize (30, 28)
			newcheck:SetBackdrop (backdrop)
			
			newcheck:SetScript ("OnClick", OnClickFunction)
			newcheck.param1 = i
			
			newcheck:SetPoint ("topleft", "DetailsFrameworkIconPickFrameButton"..(i-10), "bottomleft", 0, -1)
			newcheck:SetID (i)
			DF.IconPickFrame.buttons [#DF.IconPickFrame.buttons+1] = newcheck
			newcheck:SetScript ("OnEnter", onenter)
			newcheck:SetScript ("OnLeave", onleave)
		end
		for i = 31, 40 do 
			local newcheck = CreateFrame ("Button", "DetailsFrameworkIconPickFrameButton"..i, DF.IconPickFrame)
			local image = newcheck:CreateTexture ("DetailsFrameworkIconPickFrameButton"..i.."Icon", "overlay")
			newcheck.icon = image
			image:SetPoint ("topleft", newcheck, "topleft", 2, -2); image:SetPoint ("bottomright", newcheck, "bottomright", -2, 2)
			newcheck:SetSize (30, 28)
			newcheck:SetBackdrop (backdrop)
			
			newcheck:SetScript ("OnClick", OnClickFunction)
			newcheck.param1 = i
			
			newcheck:SetPoint ("topleft", "DetailsFrameworkIconPickFrameButton"..(i-10), "bottomleft", 0, -1)
			newcheck:SetID (i)
			DF.IconPickFrame.buttons [#DF.IconPickFrame.buttons+1] = newcheck
			newcheck:SetScript ("OnEnter", onenter)
			newcheck:SetScript ("OnLeave", onleave)
		end
		for i = 41, 50 do 
			local newcheck = CreateFrame ("Button", "DetailsFrameworkIconPickFrameButton"..i, DF.IconPickFrame)
			local image = newcheck:CreateTexture ("DetailsFrameworkIconPickFrameButton"..i.."Icon", "overlay")
			newcheck.icon = image
			image:SetPoint ("topleft", newcheck, "topleft", 2, -2); image:SetPoint ("bottomright", newcheck, "bottomright", -2, 2)
			newcheck:SetSize (30, 28)
			newcheck:SetBackdrop (backdrop)
			
			newcheck:SetScript ("OnClick", OnClickFunction)
			newcheck.param1 = i
			
			newcheck:SetPoint ("topleft", "DetailsFrameworkIconPickFrameButton"..(i-10), "bottomleft", 0, -1)
			newcheck:SetID (i)
			DF.IconPickFrame.buttons [#DF.IconPickFrame.buttons+1] = newcheck
			newcheck:SetScript ("OnEnter", onenter)
			newcheck:SetScript ("OnLeave", onleave)
		end
		for i = 51, 60 do 
			local newcheck = CreateFrame ("Button", "DetailsFrameworkIconPickFrameButton"..i, DF.IconPickFrame)
			local image = newcheck:CreateTexture ("DetailsFrameworkIconPickFrameButton"..i.."Icon", "overlay")
			newcheck.icon = image
			image:SetPoint ("topleft", newcheck, "topleft", 2, -2); image:SetPoint ("bottomright", newcheck, "bottomright", -2, 2)
			newcheck:SetSize (30, 28)
			newcheck:SetBackdrop (backdrop)
			
			newcheck:SetScript ("OnClick", OnClickFunction)
			newcheck.param1 = i
			
			newcheck:SetPoint ("topleft", "DetailsFrameworkIconPickFrameButton"..(i-10), "bottomleft", 0, -1)
			newcheck:SetID (i)
			DF.IconPickFrame.buttons [#DF.IconPickFrame.buttons+1] = newcheck
			newcheck:SetScript ("OnEnter", onenter)
			newcheck:SetScript ("OnLeave", onleave)
		end
		
		local scroll = CreateFrame ("ScrollFrame", "DetailsFrameworkIconPickFrameScroll", DF.IconPickFrame, "ListScrollFrameTemplate")

		local ChecksFrame_Update = function (self)

			local numMacroIcons = #MACRO_ICON_FILENAMES
			local macroPopupIcon, macroPopupButton
			local macroPopupOffset = FauxScrollFrame_GetOffset (scroll)
			local index

			local texture
			local filter
			if (DF.IconPickFrame.searching) then
				filter = string_lower (DF.IconPickFrame.searching)
			end

			local pool
			local shown = 0
			
			if (filter and filter ~= "") then
				if (#SPELLNAMES_CACHE == 0) then
					--build name cache
					local GetSpellInfo = GetSpellInfo
					for i = 1, #MACRO_ICON_FILENAMES do
						local spellName = GetSpellInfo (MACRO_ICON_FILENAMES [i])
						SPELLNAMES_CACHE [i] = spellName or "NULL"
					end
				end
				
				--do the filter
				pool = {}
				for i = 1, #SPELLNAMES_CACHE do
					if (SPELLNAMES_CACHE [i]:find (filter)) then
						pool [#pool+1] = MACRO_ICON_FILENAMES [i]
						shown = shown + 1
					end
				end
			else
				shown = nil
			end
			
			if (not pool) then
				pool = MACRO_ICON_FILENAMES
			end
			
			for i = 1, 60 do
				macroPopupIcon = _G ["DetailsFrameworkIconPickFrameButton"..i.."Icon"]
				macroPopupButton = _G ["DetailsFrameworkIconPickFrameButton"..i]
				index = (macroPopupOffset * 10) + i
				texture = pool [index]
				if ( index <= numMacroIcons and texture ) then

					if (type (texture) == "number") then
						macroPopupIcon:SetTexture (texture)
					else
						macroPopupIcon:SetTexture ("INTERFACE\\ICONS\\" .. texture)
					end

					macroPopupIcon:SetTexCoord (4/64, 60/64, 4/64, 60/64)
					macroPopupButton.IconID = index
					macroPopupButton:Show()
				else
					macroPopupButton:Hide()
				end
			end

			pool = nil
			
			-- Scrollbar stuff
			FauxScrollFrame_Update (scroll, ceil ((shown or numMacroIcons) / 10) , 5, 20 )
		end

		DF.IconPickFrame.updateFunc = ChecksFrame_Update
		
		scroll:SetPoint ("topleft", DF.IconPickFrame, "topleft", -18, -37)
		scroll:SetWidth (330)
		scroll:SetHeight (178)
		scroll:SetScript ("OnVerticalScroll", function (self, offset) FauxScrollFrame_OnVerticalScroll (scroll, offset, 20, ChecksFrame_Update) end)
		scroll.update = ChecksFrame_Update
		DF.IconPickFrameScroll = scroll
		DF.IconPickFrame:Hide()
		
	end
	
	DF.IconPickFrame.param1, DF.IconPickFrame.param2 = param1, param2
	
	DF.IconPickFrame:Show()
	DF.IconPickFrameScroll.update (DF.IconPickFrameScroll)
	DF.IconPickFrame.callback = callback or DF.IconPickFrame.emptyFunction
	DF.IconPickFrame.click_close = close_when_select
	
end	

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function DF:ShowPanicWarning (text)
	if (not DF.PanicWarningWindow) then
		DF.PanicWarningWindow = CreateFrame ("frame", "DetailsFrameworkPanicWarningWindow", UIParent)
		DF.PanicWarningWindow:SetHeight (80)
		DF.PanicWarningWindow:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		DF.PanicWarningWindow:SetBackdropColor (1, 0, 0, 0.2)
		DF.PanicWarningWindow:SetPoint ("topleft", UIParent, "topleft", 0, -250)
		DF.PanicWarningWindow:SetPoint ("topright", UIParent, "topright", 0, -250)
		
		DF.PanicWarningWindow.text = DF.PanicWarningWindow:CreateFontString (nil, "overlay", "GameFontNormal")
		DF.PanicWarningWindow.text:SetPoint ("center", DF.PanicWarningWindow, "center")
		DF.PanicWarningWindow.text:SetTextColor (1, 0.6, 0)
	end
	
	DF.PanicWarningWindow.text:SetText (text)
	DF.PanicWarningWindow:Show()
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local simple_panel_mouse_down = function (self, button)
	if (button == "RightButton") then
		if (self.IsMoving) then
			self.IsMoving = false
			self:StopMovingOrSizing()
			if (self.db and self.db.position) then
				DF:SavePositionOnScreen (self)
			end
		end
		if (not self.DontRightClickClose) then
			self:Hide()
		end
		return
	end
	if (not self.IsMoving and not self.IsLocked) then
		self.IsMoving = true
		self:StartMoving()
	end
end
local simple_panel_mouse_up = function (self, button)
	if (self.IsMoving) then
		self.IsMoving = false
		self:StopMovingOrSizing()
		if (self.db and self.db.position) then
			DF:SavePositionOnScreen (self)
		end
	end
end
local simple_panel_settitle = function (self, title)
	self.Title:SetText (title)
end

local simple_panel_close_click = function (self)
	self:GetParent():GetParent():Hide()
end

local SimplePanel_frame_backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true}
local SimplePanel_frame_backdrop_color = {0, 0, 0, 0.9}
local SimplePanel_frame_backdrop_border_color = {0, 0, 0, 1}

function DF:CreateScaleBar (frame, config)
	local scaleBar = DF:CreateSlider (frame, 120, 14, 0.6, 1.6, 0.1, config.scale, true, "ScaleBar", nil, "Scale:", DF:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE"), DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	scaleBar:SetPoint ("right", frame.Close, "left", -26, 0)
	scaleBar:SetFrameLevel (DF.FRAMELEVEL_OVERLAY)
	scaleBar.OnValueChanged = function (_, _, value)
		config.scale = value
		if (not scaleBar.IsValueChanging) then
			frame:SetScale (config.scale)
		end
	end
	scaleBar:SetHook ("OnMouseUp", function()
		frame:SetScale (config.scale)
	end)
end

local no_options = {}
function DF:CreateSimplePanel (parent, w, h, title, name, panel_options, db)
	
	if (db and name and not db [name]) then
		db [name] = {scale = 1}
	end
	
	if (not name) then
		name = "DetailsFrameworkSimplePanel" .. DF.SimplePanelCounter
		DF.SimplePanelCounter = DF.SimplePanelCounter + 1
	end
	if (not parent) then
		parent = UIParent
	end
	
	panel_options = panel_options or no_options
	
	local f = CreateFrame ("frame", name, UIParent)
	f:SetSize (w or 400, h or 250)
	f:SetPoint ("center", UIParent, "center", 0, 0)
	f:SetFrameStrata ("FULLSCREEN")
	f:EnableMouse()
	f:SetMovable (true)
	f:SetBackdrop (SimplePanel_frame_backdrop)
	f:SetBackdropColor (unpack (SimplePanel_frame_backdrop_color))
	f:SetBackdropBorderColor (unpack (SimplePanel_frame_backdrop_border_color))
	
	f.DontRightClickClose = panel_options.DontRightClickClose
	
	if (not panel_options.NoTUISpecialFrame) then
		tinsert (UISpecialFrames, name)
	end
	
	local title_bar = CreateFrame ("frame", name .. "TitleBar", f)
	title_bar:SetPoint ("topleft", f, "topleft", 2, -3)
	title_bar:SetPoint ("topright", f, "topright", -2, -3)
	title_bar:SetHeight (20)
	title_bar:SetBackdrop (SimplePanel_frame_backdrop)
	title_bar:SetBackdropColor (.2, .2, .2, 1)
	title_bar:SetBackdropBorderColor (0, 0, 0, 1)
	f.TitleBar = title_bar
	
	local close = CreateFrame ("button", name and name .. "CloseButton", title_bar)
	close:SetFrameLevel (DF.FRAMELEVEL_OVERLAY)
	close:SetSize (16, 16)
	close:SetNormalTexture (DF.folder .. "icons")
	close:SetHighlightTexture (DF.folder .. "icons")
	close:SetPushedTexture (DF.folder .. "icons")
	close:GetNormalTexture():SetTexCoord (0, 16/128, 0, 1)
	close:GetHighlightTexture():SetTexCoord (0, 16/128, 0, 1)
	close:GetPushedTexture():SetTexCoord (0, 16/128, 0, 1)
	close:SetAlpha (0.7)
	close:SetScript ("OnClick", simple_panel_close_click)
	f.Close = close
	
	local title_string = title_bar:CreateFontString (name and name .. "Title", "overlay", "GameFontNormal")
	title_string:SetTextColor (.8, .8, .8, 1)
	title_string:SetText (title or "")
	f.Title = title_string
	
	if (panel_options.UseScaleBar and db [name]) then
		DF:CreateScaleBar (f, db [name])
		f:SetScale (db [name].scale)
	end
	
	f.Title:SetPoint ("center", title_bar, "center")
	f.Close:SetPoint ("right", title_bar, "right", -2, 0)
	
	f:SetScript ("OnMouseDown", simple_panel_mouse_down)
	f:SetScript ("OnMouseUp", simple_panel_mouse_up)
	
	f.SetTitle = simple_panel_settitle
	
	return f
end

local Panel1PxBackdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 64,
edgeFile = DF.folder .. "border_3", edgeSize = 9, insets = {left = 2, right = 2, top = 3, bottom = 3}}

local Panel1PxOnClickClose = function (self)
	self:GetParent():Hide()
end
local Panel1PxOnToggleLock = function (self)
	if (self.IsLocked) then
		self.IsLocked = false
		self:SetMovable (true)
		self:EnableMouse (true)
		self.Lock:GetNormalTexture():SetTexCoord (32/128, 48/128, 0, 1)
		self.Lock:GetHighlightTexture():SetTexCoord (32/128, 48/128, 0, 1)
		self.Lock:GetPushedTexture():SetTexCoord (32/128, 48/128, 0, 1)
		if (self.OnUnlock) then
			self:OnUnlock()
		end
		if (self.db) then
			self.db.IsLocked = self.IsLocked
		end
	else
		self.IsLocked = true
		self:SetMovable (false)
		self:EnableMouse (false)
		self.Lock:GetNormalTexture():SetTexCoord (16/128, 32/128, 0, 1)
		self.Lock:GetHighlightTexture():SetTexCoord (16/128, 32/128, 0, 1)
		self.Lock:GetPushedTexture():SetTexCoord (16/128, 32/128, 0, 1)
		if (self.OnLock) then
			self:OnLock()
		end
		if (self.db) then
			self.db.IsLocked = self.IsLocked
		end
	end
end
local Panel1PxOnClickLock = function (self)
	local f = self:GetParent()
	Panel1PxOnToggleLock (f)
end
local Panel1PxSetTitle = function (self, text)
	self.Title:SetText (text or "")
end

local Panel1PxSetLocked= function (self, lock_state)
	if (type (lock_state) ~= "boolean") then
		return
	end
	if (lock_state) then
		-- lock it
		self.IsLocked = false
		Panel1PxOnClickLock (self.Lock)
	else
		-- unlockit
		self.IsLocked = true
		Panel1PxOnClickLock (self.Lock)
	end
end

local Panel1PxReadConfig = function (self)
	local db = self.db
	if (db) then
		db.IsLocked = db.IsLocked or false
		self.IsLocked = db.IsLocked
		db.position = db.position or {x = 0, y = 0}
		db.position.x = db.position.x or 0
		db.position.y = db.position.y or 0
		DF:RestoreFramePosition (self)
	end
end

function DF:SavePositionOnScreen (frame)
	if (frame.db and frame.db.position) then
		local x, y = DF:GetPositionOnScreen (frame)
		--print ("saving...", x, y, frame:GetName())
		if (x and y) then
			frame.db.position.x, frame.db.position.y = x, y
		end
	end
end

function DF:GetPositionOnScreen (frame)
	local xOfs, yOfs = frame:GetCenter()
	if (not xOfs) then
		return
	end
	local scale = frame:GetEffectiveScale()
	local UIscale = UIParent:GetScale()
	xOfs = xOfs*scale - GetScreenWidth()*UIscale/2
	yOfs = yOfs*scale - GetScreenHeight()*UIscale/2
	return xOfs/UIscale, yOfs/UIscale
end

function DF:RestoreFramePosition (frame)
	if (frame.db and frame.db.position) then
		local scale, UIscale = frame:GetEffectiveScale(), UIParent:GetScale()
		frame:ClearAllPoints()
		frame.db.position.x = frame.db.position.x or 0
		frame.db.position.y = frame.db.position.y or 0
		frame:SetPoint ("center", UIParent, "center", frame.db.position.x * UIscale / scale, frame.db.position.y * UIscale / scale)
	end
end

local Panel1PxSavePosition= function (self)
	DF:SavePositionOnScreen (self)
end

local Panel1PxHasPosition = function (self)
	local db = self.db
	if (db) then
		if (db.position and db.position.x and (db.position.x ~= 0 or db.position.y ~= 0)) then
			return true
		end
	end
end

function DF:Create1PxPanel (parent, w, h, title, name, config, title_anchor, no_special_frame)
	local f = CreateFrame ("frame", name, parent or UIParent)
	f:SetSize (w or 100, h or 75)
	f:SetPoint ("center", UIParent, "center")
	
	if (name and not no_special_frame) then
		tinsert (UISpecialFrames, name)
	end
	
	f:SetScript ("OnMouseDown", simple_panel_mouse_down)
	f:SetScript ("OnMouseUp", simple_panel_mouse_up)
	
	f:SetBackdrop (Panel1PxBackdrop)
	f:SetBackdropColor (0, 0, 0, 0.5)
	
	f.IsLocked = (config and config.IsLocked ~= nil and config.IsLocked) or false
	f:SetMovable (true)
	f:EnableMouse (true)
	f:SetUserPlaced (true)
	
	f.db = config
	--print (config.position.x, config.position.x)
	Panel1PxReadConfig (f)
	
	local close = CreateFrame ("button", name and name .. "CloseButton", f)
	close:SetSize (16, 16)
	close:SetNormalTexture (DF.folder .. "icons")
	close:SetHighlightTexture (DF.folder .. "icons")
	close:SetPushedTexture (DF.folder .. "icons")
	close:GetNormalTexture():SetTexCoord (0, 16/128, 0, 1)
	close:GetHighlightTexture():SetTexCoord (0, 16/128, 0, 1)
	close:GetPushedTexture():SetTexCoord (0, 16/128, 0, 1)
	close:SetAlpha (0.7)
	
	local lock = CreateFrame ("button", name and name .. "LockButton", f)
	lock:SetSize (16, 16)
	lock:SetNormalTexture (DF.folder .. "icons")
	lock:SetHighlightTexture (DF.folder .. "icons")
	lock:SetPushedTexture (DF.folder .. "icons")
	lock:GetNormalTexture():SetTexCoord (32/128, 48/128, 0, 1)
	lock:GetHighlightTexture():SetTexCoord (32/128, 48/128, 0, 1)
	lock:GetPushedTexture():SetTexCoord (32/128, 48/128, 0, 1)
	lock:SetAlpha (0.7)
	
	close:SetPoint ("topright", f, "topright", -3, -3)
	lock:SetPoint ("right", close, "left", 3, 0)
	
	close:SetScript ("OnClick", Panel1PxOnClickClose)
	lock:SetScript ("OnClick", Panel1PxOnClickLock)
	
	local title_string = f:CreateFontString (name and name .. "Title", "overlay", "GameFontNormal")
	title_string:SetPoint ("topleft", f, "topleft", 5, -5)
	title_string:SetText (title or "")
	
	if (title_anchor) then
		if (title_anchor == "top") then
			title_string:ClearAllPoints()
			title_string:SetPoint ("bottomleft", f, "topleft", 0, 0)
			close:ClearAllPoints()
			close:SetPoint ("bottomright", f, "topright", 0, 0)
		end
		f.title_anchor = title_anchor
	end
	
	f.SetTitle = Panel1PxSetTitle
	f.Title = title_string
	f.Lock = lock
	f.Close = close
	f.HasPosition = Panel1PxHasPosition
	f.SavePosition = Panel1PxSavePosition
	
	f.IsLocked = not f.IsLocked
	f.SetLocked = Panel1PxSetLocked
	Panel1PxOnToggleLock (f)
	
	return f
end

------------------------------------------------------------------------------------------------------------------------------------------------
-- ~prompt
function DF:ShowPromptPanel (message, func_true, func_false)
	
	if (not DF.prompt_panel) then
		local f = CreateFrame ("frame", "DetailsFrameworkPrompt", UIParent) 
		f:SetSize (400, 65)
		f:SetFrameStrata ("DIALOG")
		f:SetPoint ("center", UIParent, "center", 0, 300)
		f:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		f:SetBackdropColor (0, 0, 0, 0.8)
		f:SetBackdropBorderColor (0, 0, 0, 1)
		
		local prompt = f:CreateFontString (nil, "overlay", "GameFontNormal")
		prompt:SetPoint ("top", f, "top", 0, -15)
		prompt:SetJustifyH ("center")
		f.prompt = prompt
		
		local button_true = DF:CreateButton (f, nil, 60, 20, "Yes")
		button_true:SetPoint ("bottomleft", f, "bottomleft", 5, 5)
		f.button_true = button_true

		local button_false = DF:CreateButton (f, nil, 60, 20, "No")
		button_false:SetPoint ("bottomright", f, "bottomright", -5, 5)
		f.button_false = button_false
		
		button_true:SetClickFunction (function()
			local my_func = button_true.true_function
			if (my_func) then
				local okey, errormessage = pcall (my_func, true)
				if (not okey) then
					print ("error:", errormessage)
				end
				f:Hide()
			end
		end)
		
		button_false:SetClickFunction (function()
			local my_func = button_false.false_function
			if (my_func) then
				local okey, errormessage = pcall (my_func, true)
				if (not okey) then
					print ("error:", errormessage)
				end
				f:Hide()
			end
		end)
		
		f:Hide()
		DF.promtp_panel = f
	end
	
	assert (type (func_true) == "function" and type (func_false) == "function", "ShowPromptPanel expects two functions.")
	
	DF.promtp_panel.prompt:SetText (message)
	DF.promtp_panel.button_true.true_function = func_true
	DF.promtp_panel.button_false.false_function = func_false
	
	DF.promtp_panel:Show()
end


function DF:ShowTextPromptPanel (message, callback)
	
	if (not DF.text_prompt_panel) then
		
		local f = CreateFrame ("frame", "DetailsFrameworkPrompt", UIParent) 
		f:SetSize (400, 100)
		f:SetFrameStrata ("DIALOG")
		f:SetPoint ("center", UIParent, "center", 0, 300)
		f:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		f:SetBackdropColor (0, 0, 0, 0.8)
		f:SetBackdropBorderColor (0, 0, 0, 1)
		
		local prompt = f:CreateFontString (nil, "overlay", "GameFontNormal")
		prompt:SetPoint ("top", f, "top", 0, -15)
		prompt:SetJustifyH ("center")
		f.prompt = prompt

		local button_text_template = DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
		local options_dropdown_template = DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")

		local button_true = DF:CreateButton (f, nil, 60, 20, "Okey", nil, nil, nil, nil, nil, nil, options_dropdown_template, button_text_template)
		button_true:SetPoint ("bottomleft", f, "bottomleft", 10, 5)
		f.button_true = button_true

		local button_false = DF:CreateButton (f, function() f.textbox:ClearFocus(); f:Hide() end, 60, 20, "Cancel", nil, nil, nil, nil, nil, nil, options_dropdown_template, button_text_template)
		button_false:SetPoint ("bottomright", f, "bottomright", -10, 5)
		f.button_false = button_false
		
		local textbox = DF:CreateTextEntry (f, function()end, 380, 20, "textbox", nil, nil, options_dropdown_template)
		textbox:SetPoint ("topleft", f, "topleft", 10, -45)
		f.EntryBox = textbox

		button_true:SetClickFunction (function()
			local my_func = button_true.true_function
			if (my_func) then
				local okey, errormessage = pcall (my_func, textbox:GetText())
				textbox:ClearFocus()
				if (not okey) then
					print ("error:", errormessage)
				end
				f:Hide()
			end
		end)
	
		f:Hide()
		DF.text_prompt_panel = f
	end

	DF.text_prompt_panel:Show()
	
	DetailsFrameworkPrompt.EntryBox:SetText ("")
	DF.text_prompt_panel.prompt:SetText (message)
	DF.text_prompt_panel.button_true.true_function = callback
	
	DF.text_prompt_panel.textbox:SetFocus (true)
	
end

------------------------------------------------------------------------------------------------------------------------------------------------
--> options button -- ~options
function DF:CreateOptionsButton (parent, callback, name)
	
	local b = CreateFrame ("button", name, parent)
	b:SetSize (14, 14)
	b:SetNormalTexture (DF.folder .. "icons")
	b:SetHighlightTexture (DF.folder .. "icons")
	b:SetPushedTexture (DF.folder .. "icons")
	b:GetNormalTexture():SetTexCoord (48/128, 64/128, 0, 1)
	b:GetHighlightTexture():SetTexCoord (48/128, 64/128, 0, 1)
	b:GetPushedTexture():SetTexCoord (48/128, 64/128, 0, 1)
	b:SetAlpha (0.7)
	
	b:SetScript ("OnClick", callback)
	b:SetScript ("OnEnter", function (self) 
		GameCooltip2:Reset()
		GameCooltip2:AddLine ("Options")
		GameCooltip2:ShowCooltip (self, "tooltip")
	end)
	b:SetScript ("OnLeave", function (self) 
		GameCooltip2:Hide()
	end)
	
	return b

end

------------------------------------------------------------------------------------------------------------------------------------------------
--> feedback panel -- ~feedback

function DF:CreateFeedbackButton (parent, callback, name)
	local b = CreateFrame ("button", name, parent)
	b:SetSize (12, 13)
	b:SetNormalTexture (DF.folder .. "mail")
	b:SetPushedTexture (DF.folder .. "mail")
	b:SetHighlightTexture (DF.folder .. "mail")
	
	b:SetScript ("OnClick", callback)
	b:SetScript ("OnEnter", function (self) 
		GameCooltip2:Reset()
		GameCooltip2:AddLine ("Send Feedback")
		GameCooltip2:ShowCooltip (self, "tooltip")
	end)
	b:SetScript ("OnLeave", function (self) 
		GameCooltip2:Hide()
	end)
	
	return b
end

local backdrop_fb_line = {bgFile = DF.folder .. "background", edgeFile = DF.folder .. "border_3", 
tile = true, tileSize = 64, edgeSize = 8, insets = {left = 2, right = 2, top = 2, bottom = 2}}

local on_enter_feedback = function (self)
	self:SetBackdropColor (1, 1, 0, 0.5)
end
local on_leave_feedback = function (self)
	self:SetBackdropColor (0, 0, 0, 0.3)
end

local on_click_feedback = function (self)

	local feedback_link_textbox = DF.feedback_link_textbox
	
	if (not feedback_link_textbox) then
		local editbox = DF:CreateTextEntry (AddonFeedbackPanel, _, 275, 34)
		editbox:SetAutoFocus (false)
		editbox:SetHook ("OnEditFocusGained", function() 
			editbox.text = editbox.link
			editbox:HighlightText()
		end)
		editbox:SetHook ("OnEditFocusLost", function() 
			editbox:Hide()
		end)
		editbox:SetHook ("OnChar", function() 
			editbox.text = editbox.link
			editbox:HighlightText()
		end)
		editbox.text = ""
		
		DF.feedback_link_textbox = editbox
		feedback_link_textbox = editbox
	end
	
	feedback_link_textbox.link = self.link
	feedback_link_textbox.text = self.link
	feedback_link_textbox:Show()
	
	feedback_link_textbox:SetPoint ("topleft", self.icon, "topright", 3, 0)
	
	feedback_link_textbox:HighlightText()
	
	feedback_link_textbox:SetFocus()
	feedback_link_textbox:SetFrameLevel (self:GetFrameLevel()+2)
end

local feedback_get_fb_line = function (self)

	local line = self.feedback_lines [self.next_feedback]
	if (not line) then
		line = CreateFrame ("frame", "AddonFeedbackPanelFB" .. self.next_feedback, self)
		line:SetBackdrop (backdrop_fb_line)
		line:SetBackdropColor (0, 0, 0, 0.3)
		line:SetSize (390, 42)
		line:SetPoint ("topleft", self.feedback_anchor, "bottomleft", 0, -5 + ((self.next_feedback-1) * 46 * -1))
		line:SetScript ("OnEnter", on_enter_feedback)
		line:SetScript ("OnLeave", on_leave_feedback)
		line:SetScript ("OnMouseUp", on_click_feedback)
		
		line.icon = line:CreateTexture (nil, "overlay")
		line.icon:SetSize (90, 36)
		
		line.desc = line:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
		
		line.icon:SetPoint ("left", line, "left", 5, 0)
		line.desc:SetPoint ("left", line.icon, "right", 5, 0)
		
		local arrow = line:CreateTexture (nil, "overlay")
		arrow:SetTexture ([[Interface\Buttons\JumpUpArrow]])
		arrow:SetRotation (-1.55)
		arrow:SetPoint ("right", line, "right", -5, 0)
		
		self.feedback_lines [self.next_feedback] = line
	end
	
	self.next_feedback = self.next_feedback + 1
	
	return line
end

local on_click_feedback = function (self)

	local feedback_link_textbox = DF.feedback_link_textbox
	
	if (not feedback_link_textbox) then
		local editbox = DF:CreateTextEntry (AddonFeedbackPanel, _, 275, 34)
		editbox:SetAutoFocus (false)
		editbox:SetHook ("OnEditFocusGained", function() 
			editbox.text = editbox.link
			editbox:HighlightText()
		end)
		editbox:SetHook ("OnEditFocusLost", function() 
			editbox:Hide()
		end)
		editbox:SetHook ("OnChar", function() 
			editbox.text = editbox.link
			editbox:HighlightText()
		end)
		editbox.text = ""
		
		DF.feedback_link_textbox = editbox
		feedback_link_textbox = editbox
	end
	
	feedback_link_textbox.link = self.link
	feedback_link_textbox.text = self.link
	feedback_link_textbox:Show()
	
	feedback_link_textbox:SetPoint ("topleft", self.icon, "topright", 3, 0)
	
	feedback_link_textbox:HighlightText()
	
	feedback_link_textbox:SetFocus()
	feedback_link_textbox:SetFrameLevel (self:GetFrameLevel()+2)
end

local on_enter_addon = function (self)
	if (self.tooltip) then
		GameCooltip2:Preset (2)
		GameCooltip2:AddLine ("|cFFFFFF00" .. self.name .. "|r")
		GameCooltip2:AddLine ("")
		GameCooltip2:AddLine (self.tooltip)
		GameCooltip2:ShowCooltip (self, "tooltip")
	end
	self.icon:SetBlendMode ("ADD")
end
local on_leave_addon = function (self)
	if (self.tooltip) then
		GameCooltip2:Hide()
	end
	self.icon:SetBlendMode ("BLEND")
end
local on_click_addon = function (self)
	local addon_link_textbox = DF.addon_link_textbox
	
	if (not addon_link_textbox) then
		local editbox = DF:CreateTextEntry (AddonFeedbackPanel, _, 128, 64)
		editbox:SetAutoFocus (false)
		editbox:SetHook ("OnEditFocusGained", function() 
			editbox.text = editbox.link
			editbox:HighlightText()
		end)
		editbox:SetHook ("OnEditFocusLost", function() 
			editbox:Hide()
		end)
		editbox:SetHook ("OnChar", function() 
			editbox.text = editbox.link
			editbox:HighlightText()
		end)
		editbox.text = ""
		
		DF.addon_link_textbox = editbox
		addon_link_textbox = editbox
	end
	
	addon_link_textbox.link = self.link
	addon_link_textbox.text = self.link
	addon_link_textbox:Show()
	
	addon_link_textbox:SetPoint ("topleft", self.icon, "topleft", 0, 0)
	
	addon_link_textbox:HighlightText()
	
	addon_link_textbox:SetFocus()
	addon_link_textbox:SetFrameLevel (self:GetFrameLevel()+2)
end

local feedback_get_addons_line = function (self)
	local line = self.addons_lines [self.next_addons]
	if (not line) then
	
		line = CreateFrame ("frame", "AddonFeedbackPanelSA" .. self.next_addons, self)
		line:SetSize (128, 64)

		if (self.next_addons == 1) then
			line:SetPoint ("topleft", self.addons_anchor, "bottomleft", 0, -5)
		elseif (self.next_addons_line_break == self.next_addons) then
			line:SetPoint ("topleft", self.addons_anchor, "bottomleft", 0, -5 + floor (self.next_addons_line_break/3) * 66 * -1)
			self.next_addons_line_break = self.next_addons_line_break + 3
		else
			local previous = self.addons_lines [self.next_addons - 1]
			line:SetPoint ("topleft", previous, "topright", 2, 0)
		end

		line:SetScript ("OnEnter", on_enter_addon)
		line:SetScript ("OnLeave", on_leave_addon)
		line:SetScript ("OnMouseUp", on_click_addon)
		
		line.icon = line:CreateTexture (nil, "overlay")
		line.icon:SetSize (128, 64)

		line.icon:SetPoint ("topleft", line, "topleft", 0, 0)
		
		self.addons_lines [self.next_addons] = line
	end
	
	self.next_addons = self.next_addons + 1
	
	return line
end

local default_coords = {0, 1, 0, 1}
local feedback_add_fb = function (self, table)
	local line = self:GetFeedbackLine()
	line.icon:SetTexture (table.icon)
	line.icon:SetTexCoord (unpack (table.coords or default_coords))
	line.desc:SetText (table.desc)
	line.link = table.link
	line:Show()
end

local feedback_add_addon = function (self, table)
	local block = self:GetAddonsLine()
	block.icon:SetTexture (table.icon)
	block.icon:SetTexCoord (unpack (table.coords or default_coords))
	block.link = table.link
	block.tooltip = table.desc
	block.name = table.name
	block:Show()
end

local feedback_hide_all = function (self)
	self.next_feedback = 1
	self.next_addons = 1
	
	for index, line in ipairs (self.feedback_lines) do
		line:Hide()
	end
	
	for index, line in ipairs (self.addons_lines) do
		line:Hide()
	end
end

-- feedback_methods = { { icon = icon path, desc = description, link = url}}
function DF:ShowFeedbackPanel (addon_name, version, feedback_methods, more_addons)

	local f = _G.AddonFeedbackPanel

	if (not f) then
		f = DF:Create1PxPanel (UIParent, 400, 100, addon_name .. " Feedback", "AddonFeedbackPanel", nil)
		f:SetFrameStrata ("FULLSCREEN")
		f:SetPoint ("center", UIParent, "center")
		f:SetBackdropColor (0, 0, 0, 0.8)
		f.feedback_lines = {}
		f.addons_lines = {}
		f.next_feedback = 1
		f.next_addons = 1
		f.next_addons_line_break = 4
		
		local feedback_anchor = f:CreateFontString (nil, "overlay", "GameFontNormal")
		feedback_anchor:SetText ("Feedback:")
		feedback_anchor:SetPoint ("topleft", f, "topleft", 5, -30)
		f.feedback_anchor = feedback_anchor
		local excla_text = f:CreateFontString (nil, "overlay", "GameFontNormal")
		excla_text:SetText ("click and copy the link")
		excla_text:SetPoint ("topright", f, "topright", -5, -30)
		excla_text:SetTextColor (1, 0.8, 0.2, 0.6)
		
		local addons_anchor = f:CreateFontString (nil, "overlay", "GameFontNormal")
		addons_anchor:SetText ("AddOns From the Same Author:")
		f.addons_anchor = addons_anchor
		local excla_text2 = f:CreateFontString (nil, "overlay", "GameFontNormal")
		excla_text2:SetText ("click and copy the link")
		excla_text2:SetTextColor (1, 0.8, 0.2, 0.6)
		f.excla_text2 = excla_text2
		
		f.GetFeedbackLine = feedback_get_fb_line
		f.GetAddonsLine = feedback_get_addons_line
		f.AddFeedbackMethod = feedback_add_fb
		f.AddOtherAddon = feedback_add_addon
		f.HideAll = feedback_hide_all

		DF:SetFontSize (f.Title, 14)
		
	end
	
	f:HideAll()
	f:SetTitle (addon_name)
	
	for index, feedback in ipairs (feedback_methods) do
		f:AddFeedbackMethod (feedback)
	end
	
	f.addons_anchor:SetPoint ("topleft", f, "topleft", 5, f.next_feedback * 50 * -1)
	f.excla_text2:SetPoint ("topright", f, "topright", -5, f.next_feedback * 50 * -1)
	
	for index, addon in ipairs (more_addons) do
		f:AddOtherAddon (addon)
	end
	
	f:SetHeight (80 + ((f.next_feedback-1) * 50) + (ceil ((f.next_addons-1)/3) * 66))
	
	f:Show()
	
	return true
end


------------------------------------------------------------------------------------------------------------------------------------------------
--> chart panel -- ~chart

local chart_panel_backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 32, insets = {left = 5, right = 5, top = 5, bottom = 5}}

local chart_panel_align_timelabels = function (self, elapsed_time)

	self.TimeScale = elapsed_time

	local linha = self.TimeLabels [17]
	local minutos, segundos = math.floor (elapsed_time / 60), math.floor (elapsed_time % 60)
	if (segundos < 10) then
		segundos = "0" .. segundos
	end
	
	if (minutos > 0) then
		if (minutos < 10) then
			minutos = "0" .. minutos
		end
		linha:SetText (minutos .. ":" .. segundos)
	else
		linha:SetText ("00:" .. segundos)
	end
	
	local time_div = elapsed_time / 16 --786 -- 49.125
	
	for i = 2, 16 do
	
		local linha = self.TimeLabels [i]
		
		local this_time = time_div * (i-1)
		local minutos, segundos = math.floor (this_time / 60), math.floor (this_time % 60)
		
		if (segundos < 10) then
			segundos = "0" .. segundos
		end
		
		if (minutos > 0) then
			if (minutos < 10) then
				minutos = "0" .. minutos
			end
			linha:SetText (minutos .. ":" .. segundos)
		else
			linha:SetText ("00:" .. segundos)
		end
		
	end
	
end

local chart_panel_set_scale = function (self, amt, func, text)

	if (type (amt) ~= "number") then
		return
	end
	
	local piece = amt / 1000 / 8
	if (not text or text == "") then
		text = amt > 1000000 and "M" or amt > 1000 and "K"
	end
	
	for i = 1, 8 do
		if (func) then
			self ["dpsamt" .. math.abs (i-9)]:SetText ( func (piece*i) .. (text or ""))
		else
			if (piece*i > 1) then
				self ["dpsamt" .. math.abs (i-9)]:SetText ( format ("%.1f", piece*i) .. (text or ""))
			else
				self ["dpsamt" .. math.abs (i-9)]:SetText ( format ("%.3f", piece*i) .. (text or ""))
			end
		end
	end
end

local chart_panel_can_move = function (self, can)
	self.can_move = can
end

local chart_panel_overlay_reset = function (self)
	self.OverlaysAmount = 1
	for index, pack in ipairs (self.Overlays) do
		for index2, texture in ipairs (pack) do
			texture:Hide()
		end
	end
end

local chart_panel_reset = function (self)

	self.Graphic:ResetData()
	self.Graphic.max_value = 0
	
	self.TimeScale = nil
	self.BoxLabelsAmount = 1
	table.wipe (self.GData)
	table.wipe (self.OData)
	
	for index, box in ipairs (self.BoxLabels) do
		box.check:Hide()
		box.button:Hide()
		box.box:Hide()
		box.text:Hide()
		box.border:Hide()
		box.showing = false
	end
	
	chart_panel_overlay_reset (self)
end

local chart_panel_enable_line = function (f, thisbox)

	local index = thisbox.index
	local type = thisbox.type
	
	if (thisbox.enabled) then
		--disable
		thisbox.check:Hide()
		thisbox.enabled = false
	else
		--enable
		thisbox.check:Show()
		thisbox.enabled = true
	end
	
	if (type == "graphic") then
	
		f.Graphic:ResetData()
		f.Graphic.max_value = 0
		
		local max = 0
		local max_time = 0
		
		for index, box in ipairs (f.BoxLabels) do
			if (box.type == type and box.showing and box.enabled) then
				local data = f.GData [index]
				
				f.Graphic:AddDataSeries (data[1], data[2], nil, data[3])
				
				if (data[4] > max) then
					max = data[4]
				end
				if (data [5] > max_time) then
					max_time = data [5]
				end
			end
		end
		
		f:SetScale (max)
		f:SetTime (max_time)
		
	elseif (type == "overlay") then

		chart_panel_overlay_reset (f)
		
		for index, box in ipairs (f.BoxLabels) do
			if (box.type == type and box.showing and box.enabled) then
				
				f:AddOverlay (box.index)
				
			end
		end
	
	end
end

local create_box = function (self, next_box)

	local thisbox = {}
	self.BoxLabels [next_box] = thisbox
	
	local box = DF:NewImage (self.Graphic, nil, 16, 16, "border")
	
	local text = DF:NewLabel (self.Graphic)
	
	local border = DF:NewImage (self.Graphic, [[Interface\DialogFrame\UI-DialogBox-Gold-Corner]], 30, 30, "artwork")
	border:SetPoint ("center", box, "center", -3, -4)
	border:SetTexture ([[Interface\DialogFrame\UI-DialogBox-Gold-Corner]])
	
	local checktexture = DF:NewImage (self.Graphic, [[Interface\Buttons\UI-CheckBox-Check]], 18, 18, "overlay")
	checktexture:SetPoint ("center", box, "center", -1, -1)
	checktexture:SetTexture ([[Interface\Buttons\UI-CheckBox-Check]])
	
	thisbox.box = box
	thisbox.text = text
	thisbox.border = border
	thisbox.check = checktexture
	thisbox.enabled = true

	local button = CreateFrame ("button", nil, self.Graphic)
	button:SetSize (20, 20)
	button:SetScript ("OnClick", function()
		chart_panel_enable_line (self, thisbox)
	end)
	button:SetPoint ("center", box.widget or box, "center")
	
	thisbox.button = button
	
	thisbox.box:SetPoint ("right", text, "left", -4, 0)
	
	if (next_box == 1) then
		thisbox.text:SetPoint ("topright", self, "topright", -35, -16)
	else
		thisbox.text:SetPoint ("right", self.BoxLabels [next_box-1].box, "left", -7, 0)
	end

	return thisbox
	
end

local realign_labels = function (self)
	
	local width = self:GetWidth() - 108
	
	local first_box = self.BoxLabels [1]
	first_box.text:SetPoint ("topright", self, "topright", -35, -16)
	
	local line_width = first_box.text:GetStringWidth() + 26
	
	for i = 2, #self.BoxLabels do
	
		local box = self.BoxLabels [i]
		
		if (box.box:IsShown()) then
		
			line_width = line_width + box.text:GetStringWidth() + 26
			
			if (line_width > width) then
				line_width = box.text:GetStringWidth() + 26
				box.text:SetPoint ("topright", self, "topright", -35, -40)
			else
				box.text:SetPoint ("right", self.BoxLabels [i-1].box, "left", -7, 0)
			end
		else
			break
		end
	end
	
end

local chart_panel_add_label = function (self, color, name, type, number)

	local next_box = self.BoxLabelsAmount
	local thisbox = self.BoxLabels [next_box]
	
	if (not thisbox) then
		thisbox = create_box (self, next_box)
	end
	
	self.BoxLabelsAmount = self.BoxLabelsAmount + 1

	thisbox.type = type
	thisbox.index = number

	thisbox.box:SetColorTexture (unpack (color))
	thisbox.text:SetText (name)
	
	thisbox.check:Show()
	thisbox.button:Show()
	thisbox.border:Show()
	thisbox.box:Show()
	thisbox.text:Show()

	thisbox.showing = true
	thisbox.enabled = true
	
	realign_labels (self)
	
end

local line_default_color = {1, 1, 1}
local draw_overlay = function (self, this_overlay, overlayData, color)

	local pixel = self.Graphic:GetWidth() / self.TimeScale
	local index = 1
	local r, g, b = unpack (color or line_default_color)
	
	for i = 1, #overlayData, 2 do
		local aura_start = overlayData [i]
		local aura_end = overlayData [i+1]
		
		local this_block = this_overlay [index]
		if (not this_block) then
			this_block = self.Graphic:CreateTexture (nil, "border")
			tinsert (this_overlay, this_block)
		end
		this_block:SetHeight (self.Graphic:GetHeight())
		
		this_block:SetPoint ("left", self.Graphic, "left", pixel * aura_start, 0)
		if (aura_end) then
			this_block:SetWidth ((aura_end-aura_start)*pixel)
		else
			--malformed table
			this_block:SetWidth (pixel*5)
		end
		
		this_block:SetColorTexture (r, g, b, 0.25)
		this_block:Show()
		
		index = index + 1
	end

end

local chart_panel_add_overlay = function (self, overlayData, color, name, icon)

	if (not self.TimeScale) then
		error ("Use SetTime (time) before adding an overlay.")
	end

	if (type (overlayData) == "number") then
		local overlay_index = overlayData
		draw_overlay (self, self.Overlays [self.OverlaysAmount], self.OData [overlay_index][1], self.OData [overlay_index][2])
	else
		local this_overlay = self.Overlays [self.OverlaysAmount]
		if (not this_overlay) then
			this_overlay = {}
			tinsert (self.Overlays, this_overlay)
		end

		draw_overlay (self, this_overlay, overlayData, color)

		tinsert (self.OData, {overlayData, color or line_default_color})
		if (name) then
			self:AddLabel (color or line_default_color, name, "overlay", #self.OData)
		end
	end

	self.OverlaysAmount = self.OverlaysAmount + 1
end

local SMA_table = {}
local SMA_max = 0
local reset_SMA = function()
	table.wipe (SMA_table)
	SMA_max = 0
end

local calc_SMA
calc_SMA = function (a, b, ...)
	if (b) then 
		return calc_SMA (a + b, ...) 
	else 
		return a
	end 
end

local do_SMA = function (value, max_value)

	if (#SMA_table == 10) then 
		tremove (SMA_table, 1)
	end
	
	SMA_table [#SMA_table + 1] = value
	
	local new_value = calc_SMA (unpack (SMA_table)) / #SMA_table
	
	if (new_value > SMA_max) then
		SMA_max = new_value
		return new_value, SMA_max
	else
		return new_value
	end
	
end

local chart_panel_onresize = function (self)
	local width, height = self:GetSize()
	local spacement = width - 78 - 60
	spacement = spacement / 16
	
	for i = 1, 17 do
		local label = self.TimeLabels [i]
		label:SetPoint ("bottomleft", self, "bottomleft", 78 + ((i-1)*spacement), 13)
		label.line:SetHeight (height - 45)
	end
	
	local spacement = (self.Graphic:GetHeight()) / 8
	for i = 1, 8 do
		self ["dpsamt"..i]:SetPoint ("TOPLEFT", self, "TOPLEFT", 27, -25 + (-(spacement* (i-1))) )
		self ["dpsamt"..i].line:SetWidth (width-20)
	end
	
	self.Graphic:SetSize (width - 135, height - 67)
	self.Graphic:SetPoint ("topleft", self, "topleft", 108, -35)
end

local chart_panel_add_data = function (self, graphicData, color, name, elapsed_time, lineTexture, smoothLevel, firstIndex)

	local f = self
	self = self.Graphic

	local _data = {}
	local max_value = graphicData.max_value
	local amount = #graphicData
	
	local scaleW = 1/self:GetWidth()

	local content = graphicData
	tinsert (content, 1, 0)
	tinsert (content, 1, 0)
	tinsert (content, #content+1, 0)
	tinsert (content, #content+1, 0)
	
	local _i = 3
	
	local graphMaxDps = math.max (self.max_value, max_value)
	
	if (not smoothLevel) then
		while (_i <= #content-2) do 
			local v = (content[_i-2]+content[_i-1]+content[_i]+content[_i+1]+content[_i+2])/5 --> normalize
			_data [#_data+1] = {scaleW*(_i-2), v/graphMaxDps} --> x and y coords
			_i = _i + 1
		end
	
	elseif (smoothLevel == "SHORT") then
		while (_i <= #content-2) do 
			local value = (content[_i] + content[_i+1]) / 2
			_data [#_data+1] = {scaleW*(_i-2), value}
			_data [#_data+1] = {scaleW*(_i-2), value}
			_i = _i + 2
		end
	
	elseif (smoothLevel == "SMA") then
		reset_SMA()
		while (_i <= #content-2) do 
			local value, is_new_max_value = do_SMA (content[_i], max_value)
			if (is_new_max_value) then
				max_value = is_new_max_value
			end
			_data [#_data+1] = {scaleW*(_i-2), value} --> x and y coords
			_i = _i + 1
		end
	
	elseif (smoothLevel == -1) then
		while (_i <= #content-2) do
			local current = content[_i]
			
			local minus_2 = content[_i-2] * 0.6
			local minus_1 = content[_i-1] * 0.8
			local plus_1 = content[_i+1] * 0.8
			local plus_2 = content[_i+2] * 0.6
			
			local v = (current + minus_2 + minus_1 + plus_1 + plus_2)/5 --> normalize
			_data [#_data+1] = {scaleW*(_i-2), v/graphMaxDps} --> x and y coords
			_i = _i + 1
		end
	
	elseif (smoothLevel == 1) then
		_i = 2
		while (_i <= #content-1) do 
			local v = (content[_i-1]+content[_i]+content[_i+1])/3 --> normalize
			_data [#_data+1] = {scaleW*(_i-1), v/graphMaxDps} --> x and y coords
			_i = _i + 1
		end
		
	elseif (smoothLevel == 2) then
		_i = 1
		while (_i <= #content) do 
			local v = content[_i] --> do not normalize
			_data [#_data+1] = {scaleW*(_i), v/graphMaxDps} --> x and y coords
			_i = _i + 1
		end
		
	end
	
	tremove (content, 1)
	tremove (content, 1)
	tremove (content, #graphicData)
	tremove (content, #graphicData)

	if (max_value > self.max_value) then 
		--> normalize previous data
		if (self.max_value > 0) then
			local normalizePercent = self.max_value / max_value
			for dataIndex, Data in ipairs (self.Data) do 
				local Points = Data.Points
				for i = 1, #Points do 
					Points[i][2] = Points[i][2]*normalizePercent
				end
			end
		end
	
		self.max_value = max_value
		f:SetScale (max_value)

	end
	
	tinsert (f.GData, {_data, color or line_default_color, lineTexture, max_value, elapsed_time})
	if (name) then
		f:AddLabel (color or line_default_color, name, "graphic", #f.GData)
	end
	
	if (firstIndex) then
		if (lineTexture) then
			if (not lineTexture:find ("\\") and not lineTexture:find ("//")) then 
				local path = string.match (debugstack (1, 1, 0), "AddOns\\(.+)LibGraph%-2%.0%.lua")
				if path then
					lineTexture = "Interface\\AddOns\\" .. path .. lineTexture
				else
					lineTexture = nil
				end
			end
		end
		
		table.insert (self.Data, 1, {Points = _data, Color = color or line_default_color, lineTexture = lineTexture, ElapsedTime = elapsed_time})
		self.NeedsUpdate = true
	else
		self:AddDataSeries (_data, color or line_default_color, nil, lineTexture)
		self.Data [#self.Data].ElapsedTime = elapsed_time
	end
	
	local max_time = 0
	for _, data in ipairs (self.Data) do
		if (data.ElapsedTime > max_time) then
			max_time = data.ElapsedTime
		end
	end
	
	f:SetTime (max_time)
	
	chart_panel_onresize (f)
	
end



local chart_panel_vlines_on = function (self)
	for i = 1, 17 do
		local label = self.TimeLabels [i]
		label.line:Show()
	end
end

local chart_panel_vlines_off = function (self)
	for i = 1, 17 do
		local label = self.TimeLabels [i]
		label.line:Hide()
	end
end

local chart_panel_set_title = function (self, title)
	self.chart_title.text = title
end

local chart_panel_mousedown = function (self, button)
	if (button == "LeftButton" and self.can_move) then
		if (not self.isMoving) then
			self:StartMoving()
			self.isMoving = true
		end
	elseif (button == "RightButton" and not self.no_right_click_close) then
		if (not self.isMoving) then
			self:Hide()
		end
	end
end
local chart_panel_mouseup = function (self, button)
	if (button == "LeftButton" and self.isMoving) then
		self:StopMovingOrSizing()
		self.isMoving = nil
	end
end

local chart_panel_hide_close_button = function (self)
	self.CloseButton:Hide()
end

local chart_panel_right_click_close = function (self, value)
	if (type (value) == "boolean") then
		if (value) then
			self.no_right_click_close = nil
		else
			self.no_right_click_close = true
		end
	end
end

function DF:CreateChartPanel (parent, w, h, name)

	if (not name) then
		name = "DFPanel" .. DF.PanelCounter
		DF.PanelCounter = DF.PanelCounter + 1
	end
	
	parent = parent or UIParent
	w = w or 800
	h = h or 500

	local f = CreateFrame ("frame", name, parent)
	f:SetSize (w or 500, h or 400)
	f:EnableMouse (true)
	f:SetMovable (true)
	
	f:SetScript ("OnMouseDown", chart_panel_mousedown)
	f:SetScript ("OnMouseUp", chart_panel_mouseup)

	f:SetBackdrop (chart_panel_backdrop)
	f:SetBackdropColor (.3, .3, .3, .3)

	local c = CreateFrame ("Button", nil, f, "UIPanelCloseButton")
	c:SetWidth (32)
	c:SetHeight (32)
	c:SetPoint ("TOPRIGHT",  f, "TOPRIGHT", -3, -7)
	c:SetFrameLevel (f:GetFrameLevel()+1)
	c:SetAlpha (0.9)
	f.CloseButton = c
	
	local title = DF:NewLabel (f, nil, "$parentTitle", "chart_title", "Chart!", nil, 20, {1, 1, 0})
	title:SetPoint ("topleft", f, "topleft", 110, -13)

	local bottom_texture = DF:NewImage (f, nil, 702, 25, "background", nil, nil, "$parentBottomTexture")
	bottom_texture:SetColorTexture (0, 0, 0, .6)
	bottom_texture:SetPoint ("bottomleft", f, "bottomleft", 8, 7)
	bottom_texture:SetPoint ("bottomright", f, "bottomright", -8, 7)

	f.Overlays = {}
	f.OverlaysAmount = 1
	
	f.BoxLabels = {}
	f.BoxLabelsAmount = 1
	
	f.TimeLabels = {}
	for i = 1, 17 do 
		local time = f:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
		time:SetText ("00:00")
		time:SetPoint ("bottomleft", f, "bottomleft", 78 + ((i-1)*36), 13)
		f.TimeLabels [i] = time
		
		local line = f:CreateTexture (nil, "border")
		line:SetSize (1, h-45)
		line:SetColorTexture (1, 1, 1, .1)
		line:SetPoint ("bottomleft", time, "topright", 0, -10)
		line:Hide()
		time.line = line
	end
	
	--graphic
		local g = LibStub:GetLibrary("LibGraph-2.0"):CreateGraphLine (name .. "Graphic", f, "topleft","topleft", 108, -35, w - 120, h - 67)
		g:SetXAxis (-1,1)
		g:SetYAxis (-1,1)
		g:SetGridSpacing (false, false)
		g:SetGridColor ({0.5,0.5,0.5,0.3})
		g:SetAxisDrawing (false,false)
		g:SetAxisColor({1.0,1.0,1.0,1.0})
		g:SetAutoScale (true)
		g:SetLineTexture ("smallline")
		g:SetBorderSize ("right", 0.001)
		g:SetBorderSize ("left", 0.000)
		g:SetBorderSize ("top", 0.002)
		g:SetBorderSize ("bottom", 0.001)
		g.VerticalLines = {}
		g.max_value = 0
		
		g:SetLineTexture ("line")
		
		f.Graphic = g
		f.GData = {}
		f.OData = {}
	
	--div lines
		for i = 1, 8, 1 do
			local line = g:CreateTexture (nil, "overlay")
			line:SetColorTexture (1, 1, 1, .2)
			line:SetWidth (670)
			line:SetHeight (1.1)
		
			local s = f:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			f ["dpsamt"..i] = s
			s:SetText ("100k")
			s:SetPoint ("topleft", f, "topleft", 27, -61 + (-(24.6*i)))
		
			line:SetPoint ("topleft", s, "bottom", -27, 0)
			s.line = line
		end
	
	f.SetTime = chart_panel_align_timelabels
	f.EnableVerticalLines = chart_panel_vlines_on
	f.DisableVerticalLines = chart_panel_vlines_off
	f.SetTitle = chart_panel_set_title
	f.SetScale = chart_panel_set_scale
	f.Reset = chart_panel_reset
	f.AddLine = chart_panel_add_data
	f.CanMove = chart_panel_can_move
	f.AddLabel = chart_panel_add_label
	f.AddOverlay = chart_panel_add_overlay
	f.HideCloseButton = chart_panel_hide_close_button
	f.RightClickClose = chart_panel_right_click_close
	
	f:SetScript ("OnSizeChanged", chart_panel_onresize)
	chart_panel_onresize (f)
	
	return f
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~gframe
local gframe_on_enter_line = function (self)
	self:SetBackdropColor (0, 0, 0, 0)

	local parent = self:GetParent()
	local ball = self.ball
	ball:SetBlendMode ("ADD")
	
	local on_enter = parent._onenter_line
	if (on_enter) then
		return on_enter (self, parent)
	end
end

local gframe_on_leave_line = function (self)
	self:SetBackdropColor (0, 0, 0, .6)
	
	local parent = self:GetParent()
	local ball = self.ball
	ball:SetBlendMode ("BLEND")
	
	local on_leave = parent._onleave_line
	if (on_leave) then
		return on_leave (self, parent)
	end
end

local gframe_create_line = function (self)
	local index = #self._lines+1
	
	local f = CreateFrame ("frame", nil, self)
	self._lines [index] = f
	f.id = index
	f:SetScript ("OnEnter", gframe_on_enter_line)
	f:SetScript ("OnLeave", gframe_on_leave_line)
	
	f:SetWidth (self._linewidth)
	
	if (index == 1) then
		f:SetPoint ("topleft", self, "topleft")
		f:SetPoint ("bottomleft", self, "bottomleft")
	else
		local previous_line = self._lines [index-1]
		f:SetPoint ("topleft", previous_line, "topright")
		f:SetPoint ("bottomleft", previous_line, "bottomright")
	end
	
	local t = f:CreateTexture (nil, "background")
	t:SetWidth (1)
	t:SetPoint ("topright", f, "topright")
	t:SetPoint ("bottomright", f, "bottomright")
	t:SetColorTexture (1, 1, 1, .1)
	f.grid = t
	
	local b = f:CreateTexture (nil, "overlay")
	b:SetTexture ([[Interface\COMMON\Indicator-Yellow]])
	b:SetSize (16, 16)
	f.ball = b
	local anchor = CreateFrame ("frame", nil, f)
	anchor:SetAllPoints (b)
	b.tooltip_anchor = anchor
	
	local spellicon = f:CreateTexture (nil, "artwork")
	spellicon:SetPoint ("bottom", b, "bottom", 0, 10)
	spellicon:SetSize (16, 16)
	f.spellicon = spellicon
	
	local text = f:CreateFontString (nil, "overlay", "GameFontNormal")
	local textBackground = f:CreateTexture (nil, "artwork")
	textBackground:SetSize (30, 16)
	textBackground:SetColorTexture (0, 0, 0, 0.5)
	textBackground:SetPoint ("bottom", f.ball, "top", 0, -6)
	text:SetPoint ("center", textBackground, "center")
	DF:SetFontSize (text, 10)
	f.text = text
	f.textBackground = textBackground
	
	local timeline = f:CreateFontString (nil, "overlay", "GameFontNormal")
	timeline:SetPoint ("bottomright", f, "bottomright", -2, 0)
	DF:SetFontSize (timeline, 8)
	f.timeline = timeline
	
	return f
end

local gframe_getline = function (self, index)
	local line = self._lines [index]
	if (not line) then
		line = gframe_create_line (self)
	end
	return line
end

local gframe_reset = function (self)
	for i, line in ipairs (self._lines) do
		line:Hide()
	end
	if (self.GraphLib_Lines_Used) then
		for i = #self.GraphLib_Lines_Used, 1, -1 do
			local line = tremove (self.GraphLib_Lines_Used)
			tinsert (self.GraphLib_Lines, line)
			line:Hide()
		end
	end
end

local gframe_update = function (self, lines)
	
	local g = LibStub:GetLibrary ("LibGraph-2.0")
	local h = self:GetHeight()/100
	local amtlines = #lines
	local linewidth = self._linewidth
	
	local max_value = 0
	for i = 1, amtlines do
		if (lines [i].value > max_value) then
			max_value = lines [i].value
		end
	end
	
	self.MaxValue = max_value
	
	local o = 1
	local lastvalue = self:GetHeight()/2
	max_value = math.max (max_value, 0.0000001)
	
	for i = 1, min (amtlines, self._maxlines) do
		
		local data = lines [i]

		local pvalue = data.value / max_value * 100
		if (pvalue > 98) then
			pvalue = 98
		end
		pvalue = pvalue * h
	
		g:DrawLine (self, (o-1)*linewidth, lastvalue, o*linewidth, pvalue, linewidth, {1, 1, 1, 1}, "overlay")
		lastvalue = pvalue

		local line = self:GetLine (i)
		line:Show()
		line.ball:Show()
		
		line.ball:SetPoint ("bottomleft", self, "bottomleft", (o*linewidth)-8, pvalue-8)
		line.spellicon:SetTexture (nil)
		line.timeline:SetText (data.text)
		line.timeline:Show()
		
		if (data.utext) then
			line.text:Show()
			line.textBackground:Show()
			line.text:SetText (data.utext)
		else
			line.text:Hide()
			line.textBackground:Hide()
		end
		
		line.data = data
		
		o = o + 1
	end
	
end

function DF:CreateGFrame (parent, w, h, linewidth, onenter, onleave, member, name)
	local f = CreateFrame ("frame", name, parent)
	f:SetSize (w or 450, h or 150)
	--f.CustomLine = [[Interface\AddOns\Details\Libs\LibGraph-2.0\line]]
	
	if (member) then
		parent [member] = f
	end
	
	f.CreateLine = gframe_create_line
	f.GetLine = gframe_getline
	f.Reset = gframe_reset
	f.UpdateLines = gframe_update
	
	f.MaxValue = 0
	
	f._lines = {}
	
	f._onenter_line = onenter
	f._onleave_line = onleave
	
	f._linewidth = linewidth or 50
	f._maxlines = floor (f:GetWidth() / f._linewidth)
	
	return f
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~buttoncontainer

function DF:CreateButtonContainer (parent, name)
	local f = CreateFrame ("frame", name, parent)
--	f.
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> options tabs and buttons -dot

function DF:FindHighestParent (self)
	local f
	if (self:GetParent() == UIParent) then
		f = self
	end
	if (not f) then
		f = self
		for i = 1, 6 do
			local parent = f:GetParent()
			if (parent == UIParent) then
				break
			else
				f = parent
			end
		end
	end
	
	return f
end

DF.TabContainerFunctions = {}

local button_tab_template = DF.table.copy ({}, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
button_tab_template.backdropbordercolor = nil

DF.TabContainerFunctions.CreateUnderlineGlow = function (button)
	local selectedGlow = button:CreateTexture (nil, "background", -4)
	selectedGlow:SetPoint ("topleft", button.widget, "bottomleft", -7, 0)
	selectedGlow:SetPoint ("topright", button.widget, "bottomright", 7, 0)
	selectedGlow:SetTexture ([[Interface\BUTTONS\UI-Panel-Button-Glow]])
	selectedGlow:SetTexCoord (0, 95/128, 30/64, 38/64)
	selectedGlow:SetBlendMode ("ADD")
	selectedGlow:SetHeight (8)
	selectedGlow:SetAlpha (.75)
	selectedGlow:Hide()
	button.selectedUnderlineGlow = selectedGlow
end

DF.TabContainerFunctions.OnMouseDown = function (self, button)
	--> search for UIParent
	local f = DF:FindHighestParent (self)
	local container = self:GetParent()
	
	if (button == "LeftButton") then
		if (not f.IsMoving and f:IsMovable()) then
			f:StartMoving()
			f.IsMoving = true
		end
	elseif (button == "RightButton") then
		if (not f.IsMoving and container.IsContainer) then
			if (self.IsFrontPage) then
				if (container.CanCloseWithRightClick) then
					if (f.CloseFunction) then
						f:CloseFunction()
					else
						f:Hide()
					end
				end
			else
				--goes back to front page
				DF.TabContainerFunctions.SelectIndex (self, _, 1)
			end
		end
	end
end

DF.TabContainerFunctions.OnMouseUp = function (self, button)
	local f = DF:FindHighestParent (self)
	if (f.IsMoving) then
		f:StopMovingOrSizing()
		f.IsMoving = false
	end
end

DF.TabContainerFunctions.SelectIndex = function (self, fixedParam, menuIndex)
	local mainFrame = self.AllFrames and self or self.mainFrame or self:GetParent()
	
	for i = 1, #mainFrame.AllFrames do
		mainFrame.AllFrames[i]:Hide()
		if (mainFrame.ButtonNotSelectedBorderColor) then
			mainFrame.AllButtons[i]:SetBackdropBorderColor (unpack (mainFrame.ButtonNotSelectedBorderColor))
		end
		if (mainFrame.AllButtons[i].selectedUnderlineGlow) then
			mainFrame.AllButtons[i].selectedUnderlineGlow:Hide()
		end
	end
	
	mainFrame.AllFrames[menuIndex]:Show()
	if (mainFrame.ButtonSelectedBorderColor) then
		mainFrame.AllButtons[menuIndex]:SetBackdropBorderColor (unpack (mainFrame.ButtonSelectedBorderColor))
	end
	if (mainFrame.AllButtons[menuIndex].selectedUnderlineGlow) then
		mainFrame.AllButtons[menuIndex].selectedUnderlineGlow:Show()
	end
	mainFrame.CurrentIndex = menuIndex
end

DF.TabContainerFunctions.SetIndex = function (self, index)
	self.CurrentIndex = index
end

local tab_container_on_show = function (self)
	local index = self.CurrentIndex
	self.SelectIndex (self.AllButtons[index], nil, index)
end

function DF:CreateTabContainer (parent, title, frame_name, frame_list, options_table)
	
	local options_text_template = DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
	local options_dropdown_template = DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local options_switch_template = DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
	local options_slider_template = DF:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
	local options_button_template = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
	
	options_table = options_table or {}
	local frame_width = parent:GetWidth()
	local frame_height = parent:GetHeight()
	local y_offset = options_table.y_offset or 0
	local button_width = options_table.button_width or 160
	local button_height = options_table.button_height or 20
	local button_anchor_x = options_table.button_x or 230
	local button_anchor_y = options_table.button_y or -32
	local button_text_size = options_table.button_text_size or 10
	
	local mainFrame = CreateFrame ("frame", frame_name, parent.widget or parent)
	mainFrame:SetAllPoints()
	DF:Mixin (mainFrame, DF.TabContainerFunctions)
	
	local mainTitle = DF:CreateLabel (mainFrame, title, 24, "white")
	mainTitle:SetPoint ("topleft", mainFrame, "topleft", 10, -30 + y_offset)
	
	mainFrame:SetFrameLevel (200)
	
	mainFrame.AllFrames = {}
	mainFrame.AllButtons = {}
	mainFrame.CurrentIndex = 1
	mainFrame.IsContainer = true
	mainFrame.ButtonSelectedBorderColor = options_table.button_selected_border_color or {1, 1, 0, 1}
	mainFrame.ButtonNotSelectedBorderColor = options_table.button_border_color or {0, 0, 0, 0}
	
	if (options_table.right_click_interact ~= nil) then
		mainFrame.CanCloseWithRightClick = options_table.right_click_interact
	else
		mainFrame.CanCloseWithRightClick = true
	end
	
	for i, frame in ipairs (frame_list) do
		local f = CreateFrame ("frame", "$parent" .. frame.name, mainFrame)
		f:SetAllPoints()
		f:SetFrameLevel (210)
		f:Hide()
		
		local title = DF:CreateLabel (f, frame.title, 16, "silver")
		title:SetPoint ("topleft", mainTitle, "bottomleft", 0, 0)
		
		local tabButton = DF:CreateButton (mainFrame, DF.TabContainerFunctions.SelectIndex, button_width, button_height, frame.title, i, nil, nil, nil, nil, false, button_tab_template)
		tabButton:SetFrameLevel (220)
		tabButton.textsize = button_text_size
		tabButton.mainFrame = mainFrame
		DF.TabContainerFunctions.CreateUnderlineGlow (tabButton)
		
		if (i == 1) then
			local right_click_to_back = DF:CreateLabel (f, "right click to close", 10, "gray")
			right_click_to_back:SetPoint ("bottomright", f, "bottomright", -1, 0)
			f.IsFrontPage = true
		else
			local right_click_to_back = DF:CreateLabel (f, "right click to go back to main menu", 10, "gray")
			right_click_to_back:SetPoint ("bottomright", f, "bottomright", -1, 0)
		end
		
		f:SetScript ("OnMouseDown", DF.TabContainerFunctions.OnMouseDown)
		f:SetScript ("OnMouseUp", DF.TabContainerFunctions.OnMouseUp)
		
		tinsert (mainFrame.AllFrames, f)
		tinsert (mainFrame.AllButtons, tabButton)
	end
	
	--order buttons
	local x = button_anchor_x
	local y = button_anchor_y
	local space_for_buttons = frame_width - (#frame_list*3) - button_anchor_x
	local amount_buttons_per_row = floor (space_for_buttons / button_width)
	local last_button = mainFrame.AllButtons[1]
	
	mainFrame.AllButtons[1]:SetPoint ("topleft", mainTitle, "topleft", x, y)
	x = x + button_width + 2
	
	for i = 2, #mainFrame.AllButtons do
		local button = mainFrame.AllButtons [i]
		button:SetPoint ("topleft", mainTitle, "topleft", x, y)
		x = x + button_width + 2
		
		if (i % amount_buttons_per_row == 0) then
			x = button_anchor_x
			y = y - button_height - 1
		end
	end
	
	--> when show the frame, reset to the current internal index
	mainFrame:SetScript ("OnShow", tab_container_on_show)
	--> select the first frame
	mainFrame.SelectIndex (mainFrame.AllButtons[1], nil, 1)

	return mainFrame
end





------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~listbox

local simple_list_box_ResetWidgets = function (self)
	for _, widget in ipairs (self.widgets) do 
		widget:Hide()
	end
	self.nextWidget = 1
end

local simple_list_box_onenter = function (self, capsule)
	self:GetParent().options.onenter (self, capsule, capsule.value)
end

local simple_list_box_onleave = function (self, capsule)
	self:GetParent().options.onleave (self, capsule, capsule.value)
	GameTooltip:Hide()
end

local simple_list_box_GetOrCreateWidget = function (self)
	local index = self.nextWidget
	local widget = self.widgets [index]
	if (not widget) then
		widget = DF:CreateButton (self, function()end, self.options.width, self.options.row_height, "", nil, nil, nil, nil, nil, nil, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
		widget:SetHook ("OnEnter", simple_list_box_onenter)
		widget:SetHook ("OnLeave", simple_list_box_onleave)
		widget.textcolor = self.options.textcolor
		tinsert (self.widgets, widget)
	end
	self.nextWidget = self.nextWidget + 1
	return widget
end

local simple_list_box_RefreshWidgets = function (self)
	self:ResetWidgets()
	local amt = 0
	for value, _ in pairs (self.list_table) do
		local widget = self:GetOrCreateWidget()
		widget:SetPoint ("topleft", self, "topleft", 1, -self.options.row_height * (self.nextWidget-2) - 4)
		widget:SetPoint ("topright", self, "topright", -1, -self.options.row_height * (self.nextWidget-2) - 4)
		widget:SetClickFunction (self.func, value)
		widget.value = value
		
		if (self.options.icon) then
			if (type (self.options.icon) == "string" or type (self.options.icon) == "number") then
				widget:SetIcon (self.options.icon, self.options.row_height, self.options.row_height)
			elseif (type (self.options.icon) == "function") then
				local icon = self.options.icon (value)
				if (icon) then
					widget:SetIcon (icon, self.options.row_height, self.options.row_height)
				end
			end
		else
			widget:SetIcon ("", self.options.row_height, self.options.row_height)
		end
		
		if (self.options.text) then
			if (type (self.options.text) == "function") then
				local text = self.options.text (value)
				if (text) then
					widget:SetText (text)
				else
					widget:SetText ("")
				end
			else
				widget:SetText (self.options.text or "")
			end
		else
			widget:SetText ("")
		end
		
		widget.value = value
		widget:Show()
		amt = amt + 1
	end
	if (amt == 0) then
		self.EmptyLabel:Show()
	else
		self.EmptyLabel:Hide()
	end
end

local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1}
local default_options = {
	height = 400, 
	row_height = 16,
	width = 230, 
	icon = false, 
	text = "",
	textcolor = "wheat",
	onenter = function (self, capsule)
		if (capsule) then
			capsule.textcolor = "white"
		end
	end,
	onleave = function (self, capsule)
		if (capsule) then
			capsule.textcolor = self:GetParent().options.textcolor
		end
		GameTooltip:Hide()
	end,
}

local simple_list_box_SetData = function (self, t)
	self.list_table = t
end

function DF:CreateSimpleListBox (parent, name, title, empty_text, list_table, onclick, options)
	local f = CreateFrame ("frame", name, parent)
	
	f.ResetWidgets = simple_list_box_ResetWidgets
	f.GetOrCreateWidget = simple_list_box_GetOrCreateWidget
	f.Refresh = simple_list_box_RefreshWidgets
	f.SetData = simple_list_box_SetData
	f.nextWidget = 1
	f.list_table = list_table
	f.func = function (self, button, value)
		onclick (value)
		f:Refresh()
	end
	f.widgets = {}
	f:SetBackdrop (backdrop)
	f:SetBackdropColor (0, 0, 0, 0.3)
	f:SetBackdropBorderColor (0, 0, 0, 0.5)
	f.options = options or {}
	self.table.deploy (f.options, default_options)
	
	f:SetSize (f.options.width + 2, f.options.height)
	
	local name = DF:CreateLabel (f, title, 12, "silver")
	name:SetTemplate (DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	name:SetPoint ("bottomleft", f, "topleft", 0, 2)
	f.Title = name
	
	local emptyLabel = DF:CreateLabel (f, empty_text, 12, "gray")
	emptyLabel:SetAlpha (.6)
	emptyLabel:SetSize (f.options.width-10, f.options.height)
	emptyLabel:SetPoint ("center", 0, 0)
	emptyLabel:Hide()
	emptyLabel.align = "center"
	f.EmptyLabel = emptyLabel
	
	return f
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~scrollbox

DF.SortFunctions = {}

local SortMember = ""
local SortByMember = function (t1, t2)
	return t1[SortMember] > t2[SortMember]
end
local SortByMemberReverse = function (t1, t2)
	return t1[SortMember] < t2[SortMember]
end

DF.SortFunctions.Sort = function (self, t, by, is_reverse)
	SortMember = by
	if (not is_reverse) then
		table.sort (t, SortByMember)
	else
		table.sort (t, SortByMemberReverse)
	end
end


DF.ScrollBoxFunctions = {}

DF.ScrollBoxFunctions.Refresh = function (self)
	for _, frame in ipairs (self.Frames) do 
		frame:Hide()
		frame._InUse = nil
	end
	
	local offset = 0
	if (self.IsFauxScroll) then
		FauxScrollFrame_Update (self, #self.data, self.LineAmount, self.LineHeight+1)
		offset = FauxScrollFrame_GetOffset (self)
	end	
	
	local okay, totalLines = pcall (self.refresh_func, self, self.data, offset, self.LineAmount)
	if (not okay) then
		error ("Details! FrameWork: Refresh(): " .. totalLines)
	end

	for _, frame in ipairs (self.Frames) do 
		if (not frame._InUse) then
			frame:Hide()
		else
			frame:Show()
		end
	end
	
	self:Show()
	
	if (self.HideScrollBar) then
		local frameName = self:GetName()
		if (frameName) then
			local scrollBar = _G [frameName .. "ScrollBar"]
			if (scrollBar) then
				scrollBar:Hide()
			end
		else
		
		end
		
	end
	
	return self.Frames
end

DF.ScrollBoxFunctions.OnVerticalScroll = function (self, offset)
	FauxScrollFrame_OnVerticalScroll (self, offset, self.LineHeight, self.Refresh)
	return true
end

DF.ScrollBoxFunctions.CreateLine = function (self, func)
	if (not func) then
		func = self.CreateLineFunc
	end
	local okay, newLine = pcall (func, self, #self.Frames+1)
	if (okay) then
		tinsert (self.Frames, newLine)
		newLine.Index = #self.Frames
		return newLine
	else
		error ("Details! FrameWork: CreateLine(): " .. newLine)
	end
end

DF.ScrollBoxFunctions.GetLine = function (self, line_index)
	local line = self.Frames [line_index]
	if (line) then
		line._InUse = true
	end
	return line
end

DF.ScrollBoxFunctions.SetData = function (self, data)
	self.data = data
end
DF.ScrollBoxFunctions.GetData = function (self)
	return self.data
end

DF.ScrollBoxFunctions.GetFrames = function (self)
	return self.Frames
end

DF.ScrollBoxFunctions.GetNumFramesCreated = function (self)
	return #self.Frames
end

DF.ScrollBoxFunctions.GetNumFramesShown = function (self)
	return self.LineAmount
end

DF.ScrollBoxFunctions.SetNumFramesShown = function (self, new_amount)
	--> hide frames which won't be used
	if (new_amount < #self.Frames) then
		for i = new_amount+1, #self.Frames do
			self.Frames [i]:Hide()
		end
	end
	
	--> set the new amount
	self.LineAmount = new_amount
end

DF.ScrollBoxFunctions.SetFramesHeight = function (self, new_height)
	self.LineHeight = new_height
	self:OnSizeChanged()
	self:Refresh()
end

DF.ScrollBoxFunctions.OnSizeChanged = function (self)
	if (self.ReajustNumFrames) then
		--> how many lines the scroll can show
		local amountOfFramesToShow = floor (self:GetHeight() / self.LineHeight)
		
		--> how many lines the scroll already have
		local totalFramesCreated = self:GetNumFramesCreated()
		
		--> how many lines are current shown
		local totalFramesShown = self:GetNumFramesShown()

		--> the amount of frames increased
		if (amountOfFramesToShow > totalFramesShown) then
			for i = totalFramesShown+1, amountOfFramesToShow do
				--> check if need to create a new line
				if (i > totalFramesCreated) then
					self:CreateLine (self.CreateLineFunc)
				end
			end
			
		--> the amount of frames decreased
		elseif (amountOfFramesToShow < totalFramesShown) then
			--> hide all frames above the new amount to show
			for i = totalFramesCreated, amountOfFramesToShow, -1 do
				if (self.Frames [i]) then
					self.Frames [i]:Hide()
				end
			end
		end

		--> set the new amount of frames
		self:SetNumFramesShown (amountOfFramesToShow)
		
		--> refresh lines
		self:Refresh()
	end
end

function DF:CreateScrollBox (parent, name, refresh_func, data, width, height, line_amount, line_height, create_line_func, auto_amount, no_scroll)
	local scroll = CreateFrame ("scrollframe", name, parent, "FauxScrollFrameTemplate")
	
	scroll:SetSize (width, height)
	scroll.LineAmount = line_amount
	scroll.LineHeight = line_height
	scroll.IsFauxScroll = true
	scroll.HideScrollBar = no_scroll
	scroll.Frames = {}
	scroll.ReajustNumFrames = auto_amount
	scroll.CreateLineFunc = create_line_func
	
	DF:Mixin (scroll, DF.SortFunctions)
	DF:Mixin (scroll, DF.ScrollBoxFunctions)
	
	scroll.refresh_func = refresh_func
	scroll.data = data
	
	scroll:SetScript ("OnVerticalScroll", scroll.OnVerticalScroll)
	scroll:SetScript ("OnSizeChanged", DF.ScrollBoxFunctions.OnSizeChanged)
	
	return scroll
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~resizers

function DF:CreateResizeGrips (parent)
	if (parent) then
		local parentName = parent:GetName()
		
		local leftResizer = CreateFrame ("button", parentName and parentName .. "LeftResizer" or nil, parent)
		local rightResizer = CreateFrame ("button", parentName and parentName .. "RightResizer" or nil, parent)
		
		leftResizer:SetPoint ("bottomleft", parent, "bottomleft")
		rightResizer:SetPoint ("bottomright", parent, "bottomright")
		leftResizer:SetSize (16, 16)
		rightResizer:SetSize (16, 16)
		
		rightResizer:SetNormalTexture ([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Up]])
		rightResizer:SetHighlightTexture ([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Highlight]])
		rightResizer:SetPushedTexture ([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Down]])
		leftResizer:SetNormalTexture ([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Up]])
		leftResizer:SetHighlightTexture ([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Highlight]])
		leftResizer:SetPushedTexture ([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Down]])
		
		leftResizer:GetNormalTexture():SetTexCoord (1, 0, 0, 1)
		leftResizer:GetHighlightTexture():SetTexCoord (1, 0, 0, 1)
		leftResizer:GetPushedTexture():SetTexCoord (1, 0, 0, 1)
		
		return leftResizer, rightResizer
	end
end
