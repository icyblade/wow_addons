--[[
Uber credits must be given to nymbia for the metatables and frames, thanks!
]]
--Ace3 Registering

ClassTimer = LibStub("AceAddon-3.0"):NewAddon("ClassTimer", "AceBucket-3.0", "AceConsole-3.0", "AceEvent-3.0")

local ClassTimer = ClassTimer

local AceDB = LibStub("AceDB-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ClassTimer", true)
local DataBroker = LibStub:GetLibrary("LibDataBroker-1.1",true)
local sm = LibStub("LibSharedMedia-3.0")

local _G = _G
local unpack = _G.unpack
local GetTime = _G.GetTime
local table_sort = _G.table.sort
local math_ceil = _G.math.ceil
local gsub = _G.gsub
local pairs = _G.pairs
local ipairs = _G.ipairs
local UnitIsUnit = _G.UnitIsUnit

local _, enClass = UnitClass("player")
local hasPet = enClass=="HUNTER" or enClass=="WARLOCK" or enClass=="DEATHKNIGHT" or enClass=="MAGE" and true
local unlocked = {}
local sticky = {}
ClassTimer.unlocked = unlocked

local new, del
do
	local cache = setmetatable({}, {__mode='k'})
	function new()
		local t = next(cache)
		if t then
			cache[t] = nil
			return t
		else
			return {}
		end
	end
	function del(t)
		for k in pairs(t) do
			t[k] = nil
		end
		cache[t] = true
		return nil
	end
end
local OnUpdate
local bars
do
	local min = L['%dm']
	local seclong = L['%ds']
	local secshort = L['%.1fs']
	local function tioptionsm(num)
		if num <= 10 then
			return secshort:format(num)
		elseif num <= 60 then
			return seclong:format(num)
		else
			return min:format(math_ceil(num / 60))
		end
	end
	function OnUpdate(frame)
		local currentTime = GetTime()
		local endTime = frame.endTime
		local startTime = frame.startTime
		if currentTime > endTime then
			if unlocked[frame.unit] then unlocked[frame.unit] = nil unlocked.General = nil end
			if frame.unit ~= "sticky" then
				ClassTimer:UpdateUnitBars(frame.unit)
			else
				bars.sticky[sticky[frame.name..frame.unitname]]:Hide()
				ClassTimer:StickyUpdate(sticky[frame.name..frame.unitname])
			end
		else
			local elapsed = (currentTime - startTime)
			if frame.tt then
				frame.timetext:SetText(tioptionsm(endTime - currentTime))
			end
			local sp = frame:GetWidth()*elapsed/(endTime-startTime)
			if frame.reversed then
				frame:SetValue(startTime + elapsed)
				frame.spark:SetPoint('CENTER', frame, 'LEFT', sp, 0)
			else
				frame:SetValue(endTime - elapsed)
				frame.spark:SetPoint('CENTER', frame, 'RIGHT', -sp, 0)
			end
		end

	end
