local E, L, V, P, G = unpack(ElvUI)

P.enhanced = {
	general = {
		pvpAutoRelease = false,
		merchant = false,
		merchantItemLevel = false,
		showQuestLevel = false,
		questItemLevel = false,
		selectQuestReward = false,
		declineParty = false,
		declineDuel = false,
		hideZoneText = false,
		trainAllSkills = false,
		undressButton = false,
		alreadyKnown = false
	},
	blizzard = {
		errorFrame = {
			enable = false,
			width = 300,
			height = 60,
			font = "PT Sans Narrow",
			fontSize = 12,
			fontOutline = "NONE"
		},
		backgrounds = {
			characterBackground = true,
			characterBackdrop = true,
			characterDesaturate = false,

			inspectBackground = true,
			inspectBackdrop = true,
			inspectDesaturate = false
		}
	},
	chat = {
		dpsLinks = false
	},
	datatexts = {
		dataTextColors = {
			colorType = "DEFAULT",
			color = {r = 1, g = 1, b = 1}
		}
	},
	equipment = {
		enable = false,
		durability = {
			enable = true,
			onlydamaged = true,
			position = "TOPRIGHT",
			xOffset = 0,
			yOffset = -2,
			font = "Homespun",
			fontSize = 10,
			fontOutline = "MONOCHROMEOUTLINE"
		},
		itemlevel = {
			enable = true,
			qualityColor = true,
			position = "BOTTOMRIGHT",
			xOffset = -2,
			yOffset = 2,
			font = "Homespun",
			fontSize = 10,
			fontOutline = "MONOCHROMEOUTLINE"
		}
	},
	map = {
		fogClear = {
			enable = false,
			color = {r = 0.5, g = 0.5, b = 0.5, a = 1}
		}
	},
	minimap = {
		location = false,
		showlocationdigits = true,
		locationdigits = 1,
		hideincombat = false,
		fadeindelay = 5,
		buttonGrabber = {
			backdrop = false,
			backdropSpacing = 1,
			transparentBackdrop = false,
			mouseover = false,
			alpha = 1,
			buttonSize = 22,
			buttonSpacing = 0,
			buttonsPerRow = 1,
			growFrom = "TOPLEFT",
			insideMinimap = {
				enable = true,
				position = "TOPLEFT",
				xOffset = -1,
				yOffset = 1
			}
		}
	},
	nameplates = {
		classCache = false,
		chatBubbles = false,
		titleCache = false,
		guild = {
			font = "PT Sans Narrow",
			fontSize = 11,
			fontOutline = "OUTLINE",
			separator = "NONE",
			colors = {
				raid = {r = 1, g = 0.50, b = 0},
				party = {r = 0.46, g = 0.78, b = 1},
				guild = {r = 0.25, g = 1, b = 0.25},
				none = {r = 1, g = 1, b = 1}
			},
			visibility = {
				city = true,
				pvp = true,
				arena = true,
				party = true,
				raid = true
			}
		},
		npc = {
			font = "PT Sans Narrow",
			fontSize = 11,
			fontOutline = "OUTLINE",
			reactionColor = false,
			color = {r = 1, g = 1, b = 1},
			separator = "NONE"
		}
	},
	tooltip = {
		itemQualityBorderColor = false,
		progressInfo = {
			enable = false,
			checkPlayer = false,
			modifier = "SHIFT",
			tiers = {
				DS = true,
				FL = true,
				BH = true,
				TOTFW = true,
				BT = true,
				BWD = true
			}
		},
		tooltipIcon = {
			enable = false,
			tooltipIconSpells = true,
			tooltipIconItems = true,
			tooltipIconAchievements = true
		}
	},
	loseControl = {
		iconSize = 60,
		compactMode = false,
		CC = true,
		PvE = true,
		Silence = true,
		Disarm = true,
		Root = false,
		Snare = false
	},
	unitframe = {
		detachPortrait = {
			player = {
				enable = false,
				width = 54,
				height = 54
			},
			target = {
				enable = false,
				width = 54,
				height = 54
			}
		}
	},
	watchframe = {
		enable = false,
		city = "COLLAPSED",
		pvp = "HIDDEN",
		arena = "HIDDEN",
		party = "COLLAPSED",
		raid = "COLLAPSED"
	},
	raidmarkerbar = {
		enable = false,
		backdrop = true,
		transparentButtons = false,
		transparentBackdrop = false,
		buttonSize = 22,
		spacing = 1,
		orientation = "HORIZONTAL",
		reverse = false,
		modifier = "shift-",
		visibility = "DEFAULT",
		customVisibility = "[noexists, nogroup] hide;show"
	}
}