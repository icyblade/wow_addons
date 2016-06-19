local GlobalAddonName, ExRT = ...

ExRT.Options = {}

local ELib,L = ExRT.lib,ExRT.L

------------------------------------------------------------
--------------- New Options --------------------------------
------------------------------------------------------------

local OptionsFrameName = "ExRTOptionsFrame"
local Options = ELib:Template("ExRTBWInterfaceFrame",UIParent)
_G[OptionsFrameName] = Options

ExRT.Options.Frame = Options

Options:Hide()
Options:SetPoint("CENTER",0,0)
Options:SetSize(863,650)
Options.HeaderText:SetText("Exorsus Raid Tools")
Options:SetMovable(true)
Options:RegisterForDrag("LeftButton")
Options:SetScript("OnDragStart", function(self) self:StartMoving() end)
Options:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
Options:SetDontSavePosition(true)
Options.border = ExRT.lib.CreateShadow(Options,20)

ELib:ShadowInside(Options)

Options.bossButton:Hide()
Options.backToInterface:SetScript("OnClick",function ()
	ExRT.Options.Frame:Hide()
	InterfaceOptionsFrame:Show()
end)


Options.modulesList = ELib:ScrollList(Options):Size(180-10,616-10):Point(10+5,-25-5):FontSize(11)
Options.Frames = {}

Options:SetScript("OnShow",function(self)
	self.modulesList:Update()
	if Options.CurrentFrame and Options.CurrentFrame.AdditionalOnShow then
		Options.CurrentFrame:AdditionalOnShow()
	end
end)

function Options.modulesList:SetListValue(index)
	if Options.CurrentFrame then
		Options.CurrentFrame:Hide()
	end
	Options.CurrentFrame = Options.Frames[index]
	if Options.CurrentFrame.AdditionalOnShow then
		Options.CurrentFrame:AdditionalOnShow()
	end
	Options.CurrentFrame:Show()
