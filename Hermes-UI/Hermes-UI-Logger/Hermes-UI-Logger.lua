local VIEW_NAME = "Logger"

local Hermes = LibStub("AceAddon-3.0"):GetAddon("Hermes")
local UI = LibStub("AceAddon-3.0"):GetAddon("Hermes-UI")
local L = LibStub('AceLocale-3.0'):GetLocale('Hermes-UI')
local LIB_LibSharedMedia = LibStub("LibSharedMedia-3.0") or error("Required library LibSharedMedia-3.0 not found")
local ViewManager = UI:GetModule("ViewManager")
local mod = ViewManager:NewModule(VIEW_NAME)

-----------------------------------------------------------------------
-- LOCALS
-----------------------------------------------------------------------
local FRAMEPOOL = nil

local RESIZER_SIZE = 18
local BUTTON_SIZE = 22

local SLIDER_WIDTH = 18
local SLIDER_THUMB_HEIGHT = 26
local SLIDER_THUMB_WIDTH = 26

local FRAME_WIDTH = 400
local FRAME_HEIGHT = 100

local MIN_FRAME_WIDTH = 160
local MIN_FRAME_HEIGHT = 40

local HEADER_HEIGHT = 18
local IMAGE_RESIZE = "Interface\\Addons\\Hermes-UI\\Resize.tga"

local ICON_STATUS_NOTREADY = "Interface\\RAIDFRAME\\ReadyCheck-NotReady.blp"
local ICON_STATUS_READY = "Interface\\RAIDFRAME\\ReadyCheck-Ready.blp"

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

local function _getColorHEX(r, g, b)
	return string.format("FF%02x%02x%02x", r * 255, g * 255, b * 255)
end

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
-- Frame
-----------------------------------------------------------------------
function mod:RestoreFramePos(frame)
	local profile = frame.profile
	if(not profile.x or not profile.y) then
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "CENTER")
		frame:SetWidth(FRAME_WIDTH)
		frame:SetHeight(FRAME_HEIGHT)
		profile.x = frame:GetLeft()
		profile.y = frame:GetTop()
		profile.w = FRAME_WIDTH
		profile.h = FRAME_HEIGHT
	else
		x = profile.x
		y = profile.y

		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
		frame:SetWidth(profile.w)
		frame:SetHeight(profile.h)
	end
	
	frame:SetUserPlaced(nil)
end

function mod:SaveFramePos(frame)				--updates saved variables for anchor position
	frame.profile.x = frame:GetLeft()
	frame.profile.y = frame:GetTop()
	frame.profile.w = frame:GetWidth()
	frame.profile.h = frame:GetHeight()
end

