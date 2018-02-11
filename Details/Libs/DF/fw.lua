
local dversion = 65
local major, minor = "DetailsFramework-1.0", dversion
local DF, oldminor = LibStub:NewLibrary (major, minor)

if (not DF) then
	DetailsFrameworkCanLoad = false
	return 
end

DetailsFrameworkCanLoad = true
local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")

local _
local _type = type
local _unpack = unpack
local upper = string.upper

--> will always give a very random name for our widgets
local init_counter = math.random (1, 1000000)

DF.LabelNameCounter = DF.LabelNameCounter or init_counter
DF.PictureNameCounter = DF.PictureNameCounter or init_counter
DF.BarNameCounter = DF.BarNameCounter or init_counter
DF.DropDownCounter = DF.DropDownCounter or init_counter
DF.PanelCounter = DF.PanelCounter or init_counter
DF.SimplePanelCounter = DF.SimplePanelCounter or init_counter
DF.ButtonCounter = DF.ButtonCounter or init_counter
DF.SliderCounter = DF.SliderCounter or init_counter
DF.SwitchCounter = DF.SwitchCounter or init_counter
DF.SplitBarCounter = DF.SplitBarCounter or init_counter

DF.FRAMELEVEL_OVERLAY = 750
DF.FRAMELEVEL_BACKGROUND = 150

DF.FrameWorkVersion = tostring (dversion)
function DF:PrintVersion()
	print ("Details! Framework Version:", DF.FrameWorkVersion)
end

LibStub:GetLibrary("AceTimer-3.0"):Embed (DF)

--> get the working folder
do
	local path = string.match (debugstack (1, 1, 0), "AddOns\\(.+)fw.lua")
	if (path) then
		DF.folder = "Interface\\AddOns\\" .. path
	else
		--> if not found, try to use the last valid one
		DF.folder = DF.folder or ""
	end
end

DF.debug = false

_G ["DetailsFramework"] = DF

DF.embeds = DF.embeds or {}
local embed_functions = {
	"RemoveRealName",
	"table",
	"BuildDropDownFontList",
	"SetFontSize",
	"SetFontFace",
	"SetFontColor",
	"GetFontSize",
	"GetFontFace",
	"SetFontOutline",
	"trim",
	"Msg",
	"CreateFlashAnimation",
	"Fade",
	"NewColor",
	"IsHtmlColor",
	"ParseColors",
	"BuildMenu",
	"ShowTutorialAlertFrame",
	"GetNpcIdFromGuid",
	"ShowFeedbackPanel",
	"SetAsOptionsPanel",
	
	"CreateDropDown",
	"CreateButton",
	"CreateColorPickButton",
	"CreateLabel",
	"CreateBar",
	"CreatePanel",
	"CreateFillPanel",
	"ColorPick",
	"IconPick",
	"CreateSimplePanel",
	"CreateChartPanel",
	"CreateImage",
	"CreateScrollBar",
	"CreateSwitch",
	"CreateSlider",
	"CreateSplitBar",
	"CreateTextEntry",
	"Create1PxPanel",
	"CreateFeedbackButton",
	"CreateOptionsFrame",
	"NewSpecialLuaEditorEntry",
	"ShowPromptPanel",
	"ShowTextPromptPanel",
	"www_icons",
	"GetTemplate",
	"InstallTemplate",
	"GetFrameworkFolder",
	"ShowPanicWarning",
	"SetFrameworkDebugState",
	"FindHighestParent",
	"OpenInterfaceProfile",
	"CreateInCombatTexture",
	"CreateAnimationHub",
	"CreateAnimation",
	"CreateScrollBox",
	"CreateBorder",
	"FormatNumber",
	"IntegerToTimer",
}

DF.table = {}

function DF:GetFrameworkFolder()
	return DF.folder
end

function DF:SetFrameworkDebugState (state)
	DF.debug = state
end

function DF:FadeFrame (frame, t)
	if (t == 0) then
		frame.hidden = false
		frame.faded = false
		frame.fading_out = false
		frame.fading_in = false
		frame:Show()
		frame:SetAlpha (1)
		
	elseif (t == 1) then
		frame.hidden = true
		frame.faded = true
		frame.fading_out = false
		frame.fading_in = false
		frame:SetAlpha (0)
		frame:Hide()
	end
end

function DF.table.reverse (t)
	local new = {}
	local index = 1
	for i = #t, 1, -1 do
		new [index] = t[i]
		index = index + 1
	end
	return new
end

--> copy from table2 to table1 overwriting values
function DF.table.copy (t1, t2)
	for key, value in pairs (t2) do 
		if (type (value) == "table") then
			t1 [key] = t1 [key] or {}
			DF.table.copy (t1 [key], t2 [key])
		else
			t1 [key] = value
		end
	end
	return t1
end

--> copy values that does exist on table2 but not on table1
function DF.table.deploy (t1, t2)
	for key, value in pairs (t2) do 
		if (type (value) == "table") then
			t1 [key] = t1 [key] or {}
			DF.table.deploy (t1 [key], t2 [key])
		elseif (t1 [key] == nil) then
			t1 [key] = value
		end
	end
end

function DF.table.dump (t, s, deep)
	s = s or ""
	deep = deep or 0
	local space = ""
	for i = 1, deep do
		space = space .. "   "
	end
	for key, value in pairs (t) do
		local tpe = _type (value)
		if (type (key) ~= "string") then
			key = "unknown?"
		end		
		if (tpe == "table") then
			s = s .. space .. "[" .. key .. "] = |cFFa9ffa9table {|r\n"
			s = s .. DF.table.dump (value, nil, deep+1)
			s = s .. space .. "|cFFa9ffa9}|r\n"
		elseif (tpe == "string") then
			s = s .. space .. "[" .. key .. "] = '|cFFfff1c1" .. value .. "|r'\n"
		elseif (tpe == "number") then
			s = s .. space .. "[" .. key .. "] = |cFFffc1f4" .. value .. "|r\n"
		elseif (tpe == "function") then
			s = s .. space .. "[" .. key .. "] = function()\n"
		elseif (tpe == "boolean") then
			s = s .. space .. "[" .. key .. "] = |cFF99d0ff" .. (value and "true" or "false") .. "|r\n"
		end
	end
	return s
end

DF.www_icons = {
	texture = "feedback_sites",
	wowi = {0, 0.7890625, 0, 37/128},
	curse = {0, 0.7890625, 38/123, 79/128},
	mmoc = {0, 0.7890625, 80/123, 123/128},
}

local symbol_1K, symbol_10K, symbol_1B
if (GetLocale() == "koKR") then
	symbol_1K, symbol_10K, symbol_1B = "천", "만", "억"
elseif (GetLocale() == "zhCN") then
	symbol_1K, symbol_10K, symbol_1B = "千", "万", "亿"
elseif (GetLocale() == "zhTW") then
	symbol_1K, symbol_10K, symbol_1B = "千", "萬", "億"
end

if (symbol_1K) then
	function DF.FormatNumber (numero)
		if (numero > 99999999) then
			return format ("%.2f", numero/100000000) .. symbol_1B
		elseif (numero > 999999) then
			return format ("%.2f", numero/10000) .. symbol_10K
		elseif (numero > 99999) then
			return floor (numero/10000) .. symbol_10K
		elseif (numero > 9999) then
			return format ("%.1f", (numero/10000)) .. symbol_10K
		elseif (numero > 999) then
			return format ("%.1f", (numero/1000)) .. symbol_1K
		end
		return format ("%.1f", numero)
	end
