local E, L, V, P, G = unpack(select(2, ...))

--Locked Settings, These settings are stored for your character only regardless of profile options.

V.general = {
	loot = true,
	lootRoll = true,
	normTex = "ElvUI Norm",
	glossTex = "ElvUI Norm",
	dmgfont = "PT Sans Narrow",
	namefont = "PT Sans Narrow",
	chatBubbles = "backdrop",
	chatBubbleFont = "PT Sans Narrow",
	chatBubbleFontSize = 14,
	chatBubbleFontOutline = "NONE",
	chatBubbleName = false,
	pixelPerfect = true,
	replaceNameFont = true,
	replaceCombatFont = true,
	replaceBlizzFonts = true,
	minimap = {
		enable = true
	},
	classColorMentionsSpeech = true,
	raidUtility = true
}

V.bags = {
	enable = true,
	bagBar = false
}

V.nameplates = {
	enable = true,
}

V.auras = {
	enable = true,
	disableBlizzard = true,
	buffsHeader = true,
	debuffsHeader = true,
	weaponsHeader = true,
	masque = {
		buffs = false,
		debuffs = false,
		reminder = false
	}
}

V.chat = {
	enable = true
}

V.skins = {
	ace3 = {
		enable = true
	},
	checkBoxSkin = true,
	cleanBossButton = false,
	blizzard = {
		enable = true,
		achievement = true,
		alertframes = true,
		archaeology = true,
		auctionhouse = true,
		bags = true,
		barber = true,
		bgmap = true,
		bgscore = true,
		binding = true,
		BlizzardOptions = true,
		calendar = true,
		character = true,
		debug = true,
		dressingroom = true,
		encounterjournal = true,
		friends = true,
		gbank = true,
		glyph = true,
		gmchat = true,
		gossip = true,
		guild = true,
		guildcontrol = true,
		guildregistrar = true,
		help = true,
		inspect = true,
		itemText = true,
		lfg = true,
		loot = true,
		lootRoll = true,
		lfguild = true,
		macro = true,
		mail = true,
		merchant = true,
		misc = true,
		movepad = true,
		petition = true,
		pvp = true,
		quest = true,
		raid = true,
		RaidManager = true,
		reforge = true,
		socket = true,
		spellbook = true,
		stable = true,
		tabard = true,
		talent = true,
		taxi = true,
		tooltip = true,
		timemanager = true,
		trade = true,
		tradeskill = true,
		trainer = true,
		transmogrify = true,
		tutorial = true,
		voidstorage = true,
		watchframe = true,
		worldmap = true,
		mirrorTimers = true,
		WorldStateFrame = true
	}
}

V.tooltip = {
	enable = true
}

V.unitframe = {
	enable = true,
	disabledBlizzardFrames = {
		player = true,
		target = true,
		focus = true,
		boss = true,
		arena = true,
		party = true,
		raid = true
	}
}

V.actionbar = {
	enable = true,

	masque = {
		actionbars = false,
		petBar = false,
		stanceBar = false
	}
}