end
do
	local function MouseUp(bar, button)
		if ClassTimer.db.profile.Units[bar.unit].click then
			if button == 'RightButton' then
				local msg = L['%s has %s left']:format(bar.text:GetText(), bar.timetext:GetText())
				if UnitInRaid('player') then
					SendChatMessage(msg, 'RAID')
				elseif GetNumSubgroupMembers() > 0 then
					SendChatMessage(msg, 'PARTY')
				end
			end
		end
	end

	local framefactory = {
		__index = function(t,k)
			local bar = CreateFrame('StatusBar', nil, UIParent)
			t[k] = bar
			bar:SetFrameStrata('MEDIUM')
			bar:Hide()
			bar:SetClampedToScreen(true)
			bar:SetScript('OnUpdate', OnUpdate)
			bar:SetBackdrop({bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background', tile = true, tileSize = 16})
			bar.text = bar:CreateFontString(nil, 'OVERLAY')
			bar.timetext = bar:CreateFontString(nil, 'OVERLAY')
			bar.icon = bar:CreateTexture(nil, 'DIALOG')
			bar:SetScript('OnMouseUp', MouseUp)

			local spark = bar:CreateTexture(nil, "OVERLAY")
			bar.spark = spark
			spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
			spark:SetWidth(16)
			spark:SetBlendMode("ADD")
			spark:Show()
			ClassTimer:ApplySettings()
			return bar
		end
	}

	bars = {
		target = setmetatable({}, framefactory),
		focus  = setmetatable({}, framefactory),
		player = setmetatable({}, framefactory),
		sticky = setmetatable({}, framefactory),
		pet    = hasPet and setmetatable({}, framefactory) or nil
	}
	ClassTimer.bars = bars
end

ClassTimer.defaults = {
	profile = {
		Abilities = {},
		Group     = {},
		Sticky    = {},
		Units     = {
			['**']     = {
				enable                 = true,
				buffs                  = true,
				click                  = false,
				debuffs                = true,
				differentColors        = false,
				growup                 = false,
				showIcons              = false,
				icons                  = true,
				iconSide               = 'LEFT',
				scale                  = 1,
				spacing                = 0,
				nametext               = true,
				timetext               = true,
				texture                = 'Blizzard',
				width                  = 150,
				height                 = 16,
				font                   = 'Friz Quadrata TT',
				fontsize               = 9,
				alpha                  = 1,
				scale                  = 1,
				bartext                = '%s (%a) (%u)',
				sizeEnable             = false,
				sizeMax                = 5,
				buffcolor              = {0,0.49, 1, 1},
				alwaysshownbuffcolor   = {0.35, 0.45, 0.6, 1},
				Poisoncolor            = {0, 1, 0, 1},
				Magiccolor             = {0, 0, 1, 1},
				Diseasecolor           = {.55, .15, 0, 1},
				Cursecolor             = {5, 0, 5, 1},
				debuffcolor            = {1.0,0.7, 0, 1},
				alwaysshowndebuffcolor = {0.5, 0.45, 0.1, 1},
				backgroundcolor        = {0,0, 0, 1},
				textcolor              = {1,1,1},
			},
			['focus']  = { click = true },
			['sticky'] = { enable = false },
			['player'] = {},
			['target'] = {},
			['pet'] = {},
		},
	},
	char = {
		Custom = {},
		AlwaysShown = {},
	}
}


function ClassTimer:OnInitialize()
	--Remove Ace2 variables
	if ClassTimerDB and ClassTimerDB.version then
		ClassTimerDB = nil
	end
	if DataBroker then
		local launcher = DataBroker:NewDataObject("ClassTimer", {
		type = "launcher",
		icon = "Interface\\Minimap\\Tracking\\Class",
		OnClick = function(clickedframe, button)
			LibStub("AceConfigDialog-3.0"):Open("ClassTimer")
		end,
		})
	end
	local validate = {}
	local timerargs = {}
	local table =  self:CreateTimers()
	table['Race'] = self:Races()

	for k, v in pairs(table) do
		for n in ipairs(v) do
			ClassTimer.defaults.profile.Abilities[v[n]] = true
		end
		local k = L[k]
		timerargs[k] = {
			type = "group",
			name = k,
			desc = L['Which Buffs to show.'],
			order = 4,
			args = {
				shown = {
					type = 'multiselect',
					name = L["Show"],
					desc = L['Select to show.'],
					get = function(_, key) return self.db.profile.Abilities[key] end,
					set = function(_, key, value) self.db.profile.Abilities[key] = value validate[key] = value and key or nil end,
					values = ClassTimer:List(v),
				}
			}
		}
	end

	self.db = LibStub("AceDB-3.0"):New("ClassTimerDB", self.defaults)
	-- Move the profile-specific Custom timers to the char-specific timers on the first char you log in with
	if self.db.profile.Custom then
		print("ClassTimer: Custom timers have changed from being profile to character specific. The profile-specific custom timers have been copied to this characters custom timers.")
		for k, v in pairs(self.db.profile.Custom) do
			self.db.char.Custom[k] = k
		end
		self.db.profile.Custom = nil
	end
	self.options.args.Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(ClassTimer.db)
	timerargs.Spacer = {
		type = "header",
		order = 1,
		name = L["Timers"]
	}
	timerargs.Extras = {
		type = 'group',
		name = L['Extras'],
		desc = L['Other abilities'],
		order = 10,
		args = {
			Add = {
				type = 'input',
				name = L['Add a custom timer'],
				get = function() return "" end,
				set = function(_, value) self.db.char.Custom[value] = value validate[value] = value end,
				usage = L['<Spell Name in games locale>']
			},
			Remove = {
				type = 'multiselect',
				name = L['Remove a custom timer'],
				get = function() return false end,
				set = function(_, key) self.db.char.Custom[key] = nil validate[key] = nil end,
				values = self.db.char.Custom,
			}
		}
	}
	timerargs.AlwaysShown = {
		type = 'group',
		name = L['AlwaysShown'],
		desc = L['Abilities to track regardless of the caster'],
		order = 11,
		args = {
			Add = {
				type = 'input',
				name = L['Add a timer that is always shown'],
				get = function() return "" end,
				set = function(_, value) self.db.char.AlwaysShown[value] = value validate[value] = value end,
				usage = L['<Spell Name in games locale>']
			},
			Remove = {
				type = 'multiselect',
				name = L['Remove an AlwaysShown timer'],
				get = function() return false end,
				set = function(_, key) self.db.char.AlwaysShown[key] = nil validate[key] = nil end,
				values = self.db.char.AlwaysShown,
			}
		}
	}
	self.options.args.Timers = { type = 'group', order = 1, childGroups = 'tab', name = L['Timers'], desc = L['Enable or disable timers'], args = timerargs}
	for v in pairs(self.db.profile.Abilities) do
		validate[v] = v
	end
	for v in pairs(self.db.char.Custom) do
		validate[v] = v
	end
	for v in pairs(self.db.char.AlwaysShown) do
		validate[v] = v
	end
	self.options.args.BarSettings.args.sticky.args.Sticky.args.addSticky = {
		type = 'multiselect',
		name = L['Add Sticky'],
		desc = L['Add a move to be sticky'],
		get =  function(_, v) return self.db.profile.Sticky[v] end,
		order = 5,
		set = function(_, v, u) self.db.profile.Sticky[v] = u end,
		values = validate
	}

	LibStub("AceConfig-3.0"):RegisterOptionsTable("ClassTimer", self.options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ClassTimer", "ClassTimer")
	self:RegisterChatCommand("ClassTimer", function() LibStub("AceConfigDialog-3.0"):Open("ClassTimer") end )
	ClassTimer.db.RegisterCallback(self, 'OnProfileChanged', ClassTimer.ApplySettings)
	ClassTimer.db.RegisterCallback(self, 'OnProfileCopied', ClassTimer.ApplySettings)
	ClassTimer.db.RegisterCallback(self, 'OnProfileReset', ClassTimer.ApplySettings)

	sm.RegisterCallback(self, "LibSharedMedia_SetGlobal", function(mediatype, override)
		if mediatype == 'statusbar' then
            for _, k in pairs(bars) do
                for _, v in pairs(k) do
                    v:SetStatusBarTexture(sm:Fetch('statusbar', override))
				end
			end
		end
	end )
end

function ClassTimer:OnEnable()
	self:RegisterBucketEvent('UNIT_AURA', 0.25, 'UNIT_AURA')
	self:RegisterEvent('PLAYER_TARGET_CHANGED')
	self:RegisterEvent('PLAYER_FOCUS_CHANGED')
	self:RegisterEvent('PLAYER_PET_CHANGED')
end

function ClassTimer:OnDisable()
	for _, k in pairs(bars) do
		for _, v in pairs(k) do
			v:Hide()
		end
	end
end

function ClassTimer:PLAYER_TARGET_CHANGED()
	self:UpdateUnitBars('target')
end

function ClassTimer:PLAYER_FOCUS_CHANGED()
	self:UpdateUnitBars('focus')
end

function ClassTimer:PLAYER_PET_CHANGED()
	self:UpdateUnitBars('pet')
end

function ClassTimer:UNIT_AURA(units)
	for unit in pairs(units) do
		self:UpdateUnitBars(unit)
	end
end

function ClassTimer:List(table)
	if not table then return end
	local list = {}
	for k, v in pairs(table) do
		list[v] = v
	end
	return list
end

do
	local function sortup(a,b)
			return  a.remaining > b.remaining
	end
	local function sort(a,b)
			return a.remaining < b.remaining
	end
	local function text(text, spell, apps, unit)
		local str = text
		str = gsub(str, '%%s', spell)
		str = gsub(str, '%%u', L[unit])
		str = gsub(str, '%%n', GetUnitName(unit))
		if apps and apps > 1 then
			str = gsub(str, '%%a', apps)
		else
			str = gsub(str, '%%a', '')
		end
		str = gsub(str, '%s%s+', ' ')
		str = gsub(str, '%p%p+', '')
		str = gsub(str, '%s+$', '')
		return str
	end
	local tmp = {}
	local called = false -- prevent recursive calls when new bars are created.
	local stickyset = false
	local whatsMine = {
		player = true,
		pet = true,
		vehicle = true,
	}
	function ClassTimer:GetBuffs(unit, db)
		local currentTime = GetTime()
		if db.buffs then
			local i=1
			while true do
                local name, _, texture, count, _, duration, endTime, caster = UnitBuff(unit, i)
                if not name then
					break
				end
                local isMine = whatsMine[caster] 
				if duration and (self.db.profile.Abilities[name] or self.db.char.Custom[name]) and isMine or self.db.char.AlwaysShown[name] then
					local t = new()
					if self.db.profile.Units.sticky.enable and self.db.profile.Sticky[name] then
						t.startTime = endTime - duration
						t.endTime = endTime
						stickyset = true
						t.unitname = UnitName(unit)
						t.alwaysshown = not ismine and self.db.char.AlwaysShown[name]
						local number = sticky[name..t.unitname] or #sticky+1
						sticky[number] = t
						sticky[name..t.unitname] = number
					elseif isMine then
						tmp[#tmp+1] = t
					elseif self.db.char.AlwaysShown[name] then
						t.alwaysshown = true
						tmp[#tmp+1] = t
					end
					t.name = name
					t.unit = unit
					t.remaining = endTime-currentTime
					t.texture = texture
					t.duration = duration
					t.endTime = endTime
					t.count = count
					t.isbuff = true
				end
				i=i+1
			end
		end
		if db.debuffs then
			local i=1
			while true do
                local name, _, texture, count, debuffType, duration, endTime, caster = UnitDebuff(unit, i)
                if not name then
					break
				end
                local isMine = whatsMine[caster]
				if duration and duration > 0 and (self.db.profile.Abilities[name] or self.db.char.Custom[name]) and isMine or self.db.char.AlwaysShown[name] then
					local t = new()
					if self.db.profile.Units.sticky.enable and self.db.profile.Sticky[name] then
						t.startTime = endTime - duration
						t.endTime = endTime
						stickyset = true
						t.unitname = UnitName(unit)
						t.alwaysshown = not ismine and self.db.char.AlwaysShown[name]
						local number = sticky[name..t.unitname] or #sticky+1
						sticky[number] = t
						sticky[name..t.unitname] = number
					elseif isMine then
						tmp[#tmp+1] = t
					elseif self.db.char.AlwaysShown[name] then
						t.alwaysshown = true
						tmp[#tmp + 1] = t
					end
					t.name = name
					t.unit = unit
					t.texture = texture
					t.duration = duration
					t.remaining = endTime-currentTime
					t.endTime = endTime
					t.count = count
					t.dispelType = debuffType
				end
				i=i+1
			end
		end
	end
	function ClassTimer:UpdateUnitBars(unit)
		if not bars[unit] then return end
		local db = self.db.profile.Units[unit]
		if unlocked[unit] then return end
		if self.db.profile.Group[unit] then unit = self.db.profile.AllInOneOwner end
		if called then
			return
		end
		called = true
		if db.enable then
			local currentTime = GetTime()
			for k in pairs(tmp) do
				tmp[k] = del(tmp[k])
			end
			self:GetBuffs(unit, db)
			if self.db.profile.Group[unit] then
				for k, v in pairs(self.db.profile.Group) do
					if v then
						if k ~= 'focus' then
							if not UnitIsUnit(k, unit) then self:GetBuffs(k, db) end
						else
							if not UnitIsUnit(k, unit) and not UnitIsUnit(k, 'target') then self:GetBuffs(k, db) end
						end
					end
				end
			end
			local sortby = db.growup
			if db.reverseSort then
				sortby = not sortby
			end
			table_sort(tmp, sortby and sortup or sort)

			for k,v in ipairs(tmp) do
				local bar = bars[unit][k]

				bar.text:SetText(text(db.bartext, v.name, v.count, v.unit))
				bar.icon:SetTexture(v.texture)
				local startTime, endTime = v.endTime - v.duration, v.endTime
				bar.startTime = startTime
				bar.unit = unit
				bar.duration = v.duration
				bar.endTime = endTime
				bar.isbuff = v.isbuff
				bar.alwaysshown = v.alwaysshown
				if db.reversed then
					bar.reversed = true
				else
					bar.reversed = nil
				end
				if db.sizeEnable then
					if bar.duration < db.sizeMax then
						local width = (bar.duration/db.sizeMax)*db.width
						bar:SetWidth(width)
						bar.timetext:SetWidth(width)
						bar.text:SetWidth(width - db.fontsize * 2.5)
					else
						bar:SetWidth(db.width)
						bar.timetext:SetWidth(db.width)
						bar.text:SetWidth(db.width - db.fontsize * 2.5)
					end
				end
				if not db.showIcons then
					if bar.alwaysshown then
						bar:SetStatusBarColor(unpack(bar.isbuff and db.alwaysshownbuffcolor or db.alwaysshowndebuffcolor))
					elseif bar.isbuff then
						bar:SetStatusBarColor(unpack(db.buffcolor))
					elseif db.differentColors and v.dispelType then
						bar.dispelType = v.dispelType
						bar:SetStatusBarColor(unpack(db[v.dispelType .. 'color']))
					else
						bar:SetStatusBarColor(unpack(db.debuffcolor))
					end
				end
				bar:SetMinMaxValues(startTime, endTime)
				bar:Show()
			end
			for i = #tmp+1, #bars[unit] do
				bars[unit][i]:Hide()
			end
		else
			for _, v in ipairs(bars[unit]) do
				v:Hide()
			end
		end
		if stickyset then
			self:StickyUpdate()
			stickyset = nil
		end
		called = false
	end
	function ClassTimer:StickyUpdate(del)
		local db = self.db.profile.Units.sticky
		if unlocked.sticky then return end
		if db.enable then
			if del then
				for k = del, #sticky do
					local frame = bars.sticky[k+1]
					sticky[del] = nil
					if not sticky[k] and sticky[k+1] then
						sticky[k] = sticky[k+1]
						--sticky[frame.name..frame.unitname] = k
						if sticky[k+1] == #sticky then
							sticky[k+1] = nil
						end
					end
				end
			end
			for k,v in ipairs(sticky) do
				local bar = bars.sticky[k]
				bar.text:SetText(text(db.bartext, v.name, v.count, v.unit))
				bar.icon:SetTexture(v.texture)
				bar.startTime = v.startTime
				bar.unit = 'sticky'
				bar.unitname = v.unitname
				bar.duration = v.duration
				bar.sticky = v.sticky
				bar.endTime = v.endTime
				bar.isbuff = v.isbuff
				bar.alwaysshown = v.alwaysshown
				bar.name = v.name
				if db.sizeEnable then
					if bar.duration < db.sizeMax then
						local width = (bar.duration/db.sizeMax)*db.width
						bar:SetWidth(width)
						bar.timetext:SetWidth(width)
						bar.text:SetWidth(width - db.fontsize * 2.5)
					else
						bar:SetWidth(db.width)
						bar.timetext:SetWidth(db.width)
						bar.text:SetWidth(db.width - db.fontsize * 2.5)
					end
				end
				if db.reversed then
					bar.reversed = true
				else
					bar.reversed = nil
				end
				if not db.showIcons then
					if bar.alwaysshown then
						bar:SetStatusBarColor(unpack(bar.isbuff and db.alwaysshownbuffcolor or db.alwaysshowndebuffcolor))
					elseif bar.isbuff then
						bar:SetStatusBarColor(unpack(db.buffcolor))
					elseif db.differentColors and v.dispelType then
						bar.dispelType = v.dispelType
						bar:SetStatusBarColor(unpack(db[v.dispelType .. 'color']))
					else
						bar:SetStatusBarColor(unpack(db.debuffcolor))
					end
				end
				bar:SetMinMaxValues(v.startTime, v.endTime)
				bar:Show()
			end
			for i = #sticky+1, #bars.sticky do
				bars.sticky[i]:Hide()
			end
		else
			for _, v in ipairs(bars.sticky) do
				v:Hide()
			end
		end
	end
end
do
	local function apply(unit, i, bar, db)
		local bars = bars[unit]
		local showIcons = db.showIcons
		local spacing = db.spacing

		bar:ClearAllPoints()
		bar:SetStatusBarTexture(sm:Fetch('statusbar', sm.OverrideMedia.statusbar or db.texture))
		bar:SetHeight(db.height)
		bar:SetScale(db.scale)
		bar:SetAlpha(db.alpha)
		bar:SetWidth(db.width)
		if db.sizeEnable and bar.duration and bar.duration < db.sizeMax then
			local width = (bar.duration/db.sizeMax)*db.width
			bar:SetWidth(width)
			bar.timetext:SetWidth(width)
			bar.text:SetWidth(width - db.fontsize * 2.5)
		else
			bar:SetWidth(db.width)
			bar.timetext:SetWidth(db.width)
			bar.text:SetWidth(db.width - db.fontsize * 2.5)
		end
		bar.spark:SetHeight(db.height + 25)
		if showIcons then
			bar:SetStatusBarColor(1, 1, 1, 0)
			bar:SetBackdropColor(1, 1, 1, 0)
			bar.spark:Hide()
			bar.text:SetFont(sm:Fetch('font', db.font), db.fontsize)
		else
			if not db.showIcons then
				if bar.alwaysshown then
					bar:SetStatusBarColor(unpack(bar.isbuff and db.alwaysshownbuffcolor or db.alwaysshowndebuffcolor))
				elseif bar.isbuff then
					bar:SetStatusBarColor(unpack(db.buffcolor))
				elseif db.differentColors and bar.dispelType then
					bar:SetStatusBarColor(unpack(db[bar.dispelType..'color']))
				else
					bar:SetStatusBarColor(unpack(db.debuffcolor))
				end
			end
			bar.spark:Show()
			bar:SetBackdropColor(unpack(db.backgroundcolor))
		end
		if db.click or unlocked[unit] then
			bar:EnableMouse(true)
		else
			bar:EnableMouse(false)
		end
		if db.reversed then
			bar.reversed = true
		else
			bar.reversed = nil
		end
		if i == 1 then
			if db.x then
				bar:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', db.x, db.y)
			else
				bar:SetPoint('CENTER', UIParent)
			end
		else
			if db.growup then
				bar:SetPoint('BOTTOMLEFT', bars[i-1], 'TOPLEFT', 0, spacing)
			else
				bar:SetPoint('TOPLEFT', bars[i-1], 'BOTTOMLEFT', 0, -1 * spacing)
			end
		end

		local timetext = bar.timetext
		if db.timetext then
			timetext:Show()
			timetext:ClearAllPoints()
			timetext:SetFont(sm:Fetch('font', db.font), db.fontsize)
			timetext:SetShadowColor( 0, 0, 0, 1)
			timetext:SetShadowOffset( 0.8, -0.8 )
			timetext:SetTextColor(unpack(db.textcolor))
			timetext:SetNonSpaceWrap(false)
			timetext:ClearAllPoints()
			timetext:SetPoint('LEFT', bar, 'LEFT', showIcons and db.iconSide == 'LEFT' and 2 or -2, 0)
			timetext:SetJustifyH(showIcons and db.iconSide == 'LEFT' and 'LEFT' or 'RIGHT')
			bar.tt = true
		else
			timetext:Hide()
			bar.tt = false
		end

		local text = bar.text
		text:SetFont(sm:Fetch('font', db.font), db.fontsize)
		if db.nametext and not showIcons then
			text:Show()
			text:ClearAllPoints()
			text:SetShadowColor( 0, 0, 0, 1)
			text:SetShadowOffset( 0.8, -0.8 )
			text:SetTextColor(unpack(db.textcolor))
			text:SetNonSpaceWrap(false)
			text:ClearAllPoints()
			text:SetHeight(db.height)
			text:SetPoint('LEFT', bar, 'LEFT', 2, 0)
			text:SetJustifyH('LEFT')
		else
			text:Hide()
		end

		local icon = bar.icon
		if db.icons then
			icon:Show()
			icon:SetWidth(db.height)
			icon:SetHeight(db.height)
			icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			icon:ClearAllPoints()
			if db.iconSide == 'LEFT' then
				icon:SetPoint('RIGHT', bar, 'LEFT', 0, 0)
			else
				icon:SetPoint('LEFT', bar, 'RIGHT', 0, 0)
			end
		else
			icon:Hide()
		end
	end
	function ClassTimer:ApplySettings()
		for n, k in pairs(bars) do
			for u, v in pairs(k) do
				apply(n, u, v, ClassTimer.db.profile.Units[n])
			end
		end
	end
end