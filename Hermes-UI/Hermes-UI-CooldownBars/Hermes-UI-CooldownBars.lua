local VIEW_NAME = "CooldownBars"

local Hermes = LibStub("AceAddon-3.0"):GetAddon("Hermes")
local UI = LibStub("AceAddon-3.0"):GetAddon("Hermes-UI")
local ViewManager = UI:GetModule("ViewManager")
local LIBBars = LibStub("LibHermesUICooldownBars-1.0") or error("Required library LibHermesUICooldownBars-1.0 not found")
local LIB_LibSharedMedia = LibStub("LibSharedMedia-3.0") or error("Required library LibSharedMedia-3.0 not found")
local L = LibStub('AceLocale-3.0'):GetLocale('Hermes-UI')
local mod = ViewManager:NewModule(VIEW_NAME)

--global to local performance improvements
local GetTime = GetTime
local format, floor = format, floor
local tinsert, tremove, pairs, ipairs, wipe, type, tonumber, sort, tostring = tinsert, tremove, pairs, ipairs, wipe, type, tonumber, sort, tostring
-----------------------------------------------------------------------
-- LOCALS
-----------------------------------------------------------------------
local FRAMEPOOL = nil
local ANCHOR_BAR_HEIGHT = 18
local BAR_BGALPHA = 0.35
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

-----------------------------------------------------------------------
-- FRAME
-----------------------------------------------------------------------
local function OnFrameDragStart(frame, button)	--called when anchor frame starts being dragged
	if not frame.profile.locked then
		frame:StartMoving()
	end
end

local function OnFrameDragStop(frame, button)	--called when anchor frame is done being dragged
	if not frame.profile.locked then
		frame:StopMovingOrSizing()
		mod:SaveFramePos(frame)
	end
end

function mod:SaveFramePos(frame)				--updates saved variables for anchor position
	frame.profile.x = frame:GetLeft()
	frame.profile.y = frame:GetTop()
end

function mod:LockFrame(frame, force)					--shows or hides the anchor and enabled/disables dragging
	--we don't actually hide the window because everything is parented to it.
	--instead we'll just change the properties to make it appear invisible
	if frame.profile.locked == true or force then
		frame:EnableMouse(false)
		frame:SetBackdrop(nil)
		frame:SetBackdropColor(0, 0, 0, 0)
		frame:SetBackdropBorderColor(0, 0, 0, 0)
		frame.text:Hide();
	else
		frame:EnableMouse(true)
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
		frame:SetBackdropColor(0.6, 0.6, 0.6, 0.7)
		frame:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.7)
		frame.text:Show();
	end
	
	--if the window is locked, then the bars need to anchor differently, so handle that now
	self:LayoutBars(frame)
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

function mod:RestoreFramePos(frame)
	local profile = frame.profile
	if(not profile.x or not profile.y) then
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", UIParent, "CENTER")
		profile.x = frame:GetLeft()
		profile.y = frame:GetTop()
	else
		x = profile.x
		y = profile.y

		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
		frame:SetUserPlaced(nil)
	end
end

function mod:CreateFrame()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:SetUserPlaced(false)
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:SetScript("OnDragStart", OnFrameDragStart)
	frame:SetScript("OnDragStop", OnFrameDragStop)
	frame:RegisterForDrag("LeftButton");
	
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
	
	frame.bars = {}
	
	return frame
end

function mod:InitializeFrame(frame, profile)
	frame.profile = profile
	frame:SetParent(UIParent)
	frame:SetWidth(profile.barwidth)
	frame:SetHeight(ANCHOR_BAR_HEIGHT)
	frame:SetScale(profile.scale)
	frame:SetAlpha(profile.alpha)
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
	while #frame.bars > 0 do
		self:RecycleBar(frame.bars[1])
	end

	wipe(frame.bars)
	
	tinsert(FRAMEPOOL.Frames, frame)
	frame:Hide()
	frame:SetParent(FRAMEPOOL)
	frame:ClearAllPoints()
end

------------------------------------------------------------------
--BARS
------------------------------------------------------------------
function mod:GetBarForInstance(frame, instance)	--searches for the bar matching a given hermes instance
	for _, bar in ipairs(frame.bars) do
		if bar.instance == instance then
			return bar
		end
	end
end