else
	function DF.FormatNumber (numero)
		if (numero > 999999999) then
			return format ("%.2f", numero/1000000000) .. "B"
		elseif (numero > 999999) then
			return format ("%.2f", numero/1000000) .. "M"
		elseif (numero > 99999) then
			return floor (numero/1000) .. "K"
		elseif (numero > 999) then
			return format ("%.1f", (numero/1000)) .. "K"
		end
		return format ("%.1f", numero)
	end
end

function DF:IntegerToTimer (value)
	return "" .. floor (value/60) .. ":" .. format ("%02.f", value%60)
end

function DF:Embed (target)
	for k, v in pairs (embed_functions) do
		target[v] = self[v]
	end
	self.embeds [target] = true
	return target
end

function DF:RemoveRealmName (name)
	return name:gsub (("%-.*"), "")
end

function DF:RemoveRealName (name)
	return name:gsub (("%-.*"), "")
end

function DF:SetFontSize (fontString, ...)
	local fonte, _, flags = fontString:GetFont()
	fontString:SetFont (fonte, max (...), flags)
end
function DF:SetFontFace (fontString, fontface)
	local font = SharedMedia:Fetch ("font", fontface, true)
	if (font) then
		fontface = font
	end

	local _, size, flags = fontString:GetFont()
	fontString:SetFont (fontface, size, flags)
end
function DF:SetFontColor (fontString, r, g, b, a)
	r, g, b, a = DF:ParseColors (r, g, b, a)
	fontString:SetTextColor (r, g, b, a)
end

function DF:GetFontSize (fontString)
	local _, size = fontString:GetFont()
	return size
end
function DF:GetFontFace (fontString)
	local fontface = fontString:GetFont()
	return fontface
end

local ValidOutlines = {
	["NONE"] = true,
	["MONOCHROME"] = true,
	["OUTLINE"] = true,
	["THICKOUTLINE"] = true,
}
function DF:SetFontOutline (fontString, outline)
	local fonte, size = fontString:GetFont()
	if (outline) then
		if (ValidOutlines [outline]) then
			outline = outline
		elseif (_type (outline) == "boolean" and outline) then
			outline = "OUTLINE"
		elseif (outline == 1) then
			outline = "OUTLINE"
		elseif (outline == 2) then
			outline = "THICKOUTLINE"
		end
	end

	fontString:SetFont (fonte, size, outline)
end

function DF:trim (s)
	local from = s:match"^%s*()"
	return from > #s and "" or s:match(".*%S", from)
end

function DF:Msg (msg)
	print ("|cFFFFFFAA" .. self.__name .. "|r " .. msg)
end

function DF:GetNpcIdFromGuid (guid)
	local NpcId = select ( 6, strsplit ( "-", guid ) )
	if (NpcId) then
		return tonumber ( NpcId )
	end
	return 0
end

local onFinish = function (self)
	if (self.showWhenDone) then
		self.frame:SetAlpha (1)
	else
		self.frame:SetAlpha (0)
		self.frame:Hide()
	end
	
	if (self.onFinishFunc) then
		self:onFinishFunc (self.frame)
	end
end

local stop = function (self)
	local FlashAnimation = self.FlashAnimation
	FlashAnimation:Stop()
end

local flash = function (self, fadeInTime, fadeOutTime, flashDuration, showWhenDone, flashInHoldTime, flashOutHoldTime, loopType)
	
	local FlashAnimation = self.FlashAnimation
	
	local fadeIn = FlashAnimation.fadeIn
	local fadeOut = FlashAnimation.fadeOut
	
	fadeIn:Stop()
	fadeOut:Stop()

	fadeIn:SetDuration (fadeInTime or 1)
	fadeIn:SetEndDelay (flashInHoldTime or 0)
	
	fadeOut:SetDuration (fadeOutTime or 1)
	fadeOut:SetEndDelay (flashOutHoldTime or 0)

	FlashAnimation.duration = flashDuration
	FlashAnimation.loopTime = FlashAnimation:GetDuration()
	FlashAnimation.finishAt = GetTime() + flashDuration
	FlashAnimation.showWhenDone = showWhenDone
	
	FlashAnimation:SetLooping (loopType or "REPEAT")
	
	self:Show()
	self:SetAlpha (0)
	FlashAnimation:Play()
end

