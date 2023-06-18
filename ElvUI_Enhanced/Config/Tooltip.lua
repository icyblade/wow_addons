local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)
local EE = E:GetModule("ElvUI_Enhanced")
local EIBC = E:GetModule("Enhanced_ItemBorderColor")
local ETI = E:GetModule("Enhanced_TooltipIcon")

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
			progressInfo = {
				order = 2,
				type = "toggle",
				name = L["Progress Info"],
				desc = L["Display the players raid progression in the tooltip, this may not immediately update when mousing over a unit."],
				get = function(info) return E.db.enhanced.tooltip.progressInfo end,
				set = function(info, value)
					E.db.enhanced.tooltip.progressInfo = value
				end
			},
			tooltipIcon = {
				order = 3,
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
			}
		}
	}

	return config
end