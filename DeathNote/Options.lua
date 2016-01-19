local L = LibStub("AceLocale-3.0"):GetLocale("DeathNote")

DeathNote.OptionsDefaults = {
	profile = {
		unit_menu = false,
		debugging = false,
		keep_data = true,
		max_deaths = 50,
		death_time = 30,
		others_death_time = 0,

		unit_filters = {
			group = true,
			my_pet = false,
			other_pets = false,
			friendly_players = false,
			enemy_players = false,
			friendly_npcs = false,
			enemy_npcs = false,
		},

		display = {
			x = 0, y = 0, w = 700, h = 500,
			namelist_width = 220,
			namelist = 1,
			timestamp = 1,
			health = 1,
			scale = 1,
			columns = { 60, 90, 60, 100 },
		},

		display_filters = {
			damage_threshold = 0,
			hide_misses = false,
			consolidate_damage = false,

			heal_threshold = 0,
			consolidate_heals = false,

			buff_gains = true,
			buff_fades = true,
			debuff_gains = true,
			debuff_fades = true,
			survival_buffs = true,
			highlight_survival = true,
			consolidate_auras = false,

			spell_filter = {},
			source_filter = {},
		},

		announce = {
			enable = false,
			announce_unknown = false,
			limit = 3,
			channel = "CHATFRAME",
			style = "FORMATTED",
			format_damage = true,
			format_resist = true,
			format_overkill = true,
			format_hittype = true,
		},
		
		report = {
			max_lines = 15,
			style = "COMBAT_LOG",
		},
	},
}