end
function Options.modulesList:UpdateAdditional()
	if (self:GetHeight() / 16 - #self.L) > 0 then
		self.Frame.ScrollBar:Hide()
		self.Frame.C:SetWidth( self.Frame:GetWidth() )
	else
		self.Frame.ScrollBar:Show()
		self.Frame.C:SetWidth( self.Frame:GetWidth() - 16 )
	end
end

function ExRT.Options:Add(moduleName,frameName)
	local self = CreateFrame("Frame",OptionsFrameName..moduleName,Options)
	self:SetSize(660,615)
	self:SetPoint("TOPLEFT",195,-25)
	
	local pos = #Options.Frames + 1
	Options.modulesList.L[pos] = frameName or moduleName
	Options.Frames[pos] = self
	
	if Options:IsShown() then
		Options.modulesList:Update()
	end
	
	self:Hide()
	
	return self
end

function ExRT.Options:AddIcon(moduleName,icon)
	Options.modulesList.IconsRight = Options.modulesList.IconsRight or {}
	for i=1,#Options.modulesList.L do
		if Options.modulesList.L[i] == moduleName then
			Options.modulesList.IconsRight[i] = icon
			break
		end
	end
end

local OptionsFrame = ExRT.Options:Add("Exorsus Raid Tools")
Options.modulesList:SetListValue(1)
Options.modulesList.selected = 1
Options.modulesList:Update()

------------------------------------------------------------

ExRT.Options.InBlizzardInterface = CreateFrame( "Frame", nil )
ExRT.Options.InBlizzardInterface.name = "Exorsus Raid Tools"
InterfaceOptions_AddCategory(ExRT.Options.InBlizzardInterface)
ExRT.Options.InBlizzardInterface:Hide()

ExRT.Options.InBlizzardInterface:SetScript("OnShow",function (self)
	if InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Hide()
	end
	ExRT.Options:Open()
	self:SetScript("OnShow",nil)
end)

ExRT.Options.InBlizzardInterface.button = ELib:Button(ExRT.Options.InBlizzardInterface,"Exrsus Raid Tools",0):Size(400,25):Point("TOP",0,-100):OnClick(function ()
	if InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame:Hide()
	end
	ExRT.Options:Open()
end)

----> Minimap Icon

local MiniMapIcon = CreateFrame("Button", "LibDBIcon10_ExorsusRaidTools", Minimap)
ExRT.MiniMapIcon = MiniMapIcon
MiniMapIcon:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight") 
MiniMapIcon:SetSize(32,32) 
MiniMapIcon:SetFrameStrata("MEDIUM")
MiniMapIcon:SetFrameLevel(8)
MiniMapIcon:SetPoint("CENTER", -12, -80)
MiniMapIcon:SetDontSavePosition(true)
MiniMapIcon:RegisterForDrag("LeftButton")
MiniMapIcon.icon = MiniMapIcon:CreateTexture(nil, "BACKGROUND")
MiniMapIcon.icon:SetTexture("Interface\\AddOns\\ExRT\\media\\MiniMap")
MiniMapIcon.icon:SetSize(32,32)
MiniMapIcon.icon:SetPoint("CENTER", 0, 0)
MiniMapIcon.border = MiniMapIcon:CreateTexture(nil, "ARTWORK")
MiniMapIcon.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
MiniMapIcon.border:SetTexCoord(0,0.6,0,0.6)
MiniMapIcon.border:SetAllPoints()
MiniMapIcon:RegisterForClicks("anyUp")
MiniMapIcon:SetScript("OnEnter",function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_LEFT") 
	GameTooltip:AddLine("Exorsus Raid Tools") 
	GameTooltip:AddLine(L.minimaptooltiplmp,1,1,1) 
	GameTooltip:AddLine(L.minimaptooltiprmp,1,1,1) 
	GameTooltip:Show() 
end)
MiniMapIcon:SetScript("OnLeave", function(self)    
	GameTooltip:Hide()
end)

local minimapShapes = {
	["ROUND"] = {true, true, true, true},
	["SQUARE"] = {false, false, false, false},
	["CORNER-TOPLEFT"] = {false, false, false, true},
	["CORNER-TOPRIGHT"] = {false, false, true, false},
	["CORNER-BOTTOMLEFT"] = {false, true, false, false},
	["CORNER-BOTTOMRIGHT"] = {true, false, false, false},
	["SIDE-LEFT"] = {false, true, false, true},
	["SIDE-RIGHT"] = {true, false, true, false},
	["SIDE-TOP"] = {false, false, true, true},
	["SIDE-BOTTOM"] = {true, true, false, false},
	["TRICORNER-TOPLEFT"] = {false, true, true, true},
	["TRICORNER-TOPRIGHT"] = {true, false, true, true},
	["TRICORNER-BOTTOMLEFT"] = {true, true, false, true},
	["TRICORNER-BOTTOMRIGHT"] = {true, true, true, false},
}

local function IconMoveButton(self)
	if self.dragMode == "free" then
		local centerX, centerY = Minimap:GetCenter()
		local x, y = GetCursorPosition()
		x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
		self:ClearAllPoints()
		self:SetPoint("CENTER", x, y)
		VExRT.Addon.IconMiniMapLeft = x
		VExRT.Addon.IconMiniMapTop = y
	else
		local mx, my = Minimap:GetCenter()
		local px, py = GetCursorPosition()
		local scale = Minimap:GetEffectiveScale()
		px, py = px / scale, py / scale
		
		local angle = math.atan2(py - my, px - mx)
		local x, y, q = math.cos(angle), math.sin(angle), 1
		if x < 0 then q = q + 1 end
		if y > 0 then q = q + 2 end
		local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
		local quadTable = minimapShapes[minimapShape]
		if quadTable[q] then
			x, y = x*80, y*80
		else
			local diagRadius = 103.13708498985 --math.sqrt(2*(80)^2)-10
			x = math.max(-80, math.min(x*diagRadius, 80))
			y = math.max(-80, math.min(y*diagRadius, 80))
		end
		self:ClearAllPoints()
		self:SetPoint("CENTER", Minimap, "CENTER", x, y)
		VExRT.Addon.IconMiniMapLeft = x
		VExRT.Addon.IconMiniMapTop = y
	end
end

MiniMapIcon:SetScript("OnDragStart", function(self)
	self:LockHighlight()
	self:SetScript("OnUpdate", IconMoveButton)
	self.isMoving = true
	GameTooltip:Hide()
end)
MiniMapIcon:SetScript("OnDragStop", function(self)
	self:UnlockHighlight()
	self:SetScript("OnUpdate", nil)
	self.isMoving = false
end)

local function MiniMapIconOnClick(self, button)
	if button == "RightButton" then
		for _,func in pairs(ExRT.MiniMapMenu) do
			func:miniMapMenu()
		end
		ExRT.Options:UpdateModulesList()
		EasyMenu(ExRT.F.menuTable, ExRT.Options.MiniMapDropdown, "cursor", 10 , -15, "MENU")
	elseif button == "LeftButton" then
		ExRT.Options:Open()
	end
end

MiniMapIcon:SetScript("OnMouseUp", MiniMapIconOnClick)

ExRT.Options.MiniMapDropdown = CreateFrame("Frame", "ExRTMiniMapMenuFrame", nil, "UIDropDownMenuTemplate")

local MinimapMenu_UIDs = {}
local MinimapMenu_UIDnumeric = 0
local MinimapMenu_Level = {3,4,5,5}

function ExRT.F.MinimapMenuAdd(text, func, level, uid, subMenu)
	level = level or 2
	if not uid then
		MinimapMenu_UIDnumeric = MinimapMenu_UIDnumeric + 1
		uid = MinimapMenu_UIDnumeric
	end
	if MinimapMenu_UIDs[uid] then
		return
	end
	local menuTable = { text = text, func = func, notCheckable = true, keepShownOnClick = true, }
	if subMenu then
		menuTable.hasArrow = true
		menuTable.menuList = subMenu
	end
	tinsert(ExRT.F.menuTable,MinimapMenu_Level[level],menuTable)
	for i=level,#MinimapMenu_Level do
		MinimapMenu_Level[i] = MinimapMenu_Level[i] + 1
	end
	MinimapMenu_UIDs[uid] = menuTable
end

function ExRT.F.MinimapMenuRemove(uid)
	for i=1,#ExRT.F.menuTable do
		if ExRT.F.menuTable[i] == MinimapMenu_UIDs[uid] then 
			for j=i,#ExRT.F.menuTable do
				ExRT.F.menuTable[j] = ExRT.F.menuTable[j+1]
			end
			for j=1,#MinimapMenu_Level do
				if i <= MinimapMenu_Level[j] then
					MinimapMenu_Level[j] = MinimapMenu_Level[j] - 1
				end
			end
			MinimapMenu_UIDs[uid] = nil
			return
		end
	end
end

function ExRT.Options:Open(PANEL)
	CloseDropDownMenus()
	Options:Show()
	
	if Options.CurrentFrame then
		Options.CurrentFrame:Hide()
	end
	Options.CurrentFrame = PANEL or Options.Frames[Options.modulesList.selected or 1]
	Options.CurrentFrame:Show()
	
	if PANEL then
		for i=1,#Options.Frames do
			if Options.Frames[i] == PANEL then
				Options.modulesList.selected = i
				Options.modulesList:Update()
				break
			end
		end
	end
end

ExRT.F.menuTable = {
{ text = L.minimapmenu, isTitle = true, notCheckable = true, notClickable = true },
{ text = L.minimapmenuset, func = ExRT.Options.Open, notCheckable = true, keepShownOnClick = true, },
{ text = " ", isTitle = true, notCheckable = true, notClickable = true },
{ text = " ", isTitle = true, notCheckable = true, notClickable = true },
{ text = L.minimapmenuclose, func = function() CloseDropDownMenus() end, notCheckable = true },
}

local modulesActive = {}
function ExRT.Options:UpdateModulesList()
	for i=1,#ExRT.ModulesOptions do
		ExRT.F.MinimapMenuAdd(ExRT.ModulesOptions[i].name, function() 
			ExRT.Options:Open(ExRT.ModulesOptions[i]) 
		end, 2,ExRT.ModulesOptions[i].name)
	end
end

----> Options

OptionsFrame.image = ELib:Texture(OptionsFrame,"Interface\\AddOns\\ExRT\\media\\OptionLogo2"):Point("CENTER",OptionsFrame,"TOPLEFT",75,-60):Size(140,140):Color(.9,.9,.9,1):TexCoord(0,140/256,0,140/256)
OptionsFrame.title = ELib:Text(OptionsFrame,"Exorsus Raid Tools",22):Size(500,22):Point("LEFT",OptionsFrame.image,"RIGHT",20,0):Color()

OptionsFrame.chkIconMiniMap = ELib:Check(OptionsFrame,L.setminimap1):Point(25,-150):OnClick(function(self) 
	if self:GetChecked() then
		VExRT.Addon.IconMiniMapHide = true
		ExRT.MiniMapIcon:Hide()
	else
		VExRT.Addon.IconMiniMapHide = nil
		ExRT.MiniMapIcon:Show()
	end
end)
OptionsFrame.chkIconMiniMap:SetScript("OnShow", function(self,event) 
	self:SetChecked(VExRT.Addon.IconMiniMapHide) 
end)

OptionsFrame.timerSlider = ELib:Slider(OptionsFrame,L.setEggTimerSlider):Size(550):Point("TOP",0,-125):Range(10,1000):SetTo(100):OnChange(function(self,event) 
	event = event - event%1
	self.tooltipText = event
	self:tooltipReload(self)	
	event = event / 1000	
	VExRT.Addon.Timer = event
end)
OptionsFrame.timerSlider:Hide()

OptionsFrame.eventsCountTextLeft = ELib:Text(OptionsFrame,"",12):Size(590,300):Point(15,-300):Color():Shadow()
OptionsFrame.eventsCountTextRight = ELib:Text(OptionsFrame,"",12):Size(590,300):Point(85,-300):Color():Shadow()
OptionsFrame.eventsCountTextFrame = CreateFrame("Frame",nil,OptionsFrame)
OptionsFrame.eventsCountTextFrame:SetSize(1,1)
OptionsFrame.eventsCountTextFrame:SetPoint("TOPLEFT")
OptionsFrame.eventsCountTextFrame:Hide()
OptionsFrame.eventsCountTextFrame:SetScript("OnShow",function()
	local tmp = {}
	for i=1,#ExRT.Modules do
		if ExRT.Modules[i].main.eventsCounter then
			for event,count in pairs(ExRT.Modules[i].main.eventsCounter) do
				if not tmp[event] then
					tmp[event] = count
				else
					tmp[event] = max(tmp[event],count)
				end
			end
		end
	end
	tmp["COMBAT_LOG_EVENT_UNFILTERED"] = -1
	local tmp2 = {}
	local total = 0
	for event,count in pairs(tmp) do
		table.insert(tmp2,{event,count})
		total = total + count
	end
	table.sort(tmp2,function(a,b) return a[2] > b[2] end)
	local h = total.."\n"
	local n = "Total\n"
	for i=1,#tmp2 do
		h = h .. tmp2[i][2].."\n"
		n = n .. tmp2[i][1] .."\n"
	end
	OptionsFrame.eventsCountTextLeft:SetText(h)
	OptionsFrame.eventsCountTextRight:SetText(n)
end)

OptionsFrame.eggBut = CreateFrame("Button",nil,OptionsFrame)  
OptionsFrame.eggBut:SetSize(14,14) 
OptionsFrame.eggBut:SetPoint("CENTER",OptionsFrame.image,0,12)
OptionsFrame.eggBut:SetScript("OnClick",function(s) 
	local superMode = nil
	OptionsFrame.timerSlider:SetValue(VExRT.Addon.Timer*1000 or 100)
	OptionsFrame.timerSlider:Show()
	OptionsFrame.eventsCountTextFrame:Show()
	if IsShiftKeyDown() then
		return
	end
	if IsAltKeyDown() then
		superMode = true
	end
end)

OptionsFrame.authorLeft = ELib:Text(OptionsFrame,L.setauthor,12):Size(150,25):Point(15,-195):Shadow():Top()
OptionsFrame.authorRight = ELib:Text(OptionsFrame,"Afiya (Афиа) @ EU-Howling Fjord",12):Size(520,25):Point(135,-195):Color():Shadow():Top()

OptionsFrame.versionLeft = ELib:Text(OptionsFrame,L.setver,12):Size(150,25):Point(15,-215):Shadow():Top()
OptionsFrame.versionRight = ELib:Text(OptionsFrame,ExRT.V..(ExRT.T == "R" and "" or " "..ExRT.T),12):Size(520,25):Point(135,-215):Color():Shadow():Top()

OptionsFrame.contactLeft = ELib:Text(OptionsFrame,L.setcontact,12):Size(150,25):Point(15,-235):Shadow():Top()
OptionsFrame.contactRight = ELib:Text(OptionsFrame,"e-mail: ykiigor@gmail.com",12):Size(520,25):Point(135,-235):Color():Shadow():Top()

OptionsFrame.thanksLeft = ELib:Text(OptionsFrame,L.SetThanks,12):Size(150,25):Point(15,-255):Shadow():Top()
OptionsFrame.thanksRight = ELib:Text(OptionsFrame,"Phanx, funkydude, Shurshik, Kemayo, Guillotine, Rabbit, fookah, diesal2010, Felix, yuk6196, martinkerth, Gyffes, Cubetrace, tigerlolol",12):Size(520,25):Point(135,-255):Color():Shadow():Top()

if L.TranslateBy ~= "" then
	OptionsFrame.translateLeft = ELib:Text(OptionsFrame,L.SetTranslate,12):Size(150,25):Point("LEFT",OptionsFrame,15,0):Point("TOP",OptionsFrame.thanksRight,"BOTTOM",0,-8):Shadow():Top()
	OptionsFrame.translateRight = ELib:Text(OptionsFrame,L.TranslateBy,12):Size(520,25):Point("LEFT",OptionsFrame.thanksRight,"LEFT",0,0):Point("TOP",OptionsFrame.translateLeft,0,0):Color():Shadow():Top()

end

local function CreateDataBrokerPlugin()
	local dataObject = LibStub:GetLibrary('LibDataBroker-1.1'):NewDataObject(GlobalAddonName, {
		type = 'launcher',
		icon = "Interface\\AddOns\\ExRT\\media\\MiniMap",
		OnClick = MiniMapIconOnClick,
	})
end
CreateDataBrokerPlugin()
