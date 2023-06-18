local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)
local EE = E:GetModule("ElvUI_Enhanced")
local NP = E:GetModule("NamePlates")
local ENP = E:GetModule("Enhanced_NamePlates")

function EE:NamePlatesOptions()
	local config = {
		type = "group",
		name = L["NamePlates"],
		get = function(info) return E.db.enhanced.nameplates[info[#info]] end,
		childGroups = "tab",
		args = {
			general = {
				order = 1,
				type = "group",
				name = L["General"],
				args = {
					classCache = {
						order = 1,
						type = "toggle",
						name = L["Cache Unit Class"],
						set = function(info, value)
							E.db.enhanced.nameplates[info[#info]] = value
							ENP:UpdateAllSettings()
						end
					},
					chatBubbles = {
						order = 2,
						type = "toggle",
						name = L["Chat Bubbles"],
						set = function(info, value)
							E.db.enhanced.nameplates[info[#info]] = value
							ENP:UpdateAllSettings()
							NP:ConfigureAll()
						end
					}
				}
			},
			titleCacheGroup = {
				order = 3,
				type = "group",
				name = L["Cache Unit Guilds / NPC Titles"],
				get = function(info) return E.db.enhanced.nameplates[info[#info]] end,
				args = {
					titleCache = {
						order = 1,
						type = "toggle",
						name = L["ENABLE"],
						set = function(info, value)
							E.db.enhanced.nameplates[info[#info]] = value
							ENP:UpdateAllSettings()
							NP:ConfigureAll()
						end
					},
					guildGroup = {
						order = 2,
						type = "group",
						name = L["GUILD"],
						guiInline = true,
						get = function(info) return E.db.enhanced.nameplates.guild[info[#info]] end,
						set = function(info, value)
							E.db.enhanced.nameplates.guild[info[#info]] = value
							NP:ConfigureAll()
						end,
						disabled = function() return not E.db.enhanced.nameplates.titleCache end,
						args = {
							font = {
								order = 1,
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font
							},
							fontSize = {
								order = 2,
								type = "range",
								name = L["FONT_SIZE"],
								min = 4, max = 33, step = 1
							},
							fontOutline = {
								order = 3,
								type = "select",
								name = L["Font Outline"],
								values = {
									["NONE"] = L["NONE"],
									["OUTLINE"] = "OUTLINE",
									["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE"
								}
							},
							separator = {
								order = 4,
								type = "select",
								name = L["Separator"],
								values = {
									NONE = L["NONE"],
									ARROW = "><",
									ARROW1 = ">  <",
									ARROW2 = "<>",
									ARROW3 = "<  >",
									BOX = "[]",
									BOX1 = "[  ]",
									CURLY = "{}",
									CURLY1 = "{  }",
									CURVE = "()",
									CURVE1 = "(  )"
								}
							},
							colorsGroup = {
								order = 5,
								type = "group",
								name = L["COLORS"],
								guiInline = true,
								get = function(info)
									local t = E.db.enhanced.nameplates.guild.colors[info[#info]]
									local d = P.enhanced.nameplates.guild.colors[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b
								end,
								set = function(info, r, g, b)
									local t = E.db.enhanced.nameplates.guild.colors[info[#info]]
									t.r, t.g, t.b = r, g, b
									NP:ConfigureAll()
								end,
								args = {
									raid = {
										order = 1,
										type = "color",
										name = L["RAID"]
									},
									party = {
										order = 2,
										type = "color",
										name = L["PARTY"]
									},
									guild = {
										order = 3,
										type = "color",
										name = L["GUILD"]
									},
									none = {
										order = 4,
										type = "color",
										name = L["ALL"]
									}
								}
							},
							visabilityGroup = {
								order = 6,
								type = "group",
								name = L["Visibility State"],
								guiInline = true,
								get = function(info) return E.db.enhanced.nameplates.guild.visibility[info[#info]] end,
								set = function(info, value)
									E.db.enhanced.nameplates.guild.visibility[info[#info]] = value
									NP:ConfigureAll()
								end,
								args = {
									city = {
										order = 1,
										type = "toggle",
										name = L["City (Resting)"]
									},
									pvp = {
										order = 2,
										type = "toggle",
										name = L["PvP"]
									},
									arena = {
										order = 3,
										type = "toggle",
										name = L["ARENA"]
									},
									party = {
										order = 4,
										type = "toggle",
										name = L["PARTY"]
									},
									raid = {
										order = 5,
										type = "toggle",
										name = L["RAID"]
									}
								}
							}
						}
					},
					npcGroup = {
						order = 3,
						type = "group",
						name = L["NPC"],
						guiInline = true,
						get = function(info) return E.db.enhanced.nameplates.npc[info[#info]] end,
						set = function(info, value)
							E.db.enhanced.nameplates.npc[info[#info]] = value
							NP:ConfigureAll()
						end,
						disabled = function() return not E.db.enhanced.nameplates.titleCache end,
						args = {
							font = {
								order = 1,
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font
							},
							fontSize = {
								order = 2,
								type = "range",
								name = L["FONT_SIZE"],
								min = 4, max = 33, step = 1
							},
							fontOutline = {
								order = 3,
								type = "select",
								name = L["Font Outline"],
								values = {
									["NONE"] = L["NONE"],
									["OUTLINE"] = "OUTLINE",
									["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE"
								}
							},
							separator = {
								order = 4,
								type = "select",
								name = L["Separator"],
								values = {
									NONE = L["NONE"],
									ARROW = "><",
									ARROW1 = "> <",
									ARROW2 = "<>",
									ARROW3 = "< >",
									BOX = "[]",
									BOX1 = "[ ]",
									CURLY = "{}",
									CURLY1 = "{ }",
									CURVE = "()",
									CURVE1 = "( )"
								}
							},
							reactionColor = {
								order = 5,
								type = "toggle",
								name = L["Reaction Color"],
								desc = L["Color based on reaction type."]
							},
							color = {
								order = 6,
								type = "color",
								name = L["COLOR"],
								get = function(info)
									local t = E.db.enhanced.nameplates.npc[info[#info]]
									local d = P.enhanced.nameplates.npc[info[#info]]
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b
								end,
								set = function(info, r, g, b)
									local t = E.db.enhanced.nameplates.npc[info[#info]]
									t.r, t.g, t.b = r, g, b
									NP:ConfigureAll()
								end,
								disabled = function() return E.db.enhanced.nameplates.npc.reactionColor end
							}
						}
					}
				}
			}
		}
	}

	return config
end