function DF:CreateFlashAnimation (frame, onFinishFunc, onLoopFunc)
	local FlashAnimation = frame:CreateAnimationGroup() 
	
	FlashAnimation.fadeOut = FlashAnimation:CreateAnimation ("Alpha") --> fade out anime
	FlashAnimation.fadeOut:SetOrder (1)
	FlashAnimation.fadeOut:SetFromAlpha (0)
	FlashAnimation.fadeOut:SetToAlpha (1)
	
	FlashAnimation.fadeIn = FlashAnimation:CreateAnimation ("Alpha") --> fade in anime
	FlashAnimation.fadeIn:SetOrder (2)
	FlashAnimation.fadeIn:SetFromAlpha (1)
	FlashAnimation.fadeIn:SetToAlpha (0)
	
	frame.FlashAnimation = FlashAnimation
	FlashAnimation.frame = frame
	FlashAnimation.onFinishFunc = onFinishFunc
	
	FlashAnimation:SetScript ("OnLoop", onLoopFunc)
	FlashAnimation:SetScript ("OnFinished", onFinish)
	
	frame.Flash = flash
	frame.Stop = stop
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> points

	function DF:CheckPoints (v1, v2, v3, v4, v5, object)

		if (not v1 and not v2) then
			return "topleft", object.widget:GetParent(), "topleft", 0, 0
		end
		
		if (_type (v1) == "string") then
			local frameGlobal = _G [v1]
			if (frameGlobal and type (frameGlobal) == "table" and frameGlobal.GetObjectType) then
				return DF:CheckPoints (frameGlobal, v2, v3, v4, v5, object)
			end
			
		elseif (_type (v2) == "string") then
			local frameGlobal = _G [v2]
			if (frameGlobal and type (frameGlobal) == "table" and frameGlobal.GetObjectType) then
				return DF:CheckPoints (v1, frameGlobal, v3, v4, v5, object)
			end
		end
		
		if (_type (v1) == "string" and _type (v2) == "table") then --> :setpoint ("left", frame, _, _, _)
			if (not v3 or _type (v3) == "number") then --> :setpoint ("left", frame, 10, 10)
				v1, v2, v3, v4, v5 = v1, v2, v1, v3, v4
			end
			
		elseif (_type (v1) == "string" and _type (v2) == "number") then --> :setpoint ("topleft", x, y)
			v1, v2, v3, v4, v5 = v1, object.widget:GetParent(), v1, v2, v3
			
		elseif (_type (v1) == "number") then --> :setpoint (x, y) 
			v1, v2, v3, v4, v5 = "topleft", object.widget:GetParent(), "topleft", v1, v2

		elseif (_type (v1) == "table") then --> :setpoint (frame, x, y)
			v1, v2, v3, v4, v5 = "topleft", v1, "topleft", v2, v3
			
		end
		
		if (not v2) then
			v2 = object.widget:GetParent()
		elseif (v2.dframework) then
			v2 = v2.widget
		end
		
		return v1 or "topleft", v2, v3 or "topleft", v4 or 0, v5 or 0
	end
	

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> colors

	function DF:NewColor (_colorname, _colortable, _green, _blue, _alpha)
		assert (_type (_colorname) == "string", "NewColor: colorname must be a string.")
		assert (not DF.alias_text_colors [_colorname], "NewColor: colorname already exists.")

		if (_type (_colortable) == "table") then
			if (_colortable[1] and _colortable[2] and _colortable[3]) then
				_colortable[4] = _colortable[4] or 1
				DF.alias_text_colors [_colorname] = _colortable
			else
				error ("invalid color table.")
			end
		elseif (_colortable and _green and _blue) then
			_alpha = _alpha or 1
			DF.alias_text_colors [_colorname] = {_colortable, _green, _blue, _alpha}
		else
			error ("invalid parameter.")
		end
		
		return true
	end

	function DF:IsHtmlColor (color)
		return DF.alias_text_colors [color]
	end

	local tn = tonumber
	function DF:ParseColors (_arg1, _arg2, _arg3, _arg4)
		if (_type (_arg1) == "table") then
			if (not _arg1[1] and _arg1.r) then
				_arg1, _arg2, _arg3, _arg4 = _arg1.r, _arg1.g, _arg1.b, _arg1.a
			else
				_arg1, _arg2, _arg3, _arg4 = _unpack (_arg1)
			end
		
		elseif (_type (_arg1) == "string") then
		
			if (string.find (_arg1, "#")) then
				_arg1 = _arg1:gsub ("#","")
				if (string.len (_arg1) == 8) then --alpha
					_arg1, _arg2, _arg3, _arg4 = tn ("0x" .. _arg1:sub (3, 4))/255, tn ("0x" .. _arg1:sub (5, 6))/255, tn ("0x" .. _arg1:sub (7, 8))/255, tn ("0x" .. _arg1:sub (1, 2))/255
				else
					_arg1, _arg2, _arg3, _arg4 = tn ("0x" .. _arg1:sub (1, 2))/255, tn ("0x" .. _arg1:sub (3, 4))/255, tn ("0x" .. _arg1:sub (5, 6))/255, 1
				end
			
			else
				local color = DF.alias_text_colors [_arg1]
				if (color) then
					_arg1, _arg2, _arg3, _arg4 = _unpack (color)
				else
					_arg1, _arg2, _arg3, _arg4 = _unpack (DF.alias_text_colors.none)
				end
			end
		end
		
		if (not _arg1) then
			_arg1 = 1
		end
		if (not _arg2) then
			_arg2 = 1
		end
		if (not _arg3) then
			_arg3 = 1
		end
		if (not _arg4) then
			_arg4 = 1
		end
		
		return _arg1, _arg2, _arg3, _arg4
	end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> menus
	
	local disable_on_combat = {}
	
	function DF:BuildMenu (parent, menu, x_offset, y_offset, height, use_two_points, text_template, dropdown_template, switch_template, switch_is_box, slider_template, button_template)
		
		if (not parent.widget_list) then
			DF:SetAsOptionsPanel (parent)
		end
		
		local cur_x = x_offset
		local cur_y = y_offset
		local max_x = 0
		
		height = abs ((height or parent:GetHeight()) - abs (y_offset) + 20)
		height = height*-1
		
		for index, widget_table in ipairs (menu) do 
		
			local widget_created
		
			if (widget_table.type == "blank" or widget_table.type == "space") then
				-- do nothing
		
			elseif (widget_table.type == "label" or widget_table.type == "text") then
				local label = DF:CreateLabel (parent, widget_table.get() or widget_table.text, widget_table.text_template or text_template or widget_table.size, widget_table.color, widget_table.font, nil, "$parentWidget" .. index, "overlay")
				label._get = widget_table.get
				label.widget_type = "label"
				label:SetPoint (cur_x, cur_y)
				tinsert (parent.widget_list, label)
			
			elseif (widget_table.type == "select" or widget_table.type == "dropdown") then
				local dropdown = DF:NewDropDown (parent, nil, "$parentWidget" .. index, nil, 140, 18, widget_table.values, widget_table.get(), dropdown_template)
				dropdown.tooltip = widget_table.desc
				dropdown._get = widget_table.get
				dropdown.widget_type = "select"
				local label = DF:NewLabel (parent, nil, "$parentLabel" .. index, nil, widget_table.name .. (use_two_points and ": " or ""), "GameFontNormal", widget_table.text_template or text_template or 12)
				dropdown:SetPoint ("left", label, "right", 2)
				label:SetPoint (cur_x, cur_y)
				
				local size = label.widget:GetStringWidth() + 140 + 4
				if (size > max_x) then
					max_x = size
				end
				
				tinsert (parent.widget_list, dropdown)
				widget_created = dropdown
				
			elseif (widget_table.type == "toggle" or widget_table.type == "switch") then
				local switch = DF:NewSwitch (parent, nil, "$parentWidget" .. index, nil, 60, 20, nil, nil, widget_table.get(), nil, nil, nil, nil, switch_template)
				switch.tooltip = widget_table.desc
				switch._get = widget_table.get
				switch.widget_type = "toggle"
				switch.OnSwitch = widget_table.set
				
				if (switch_is_box) then
					switch:SetAsCheckBox()
				end
				
				local label = DF:NewLabel (parent, nil, "$parentLabel" .. index, nil, widget_table.name .. (use_two_points and ": " or ""), "GameFontNormal", widget_table.text_template or text_template or 12)
				switch:SetPoint ("left", label, "right", 2)
				label:SetPoint (cur_x, cur_y)
				
				local size = label.widget:GetStringWidth() + 60 + 4
				if (size > max_x) then
					max_x = size
				end
				
				tinsert (parent.widget_list, switch)
				widget_created = switch
				
			elseif (widget_table.type == "range" or widget_table.type == "slider") then
				local is_decimanls = widget_table.usedecimals
				local slider = DF:NewSlider (parent, nil, "$parentWidget" .. index, nil, 140, 20, widget_table.min, widget_table.max, widget_table.step, widget_table.get(),  is_decimanls, nil, nil, slider_template)
				slider.tooltip = widget_table.desc
				slider._get = widget_table.get
				slider.widget_type = "range"
				slider:SetHook ("OnValueChange", widget_table.set)
				
				if (widget_table.thumbscale) then
					slider:SetThumbSize (slider.thumb:GetWidth()*widget_table.thumbscale, nil)
				end
				
				local label = DF:NewLabel (parent, nil, "$parentLabel" .. index, nil, widget_table.name .. (use_two_points and ": " or ""), "GameFontNormal", widget_table.text_template or text_template or 12)
				slider:SetPoint ("left", label, "right", 2)
				label:SetPoint (cur_x, cur_y)
				
				local size = label.widget:GetStringWidth() + 140 + 6
				if (size > max_x) then
					max_x = size
				end
				
				tinsert (parent.widget_list, slider)
				widget_created = slider
				
			elseif (widget_table.type == "color" or widget_table.type == "color") then
				local colorpick = DF:NewColorPickButton (parent, "$parentWidget" .. index, nil, widget_table.set, nil, button_template)
				colorpick.tooltip = widget_table.desc
				colorpick._get = widget_table.get
				colorpick.widget_type = "color"

				local default_value, g, b, a = widget_table.get()
				if (type (default_value) == "table") then
					colorpick:SetColor (unpack (default_value))
				else
					colorpick:SetColor (default_value, g, b, a)
				end
				
				local label = DF:NewLabel (parent, nil, "$parentLabel" .. index, nil, widget_table.name .. (use_two_points and ": " or ""), "GameFontNormal", widget_table.text_template or text_template or 12)
				colorpick:SetPoint ("left", label, "right", 2)
				label:SetPoint (cur_x, cur_y)
				
				local size = label.widget:GetStringWidth() + 60 + 4
				if (size > max_x) then
					max_x = size
				end
				
				tinsert (parent.widget_list, colorpick)
				widget_created = colorpick
				
			elseif (widget_table.type == "execute" or widget_table.type == "button") then
			
				local button = DF:NewButton (parent, nil, "$parentWidget" .. index, nil, 120, 18, widget_table.func, widget_table.param1, widget_table.param2, nil, widget_table.name, nil, button_template, text_template)
				if (not button_template) then
					button:InstallCustomTexture()
				end

				button:SetPoint (cur_x, cur_y)
				button.tooltip = widget_table.desc
				button.widget_type = "execute"
				
				local size = button:GetWidth() + 4
				if (size > max_x) then
					max_x = size
				end
				
				tinsert (parent.widget_list, button)
				widget_created = button
				
				
			elseif (widget_table.type == "textentry") then
				local textentry = DF:CreateTextEntry (parent, widget_table.func, 120, 18, nil, "$parentWidget" .. index, nil, button_template)
				textentry.tooltip = widget_table.desc
				textentry.text = widget_table.get()
				textentry._get = widget_table.get
				textentry.widget_type = "textentry"
				textentry:SetHook ("OnEnterPressed", widget_table.set)
				textentry:SetHook ("OnEditFocusLost", widget_table.set)

				local label = DF:NewLabel (parent, nil, "$parentLabel" .. index, nil, widget_table.name .. (use_two_points and ": " or ""), "GameFontNormal", widget_table.text_template or text_template or 12)
				textentry:SetPoint ("left", label, "right", 2)
				label:SetPoint (cur_x, cur_y)

				local size = label.widget:GetStringWidth() + 60 + 4
				if (size > max_x) then
					max_x = size
				end
				
				tinsert (parent.widget_list, textentry)
				widget_created = textentry
				
			end
			
			if (widget_table.nocombat) then
				tinsert (disable_on_combat, widget_created)
			end
		
			if (widget_table.spacement) then
				cur_y = cur_y - 30
			else
				cur_y = cur_y - 20
			end
			
			if (widget_table.type == "breakline" or cur_y < height) then
				cur_y = y_offset
				cur_x = cur_x + max_x + 30
				max_x = 0
			end
		
		end
		
		DF.RefreshUnsafeOptionsWidgets()
		
	end
	
	local lock_notsafe_widgets = function()
		for _, widget in ipairs (disable_on_combat) do
			widget:Disable()
		end
	end
	local unlock_notsafe_widgets = function()
		for _, widget in ipairs (disable_on_combat) do
			widget:Enable()
		end
	end
	function DF.RefreshUnsafeOptionsWidgets()
		if (DF.PlayerHasCombatFlag) then
			lock_notsafe_widgets()
		else
			unlock_notsafe_widgets()
		end
	end
	DF.PlayerHasCombatFlag = false
	local ProtectCombatFrame = CreateFrame ("frame")
	ProtectCombatFrame:RegisterEvent ("PLAYER_REGEN_ENABLED")
	ProtectCombatFrame:RegisterEvent ("PLAYER_REGEN_DISABLED")
	ProtectCombatFrame:RegisterEvent ("PLAYER_ENTERING_WORLD")
	ProtectCombatFrame:SetScript ("OnEvent", function (self, event)
		if (event == "PLAYER_ENTERING_WORLD") then
			if (InCombatLockdown()) then
				DF.PlayerHasCombatFlag = true
			else
				DF.PlayerHasCombatFlag = false
			end
			DF.RefreshUnsafeOptionsWidgets()
			
		elseif (event == "PLAYER_REGEN_ENABLED") then
			DF.PlayerHasCombatFlag = false
			DF.RefreshUnsafeOptionsWidgets()
			
		elseif (event == "PLAYER_REGEN_DISABLED") then
			DF.PlayerHasCombatFlag = true
			DF.RefreshUnsafeOptionsWidgets()
			
		end
	end)
	
	function DF:CreateInCombatTexture (frame)
		if (DF.debug and not frame) then
			error ("Details! Framework: CreateInCombatTexture invalid frame on parameter 1.")
		end
	
		local in_combat_background = DF:CreateImage (frame)
		in_combat_background:SetColorTexture (.6, 0, 0, .1)
		in_combat_background:Hide()

		local in_combat_label = Plater:CreateLabel (frame, "you are in combat", 24, "silver")
		in_combat_label:SetPoint ("right", in_combat_background, "right", -10, 0)
		in_combat_label:Hide()

		frame:RegisterEvent ("PLAYER_REGEN_DISABLED")
		frame:RegisterEvent ("PLAYER_REGEN_ENABLED")
		frame:SetScript ("OnEvent", function (self, event)
			if (event == "PLAYER_REGEN_DISABLED") then
				in_combat_background:Show()
				in_combat_label:Show()
			elseif (event == "PLAYER_REGEN_ENABLED") then
				in_combat_background:Hide()
				in_combat_label:Hide()
			end
		end)
		
		return in_combat_background
	end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> tutorials
	
	function DF:ShowTutorialAlertFrame (maintext, desctext, clickfunc)
		
		local TutorialAlertFrame = _G.DetailsFrameworkTutorialAlertFrame
		
		if (not TutorialAlertFrame) then
			
			TutorialAlertFrame = CreateFrame ("ScrollFrame", "DetailsFrameworkTutorialAlertFrame", UIParent, "DetailsFrameworkTutorialAlertFrameTemplate")
			TutorialAlertFrame.isFirst = true
			TutorialAlertFrame:SetPoint ("left", UIParent, "left", -20, 100)
			
			TutorialAlertFrame:SetWidth (290)
			TutorialAlertFrame.ScrollChild:SetWidth (256)
			
			local scrollname = TutorialAlertFrame.ScrollChild:GetName()
			_G [scrollname .. "BorderTopLeft"]:SetVertexColor (1, 0.8, 0, 1)
			_G [scrollname .. "BorderTopRight"]:SetVertexColor (1, 0.8, 0, 1)
			_G [scrollname .. "BorderBotLeft"]:SetVertexColor (1, 0.8, 0, 1)
			_G [scrollname .. "BorderBotRight"]:SetVertexColor (1, 0.8, 0, 1)	
			_G [scrollname .. "BorderLeft"]:SetVertexColor (1, 0.8, 0, 1)
			_G [scrollname .. "BorderRight"]:SetVertexColor (1, 0.8, 0, 1)
			_G [scrollname .. "BorderBottom"]:SetVertexColor (1, 0.8, 0, 1)
			_G [scrollname .. "BorderTop"]:SetVertexColor (1, 0.8, 0, 1)
			
			local iconbg = _G [scrollname .. "QuestIconBg"]
			iconbg:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
			iconbg:SetTexCoord (0, 1, 0, 1)
			iconbg:SetSize (100, 100)
			iconbg:ClearAllPoints()
			iconbg:SetPoint ("bottomleft", TutorialAlertFrame.ScrollChild, "bottomleft")
			
			_G [scrollname .. "Exclamation"]:SetVertexColor (1, 0.8, 0, 1)
			_G [scrollname .. "QuestionMark"]:SetVertexColor (1, 0.8, 0, 1)
			
			_G [scrollname .. "TopText"]:SetText ("Details!") --string
			_G [scrollname .. "QuestName"]:SetText ("") --string
			_G [scrollname .. "BottomText"]:SetText ("") --string
			
			TutorialAlertFrame.ScrollChild.IconShine:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
			
			TutorialAlertFrame:SetScript ("OnMouseUp", function (self) 
				if (self.clickfunc and type (self.clickfunc) == "function") then
					self.clickfunc()
				end
				self:Hide()
			end)
			TutorialAlertFrame:Hide()
		end
		
		if (type (maintext) == "string") then
			TutorialAlertFrame.ScrollChild.QuestName:SetText (maintext)
		else
			TutorialAlertFrame.ScrollChild.QuestName:SetText ("")
		end
		
		if (type (desctext) == "string") then
			TutorialAlertFrame.ScrollChild.BottomText:SetText (desctext)
		else
			TutorialAlertFrame.ScrollChild.BottomText:SetText ("")
		end
		
		TutorialAlertFrame.clickfunc = clickfunc
		TutorialAlertFrame:Show()
		DetailsTutorialAlertFrame_SlideInFrame (TutorialAlertFrame, "AUTOQUEST")
	end
	
	local refresh_options = function (self)
		for _, widget in ipairs (self.widget_list) do
			if (widget._get) then
				if (widget.widget_type == "label") then
					if (widget._get()) then
						widget:SetText (widget._get())
					end
				elseif (widget.widget_type == "select") then
					widget:Select (widget._get())
				elseif (widget.widget_type == "toggle" or widget.widget_type == "range") then
					widget:SetValue (widget._get())
				elseif (widget.widget_type == "textentry") then
					widget:SetText (widget._get())
				elseif (widget.widget_type == "color") then
					local default_value, g, b, a = widget._get()
					if (type (default_value) == "table") then
						widget:SetColor (unpack (default_value))
					else
						widget:SetColor (default_value, g, b, a)
					end
				end
			end
		end
	end
	
	function DF:SetAsOptionsPanel (frame)
		frame.RefreshOptions = refresh_options
		frame.widget_list = {}
	end
	
	function DF:CreateOptionsFrame (name, title, template)
	
		template = template or 1
	
		if (template == 2) then
			local options_frame = CreateFrame ("frame", name, UIParent, "ButtonFrameTemplate")
			tinsert (UISpecialFrames, name)
			options_frame:SetSize (500, 200)
			options_frame.RefreshOptions = refresh_options
			options_frame.widget_list = {}
			
			options_frame:SetScript ("OnMouseDown", function(self, button)
				if (button == "RightButton") then
					if (self.moving) then 
						self.moving = false
						self:StopMovingOrSizing()
					end
					return options_frame:Hide()
				elseif (button == "LeftButton" and not self.moving) then
					self.moving = true
					self:StartMoving()
				end
			end)
			options_frame:SetScript ("OnMouseUp", function(self)
				if (self.moving) then 
					self.moving = false
					self:StopMovingOrSizing()
				end
			end)
			
			options_frame:SetMovable (true)
			options_frame:EnableMouse (true)
			options_frame:SetFrameStrata ("DIALOG")
			options_frame:SetToplevel (true)
			
			options_frame:Hide()
			
			options_frame:SetPoint ("center", UIParent, "center")
			options_frame.TitleText:SetText (title)
			options_frame.portrait:SetTexture ([[Interface\CHARACTERFRAME\TEMPORARYPORTRAIT-FEMALE-BLOODELF]])
			
			return options_frame
	
		elseif (template == 1) then
		
			local options_frame = CreateFrame ("frame", name, UIParent)
			tinsert (UISpecialFrames, name)
			options_frame:SetSize (500, 200)
			options_frame.RefreshOptions = refresh_options
			options_frame.widget_list = {}

			options_frame:SetScript ("OnMouseDown", function(self, button)
				if (button == "RightButton") then
					if (self.moving) then 
						self.moving = false
						self:StopMovingOrSizing()
					end
					return options_frame:Hide()
				elseif (button == "LeftButton" and not self.moving) then
					self.moving = true
					self:StartMoving()
				end
			end)
			options_frame:SetScript ("OnMouseUp", function(self)
				if (self.moving) then 
					self.moving = false
					self:StopMovingOrSizing()
				end
			end)
			
			options_frame:SetMovable (true)
			options_frame:EnableMouse (true)
			options_frame:SetFrameStrata ("DIALOG")
			options_frame:SetToplevel (true)
			
			options_frame:Hide()
			
			options_frame:SetPoint ("center", UIParent, "center")
			
			options_frame:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
			edgeFile = DF.folder ..  "border_2", edgeSize = 32,
			insets = {left = 1, right = 1, top = 1, bottom = 1}})
			options_frame:SetBackdropColor (0, 0, 0, .7)

			local texturetitle = options_frame:CreateTexture (nil, "artwork")
			texturetitle:SetTexture ([[Interface\CURSOR\Interact]])
			texturetitle:SetTexCoord (0, 1, 0, 1)
			texturetitle:SetVertexColor (1, 1, 1, 1)
			texturetitle:SetPoint ("topleft", options_frame, "topleft", 2, -3)
			texturetitle:SetWidth (36)
			texturetitle:SetHeight (36)
			
			local title = DF:NewLabel (options_frame, nil, "$parentTitle", nil, title, nil, 20, "yellow")
			title:SetPoint ("left", texturetitle, "right", 2, -1)
			DF:SetFontOutline (title, true)

			local c = CreateFrame ("Button", nil, options_frame, "UIPanelCloseButton")
			c:SetWidth (32)
			c:SetHeight (32)
			c:SetPoint ("TOPRIGHT",  options_frame, "TOPRIGHT", -3, -3)
			c:SetFrameLevel (options_frame:GetFrameLevel()+1)
			
			return options_frame
		end
	end	
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> templates