function mod:LockFrame(frame, force)					--shows or hides the anchor and enabled/disables dragging
	--we don't actually hide the window because everything is parented to it.
	--instead we'll just change the properties to make it appear invisible
	if frame.profile.locked == true or force then
		--frame.header:EnableMouse(false)
		--frame.header:SetBackdrop(nil)
		--frame.header:SetBackdropColor(0, 0, 0, 0)
		--frame.header:SetBackdropBorderColor(0, 0, 0, 0)
		frame.header:Hide()
		frame.resizer:EnableMouse(false)
		frame.resizer:Hide()
	else
		--[[
		frame.header:EnableMouse(true)
		frame.header:SetBackdrop({
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
		frame.header:SetBackdropColor(0.6, 0.6, 0.6, 0.7)
		frame.header:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.7)
		]]--
		frame.header:Show()
		frame.resizer:EnableMouse(true)
		frame.resizer:Show()
	end
end

function mod:InitializeFrame(frame, profile)
	frame.profile = profile
	frame:SetParent(UIParent)
	frame:SetScale(profile.scale)
	frame:SetAlpha(profile.alpha)
	frame:SetBackdropColor(profile.bgColor.r, profile.bgColor.g, profile.bgColor.b, profile.bgColor.a)
	local font = LIB_LibSharedMedia:Fetch("font", profile.font)
	frame.message:SetFont(font, profile.fontSize)
	if profile.showSlider == true then
		frame.slider:Show()
	else
		frame.slider:Hide()
	end
end

function mod:CreateFrame()
	---------------------
	--main
	---------------------
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:Hide()
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:SetWidth(FRAME_WIDTH)
	frame:SetHeight(FRAME_HEIGHT)
	frame:SetScale(1)
	
	frame:EnableMouse(false)
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:SetUserPlaced(false)
	frame:SetToplevel(false)
	frame:SetScript("OnHide", function() frame.resizer:StopMovingOrSizing() frame:StopMovingOrSizing() end) -- prevents stuck dragging
	frame:SetScript("OnSizeChanged", function() frame.header:SetWidth(frame:GetWidth()) end)
	frame:SetMinResize(MIN_FRAME_WIDTH, MIN_FRAME_HEIGHT)
	frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		tile = false,
		tileSize = 32,
		edgeSize = 10,
		insets = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0
		}
	})
	frame:SetBackdropColor(0, 0, 0, 0.75)
	
	---------------------
	--header
	---------------------
	frame.header = CreateFrame("Frame", nil, frame)
	frame.header:SetHeight(HEADER_HEIGHT)
	frame.header:SetPoint("BOTTOMLEFT", frame, "TOPLEFT")
	frame.header:SetWidth(FRAME_WIDTH)
	frame.header:EnableMouse(true)
	frame.header:SetMovable(true)
	frame.header:SetResizable(true)
	frame.header:SetUserPlaced(false)
	frame.header:SetToplevel(false)
	frame.header:RegisterForDrag("LeftButton");
	frame.header:SetScript("OnDragStart", function()
		if(frame.profile.locked == false) then
			frame:StartMoving()
		end
	end)
	frame.header:SetScript("OnDragStop", function() 
		frame:StopMovingOrSizing()
		frame.resizer:StopMovingOrSizing()
		self:SaveFramePos(frame)
	end)
	frame.header:SetBackdrop({
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
	frame.header:SetBackdropColor(0.6, 0.6, 0.6, 0.7)
	frame.header:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.7)
	frame.header.text = frame.header:CreateFontString(nil, "ARTWORK")
	frame.header.text:SetFontObject(GameFontNormalSmall);
	frame.header.text:SetTextColor(0.9, 0.9, 0.9, 1)
	frame.header.text:SetText("")
	frame.header.text:SetWordWrap(false)
	frame.header.text:SetNonSpaceWrap(false)
	frame.header.text:SetJustifyH("CENTER");
	frame.header.text:SetJustifyV("CENTER");
	frame.header.text:SetAllPoints();

	---------------------
	--message frame
	---------------------
	frame.message = CreateFrame("ScrollingMessageFrame", nil, frame)
	frame.message:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
	frame.message:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -SLIDER_WIDTH, -2)
	frame.message:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, 2)
	frame.message:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -SLIDER_WIDTH + 2, 2)
	frame.message:SetJustifyH("LEFT")
	frame.message:SetFading(true)
	frame.message:SetFadeDuration(5)
	frame.message:SetTimeVisible(120)
	frame.message:SetFontObject("ChatFontNormal")
	frame.message:SetMaxLines(1000)
	frame.message:EnableMouse(false)
	frame.message:EnableMouseWheel(1)
	frame.message:SetHyperlinksEnabled(true)
	frame.message:SetScript("OnHyperlinkClick", function(self, link, text, button)
		SetItemRef(link, text);
	end)
	frame.message:SetScript("OnMouseWheel", function(self, delta)
		if delta == 1 then
			self:ScrollUp()
		elseif delta == -1 then 
			self:ScrollDown()
		end
	end)
	frame.message:SetScript("OnMessageScrollChanged", function()
		self:UpdateScrollPosition(frame)
	end)
	
	---------------------
	--reset button
	---------------------
	frame.resetbutton = CreateFrame("Button", nil, frame.message)
	frame.resetbutton:SetWidth(BUTTON_SIZE)
	frame.resetbutton:SetHeight(BUTTON_SIZE)
	frame.resetbutton:SetAlpha(0.3)
	frame.resetbutton:SetPoint("TOPRIGHT", frame.message, "TOPRIGHT", -1, -1)
	frame.resetbutton:SetNormalTexture("Interface\\AddOns\\Hermes-UI\\Hermes-UI-Logger\\icon-reset.tga")
	frame.resetbutton:RegisterForClicks("AnyUp")
	frame.resetbutton:SetScript("OnClick",
		function(self, button, down)
			frame.message:Clear()
		end
	)
	frame.resetbutton:SetScript("OnEnter", function()
		frame.resetbutton:SetAlpha(1)
	end)
	frame.resetbutton:SetScript("OnLeave", function()
		frame.resetbutton:SetAlpha(0.3)
	end)
	
	---------------------
	--slider
	---------------------
	frame.slider = CreateFrame("Slider", nil, frame)
	frame.slider:SetValueStep(1)
    frame.slider.bg = frame.slider:CreateTexture(nil, "BACKGROUND")
    frame.slider.bg:SetAllPoints(true)
    frame.slider.bg:SetTexture(0, 0, 0, 0.5)

    frame.slider.thumb = frame.slider:CreateTexture(nil, "OVERLAY")
    frame.slider.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
    frame.slider.thumb:SetSize(SLIDER_THUMB_WIDTH, SLIDER_THUMB_HEIGHT)
    frame.slider:SetThumbTexture(frame.slider.thumb)
	
	frame.slider:SetOrientation("VERTICAL");
	frame.slider:SetWidth(SLIDER_WIDTH)
	frame.slider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
	frame.slider:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, RESIZER_SIZE)
	frame.slider:SetScript("OnValueChanged", function()
		if not frame.slider.override then
			local total = frame.message:GetNumMessages()
			local displayed = frame.message:GetNumLinesDisplayed()
			local offset = total - frame.slider:GetValue() - displayed
			frame.message:SetScrollOffset(offset)
		end
	end)
	
	---------------------
	--resizer
	---------------------
	frame.resizer = CreateFrame("Frame", nil, frame)
	frame.resizer:SetWidth(RESIZER_SIZE)
	frame.resizer:SetHeight(RESIZER_SIZE)
	frame.resizer:EnableMouse(true)
	frame.resizer:RegisterForDrag("LeftButton")
	frame.resizer:SetPoint("BOTTOMRIGHT", frame)
	frame.resizer:SetScript("OnMouseDown", function()
		frame.resizer:StopMovingOrSizing()
		frame:StopMovingOrSizing()
		frame:StartSizing()
	end)
	frame.resizer:SetScript("OnMouseUp", function()
		frame.resizer:StopMovingOrSizing()
		frame:StopMovingOrSizing()
		self:SaveFramePos(frame)
		self:UpdateScrollRange(frame)
		self:UpdateScrollPosition(frame)
	end)
	frame.resizer.texture = frame.resizer:CreateTexture()
	frame.resizer.texture:SetTexture(IMAGE_RESIZE)
	frame.resizer.texture:SetDrawLayer("OVERLAY")
	frame.resizer.texture:SetAllPoints()
	
	return frame
