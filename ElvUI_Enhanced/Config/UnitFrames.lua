local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)
local EE = E:GetModule("ElvUI_Enhanced")
local UF = E:GetModule("UnitFrames")
local EDP = E:GetModule("Enhanced_DetachedPortrait")
local TC = E:GetModule("Enhanced_TargetClass")

function EE:UnitFrameOptions()
	local config = {
		type = "group",
		name = L["UnitFrames"],
		childGroups = "tab",
		args = {
			player = {
				order = 1,
				type = "group",
				name = L["PLAYER"],
				args = {
					detachPortrait = {
						order = 1,
						type = "group",
						name = L["Portrait"],
						get = function(info) return E.db.enhanced.unitframe.detachPortrait.player[info[#info]] end,
						set = function(info, value)
							E.db.enhanced.unitframe.detachPortrait.player[info[#info]] = value
							UF:CreateAndUpdateUF("player")
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Detach From Frame"],
								set = function(info, value)
									E.db.enhanced.unitframe.detachPortrait.player[info[#info]] = value
									EDP:ToggleState("player")
								end,
								disabled = function() return not E.db.unitframe.units.player.portrait.enable end
							},
							spacer = {
								order = 2,
								type = "description",
								name = " "
							},
							width = {
								order = 3,
								type = "range",
								name = L["Detached Width"],
								min = 10, max = 600, step = 1,
								disabled = function() return not E.db.unitframe.units.player.portrait.enable end
							},
							height = {
								order = 4,
								type = "range",
								name = L["Detached Height"],
								min = 10, max = 600, step = 1,
								disabled = function() return not E.db.unitframe.units.player.portrait.enable end
							}
						}
					}
				}
			},
			target = {
				order = 2,
				type = "group",
				name = L["TARGET"],
				args = {
					classIcon = {
						order = 1,
						type = "group",
						name = L["Class Icons"],
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["ENABLE"],
								desc = L["Show class icon for units."],
								get = function(info) return E.db.enhanced.unitframe.units.target.classicon.enable end,
								set = function(info, value)
									E.db.enhanced.unitframe.units.target.classicon.enable = value
									TC:ToggleSettings()
								end
							},
							spacer = {
								order = 2,
								type = "description",
								name = " "
							},
							size = {
								order = 3,
								type = "range",
								name = L["Size"],
								desc = L["Size of the indicator icon."],
								min = 16, max = 40, step = 1,
								get = function(info) return E.db.enhanced.unitframe.units.target.classicon.size end,
								set = function(info, value)
									E.db.enhanced.unitframe.units.target.classicon.size = value
									TC:ToggleSettings()
								end,
								disabled = function() return not E.db.enhanced.unitframe.units.target.classicon.enable end
							},
							xOffset = {
								order = 4,
								type = "range",
								name = L["X-Offset"],
								min = -100, max = 100, step = 1,
								get = function(info) return E.db.enhanced.unitframe.units.target.classicon.xOffset end,
								set = function(info, value)
									E.db.enhanced.unitframe.units.target.classicon.xOffset = value
									TC:ToggleSettings()
								end,
								disabled = function() return not E.db.enhanced.unitframe.units.target.classicon.enable end
							},
							yOffset = {
								order = 5,
								type = "range",
								name = L["Y-Offset"],
								min = -80, max = 40, step = 1,
								get = function(info) return E.db.enhanced.unitframe.units.target.classicon.yOffset end,
								set = function(info, value)
									E.db.enhanced.unitframe.units.target.classicon.yOffset = value
									TC:ToggleSettings()
								end,
								disabled = function() return not E.db.enhanced.unitframe.units.target.classicon.enable end
							}
						}
					},
					detachPortrait = {
						order = 2,
						type = "group",
						name = L["Portrait"],
						get = function(info) return E.db.enhanced.unitframe.detachPortrait.target[info[#info]] end,
						set = function(info, value)
							E.db.enhanced.unitframe.detachPortrait.target[info[#info]] = value
							UF:CreateAndUpdateUF("target")
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["Detach From Frame"],
								set = function(info, value)
									E.db.enhanced.unitframe.detachPortrait.target[info[#info]] = value
									EDP:ToggleState("target")
								end,
								disabled = function() return not E.db.unitframe.units.target.portrait.enable end
							},
							spacer = {
								order = 2,
								type = "description",
								name = " "
							},
							width = {
								order = 3,
								type = "range",
								name = L["Detached Width"],
								min = 10, max = 600, step = 1,
								disabled = function() return not E.db.unitframe.units.target.portrait.enable end
							},
							height = {
								order = 4,
								type = "range",
								name = L["Detached Height"],
								min = 10, max = 600, step = 1,
								disabled = function() return not E.db.unitframe.units.target.portrait.enable end
							}
						}
					}
				}
			}
		}
	}

	return config
end