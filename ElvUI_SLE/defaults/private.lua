local SLE, T, E, L, V, P, G = unpack(select(2, ...))

V["skins"]["addons"] = {
	["EmbedSkada"] = true,
}

V["sle"] = {
	["Armory"] = {
		["UseArtMonitor"] = true,
	},
	["equip"] = {
		["enable"] = false,
		["spam"] = false,
		["onlyTalent"] = false,
		["conditions"] = "",
		["setoverlay"] = false,
		["lockbutton"] = false,
	},
	--Minimap Module
	["minimap"] = {
		["buttons"] = {
			["enable"] = true,
		},
		["mapicons"] = {
			["enable"] = false,
			["barenable"] = false,
			["template"] = "Transparent",
		},
	},

	["dt"] = {
		["specswitch"] = {
			["xOffset"] = -15,
			["yOffset"] = -7,
		},
	},

	["bags"] = {
		["transparentSlots"] = false,
	},

	["vehicle"] = {
		["enable"] = false,
	},
	
	["professions"] = {
		["deconButton"] = {
			["enable"] = true,
			["style"] = "BIG",
			["buttonGlow"] = true,
		},
		["enchant"] = {
			["enchScroll"] = false,
		},
		["fishing"] = {
			["EasyCast"] = false,
			["FromMount"] = false,
			["UseLures"] = true,
			["IgnorePole"] = false,
			["CastButton"] = "Shift",
		},
	},

	["module"] = {
		["screensaver"] = false,
		["blizzmove"] = {
			["enable"] = true,
			["remember"] = false,
			["points"] = {},
		},
		["shadows"] = {
			["vehicle"] = false,
			["player"] = false,
			["target"] = false,
			["targettarget"] = false,
			["focus"] = false,
			["focustarget"] = false,
			["pet"] = false,
			["pettarget"] = false,
			["boss"] = false,
			["arena"] = false,
			["actionbars"] = {
				["bar1"] = false,
				["bar2"] = false,
				["bar3"] = false,
				["bar4"] = false,
				["bar5"] = false,
				["bar6"] = false,
				["bar7"] = false,
				["bar8"] = false,
				["bar9"] = false,
				["bar10"] = false,
				["stancebar"] = false,
				["microbar"] = false,
				["petbar"] = false,
				["bar1buttons"] = false,
				["bar2buttons"] = false,
				["bar3buttons"] = false,
				["bar4buttons"] = false,
				["bar5buttons"] = false,
				["bar6buttons"] = false,
				["bar7buttons"] = false,
				["bar8buttons"] = false,
				["bar9buttons"] = false,
				["bar10buttons"] = false,
				["stancebarbuttons"] = false,
				["microbarbuttons"] = false,
				["petbarbuttons"] = false,
			},
			["minimap"] = false,
			["chat"] = {
				["left"] = false,
				["right"] = false,
			},
		},
	},
	
	["unitframe"] = {
		["resizeHealthPrediction"] = false,
		["statusbarTextures"] = {
			["power"] = false,
			["cast"] = false,
			["aura"] = false,
			["class"] = false,
		},
	},
	
	["chat"] = {
		["chatMax"] = 128,
		["chatHistory"] = {
			["CHAT_MSG_INSTANCE_CHAT"] = true,
			["CHAT_MSG_INSTANCE_CHAT_LEADER"] = true,
			["CHAT_MSG_BN_WHISPER"] = true,
			["CHAT_MSG_BN_WHISPER_INFORM"] = true,
			["CHAT_MSG_CHANNEL"] = true,
			["CHAT_MSG_EMOTE"] = true,
			["CHAT_MSG_GUILD"] = true,
			["CHAT_MSG_GUILD_ACHIEVEMENT"] = true,
			["CHAT_MSG_OFFICER"] = true,
			["CHAT_MSG_PARTY"] = true,
			["CHAT_MSG_PARTY_LEADER"] = true,
			["CHAT_MSG_RAID"] = true,
			["CHAT_MSG_RAID_LEADER"] = true,
			["CHAT_MSG_RAID_WARNING"] = true,
			["CHAT_MSG_SAY"] = true,
			["CHAT_MSG_WHISPER"] = true,
			["CHAT_MSG_WHISPER_INFORM"] = true,
			["CHAT_MSG_YELL"] = true,
			["size"] = 128,
		},
	},
	["pvp"] = {
		["KBbanner"] = {
			["enable"] = false,
			["sound"] = true,
		},
	},
	["actionbars"] = {
		["oorBind"] = false,
		["checkedtexture"] = false,
		["checkedColor"] = {r = 0, g = 1, b = 0, a = 0.3},
		["transparentBackdrop"] = false,
		["transparentButtons"] = false,
	},
	["skins"] = {
		["objectiveTracker"] = {
			["enable"] = true,
			["texture"] = "ElvUI Norm",
			["class"] = false,
			["color"] = {r = 0.26, g = 0.42, b = 1},
			["underlineHeight"] = 1,
			["scenarioBG"] = false,
		},
		["petbattles"] = {
			["enable"] = true,
		},
		["merchant"] = {
			["enable"] = false,
			["style"] = "Default",
			["subpages"] = 2,
		},
		["questguru"] = {
			["enable"] = false,
			["removeParchment"] = false,
		},
	},
	["uibuttons"] = {
		["style"] = "classic",
		["strata"] = "MEDIUM",
		["level"] = 5,
		["transparent"] = "Default",
	},

	["characterGoldsSorting"] = {},
	}

G["sle"] = {
	["DE"] = {
		["Blacklist"] = "",
		["IgnoreTabards"] = true,
		["IgnorePanda"] = true,
		["IgnoreCooking"] = true,
		["IgnoreFishing"] = true,
	},
	["LOCK"] = {
		["Blacklist"] = "",
		["TradeOpen"] = false,
	},
	["advanced"] = {
		["general"] = false,
		["optionsLimits"] = false,
		["gameMenu"] = {
			["enable"] = true,
			["reload"] = false,
		},
		["confirmed"] = false,
		["cyrillics"] = {
			["commands"] = false,
			["devCommands"] = false,
		},
		["chat"] = {
			["setupDelay"] = 1,
		},
	},
}