DF.font_templates = {}
DF.font_templates ["ORANGE_FONT_TEMPLATE"] = {color = "orange", size = 11, font = "Accidental Presidency"}
DF.font_templates ["OPTIONS_FONT_TEMPLATE"] = {color = "yellow", size = 12, font = "Accidental Presidency"}

DF.dropdown_templates = {}
DF.dropdown_templates ["OPTIONS_DROPDOWN_TEMPLATE"] = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdropcolor = {1, 1, 1, .5},
	backdropbordercolor = {0, 0, 0, 1},
	onentercolor = {1, 1, 1, .5},
	onenterbordercolor = {1, 1, 1, 1},
}

DF.switch_templates = {}
DF.switch_templates ["OPTIONS_CHECKBOX_TEMPLATE"] = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdropcolor = {1, 1, 1, .5},
	backdropbordercolor = {0, 0, 0, 1},
	width = 18,
	height = 18,
	enabled_backdropcolor = {1, 1, 1, .5},
	disabled_backdropcolor = {1, 1, 1, .2},
	onenterbordercolor = {1, 1, 1, 1},
}
DF.switch_templates ["OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"] = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdropcolor = {1, 1, 1, .5},
	backdropbordercolor = {0, 0, 0, 1},
	width = 18,
	height = 18,
	enabled_backdropcolor = {1, 1, 1, .5},
	disabled_backdropcolor = {1, 1, 1, .5},
	onenterbordercolor = {1, 1, 1, 1},
}

