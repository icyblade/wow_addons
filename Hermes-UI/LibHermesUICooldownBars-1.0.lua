--[[
Create one shot timer
]]--
local MAJOR, MINOR = "LibHermesUICooldownBars-1.0", 100001
local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

-----------------------------------------------------------------------
-- LOCALS
-----------------------------------------------------------------------
local BARPOOL = nil
local BAR_SPARK_WIDTH = 10
local BAR_SPARK_EXTRA_HEIGHT = 10
local BAR_FONTGAP = 2
local UPDATE_FREQUENCY = 0.06 --just set it to match hermes frequency
local DFGTC = {r = 1, g = 1, b = 1, a = 1 }
local DBGTC = {r = 0.3, g = 0.3, b = 0.3, a = 0.3 }
local DFC = {r = 0, g = 0, b = 0, a = 1 }

-----------------------------------------------------------------------
-- HELPERS
-----------------------------------------------------------------------
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

local function _createBarPool()
	BARPOOL = CreateFrame("Frame", nil, UIParent)
	BARPOOL:SetPoint("CENTER")
	BARPOOL:SetWidth(50)
	BARPOOL:SetHeight(50)
	BARPOOL:Hide()

	BARPOOL:EnableMouse(false)
	BARPOOL:SetMovable(false)
	BARPOOL:SetToplevel(false)
	BARPOOL.Bars = {}
end

local function _resetBar(bar)
	bar:Hide() -- hide by default
	lib:StopForegroundAnimation(bar) --this also stops one shot animation if it's running
	bar:ClearAllPoints()
	bar:EnableMouse(false) --allow clickthrough
	bar:SetMovable(false)
	bar:SetResizable(false)
	bar:SetToplevel(true)
	
	--bar defaults
	bar.width = 100
	bar.height = 20
	bar.iconside = "left"
	bar.nameside = "left"
	bar.textratio = 50
	bar.animationdir = "right"
	bar.animationstyle = "empty"
	bar.fganimating = nil
	bar.oneshotlastonupdate = nil
	bar.oneshotanimating = nil
	bar.oneshotshowtime = nil
	
	--bgtexture
	bar.bg:SetTexture(bar, "")
	bar.bg:SetVertexColor(DBGTC.r, DBGTC.g, DBGTC.b, DBGTC.a)
	bar.bg:ClearAllPoints()
	bar.bg:Hide() --only shows when animating
	
	--fgtexture
	bar.fg:SetTexture(bar, "")
	bar.fg:SetVertexColor(DFGTC.r, DFGTC.g, DFGTC.b, DFGTC.a)
	bar.fg:ClearAllPoints()
	bar.fg:Show() --always shows

	--spark
	bar.spark:ClearAllPoints()
	bar.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	bar.spark:SetWidth(BAR_SPARK_WIDTH)
	bar.spark:SetBlendMode("ADD")
	bar.spark:Hide() --only show when animation
	
	--oneshottexture
	bar.oneshottexture:SetTexture(bar, "")
	bar.oneshottexture:SetVertexColor(DFGTC.r, DFGTC.g, DFGTC.b, DFGTC.a)
	bar.oneshottexture:ClearAllPoints()
	bar.oneshottexture:Hide() --onlt shows when animating
	
	--oneshotspark
	bar.oneshotspark:ClearAllPoints()
	bar.oneshotspark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	bar.oneshotspark:SetWidth(BAR_SPARK_WIDTH)
	bar.oneshotspark:SetBlendMode("ADD")
	bar.oneshotspark:Hide() --only show when animating
	
	--icon
	bar.icon:ClearAllPoints()
	bar.icon:SetTexture("")
	bar.icon:SetTexCoord(0.1,0.9,0.1,0.9)
	bar.icon:Hide()
	
	--text
	bar.text:ClearAllPoints()
	bar.text:SetFontObject("GameFontWhite")
	bar.text:SetWordWrap(false)
	bar.text:SetJustifyV("CENTER") --defaults, could change
	bar.text:SetJustifyH("LEFT") --defaults, could change
	bar.text:SetText("")
	bar.text:SetTextColor(DFC.r, DFC.g, DFC.b, DFC.a)
	bar.text:SetShadowColor(0, 0, 0, 1) --default include drop shadow
	bar.text:SetShadowOffset(1, -1) --default include drop shadow
	
	--duration
	bar.duration:ClearAllPoints()
	bar.duration:SetFontObject("GameFontWhite")
	bar.duration:SetWordWrap(false)
	bar.duration:SetJustifyV("CENTER") --defaults, could change
	bar.duration:SetJustifyH("RIGHT") --defaults, could change
	bar.duration:SetText("")
	bar.duration:SetTextColor(DFC.r, DFC.g, DFC.b, DFC.a)
	bar.duration:SetShadowColor(0, 0, 0, 0.5) --default include drop shadow
	bar.duration:SetShadowOffset(1, -1) --default include drop shadow