end

function mod:UpdateScrollRange(frame)
	local total = frame.message:GetNumMessages()
	local displayed = frame.message:GetNumLinesDisplayed()
	frame.slider:SetMinMaxValues(0, total - displayed)
end

function mod:UpdateScrollPosition(frame)
	local total = frame.message:GetNumMessages()
	local current = frame.message:GetCurrentScroll()
	local displayed = frame.message:GetNumLinesDisplayed()
	frame.slider.override = 1
	frame.slider:SetValue(total - current - displayed)
	frame.slider.override = nil
end

function mod:AddMessage(frame, msg)
	local profile = frame.profile
	if profile.showTimestamp == true then
		frame.message:AddMessage(string.format("|c%s[%s]|r %s",
			_getColorHEX(profile.fontColor.r, profile.fontColor.g, profile.fontColor.b),
			date("%X"),
			msg)
			, 1, 1, 1, 1)
	else
		frame.message:AddMessage(string.format("%s",
			msg),
			1, 1, 1, 1)
	end
	
	self:UpdateScrollRange(frame)
	self:UpdateScrollPosition(frame)
end

function mod:AddMessageUsed(frame, instance)
	local link = GetSpellLink(instance.ability.id)
	if link then
		self:AddMessage(frame, string.format("|T%s:0:0:0:0|t %s %s", ICON_STATUS_NOTREADY, Hermes:GetClassColorString(instance.sender.name, instance.sender.class), link))
	else
		self:AddMessage(frame, string.format("|T%s:0:0:0:0|t %s %s", ICON_STATUS_NOTREADY, Hermes:GetClassColorString(instance.sender.name, instance.sender.class), instance.ability.name))
	end
end

function mod:AddMessageReady(frame, instance)
	local link = GetSpellLink(instance.ability.id)
	if link then
		self:AddMessage(frame, string.format("|T%s:0:0:0:0|t %s %s", ICON_STATUS_READY, Hermes:GetClassColorString(instance.sender.name, instance.sender.class), link))
	else
		self:AddMessage(frame, string.format("|T%s:0:0:0:0|t %s %s", ICON_STATUS_READY, Hermes:GetClassColorString(instance.sender.name, instance.sender.class), instance.ability.name))
	end
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

function mod:RecycleFrame(frame)
	tinsert(FRAMEPOOL.Frames, frame)
	frame:Hide()
	frame:SetParent(FRAMEPOOL)
	frame:ClearAllPoints()
	frame.message:Clear()