DF.button_templates = {}
DF.button_templates ["OPTIONS_BUTTON_TEMPLATE"] = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdropcolor = {1, 1, 1, .5},
	backdropbordercolor = {0, 0, 0, 1},
}

DF.slider_templates = {}
DF.slider_templates ["OPTIONS_SLIDER_TEMPLATE"] = {
	backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
	backdropcolor = {1, 1, 1, .5},
	backdropbordercolor = {0, 0, 0, 1},
	onentercolor = {1, 1, 1, .5},
	onenterbordercolor = {1, 1, 1, 1},
	thumbtexture = [[Interface\Tooltips\UI-Tooltip-Background]],
	thumbwidth = 16,
	thumbheight = 14,
	thumbcolor = {0, 0, 0, 0.5},
}

function DF:InstallTemplate (widget_type, template_name, template, parent_name)

	local newTemplate = {}
	
	--if has a parent, just copy the parent to the new template
	if (parent_name and type (parent_name) == "string") then
		local parentTemplate = DF:GetTemplate (widget_type, parent_name)
		if (parentTemplate) then
			DF.table.copy (newTemplate, parentTemplate)
		end
	end
	
	--copy the template passed into the new template
	DF.table.copy (newTemplate, template)

	widget_type = string.lower (widget_type)
	
	local template_table
	if (widget_type == "font") then
		template_table = DF.font_templates
	elseif (widget_type == "dropdown") then
		template_table = DF.dropdown_templates
	elseif (widget_type == "button") then
		template_table = DF.button_templates
	elseif (widget_type == "switch") then
		template_table = DF.switch_templates
	elseif (widget_type == "slider") then
		template_table = DF.slider_templates
	end

	template_table [template_name] = newTemplate
	
	return newTemplate
