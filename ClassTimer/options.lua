local sm = LibStub("LibSharedMedia-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("ClassTimer", true)

local bars = ClassTimer.bars
local unlocked = ClassTimer.unlocked

local function dragstart(self)
	self:StartMoving()
end
local function dragstop(self)
	ClassTimer.db.profile.Units[self.unit].x = self:GetLeft()
	ClassTimer.db.profile.Units[self.unit].y = self:GetBottom()
	self:StopMovingOrSizing()
end
local function getColor(info)
	return unpack(ClassTimer.db.profile.Units[info.arg[1]][info.arg[2]])
end
local function setColor(info, ...)
	if info.arg[1] == "general" then
		for k in pairs(bars) do
			ClassTimer.db.profile.Units[k][info.arg[2]] = { ... }
		end
	end
	ClassTimer.db.profile.Units[info.arg[1]][info.arg[2]] = { ... }
	ClassTimer.ApplySettings()
end

ClassTimer.options = {
	type = 'group',
	icon = '',
	name = 'ClassTimer',
	childGroups = 'tree',
    args = {
		enable = {
			type = 'toggle',
			name = L['Enable'],
			desc = L['Enable ClassTimer'],
			order = 1,
			get = function() return ClassTimer:IsEnabled() end,
			set = function(_, v) if v then ClassTimer:Enable() else ClassTimer:Disable() end end
		},
		lock = {
			type = 'toggle',
			name = L['Lock'],
			desc = L['Toggle Cast Bar lock'],
			order = 2,
			get = function()
				return not unlocked['general']
			end,
			set = function(info, v)
				unlocked.general = not v
				for k in pairs(bars) do
					local unit = k
					unlocked[unit] = not v
					if v or not ClassTimer.db.profile.Units[unit].enable or (ClassTimer.db.profile.Group[unit] and unit ~= ClassTimer.db.profile.AllInOneOwner) then
						bars[unit][1]:SetScript('OnDragStart', nil)
						bars[unit][1]:SetScript('OnDragStop', nil)
						if not ClassTimer.db.profile.Units[unit].click then
							bars[unit][1]:EnableMouse(false)
						end
					else
						local bar = bars[unit][1]
						bar.icon:SetTexture("Interface\\Icons\\Ability_Druid_Enrage")
						bar.text:SetText(L['%s, Drag to move']:format(L[unit]))
						bar:EnableMouse(true)
						bar:SetMovable(true)
						bar.startTime = GetTime()
						bar.endTime = GetTime() + 120
						bar:SetMinMaxValues(GetTime(),  GetTime() + 120)
						bar:RegisterForDrag('LeftButton')
						bar.unit = unit
						bar:SetScript('OnDragStart', dragstart)
						bar:SetScript('OnDragStop', dragstop)
						bar:SetAlpha(1)
						bar:Show()
					end
					ClassTimer:UpdateUnitBars(unit)
				end
			end,
		},
		BarSettings = {
			type = 'group',
			name = L['Bar Settings'],
			order = 3,
			args = {
				Spacer = {
					type = "header",
					order = 1,
					name = L["Bar Settings"]
				},
				EnabledUnits = {
					order = 1,
					name = L["Enabled Units"],
					type = "multiselect",
					get = function(info, key)
						return ClassTimer.db.profile.Units[key].enable
					end,
					set = function(info, key, value)
						ClassTimer.db.profile.Units[key].enable = value
					end,
				},
				AllInOne = {
					type = 'group',
					name = L['AllInOne'],
					inline = true,
					args = {
						Units = {
							type = 'multiselect',
							name = L['Units'],
							desc = L['Display all the buffs and debuffs on the AllInOne owner bar'],
							get = function(_, key) return ClassTimer.db.profile.Group[key] end,
							set = function(_, key, value)
								if not ClassTimer.db.profile.AllInOneOwner then
									ClassTimer.db.profile.AllInOneOwner = key
								elseif not ClassTimer.db.profile.Group[ClassTimer.db.profile.AllInOneOwner] then
									ClassTimer.db.profile.AllInOneOwner = key
								end
									ClassTimer.db.profile.Group[key] = value
							end,
							order = 2,
						},
						Owner = {
							type = 'select',
							name = L['Owner'],
							desc = L['Display the AllInOne Bars this bar'],
							get = function() return ClassTimer.db.profile.AllInOneOwner end,
							set = function(_, value) ClassTimer.db.profile.AllInOneOwner = value ClassTimer.db.profile.Group[value] = true  end,
							order = 3,
						}
					}
				}
			}
		},
	}
}

CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {}

CONFIGMODE_CALLBACKS["ClassTimer"] = function(action, mode)
   if action == "ON" then
     ClassTimer.options.args.lock.set(nil, false)
   elseif action == "OFF" then
     ClassTimer.options.args.lock.set(nil, true)
   end
 end


function ClassTimer:AddUnitOptions(type)
	local path = ClassTimer.options.args.BarSettings
	path.args[type] = {
		name = L[type],
		type = "group",
		desc = "Settings for "..L[type],
		order = type == 'general' and 1 or 20,
		childGroups = "tab",
		hidden = function() return not(ClassTimer.db.profile.Units[type].enable) end,
		get = function(info)
			return ClassTimer.db.profile.Units[info.arg[1]][info.arg[2]]
		end,
		set = function(info, value)
			if info.arg[1] == "general" then
				for k in pairs(bars) do
					ClassTimer.db.profile.Units[k][info.arg[2]] = value
				end
			end
			ClassTimer.db.profile.Units[info.arg[1]][info.arg[2]] = value
			ClassTimer.ApplySettings()
		end,
		args = {
			Header = {
				type = 'header',
				order = 1,
				name = L[type],
			},
			General = {
				name = L["General"],
				type = "group",
				order = 1,
				args = {
					buffs = {
						type = 'toggle',
						name = L['Enable Buffs'],
						desc = L['Show buffs'],
						order = 1,
						arg = {type, 'buffs'},
					},
					debuffs = {
						type = 'toggle',
						name = L['Enable Debuffs'],
						desc = L['Show debuffs'],
						order = 2,
						arg = {type, 'debuffs'},
					},
					click = {
						type = 'toggle',
						name = L['Use Clicks'],
						desc = L['Print timeleft and ability on right click'],
						arg = {type, 'click'},
						order = 4,
					},
					growUp = {
						type = 'toggle',
						name = L['Grow Up'],
						desc = L['Set bars to grow up'],
						order = 5,
						arg = {type, 'growup'},
					},
					reversed = {
						type = 'toggle',
						name = L['Reversed'],
						desc = L['Reverse the bars (fill vs deplete)'],
						order = 6,
						arg = {type, 'reversed'},
					},
					reverseSort = {
						type = 'toggle',
						name = L['Reverse sort'],
						desc = L['Reverse up/down sorting'],
						order = 7,
						arg = {type, 'reverseSort'},
					},

					showiconsOnly = {
						type = 'toggle',
						name = L['Show Only Icons'],
						desc = L['Show only icons and timeleft'],
						arg = {type, 'showIcons'},
						order = 8,
					},
					iconSide = {
						type = 'select',
						name = L['Icon Position'],
						desc = L['Set the side of the bar that the icon appears on'],
						values = {['LEFT']=L['Left'], ['RIGHT']=L['Right']},
						arg = {type, 'iconSide'},
						order = 9,
					},
				},
			},
			FrameAttributes = {
				name = L["Frame Attributes"],
				type = "group",
				order = 2,
				args = {
					width = {
						type = 'range',
						name = L['Bar Width'],
						desc = L['Set the width of the bars'],
						min = 50,
						max = 300,
						step = 1,
						--bigStep = 5,
						arg = {type, 'width'},
						order = 1,
					},
					height = {
						type = 'range',
						name = L['Bar Height'],
						desc = L['Set the height of the bars'],
						min = 4,
						max = 25,
						step = 1,
						--bigStep = 5,
						arg = {type, 'height'},
						order = 2,
					},
					scale = {
						type = 'range',
						name = L['Scale'],
						desc = L['Set the scale of the bars'],
						min = .1,
						max = 2,
						step = .01,
						--bigStep = .1,
						order = 3,
						arg = {type, 'scale'},
					},
					spacing = {
						type = 'range',
						name = L['Spacing'],
						desc = L['Tweak the space between bars'],
						min = -5,
						max = 5,
						step = .1,
						--bigStep = 1,
						arg = {type, 'spacing'},
						order = 4,
					},
					alpha = {
						type = 'range',
						name = L['Alpha'],
						desc = L['Set the alpha of the bars'],
						order = 5,
						min = 0,
						max = 1,
						step = .05,
						arg = {type, 'alpha'},
					},
					sizes = {
						type = 'group',
						name = L['Change size'],
						desc = L['Change bar size depending on duration if its less that the max time setting'],
						order = 6,
						inline = true,
						args = {
							enable = {
								type = 'toggle',
								name = L['Enable'],
								desc = L['Enable changing of bar size depending on duration if its less that the max time setting'],
								order = 1,
								arg = {type, 'sizeEnable'}
							},
							maxTime = {
								type = 'range',
								name = L['Max time'],
								desc = L['Max time to change bar sizes for'],
								order = 2,
								max = 60,
								min = 5,
								step = .5,
								--bigStep = 1,
								hidden = function() return not ClassTimer.db.profile.Units[type].sizeEnable end,
								arg = {type, 'sizeMax'},
							}
						}
					},
				},
			},
			Texts = {
				name = L["Texts"],
				type = "group",
				order = 3,
				args = {
					text = {
						type = 'input',
						name = L['Bar Text'],
						desc = L['Set the bar text'],
						order = 1,
						usage = L['<%s for spell, %a for applications, %n for name, %u for unit>'],
						arg = {type, 'bartext'},
					},
					timetext = {
						type = 'toggle',
						name = L['Time Text'],
						desc = L['Display the time remaining on buffs/debuffs on their bars'],
						arg = {type, 'timetext'},
						order = 2,
					},
					textcolor = {
						type = 'color',
						name = L['Text Color'],
						desc = L['Set the color of the text for the bars'],
						arg = {type, 'textcolor'},
						get = getColor,
						set = setColor,
						order = 3,
					},
					font = {
						type = 'select',
						name = L['Font'],
						desc = L['Set the font used in the bars'],
						values = function() return ClassTimer:List(sm:List('font')) end,
						arg = {type, 'font'},
						order = 4,
					},
					fontsize = {
						type = 'range',
						name = L['Font Size'],
						desc = L['Set the font size for the bars'],
						min = 3,
						max = 15,
						step = .5,
						--bigStep = 2,
						arg = {type, 'fontsize'},
						order = 5,
					},
				},
			},
			Textures = {
				name = L["Textures"],
				type = "group",
				order = 4,
				args = {
					texture = {
						type = 'select',
						name = L['Texture'],
						desc = L['Set the bar Texture'],
						values = function() return ClassTimer:List(sm:List('statusbar')) end,
						order = 1,
						arg = {type, 'texture'},
					},
					showicons = {
						type = 'toggle',
						name = L['Show Icons'],
						desc = L['Show icons on buffs and debuffs'],
						arg = {type, 'icons'},
						order = 2,
					},
					iconside = {
						type = 'select',
						name = L['Icon Position'],
						desc = L['Set the side of the bar that the icon appears on'],
						values = {LEFT = L['Left'], RIGHT = L['Right']},
						arg = {type, 'iconSide'},
						order = 3,
					},
					buffcolor = {
						type = 'color',
						name = L['Buff Color'],
						desc = L['Set the color of the bars for buffs'],
						get = getColor,
						set = setColor,
						hasAlpha = true,
						arg = {type, 'buffcolor'},
						order = 4,
					},
					alwaysshownbuffcolor = {
						type = 'color',
						name = L['AlwaysShown buff Color'],
						desc = L['Set the color of the bars for always shown buffs'],
						get = getColor,
						set = setColor,
						hasAlpha = true,
						arg = {type, 'alwaysshownbuffcolor'},
						order = 5,
					},
					backgroundcolor = {
						type = 'color',
						name = L['Background Color'],
						desc = L['Set the color of the bars background'],
						get = getColor,
						set = setColor,
						hasAlpha = true,
						arg = {type, 'backgroundcolor'},
						order = 6,
					},
					Debuffs = {
						type = 'group',
						name = L['Debuff Colors'],
						desc = L['Set the color of the bars for debuffs'],
						inline = true,
						order = 7,
						args = {
							Normal = {
								type = 'color',
								name = L['Normal'],
								desc = L['Set color for normal'],
								get = getColor,
								set = setColor,
								order = 1,
								hasAlpha = true,
								arg = {type, 'debuffcolor'},
							},
							alwaysshown = {
								type = 'color',
								name = L['AlwaysShown'],
								desc = L['Set the color for always shown debuffs'],
								get = getColor,
								set = setColor,
								order = 1,
								hasAlpha = true,
								arg = {type, 'alwaysshowndebuffcolor'},
							},
							differentColors = {
								type = 'toggle',
								name = L['Different colors'],
								desc = L['Different colors for different debuffs types'],
								order = 2,
								arg = {type, 'differentColors'},
							},
							Curse = {
								type = 'color',
								name = L['Curse'],
								desc = L['Set color for curses'],
								get = getColor,
								set = setColor,
								order = 5,
								hasAlpha = true,
								arg = {type, 'Cursecolor'},
								hidden = function() return not ClassTimer.db.profile.Units[type].differentColors end,
							},
							Poison = {
								type = 'color',
								name = L['Poison'],
								desc = L['Set color for poisons'],
								get = getColor,
								set = setColor,
								order = 6,
								hasAlpha = true,
								arg = {type, 'Poisoncolor'},
								hidden = function() return not ClassTimer.db.profile.Units[type].differentColors end,
							},
							Magic = {
								type = 'color',
								name = L['Magic'],
								desc = L['Set color for magics'],
								get = getColor,
								set = setColor,
								order = 7,
								hasAlpha = true,
								arg = {type, 'Magiccolor'},
								hidden = function() return not ClassTimer.db.profile.Units[type].differentColors end,
							},
							Disease = {
								type = 'color',
								name = L['Disease'],
								desc = L['Set color for diseases'],
								get = getColor,
								set = setColor,
								order = 8,
								hasAlpha = true,
								arg = {type, 'Diseasecolor'},
								hidden = function() return not ClassTimer.db.profile.Units[type].differentColors end,
							},
						},
					},
				},
			},
			Sticky = type == "sticky" and {
				type = 'group',
				name = L['Add Sticky'],
				desc = L['Add a move to be sticky'],
				order = 7,
				args = {},
			} or nil
		},
	}
end

local values = {}
local values2 = {}
for k in pairs(bars) do
	values[k] = L[k]
	values2[k] = L[k]
	ClassTimer:AddUnitOptions(k)
end

ClassTimer:AddUnitOptions('general')
ClassTimer.options.args.BarSettings.args.EnabledUnits.values = values
values2['sticky'] = nil
ClassTimer.options.args.BarSettings.args.AllInOne.args.Units.values = values2
ClassTimer.options.args.BarSettings.args.AllInOne.args.Owner.values = values2
local values = nil
local values2 = nil
