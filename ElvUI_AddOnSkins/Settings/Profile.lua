local E, L, V, P, G = unpack(ElvUI)

P.addOnSkins = {
	embed = {
		embedType = "SINGLE",
		leftWindow = "Skada",
		rightWindow = "Skada",
		rightChatPanel = true,
		leftWindowWidth = 200,
		belowTopTab = false,
		hideChat = "NONE"
	},
	skada = {
		backdrop = true,
		template = "Default",
		templateGloss = false,
		titleBackdrop = true,
		titleTemplate = "Default",
		titleTemplateGloss = true
	},
	dbm = {
		barHeight = 22,
		font = "PT Sans Narrow",
		fontSize = 12,
		fontOutline = "OUTLINE"
	},
	weakAura = {
		auraBar = true,
		iconCooldown = true
	}
}