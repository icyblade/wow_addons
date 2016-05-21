local L = LibStub("AceLocale-3.0"):NewLocale("SimpleILevel", "esES");

if not L then return end

L.core = {
	ageDays = "%s days", -- Requires localization
	ageHours = "%s hours", -- Requires localization
	ageMinutes = "%s minutes", -- Requires localization
	ageSeconds = "%s seconds", -- Requires localization
	desc = "Adds the Average iLevel (AiL) to the tooltip of other players", -- Requires localization
	load = "Loading v%s", -- Requires localization
	minimapClick = "Simple iLevel - Click for details", -- Requires localization
	minimapClickDrag = "Click and drag to move the icon.", -- Requires localization
	name = "Nivel de objeto Simple", -- Needs review
	purgeNotification = "Purging %s people from your cache", -- Requires localization
	purgeNotificationFalse = "You do not have an auto purge set.", -- Requires localization
	scoreDesc = "This is the Average iLevel of all of your equipped items.", -- Requires localization
	scoreYour = "Tu nivel de objeto es %s", -- Needs review
	slashClear = "Borrar configuraciones", -- Needs review
	slashGetScore = "%s has a AiL of %s and the information is %s old", -- Requires localization
	slashGetScoreFalse = "Sorry, there was a error getting a score for %s", -- Requires localization
	slashTargetScore = "%s tiene un nivel de objeto de %s", -- Needs review
	slashTargetScoreFalse = "Lo sentimos, hubo un error construyendo el nivel de objeto de tu objetivo", -- Needs review
	ttAdvanced = "%s old", -- Requires localization
	ttLeft = "Average iLevel:", -- Requires localization
	options = {
		autoscan = "Autoscan on Changes", -- Requires localization
		autoscanDesc = "Automatically scan group members when there gear appears to change", -- Requires localization
		clear = "Clear Settings", -- Requires localization
		clearDesc = "Borrar toda la configuracion y la cache", -- Needs review
		color = "Color Score", -- Requires localization
		colorDesc = "Color the AiL where appropriate. Disable this if you only want to see white and gray scores.", -- Requires localization
		get = "Get Score", -- Requires localization
		getDesc = "Retornar el nivel de objeto promedio de un nombre si esta en la cache", -- Needs review
		ldb = "LDB Options", -- Requires localization
		ldbRefresh = "Refresh Rate", -- Requires localization
		ldbRefreshDesc = "How often should LDB be updated in seconds.", -- Requires localization
		ldbSource = "LDB Source Label", -- Requires localization
		ldbSourceDesc = "Show a label of the source data for the LDB score.", -- Requires localization
		ldbText = "LDB Text", -- Requires localization
		ldbTextDesc = "Toggle LDB on and off, this will save a little resources.", -- Requires localization
		maxAge = "Maximum Refresh Interval (Minutes)", -- Requires localization
		maxAgeDesc = "Establecer la cantidad de tiempo entre inspecciones en minutos", -- Needs review
		minimap = "Show Minimap Button", -- Requires localization
		minimapDesc = "Toggles showing the minimap button", -- Requires localization
		modules = "Load Modules", -- Requires localization
		modulesDesc = "For these changes to take effect you need to reload your UI with /rl or /console reloadui.", -- Requires localization
		name = "Simple iLevel Options", -- Requires localization
		open = "Open SiL Options UI", -- Requires localization
		options = "SiL Options", -- Requires localization
		paperdoll = "Show on Character Info", -- Requires localization
		paperdollDesc = "Shows your AiL on the Character Info window on the stats pane.", -- Requires localization
		purge = "Purge Cache", -- Requires localization
		purgeAuto = "Automatically Purge Cache", -- Requires localization
		purgeAutoDesc = "Automatically purge the cache older then # days. 0 is never.", -- Requires localization
		purgeDesc = "Clears all cached characters older then %s days", -- Requires localization
		purgeError = "Please enter the number of days.", -- Requires localization
		round = "Round iLevel", -- Requires localization
		roundDesc = "Round the iLevel to the nearest whole number", -- Requires localization
		target = "Get Target Score", -- Requires localization
		targetDesc = "Retornar el item level promedio de tu actual objetivo", -- Needs review
		ttAdvanced = "Advanced Tooltip", -- Requires localization
		ttAdvancedDesc = "Cambiar a informacion avanzada incluyendo los cambios en el tiempo", -- Needs review
		ttCombat = "Tooltip in Combat", -- Requires localization
		ttCombatDesc = "Show the SiL information on the tooltip while in combat", -- Requires localization
	},
}
L.group = {
	addonName = "Simple iLevel - Group", -- Requires localization
	desc = "View the AiL of everyone in your group", -- Requires localization
	load = "Group Module Loaded", -- Requires localization
	name = "SiL Group", -- Requires localization
	nameShort = "Group", -- Requires localization
	outputHeader = "Simple iLevel: Group Average %s", -- Requires localization
	outputNoScore = "%s is not available", -- Requires localization
	outputRough = "* denotes an approximate score", -- Requires localization
	options = {
		group = "Group Score", -- Requires localization
		groupDesc = "Prints the score of your group to <%s>.", -- Requires localization
	},
}
L.resil = {
	addonName = "Simple iLevel - Resilience", -- Requires localization
	desc = "Shows the amount of PvP gear other players have equipped in the tooltip", -- Requires localization
	load = "Resilience Module Loaded", -- Requires localization
	name = "SiL Resilience", -- Requires localization
	nameShort = "Resilience", -- Requires localization
	outputHeader = "Simple iLevel: Group Average PvP Gear %s", -- Requires localization
	outputNoScore = "%s is not available", -- Requires localization
	outputRough = "* denotes an approximate score", -- Requires localization
	ttPaperdoll = "You have %s/%s items with a %s resilience rating.", -- Requires localization
	ttPaperdollFalse = "You currently do not have any PvP items equiped.", -- Requires localization
	options = {
		cinfo = "Show on Character Info", -- Requires localization
		cinfoDesc = "Shows your SimpleiLevel Resilience score on the stats pane.", -- Requires localization
		group = "Group PvP Score", -- Requires localization
		groupDesc = "Prints the PvP Score of your group to <%s>.", -- Requires localization
		name = "SiL Resilience Options", -- Requires localization
		pvpDesc = "Displayed the PvP gear of everyone in your group.", -- Requires localization
		ttType = "Tooltip Type", -- Requires localization
		ttZero = "Zero Tooltip", -- Requires localization
		ttZeroDesc = "Shows information in the tooltip even if they have no PvP gear.", -- Requires localization
	},
}
L.social = {
	addonName = "Simple iLevel - Social", -- Requires localization
	desc = "Added the AiL to chat windows for various channels", -- Requires localization
	load = "Social Module Loaded", -- Requires localization
	name = "SiL Social", -- Requires localization
	nameShort = "Social", -- Requires localization
	options = {
		chatEvents = "Show Score On:", -- Requires localization
		color = "Color Score", -- Requires localization
		colorDesc = "Color the score in the chat windows.", -- Requires localization
		enabled = "Enabled", -- Requires localization
		enabledDesc = "Enable all features or SiL Social.", -- Requires localization
		name = "SiL Social Options", -- Requires localization
	},
}


