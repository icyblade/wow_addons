local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)
local EE = E:GetModule("ElvUI_Enhanced")
local EIBC = E:GetModule("Enhanced_ItemBorderColor")
local ETI = E:GetModule("Enhanced_TooltipIcon")
local EPI = E:GetModule("Enhanced_ProgressionInfo")

function EE:TooltipOptions()
	local config = {
		type = "group",
		name = L["Tooltip"],
		get = function(info) return E.db.enhanced.tooltip[info[#info]] end,
		args = {
			itemQualityBorderColor = {
 				order = 1,
				type = "toggle",
				name = L["Item Border Color"],
				desc = L["Colorize the tooltip border based on item quality."],
				get = function(info) return E.db.enhanced.tooltip.itemQualityBorderColor end,
				set = function(info, value)
					E.db.enhanced.tooltip.itemQualityBorderColor = value
					EIBC:ToggleState()
				end
			},
			tooltipIcon = {
				order = 2,
				type = "group",
				name = L["Tooltip Icon"],
				guiInline = true,
				args = {
					tooltipIcon = {
						order = 1,
						type = "toggle",
						name = L["ENABLE"],
						desc = L["Show/Hides an Icon for Spells and Items on the Tooltip."],
						get = function(info) return E.db.enhanced.tooltip.tooltipIcon.enable end,
						set = function(info, value)
							E.db.enhanced.tooltip.tooltipIcon.enable = value
							ETI:ToggleItemsState()
							ETI:ToggleSpellsState()
							ETI:ToggleAchievementsState()
						end
					},
					spacer = {
						order = 2,
						type = "description",
						name = "",
						width = "full"
					},
					tooltipIconSpells = {
						order = 3,
						type = "toggle",
						name = L["SPELLS"],
						desc = L["Show/Hides an Icon for Spells on the Tooltip."],
						get = function(info) return E.db.enhanced.tooltip.tooltipIcon.tooltipIconSpells end,
						set = function(info, value)
							E.db.enhanced.tooltip.tooltipIcon.tooltipIconSpells = value
							ETI:ToggleSpellsState()
						end,
						disabled = function() return not E.db.enhanced.tooltip.tooltipIcon.enable end
					},
					tooltipIconItems = {
						order = 4,
						type = "toggle",
						name = L["ITEMS"],
						desc = L["Show/Hides an Icon for Items on the Tooltip."],
						get = function(info) return E.db.enhanced.tooltip.tooltipIcon.tooltipIconItems end,
						set = function(info, value)
							E.db.enhanced.tooltip.tooltipIcon.tooltipIconItems = value
							ETI:ToggleItemsState()
						end,
						disabled = function() return not E.db.enhanced.tooltip.tooltipIcon.enable end
					},
					tooltipIconAchievements = {
						order = 5,
						type = "toggle",
						name = L["ACHIEVEMENTS"],
						desc = L["Show/Hides an Icon for Achievements on the Tooltip."],
						get = function(info) return E.db.enhanced.tooltip.tooltipIcon.tooltipIconAchievements end,
						set = function(info, value)
							E.db.enhanced.tooltip.tooltipIcon.tooltipIconAchievements = value
							ETI:ToggleAchievementsState()
						end,
						disabled = function() return not E.db.enhanced.tooltip.tooltipIcon.enable end
					}
				}
			},
			progressInfo = {
				order = 3,
				type = "group",
				name = L["Progress Info"],
				guiInline = true,
				get = function(info) return E.db.enhanced.tooltip.progressInfo[info[#info]] end,
				set = function(info, value) E.db.enhanced.tooltip.progressInfo[info[#info]] = value end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["ENABLE"],
						set = function(info, value)
							E.db.enhanced.tooltip.progressInfo[info[#info]] = value
							EPI:ToggleState()
						end
					},
					checkPlayer = {
						order = 2,
						type = "toggle",
						name = L["Check Player"],
						disabled = function() return not E.db.enhanced.tooltip.progressInfo.enable end
					},
					modifier = {
						order = 3,
						type = "select",
						name = L["Modifier Key"],
						set = function(info, value)
							E.db.enhanced.tooltip.progressInfo[info[#info]] = value
							EPI:UpdateModifier()
						end,
						values = {
							["ALL"] = L["ALWAYS"],
							["SHIFT"] = L["SHIFT_KEY"],
							["ALT"] = L["ALT_KEY"],
							["CTRL"] = L["CTRL_KEY"]
						},
						disabled = function() return not E.db.enhanced.tooltip.progressInfo.enable end
					},
					tiers = {
						order = 4,
						type = "group",
						name = L["Tiers"],
						get = function(info) return E.db.enhanced.tooltip.progressInfo.tiers[info[#info]] end,
						set = function(info, value)
							E.db.enhanced.tooltip.progressInfo.tiers[info[#info]] = value
							EPI:UpdateSettings()
						end,
						disabled = function() return not E.db.enhanced.tooltip.progressInfo.enable end,
						args = {
							DS = {
								order = 1,
								type = "toggle",
								name = L["Dragon Soul"]
							},
							FL = {
								order = 2,
								type = "toggle",
								name = L["Firelands"]
							},
							BH = {
								order = 3,
								type = "toggle",
								name = L["Baradin Hold"]
							},
							TOTFW = {
								order = 4,
								type = "toggle",
								name = L["Throne of the Four Winds"]
							},
							BT = {
								order = 5,
								type = "toggle",
								name = L["Bastion of Twilight"]
							},
							BWD = {
								order = 6,
								type = "toggle",
								name = L["Blackwing Descend"]
							}
						}
					}
				}
			}
		}
	}

	return config
end