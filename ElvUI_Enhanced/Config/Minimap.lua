local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)
local EE = E:GetModule("ElvUI_Enhanced")
local EML = E:GetModule("Enhanced_MinimapLocation")
local MM = E:GetModule("Minimap")
local MBG = E:GetModule("Enhanced_MinimapButtonGrabber")

local positionValues = {
	TOP = L["Top"],
	LEFT = L["Left"],
	RIGHT = L["Right"],
	BOTTOM = L["Bottom"],
	CENTER = L["Center"],
	TOPLEFT = L["Top Left"],
	TOPRIGHT = L["Top Right"],
	BOTTOMLEFT = L["Bottom Left"],
	BOTTOMRIGHT = L["Bottom Right"]
}

function EE:MinimapOptions()
	local config = {
		type = "group",
		name = L["Minimap"],
		get = function(info) return E.db.enhanced.minimap[info[#info]] end,
		set = function(info, value)
			E.db.enhanced.minimap[info[#info]] = value
			MM:UpdateSettings()
		end,
		disabled = function() return not E.private.general.minimap.enable end,
		args = {
			location = {
				order = 1,
				type = "toggle",
				name = L["Location Panel"],
				desc = L["Toggle Location Panel."],
				set = function(info, value)
					E.db.enhanced.minimap[info[#info]] = value
					EML:UpdateSettings()
				end
			},
			locationdigits = {
				order = 2,
				type = "range",
				name = L["Location Digits"],
				desc = L["Number of digits for map location."],
				min = 0, max = 2, step = 1,
				disabled = function() return not (E.db.enhanced.minimap.location and E.db.general.minimap.locationText == "ABOVE" and E.db.enhanced.minimap.showlocationdigits) end
			},
			hideincombat = {
				order = 3,
				type = "toggle",
				name = L["Hide In Combat"],
				desc = L["Hide minimap while in combat."],
			},
			fadeindelay = {
				order = 4,
				type = "range",
				name = L["FadeIn Delay"],
				desc = L["The time to wait before fading the minimap back in after combat hide. (0 = Disabled)"],
				min = 0, max = 20, step = 1,
				disabled = function() return not E.db.enhanced.minimap.hideincombat end
			},
			minimapButtons = {
				order = 5,
				type = "group",
				name = L["Minimap Button Grabber"],
				guiInline = true,
				get = function(info) return E.db.enhanced.minimap.buttonGrabber[info[#info]] end,
				set = function(info, value)
					E.db.enhanced.minimap.buttonGrabber[info[#info]] = value
					MBG:UpdateLayout()
				end,
				disabled = function() return not E.private.enhanced.minimapButtonGrabber end,
				args = {
					enable = {
						order = 1,
						type = "toggle",
						name = L["ENABLE"],
						get = function(info) return E.private.enhanced.minimapButtonGrabber end,
						set = function(info, value)
							E.private.enhanced.minimapButtonGrabber = value
							if value and not MBG.initialized then
								MBG:Initialize()
							elseif not value then
								E:StaticPopup_Show("PRIVATE_RL")
							end
						end,
						disabled = false
					},
					spacer = {
						order = 2,
						type = "description",
						name = " ",
						width = "full"
					},
					growFrom = {
						order = 3,
						type = "select",
						name = L["Grow direction"],
						values = {
							["TOPLEFT"] = format(L["%s and then %s"], L["Down"], L["Right"]),
							["TOPRIGHT"] = format(L["%s and then %s"], L["Down"], L["Left"]),
							["BOTTOMLEFT"] = format(L["%s and then %s"], L["Up"], L["Right"]),
							["BOTTOMRIGHT"] = format(L["%s and then %s"], L["Up"], L["Left"])
						}
					},
					buttonsPerRow = {
						order = 4,
						type = "range",
						name = L["Buttons Per Row"],
						desc = L["The amount of buttons to display per row."],
						min = 1, max = 12, step = 1
					},
					buttonSize = {
						order = 5,
						type = "range",
						name = L["Button Size"],
						min = 2, max = 60, step = 1
					},
					buttonSpacing = {
						order = 6,
						type = "range",
						name = L["Button Spacing"],
						desc = L["The spacing between buttons."],
						min = -1, max = 24, step = 1
					},
					backdrop = {
						order = 7,
						type = "toggle",
						name = L["Backdrop"]
					},
					transparentBackdrop = {
						order = 8,
						type = "toggle",
						name = L["Transparent Backdrop"]
					},
					backdropSpacing = {
						order = 9,
						type = "range",
						name = L["Backdrop Spacing"],
						desc = L["The spacing between the backdrop and the buttons."],
						min = -1, max = 15, step = 1,
						disabled = function() return not E.private.enhanced.minimapButtonGrabber or not E.db.enhanced.minimap.buttonGrabber.backdrop end,
					},
					mouseover = {
						order = 10,
						type = "toggle",
						name = L["Mouse Over"],
						desc = L["The frame is not shown unless you mouse over the frame."],
						set = function(info, value)
							E.db.enhanced.minimap.buttonGrabber[info[#info]] = value
							MBG:ToggleMouseover()
						end
					},
					alpha = {
						order = 11,
						type = "range",
						name = L["Alpha"],
						min = 0, max = 1, step = 0.01,
						set = function(info, value)
							E.db.enhanced.minimap.buttonGrabber[info[#info]] = value
							MBG:UpdateAlpha()
						end
					},
					insideMinimapGroup = {
						order = 12,
						type = "group",
						name = L["Inside Minimap"],
						guiInline = true,
						get = function(info) return E.db.enhanced.minimap.buttonGrabber.insideMinimap[info[#info]] end,
						set = function(info, value)
							E.db.enhanced.minimap.buttonGrabber.insideMinimap[info[#info]] = value
							MBG:UpdatePosition()
						end,
						args = {
							enable = {
								order = 1,
								type = "toggle",
								name = L["ENABLE"],
								disabled = function() return not E.private.enhanced.minimapButtonGrabber end
							},
							position = {
								order = 2,
								type = "select",
								name = L["Position"],
								values = positionValues,
								disabled = function() return not E.db.enhanced.minimap.buttonGrabber.insideMinimap.enable or not E.private.enhanced.minimapButtonGrabber end
							},
							xOffset = {
								order = 3,
								type = "range",
								name = L["X-Offset"],
								min = -20, max = 20, step = 1,
								disabled = function() return not E.db.enhanced.minimap.buttonGrabber.insideMinimap.enable or not E.private.enhanced.minimapButtonGrabber end
							},
							yOffset = {
								order = 4,
								type = "range",
								name = L["Y-Offset"],
								min = -20, max = 20, step = 1,
								disabled = function() return not E.db.enhanced.minimap.buttonGrabber.insideMinimap.enable or not E.private.enhanced.minimapButtonGrabber end
							}
						}
					}
				}
			}
		}
	}
	E.Options.args.maps.args.minimap.args.locationTextGroup.args.locationText.values = {
		["MOUSEOVER"] = L["Minimap Mouseover"],
		["SHOW"] = L["Always Display"],
		["ABOVE"] = EE:ColorizeSettingName(L["Above Minimap"]),
		["HIDE"] = L["HIDE"]
	}
	config.args.locationText = E.Options.args.maps.args.minimap.args.locationTextGroup.args.locationText

	return config
end