function mod:LayoutBars(frame)					--sorts and repositions the bars
	local profile = frame.profile
	local height = profile.barheight
	local width = profile.barwidth
	
	--go ahead and resort the bars based on duration
	self:BarSort(frame)
	
	--now reposition all the bars
	local count = 1
	for _, bar in ipairs(frame.bars) do
		if profile.hideSelf and profile.hideSelf == true and bar.instance.sender.name == UnitName("player") then
			--hide the bar
			bar:Hide()
			bar:ClearAllPoints()
		else
			local offset, apBar, apAnchor
			offset = ( count - 1 ) * (height + profile.barGap)
			if profile.growup == false then
				--down
				offset = offset * -1
				apBar = "TOP"
				
				--if locked, then anchor to the "top" of the frame instead of the bottom
				if profile.locked == true then
					apAnchor = "TOP"
				else
					apAnchor = "BOTTOM"
				end
			else
				--up
				apBar = "BOTTOM"
				
				--if locked, then anchor to the "bottom" of the frame instead of the top
				if profile.locked == true then
					apAnchor = "BOTTOM"
				else
					apAnchor = "TOP"
				end
			end

			bar:ClearAllPoints()
			
			bar:SetPoint(apBar, frame, apAnchor, 0, offset) -- TOP/BOTTOM assignment
			bar:SetPoint("LEFT", frame, "LEFT", 0, 0)
			--bar:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
			--bar:SetHeight(height)
			--bar:SetWidth(profile.barwidth)
			
			count = count + 1
			
			--show the bar
			bar:Show()
		end
	end
end

function mod:AnimateBar(bar)					--updates the duration text and bar animations
	local frame = bar.frame
	LIBBars:AnimateForegroundTexture(bar, bar.instance.initialDuration, bar.instance.remaining, true)
end

function mod:ReinitBars(frame)					--resets values based on config changes
	for _, bar in ipairs(frame.bars) do
		--LIBBars:StopOneShotAnimation(bar)
		self:InitBar(frame, bar, bar.instance)
	end
end

function mod:InitBar(frame, bar, instance)						--sets all necessary first time values
	bar.instance = instance
	bar.frame = frame
	bar:SetParent(frame)
	
	local profile = frame.profile
	local playerclass = instance.sender.class
	local playername = instance.sender.name
	local spellname = instance.ability.name
	local spellicon = instance.ability.icon
	local barcolor = Hermes:GetClassColorRGB(playerclass)
	local bartexture = LIB_LibSharedMedia:Fetch("statusbar", profile.bartexture)
	local font = LIB_LibSharedMedia:Fetch("font", profile.font)
	
	LIBBars:SetBackgroundTexture(bar, bartexture)
	LIBBars:SetForegroundTexture(bar, bartexture)
	LIBBars:SetBackgroundTextureColor(bar, 0.3, 0.3, 0.3, BAR_BGALPHA)
	LIBBars:SetForegroundTextureColor(bar, barcolor.r, barcolor.g, barcolor.b, 1)
	LIBBars:SetOneShotTextureColor(bar, profile.osFGColor.r, profile.osFGColor.g, profile.osFGColor.b, profile.osFGColor.a)
	LIBBars:SetIconTexture(bar, spellicon)
	LIBBars:SetFontColorText(bar, 1, 1, 1, 1)
	LIBBars:SetFontColorDuration(bar, 1, 1, 1, 1)
	LIBBars:SetFont(bar, font, profile.fontsize, true)
	
	if profile.barShowSpellName == true then
		bar.text:SetText(playername.."-"..instance.ability.name)
	else
		bar.text:SetText(playername)
	end
	
	bar.duration:SetText("")
	
	--bar may or may not be visible, depends on whether this was called from ReinitBars
	LIBBars:Draw(bar,
		profile.barwidth,
		profile.barheight,
		profile.barIcon,
		profile.barTextSide,
		profile.textratio,
		profile.barCooldownDirection,
		profile.barCooldownStyle,
		profile.osCooldownDirection,
		profile.osCooldownStyle)
end

function mod:RecycleBar(bar)				--recycles an existing bar
	_deleteFromIndexedTable(bar.frame.bars, bar)
	--bar:Hide()
	bar.instance = nil
	bar.frame = nil
	bar:ClearAllPoints()
	LIBBars:ReleaseBar(bar)
end

function mod:BarSort(frame)						--very simple sort function that sorts by duration
	table.sort(frame.bars,
		function(a, b)
			return a.instance.remaining > b.instance.remaining
		end
	)
end