end

-----------------------------------------------------------------------
-- VIEW
-----------------------------------------------------------------------
function mod:GetViewDisplayName() --REQUIRED
	return "Logger"
end

function mod:GetViewDisplayDescription() --REQUIRED
	return L["LOGGER_VIEW_DESCRIPTION"]
end

function mod:GetViewDefaults() --REQUIRED
	local defaults = {
		locked = false,
		scale = 1,
		bgColor = {r = 0, g = 0, b = 0, a = 0.75},
		showSlider = true,
		showTimestamp = true,
		alpha = 1,
		font = "Friz Quadrata TT",
		fontColor = {r = 0.6, g = 0.6, b = 0.6, a = 1},
		fontSize = 12,
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
			type = "group",
			name = L["Window"],
			inline = false,
			order = 10,
			args = {
				scale = {
					type = "range",
					min = 0.1, max = 3, step = 0.01,
					name = L["Scale"],
					order = 5,
					width = "full",
					get = function(info) return profile.scale end,
					set = function(info, value)
						profile.scale = value
						frame:SetScale(profile.scale)
					end
				},
				alpha = {
					type = "range",
					min = 0, max = 1, step = 0.01,
					name = L["Alpha"],
					order = 10,
					width = "full",
					get = function(info) return profile.alpha end,
					set = function(info, value)
						profile.alpha = value
						frame:SetAlpha(profile.alpha)
					end
				},
				showSlider = {
					type = "toggle",
					name = L["Show Slider"],
					width = "full",
					get = function(info) return profile.showSlider end,
					order = 15,
					set =function(info, value)
						profile.showSlider = value
						if profile.showSlider == true then
							frame.slider:Show()
						else
							frame.slider:Hide()
						end
					end,
				},
				font = {
					type = "select",
					dialogControl = 'LSM30_Font',
					order = 20,
					name = L["Font"],
					width = "full",
					values = AceGUIWidgetLSMlists.font,
					get = function(info) return profile.font end,
					set = function(info, value)
						profile.font = value
						local font = LIB_LibSharedMedia:Fetch("font", profile.font)
						frame.message:SetFont(font, profile.fontSize)
					end,
				},
				fontSize = {
					type = "range",
					min = 5, max = 30, step = 1,
					name = L["Font Size"],
					width = "full",
					get = function(info) return profile.fontSize end,
					order = 25,
					set = function(info, value)
						profile.fontSize = value
						local font = LIB_LibSharedMedia:Fetch("font", profile.font)
						frame.message:SetFont(font, profile.fontSize)
					end,
				},
				bgColor = {
					type = "color",
					hasAlpha = true,
					order = 30,
					name = L["Color"],
					width = "full",
					get = function(info) return
						profile.bgColor.r,
						profile.bgColor.g,
						profile.bgColor.b,
						profile.bgColor.a
					end,
					set = function(info, r, g, b, a)
						profile.bgColor.r = r
						profile.bgColor.g = g
						profile.bgColor.b = b
						profile.bgColor.a = a
						frame:SetBackdropColor(profile.bgColor.r, profile.bgColor.g, profile.bgColor.b, profile.bgColor.a)
					end,
				},
			},
		},
	}
	
	return options
end

function mod:OnViewNameChanged(view, old, new)
	view.frame.header.text:SetText(view.name)
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
end

function mod:AcquireView(view) --REQUIRED
	local profile = view.profile
	local frame = self:FetchFrame(profile)
	view.frame = frame
	frame.view = view
	frame.header.text:SetText(view.name)
	self:RestoreFramePos(frame)
	self:LockFrame(frame)
	frame:Show()
end

function mod:ReleaseView(view) --REQUIRED
	self:RecycleFrame(view.frame)
end

function mod:EnableView(view) --REQUIRED

end

function mod:DisableView(view) --REQUIRED

end

function mod:OnInstanceStartCooldown(view, ability, instance) --OPTIONAL
	local elapsed = instance.initialDuration - instance.remaining
	if elapsed < 1 then
		--only add if it's fresh
		self:AddMessageUsed(view.frame, instance)
	end
end

function mod:OnInstanceStopCooldown(view, ability, instance) --OPTIONAL
	self:AddMessageReady(view.frame, instance)
end

function mod:OnLibSharedMediaUpdate(view, mediatype, key) --OPTIONAL
	--update all the cells in the container
	if mediatype == "font" then
		local frame = view.frame
		local font = LIB_LibSharedMedia:Fetch("font", profile.font)
		frame.message:SetFont(font, profile.fontSize)
	end
end


