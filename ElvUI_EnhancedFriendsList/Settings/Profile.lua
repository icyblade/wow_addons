local E, L, V, P, G = unpack(ElvUI)

P.enhanceFriendsList = {
	showBackground = true,
	showStatusIcon = true,
	statusIcons = "Default",
	nameFont = "PT Sans Narrow",
	nameFontSize = 12,
	nameFontOutline = "NONE",
	zoneFont = "PT Sans Narrow",
	zoneFontSize = 12,
	zoneFontOutline = "NONE",

	Online = {
		enhancedName = false,
		colorizeNameOnly = false,
		enhancedZone = false,
		enhancedZoneColor = {r = 1, g = 0.96, b = 0.45},
		classText = true,
		level = true,
		levelColor = false,
		levelText = true,
		shortLevel = false,
		zoneText = true,
		sameZone = false,
		sameZoneColor = {r = 0.3, g = 1.0, b = 0.3},
		classIcon = false,
		classIconStatusColor = false
	},
	Offline = {
		enhancedName = false,
		colorizeNameOnly = false,
		classText = false,
		level = false,
		levelColor = false,
		levelText = false,
		shortLevel = false,
		zoneText = true,
		lastSeen = true,
		classIcon = false
	}
}