DeathNote.Options = {
	type = "group",
	args = {
		general = {
			order = 1,
			name = L["General"],
			type = "group",
			args = {
				unit_menu = {
					order = 1,
					name = L["Show in the unit popup menu (requires a UI reload)"],
					desc = L["Enabling this option will taint the unit popup menu and will prevent some options from working (such as setting a focus target)"],
					type = "toggle",
					width = "double",
					get = function() return DeathNote.settings.unit_menu end,
					set = function(_, v) DeathNote.settings.unit_menu = v end,
				},
			},
		},
		data_capture = {
			order = 2,
			name = L["Data capture"],
			type = "group",
			args = {
				max_deaths = {
					order = 1,
					name = L["Maximum number of deaths"],
					type = "range",
					min = 5,
					max = 500,
					step = 1,
					width = "full",
					get = function() return DeathNote.settings.max_deaths end,
					set = function(_, v) DeathNote.settings.max_deaths = v end,
				},

				death_time = {
					order = 2,
					name = L["Seconds to keep before each death (for the unit killed)"],
					type = "range",
					min = 5,
					max = 120,
					step = 1,
					width = "full",
					get = function() return DeathNote.settings.death_time end,
					set = function(_, v)
						DeathNote.settings.death_time = v
						DeathNote.settings.others_death_time = math.min(v, DeathNote.settings.others_death_time)
					end,
				},

				--[[
				TODO: Reenable this once implemented
				
				others_death_time = {
					order = 3,
					name = L["Seconds to keep before each death (for other units)"],
					desc = L["This data is used to display actions of other players when a death happened. Set this value to 0 unless you want to use this feature, as it can use a large amount of memory."],
					type = "range",
					min = 0,
					max = 120,
					step = 1,
					width = "full",
					get = function() return DeathNote.settings.others_death_time end,
					set = function(_, v)
						DeathNote.settings.others_death_time = v
						DeathNote.settings.death_time = math.max(v, DeathNote.settings.death_time)
					end,
				},
				]]

				filter_capture = {
					order = 10,
					name = L["Units filters"],
					type = "group",
					inline = true,
					args = {
						help = {
							order = 0,
							type = "description",
							name = L["Check the units you are interested in. Data for the units not filtered is discarded."],
						},

						group = {
							order = 1,
							type = "toggle",
							name = L["Group players"],
							desc = L["Party and raid members, including yourself"],
							width = "full",
							get = function() return DeathNote.settings.unit_filters.group end,
							set = function(_, v) DeathNote:SetUnitFilter("group", v) end,
						},

						your_pet = {
							order = 2,
							type = "toggle",
							name = L["Your pet"],
							get = function() return DeathNote.settings.unit_filters.my_pet end,
							set = function(_, v) DeathNote:SetUnitFilter("my_pet", v) end,
						},

						other_pets = {
							order = 3,
							type = "toggle",
							name = L["Other pets"],
							desc = L["The effect of this filter depends on the other filters. For example, if you have the friendly players filter inactive, their pets deaths won't be recorded either, even with this filter activated."],
							get = function() return DeathNote.settings.unit_filters.other_pets end,
							set = function(_, v) DeathNote:SetUnitFilter("other_pets", v) end,
						},

						friendly_players = {
							order = 4,
							type = "toggle",
							name = L["Friendly players"],
							desc = L["All friendly players, including those not in your group"],
							get = function() return DeathNote.settings.unit_filters.friendly_players end,
							set = function(_, v) DeathNote:SetUnitFilter("friendly_players", v) end,
						},

						enemy_players = {
							order = 5,
							type = "toggle",
							name = L["Enemy players"],
							get = function() return DeathNote.settings.unit_filters.enemy_players end,
							set = function(_, v) DeathNote:SetUnitFilter("enemy_players", v) end,
						},

						friendly_npcs = {
							order = 6,
							type = "toggle",
							name = L["Friendly NPCs"],
							get = function() return DeathNote.settings.unit_filters.friendly_npcs end,
							set = function(_, v) DeathNote:SetUnitFilter("friendly_npcs", v) end,
						},

						enemy_npcs = {
							order = 7,
							type = "toggle",
							name = L["Enemy NPCs"],
							get = function() return DeathNote.settings.unit_filters.enemy_npcs end,
							set = function(_, v) DeathNote:SetUnitFilter("enemy_npcs", v) end,
						},
					},
				},

				keep_data = {
					order = 20,
					name = L["Keep data between sessions"],
					desc = L["Enable this if you want the data to persist after logging out or after a reload ui.\nKeep in mind that depending on your options this may generate a very big SavedVariables file and may impact your login/logout and reload ui times."],
					type = "toggle",
					width = "full",
					get = function() return DeathNote.settings.keep_data end,
					set = function(_, v) DeathNote.settings.keep_data = v end,
				},

				reset_data = {
					order = 30,
					name = L["Reset data"],
					type = "execute",
					func = function() DeathNote:ResetData() end
				},
			},
		},

		announce = {
			order = 3,
			name = L["Announce"],
			type = "group",
			args = {
				announce = {
					order = 10,
					name = L["Announce deaths"],
					type = "toggle",
					width = "full",
					get = function() return DeathNote.settings.announce.enable end,
					set = function(_, v) DeathNote.settings.announce.enable = v end,
				},

				announce_unknown = {
					order = 11,
					name = L["Announce deaths with an unknown cause"],
					type = "toggle",
					width = "full",
					disabled = function() return not DeathNote.settings.announce.enable end,
					get = function() return DeathNote.settings.announce.announce_unknown end,
					set = function(_, v) DeathNote.settings.announce.announce_unknown = v end,
				},

				announce_limit = {
					order = 12,
					name = L["Announces/10 seconds limit"],
					type = "range",
					min = 1,
					softMax = 10,
					step = 1,
					width = "full",
					disabled = function() return not DeathNote.settings.announce.enable end,
					get = function() return DeathNote.settings.announce.limit end,
					set = function(_, v) DeathNote.settings.announce.limit = v end,
				},

				channel = {
					order = 20,
					name = L["Output channel"],
					type = "select",
					disabled = function() return not DeathNote.settings.announce.enable end,
					values = function()
						local v = {}
						for k, o in DeathNote:O_IterateOutputs() do
							v[k] = o.name
						end
						return v
					end,
					get = function() return DeathNote.settings.announce.channel end,
					set = function(_, v) DeathNote.settings.announce.channel = v end,
				},

				format = {
					order = 30,
					name = "Style",
					type = "select",
					style = "radio",
					disabled = function() return not DeathNote.settings.announce.enable end,
					values = {
						["COMBAT_LOG"]	= L["Combat log lines"],
						["FORMATTED"]	= L["Formatted"],
					},
					get = function() return DeathNote.settings.announce.style end,
					set = function(_, v) DeathNote.settings.announce.style = v end,
				},

				format_style = {
					order = 40,
					name = L["Formatted style options"],
					type = "group",
					inline = true,
					disabled = function() return not DeathNote.settings.announce.enable or DeathNote.settings.announce.style ~= "FORMATTED" end,
					args = {
						format_damage = {
							order = 10,
							name = L["Include damage"],
							type = "toggle",
							get = function() return DeathNote.settings.announce.format_damage end,
							set = function(_, v) DeathNote.settings.announce.format_damage = v end,
						},

						format_resisted = {
							order = 20,
							name = L["Include amount resisted/blocked/absorbed"],
							type = "toggle",
							width = "double",
							get = function() return DeathNote.settings.announce.format_resist end,
							set = function(_, v) DeathNote.settings.announce.format_resist = v end,
						},

						format_hittype = {
							order = 30,
							name = L["Include hit type (critical, crushing, etc)"],
							type = "toggle",
							width = "double",
							get = function() return DeathNote.settings.announce.format_hittype end,
							set = function(_, v) DeathNote.settings.announce.format_hittype = v end,
						},

						format_overkill = {
							order = 40,
							name = L["Include overkill"],
							type = "toggle",
							get = function() return DeathNote.settings.announce.format_overkill end,
							set = function(_, v) DeathNote.settings.announce.format_overkill = v end,
						},
					},
				},
			},
		},
	},
}
