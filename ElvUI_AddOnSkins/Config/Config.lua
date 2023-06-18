local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)
local AS = E:GetModule("AddOnSkins")
local Embed = E:GetModule("EmbedSystem")

local pairs, select = pairs, select
local format = string.format

local GetAddOnInfo = GetAddOnInfo

local SUPPORTED_ADDONS_STRING = ""

AS.addonList = {
	_NPCScan				= "5.4.8.6",
	AckisRecipeList			= "3.0.5",
	ACP						= "3.4.9",
	AtlasLoot				= "7.07.03",
	Auctionator				= "3.1.5",
	BattlePetBreedID		= "1.1.1b",
	BindPad					= "2.6.8",
	BugSack					= "r278",
	Clique					= "50400-1.0.0",
	DBM						= "5.4.19-33",
	Doom_CooldownPulse		= "1.2.11",
	EasyMail				= "3.6",
	ExtVendor				= "1.5.2",
	Factionizer				= "14.4.27",
	FlightMap				= "5.4.0.0",
	Gatherer				= "4.4.1",
	LightHeaded				= "371",
	MacroToolkit			= "5.4.0.4",
	Overachiever			= "0.73",
	PetJournal_QuickFilter	= "1.0",
	PetJournalEnhanced		= "2.9.10",
	PetTracker				= "5.4.26",
	PlateBuffs				= "r228",
	Postal					= "3.5.2",
	RCLootCouncil			= "1.6.3",
	Recount					= "r1269",
	SilverDragon			= "r214",
	Skada					= "1.4-19",
	Spy						= "3.1.6",
	TrinketMenu				= "5.0.4",
	WeakAuras				= "2.0.8",
}

function AS:RegisterAddonOption(AddonName, options)
	if select(6, GetAddOnInfo(AddonName)) == "MISSING" then return end

	options.args.skins.args[AddonName] = {
		type = "toggle",
		name = AddonName,
		desc = L["TOGGLESKIN_DESC"],
		hidden = function() return not AS:CheckAddOn(AddonName) end
	}
end