-----------------------------------------------------------------------
-- VIEW
-----------------------------------------------------------------------
function mod:GetViewDisplayName() --REQUIRED
	return "CooldownBars"
end

function mod:GetViewDisplayDescription() --REQUIRED
	return L["COOLDOWNBARS_VIEW_DESCRIPTION"]
end

function mod:GetViewDefaults() --REQUIRED
	local defaults = {
		locked = false,
		scale = 1,
		alpha = 1,
		barwidth = 180,
		barheight = 14,
		bartexture = "Blizzard",
		textratio = 60,
		growup = false, --true = down, false = up
		font = "Friz Quadrata TT",
		fontsize = 12,
		hideSelf = false,
		barGap = 1,
		barTextSide = "left",
		barCooldownStyle = "full",
		barCooldownDirection = "right",
		barIcon = "left",
		osEnabled = false,
		osCooldownStyle = "full",
		osCooldownDirection = "right",
		osFGColor = {r = 0, g = 1, b = 0, a = 1 },
		barShowSpellName = false,
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
		growup = {
			type = "toggle",
			name = L["Grow Up"],
			width = "normal",
			get = function(info) return profile.growup end,
			order = 10,
			set = function(info, value)
				profile.growup = value
				self:LayoutBars(frame)
			end,
		},
		hideSelf = {
			type = "toggle",
			name = L["Hide Self"],
			width = "normal",
			get = function(info) return profile.hideSelf end,
			order = 15,
			set = function(info, value)
				profile.hideSelf = value
				self:LayoutBars(frame)
			end,
		},
		anchor = {
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
			},
		},
		layout = {
			type = "group",
			name = L["Layout"],
			inline = false,
			order = 15,
			args = {
				barShowSpellName = {
					type = "toggle",
					name = L["Show Spell Name"],
					width = "full",
					get = function(info) return profile.barShowSpellName end,
					order = 5,
					set =function(info, value)
						profile.barShowSpellName = value
						self:ReinitBars(frame)
					end,
				},
				barTextSide = {
					type = "toggle",
					name = L["Swap Name and Duration"],
					width = "full",
					get = function(info) return profile.barTextSide == "right" end,
					order = 10,
					set =function(info, value)
						if value == true then
							profile.barTextSide = "right"
						else
							profile.barTextSide = "left"
						end
						self:ReinitBars(frame)
					end,
				},
				icon = {
					type = "select",
					name = L["Icon"],
					width = "full",
					get = function(info)
						return profile.barIcon
					end,
					order = 15,
					style = "dropdown",
					set = function(info, value)
						profile.barIcon = value
						self:ReinitBars(frame)
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
					order = 20,
					style = "dropdown",
					width = "full",
					get = function(info)
						return profile.barCooldownStyle
					end,
					set = function(info, value)
						profile.barCooldownStyle = value
						self:ReinitBars(frame)
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
					order = 25,
					set =function(info, value)
						if value == true then
							profile.barCooldownDirection = "left"
						else
							profile.barCooldownDirection = "right"
						end
						self:ReinitBars(frame)
					end,
				},
				barGap = {
					type = "range",
					min = 0, max = 50, step = 1,
					name = L["Gap Between Bars"],
					width = "full",
					get = function(info) return profile.barGap end,
					order = 30,
					set = function(info, value)
						profile.barGap = value
						self:LayoutBars(frame)
					end,
				},
			},
		},
		bars = {
			type = "group",
			name = L["Bars"],
			inline = false,
			order = 20,
			args = {
				height = {
					type = "range",
					min = 1, max = 45, step = 1,
					name = L["Height"],
					order = 5,
					width = "full",
					get = function(info) return profile.barheight end,
					set = function(info, value)
						profile.barheight = value
						self:ReinitBars(frame)
						self:LayoutBars(frame)
					end
				},
				width = {
					type = "range",
					min = 50, max = 500, step = 1,
					name = L["Width"],
					order = 10,
					width = "full",
					get = function(info) return profile.barwidth end,
					set = function(info, value)
						profile.barwidth = value
						frame:SetWidth(profile.barwidth)
						self:ReinitBars(frame)
					end
				},
				bartexture = {
					type = 'select',
					order = 15,
					dialogControl = 'LSM30_Statusbar',
					name = L["Texture"],
					values = AceGUIWidgetLSMlists.statusbar,
					width = "full",
					get = function() return profile.bartexture end,
					set = function(info, value)
						profile.bartexture = value
						self:ReinitBars(frame)
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
						self:ReinitBars(frame)
					end,
				},
				fontsize = {
					type = "range",
					min = 5, max = 30, step = 1,
					name = L["Font Size"],
					width = "full",
					get = function(info) return profile.fontsize end,
					order = 25,
					set = function(info, value)
						profile.fontsize = value
						self:ReinitBars(frame)
					end,
				},
				textratio = {
					type = "range",
					min = 0, max = 100, step = 1,
					name = L["Player/Duration Width Ratio (%)"],
					width = "full",
					get = function(info) return profile.textratio end,
					order = 30,
					set = function(info, value)
						profile.textratio = value
						self:ReinitBars(frame)
					end,
				},
			},
		},
		oneshottimer = {
			name = L["Duration Timer"],
			type = "group",
			inline = false,
			childGroups = "tab",
			order = 30,
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
						--self:ReinitBars(frame)
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
						--self:ReinitBars(frame)
						for _, bar in ipairs(frame.bars) do
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
						--self:ReinitBars(frame)
						for _, bar in ipairs(frame.bars) do
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
							
						self:ReinitBars(frame)
					end,
				},
			},
		},
	}
		
	return options