end

function DF:GetTemplate (widget_type, template_name)
	widget_type = string.lower (widget_type)

	local template_table
	if (widget_type == "font") then
		template_table = DF.font_templates
	elseif (widget_type == "dropdown") then
		template_table = DF.dropdown_templates
	elseif (widget_type == "button") then
		template_table = DF.button_templates
	elseif (widget_type == "switch") then
		template_table = DF.switch_templates
	elseif (widget_type == "slider") then
		template_table = DF.slider_templates
	end
	return template_table [template_name]
end

function DF.GetParentName (frame)
	local parentName = frame:GetName()
	if (not parentName) then
		error ("Details! FrameWork: called $parent but parent was no name.", 2)
	end
	return parentName
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> widget scripts and hooks

function DF:RunHooksForWidget (event, ...)
	local hooks = self.HookList [event]
	
	if (not hooks) then
		print (self.widget:GetName(), "sem hook para", event)
		return
	end
	
	for i, func in ipairs (hooks) do
		local success, canInterrupt = pcall (func, ...)
		if (not success) then
			error ("Details! Framework: " .. event .. " hook for " .. self:GetName() .. ": " .. canInterrupt)
		elseif (canInterrupt) then
			return true
		end
	end
end

function DF:SetHook (hookType, func)
	if (self.HookList [hookType]) then
		if (type (func) == "function") then
			local isRemoval = false
			for i = #self.HookList [hookType], 1, -1 do
				if (self.HookList [hookType] [i] == func) then
					tremove (self.HookList [hookType], i)
					isRemoval = true
					break
				end
			end
			if (not isRemoval) then
				tinsert (self.HookList [hookType], func)
			end
		else 
			if (DF.debug) then
				error ("Details! Framework: invalid function for widget " .. self.WidgetType .. ".")
			end
		end
	else
		if (DF.debug) then
			error ("Details! Framework: unknown hook type for widget " .. self.WidgetType .. ": '" .. hookType .. "'.")
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> members

DF.GlobalWidgetControlNames = {
	textentry = "DF_TextEntryMetaFunctions",
	button = "DF_ButtonMetaFunctions",
	panel = "DF_PanelMetaFunctions",
	dropdown = "DF_DropdownMetaFunctions",
	label = "DF_LabelMetaFunctions",
	normal_bar = "DF_NormalBarMetaFunctions",
	image = "DF_ImageMetaFunctions",
	slider = "DF_SliderMetaFunctions",
	split_bar = "DF_SplitBarMetaFunctions",
	aura_tracker = "DF_AuraTracker",
}

function DF:AddMemberForWidget (widgetName, memberType, memberName, func)
	if (DF.GlobalWidgetControlNames [widgetName]) then
		if (type (memberName) == "string" and (memberType == "SET" or memberType == "GET")) then
			if (func) then
				local widgetControlObject = _G [DF.GlobalWidgetControlNames [widgetName]]
				
				if (memberType == "SET") then
					widgetControlObject ["SetMembers"] [memberName] = func
				elseif (memberType == "GET") then
					widgetControlObject ["GetMembers"] [memberName] = func
				end
			else
				if (DF.debug) then
					error ("Details! Framework: AddMemberForWidget invalid function.")
				end
			end
		else
			if (DF.debug) then
				error ("Details! Framework: AddMemberForWidget unknown memberName or memberType.")
			end
		end
	else
		if (DF.debug) then
			error ("Details! Framework: AddMemberForWidget unknown widget type: " .. (widgetName or "") .. ".")
		end
	end
end

-----------------------------

function DF:OpenInterfaceProfile()
	InterfaceOptionsFrame_OpenToCategory (self.__name)
	InterfaceOptionsFrame_OpenToCategory (self.__name)
	for i = 1, 100 do
		local button = _G ["InterfaceOptionsFrameAddOnsButton" .. i]
		if (button) then
			local text = _G ["InterfaceOptionsFrameAddOnsButton" .. i .. "Text"]
			if (text) then
				text = text:GetText()
				if (text == self.__name) then
					local toggle = _G ["InterfaceOptionsFrameAddOnsButton" .. i .. "Toggle"]
					if (toggle) then
						if (toggle:GetNormalTexture():GetTexture():find ("PlusButton")) then
							--is minimized, need expand
							toggle:Click()
							_G ["InterfaceOptionsFrameAddOnsButton" .. i+1]:Click()
						elseif (toggle:GetNormalTexture():GetTexture():find ("MinusButton")) then
							--isn't minimized
							_G ["InterfaceOptionsFrameAddOnsButton" .. i+1]:Click()
						end
					end
					break
				end
			end
		else
			self:Msg ("Couldn't not find the profile panel.")
			break
		end
	end
end