end

local function _createBar()
	--bar frame
	local bar = CreateFrame("Frame", nil, nil)
	
	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.fg = bar:CreateTexture(nil, "BORDER")
	bar.spark = bar:CreateTexture(nil, "OVERLAY")
	bar.oneshottexture = bar:CreateTexture(nil, "BORDER")
	bar.oneshotspark = bar:CreateTexture(nil, "OVERLAY")
	bar.icon = bar:CreateTexture(nil, "OVERLAY")
	bar.text = bar:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	bar.duration = bar:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	
	_resetBar(bar)
	
	return bar
end

local function _getTextWidths(bar)
	local maxw = bar.bg:GetWidth() --always utilize the width of the bg texture for this, not the width of the bar because it's different if the icon is showing
	local wt, wd
	
	--account for 0%/100% ratios
	if bar.textratio <= 0 then
		wt = 0
		wd = maxw
	elseif bar.textratio >= 100 then
		wt = maxw
		wd = 0
	else
		wt = maxw * (bar.textratio / 100)
		wd = maxw - wt
	end
	
	return wt, wd
end

do
	_createBarPool()
end

--------------------------------------------------------------------
-- ACQUIRE/RELEASE
--------------------------------------------------------------------
function lib:AcquireBar()
	local bar
	if(#BARPOOL.Bars > 0) then
		bar = BARPOOL.Bars[1]
		_deleteFromIndexedTable(BARPOOL.Bars, bar)
	else
		bar = _createBar()
	end

	return bar
end

function lib:ReleaseBar(bar)
	tinsert(BARPOOL.Bars, bar)
	_resetBar(bar)
	bar:SetParent(BARPOOL)
end

--------------------------------------------------------------------
-- PROPERTIES
--------------------------------------------------------------------
function lib:SetBackgroundTexture(bar, texture)
	bar.bg:SetTexture(texture)
end

function lib:SetBackgroundTextureColor(bar, r, g, b, a)
	bar.bg:SetVertexColor(r, g, b, a)
end

function lib:SetForegroundTexture(bar, texture)
	bar.fg:SetTexture(texture)
	bar.oneshottexture:SetTexture(texture)
end

function lib:SetForegroundTextureColor(bar, r, g, b, a)
	bar.fg:SetVertexColor(r, g, b, a)
	bar.spark:SetVertexColor(r, g, b, a)
end

function lib:SetOneShotTextureColor(bar, r, g, b, a)
	bar.oneshottexture:SetVertexColor(r, g, b, a)
	bar.oneshotspark:SetVertexColor(r, g, b, a)
end

function lib:SetFont(bar, filename, height, usedropshadow, extrathick)
	local flags = ""
	
	if extrathick and extrathick == true then
		flags = "OUTLINE"
	end
	
	bar.text:SetFont(filename, height, flags)
	bar.duration:SetFont(filename, height, flags)
	
	if usedropshadow == true then
		bar.text:SetShadowColor(0, 0, 0, 1)
		bar.text:SetShadowOffset(1, -1)
		bar.duration:SetShadowColor(0, 0, 0, 1)
		bar.duration:SetShadowOffset(1, -1)
	else
		bar.text:SetShadowColor(0, 0, 0, 0)
		bar.text:SetShadowOffset(0, 0)
		bar.duration:SetShadowColor(0, 0, 0, 0)
		bar.duration:SetShadowOffset(0, 0)
	end
end

function lib:SetFontColorText(bar, r, g, b, a)
	bar.text:SetTextColor(r, g, b, a)
end

function lib:SetFontColorDuration(bar, r, g, b, a)
	bar.duration:SetTextColor(r, g, b, a)
end

function lib:SetIconTexture(bar, texture)
	bar.icon:SetTexture(texture)
end

function lib:SetWidth(bar, width, redraw)
	bar.width = width
	if redraw then
		self:Draw(bar, bar.width, bar.height, bar.iconside, bar.nameside, bar.textratio, bar.animationdir, bar.animationstyle, bar.oneshotanimationdir, bar.oneshotanimationstyle)
	end
end

function lib:SetHeight(bar, height, redraw)
	bar.height = height
	if redraw then
		self:Draw(bar, bar.width, bar.height, bar.iconside, bar.nameside, bar.textratio, bar.animationdir, bar.animationstyle, bar.oneshotanimationdir, bar.oneshotanimationstyle)
	end
end

function lib:SetIconLocation(bar, iconside, redraw)
	bar.iconside = iconside
	if redraw then
		self:Draw(bar, bar.width, bar.height, bar.iconside, bar.nameside, bar.textratio, bar.animationdir, bar.animationstyle, bar.oneshotanimationdir, bar.oneshotanimationstyle)
	end
end

function lib:SetNameSide(bar, nameside, redraw)
	bar.nameside = nameside
	if redraw then
		self:Draw(bar, bar.width, bar.height, bar.iconside, bar.nameside, bar.textratio, bar.animationdir, bar.animationstyle, bar.oneshotanimationdir, bar.oneshotanimationstyle)
	end
end

function lib:SetTextRatio(bar, textratio, redraw)
	bar.textratio = textratio
	if redraw then
		self:Draw(bar, bar.width, bar.height, bar.iconside, bar.nameside, bar.textratio, bar.animationdir, bar.animationstyle, bar.oneshotanimationdir, bar.oneshotanimationstyle)
	end
end

function lib:SetAnimationDirection(bar, animationdir, redraw)
	bar.animationdir = animationdir
	if redraw then
		self:Draw(bar, bar.width, bar.height, bar.iconside, bar.nameside, bar.textratio, bar.animationdir, bar.animationstyle, bar.oneshotanimationdir, bar.oneshotanimationstyle)
	end
end

function lib:SetOneShotAnimationDirection(bar, oneshotanimationdir, redraw)
	bar.oneshotanimationdir = oneshotanimationdir
	if redraw then
		self:Draw(bar, bar.width, bar.height, bar.iconside, bar.nameside, bar.textratio, bar.animationdir, bar.animationstyle, bar.oneshotanimationdir, bar.oneshotanimationstyle)
	end
end

function lib:SetAnimationStyle(bar, animationstyle, redraw)
	bar.animationstyle = animationstyle
	if redraw then
		self:Draw(bar, bar.width, bar.height, bar.iconside, bar.nameside, bar.textratio, bar.animationdir, bar.animationstyle, bar.oneshotanimationdir, bar.oneshotanimationstyle)
	end
end

function lib:SetOneShotAnimationStyle(bar, oneshotanimationstyle, redraw)
	bar.oneshotanimationstyle = oneshotanimationstyle
	if redraw then
		self:Draw(bar, bar.width, bar.height, bar.iconside, bar.nameside, bar.textratio, bar.animationdir, bar.animationstyle, bar.oneshotanimationdir, bar.oneshotanimationstyle)
	end
end

function lib:SetSize(bar, width, height, redraw)
	bar.width = width
	bar.height = height
	if redraw then
		self:Draw(bar, bar.width, bar.height, bar.iconside, bar.nameside, bar.textratio, bar.animationdir, bar.animationstyle, bar.oneshotanimationdir, bar.oneshotanimationstyle)
	end
end

--------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------
function lib:Draw(bar, width, height, iconside, nameside, textratio, animationdir, animationstyle, oneshotanimationdir, oneshotanimationstyle)
	if nameside ~= "right" then nameside = "left" end							--text on left by default
	if textratio == nil then textratio = 50 end									--50:50 ratio by default
	if animationdir ~= "left" then animationdir = "right" end					--animate to the right by default
	if animationstyle ~= "full" then animationstyle = "empty" end					--default style is empty
	if oneshotanimationdir ~= "left" then oneshotanimationdir = "right" end					--animate to the right by default
	if oneshotanimationstyle ~= "full" then oneshotanimationstyle = "empty" end					--default style is empty
	
	bar.width = width
	bar.height = height
	bar.iconside = iconside
	bar.nameside = nameside
	bar.textratio = textratio
	bar.animationdir = animationdir
	bar.animationstyle = animationstyle
	bar.oneshotanimationdir = oneshotanimationdir
	bar.oneshotanimationstyle = oneshotanimationstyle
	
	bar.bg:ClearAllPoints()
	bar.fg:ClearAllPoints()
	bar.icon:ClearAllPoints()
	bar.text:ClearAllPoints()
	bar.duration:ClearAllPoints()
	bar.spark:ClearAllPoints()
	bar.oneshottexture:ClearAllPoints()
	bar.oneshotspark:ClearAllPoints()
	
	bar:SetWidth(bar.width)
	bar:SetHeight(bar.height)
	
	---------------------------
	--layout icon
	---------------------------
	if iconside == "right" then
		bar.icon:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
		bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
		bar.icon:Show()
	elseif iconside == "none" then
		bar.icon:Hide()
	else
		--default is left
		bar.icon:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		bar.icon:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
		bar.icon:Show()
	end
	
	bar.icon:SetWidth(bar.height)
	
	---------------------------
	--layout textures
	---------------------------
	if iconside == "right" then
		--set bg texture
		bar.bg:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		bar.bg:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
		bar.bg:SetWidth(bar.width - bar.height)
		--set fg texture, depends on animationdir, do not set anchor points on both left and right sides
		if animationdir == "right" then
			--flows from left to right ---->
			bar.fg:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
			bar.fg:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
			if not bar.fganimating then bar.fg:SetWidth(bar.bg:GetWidth()) end
		else
			--flows from right to left <----
			bar.fg:SetPoint("TOPRIGHT", bar.icon, "TOPLEFT", 0, 0)
			bar.fg:SetPoint("BOTTOMRIGHT", bar.icon, "BOTTOMLEFT", 0, 0)
			if not bar.fganimating then bar.fg:SetWidth(bar.bg:GetWidth()) end
		end
	elseif iconside == "none" then
		--set bg texture
		bar.bg:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		bar.bg:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
		bar.bg:SetWidth(bar.width)
		
		--set fg texture, depends on animationdir, do not set anchor points on both left and right sides
		if animationdir == "right" then
			--flows from left to right ---->
			bar.fg:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
			bar.fg:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
			if not bar.fganimating then bar.fg:SetWidth(bar.bg:GetWidth()) end
		else
			--flows from right to left <----
			bar.fg:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
			bar.fg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
			if not bar.fganimating then bar.fg:SetWidth(bar.bg:GetWidth()) end
		end
	else --default is left
		--set bg texture
		bar.bg:SetPoint("TOPLEFT", bar.icon, "TOPRIGHT", 0, 0)
		bar.bg:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT", 0, 0)
		bar.bg:SetWidth(bar.width - bar.height)
		
		--set fg texture, depends on animationdir, do not set anchor points on both left and right sides
		if animationdir == "right" then
			--flows from left to right ---->
			bar.fg:SetPoint("TOPLEFT", bar.icon, "TOPRIGHT", 0, 0)
			bar.fg:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT", 0, 0)
			if not bar.fganimating then bar.fg:SetWidth(bar.bg:GetWidth()) end
		else
			--flows from right to left <----
			bar.fg:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
			bar.fg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
			if not bar.fganimating then bar.fg:SetWidth(bar.bg:GetWidth()) end
		end
	end
	
	---------------------------
	--layout oneshot textures
	---------------------------
	if iconside == "right" then
		--set fg texture, depends on animationdir, do not set anchor points on both left and right sides
		if oneshotanimationdir == "right" then
			--flows from left to right ---->
			bar.oneshottexture:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
			bar.oneshottexture:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
			if not bar.oneshotanimating then bar.oneshottexture:SetWidth(bar.bg:GetWidth()) end
		else
			--flows from right to left <----
			bar.oneshottexture:SetPoint("TOPRIGHT", bar.icon, "TOPLEFT", 0, 0)
			bar.oneshottexture:SetPoint("BOTTOMRIGHT", bar.icon, "BOTTOMLEFT", 0, 0)
			if not bar.oneshotanimating then bar.oneshottexture:SetWidth(bar.bg:GetWidth()) end
		end
	elseif iconside == "none" then
		--set fg texture, depends on animationdir, do not set anchor points on both left and right sides
		if oneshotanimationdir == "right" then
			--flows from left to right ---->
			bar.oneshottexture:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
			bar.oneshottexture:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
			if not bar.oneshotanimating then bar.oneshottexture:SetWidth(bar.bg:GetWidth()) end
		else
			--flows from right to left <----
			bar.oneshottexture:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
			bar.oneshottexture:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
			if not bar.oneshotanimating then bar.oneshottexture:SetWidth(bar.bg:GetWidth()) end
		end
	else --default is left
		--set fg texture, depends on animationdir, do not set anchor points on both left and right sides
		if oneshotanimationdir == "right" then
			--flows from left to right ---->
			bar.oneshottexture:SetPoint("TOPLEFT", bar.icon, "TOPRIGHT", 0, 0)
			bar.oneshottexture:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT", 0, 0)
			if not bar.oneshotanimating then bar.oneshottexture:SetWidth(bar.bg:GetWidth()) end
		else
			--flows from right to left <----
			bar.oneshottexture:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
			bar.oneshottexture:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
			if not bar.oneshotanimating then bar.oneshottexture:SetWidth(bar.bg:GetWidth()) end
		end
	end
	
	---------------------------
	--layout fonts
	---------------------------
	local wt, wd = _getTextWidths(bar)
	if wt > 0 then bar.text:SetWidth(wt) end
	if wd > 0 then bar.duration:SetWidth(wd) end
	
	if iconside == "right" then
		if nameside == "left" then
			bar.text:SetPoint("TOPLEFT", bar, "TOPLEFT", BAR_FONTGAP, 0)
			bar.text:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", BAR_FONTGAP, 0)
			bar.text:SetJustifyH("LEFT")
			
			bar.duration:SetPoint("TOPRIGHT", bar.icon, "TOPLEFT", -BAR_FONTGAP, 0)
			bar.duration:SetPoint("BOTTOMRIGHT", bar.icon, "BOTTOMLEFT", -BAR_FONTGAP, 0)
			bar.duration:SetJustifyH("RIGHT");
		else
			bar.text:SetPoint("TOPRIGHT", bar.icon, "TOPLEFT", -BAR_FONTGAP, 0)
			bar.text:SetPoint("BOTTOMRIGHT", bar.icon, "BOTTOMLEFT", -BAR_FONTGAP, 0)
			bar.text:SetJustifyH("RIGHT");
			
			bar.duration:SetPoint("TOPLEFT", bar, "TOPLEFT", BAR_FONTGAP, 0)
			bar.duration:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", BAR_FONTGAP, 0)
			bar.duration:SetJustifyH("LEFT")
		end
	elseif iconside == "none" then
		if nameside == "left" then
			bar.text:SetPoint("TOPLEFT", bar, "TOPLEFT", BAR_FONTGAP, 0)
			bar.text:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", BAR_FONTGAP, 0)
			bar.text:SetJustifyH("LEFT")
			
			bar.duration:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -BAR_FONTGAP, 0)
			bar.duration:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -BAR_FONTGAP, 0)
			bar.duration:SetJustifyH("RIGHT");
		else
			bar.text:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -BAR_FONTGAP, 0)
			bar.text:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -BAR_FONTGAP, 0)
			bar.text:SetJustifyH("RIGHT");
			
			bar.duration:SetPoint("TOPLEFT", bar, "TOPLEFT", BAR_FONTGAP, 0)
			bar.duration:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", BAR_FONTGAP, 0)
			bar.duration:SetJustifyH("LEFT")
		end
	else
		--default is left
		if nameside == "left" then
			bar.text:SetPoint("TOPLEFT", bar.icon, "TOPRIGHT", BAR_FONTGAP, 0)
			bar.text:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT", BAR_FONTGAP, 0)
			bar.text:SetJustifyH("LEFT")
			
			bar.duration:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -BAR_FONTGAP, 0)
			bar.duration:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -BAR_FONTGAP, 0)
			bar.duration:SetJustifyH("RIGHT");
		else
			bar.text:SetPoint("TOPRIGHT", bar, "TOPRIGHT", -BAR_FONTGAP, 0)
			bar.text:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -BAR_FONTGAP, 0)
			bar.text:SetJustifyH("RIGHT");
			
			bar.duration:SetPoint("TOPLEFT", bar.icon, "TOPRIGHT", BAR_FONTGAP, 0)
			bar.duration:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT", BAR_FONTGAP, 0)
			bar.duration:SetJustifyH("LEFT")
		end
	end	

	---------------------------
	--layout spark
	---------------------------
	if animationdir == "right" then
		bar.spark:SetPoint("CENTER", bar.fg, "RIGHT", 0, 0)
	else
		bar.spark:SetPoint("CENTER", bar.fg, "LEFT", 0, 0)
	end
	
	---------------------------
	--layout oneshot spark
	---------------------------
	if oneshotanimationdir == "right" then
		bar.oneshotspark:SetPoint("CENTER", bar.oneshottexture, "RIGHT", 0, 0)
	else
		bar.oneshotspark:SetPoint("CENTER", bar.oneshottexture, "LEFT", 0, 0)
	end
	
	bar.spark:SetHeight(bar.height + BAR_SPARK_EXTRA_HEIGHT)
	bar.oneshotspark:SetHeight(bar.height + BAR_SPARK_EXTRA_HEIGHT)