function AS:InsertOptions()
	if not E.Options.args.elvuiPlugins then
		E.Options.args.elvuiPlugins = {
			order = 50,
			type = "group",
			name = "|cff00fcceE|r|cffe5e3e3lvUI |r|cff00fcceP|r|cffe5e3e3lugins|r",
			args = {}
		}
	end

	for addonName, addonVersion in pairs(AS.addonList) do
		local line = format("%s |cffff7d0a%s|r", addonName, addonVersion)

		SUPPORTED_ADDONS_STRING = SUPPORTED_ADDONS_STRING.."\n"..line
	end

	E.Options.args.elvuiPlugins.args.addOnSkins = {
		type = "group",
		name = "|cff00fcceA|r|cffe5e3e3ddOn |r|cff00fcceS|r|cffe5e3e3kins|r",
		childGroups = "tab",
		args = {
			skins = {
				order = 1,
				type = "group",
				name = L["Skins"],
				get = function(info) return E.private.addOnSkins[info[#info]] end,
				set = function(info, value) E.private.addOnSkins[info[#info]] = value E:StaticPopup_Show("PRIVATE_RL") end,
				args = {}
			},
			misc = {
				order = 2,
				type = "group",
				name = L["MISCELLANEOUS"],
				childGroups = "tab",
				args = {
					skada = {
						order = 1,
						type = "group",
						name = "Skada",
						get = function(info) return E.db.addOnSkins.skada[info[#info]] end,
						set = function(info, value) E.db.addOnSkins.skada[info[#info]] = value Skada:ApplySettings() end,
						disabled = function() return not AS:CheckAddOn("Skada") end,
						args = {
							titleBackdrop = {
								order = 1,
								type = "toggle",
								name = L["Title Backdrop"]
							},
							titleTemplate = {
								order = 2,
								type = "select",
								name = L["Title Template"],
								values = {
									["Default"] = L["DEFAULT"],
									["Transparent"] = L["Transparent"]
								},
								disabled = function() return not E.db.addOnSkins.skada.titleBackdrop end
							},
							titleTemplateGloss = {
								order = 3,
								type = "toggle",
								name = L["Title Gloss Template"],
								disabled = function() return E.db.addOnSkins.skada.titleTemplate == "Transparent" or not E.db.addOnSkins.skada.titleBackdrop end
							},
							spacer = {
								order = 4,
								type = "description",
								name = ""
							},
							backdrop = {
								order = 5,
								type = "toggle",
								name = L["Backdrop"]
							},
							template = {
								order = 6,
								type = "select",
								name = L["Template"],
								values = {
									["Default"] = L["DEFAULT"],
									["Transparent"] = L["Transparent"]
								},
								disabled = function() return not E.db.addOnSkins.skada.backdrop end
							},
							templateGloss = {
								order = 7,
								type = "toggle",
								name = L["Gloss Template"],
								disabled = function() return E.db.addOnSkins.skada.template == "Transparent" or not E.db.addOnSkins.skada.backdrop end
							}
						}
					},
					dbm = {
						order = 2,
						type = "group",
						name = "DBM",
						get = function(info) return E.db.addOnSkins.dbm[info[#info]] end,
						set = function(info, value) E.db.addOnSkins.dbm[info[#info]] = value DBM.Bars:ApplyStyle() DBM.BossHealth:UpdateSettings() end,
						disabled = function() return not AS:CheckAddOn("DBM-Core") end,
						args = {
							barHeight = {
								order = 1,
								type = "range",
								name = L["Bar Height"],
								min = 6, max = 60,
								step = 1
							},
							spacer = {
								order = 2,
								type = "description",
								name = ""
							},
							font = {
								order = 3,
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font
							},
							fontSize = {
								order = 4,
								type = "range",
								name = L["FONT_SIZE"],
								min = 6, max = 22, step = 1
							},
							fontOutline = {
								order = 5,
								type = "select",
								name = L["Font Outline"],
								values = {
									["NONE"] = L["NONE"],
									["OUTLINE"] = "OUTLINE",
									["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE"
								}
							}
						}
					},
					weakAura = {
						order = 3,
						type = "group",
						name = "WeakAuras",
						get = function(info) return E.db.addOnSkins.weakAura[info[#info]] end,
						set = function(info, value) E.db.addOnSkins.weakAura[info[#info]] = value E:StaticPopup_Show("PRIVATE_RL") end,
						disabled = function() return not AS:CheckAddOn("WeakAuras") end,
						args = {
							auraBar = {
								order = 1,
								type = "toggle",
								name = L["AuraBar Backdrop"]
							},
							iconCooldown = {
								order = 2,
								type = "toggle",
								name = L["WeakAura Cooldowns"]
							}
						}
					}
				}
			},
			embed = {
				order = 3,
				type = "group",
				name = L["Embed Settings"],
				get = function(info) return E.db.addOnSkins.embed[info[#info]] end,
				set = function(info, value) E.db.addOnSkins.embed[info[#info]] = value Embed:EmbedUpdate() end,
				args = {
					desc = {
						order = 1,
						type = "description",
						name = L["Settings to control Embedded AddOns\n\nAvailable Embeds: Omen | Skada | Recount"]
					},
					embedType = {
						order = 2,
						type = "select",
						name = L["Embed Type"],
						values = {
							["DISABLE"] = L["DISABLE"],
							["SINGLE"] = L["Single"],
							["DOUBLE"] = L["Double"]
						}
					},
					rightChatPanel = {
						order = 3,
						type = "toggle",
						name = L["Embed into Right Chat Panel"],
						disabled = function() return E.db.addOnSkins.embed.embedType == "DISABLE" end
					},
					belowTopTab = {
						order = 4,
						type = "toggle",
						name = L["Embed Below Top Tab"],
						disabled = function() return E.db.addOnSkins.embed.embedType == "DISABLE" end
					},
					spacer = {
						order = 5,
						type = "description",
						name = ""
					},
					leftWindow = {
						order = 6,
						type = "select",
						name = L["Left Panel"],
						values = {
							["Recount"] = "Recount",
							["Omen"] = "Omen",
							["Skada"] = "Skada"
						},
						disabled = function() return E.db.addOnSkins.embed.embedType == "DISABLE" end
					},
					rightWindow = {
						order = 7,
						type = "select",
						name = L["Right Panel"],
						values = {
							["Recount"] = "Recount",
							["Omen"] = "Omen",
							["Skada"] = "Skada"
						},
						disabled = function() return E.db.addOnSkins.embed.embedType ~= "DOUBLE" end
					},
					hideChat = {
						order = 8,
						type = "select",
						name = L["Hide Chat Frame"],
						values = Embed:GetChatWindowInfo(),
						disabled = function() return E.db.addOnSkins.embed.embedType == "DISABLE" end
					},
					leftWindowWidth = {
						order = 9,
						type = "range",
						name = L["Embed Left Window Width"],
						min = 100, max = 300, step = 1,
						disabled = function() return E.db.addOnSkins.embed.embedType == "DISABLE" end
					}
				}
			},
			supportedAddOns = {
				order = 4,
				type = "group",
				name = L["Supported AddOns"],
				args = {
					text = {
						order = 1,
						type = "description",
						name = SUPPORTED_ADDONS_STRING
					}
				}
			}
		}
	}

	for addonName in pairs(AS.addonList) do
		AS:RegisterAddonOption(addonName, E.Options.args.elvuiPlugins.args.addOnSkins)
	end
end