end

function mod:OnViewNameChanged(view, old, new)
	local frame = view.frame
	frame.text:SetText(new)
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

function mod:UpgradeProfile(profile)
	--do db upgrades
	local defaults = self:GetViewDefaults()
	if profile.osEnabled == nil then
		profile.osEnabled = defaults.osEnabled
	end
	if profile.osCooldownStyle == nil then
		profile.osCooldownStyle = defaults.osCooldownStyle
	end
	if profile.osCooldownDirection == nil then
		profile.osCooldownDirection = defaults.osCooldownDirection
	end
	if profile.osFGColor == nil then
		profile.osFGColor = _deepcopy(defaults.osFGColor)
	end
	wipe(defaults)
end

function mod:AcquireView(view) --REQUIRED
	local profile = view.profile
	--upgrade database
	self:UpgradeProfile(profile)
	local frame = self:FetchFrame(profile)
	view.frame = frame
	frame.view = view
	frame.text:SetText(view.name)
	self:RestoreFramePos(frame)
	self:LockFrame(frame)
	frame:Show()
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

function mod:OnInstanceRemoved(view, ability, instance) --OPTIONAL
	local frame = view.frame
	local bar = self:GetBarForInstance(frame, instance)
	if bar then
		self:RecycleBar(bar)
		self:LayoutBars(frame)
	end
end

function mod:OnInstanceStartCooldown(view, ability, instance) --OPTIONAL
	local frame = view.frame
	
	local bar = self:GetBarForInstance(frame, instance)
	if not bar then
		--need to create a new bar
		bar = LIBBars:AcquireBar()
		tinsert(frame.bars, bar)
	else
		--bar already exists, do nothing. It will get reinitialized and redrawn below
	end
	
	self:InitBar(frame, bar, instance)
	
	if frame.profile.osEnabled == true then
		--see if there is a "duration" metadata value
		local metadata = Hermes:GetAbilityMetaDataValue(ability.id, "duration") or Hermes:GetAbilityMetaDataValue(ability.id, "2ndcooldown") --legacy treck support
		if metadata then
			--validate metadata is a number before trying to do math
			local number = tonumber(metadata)
			if number ~= nil and number > 0 and number <= 3600 then 
				local remaining = number - (bar.instance.initialDuration - bar.instance.remaining)
				if remaining > 0 then
					LIBBars:StartOneShotAnimation(bar, remaining, true)
				end
			end
		end
	end
	
	self:AnimateBar(bar) --it's important to animate before display, otherwise you may get "flashes" if the bar is full when in empty display mode.
	self:LayoutBars(frame)
end

function mod:OnInstanceUpdateCooldown(view, ability, instance) --OPTIONAL
	local frame = view.frame
	local bar = self:GetBarForInstance(frame, instance)
	if bar then
		self:AnimateBar(bar)
	end
end

function mod:OnInstanceStopCooldown(view, ability, instance) --OPTIONAL
	local frame = view.frame
	local bar = self:GetBarForInstance(frame, instance)
	if bar then
		LIBBars:StopForegroundAnimation(bar)
		self:RecycleBar(bar)
		self:LayoutBars(frame)
	end
end