-----------------------------
--safe copy from blizz api
function DF:Mixin (object, ...)
	for i = 1, select("#", ...) do
		local mixin = select(i, ...);
		for k, v in pairs(mixin) do
			object[k] = v;
		end
	end

	return object;
end

-----------------------------
--> animations

function DF:CreateAnimationHub (parent, onPlay, onFinished)
	local newAnimation = parent:CreateAnimationGroup()
	newAnimation:SetScript ("OnPlay", onPlay)
	newAnimation:SetScript ("OnFinished", onFinished)
	newAnimation.NextAnimation = 1
	return newAnimation
end

function DF:CreateAnimation (animation, type, order, duration, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local anim = animation:CreateAnimation (type)
	
	anim:SetOrder (order or animation.NextAnimation)
	anim:SetDuration (duration)
	
	type = string.upper (type)
	
	if (type == "ALPHA") then
		anim:SetFromAlpha (arg1)
		anim:SetToAlpha (arg2)
	
	elseif (type == "SCALE") then
		anim:SetFromScale (arg1, arg2)
		anim:SetToScale (arg3, arg4)
		anim:SetOrigin (arg5 or "center", arg6 or 0, arg7 or 0) --point, x, y
	
	elseif (type == "ROTATION") then
		anim:SetDegrees (arg1) --degree
		anim:SetOrigin (arg2 or "center", arg3 or 0, arg4 or 0) --point, x, y
		
	elseif (type == "TRANSLATION") then
		anim:SetOffset (arg1, arg2)
		
	end
	
	animation.NextAnimation = animation.NextAnimation + 1	
	return anim
end


-----------------------------
--> borders

local default_border_color1 = .5
local default_border_color2 = .3
local default_border_color3 = .1

local SetBorderAlpha = function (self, alpha1, alpha2, alpha3)
	self.Borders.Alpha1 = alpha1 or self.Borders.Alpha1
	self.Borders.Alpha2 = alpha2 or self.Borders.Alpha2
	self.Borders.Alpha3 = alpha3 or self.Borders.Alpha3
	
	for _, texture in ipairs (self.Borders.Layer1) do
		texture:SetAlpha (self.Borders.Alpha1)
	end
	for _, texture in ipairs (self.Borders.Layer2) do
		texture:SetAlpha (self.Borders.Alpha2)
	end
	for _, texture in ipairs (self.Borders.Layer3) do
		texture:SetAlpha (self.Borders.Alpha3)
	end
end

function DF:CreateBorder (parent, alpha1, alpha2, alpha3)
	
	parent.Borders = {
		Layer1 = {},
		Layer2 = {},
		Layer3 = {},
		Alpha1 = alpha1 or default_border_color1,
		Alpha2 = alpha2 or default_border_color2,
		Alpha3 = alpha3 or default_border_color3,
	}
	
	parent.SetBorderAlpha = SetBorderAlpha
	
	local border1 = parent:CreateTexture (nil, "background")
	border1:SetPoint ("topleft", parent, "topleft", -1, 1)
	border1:SetPoint ("bottomleft", parent, "bottomleft", -1, -1)
	border1:SetColorTexture (0, 0, 0, alpha1 or default_border_color1)
	local border2 = parent:CreateTexture (nil, "background")
	border2:SetPoint ("topleft", parent, "topleft", -2, 2)
	border2:SetPoint ("bottomleft", parent, "bottomleft", -2, -2)
	border2:SetColorTexture (0, 0, 0, alpha2 or default_border_color2)
	local border3 = parent:CreateTexture (nil, "background")
	border3:SetPoint ("topleft", parent, "topleft", -3, 3)
	border3:SetPoint ("bottomleft", parent, "bottomleft", -3, -3)
	border3:SetColorTexture (0, 0, 0, alpha3 or default_border_color3)
	
	tinsert (parent.Borders.Layer1, border1)
	tinsert (parent.Borders.Layer2, border2)
	tinsert (parent.Borders.Layer3, border3)
	
	local border1 = parent:CreateTexture (nil, "background")
	border1:SetPoint ("topleft", parent, "topleft", 0, 1)
	border1:SetPoint ("topright", parent, "topright", 1, 1)
	border1:SetColorTexture (0, 0, 0, alpha1 or default_border_color1)
	local border2 = parent:CreateTexture (nil, "background")
	border2:SetPoint ("topleft", parent, "topleft", -1, 2)
	border2:SetPoint ("topright", parent, "topright", 2, 2)
	border2:SetColorTexture (0, 0, 0, alpha2 or default_border_color2)
	local border3 = parent:CreateTexture (nil, "background")
	border3:SetPoint ("topleft", parent, "topleft", -2, 3)
	border3:SetPoint ("topright", parent, "topright", 3, 3)
	border3:SetColorTexture (0, 0, 0, alpha3 or default_border_color3)
	
	tinsert (parent.Borders.Layer1, border1)
	tinsert (parent.Borders.Layer2, border2)
	tinsert (parent.Borders.Layer3, border3)	
	
	local border1 = parent:CreateTexture (nil, "background")
	border1:SetPoint ("topright", parent, "topright", 1, 0)
	border1:SetPoint ("bottomright", parent, "bottomright", 1, -1)
	border1:SetColorTexture (0, 0, 0, alpha1 or default_border_color1)
	local border2 = parent:CreateTexture (nil, "background")
	border2:SetPoint ("topright", parent, "topright", 2, 1)
	border2:SetPoint ("bottomright", parent, "bottomright", 2, -2)
	border2:SetColorTexture (0, 0, 0, alpha2 or default_border_color2)
	local border3 = parent:CreateTexture (nil, "background")
	border3:SetPoint ("topright", parent, "topright", 3, 2)
	border3:SetPoint ("bottomright", parent, "bottomright", 3, -3)
	border3:SetColorTexture (0, 0, 0, alpha3 or default_border_color3)
	
	tinsert (parent.Borders.Layer1, border1)
	tinsert (parent.Borders.Layer2, border2)
	tinsert (parent.Borders.Layer3, border3)	
	
	local border1 = parent:CreateTexture (nil, "background")
	border1:SetPoint ("bottomleft", parent, "bottomleft", 0, -1)
	border1:SetPoint ("bottomright", parent, "bottomright", 0, -1)
	border1:SetColorTexture (0, 0, 0, alpha1 or default_border_color1)
	local border2 = parent:CreateTexture (nil, "background")
	border2:SetPoint ("bottomleft", parent, "bottomleft", -1, -2)
	border2:SetPoint ("bottomright", parent, "bottomright", 1, -2)
	border2:SetColorTexture (0, 0, 0, alpha2 or default_border_color2)
	local border3 = parent:CreateTexture (nil, "background")
	border3:SetPoint ("bottomleft", parent, "bottomleft", -2, -3)
	border3:SetPoint ("bottomright", parent, "bottomright", 2, -3)
	border3:SetColorTexture (0, 0, 0, alpha3 or default_border_color3)
	
	tinsert (parent.Borders.Layer1, border1)
	tinsert (parent.Borders.Layer2, border2)
	tinsert (parent.Borders.Layer3, border3)
	
end

function DF:ReskinSlider (slider, heightOffset)
	if (slider.slider) then
		slider.cima:SetNormalTexture ([[Interface\Buttons\Arrow-Up-Up]])
		slider.cima:SetPushedTexture ([[Interface\Buttons\Arrow-Up-Down]])
		slider.cima:SetDisabledTexture ([[Interface\Buttons\Arrow-Up-Disabled]])
		slider.cima:GetNormalTexture():ClearAllPoints()
		slider.cima:GetPushedTexture():ClearAllPoints()
		slider.cima:GetDisabledTexture():ClearAllPoints()
		slider.cima:GetNormalTexture():SetPoint ("center", slider.cima, "center", 1, 1)
		slider.cima:GetPushedTexture():SetPoint ("center", slider.cima, "center", 1, 1)
		slider.cima:GetDisabledTexture():SetPoint ("center", slider.cima, "center", 1, 1)
		slider.cima:SetSize (16, 16)
		slider.cima:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
		slider.cima:SetBackdropColor (0, 0, 0, 0.3)
		slider.cima:SetBackdropBorderColor (0, 0, 0, 1)
		
		slider.baixo:SetNormalTexture ([[Interface\Buttons\Arrow-Down-Up]])
		slider.baixo:SetPushedTexture ([[Interface\Buttons\Arrow-Down-Down]])
		slider.baixo:SetDisabledTexture ([[Interface\Buttons\Arrow-Down-Disabled]])
		slider.baixo:GetNormalTexture():ClearAllPoints()
		slider.baixo:GetPushedTexture():ClearAllPoints()
		slider.baixo:GetDisabledTexture():ClearAllPoints()
		slider.baixo:GetNormalTexture():SetPoint ("center", slider.baixo, "center", 1, -5)
		slider.baixo:GetPushedTexture():SetPoint ("center", slider.baixo, "center", 1, -5)
		slider.baixo:GetDisabledTexture():SetPoint ("center", slider.baixo, "center", 1, -5)
		slider.baixo:SetSize (16, 16)
		slider.baixo:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
		slider.baixo:SetBackdropColor (0, 0, 0, 0.35)
		slider.baixo:SetBackdropBorderColor (0, 0, 0, 1)
		
		slider.slider:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
		slider.slider:SetBackdropColor (0, 0, 0, 0.35)
		slider.slider:SetBackdropBorderColor (0, 0, 0, 1)
		
		--slider.slider:Altura (164)
		slider.slider:cimaPoint (0, 13)
		slider.slider:baixoPoint (0, -13)
		slider.slider.thumb:SetTexture ([[Interface\AddOns\Details\images\icons2]])
		slider.slider.thumb:SetTexCoord (482/512, 492/512, 104/512, 120/512)
		slider.slider.thumb:SetSize (12, 12)
		slider.slider.thumb:SetVertexColor (0.6, 0.6, 0.6, 0.95)
	else

		slider.ScrollBar.ScrollUpButton:SetNormalTexture ([[Interface\Buttons\Arrow-Up-Up]])
		slider.ScrollBar.ScrollUpButton:GetNormalTexture():SetTexCoord (0, 1, 0, 1)
		slider.ScrollBar.ScrollUpButton:SetPushedTexture ([[Interface\Buttons\Arrow-Up-Down]])
		slider.ScrollBar.ScrollUpButton:GetPushedTexture():SetTexCoord (0, 1, 0, 1)
		slider.ScrollBar.ScrollUpButton:SetDisabledTexture ([[Interface\Buttons\Arrow-Up-Disabled]])
		slider.ScrollBar.ScrollUpButton:GetDisabledTexture():SetTexCoord (0, 1, 0, 1)

		slider.ScrollBar.ScrollUpButton:SetSize (16, 16)
		slider.ScrollBar.ScrollUpButton:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
		slider.ScrollBar.ScrollUpButton:SetBackdropColor (0, 0, 0, 0.3)
		slider.ScrollBar.ScrollUpButton:SetBackdropBorderColor (0, 0, 0, 1)

		slider.ScrollBar.ScrollUpButton:GetNormalTexture():ClearAllPoints()
		slider.ScrollBar.ScrollUpButton:GetPushedTexture():ClearAllPoints()
		slider.ScrollBar.ScrollUpButton:GetDisabledTexture():ClearAllPoints()
		slider.ScrollBar.ScrollUpButton:GetNormalTexture():SetPoint ("center", slider.ScrollBar.ScrollUpButton, "center", 1, 1)
		slider.ScrollBar.ScrollUpButton:GetPushedTexture():SetPoint ("center", slider.ScrollBar.ScrollUpButton, "center", 1, 1)
		slider.ScrollBar.ScrollUpButton:GetDisabledTexture():SetPoint ("center", slider.ScrollBar.ScrollUpButton, "center", 1, 1)
	
		--
		
		slider.ScrollBar.ScrollDownButton:SetNormalTexture ([[Interface\Buttons\Arrow-Down-Up]])
		slider.ScrollBar.ScrollDownButton:GetNormalTexture():SetTexCoord (0, 1, 0, 1)
		slider.ScrollBar.ScrollDownButton:SetPushedTexture ([[Interface\Buttons\Arrow-Down-Down]])
		slider.ScrollBar.ScrollDownButton:GetPushedTexture():SetTexCoord (0, 1, 0, 1)
		slider.ScrollBar.ScrollDownButton:SetDisabledTexture ([[Interface\Buttons\Arrow-Down-Disabled]])
		slider.ScrollBar.ScrollDownButton:GetDisabledTexture():SetTexCoord (0, 1, 0, 1)
		
		slider.ScrollBar.ScrollDownButton:SetSize (16, 16)
		slider.ScrollBar.ScrollDownButton:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
		slider.ScrollBar.ScrollDownButton:SetBackdropColor (0, 0, 0, 0.3)
		slider.ScrollBar.ScrollDownButton:SetBackdropBorderColor (0, 0, 0, 1)
	
		slider.ScrollBar.ScrollDownButton:GetNormalTexture():ClearAllPoints()
		slider.ScrollBar.ScrollDownButton:GetPushedTexture():ClearAllPoints()
		slider.ScrollBar.ScrollDownButton:GetDisabledTexture():ClearAllPoints()
		slider.ScrollBar.ScrollDownButton:GetNormalTexture():SetPoint ("center", slider.ScrollBar.ScrollDownButton, "center", 1, -5)
		slider.ScrollBar.ScrollDownButton:GetPushedTexture():SetPoint ("center", slider.ScrollBar.ScrollDownButton, "center", 1, -5)
		slider.ScrollBar.ScrollDownButton:GetDisabledTexture():SetPoint ("center", slider.ScrollBar.ScrollDownButton, "center", 1, -5)
	
		--
		slider.ScrollBar:SetPoint ("TOPLEFT", slider, "TOPRIGHT", 6, -16)
		slider.ScrollBar:SetPoint ("BOTTOMLEFT", slider, "BOTTOMRIGHT", 6, 16 + (heightOffset and heightOffset*-1 or 0))
		
		slider.ScrollBar.ThumbTexture:SetColorTexture (.5, .5, .5, .3)
		slider.ScrollBar.ThumbTexture:SetSize (12, 8)
		
		--
		
		slider.ScrollBar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
		slider.ScrollBar:SetBackdropColor (0, 0, 0, 0.35)
		slider.ScrollBar:SetBackdropBorderColor (0, 0, 0, 1)
	end
end

--doo elsee 