end

--------------------------------------------------------------------
-- FOREGROUND ANIMATION
--------------------------------------------------------------------
function lib:AnimateForegroundTexture(bar, initial, current, showtime)
	--flag that the foreground animation has started
	bar.fganimating = 1
	
	--we want to set the size of the texture even if the secondary animation is running, because the secondary animation will eventally show
	local maxw = bar.bg:GetWidth() --always utilize the width of the bg texture for this, not the width of the bar because it's different if the icon is showing
	if bar.animationstyle == "full" then --starts out full
		width = (current / initial) * maxw
		--just some simple error handling to prevent crazy math errors or bad calls to animate
		if width >= maxw then
			width = maxw
		end
		bar.fg:SetWidth(width)
	else  --starts out empty
		width = maxw - ((current / initial) * maxw)
		--if current / initial == 0 then we need to manually set the size to 1. Anything other than zero!! Otherwise the bar size doesn't actuall change
		if width <= 1 then
			width = 1
		end
		bar.fg:SetWidth(width)
	end

	--don't set the text or do anything with spark and background if the secondary animation is running
	if not bar.oneshotanimating then
		if showtime and showtime == true then
			local h, m, s = _secondsToClock(current)
			if h then
				bar.duration:SetFormattedText("%d:%02.f:%02.f", h, m, s)
			elseif m then
				bar.duration:SetFormattedText("%d:%02.f", m, s)
			else
				bar.duration:SetFormattedText("%d", s)
			end
		else
			bar.duration:SetFormattedText("")
		end
		bar.spark:Show()
		bar.bg:Show()
	end
