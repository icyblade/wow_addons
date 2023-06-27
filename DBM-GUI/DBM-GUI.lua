-- *********************************************************
-- **               Deadly Boss Mods - GUI                **
-- **            http://www.deadlybossmods.com            **
-- *********************************************************
--
-- This addon is written and copyrighted by:
--    * Paul Emmerich (Tandanu @ EU-Aegwynn) (DBM-Core)
--    * Martin Verges (Nitram @ EU-Azshara) (DBM-GUI)
--
-- The localizations are written by:
--    * enGB/enUS: Tandanu				http://www.deadlybossmods.com
--    * deDE: Tandanu					http://www.deadlybossmods.com
--    * zhCN: Diablohu					http://www.dreamgen.cn | diablohudream@gmail.com
--    * ruRU: BootWin					bootwin@gmail.com
--    * ruRU: Vampik					admin@vampik.ru
--    * zhTW: Hman						herman_c1@hotmail.com
--    * zhTW: Azael/kc10577				paul.poon.kw@gmail.com
--    * koKR: BlueNyx/nBlueWiz			bluenyx@gmail.com / everfinale@gmail.com
--    * esES: Snamor/1nn7erpLaY      	romanscat@hotmail.com
--
-- Special thanks to:
--    * Arta
--    * Omegal @ US-Whisperwind (continuing mod support for 3.2+)
--    * Tennberg (a lot of fixes in the enGB/enUS localization)
--
--
-- The code of this addon is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License. (see license.txt)
-- All included textures and sounds are copyrighted by their respective owners, license information for these media files can be found in the modules that make use of them.
--
--
--  You are free:
--    * to Share - to copy, distribute, display, and perform the work
--    * to Remix - to make derivative works
--  Under the following conditions:
--    * Attribution. You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work). (A link to http://www.deadlybossmods.com is sufficient)
--    * Noncommercial. You may not use this work for commercial purposes.
--    * Share Alike. If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
--
--

local revision =("$Revision: 7598 $"):sub(12, -3) 
local FrameTitle = "DBM_GUI_Option_"	-- all GUI frames get automatically a name FrameTitle..ID

local PanelPrototype = {}
DBM_GUI = {}
setmetatable(PanelPrototype, {__index = DBM_GUI})

local L = DBM_GUI_Translations

local usemodelframe = true		-- very beta

function DBM_GUI:ShowHide(forceshow)
	if forceshow == true then
		self:UpdateModList()
		DBM_GUI_OptionsFrame:Show()

	elseif forceshow == false then
		DBM_GUI_OptionsFrame:Hide()

	else 
		if DBM_GUI_OptionsFrame:IsShown() then 
			DBM_GUI_OptionsFrame:Hide() 
		else 
			self:UpdateModList()
			DBM_GUI_OptionsFrame:Show() 
		end
	end
end

do
	DBM_GUI_OptionsFrameTab1:SetText(L.OTabBosses)
	DBM_GUI_OptionsFrameTab2:SetText(L.OTabOptions)

	local myid = 100
	local prottypemetatable = {__index = PanelPrototype}
	-- This function creates a new entry in the menu
	--
	--  arg1 = Text for the UI Button
	--  arg2 = nil or ("option" or 2)  ... nil will place as a Boss Mod, otherwise as a Option Tab
	--
	function DBM_GUI:CreateNewPanel(FrameName, FrameTyp, showsub, sortID) 
		local panel = CreateFrame('Frame', FrameTitle..self:GetNewID(), DBM_GUI_OptionsFramePanelContainer)
		panel.mytype = "panel"
		panel.sortID = self:GetCurrentID()
		panel:SetWidth(DBM_GUI_OptionsFramePanelContainerFOV:GetWidth())
		panel:SetHeight(DBM_GUI_OptionsFramePanelContainerFOV:GetHeight()) 
		panel:SetPoint("TOPLEFT", DBM_GUI_OptionsFramePanelContainer, "TOPLEFT")
	
		panel.name = FrameName
		panel.showsub = (showsub or showsub == nil)

		if (sortID or 0) > 0 then
			panel.sortid = sortID
		else
			myid = myid + 1
			panel.sortid = myid
		end
		panel:Hide()
	
		if FrameTyp == "option" or FrameTyp == 2 then
			panel.categoryid = DBM_GUI_Options:CreateCategory(panel, self and self.frame and self.frame.name)
			panel.FrameTyp = 2
		else
			panel.categoryid = DBM_GUI_Bosses:CreateCategory(panel, self and self.frame and self.frame.name)
			panel.FrameTyp = 1
		end
	
		self:SetLastObj(panel)
		self.panels = self.panels or {}
		table.insert(self.panels, {frame = panel, parent = self, framename = FrameTitle..self:GetCurrentID()})
		local obj = self.panels[#self.panels]
		panel.panelid = #self.panels
		return setmetatable(obj, prottypemetatable)
	end

	-- This function don't realy destroy a window, it just hides it
	function PanelPrototype:Destroy()
		if self.frame.FrameTyp == 2 then
			table.remove(DBM_GUI_Options.Buttons, self.frame.categoryid)
		else
			table.remove(DBM_GUI_Bosses.Buttons, self.frame.categoryid)
		end
		table.remove(self.parent.panels, self.frame.panelid)
		self.frame:Hide()
	end

	-- This function renames the Menu Entry for a Panel
	function PanelPrototype:Rename(newname)
		self.frame.name = newname
	end

	-- This function adds areas to group widgets
	--
	--  arg1 = titel of this area
	--  arg2 = width ot the area
	--  arg3 = hight of the area
	--  arg4 = autoplace
	--
	function PanelPrototype:CreateArea(name, width, height, autoplace)
		local area = CreateFrame('Frame', FrameTitle..self:GetNewID(), self.frame, 'OptionsBoxTemplate')
		area.mytype = "area"
		area:SetBackdropBorderColor(0.4, 0.4, 0.4)
		area:SetBackdropColor(0.15, 0.15, 0.15, 0.5)
		_G[FrameTitle..self:GetCurrentID()..'Title']:SetText(name)
		if width ~= nil and width < 0 then
			area:SetWidth( self.frame:GetWidth() -12 + width)
		else
			area:SetWidth(width or self.frame:GetWidth()-12)
		end
		area:SetHeight(height or self.frame:GetHeight()-10)
		
		if autoplace then
			if select('#', self.frame:GetChildren()) == 1 then
				area:SetPoint('TOPLEFT', self.frame, 5, -17)
			else
				area:SetPoint('TOPLEFT', select(-2, self.frame:GetChildren()) or self.frame, "BOTTOMLEFT", 0, -17)
			end
		end
	
		self:SetLastObj(area)
		self.areas = self.areas or {}
		table.insert(self.areas, {frame = area, parent = self, framename = FrameTitle..self:GetCurrentID()})
		return setmetatable(self.areas[#self.areas], prottypemetatable)
	end

	function DBM_GUI:GetLastObj() 
		return self.lastobject
	end
	function DBM_GUI:SetLastObj(obj)
		self.lastobject = obj
	end
	function DBM_GUI:GetParentsLastObj()
		if self.frame.mytype == "area" then
			return self.parent:GetLastObj()
		else
			return self:GetLastObj()
		end
	end
end

do 
	local FrameNames = {}
	function DBM_GUI:AddFrame(FrameName)
		table.insert(FrameNames, FrameName)
	end
	function DBM_GUI:IsPresent(FrameName)
		for k,v in ipairs(FrameNames) do
			if v == FrameName then
				return true
			end
		end
		return false
	end
end


do
	local framecount = 0
	function DBM_GUI:GetNewID() 
		framecount = framecount + 1
		return framecount
	end
	function DBM_GUI:GetCurrentID()
		return framecount
	end
end



-- This function creates a check box
-- Autoplaced buttons will be placed under the last widget
--
--  arg1 = text right to the CheckBox
--  arg2 = autoplaced (true or nil/false)
--  arg3 = text on left side
--  arg4 = DBM.Options[arg4] 
--  arg5 = DBM.Bars:SetOption(arg5, ...)
--
do
	local function cursorInHitBox(frame)
		local x = GetCursorPosition()
		local fX = frame:GetCenter()
		local hitBoxSize = -100 -- default value from the default UI template
		return x - fX < hitBoxSize
	end
	
	local currActiveButton
	local updateFrame = CreateFrame("Frame")
	local function onUpdate(self, elapsed)
		local inHitBox = cursorInHitBox(currActiveButton)
		if currActiveButton.fakeHighlight and not inHitBox then
			currActiveButton:UnlockHighlight()
			currActiveButton.fakeHighlight = nil
		elseif not currActiveButton.fakeHighlight and inHitBox then
			currActiveButton:LockHighlight()
			currActiveButton.fakeHighlight = true
		end
		local x, y = GetCursorPosition()
		local scale = UIParent:GetEffectiveScale()
		x, y = x / scale, y / scale
		GameTooltip:SetPoint("BOTTOMLEFT", nil, "BOTTOMLEFT", x + 5, y + 2)
	end
		
	local function onHyperlinkClick(self, data, link)
		if IsShiftKeyDown() then
			local msg = link:gsub("|h(.*)|h", "|h[%1]|h")
			local chatWindow = ChatEdit_GetActiveWindow()
			if chatWindow then
				chatWindow:Insert(msg)
			end
		elseif not IsShiftKeyDown() then
			if cursorInHitBox(self:GetParent()) then
				self:GetParent():Click()
			end
		end
	end

	local function onHyperlinkEnter(self, data, link)
		GameTooltip:SetOwner(self, "ANCHOR_NONE") -- I want to anchor BOTTOMLEFT of the tooltip to the cursor... (not BOTTOM as in ANCHOR_CURSOR)
		local linkType = strsplit(":", data)
		if linkType ~= "journal" then
			GameTooltip:SetHyperlink(data)
		else -- "journal:contentType:contentID:difficulty"
			local _, contentType, contentID = strsplit(":", data)
			if contentType == "2" then -- EJ section
				local name, description = EJ_GetSectionInfo(tonumber(contentID))
				GameTooltip:AddLine(name or DBM_CORE_UNKNOWN, 255, 255, 255, 0)
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(description or DBM_CORE_UNKNOWN, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
			end
		end
		GameTooltip:Show()
		currActiveButton = self:GetParent()
		updateFrame:SetScript("OnUpdate", onUpdate)
		if cursorInHitBox(self:GetParent()) then
			self:GetParent().fakeHighlight = true
			self:GetParent():LockHighlight()
		end
	end

	local function onHyperlinkLeave(self, data, link)
		GameTooltip:Hide()
		updateFrame:SetScript("OnUpdate", nil)
		if self:GetParent().fakeHighlight then
			self:GetParent().fakeHighlight = nil
			self:GetParent():UnlockHighlight()
		end
	end
	
	local function replaceSpellLinks(id)
		local spellId = tonumber(id)
		local spellName = GetSpellInfo(spellId) or DBM_CORE_UNKNOWN
		return ("|cff71d5ff|Hspell:%d|h%s|h|r"):format(spellId, spellName)
	end

	local function replaceJournalLinks(id)
		local link = select(9, EJ_GetSectionInfo(tonumber(id))) or DBM_CORE_UNKNOWN
		return link:gsub("|h%[(.*)%]|h", "|h%1|h")
	end
	
	function PanelPrototype:CreateCheckButton(name, autoplace, textleft, dbmvar, dbtvar)
		if not name then
			return
		end
		if type(name) == "number" then
			return DBM:AddMsg("CreateCheckButton: error: expected string, received number. You probably called mod:NewTimer(optionId) with a spell id.")
		end
		local button = CreateFrame('CheckButton', FrameTitle..self:GetNewID(), self.frame, 'OptionsCheckButtonTemplate')
		button.myheight = 25
		button.mytype = "checkbutton"
		-- font strings do not support hyperlinks, so check if we need one...
		if name:find("%$spell:ej") then -- it is in fact a journal link :-)
			name = name:gsub("%$spell:ej(%d+)", "$journal:%1")
		end
		if name:find("%$spell:") then
			name = name:gsub("%$spell:(%d+)", replaceSpellLinks)
		end
		if name:find("%$journal:") then
			name = name:gsub("%$journal:(%d+)", replaceJournalLinks)
		end
		if name and name:find("|H") then -- ...and replace it with a SimpleHTML frame
			_G[button:GetName().."Text"] = CreateFrame("SimpleHTML", button:GetName().."Text", button)
			local html = _G[button:GetName().."Text"]
			html:SetHeight(12)
			html:SetFontObject("GameFontNormal")
			html:SetPoint("LEFT", button, "RIGHT", 0, 1)
			html:SetScript("OnHyperlinkClick", onHyperlinkClick)
			html:SetScript("OnHyperlinkEnter", onHyperlinkEnter)
			html:SetScript("OnHyperlinkLeave", onHyperlinkLeave)
		end
		_G[button:GetName() .. 'Text']:SetText(name or DBM_CORE_UNKNOWN)
		_G[button:GetName() .. 'Text']:SetWidth( self.frame:GetWidth() - 50 )

		if textleft then
			_G[button:GetName() .. 'Text']:ClearAllPoints()
			_G[button:GetName() .. 'Text']:SetPoint("RIGHT", button, "LEFT", 0, 0)
			_G[button:GetName() .. 'Text']:SetJustifyH("RIGHT")
		else
			_G[button:GetName() .. 'Text']:SetJustifyH("LEFT")
		end
		
		if dbmvar and DBM.Options[dbmvar] ~= nil then
			button:SetScript("OnShow",  function(self) button:SetChecked(DBM.Options[dbmvar]) end)
			button:SetScript("OnClick", function(self) DBM.Options[dbmvar] = not DBM.Options[dbmvar] end)
		end

		if dbtvar then
			button:SetScript("OnShow",  function(self) button:SetChecked( DBM.Bars:GetOption(dbtvar) ) end)
			button:SetScript("OnClick", function(self) DBM.Bars:SetOption(dbtvar, not DBM.Bars:GetOption(dbtvar)) end)
		end

		if autoplace then
			local x = self:GetLastObj()
			if x.mytype == "checkbutton" then
				button:ClearAllPoints()
				button:SetPoint('TOPLEFT', self:GetLastObj(), "BOTTOMLEFT", 0, 2)
			else
				button:ClearAllPoints()
				button:SetPoint('TOPLEFT', 10, -12)
			end
		end

		self:SetLastObj(button)
		return button
	end

end

do
	local function unfocus(self)
		self:ClearFocus() 
	end
	-- This function creates an EditBox
	--
	--  arg1 = Title text, placed ontop of the EditBox
	--  arg2 = Text placed within the EditBox
	--  arg3 = width
	--  arg4 = height
	--
	function PanelPrototype:CreateEditBox(text, value, width, height)
		local textbox = CreateFrame('EditBox', FrameTitle..self:GetNewID(), self.frame, 'DBM_GUI_FrameEditBoxTemplate')
		textbox.mytype = "textbox"
		_G[FrameTitle..self:GetCurrentID().."Text"]:SetText(text)
		textbox:SetWidth(width or 100)
		textbox:SetHeight(height or 20)
		textbox:SetScript("OnEscapePressed", unfocus)
		textbox:SetScript("OnTabPressed", unfocus)
		if type(value) == "string" then
			textbox:SetText(value)
		end
		self:SetLastObj(textbox)
		return textbox
	end
end

-- This function creates a ScrollingMessageFrame (usefull for log entrys)
--
--  arg1 = width of the frame
--  arg2 = height
--  arg3 = insertmode (BOTTOM or TOP)
--  arg4 = enable message fading (default disabled)
--  arg5 = fontobject (font for the messages)
--
function PanelPrototype:CreateScrollingMessageFrame(width, height, insertmode, fading, fontobject)
	local scrollframe = CreateFrame("ScrollingMessageFrame",FrameTitle..self:GetNewID(), self.frame)
	scrollframe:SetWidth(width or 200)
	scrollframe:SetHeight(height or 150)
	scrollframe:SetJustifyH("LEFT")
	if not fading then
		scrollframe:SetFading(false)
	end
--	scrollframe:SetInsertMode(insertmode or "BOTTOM")
	scrollframe:SetFontObject(fontobject or "GameFontNormal")
	scrollframe:SetMaxLines(2000)
	scrollframe:EnableMouse(true)
	scrollframe:EnableMouseWheel(1)
	
	scrollframe:SetScript("OnHyperlinkClick", ChatFrame_OnHyperlinkShow)
	scrollframe:SetScript("OnMouseWheel", function(self, delta)
		if delta == 1 then
			self:ScrollUp()
		elseif delta == -1 then 
			self:ScrollDown()
		end
	end)

	self:SetLastObj(scrollframe)
	return scrollframe
end	


-- This function creates a slider for numeric values
--
--  arg1 = text ontop of the slider, centered
--  arg2 = lowest value
--  arg3 = highest value
--  arg4 = stepping
--  arg5 = framewidth
--
do
	local function onValueChanged(font, text)
		return function(self, value)
			font:SetFormattedText(text, value)
		end
	end
	function PanelPrototype:CreateSlider(text, low, high, step, framewidth)
		local slider = CreateFrame('Slider', FrameTitle..self:GetNewID(), self.frame, 'OptionsSliderTemplate')
		slider.mytype = "slider"
		slider:SetMinMaxValues(low, high)
		slider:SetValueStep(step)
		slider:SetWidth(framewidth or 180)
		_G[FrameTitle..self:GetCurrentID()..'Text']:SetText(text)
		slider:SetScript("OnValueChanged", onValueChanged(_G[FrameTitle..self:GetCurrentID()..'Text'], text))
		self:SetLastObj(slider)
		return slider
	end
end

-- This function creates a color picker
--
--  arg1 = width of the colorcircle (128 default)
--  arg2 = true if you want an alpha selector
--  arg3 = width of the alpha selector (32 default)

function PanelPrototype:CreateColorSelect(dimension, withalpha, alphawidth)
	--- Color select texture with wheel and value
	local colorselect = CreateFrame("ColorSelect", FrameTitle..self:GetNewID(), self.frame)
	colorselect.mytype = "colorselect"
	if withalpha then
		colorselect:SetWidth((dimension or 128)+37)
	else
		colorselect:SetWidth((dimension or 128))
	end
	colorselect:SetHeight(dimension or 128)
	
	-- create a color wheel
	local colorwheel = colorselect:CreateTexture()
	colorwheel:SetWidth(dimension or 128)
	colorwheel:SetHeight(dimension or 128)
	colorwheel:SetPoint("TOPLEFT", colorselect, "TOPLEFT", 5, 0)
	colorselect:SetColorWheelTexture(colorwheel)
	
	-- create the colorpicker
	local colorwheelthumbtexture = colorselect:CreateTexture()
	colorwheelthumbtexture:SetTexture("Interface\\Buttons\\UI-ColorPicker-Buttons")
	colorwheelthumbtexture:SetWidth(10)
	colorwheelthumbtexture:SetHeight(10)
	colorwheelthumbtexture:SetTexCoord(0,0.15625, 0, 0.625)
	colorselect:SetColorWheelThumbTexture(colorwheelthumbtexture)
	
	if withalpha then
		-- create the alpha bar
		local colorvalue = colorselect:CreateTexture()
		colorvalue:SetWidth(alphawidth or 32)
		colorvalue:SetHeight(dimension or 128)
		colorvalue:SetPoint("LEFT", colorwheel, "RIGHT", 10, -3)
		colorselect:SetColorValueTexture(colorvalue)
	
		-- create the alpha arrows
		local colorvaluethumbtexture = colorselect:CreateTexture()
		colorvaluethumbtexture:SetTexture("Interface\\Buttons\\UI-ColorPicker-Buttons")
		colorvaluethumbtexture:SetWidth( alphawidth/32 * 48)
		colorvaluethumbtexture:SetHeight( alphawidth/32 * 14)
		colorvaluethumbtexture:SetTexCoord(0.25, 1, 0.875, 0)
		colorselect:SetColorValueThumbTexture(colorvaluethumbtexture)
	end
	
	self:SetLastObj(colorselect)
	return colorselect
end


-- This function creates a button
--
--  arg1 = text on the button "OK", "Cancel",...
--  arg2 = widht
--  arg3 = height
--  arg4 = function to call when clicked
--
function PanelPrototype:CreateButton(title, width, height, onclick, FontObject)
	local button = CreateFrame('Button', FrameTitle..self:GetNewID(), self.frame, 'DBM_GUI_OptionsFramePanelButtonTemplate')
	button.mytype = "button"
	button:SetWidth(width or 100)
	button:SetHeight(height or 20)
	button:SetText(title)
	if onclick then
		button:SetScript("OnClick", onclick)
	end
	if FontObject then
		button:SetNormalFontObject(FontObject);
		button:SetHighlightFontObject(FontObject);		
	end
	if _G[button:GetName().."Text"]:GetStringWidth() > button:GetWidth() then
		button:SetWidth( _G[button:GetName().."Text"]:GetStringWidth() + 25 )
	end

	self:SetLastObj(button)
	return button
end

-- This function creates a text block for descriptions
--
--  arg1 = text to write
--  arg2 = width to set
function PanelPrototype:CreateText(text, width, autoplaced, style, justify)
	local textblock = self.frame:CreateFontString(FrameTitle..self:GetNewID(), "ARTWORK")
	textblock.mytype = "textblock"
	if not style then
		textblock:SetFontObject(GameFontNormal)
	else
		textblock:SetFontObject(style)
	end
	textblock:SetText(text)
	if justify then
		textblock:SetJustifyH(justify)
	else
		textblock:SetJustifyH("CENTER")
	end

	if width then
		textblock:SetWidth( width or 100 )
	else
		textblock:SetWidth( self.frame:GetWidth() )
	end

	if autoplaced then
		textblock:SetPoint('TOPLEFT',self.frame, "TOPLEFT", 10, -10);
	end

	self:SetLastObj(textblock)
	return textblock
end


function PanelPrototype:CreateCreatureModelFrame(width, height, creatureid)
	local ModelFrame = CreateFrame('PlayerModel', FrameTitle..self:GetNewID(), self.frame)
	ModelFrame.mytype = "modelframe"
	ModelFrame:SetWidth(width or 100)
	ModelFrame:SetHeight(height or 200)
	ModelFrame:SetCreature(tonumber(creatureid) or 448)	-- Hogger!!! he kills all of you
	
	self:SetLastObj(ModelFrame)
	return ModelFrame	
end

function PanelPrototype:AutoSetDimension()
	if not self.frame.mytype == "area" then return end
	local height = self.frame:GetHeight()

	local need_height = 25
	
	local kids = { self.frame:GetChildren() }
	for _, child in pairs(kids) do
		if child.myheight and type(child.myheight) == "number" then
			need_height = need_height + child.myheight
		else
			need_height = need_height + child:GetHeight() + 50
		end
	end

	self.frame.myheight = need_height + 25
	self.frame:SetHeight(need_height)
end

function PanelPrototype:SetMyOwnHeight()
	if not self.frame.mytype == "panel" then return end

	local need_height = 30

	local kids = { self.frame:GetChildren() }
	for _, child in pairs(kids) do
		if child.mytype == "area" and child.myheight then
			need_height = need_height + child.myheight
		elseif child.mytype == "area" then
			need_height = need_height + child:GetHeight() + 30
		elseif child.myheight then
			need_height = need_height +  child.myheight
		end
	end
	self.frame.actualHeight = need_height -- HACK: work-around for some strange bug, panels that are overriden (e.g. stats panels when the mod is loaded) are behaving strange since 4.1. GetHeight() will always return the height of the old panel and not of the new...
	self.frame:SetHeight(need_height)
end


local ListFrameButtonsPrototype = {}
-- Prototyp for ListFrame Options Buttons

function ListFrameButtonsPrototype:CreateCategory(frame, parent)
	if not type(frame) == "table" then
		DBM:AddMsg("Failed to create category - frame is not a table")
		DBM:AddMsg(debugstack())
		return false
	elseif not frame.name then
		DBM:AddMsg("Failed to create category - frame.name is missing")
		DBM:AddMsg(debugstack())
		return false
	elseif self:IsPresent(frame.name) then
		DBM:AddMsg("Frame ("..frame.name..") already exists")
		DBM:AddMsg(debugstack())
		return false
	end

	if parent then
		frame.depth = self:GetDepth(parent)
	else 
		frame.depth = 1
	end

	self:SetParentHasChilds(parent)

	table.insert(self.Buttons, {
		frame = frame,
		parent = parent
	})
	return #self.Buttons
end

function ListFrameButtonsPrototype:IsPresent(framename)
	for k,v in ipairs(self.Buttons) do
		if v.frame.name == framename then
			return true
		end
	end
	return false
end

function ListFrameButtonsPrototype:GetDepth(framename, depth)
	depth = depth or 1
	for k,v in ipairs(self.Buttons) do
		if v.frame.name == framename then
			if v.parent == nil then		
				return depth+1
			else				
				depth = depth + self:GetDepth(v.parent, depth)
			end
		end
	end
	return depth
end

function ListFrameButtonsPrototype:SetParentHasChilds(parent)
	if not parent then return end
	for k,v in ipairs(self.Buttons) do
		if v.frame.name == parent then		
			v.frame.haschilds = true
		end
	end
end


do
	local mytable = {}
	function ListFrameButtonsPrototype:GetVisibleTabs()
		table.wipe(mytable)
		for k,v in ipairs(self.Buttons) do
			if v.parent == nil then 
				table.insert(mytable, v)
	
				if v.frame.showsub then
					self:GetVisibleSubTabs(v.frame.name, mytable)
				end
			end
		end
		return mytable
	end
end

function ListFrameButtonsPrototype:GetVisibleSubTabs(parent, t)
	for i, v in ipairs(self.Buttons) do
		if v.parent == parent then
			table.insert(t, v)
			if v.frame.showsub then
				self:GetVisibleSubTabs(v.frame.name, t)
			end
		end
	end
end

local CreateNewFauxScrollFrameList
do
	local mt = {__index = ListFrameButtonsPrototype}
	function CreateNewFauxScrollFrameList()
		return setmetatable({ Buttons={} }, mt)
	end
end

DBM_GUI_Bosses = CreateNewFauxScrollFrameList()
DBM_GUI_Options = CreateNewFauxScrollFrameList()


local function GetSharedMedia3()
	if LibStub and LibStub("LibSharedMedia-3.0", true) then
		return LibStub("LibSharedMedia-3.0", true)
	end
	return false
end


local UpdateAnimationFrame
do
	local function HideScrollBar(frame)
		local list = _G[frame:GetName() .. "List"];
		list:Hide();
		local listWidth = list:GetWidth();
		for _, button in next, frame.buttons do
			button:SetWidth(button:GetWidth() + listWidth);
		end
	end

	local function DisplayScrollBar(frame)
		local list = _G[frame:GetName() .. "List"];
		list:Show();
		local listWidth = list:GetWidth();
		for _, button in next, frame.buttons do
			button:SetWidth(button:GetWidth() - listWidth);
		end
	end

	-- the functions in this block are only used to 
	-- create/update/manage the Fauxscrollframe for Boss/Options Selection
	local displayedElements = {}

	-- This function is for internal use.
	-- Function to update the left scrollframe buttons with the menu entries
	function DBM_GUI_OptionsFrame:UpdateMenuFrame(listframe)
		local offset = _G[listframe:GetName().."List"].offset;
		local buttons = listframe.buttons;
		local TABLE 

		if not buttons then return false; end

		if listframe:GetParent().tab == 2 then
			TABLE = DBM_GUI_Options:GetVisibleTabs()
		else 
			TABLE = DBM_GUI_Bosses:GetVisibleTabs()
		end
		local element;
		
		for i, element in ipairs(displayedElements) do
			displayedElements[i] = nil;
		end

		for i, element in ipairs(TABLE) do
			table.insert(displayedElements, element.frame);
		end


		local numAddOnCategories = #displayedElements;
		local numButtons = #buttons;

		if ( numAddOnCategories > numButtons and ( not listframe:IsShown() ) ) then
			DisplayScrollBar(listframe);
		elseif ( numAddOnCategories <= numButtons and ( listframe:IsShown() ) ) then
			HideScrollBar(listframe);
		end
	
		if ( numAddOnCategories > numButtons ) then
			_G[listframe:GetName().."List"]:Show();
			_G[listframe:GetName().."ListScrollBar"]:SetMinMaxValues(0, (numAddOnCategories - numButtons) * buttons[1]:GetHeight());
			_G[listframe:GetName().."ListScrollBar"]:SetValueStep( buttons[1]:GetHeight() )
		else
			_G[listframe:GetName().."ListScrollBar"]:SetValue(0);
			_G[listframe:GetName().."List"]:Hide();
		end

		local selection = DBM_GUI_OptionsFrameBossMods.selection;
		if ( selection ) then
			DBM_GUI_OptionsFrame:ClearSelection(listframe, listframe.buttons);
		end

		for i = 1, #buttons do
			element = displayedElements[i + offset]
			if ( not element ) then
				DBM_GUI_OptionsFrame:HideButton(buttons[i]);
			else
				DBM_GUI_OptionsFrame:DisplayButton(buttons[i], element);
				
				if ( selection ) and ( selection == element ) and ( not listframe.selection ) then
					DBM_GUI_OptionsFrame:SelectButton(listframe, buttons[i]);
				end
			end
		end
	end

	-- This function is for internal use.
	-- Used to show a button from the list
	function DBM_GUI_OptionsFrame:DisplayButton(button, element)
		button:Show();
		button.element = element;

		button.text:ClearAllPoints()		
		button.text:SetPoint("LEFT", 12 + 8 * element.depth, 2);
		button.text:SetFontObject(GameFontNormalSmall)
		button.toggle:ClearAllPoints()
		button.toggle:SetPoint("LEFT", 8 * element.depth - 2, 1);

		if element.depth > 2 then
			button:SetNormalFontObject(GameFontHighlightSmall);
			button:SetHighlightFontObject(GameFontHighlightSmall);

		elseif element.depth > 1  then
			button:SetNormalFontObject(GameFontNormalSmall);
			button:SetHighlightFontObject(GameFontNormalSmall);
		else
			button:SetNormalFontObject(GameFontNormal);
			button:SetHighlightFontObject(GameFontNormal);
		end
		button:SetWidth(185)

		if element.haschilds then
			if not element.showsub then
				button.toggle:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP");
				button.toggle:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN");
			else
				button.toggle:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-UP");
				button.toggle:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-DOWN");		
			end
			button.toggle:Show();
		else
			button.toggle:Hide();
		end

		button.text:SetText(element.name);
		button.text:Show()
	end

	-- This function is for internal use.
	-- Used to hide a button from the list
	function DBM_GUI_OptionsFrame:HideButton(button)
		button:Hide()
	end

	-- This function is for internal use.
	-- Called when a new entry is selected
	function DBM_GUI_OptionsFrame:ClearSelection(listFrame, buttons)
		for _, button in ipairs(buttons) do button:UnlockHighlight(); end
		listFrame.selection = nil;
	end
	
	-- This function is for Internal use.
	-- Called when a button is selected
	function DBM_GUI_OptionsFrame:SelectButton(listFrame, button)
		button:LockHighlight()
		listFrame.selection = button.element;
	end

	-- This function is for Internal use.
	-- Required to create a list of buttons in the scrollframe
	function DBM_GUI_OptionsFrame:CreateButtons(frame)
		local name = frame:GetName()
	
		frame.scrollBar = _G[name.."ListScrollBar"]
		frame:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
		_G[name.."Bottom"]:SetVertexColor(0.66, 0.66, 0.66)
	
		local buttons = {}
		local button = CreateFrame("BUTTON", name.."Button1", frame, "DBM_GUI_FrameButtonTemplate")
		button:SetPoint("TOPLEFT", frame, 0, -8)
		frame.buttonHeight = button:GetHeight()
		table.insert(buttons, button)
	
		local maxButtons = (frame:GetHeight() - 8) / frame.buttonHeight
		for i = 2, maxButtons do
			button = CreateFrame("BUTTON", name.."Button"..i, frame, "DBM_GUI_FrameButtonTemplate")
			button:SetPoint("TOPLEFT", buttons[#buttons], "BOTTOMLEFT")
			table.insert(buttons, button)
		end
		frame.buttons = buttons
	end

	-- This function is for internal use.
	-- Called when someone clicks a Button
	function DBM_GUI_OptionsFrame:OnButtonClick(button)
		local parent = button:GetParent();
		local buttons = parent.buttons;
	
		self:ClearSelection(_G[self:GetName().."BossMods"],   _G[self:GetName().."BossMods"].buttons);
		self:ClearSelection(_G[self:GetName().."DBMOptions"], _G[self:GetName().."DBMOptions"].buttons);
		self:SelectButton(parent, button);

		self:DisplayFrame(button.element);
	end

	function DBM_GUI_OptionsFrame:ToggleSubCategories(button)
		local parent = button:GetParent();
		if parent.element.showsub then
			parent.element.showsub = false
		else
			parent.element.showsub = true
		end
		self:UpdateMenuFrame(parent:GetParent())
	end

	-- This function is for internal use.
	-- places the selected tab on the container frame
	function DBM_GUI_OptionsFrame:DisplayFrame(frame)
		local container = _G[self:GetName().."PanelContainer"]

		if not (type(frame) == "table" and type(frame[0]) == "userdata") or select("#", frame:GetChildren()) == 0 then
--			DBM:AddMsg(debugstack())
			return
		end

		if ( container.displayedFrame ) then
			container.displayedFrame:Hide();
		end
		container.displayedFrame = frame

		DBM_GUI_OptionsFramePanelContainerHeaderText:SetText( frame.name )
				
		local mymax = (frame.actualHeight or frame:GetHeight()) - container:GetHeight()
		
		if mymax <= 0 then mymax = 0 end
		
		if mymax > 0 then
			_G[container:GetName().."FOV"]:Show()
			_G[container:GetName().."FOV"]:SetScrollChild(frame)
			_G[container:GetName().."FOVScrollBar"]:SetMinMaxValues(0, mymax)

			if frame.isfixed then
				frame.isfixed = nil
				local listwidth = _G[container:GetName().."FOVScrollBar"]:GetWidth()
				for i=1, select("#", frame:GetChildren()), 1 do
					local child = select(i, frame:GetChildren())
					if child.mytype == "area" then
						child:SetWidth( child:GetWidth() - listwidth - 1 )
					end
				end
			end
		else
			_G[container:GetName().."FOV"]:Hide()
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", container ,"TOPLEFT", 5, 0)
			frame:SetPoint("BOTTOMRIGHT", container ,"BOTTOMRIGHT", 0, 0)

			if not frame.isfixed then
				frame.isfixed = true
				local listwidth = _G[container:GetName().."FOVScrollBar"]:GetWidth()
				for i=1, select("#", frame:GetChildren()), 1 do
					local child = select(i, frame:GetChildren())
					if child.mytype == "area" then
						child:SetWidth( child:GetWidth() + listwidth )
					end
				end
			end
		end
		frame:Show();

		if DBM.Options.EnableModels then
			DBM_BossPreview.enabled = false
			DBM_BossPreview:Hide()
			for _, mod in ipairs(DBM.Mods) do
				if mod.panel and mod.panel.frame and mod.panel.frame == frame then
					UpdateAnimationFrame(mod)
				end
			end
		end
	end

end

function UpdateAnimationFrame(mod)
	DBM_BossPreview.currentMod = mod
	local displayId = nil

--[[ This way will break the Encounter Journal GUI .. needs a "fix" before activating
	if mod.encounterId and mod.instanceId then
		EJ_SetDifficulty(true, true)
		EncounterJournal.instanceID = mod.instanceId
		EncounterJournal_Refresh(EncounterJournal.encounter)
		EncounterJournal.encounterID = mod.encounterId
		EncounterJournal_Refresh(EncounterJournal.encounter)
		displayId = EncounterJournal.encounter["creatureButton1"].displayInfo
	end]]

	DBM_BossPreview:Show()
	DBM_BossPreview:ClearModel()
	DBM_BossPreview:SetDisplayInfo(displayId or mod.modelId or 0)
	DBM_BossPreview:SetSequence(4)
	if DBM.Options.ModelSoundValue == "Short" then
		if DBM.Options.UseMasterVolume then
			PlaySoundFile(mod.modelSoundShort or 0, "Master")
		else
			PlaySoundFile(mod.modelSoundShort or 0)
		end
	elseif DBM.Options.ModelSoundValue == "Long" then
		if DBM.Options.UseMasterVolume then
			PlaySoundFile(mod.modelSoundLong or 0, "Master")
		else
			PlaySoundFile(mod.modelSoundLong or 0)
		end
	end

--[[	** FANCY STUFF WE DO NOT USE FOR NOW **
	DBM_BossPreview:SetModelScale(mod.modelScale or 0.5)

	DBM_BossPreview.atime = 0 
	DBM_BossPreview.apos = 0
	DBM_BossPreview.rotation = 0
	DBM_BossPreview.modelRotation = mod.modelRotation or -60
	DBM_BossPreview.modelOffsetX = mod.modelOffsetX or 0
	DBM_BossPreview.modelOffsetY = mod.modelOffsetY or 0
	DBM_BossPreview.modelOffsetZ = mod.modelOffsetZ or 0
	DBM_BossPreview.modelscale = mod.modelScale or 0.5
	DBM_BossPreview.modelMoveSpeed = mod.modelMoveSpeed or 1
	DBM_BossPreview.pos_x = 0.5
	DBM_BossPreview.pos_y = 0.1
	DBM_BossPreview.pos_z = 0
	DBM_BossPreview.alpha = 1
	DBM_BossPreview.scale = 0
	DBM_BossPreview.apos = 0
	DBM_BossPreview:SetAlpha(DBM_BossPreview.alpha)
	DBM_BossPreview:SetFacing( DBM_BossPreview.modelRotation  *math.pi/180)
	DBM_BossPreview:SetPosition(
		DBM_BossPreview.pos_z + DBM_BossPreview.modelOffsetZ, 
		DBM_BossPreview.pos_x + DBM_BossPreview.modelOffsetX, 
		DBM_BossPreview.pos_y + DBM_BossPreview.modelOffsetY)
	DBM_BossPreview.enabled = true
--]]
end

local function CreateAnimationFrame()
	local mobstyle = CreateFrame('PlayerModel', "DBM_BossPreview", DBM_GUI_OptionsFramePanelContainer)
	mobstyle:SetPoint("BOTTOMRIGHT", DBM_GUI_OptionsFramePanelContainer, "BOTTOMRIGHT", -5, 5)
	mobstyle:SetWidth( 300 )
	mobstyle:SetHeight( 230 )
	mobstyle:SetPortraitZoom(0.4)
	mobstyle:SetRotation(0)
	mobstyle:SetClampRectInsets(0, 0, 24, 0)

--[[    ** FANCY STUFF WE DO NOT USE FOR NOW **

	mobstyle.playlist = { 	-- start animation outside of our fov    
				{set_y = 0, set_x = 1.1, set_z = 0, setfacing = -90, setalpha = 1},
				-- wait outside fov befor begining
				{mintime = 1000, maxtime = 7000},	-- randomtime to wait
				-- {time = 10000},  			-- just wait 10 seconds

				-- move in the fov and to waypoint #1
				{animation = 4, time = 1500, move_x = -0.7},
				{animation = 0, time = 10, endfacing = -90 }, -- rotate in an animation

				-- stay on waypoint #1 
				{setfacing = -90},
				{animation = 0, time = 10000},
				--{animation = 0, time = 2000, randomanimation = {45,46,47}},	-- play a random emote

				-- move to next waypoint
				{setfacing = -90},
				{animation = 4, time = 5000, move_x = -2.5},

				-- stay on waypoint #2
				{setfacing = 0},
				{animation = 0, time = 10000,},
				 
				
				-- move to the horizont
				{setfacing = 180},
				{animation = 4, time = 10000, toscale=0.005},

				-- die and despawn
				{animation = 1, time = 5000},
				{animation = 6, time = 2000, toalpha = 0},

				-- we want so sleep a little while on animation end
				{mintime = 1000, maxtime = 3000},
	} 

	mobstyle.animationTypes = {1, 4, 5, 14, 40} -- die, walk, run, kneel?, swim/fly
	mobstyle.animation = 3
	mobstyle:SetScript("OnUpdate", function(self, e)
		if not self.enabled then return end
		
		self.atime = self.atime + e*1000

		if self.atime >= 10000 then
			mobstyle.animation = floor(math.random(1, #mobstyle.animationTypes))
			self.atime = 0
		end
		self:SetSequenceTime(mobstyle.animationTypes[mobstyle.animation], self.atime) 
	end)
	
	mobstyle:SetScript("OnUpdate", function(self, e)
		--if true then return end
		if not self.enabled then return end
		self.atime = self.atime + e * 1000  
		if self.apos == 0 or self.atime >= (self.playlist[self.apos].time or 0) then
			self.apos = self.apos + 1
			if self.apos <= #self.playlist and self.playlist[self.apos].setfacing then
				self:SetFacing( (self.playlist[self.apos].setfacing + self.modelRotation) * math.pi/180)
			end
			if self.apos <= #self.playlist and self.playlist[self.apos].setalpha then
				self:SetAlpha(self.playlist[self.apos].setalpha)
			end
			if self.apos <= #self.playlist and (self.playlist[self.apos].set_y or self.playlist[self.apos].set_x or self.playlist[self.apos].set_z) then
				self.pos_y = self.playlist[self.apos].set_y or self.pos_y
				self.pos_x = self.playlist[self.apos].set_x or self.pos_x
				self.pos_z = self.playlist[self.apos].set_z or self.pos_z
				self:SetPosition(
					self.pos_z + self.modelOffsetZ, 
					self.pos_x + self.modelOffsetX, 
					self.pos_y + self.modelOffsetY
				)
			end
			if self.apos > #self.playlist then

				self:SetAlpha(1)
				self:SetModelScale(1.0)
				self:SetPosition(0, 0, 0)
				self:SetCreature(self.currentMod.modelId or self.currentMod.creatureId or 0)

				self.apos = 0 
				self.pos_x = 0
				self.pos_y = 0
				self.pos_z = 0
				self.alpha = 1
				self.scale = self.modelscale

				self:SetAlpha(self.alpha)
				self:SetFacing(self.modelRotation)
				self:SetModelScale(self.modelscale)
				self:SetPosition(
					self.pos_z + self.modelOffsetZ, 
					self.pos_x + self.modelOffsetX, 
					self.pos_y + self.modelOffsetY
				)
				return 
			end
			self.rotation = self:GetFacing()
			if self.playlist[self.apos].randomanimation then
				self.playlist[self.apos].animation = self.playlist[self.apos].randomanimation[math.random(1, #self.playlist[self.apos].randomanimation)]
			end
			if self.playlist[self.apos].mintime and self.playlist[self.apos].maxtime then
				self.playlist[self.apos].time = math.random(self.playlist[self.apos].mintime, self.playlist[self.apos].maxtime)
			end


			self.atime = 0
			self.playlist[self.apos].animation = self.playlist[self.apos].animation or 0
			self:SetSequenceTime(self.playlist[self.apos].animation, self.atime)
		end

		if self.playlist[self.apos].animation > 0 then
			self:SetSequenceTime(self.playlist[self.apos].animation,  self.atime) 
		end
	
		if self.playlist[self.apos].endfacing then -- not self.playlist[self.apos].endfacing == self:GetFacing() 
			self.rotation = self.rotation + (e * 2 * math.pi * -- Rotations per second
						((self.playlist[self.apos].endfacing/360)
						/ (self.playlist[self.apos].time/1000))
						)

			self:SetFacing( self.rotation )							
		end
		if self.playlist[self.apos].move_x then
			--self.pos_x = self.pos_x + (self.playlist[self.apos].move_x / (self.playlist[self.apos].time/1000) ) * e
			self.pos_x = self.pos_x + (((self.playlist[self.apos].move_x / (self.playlist[self.apos].time/1000) ) * e) * self.modelMoveSpeed)
			self:SetPosition(self.pos_z+self.modelOffsetZ, self.pos_x+self.modelOffsetX, self.pos_y+self.modelOffsetY)
		end
		if self.playlist[self.apos].move_y then
			self.pos_y = self.pos_y + (self.playlist[self.apos].move_y / (self.playlist[self.apos].time/1000) ) * e
			--self:SetPosition(self.pos_y, self.pos_x, self.pos_z)
			self:SetPosition(self.pos_z+self.modelOffsetZ, self.pos_x+self.modelOffsetX, self.pos_y+self.modelOffsetY)
		end
		if self.playlist[self.apos].move_z then
			self.pos_z = self.pos_z + (self.playlist[self.apos].move_z / (self.playlist[self.apos].time/1000) ) * e
			--self:SetPosition(self.pos_y, self.pos_x, self.pos_z)
			self:SetPosition(self.pos_z+self.modelOffsetZ, self.pos_x+self.modelOffsetX, self.pos_y+self.modelOffsetY)
		end
		if self.playlist[self.apos].toalpha then
			self.alpha = self.alpha - ((1 - self.playlist[self.apos].toalpha) / (self.playlist[self.apos].time/1000) ) * e
			self:SetAlpha(self.alpha)
		end
		if self.playlist[self.apos].toscale then
			self.scale = self.scale - ((self.modelscale - self.playlist[self.apos].toscale) / (self.playlist[self.apos].time/1000) ) * e
			if self.scale < 0 then self.scale = 0.0001 end
			self:SetModelScale(self.scale)
		end
	end)--]]
	return mobstyle
end

local function CreateOptionsMenu()
	-- *****************************************************************
	-- 
	--  begin creating the Option Frames, this is mainly hardcoded
	--  because this allows me to place all the options as I want.
	--
	--  This API can be used to add your own tabs to our menu
	--
	--  To create a new tab please use the following function:
	--
	--    yourframe = DBM_GUI_Frame:CreateNewPanel("title", "option")
	--  
	--  You can use the DBM widgets by calling methods like
	--
	--    yourframe:CreateCheckButton("my first checkbox", true)
	--
	--  If you Set the second argument to true, the checkboxes will be
	--  placed automatically.
	--
	-- *****************************************************************


	DBM_GUI_Frame = DBM_GUI:CreateNewPanel(L.TabCategory_Options, "option")
	if usemodelframe then CreateAnimationFrame() end
	do
		----------------------------------------------
		--             General Options              --
		----------------------------------------------
		local generaloptions = DBM_GUI_Frame:CreateArea(L.General, nil, 230, true)
	
		local enabledbm = generaloptions:CreateCheckButton(L.EnableDBM, true)
		enabledbm:SetScript("OnShow",  function() enabledbm:SetChecked(DBM:IsEnabled()) end)
		enabledbm:SetScript("OnClick", function() if DBM:IsEnabled() then DBM:Disable() else DBM:Enable() end end)

		local MiniMapIcon				= generaloptions:CreateCheckButton(L.EnableMiniMapIcon, true)
		MiniMapIcon:SetScript("OnClick", function(self)
			DBM:ToggleMinimapButton()
			self:SetChecked( DBM.Options.ShowMinimapButton )
		end)
		MiniMapIcon:SetScript("OnShow", function(self)
			self:SetChecked( DBM.Options.ShowMinimapButton )
		end)
		local UseMasterVolume			= generaloptions:CreateCheckButton(L.UseMasterVolume, true, nil, "UseMasterVolume")
		local DisableCinematics			= generaloptions:CreateCheckButton(L.DisableCinematics, true, nil, "DisableCinematics")
		generaloptions:CreateCheckButton(L.SKT_Enabled, true, nil, "AlwaysShowSpeedKillTimer")

		local bmrange  = generaloptions:CreateButton(L.Button_RangeFrame)
		bmrange:SetPoint('TOPLEFT', MiniMapIcon, "BOTTOMLEFT", 0, -70)
		bmrange:SetScript("OnClick", function(self) 
			if DBM.RangeCheck:IsShown() then
				DBM.RangeCheck:Hide()
			else
				DBM.RangeCheck:Show()
			end
		end)

		local bmradar  = generaloptions:CreateButton(L.Button_RangeRadar)
		bmradar:SetPoint('TOPLEFT', bmrange, "TOPRIGHT", 0, 0)
		bmradar:SetScript("OnClick", function(self) 
			if DBMRangeCheckRadar and DBMRangeCheckRadar:IsShown() then
				DBMRangeCheckRadar:Hide()
			else
				DBM.RangeCheck:Show()
				DBMRangeCheckRadar:Show()
			end
		end)

		local bminfo  = generaloptions:CreateButton(L.Button_InfoFrame)
		bminfo:SetPoint('TOPLEFT', bmrange, "BOTTOMLEFT", 0, 0)
		bminfo:SetScript("OnClick", function(self) 
			if DBM.InfoFrame:IsShown() then
				DBM.InfoFrame:Hide()
			else
				DBM.InfoFrame:Show(5, "test")
			end
		end)

		local bmtestmode  = generaloptions:CreateButton(L.Button_TestBars)
		bmtestmode:SetPoint('TOPLEFT', bminfo, "TOPRIGHT", 0, 0)
		bmtestmode:SetScript("OnClick", function(self) DBM:DemoMode() end)

		local latencySlider = generaloptions:CreateSlider(L.Latency_Text, 50, 750, 5, 210)   -- (text , min_value , max_value , step , width)
     	latencySlider:SetPoint('BOTTOMLEFT', bminfo, "BOTTOMLEFT", 10, -35)
     	latencySlider:HookScript("OnShow", function(self) self:SetValue(DBM.Options.LatencyThreshold) end)
		latencySlider:HookScript("OnValueChanged", function(self) DBM.Options.LatencyThreshold = self:GetValue() end)

		--Model viewer options
		local modelarea = DBM_GUI_Frame:CreateArea(L.ModelOptions, nil, 85)
		modelarea.frame:SetPoint('TOPLEFT', generaloptions.frame, "BOTTOMLEFT", 0, -20)
		
		local enablemodels	= modelarea:CreateCheckButton(L.EnableModels,  true, nil, "EnableModels")--Needs someone smarter then me to hide/disable this option if not 4.0.6+

		local modelSounds = {
			{	text	= L.NoSound,			value	= "" },
			{	text	= L.ModelSoundShort,	value 	= "Short"},
			{	text	= L.ModelSoundLong,		value 	= "Long"},
		}
		local ModelSoundDropDown = generaloptions:CreateDropdown(L.ModelSoundOptions, modelSounds, 
		DBM.Options.ModelSoundValue, function(value) 
			DBM.Options.ModelSoundValue = value
		end
		)
		ModelSoundDropDown:SetPoint("TOPLEFT", modelarea.frame, "TOPLEFT", 0, -50)

		-- Pizza Timer (create your own timer menu)
		local pizzaarea = DBM_GUI_Frame:CreateArea(L.PizzaTimer_Headline, nil, 85)
		pizzaarea.frame:SetPoint('TOPLEFT', modelarea.frame, "BOTTOMLEFT", 0, -20)
	
		local textbox = pizzaarea:CreateEditBox(L.PizzaTimer_Title, "Pizza!", 175)
		local hourbox = pizzaarea:CreateEditBox(L.PizzaTimer_Hours, "0", 25)
		local minbox  = pizzaarea:CreateEditBox(L.PizzaTimer_Mins, "15", 25)
		local secbox  = pizzaarea:CreateEditBox(L.PizzaTimer_Secs, "0", 25)
	
		textbox:SetMaxLetters(17)
		textbox:SetPoint('TOPLEFT', 30, -25)
		hourbox:SetNumeric()
		hourbox:SetMaxLetters(2)
		hourbox:SetPoint('TOPLEFT', textbox, "TOPRIGHT", 20, 0)
		minbox:SetNumeric()
		minbox:SetMaxLetters(2)
		minbox:SetPoint('TOPLEFT', hourbox, "TOPRIGHT", 20, 0)
		secbox:SetNumeric()
		secbox:SetMaxLetters(2)
		secbox:SetPoint('TOPLEFT', minbox, "TOPRIGHT", 20, 0)

		local BcastTimer = pizzaarea:CreateCheckButton(L.PizzaTimer_BroadCast)
		local okbttn  = pizzaarea:CreateButton(L.PizzaTimer_ButtonStart);
		okbttn:SetPoint('TOPLEFT', textbox, "BOTTOMLEFT", -7, -8)
		BcastTimer:SetPoint("TOPLEFT", okbttn, "TOPRIGHT", 10, 3)

		pizzaarea.frame:SetScript("OnShow", function(self)
			if DBM:GetRaidRank() == 0 then
				BcastTimer:Hide()
			else
				BcastTimer:Show()
			end
		end)

		okbttn:SetScript("OnClick", function() 
			local time = (hourbox:GetNumber() * 60*60) + (minbox:GetNumber() * 60) + secbox:GetNumber()
			if textbox:GetText() and time > 0 then
				DBM:CreatePizzaTimer(time,  textbox:GetText(), BcastTimer:GetChecked())
			end
		end)

		-- END Pizza Timer
		--
		DBM_GUI_Frame:SetMyOwnHeight()
	end

	do
		-------------------------------------------
		--            General Warnings           --
		-------------------------------------------
		local generalWarningPanel = DBM_GUI_Frame:CreateNewPanel(L.Tab_GeneralMessages, "option")
		local generalCoreArea = generalWarningPanel:CreateArea(L.CoreMessages, nil, 120, true)
--		generalCoreArea:CreateCheckButton(L.ShowLoadMessage, true, nil, "ShowLoadMessage")--Only here as a note, this is commented out so inexperienced users don't disable this, but an option for advanced users who want to manually change the value from true to false
		generalCoreArea:CreateCheckButton(L.ShowPizzaMessage, true, nil, "ShowPizzaMessage")

		local generalMessagesArea = generalWarningPanel:CreateArea(L.CombatMessages, nil, 135, true)
		generalMessagesArea:CreateCheckButton(L.ShowEngageMessage, true, nil, "ShowEngageMessage")
		generalMessagesArea:CreateCheckButton(L.ShowKillMessage, true, nil, "ShowKillMessage")
		generalMessagesArea:CreateCheckButton(L.ShowWipeMessage, true, nil, "ShowWipeMessage")
		generalMessagesArea:CreateCheckButton(L.ShowRecoveryMessage, true, nil, "ShowRecoveryMessage")
		local generalWhispersArea = generalWarningPanel:CreateArea(L.WhisperMessages, nil, 135, true)
		generalWhispersArea:CreateCheckButton(L.AutoRespond, true, nil, "AutoRespond")
		generalWhispersArea:CreateCheckButton(L.EnableStatus, true, nil, "StatusEnabled")
		generalWhispersArea:CreateCheckButton(L.WhisperStats, true, nil, "WhisperStats")
		generalCoreArea:AutoSetDimension()
		generalMessagesArea:AutoSetDimension()
		generalWhispersArea:AutoSetDimension()
		generalWarningPanel:SetMyOwnHeight()
	end	

	do
		-----------------------------------------------
		--            Raid Warning Colors            --
		-----------------------------------------------
		local RaidWarningPanel = DBM_GUI_Frame:CreateNewPanel(L.Tab_RaidWarning, "option")
		local raidwarnoptions = RaidWarningPanel:CreateArea(L.RaidWarning_Header, nil, 200, true)

		local ShowWarningsInChat 	= raidwarnoptions:CreateCheckButton(L.ShowWarningsInChat, true, nil, "ShowWarningsInChat")
		local ShowFakedRaidWarnings 	= raidwarnoptions:CreateCheckButton(L.ShowFakedRaidWarnings,  true, nil, "ShowFakedRaidWarnings")
		local WarningIconLeft		= raidwarnoptions:CreateCheckButton(L.WarningIconLeft,  true, nil, "WarningIconLeft")
		local WarningIconRight 		= raidwarnoptions:CreateCheckButton(L.WarningIconRight,  true, nil, "WarningIconRight")

		-- RaidWarn Sound
		local Sounds = {
			{	text	= L.NoSound,	value	= "" },
			{	text	= "Default",	value 	= "Sound\\interface\\RaidWarning.wav", 		sound=true },
			{	text	= "Classic",	value 	= "Sound\\Doodad\\BellTollNightElf.wav", 	sound=true },
			{	text	= "Ding",	value 	= "Sound\\interface\\AlarmClockWarning3.wav", 	sound=true }
		}
		if GetSharedMedia3() then
			for k,v in next, GetSharedMedia3():HashTable("sound") do
				if k ~= "None" then -- lol ace .. playsound accepts empty strings.. quite.mp3 wtf!
					table.insert(Sounds, {text=k, value=v, sound=true})
				end
			end
		end
		local RaidWarnSoundDropDown = raidwarnoptions:CreateDropdown(L.RaidWarnSound, Sounds, 
			DBM.Options.RaidWarningSound, function(value) 
				DBM.Options.RaidWarningSound = value
			end
		)
		RaidWarnSoundDropDown:SetPoint("TOPLEFT", WarningIconRight, "BOTTOMLEFT", 20, -10)

		local countSounds = {
			{	text	= "Mosh (Male)",	value 	= "Mosh"},
			{	text	= "Corsica (Female)",value 	= "Corsica"},
		}
		local CountSoundDropDown = raidwarnoptions:CreateDropdown(L.CountdownVoice, countSounds, 
		DBM.Options.CountdownVoice, function(value) 
			DBM.Options.CountdownVoice = value
		end
		)
		CountSoundDropDown:SetPoint("TOPLEFT", WarningIconRight, "BOTTOMLEFT", 20, -50)

		--Raid Warning Colors 
		local raidwarncolors = RaidWarningPanel:CreateArea(L.RaidWarnColors, nil, 175, true)
	
		local color1 = raidwarncolors:CreateColorSelect(64)
		local color2 = raidwarncolors:CreateColorSelect(64)
		local color3 = raidwarncolors:CreateColorSelect(64)
		local color4 = raidwarncolors:CreateColorSelect(64)
		local color1text = raidwarncolors:CreateText(L.RaidWarnColor_1, 64)
		local color2text = raidwarncolors:CreateText(L.RaidWarnColor_2, 64)
		local color3text = raidwarncolors:CreateText(L.RaidWarnColor_3, 64)
		local color4text = raidwarncolors:CreateText(L.RaidWarnColor_4, 64)
		local color1reset = raidwarncolors:CreateButton(L.Reset, 60, 10, nil, GameFontNormalSmall)
		local color2reset = raidwarncolors:CreateButton(L.Reset, 60, 10, nil, GameFontNormalSmall)
		local color3reset = raidwarncolors:CreateButton(L.Reset, 60, 10, nil, GameFontNormalSmall)
		local color4reset = raidwarncolors:CreateButton(L.Reset, 60, 10, nil, GameFontNormalSmall)
	
		color1:SetPoint('TOPLEFT', 30, -20)
		color2:SetPoint('TOPLEFT', color1, "TOPRIGHT", 30, 0)
		color3:SetPoint('TOPLEFT', color2, "TOPRIGHT", 30, 0)
		color4:SetPoint('TOPLEFT', color3, "TOPRIGHT", 30, 0)
	
		local function UpdateColor(self)
			local r, g, b = self:GetColorRGB()
			self.textid:SetTextColor(r, g, b)
			DBM.Options.WarningColors[self.myid].r = r
			DBM.Options.WarningColors[self.myid].g = g
			DBM.Options.WarningColors[self.myid].b = b 
		end
		local function ResetColor(id, frame)
			return function(self)
				DBM.Options.WarningColors[id].r = DBM.DefaultOptions.WarningColors[id].r
				DBM.Options.WarningColors[id].g = DBM.DefaultOptions.WarningColors[id].g
				DBM.Options.WarningColors[id].b = DBM.DefaultOptions.WarningColors[id].b
				frame:SetColorRGB(DBM.Options.WarningColors[id].r, DBM.Options.WarningColors[id].g, DBM.Options.WarningColors[id].b)
			end
		end
		local function UpdateColorFrames(color, text, rset, id)
			color.textid = text
			color.myid = id
			color:SetScript("OnColorSelect", UpdateColor)
			color:SetColorRGB(DBM.Options.WarningColors[id].r, DBM.Options.WarningColors[id].g, DBM.Options.WarningColors[id].b)
			text:SetPoint('TOPLEFT', color, "BOTTOMLEFT", 3, -10) 
			text:SetJustifyH("CENTER")
			rset:SetPoint("TOP", text, "BOTTOM", 0, -5)
			rset:SetScript("OnClick", ResetColor(id, color))
		end
		UpdateColorFrames(color1, color1text, color1reset, 1)
		UpdateColorFrames(color2, color2text, color2reset, 2)
		UpdateColorFrames(color3, color3text, color3reset, 3)
		UpdateColorFrames(color4, color4text, color4reset, 4)
		
		local infotext = raidwarncolors:CreateText(L.InfoRaidWarning, 380, false, GameFontNormalSmall, "LEFT")
		infotext:SetPoint('BOTTOMLEFT', raidwarncolors.frame, "BOTTOMLEFT", 10, 10)
	
		local movemebutton = raidwarncolors:CreateButton(L.MoveMe, 100, 16)
		movemebutton:SetPoint('BOTTOMRIGHT', raidwarncolors.frame, "TOPRIGHT", 0, -1)
		movemebutton:SetNormalFontObject(GameFontNormalSmall);
		movemebutton:SetHighlightFontObject(GameFontNormalSmall);		
		do
			local anchorFrame
			local function hideme()
				anchorFrame:Hide()
			end
			movemebutton:SetScript("OnClick", function(self)
				DBM:Schedule(20, hideme)
				DBM.Bars:CreateBar(20, L.BarWhileMove)
				if not anchorFrame then
					anchorFrame = CreateFrame("Frame", "DBM_GUI_RaidWarnAnchor", UIParent)
					anchorFrame:SetWidth(32)
					anchorFrame:SetHeight(32)
					anchorFrame:EnableMouse(true)
					anchorFrame:SetPoint("BOTTOM", RaidWarningFrame, "TOP", 0, 1)
					anchorFrame.texture = anchorFrame:CreateTexture()
					anchorFrame.texture:SetTexture("Interface\\Addons\\DBM-GUI\\textures\\dot.blp")
					anchorFrame.texture:SetPoint("CENTER", anchorFrame, "CENTER", 0, 0)
					anchorFrame.texture:SetWidth(32)
					anchorFrame.texture:SetHeight(32)
					anchorFrame:SetScript("OnMouseDown", function(self) 
						RaidWarningFrame:SetMovable(1)
						RaidWarningFrame:StartMoving()
						DBM:Unschedule(hideme)
						DBM.Bars:CancelBar(L.BarWhileMove)
					end)
					anchorFrame:SetScript("OnMouseUp", function(self) 
						RaidWarningFrame:StopMovingOrSizing()
						RaidWarningFrame:SetMovable(0)
						local point, _, _, xOfs, yOfs = RaidWarningFrame:GetPoint(1)		
						DBM.Options.RaidWarningPosition.Point = point
						DBM.Options.RaidWarningPosition.X = xOfs
						DBM.Options.RaidWarningPosition.Y = yOfs	
						DBM:Schedule(15, hideme)
						DBM.Bars:CreateBar(15, L.BarWhileMove)
					end)
					do
						local elapsed = 10
						anchorFrame:SetScript("OnUpdate", function(self, e)
							elapsed = elapsed + e
							if elapsed > 5 then 
								elapsed = 0 
								RaidNotice_AddMessage(RaidWarningFrame, L.RaidWarnMessage, ChatTypeInfo["RAID_WARNING"])
							end
						end)
					end

					anchorFrame:Show()
				else
					if anchorFrame:IsShown() then
						anchorFrame:Hide()
					else
						anchorFrame:Show()
					end
				end	
			end)
		end
	end

	do
		--------------------------------------
		--            Bar Options           --
		--------------------------------------
		local BarSetupPanel = DBM_GUI_Frame:CreateNewPanel(L.BarSetup, "option")
		
		local BarSetup = BarSetupPanel:CreateArea(L.AreaTitle_BarSetup, nil, 240, true)

		local movemebutton = BarSetup:CreateButton(L.MoveMe, 100, 16)
		movemebutton:SetPoint('BOTTOMRIGHT', BarSetup.frame, "TOPRIGHT", 0, -1)
		movemebutton:SetNormalFontObject(GameFontNormalSmall);
		movemebutton:SetHighlightFontObject(GameFontNormalSmall);		
		movemebutton:SetScript("OnClick", function() DBM.Bars:ShowMovableBar() end)

		local maindummybar = DBM.Bars:CreateDummyBar()
		maindummybar.frame:SetParent(BarSetup.frame)
		maindummybar.frame:SetPoint('BOTTOM', BarSetup.frame, "TOP", 0, -65)
		maindummybar.frame:SetScript("OnUpdate", function(self, elapsed) maindummybar:Update(elapsed) end)
		do 
			-- little hook to prevent this bar from changing size/scale
			local old = maindummybar.ApplyStyle 
			function maindummybar:ApplyStyle(...) 
				old(self, ...) 
				self.frame:SetWidth(183)
				self.frame:SetScale(0.9)
				_G[self.frame:GetName().."Bar"]:SetWidth(183)
			end 
		end

		local iconleft = BarSetup:CreateCheckButton(L.BarIconLeft, nil, nil, nil, "IconLeft")
		local iconright = BarSetup:CreateCheckButton(L.BarIconRight, nil, true, nil, "IconRight")
		iconleft:SetPoint('BOTTOMRIGHT', maindummybar.frame, "TOPLEFT", -5, 5)
		iconright:SetPoint('BOTTOMLEFT', maindummybar.frame, "TOPRIGHT", 5, 5)

		local color1 = BarSetup:CreateColorSelect(64)
		local color2 = BarSetup:CreateColorSelect(64)
		color1:SetPoint('TOPLEFT', BarSetup.frame, "TOPLEFT", 20, -80)
		color2:SetPoint('TOPLEFT', color1, "TOPRIGHT", 20, 0)

		local color1reset = BarSetup:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		local color2reset = BarSetup:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color1reset:SetPoint('TOP', color1, "BOTTOM", 5, -10)
		color2reset:SetPoint('TOP', color2, "BOTTOM", 5, -10)
		color1reset:SetScript("OnClick", function(self) 
			color1:SetColorRGB(DBM.Bars:GetDefaultOption("StartColorR"), DBM.Bars:GetDefaultOption("StartColorG"), DBM.Bars:GetDefaultOption("StartColorB"))
		end)
		color2reset:SetScript("OnClick", function(self) 
			color2:SetColorRGB(DBM.Bars:GetDefaultOption("EndColorR"), DBM.Bars:GetDefaultOption("EndColorG"), DBM.Bars:GetDefaultOption("EndColorB"))
		end)

		local color1text = BarSetup:CreateText(L.BarStartColor, 80)
		local color2text = BarSetup:CreateText(L.BarEndColor, 80)
		color1text:SetPoint("BOTTOM", color1, "TOP", 0, 4)
		color2text:SetPoint("BOTTOM", color2, "TOP", 0, 4)
		color1:SetScript("OnShow", function(self) self:SetColorRGB(
								DBM.Bars:GetOption("StartColorR"),
								DBM.Bars:GetOption("StartColorG"),
								DBM.Bars:GetOption("StartColorB"))
								color1text:SetTextColor(
									DBM.Bars:GetOption("StartColorR"),
									DBM.Bars:GetOption("StartColorG"),
									DBM.Bars:GetOption("StartColorB")
								)
							  end)
		color2:SetScript("OnShow", function(self) self:SetColorRGB(
								DBM.Bars:GetOption("EndColorR"),
								DBM.Bars:GetOption("EndColorG"),
								DBM.Bars:GetOption("EndColorB"))
								color2text:SetTextColor(
									DBM.Bars:GetOption("EndColorR"),
									DBM.Bars:GetOption("EndColorG"),
									DBM.Bars:GetOption("EndColorB")
								)
							  end)
		color1:SetScript("OnColorSelect", function(self)
							DBM.Bars:SetOption("StartColorR", select(1, self:GetColorRGB()))
							DBM.Bars:SetOption("StartColorG", select(2, self:GetColorRGB()))
							DBM.Bars:SetOption("StartColorB", select(3, self:GetColorRGB()))
							color1text:SetTextColor(self:GetColorRGB())
						  end)
		color2:SetScript("OnColorSelect", function(self)
							DBM.Bars:SetOption("EndColorR", select(1, self:GetColorRGB()))
							DBM.Bars:SetOption("EndColorG", select(2, self:GetColorRGB()))
							DBM.Bars:SetOption("EndColorB", select(3, self:GetColorRGB()))
							color2text:SetTextColor(self:GetColorRGB())
						  end)					  

		local Textures = { 
			{	text	= "Default",	value 	= "Interface\\AddOns\\DBM-Core\\textures\\default.tga", 	texture	= "Interface\\AddOns\\DBM-Core\\textures\\default.tga"	},
			{	text	= "Blizzad",	value 	= "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar", 	texture	= "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar"	},
			{	text	= "Glaze",	value 	= "Interface\\AddOns\\DBM-Core\\textures\\glaze.tga", 		texture	= "Interface\\AddOns\\DBM-Core\\textures\\glaze.tga"	},
			{	text	= "Otravi",	value 	= "Interface\\AddOns\\DBM-Core\\textures\\otravi.tga", 		texture	= "Interface\\AddOns\\DBM-Core\\textures\\otravi.tga"	},
			{	text	= "Smooth",	value 	= "Interface\\AddOns\\DBM-Core\\textures\\smooth.tga", 		texture	= "Interface\\AddOns\\DBM-Core\\textures\\smooth.tga"	}
		}
		if GetSharedMedia3() then
			for k,v in next, GetSharedMedia3():HashTable("statusbar") do
				table.insert(Textures, {text=k, value=v, texture=v})
			end
		end
		local TextureDropDown = BarSetup:CreateDropdown(L.BarTexture, Textures, 
			DBM.Bars:GetOption("Texture"), function(value) 
				DBM.Bars:SetOption("Texture", value) 
			end
		)
		TextureDropDown:SetPoint("TOPLEFT", BarSetup.frame, "TOPLEFT", 210, -80)

		local ExpandUpwards = BarSetup:CreateCheckButton(L.ExpandUpwards, false, nil, nil, "ExpandUpwards")
		ExpandUpwards:SetPoint("TOPLEFT", TextureDropDown, "BOTTOMLEFT", 0, -10)

		local FillUpBars = BarSetup:CreateCheckButton(L.FillUpBars, false, nil, nil, "FillUpBars")
		FillUpBars:SetPoint("TOP", ExpandUpwards, "BOTTOM", 0, 5)
		
		local ClickThrough = BarSetup:CreateCheckButton(L.ClickThrough, false, nil, nil, "ClickThrough")
		ClickThrough:SetPoint("TOPLEFT", color1reset, "BOTTOMLEFT", -7, -5)
		
		-- Functions for the next 2 Areas
		local function createDBTOnShowHandler(option)
			return function(self)
				self:SetValue(DBM.Bars:GetOption(option))
			end
		end
		local function createDBTOnValueChangedHandler(option)
			return function(self)
				DBM.Bars:SetOption(option, self:GetValue())
			end
		end

		local Fonts = { 
			{	text	= "Default",		value 	= STANDARD_TEXT_FONT,			font = STANDARD_TEXT_FONT		},
			{	text	= "Arial",			value 	= "Fonts\\ARIALN.TTF",			font = "Fonts\\ARIALN.TTF"		},
			{	text	= "Skurri",			value 	= "Fonts\\skurri.ttf",			font = "Fonts\\skurri.ttf"		},
			{	text	= "Morpheus",		value 	= "Fonts\\MORPHEUS.ttf",		font = "Fonts\\MORPHEUS.ttf"	}
		}
		if GetSharedMedia3() then
			for k,v in next, GetSharedMedia3():HashTable("font") do
				table.insert(Fonts, {text=k, value=v, font=v})
			end
		end
		local FontDropDown = BarSetup:CreateDropdown(L.Bar_Font, Fonts, DBM.Bars:GetOption("Font"), 
			function(value) 
				DBM.Bars:SetOption("Font", value) 
			end)
		FontDropDown:SetPoint("TOPLEFT", BarSetup.frame, "TOPLEFT", 210, -200)

		local FontSizeSlider = BarSetup:CreateSlider(L.Bar_FontSize, 7, 18, 1)
		FontSizeSlider:SetPoint("TOPLEFT", BarSetup.frame, "TOPLEFT", 20, -202)
		FontSizeSlider:SetScript("OnShow", createDBTOnShowHandler("FontSize"))
		FontSizeSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("FontSize"))

		-----------------------
		-- Small Bar Options --
		-----------------------
		local BarSetupSmall = BarSetupPanel:CreateArea(L.AreaTitle_BarSetupSmall, nil, 160, true)

		local smalldummybar = DBM.Bars:CreateDummyBar()
		smalldummybar.frame:SetParent(BarSetupSmall.frame)
		smalldummybar.frame:SetPoint('BOTTOM', BarSetupSmall.frame, "TOP", 0, -35)
		smalldummybar.frame:SetScript("OnUpdate", function(self, elapsed) smalldummybar:Update(elapsed) end)

		local BarWidthSlider = BarSetup:CreateSlider(L.Slider_BarWidth, 100, 325, 1)
		BarWidthSlider:SetPoint("TOPLEFT", BarSetupSmall.frame, "TOPLEFT", 20, -90)
		BarWidthSlider:SetScript("OnShow", createDBTOnShowHandler("Width"))
		BarWidthSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("Width"))

		local BarScaleSlider = BarSetup:CreateSlider(L.Slider_BarScale, 0.75, 2, 0.05)
		BarScaleSlider:SetPoint("TOPLEFT", BarWidthSlider, "BOTTOMLEFT", 0, -10)
		BarScaleSlider:SetScript("OnShow", createDBTOnShowHandler("Scale"))
		BarScaleSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("Scale"))

		local BarOffsetXSlider = BarSetup:CreateSlider(L.Slider_BarOffSetX, -50, 50, 1)
		BarOffsetXSlider:SetPoint("TOPLEFT", BarSetupSmall.frame, "TOPLEFT", 220, -90)
		BarOffsetXSlider:SetScript("OnShow", createDBTOnShowHandler("BarXOffset"))
		BarOffsetXSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("BarXOffset"))

		local BarOffsetYSlider = BarSetup:CreateSlider(L.Slider_BarOffSetY, -5, 25, 1)
		BarOffsetYSlider:SetPoint("TOPLEFT", BarOffsetXSlider, "BOTTOMLEFT", 0, -10)
		BarOffsetYSlider:SetScript("OnShow", createDBTOnShowHandler("BarYOffset"))
		BarOffsetYSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("BarYOffset"))
		
		-----------------------
		-- Huge Bar Options --
		-----------------------
		local BarSetupHuge = BarSetupPanel:CreateArea(L.AreaTitle_BarSetupHuge, nil, 175, true)
	
		local enablebar = BarSetupHuge:CreateCheckButton(L.EnableHugeBar, true, nil, nil, "HugeBarsEnabled")

		local hugedummybar = DBM.Bars:CreateDummyBar()
		hugedummybar.frame:SetParent(BarSetupSmall.frame)
		hugedummybar.frame:SetPoint('BOTTOM', BarSetupHuge.frame, "TOP", 0, -50)
		hugedummybar.frame:SetScript("OnUpdate", function(self, elapsed) hugedummybar:Update(elapsed) end)
		hugedummybar.enlarged = true                                
		hugedummybar:ApplyStyle()     

		local HugeBarWidthSlider = BarSetupHuge:CreateSlider(L.Slider_BarWidth, 100, 325, 1)
		HugeBarWidthSlider:SetPoint("TOPLEFT", BarSetupHuge.frame, "TOPLEFT", 20, -105)
		HugeBarWidthSlider:SetScript("OnShow", createDBTOnShowHandler("HugeWidth"))
		HugeBarWidthSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("HugeWidth"))

		local HugeBarScaleSlider = BarSetupHuge:CreateSlider(L.Slider_BarScale, 0.75, 2, 0.05)
		HugeBarScaleSlider:SetPoint("TOPLEFT", HugeBarWidthSlider, "BOTTOMLEFT", 0, -10)
		HugeBarScaleSlider:SetScript("OnShow", createDBTOnShowHandler("HugeScale"))
		HugeBarScaleSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("HugeScale"))

		local HugeBarOffsetXSlider = BarSetupHuge:CreateSlider(L.Slider_BarOffSetX, -50, 50, 1)
		HugeBarOffsetXSlider:SetPoint("TOPLEFT", BarSetupHuge.frame, "TOPLEFT", 220, -105)
		HugeBarOffsetXSlider:SetScript("OnShow", createDBTOnShowHandler("HugeBarXOffset"))
		HugeBarOffsetXSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("HugeBarXOffset"))

		local HugeBarOffsetYSlider = BarSetupHuge:CreateSlider(L.Slider_BarOffSetY, -5, 25, 1)
		HugeBarOffsetYSlider:SetPoint("TOPLEFT", HugeBarOffsetXSlider, "BOTTOMLEFT", 0, -10)
		HugeBarOffsetYSlider:SetScript("OnShow", createDBTOnShowHandler("HugeBarYOffset"))
		HugeBarOffsetYSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("HugeBarYOffset"))


		BarSetupPanel:SetMyOwnHeight() 
	end

	do
		local specPanel = DBM_GUI_Frame:CreateNewPanel(L.Panel_SpecWarnFrame, "option")
		local specArea = specPanel:CreateArea(L.Area_SpecWarn, nil, 250, true)
		specArea:CreateCheckButton(L.SpecWarn_Enabled, true, nil, "ShowSpecialWarnings")
		specArea:CreateCheckButton(L.SpecWarn_LHFrame, true, nil, "ShowLHFrame")

		local showbutton = specArea:CreateButton(L.SpecWarn_DemoButton, 120, 16)
		showbutton:SetPoint('TOPRIGHT', specArea.frame, "TOPRIGHT", -5, -5)
		showbutton:SetNormalFontObject(GameFontNormalSmall);
		showbutton:SetHighlightFontObject(GameFontNormalSmall);		
		showbutton:SetScript("OnClick", function() DBM:ShowTestSpecialWarning() end)

		local movemebutton = specArea:CreateButton(L.SpecWarn_MoveMe, 120, 16)
		movemebutton:SetPoint('TOPRIGHT', showbutton, "BOTTOMRIGHT", 0, -5)
		movemebutton:SetNormalFontObject(GameFontNormalSmall);
		movemebutton:SetHighlightFontObject(GameFontNormalSmall);		
		movemebutton:SetScript("OnClick", function() DBM:MoveSpecialWarning() end)

		local fontSizeSlider = specArea:CreateSlider(L.SpecWarn_FontSize, 8, 40, 1)
		fontSizeSlider:SetPoint("TOPLEFT", specArea.frame, "TOPLEFT", 20, -75)
		do
			local firstshow = true
			fontSizeSlider:SetScript("OnShow", function(self) 
					firstshow = true
					self:SetValue(DBM.Options.SpecialWarningFontSize) 
			end)
			fontSizeSlider:HookScript("OnValueChanged", function(self)
					if firstshow then firstshow = false; return end
					DBM.Options.SpecialWarningFontSize = self:GetValue()
					DBM:UpdateSpecialWarningOptions()
					DBM:ShowTestSpecialWarning()
			end)
		end

		local color1 = specArea:CreateColorSelect(64)
		color1:SetPoint('TOPLEFT', specArea.frame, "TOPLEFT", 20, -125)		
		local color1text = specArea:CreateText(L.SpecWarn_FontColor, 80)
		color1text:SetPoint("BOTTOM", color1, "TOP", 5, 4)
		local color1reset = specArea:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color1reset:SetPoint('TOP', color1, "BOTTOM", 5, -10)
		color1reset:SetScript("OnClick", function(self)
				DBM.Options.SpecialWarningFontColor[1] = DBM.DefaultOptions.SpecialWarningFontColor[1]
				DBM.Options.SpecialWarningFontColor[2] = DBM.DefaultOptions.SpecialWarningFontColor[2]
				DBM.Options.SpecialWarningFontColor[3] = DBM.DefaultOptions.SpecialWarningFontColor[3]
				color1:SetColorRGB(DBM.Options.SpecialWarningFontColor[1], DBM.Options.SpecialWarningFontColor[2], DBM.Options.SpecialWarningFontColor[3])
				DBM:UpdateSpecialWarningOptions()
				DBM:ShowTestSpecialWarning()
		end)
		do
			local firstshow = true
			color1:SetScript("OnShow", function(self)
					firstshow = true
					self:SetColorRGB(DBM.Options.SpecialWarningFontColor[1], DBM.Options.SpecialWarningFontColor[2], DBM.Options.SpecialWarningFontColor[3])
			end)
			color1:SetScript("OnColorSelect", function(self)
					if firstshow then firstshow = false; return end
					DBM.Options.SpecialWarningFontColor[1] = select(1, self:GetColorRGB())
					DBM.Options.SpecialWarningFontColor[2] = select(2, self:GetColorRGB())
					DBM.Options.SpecialWarningFontColor[3] = select(3, self:GetColorRGB())
					color1text:SetTextColor(self:GetColorRGB())
					DBM:UpdateSpecialWarningOptions()
					DBM:ShowTestSpecialWarning()
			end)
		end

		local Fonts = { 
			{	text	= "Default",		value 	= STANDARD_TEXT_FONT,			font = STANDARD_TEXT_FONT		},
			{	text	= "Arial",			value 	= "Fonts\\ARIALN.TTF",			font = "Fonts\\ARIALN.TTF"		},
			{	text	= "Skurri",			value 	= "Fonts\\skurri.ttf",			font = "Fonts\\skurri.ttf"		},
			{	text	= "Morpheus",		value 	= "Fonts\\MORPHEUS.ttf",		font = "Fonts\\MORPHEUS.ttf"	}
		}
		if GetSharedMedia3() then
			for k,v in next, GetSharedMedia3():HashTable("font") do
				table.insert(Fonts, {text=k, value=v, font=v})
			end
		end
		local FontDropDown = specArea:CreateDropdown(L.SpecWarn_FontType, Fonts, DBM.Options.SpecialWarningFont, 
			function(value) 
				DBM.Options.SpecialWarningFont = value
				DBM:UpdateSpecialWarningOptions()
				DBM:ShowTestSpecialWarning()
			end
		)
		FontDropDown:SetPoint("TOPLEFT", specArea.frame, "TOPLEFT", 130, -120)

		-- SpecialWarn Sound
		local Sounds = {
			{	text	= L.NoSound,		value	= "" },
			{	text	= "Default",		value 	= "Sound\\Spells\\PVPFlagTaken.wav", 		sound=true },
			{	text	= "Beware!",		value 	= "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav", 		sound=true },--Great sound, short and to the point. Best pick for a secondary default!
			{	text	= "NotPrepared",	value 	= "Sound\\Creature\\Illidan\\BLACK_Illidan_04.wav", 		sound=true },--Maybe a bit long? wouldn't recommend it as a default, but good for customizing.
			{	text	= "NightElfBell",	value 	= "Sound\\Doodad\\BellTollNightElf.wav", 	sound=true }
		}
		if GetSharedMedia3() then
			for k,v in next, GetSharedMedia3():HashTable("sound") do
				if k ~= "None" then -- lol ace .. playsound accepts empty strings.. quite.mp3 wtf!
					table.insert(Sounds, {text=k, value=v, sound=true})
				end
			end
		end
		local SpecialWarnSoundDropDown = specArea:CreateDropdown(L.SpecialWarnSound, Sounds, 
			DBM.Options.SpecialWarningSound, function(value) 
				DBM.Options.SpecialWarningSound = value
			end
		)
		SpecialWarnSoundDropDown:SetPoint("TOPLEFT", specArea.frame, "TOPLEFT", 130, -160)
		
		local SpecialWarnSoundDropDown2 = specArea:CreateDropdown(L.SpecialWarnSound2, Sounds, 
			DBM.Options.SpecialWarningSound2, function(value) 
				DBM.Options.SpecialWarningSound2 = value
			end
		)
		SpecialWarnSoundDropDown2:SetPoint("TOPLEFT", specArea.frame, "TOPLEFT", 130, -200)


		local resetbutton = specArea:CreateButton(L.SpecWarn_ResetMe, 120, 16)
		resetbutton:SetPoint('BOTTOMRIGHT', specArea.frame, "BOTTOMRIGHT", -5, 5)
		resetbutton:SetNormalFontObject(GameFontNormalSmall);
		resetbutton:SetHighlightFontObject(GameFontNormalSmall);		
		resetbutton:SetScript("OnClick", function()
				DBM.Options.SpecialWarningFont = DBM.DefaultOptions.SpecialWarningFont
				DBM.Options.SpecialWarningFontSize = DBM.DefaultOptions.SpecialWarningFontSize
				DBM.Options.SpecialWarningFontColor[1] = DBM.DefaultOptions.SpecialWarningFontColor[1]
				DBM.Options.SpecialWarningFontColor[2] = DBM.DefaultOptions.SpecialWarningFontColor[2]
				DBM.Options.SpecialWarningFontColor[3] = DBM.DefaultOptions.SpecialWarningFontColor[3]
				DBM.Options.SpecialWarningPoint = DBM.DefaultOptions.SpecialWarningPoint
				DBM.Options.SpecialWarningX = DBM.DefaultOptions.SpecialWarningX
				DBM.Options.SpecialWarningY = DBM.DefaultOptions.SpecialWarningY
				color1:SetColorRGB(DBM.Options.SpecialWarningFontColor[1], DBM.Options.SpecialWarningFontColor[2], DBM.Options.SpecialWarningFontColor[3])
				fontSizeSlider:SetValue(DBM.DefaultOptions.SpecialWarningFontSize)
				DBM:UpdateSpecialWarningOptions()
		end)
	end

	do
		local hpPanel = DBM_GUI_Frame:CreateNewPanel(L.Panel_HPFrame, "option")
		local hpArea = hpPanel:CreateArea(L.Area_HPFrame, nil, 150, true)
		hpArea:CreateCheckButton(L.HP_Enabled, true, nil, "AlwaysShowHealthFrame")
		local growbttn = hpArea:CreateCheckButton(L.HP_GrowUpwards, true)
		growbttn:SetScript("OnShow",  function(self) self:SetChecked(DBM.Options.HealthFrameGrowUp) end)
		growbttn:SetScript("OnClick", function(self) 
				DBM.Options.HealthFrameGrowUp = not not self:GetChecked() 
				DBM.BossHealth:UpdateSettings()
		end)


		local BarWidthSlider = hpArea:CreateSlider(L.BarWidth, 150, 275, 1)
		BarWidthSlider:SetPoint("TOPLEFT", hpArea.frame, "TOPLEFT", 20, -75)
		BarWidthSlider:SetScript("OnShow", function(self) self:SetValue(DBM.Options.HealthFrameWidth or 100) end)
		BarWidthSlider:HookScript("OnValueChanged", function(self) 
				DBM.Options.HealthFrameWidth = self:GetValue()
				DBM.BossHealth:UpdateSettings()
		end)

		local resetbutton = hpArea:CreateButton(L.Reset, 120, 16)
		resetbutton:SetPoint('BOTTOMRIGHT', hpArea.frame, "BOTTOMRIGHT", -5, 5)
		resetbutton:SetNormalFontObject(GameFontNormalSmall);
		resetbutton:SetHighlightFontObject(GameFontNormalSmall);		
		resetbutton:SetScript("OnClick", function()
				DBM.Options.HPFramePoint = DBM.DefaultOptions.HPFramePoint
				DBM.Options.HPFrameX = DBM.DefaultOptions.HPFrameX
				DBM.Options.HPFrameY = DBM.DefaultOptions.HPFrameY
				DBM.Options.HealthFrameGrowUp = DBM.DefaultOptions.HealthFrameGrowUp
				DBM.Options.HealthFrameWidth = DBM.DefaultOptions.HealthFrameWidth
				DBM.BossHealth:UpdateSettings()
		end)		

		local function createDummyFunc(i) return function() return i end end
		local showbutton = hpArea:CreateButton(L.HP_ShowDemo, 120, 16)
		showbutton:SetPoint('BOTTOM', resetbutton, "TOP", 0, 5)
		showbutton:SetNormalFontObject(GameFontNormalSmall);
		showbutton:SetHighlightFontObject(GameFontNormalSmall);		
		showbutton:SetScript("OnClick", function()
				DBM.BossHealth:Show("Health Frame")
				DBM.BossHealth:AddBoss(createDummyFunc(25), "TestBoss 1")
				DBM.BossHealth:AddBoss(createDummyFunc(50), "TestBoss 2")
				DBM.BossHealth:AddBoss(createDummyFunc(75), "TestBoss 3")
				DBM.BossHealth:AddBoss(createDummyFunc(100), "TestBoss 4")			
		end)
	end

	do
		local spamPanel = DBM_GUI_Frame:CreateNewPanel(L.Panel_SpamFilter, "option")
		local spamOutArea = spamPanel:CreateArea(L.Area_SpamFilter_Outgoing, nil, 120, true)
		spamOutArea:CreateCheckButton(L.SpamBlockNoShowAnnounce, true, nil, "DontShowBossAnnounces")
		spamOutArea:CreateCheckButton(L.SpamBlockNoSendAnnounce, true, nil, "DontSendBossAnnounces")
		spamOutArea:CreateCheckButton(L.SpamBlockNoSendWhisper, true, nil, "DontSendBossWhispers")
		spamOutArea:CreateCheckButton(L.SpamBlockNoSetIcon, true, nil, "DontSetIcons")

		local spamArea = spamPanel:CreateArea(L.Area_SpamFilter, nil, 135, true)
		spamArea:CreateCheckButton(L.HideBossEmoteFrame, true, nil, "HideBossEmoteFrame")
		spamArea:CreateCheckButton(L.SpamBlockRaidWarning, true, nil, "SpamBlockRaidWarning")
		spamArea:CreateCheckButton(L.SpamBlockBossWhispers, true, nil, "SpamBlockBossWhispers")
		spamArea:CreateCheckButton(L.BlockVersionUpdateNotice, true, nil, "BlockVersionUpdateNotice")
		if BigBrother and type(BigBrother.ConsumableCheck) == "function" then
			spamArea:CreateCheckButton(L.ShowBigBrotherOnCombatStart, true, nil, "ShowBigBrotherOnCombatStart")
			spamArea:CreateCheckButton(L.BigBrotherAnnounceToRaid, true, nil, "BigBrotherAnnounceToRaid")
		end
		spamArea:AutoSetDimension()
		spamOutArea:AutoSetDimension()
		spamPanel:SetMyOwnHeight()
	end

	-- Set Revision // please don't translate this!
	DBM_GUI_OptionsFrameRevision:SetText("Version: "..DBM.DisplayVersion.." - Core: r"..DBM.Revision.." - Gui: r"..revision)
	DBM_GUI_OptionsFrameTranslation:SetText("Translated by: "..L.TranslationBy)
end
DBM:RegisterOnGuiLoadCallback(CreateOptionsMenu, 1)

do
	local function OnShowGetStats(stats, party, bossvalue1, bossvalue2, bossvalue3, boss25value1, boss25value2, boss25value3, bossvalue4, bossvalue5, bossvalue6, boss25value4, boss25value5, boss25value6)
		return function(self)
			bossvalue1:SetText( stats.normalKills )
			bossvalue2:SetText( stats.normalPulls - stats.normalKills )
			bossvalue3:SetText( stats.normalBestTime and ("%d:%02d"):format(math.floor(stats.normalBestTime / 60), stats.normalBestTime % 60) or "-" )
			boss25value1:SetText( stats.normal25Kills )
			boss25value2:SetText( stats.normal25Pulls - stats.normal25Kills )
			boss25value3:SetText( stats.normal25BestTime and ("%d:%02d"):format(math.floor(stats.normal25BestTime / 60), stats.normal25BestTime % 60) or "-" )
			bossvalue4:SetText( stats.heroicKills )
			bossvalue5:SetText( stats.heroicPulls-stats.heroicKills )
			bossvalue6:SetText( stats.heroicBestTime and ("%d:%02d"):format(math.floor(stats.heroicBestTime / 60), stats.heroicBestTime % 60) or "-" )
			boss25value4:SetText( stats.heroic25Kills )
			boss25value5:SetText( stats.heroic25Pulls-stats.heroic25Kills )
			boss25value6:SetText( stats.heroic25BestTime and ("%d:%02d"):format(math.floor(stats.heroic25BestTime / 60), stats.heroic25BestTime % 60) or "-" )
			if party then
				boss25value1:SetText( stats.heroicKills )
				boss25value2:SetText( stats.heroicPulls-stats.heroicKills )
				boss25value3:SetText( stats.heroicBestTime and ("%d:%02d"):format(math.floor(stats.heroicBestTime / 60), stats.heroicBestTime % 60) or "-" )
			end
		end
	end

	local function CreateBossModTab(addon, panel, subtab)
		if not panel then 
			error("Panel is nil", 2)
		end
		if addon.modId == "DBM-PvP" then return	end -- no need to create a stats page for PvP modules

		local ptext = panel:CreateText(L.BossModLoaded:format(subtab and addon.subTabs[subtab] or addon.name), nil, nil, GameFontNormal)
		ptext:SetPoint('TOPLEFT', panel.frame, "TOPLEFT", 10, -10)

		local bossstats = 0 
		local area = panel:CreateArea(nil, panel.frame:GetWidth() - 20, 0)
		area.frame:SetPoint("TOPLEFT", 10, -25)
		area.onshowcall = {}

		for _, mod in ipairs(DBM.Mods) do
			if mod.modId == addon.modId and (not subtab or subtab == mod.subTab) then
				local party = false
				bossstats = bossstats + 1
				local Boss 		= area:CreateText(mod.localization.general.name, nil, nil, GameFontHighlight, "LEFT")
				local Boss10		= area:CreateText(L.Statistic_10Man, nil, nil, GameFontHighlightSmall, "LEFT")				
				local bossstat1		= area:CreateText(L.Statistic_Kills, nil, nil, GameFontNormalSmall, "LEFT")
				local bossstat2		= area:CreateText(L.Statistic_Wipes, nil, nil, GameFontNormalSmall, "LEFT")
				local bossstat3		= area:CreateText(L.Statistic_BestKill, nil, nil, GameFontNormalSmall, "LEFT")
				local Heroic10		= area:CreateText(L.Statistic_Heroic, nil, nil, GameFontDisableSmall, "LEFT")
				local bossstat4	= 	area:CreateText(L.Statistic_Kills, nil, nil, GameFontNormalSmall, "LEFT")
				local bossstat5	= 	area:CreateText(L.Statistic_Wipes, nil, nil, GameFontNormalSmall, "LEFT")
				local bossstat6	= 	area:CreateText(L.Statistic_BestKill, nil, nil, GameFontNormalSmall, "LEFT")

				local Heroic	 	= area:CreateText(L.Statistic_Heroic, nil, nil, GameFontDisableSmall, "LEFT")
				local Boss25		= area:CreateText(L.Statistic_25Man, nil, nil, GameFontHighlightSmall, "LEFT")
				local boss25stat1	= area:CreateText(L.Statistic_Kills, nil, nil, GameFontNormalSmall, "LEFT")
				local boss25stat2	= area:CreateText(L.Statistic_Wipes, nil, nil, GameFontNormalSmall, "LEFT")
				local boss25stat3	= area:CreateText(L.Statistic_BestKill, nil, nil, GameFontNormalSmall, "LEFT")
				local Heroic25		= area:CreateText(L.Statistic_Heroic, nil, nil, GameFontDisableSmall, "LEFT")
				local boss25stat4	= area:CreateText(L.Statistic_Kills, nil, nil, GameFontNormalSmall, "LEFT")
				local boss25stat5	= area:CreateText(L.Statistic_Wipes, nil, nil, GameFontNormalSmall, "LEFT")
				local boss25stat6	= area:CreateText(L.Statistic_BestKill, nil, nil, GameFontNormalSmall, "LEFT")

				local bossvalue1	= area:CreateText(mod.stats.normalKills, nil, nil, GameFontNormalSmall, "LEFT")
				local bossvalue2	= area:CreateText((mod.stats.normalPulls-mod.stats.normalKills), nil, nil, GameFontNormalSmall, "LEFT")
				local bossvalue3	= area:CreateText("0:00:00", nil, nil, GameFontNormalSmall, "LEFT")
				local bossvalue4	= area:CreateText(mod.stats.heroicKills, nil, nil, GameFontNormalSmall, "LEFT")
				local bossvalue5	= area:CreateText((mod.stats.heroicPulls-mod.stats.normal25Kills), nil, nil, GameFontNormalSmall, "LEFT")
				local bossvalue6	= area:CreateText("0:00:00", nil, nil, GameFontNormalSmall, "LEFT")

				local boss25value1	= area:CreateText(mod.stats.normal25Kills, nil, nil, GameFontNormalSmall, "LEFT")
				local boss25value2	= area:CreateText((mod.stats.normal25Pulls-mod.stats.heroicKills), nil, nil, GameFontNormalSmall, "LEFT")
				local boss25value3	= area:CreateText("0:00:00", nil, nil, GameFontNormalSmall, "LEFT")
				local boss25value4	= area:CreateText(mod.stats.heroic25Kills, nil, nil, GameFontNormalSmall, "LEFT")
				local boss25value5	= area:CreateText((mod.stats.heroic25Pulls-mod.stats.heroic25Kills), nil, nil, GameFontNormalSmall, "LEFT")
				local boss25value6	= area:CreateText("0:00:00", nil, nil, GameFontNormalSmall, "LEFT")

				Boss:SetPoint("TOPLEFT", area.frame, "TOPLEFT", 10, -10-(L.FontHeight*6*(bossstats-1)))
				Boss10:SetPoint("TOPLEFT", Boss, "BOTTOMLEFT", 20, -5)
				bossstat1:SetPoint("TOPLEFT", Boss10, "BOTTOMLEFT", 20, -5)
				bossstat2:SetPoint("TOPLEFT", bossstat1, "BOTTOMLEFT", 0, -5)
				bossstat3:SetPoint("TOPLEFT", bossstat2, "BOTTOMLEFT", 0, -5)

				Heroic:SetPoint("LEFT", Boss, "LEFT", 220, 0)
				Boss25:SetPoint("LEFT", Boss10, "LEFT", 220, 0)
				boss25stat1:SetPoint("LEFT", bossstat1, "LEFT", 220, 0)
				boss25stat2:SetPoint("LEFT", bossstat2, "LEFT", 220, 0)
				boss25stat3:SetPoint("LEFT", bossstat3, "LEFT", 220, 0)

				bossvalue1:SetPoint("TOPLEFT", bossstat1, "TOPLEFT", 80, 0)
				bossvalue2:SetPoint("TOPLEFT", bossstat2, "TOPLEFT", 80, 0)
				bossvalue3:SetPoint("TOPLEFT", bossstat3, "TOPLEFT", 80, 0)
				
				boss25value1:SetPoint("TOPLEFT", boss25stat1, "TOPLEFT", 80, 0)
				boss25value2:SetPoint("TOPLEFT", boss25stat2, "TOPLEFT", 80, 0)
				boss25value3:SetPoint("TOPLEFT", boss25stat3, "TOPLEFT", 80, 0)

				if mod.modId:sub(1,9) == "DBM-Party" or mod.modId:sub(1,9) == "DBM-World" then
					party = true
					Boss:SetPoint("TOPLEFT", area.frame, "TOPLEFT", 10, -10-(L.FontHeight*5*(bossstats-1)))
					Boss10:Hide()
					Boss25:Hide()
					bossstat1:SetPoint("TOPLEFT", Boss, "BOTTOMLEFT", 20, -5)
					area.frame:SetHeight( area.frame:GetHeight() + L.FontHeight*5 )
				elseif not mod.hasHeroic then
					Heroic:Hide()
					area.frame:SetHeight( area.frame:GetHeight() + L.FontHeight*6 ) 
				else
					Boss:SetPoint("TOPLEFT", area.frame, "TOPLEFT", 10, -10-(L.FontHeight*10*(bossstats-1)))
					Heroic:Hide()
					Heroic10:SetPoint("TOPLEFT", bossstat3, "BOTTOMLEFT", -20, -5)
					bossstat4:SetPoint("TOPLEFT", Heroic10, "BOTTOMLEFT", 20, -5)
					bossstat5:SetPoint("TOPLEFT", bossstat4, "BOTTOMLEFT", 0, -5)
					bossstat6:SetPoint("TOPLEFT", bossstat5, "BOTTOMLEFT", 0, -5)
					Heroic25:SetPoint("LEFT", Heroic10, "LEFT", 220, 0)
					boss25stat4:SetPoint("LEFT", bossstat4, "LEFT", 220, 0)
					boss25stat5:SetPoint("LEFT", bossstat5, "LEFT", 220, 0)
					boss25stat6:SetPoint("LEFT", bossstat6, "LEFT", 220, 0)
					bossvalue4:SetPoint("TOPLEFT", bossstat4, "TOPLEFT", 80, 0)
					bossvalue5:SetPoint("TOPLEFT", bossstat5, "TOPLEFT", 80, 0)
					bossvalue6:SetPoint("TOPLEFT", bossstat6, "TOPLEFT", 80, 0)
					boss25value4:SetPoint("TOPLEFT", boss25stat4, "TOPLEFT", 80, 0)
					boss25value5:SetPoint("TOPLEFT", boss25stat5, "TOPLEFT", 80, 0)
					boss25value6:SetPoint("TOPLEFT", boss25stat6, "TOPLEFT", 80, 0)
					area.frame:SetHeight( area.frame:GetHeight() + L.FontHeight*10 ) 
				end

				table.insert(area.onshowcall, OnShowGetStats(mod.stats, party, bossvalue1, bossvalue2, bossvalue3, boss25value1, boss25value2, boss25value3, bossvalue4, bossvalue5, bossvalue6, boss25value4, boss25value5, boss25value6))
			end
		end
		area.frame:SetScript("OnShow", function(self)
			for _,v in pairs(area.onshowcall) do
				v()
			end
		end)
		panel:SetMyOwnHeight()
		DBM_GUI_OptionsFrame:DisplayFrame(panel.frame)
	end

	local function LoadAddOn_Button(self) 
		if DBM:LoadMod(self.modid) then 
			self:Hide()
			self.headline:Hide()
			CreateBossModTab(self.modid, self.modid.panel)		
			DBM_GUI_OptionsFrameBossMods:Hide()
			DBM_GUI_OptionsFrameBossMods:Show()
		end
	end

	local Categories = {}
	function DBM_GUI:UpdateModList()
		for k,addon in ipairs(DBM.AddOns) do
			if not Categories[addon.category] then
				Categories[addon.category] = DBM_GUI:CreateNewPanel(L["TabCategory_"..addon.category:upper()] or L.TabCategory_Other, nil, (addon.category:upper()=="CATA"))
				if L["TabCategory_"..addon.category:upper()] then
					local ptext = Categories[addon.category]:CreateText(L["TabCategory_"..addon.category:upper()])
					ptext:SetPoint('TOPLEFT', Categories[addon.category].frame, "TOPLEFT", 10, -10)
				end
			end
			
			if not addon.panel then
				-- Create a Panel for "Naxxramas" "Eye of Eternity" ...
				addon.panel = Categories[addon.category]:CreateNewPanel(addon.name or "Error: X-DBM-Mod-Name", nil, false)

				if not IsAddOnLoaded(addon.modId) then
					local button = addon.panel:CreateButton(L.Button_LoadMod, 200, 30)
					button.modid = addon
					button.headline = addon.panel:CreateText(L.BossModLoad_now, 350)
					button.headline:SetHeight(50)
					button.headline:SetPoint("CENTER", button, "CENTER", 0, 80)

					button:SetScript("OnClick", LoadAddOn_Button)
					button:SetPoint('CENTER', 0, -20)
				else
					CreateBossModTab(addon, addon.panel)
				end
			end

			if addon.panel and addon.subTabs and IsAddOnLoaded(addon.modId) then
				-- Create a Panel for "Arachnid Quarter" "Plague Quarter" ...
				if not addon.subPanels then addon.subPanels = {} end

				for k,v in pairs(addon.subTabs) do
					if not addon.subPanels[k] then
						addon.subPanels[k] = addon.panel:CreateNewPanel(v or "Error: X-DBM-Mod-Name", nil, false)
						CreateBossModTab(addon, addon.subPanels[k], k)
					end
				end
			end


			for _, mod in ipairs(DBM.Mods) do
				if mod.modId == addon.modId then
					if not mod.panel and (not addon.subTabs or (addon.subPanels and addon.subPanels[mod.subTab])) then
						if addon.subTabs and addon.subPanels[mod.subTab] then
							mod.panel = addon.subPanels[mod.subTab]:CreateNewPanel(mod.localization.general.name or "Error: DBM.Mods")
						else
							mod.panel = addon.panel:CreateNewPanel(mod.localization.general.name or "Error: DBM.Mods")
						end
						DBM_GUI:CreateBossModPanel(mod)
					end
				end
			end	
		end
		if DBM_GUI_OptionsFrame:IsShown() then
			DBM_GUI_OptionsFrame:Hide()
			DBM_GUI_OptionsFrame:Show()
		end
	end


	function DBM_GUI:CreateBossModPanel(mod)
		if not mod.panel then
			DBM:AddMsg("Couldn't create boss mod panel for "..mod.localization.general.name)
			return false
		end
		local panel = mod.panel
		local category

		local iconstat = panel.frame:CreateFontString("DBM_GUI_Mod_Icons"..mod.localization.general.name, "ARTWORK")
		iconstat:SetPoint("TOPRIGHT", panel.frame, "TOPRIGHT", -16, -16)
		iconstat:SetFontObject(GameFontNormal)
		iconstat:SetText(L.IconsInUse)
		for i=1, 8, 1 do
			local icon = panel.frame:CreateTexture()
			icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons.blp")
			icon:SetPoint("TOPRIGHT", panel.frame, "TOPRIGHT", 2-(i*18), -32)
			icon:SetWidth(16)
			icon:SetHeight(16)
			if not mod.usedIcons or not mod.usedIcons[i] then		icon:SetAlpha(0.25)		end
			if 		i == 1 then		icon:SetTexCoord(0,		0.25,	0,		0.25)
			elseif	i == 2 then		icon:SetTexCoord(0.25,	0.5,	0,		0.25)
			elseif	i == 3 then		icon:SetTexCoord(0.5, 	0.75,	0,		0.25)
			elseif	i == 4 then		icon:SetTexCoord(0.75,	1,		0,		0.25)
			elseif	i == 5 then		icon:SetTexCoord(0,		0.25,	0.25,	0.5)
			elseif	i == 6 then		icon:SetTexCoord(0.25,	0.5,	0.25,	0.5)
			elseif	i == 7 then		icon:SetTexCoord(0.5,	0.75,	0.25,	0.5)
			elseif	i == 8 then		icon:SetTexCoord(0.75,	1,		0.25,	0.5)
			end
		end

		local button = panel:CreateCheckButton(L.Mod_Enabled, true)
		button:SetScript("OnShow",  function(self) self:SetChecked(mod.Options.Enabled) end)
		button:SetScript("OnClick", function(self) mod:Toggle()	end)

		local button = panel:CreateCheckButton(L.Mod_EnableAnnounce, true)
		button:SetScript("OnShow",  function(self) self:SetChecked(mod.Options.Announce) end)
		button:SetScript("OnClick", function(self) mod.Options.Announce = not not self:GetChecked() end)
		
		for _, catident in pairs(mod.categorySort) do
			category = mod.optionCategories[catident]
			local catpanel = panel:CreateArea(mod.localization.cats[catident], nil, nil, true)
			local button, lastButton, addSpacer
			for _,v in ipairs(category) do
				if v == DBM_OPTION_SPACER then
					addSpacer = true
				elseif type(mod.Options[v]) == "boolean" then
					lastButton = button
					button = catpanel:CreateCheckButton(mod.localization.options[v], true)
					if addSpacer then
						button:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, -6)
						addSpacer = false
					end
					button:SetScript("OnShow",  function(self) 
						self:SetChecked(mod.Options[v]) 
					end)
					button:SetScript("OnClick", function(self) 
						mod.Options[v] = not mod.Options[v]
						if mod.optionFuncs and mod.optionFuncs[v] then mod.optionFuncs[v]() end
					end)
				elseif mod.dropdowns and mod.dropdowns[v] then
					lastButton = button
					local dropdownOptions = {}
					for i, v in ipairs(mod.dropdowns[v]) do
						dropdownOptions[#dropdownOptions + 1] = { text = mod.localization.options[v], value = v }
					end
					button = catpanel:CreateDropdown(mod.localization.options[v], dropdownOptions, mod.Options[v], function(value) mod.Options[v] = value end)
					if addSpacer then
						button:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, -6)
						addSpacer = false
					else
						button:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, -10)
					end
--					button:SetScript("OnShow", function(self)
--						-- set the correct selected value if the mod is being loaded after the gui is loaded (hack because the dropdown menu lacks a SetSelectedValue method)
--						_G[button:GetName().."Text"]:SetText(mod.localization.options[v])
--						button.value = v
--						button.text = mod.localization.options[v]
--					end)
				end
			end
			catpanel:AutoSetDimension()
			panel:SetMyOwnHeight()
		end
	end
end