end

function lib:StopForegroundAnimation(bar)
	--indicate no longer animating
	bar.fganimating = nil
	
	--this is just a safe check to ensure that any style changes are reset.
	--The assumption being made here is that it's never proper to have a secondary animation >= the foreground animation
	self:StopOneShotAnimation(bar)
	
	--hide the spark
	bar.spark:Hide()
	
	--update the width
	bar.fg:SetWidth(bar.bg:GetWidth())

	--show the fg texture again in case it was hidden due to OnShotAnimation running
	bar.fg:Show()
	
	--reset duration text
	bar.duration:SetFormattedText("")
	
	--hide the background
	bar.bg:Hide()
end

--------------------------------------------------------------------
-- ONESHOT ANIMATION
--------------------------------------------------------------------
local function OnOneShotAnimation(bar, elapsed)
	bar.oneshotlastonupdate = bar.oneshotlastonupdate + elapsed
	bar.oneshotremaining = bar.oneshotremaining - elapsed --update the remainder on the secondary animation
	while (bar.oneshotlastonupdate > UPDATE_FREQUENCY) do
		bar.oneshotlastonupdate = bar.oneshotlastonupdate - UPDATE_FREQUENCY
		
		if bar.oneshotremaining <= 0 then
			--stop the animation if it's completed, this will kill the event and reset everything correctly
			lib:StopOneShotAnimation(bar)
			return
		end

		local maxw = bar.bg:GetWidth() --always utilize the width of the bg texture for this, not the width of the bar because it's different if the icon is showing
		
		if bar.oneshotshowtime and bar.oneshotshowtime == true then
			local h, m, s = _secondsToClock(bar.oneshotremaining)
			if h then
				bar.duration:SetFormattedText("%d:%02.f:%02.f", h, m, s)
			elseif m then
				bar.duration:SetFormattedText("%d:%02.f", m, s)
			else
				bar.duration:SetFormattedText("%d", s)
			end
		else
			bar.duration:SetFormattedText("")
		end
		
		if bar.oneshotanimationstyle == "full" then --starts out full
			width = (bar.oneshotremaining / bar.oneshotinitial) * maxw
			--just some simple error handling to prevent crazy math errors or bad calls to animate
			if width >= maxw then
				width = maxw
			end
			bar.oneshottexture:SetWidth(width)
		else  --starts out empty
			width = maxw - ((bar.oneshotremaining / bar.oneshotinitial) * maxw)
			--if bar.oneshotremaining / bar.oneshotinitial == 0 then we need to manually set the size to 1. Anything other than zero!! Otherwise the bar size doesn't actuall change
			if width <= 1 then
				width = 1
			end
			bar.oneshottexture:SetWidth(width)
		end
		bar.oneshottexture:Show()
		bar.oneshotspark:Show()
		bar.bg:Show()
	end
end

function lib:StartOneShotAnimation(bar, duration, showtime) --start, stop, and initial are all assumed to be positive values in seconds
	--just do some quick error handling because ultimately the data is untrusted
	local number = tonumber(duration)
	if number == nil or number <= 0 or number > 3600 then return end --assume nothing would EVER go higher than 60 minutes!
	
	bar.oneshotinitial = number
	bar.oneshotremaining = number
	bar.oneshotlastonupdate = 0
	bar.oneshotanimating = 1
	bar.oneshotshowtime = showtime
	
	--hide the fg animation or textures regardless of if they're running
	bar.fg:Hide()
	bar.spark:Hide()
	
	bar:SetScript("OnUpdate", OnOneShotAnimation)
end

function lib:StopOneShotAnimation(bar)
	bar.oneshotlastonupdate = nil
	bar:SetScript("OnUpdate", nil)
	bar.oneshotanimating = nil
	bar.oneshotshowtime = nil
	
	bar.duration:SetFormattedText("") --empty out the duration, if fg animation is running it'll get put back to a proper value
	bar.oneshottexture:Hide()
	bar.oneshotspark:Hide()
		
	--only restore the following if the foreground animation is still running
	if bar.fganimating then
		bar.fg:Show()
		bar.spark:Show()
	end
end




