if GetLocale() ~= "deDE" then return end

DBM_CORE_NEED_SUPPORT				= "Hey, bist du ein Programmierer oder gut in Fremdsprachen? Falls ja, benötigt das DBM-Team deine Hilfe, damit DBM das beste Boss Mod für WoW bleibt. Trete dem Team auf www.deadlybossmods.com bei oder sende eine E-Mail an tandanu@deadlybossmods.com oder nitram@deadlybossmods.com."
DBM_HOW_TO_USE_MOD					= "Willkommen bei DBM. Tippe /dbm help für eine Liste unterstützter Kommandos. Für den Zugriff auf Einstellungen tippe /dbm in den Chat um die Konfiguration zu beginnen. Lade gewünschte Zonen manuell um jegliche Boss-spezifische Einstellungen nach deinen Wünschen zu konfigurieren. DBM versucht dies für dich zu tun, indem es beim ersten Start deine Spezialisierung scannt, aber du kannst zusätzliche Einstellungen aktivieren."

DBM_CORE_LOAD_MOD_ERROR				= "Fehler beim Laden der Boss Mods für %s: %s"
DBM_CORE_LOAD_MOD_SUCCESS			= "Boss Mods für '%s' geladen. Für weitere Einstellungen /dbm oder /dbm help im Chatfenster eingeben!"
DBM_CORE_LOAD_GUI_ERROR				= "Konnte die Benutzeroberfläche nicht laden: %s"

DBM_CORE_COMBAT_STARTED				= "Kampf gegen %s hat begonnen. Viel Glück! :)";
DBM_CORE_BOSS_DOWN					= "%s tot nach %s!"
DBM_CORE_BOSS_DOWN_L				= "%s tot nach %s! Dein letzter Sieg hat %s gedauert und der schnellste %s. Das war dein %d. Sieg."
DBM_CORE_BOSS_DOWN_NR				= "%s tot nach %s! Das ist ein neuer Rekord! (Der alte Rekord war %s.) Das war dein %d. Sieg."
DBM_CORE_COMBAT_ENDED_AT			= "Kampf gegen %s (%s) hat nach %s aufgehört."
DBM_CORE_COMBAT_ENDED_AT_LONG		= "Kampf gegen %s (%s) hat nach %s aufgehört. Das war deine %d. Niederlage auf diesem Schwierigkeitsgrad."
DBM_CORE_COMBAT_STATE_RECOVERED		= "Kampf gegen %s hat vor %s begonnen, Neukalibrierung der Timer erfolgt..."

DBM_CORE_TIMER_FORMAT_SECS			= "%d |4Sekunde:Sekunden;"
DBM_CORE_TIMER_FORMAT_MINS			= "%d |4Minute:Minuten;"
DBM_CORE_TIMER_FORMAT				= "%d |4Minute:Minuten; und %d |4Sekunde:Sekunden;"

DBM_CORE_MIN						= "Min"
DBM_CORE_MIN_FMT					= "%d Min"
DBM_CORE_SEC						= "Sek"
DBM_CORE_SEC_FMT					= "%d Sek"
DBM_CORE_DEAD						= "Tot"
DBM_CORE_OK							= "Okay"

DBM_CORE_GENERIC_WARNING_BERSERK	= "Berserker in %s %s"
DBM_CORE_GENERIC_TIMER_BERSERK		= "Berserker"
DBM_CORE_OPTION_TIMER_BERSERK		= "Zeige Zeit bis $spell:26662"
DBM_CORE_OPTION_HEALTH_FRAME		= "Zeige Lebensanzeige"

DBM_CORE_OPTION_CATEGORY_TIMERS		= "Timer"
DBM_CORE_OPTION_CATEGORY_WARNINGS	= "Ansagen"
DBM_CORE_OPTION_CATEGORY_MISC		= "Verschiedenes"

DBM_CORE_AUTO_RESPONDED						= "Automatisch geantwortet."
DBM_CORE_STATUS_WHISPER						= "%s: %s, %d/%d Spieler am Leben"
DBM_CORE_AUTO_RESPOND_WHISPER				= "%s ist damit beschäftigt gegen %s zu kämpfen! (%s, %d/%d Spieler am Leben)"
DBM_CORE_WHISPER_COMBAT_END_KILL			= "%s hat %s besiegt!"
DBM_CORE_WHISPER_COMBAT_END_KILL_STATS		= "%s hat %s besiegt! Das war der %d. Sieg."
DBM_CORE_WHISPER_COMBAT_END_WIPE_AT			= "%s war %s bei %s unterlegen."
DBM_CORE_WHISPER_COMBAT_END_WIPE_STATS_AT	= "%s war %s bei %s unterlegen. Das war die %d. Niederlage auf diesem Schwierigkeitsgrad."

DBM_CORE_VERSIONCHECK_HEADER		= "Deadly Boss Mods - Versionen"
DBM_CORE_VERSIONCHECK_ENTRY			= "%s: %s (r%d)"
DBM_CORE_VERSIONCHECK_ENTRY_NO_DBM	= "%s: DBM nicht installiert"
DBM_CORE_VERSIONCHECK_FOOTER		= "%d Spieler mit Deadly Boss Mods gefunden"
DBM_CORE_YOUR_VERSION_OUTDATED      = "Deine Version von Deadly Boss Mods ist veraltet! Bitte besuche www.deadlybossmods.com um die neueste Version herunterzuladen."

DBM_CORE_UPDATEREMINDER_HEADER		= "Deine Version von Deadly Boss Mods ist veraltet.\n Version %s (r%d) ist hier zum Download verfügbar:"
DBM_CORE_UPDATEREMINDER_FOOTER		= "Drücke Strg+C um den Downloadlink in die Zwischenablage zu kopieren"
DBM_CORE_UPDATEREMINDER_NOTAGAIN	= "Zeige Popup, wenn eine neue Version verfügbar ist"

DBM_CORE_MOVABLE_BAR				= "Zieh mich!"

DBM_PIZZA_SYNC_INFO					= "|Hplayer:%1$s|h[%1$s]|h hat dir einen DBM-Timer geschickt: '%2$s'\n|HDBM:cancel:%2$s:nil|h|cff3588ff[Diesen Timer abbrechen]|r|h  |HDBM:ignore:%2$s:%1$s|h|cff3588ff[Timer von %1$s ignorieren]|r|h"
DBM_PIZZA_CONFIRM_IGNORE			= "Willst du wirklich DBM-Timer von %s für diese Sitzung ignorieren?"
DBM_PIZZA_ERROR_USAGE				= "Benutzung: /dbm [broadcast] timer <Sekunden> <Text>"

DBM_CORE_ERROR_DBMV3_LOADED			= "Deadly Boss Mods läuft doppelt, da du DBMv3 und DBMv4 installiert und aktiviert hast!\nKlick auf \"Okay\" um DBMv3 zu deaktivieren und dein Interface neu zu laden.\nAußerdem solltest du deinen AddOn-Ordner aufräumen, indem du die alten DBMv3-Ordner löschst."

DBM_CORE_MINIMAP_TOOLTIP_HEADER		= "Deadly Boss Mods"
DBM_CORE_MINIMAP_TOOLTIP_FOOTER		= "Shift+Klick oder Rechtsklick zum Bewegen\nAlt+Shift+Klick zum freien Bewegen"

DBM_CORE_RANGECHECK_HEADER			= "Abstandscheck (%dm)"
DBM_CORE_RANGECHECK_SETRANGE		= "Abstand einstellen"
DBM_CORE_RANGECHECK_SOUNDS			= "Sounds"
DBM_CORE_RANGECHECK_SOUND_OPTION_1	= "Sound, falls ein Spieler in Reichweite ist"
DBM_CORE_RANGECHECK_SOUND_OPTION_2	= "Sound, falls mehr als ein Spieler in Reichweite ist"
DBM_CORE_RANGECHECK_SOUND_0			= "Kein Sound"
DBM_CORE_RANGECHECK_SOUND_1			= "Standard-Sound"
DBM_CORE_RANGECHECK_SOUND_2			= "Nerviges Piepsen"
DBM_CORE_RANGECHECK_HIDE			= "Verstecken"
DBM_CORE_RANGECHECK_SETRANGE_TO		= "%dm"
DBM_CORE_RANGECHECK_LOCK			= "Fenster sperren"
DBM_CORE_RANGECHECK_OPTION_FRAMES	= "Fenster"
DBM_CORE_RANGECHECK_OPTION_RADAR	= "Zeige Radarfenster"
DBM_CORE_RANGECHECK_OPTION_TEXT		= "Zeige Textfenster"
DBM_CORE_RANGECHECK_OPTION_BOTH		= "Zeige beide Fenster"
DBM_CORE_RANGECHECK_OPTION_SPEED	= "Aktualisierungsrate (Reload erforderlich)"
DBM_CORE_RANGECHECK_OPTION_SLOW		= "Langsam (geringste CPU-Last)"
DBM_CORE_RANGECHECK_OPTION_AVERAGE	= "Mittel"
DBM_CORE_RANGECHECK_OPTION_FAST		= "Schnell (nahezu Echtzeit)"
DBM_CORE_RANGERADAR_HEADER			= "Abstandsradar (%dm)"

DBM_CORE_INFOFRAME_LOCK				= "Fenster sperren"
DBM_CORE_INFOFRAME_HIDE				= "Verstecken"
DBM_CORE_INFOFRAME_SHOW_SELF		= "Eigene Stärke immer anzeigen" -- Always show your own power value even if you are below the threshold

DBM_LFG_INVITE						= "Einladung der Gruppensuche"

DBM_CORE_SLASHCMD_HELP				= {
	"Verfügbare Slash-Kommandos:",
	"/dbm version: Prüft die Version im gesamten Schlachtzug (Alias: ver)",
--	"/dbm version2: Prüft die Version im gesamten Schlachtzug und flüstert Mitglieder mit veralteten Versionen an (Alias: ver2).",
	"/dbm unlock: Zeigt einen bewegbaren Timer an (alias: move)",
	"/dbm timer <x> <text>: Startet einen <x> Sekunden langen DBM-Timer mit dem Namen <text>",
	"/dbm broadcast timer <x> <text>: Schickt einen <x> Sekunden langen DBM-Timer mit dem Namen <text> an den Schlachtzug (nur als Leiter/Assistent)",
	"/dbm break <min>: Startet einen Pause-Timer für <min> Minuten. Schickt allen Schlachzugsmitgliedern mit DBM einen Pause-Timer (nur als Leiter/Assistent).",
	"/dbm pull <sec>: Startet einen Pull-Timer für <sec> Sekunden. Schickt allen Schlachzugsmitgliedern mit DBM einen Pull-Timer (nur als Leiter/Assistent).",
	"/dbm arrow: Zeigt den DBM-Pfeil, siehe /dbm arrow help für Details.",
	"/dbm lockout: Fragt die Schlachtzugsmitglieder nach ihren derzeitigen Instanzsperren (IDs) (nur als Leiter/Assistent).",
	"/dbm help: Zeigt diese Hilfe.",
}

DBM_ERROR_NO_PERMISSION				= "Du hast nicht die benötigte Berechtigung für diesen Befehl!"

DBM_CORE_BOSSHEALTH_HIDE_FRAME		= "Verstecken"

DBM_CORE_ALLIANCE					= "Allianz"
DBM_CORE_HORDE						= "Horde"

DBM_CORE_UNKNOWN					= "unbekannt"

DBM_CORE_BREAK_START				= "Pause startet jetzt -- du hast %s Minute(n)!"
DBM_CORE_BREAK_MIN					= "Pause endet in %s Minute(n)!"
DBM_CORE_BREAK_SEC					= "Pause endet in %s Sekunden!"
DBM_CORE_TIMER_BREAK				= "Pause!"
DBM_CORE_ANNOUNCE_BREAK_OVER		= "Pause ist vorbei"

DBM_CORE_TIMER_PULL					= "Pull in"
DBM_CORE_ANNOUNCE_PULL				= "Pull in %d Sek"
DBM_CORE_ANNOUNCE_PULL_NOW			= "Pull jetzt!"

DBM_CORE_ACHIEVEMENT_TIMER_SPEED_KILL = "Speed Kill (Erfolg)"

-- Auto-generated Timer Localizations
DBM_CORE_AUTO_TIMER_TEXTS = {
	target		= "%s: %%s",
	cast		= "%s",
	active		= "%s endet",--Buff/Debuff/event on boss
	fades		= "%s schwindet",--Buff/Debuff on players
	cd			= "%s CD",
	cdcount		= "%s CD (%%d)",
	cdsource	= "%s CD: %%s",
	next		= "Nächster %s",
	nextcount	= "Nächster %s (%%d)",
	nextsource	= "Nächster %s: %%s",
	achievement	= "%s"
}

DBM_CORE_AUTO_TIMER_OPTIONS = {
	target		= "Dauer des Debuffs $spell:%s anzeigen",
	cast		= "Wirkzeit von $spell:%s anzeigen",
	active		= "Dauer von $spell:%s anzeigen",
	fades		= "Zeit bis $spell:%s von Spielern schwindet anzeigen",
	cd			= "Abklingzeit von $spell:%s anzeigen",
	cdcount		= "Abklingzeit von $spell:%s anzeigen",
	cdsource	= "Abklingzeit von $spell:%s anzeigen",
	next		= "Zeit bis nächstes $spell:%s anzeigen",
	nextcount	= "Zeit bis nächstes $spell:%s anzeigen",
	nextsource	= "Zeit bis nächstes $spell:%s anzeigen",
	achievement	= "Zeit für %s anzeigen"
}

-- Auto-generated Warning Localizations
DBM_CORE_AUTO_ANNOUNCE_TEXTS = {
	target		= "%s auf >%%s<",
	targetcount	= "%s (%%d) auf >%%s<",
	spell		= "%s",
	adds		= "%s verbleibend: %%d",
	cast		= "Wirkt %s: %.1f Sek",
	soon		= "%s bald",
	prewarn 	= "%s in %s",
	phase		= "Phase %s",
	prephase	= "Phase %s bald",
	count		= "%s (%%d)",
	stack		= "%s auf >%%s< (%%d)"
}

local prewarnOption = "Zeige Vorwarnung für $spell:%s"
DBM_CORE_AUTO_ANNOUNCE_OPTIONS = {
	target		= "Verkünde Ziele von $spell:%s",
	targetcount	= "Verkünde Ziele von $spell:%s",
	spell		= "Zeige Warnung für $spell:%s",
	adds		= "Verkünde die Anzahl der verbleibenden $spell:%s",
	cast		= "Zeige Warnung, wenn $spell:%s gewirkt wird",
	soon		= prewarnOption,
	prewarn 	= prewarnOption,
	phase		= "Verkünde Phase %s",
	prephase	= "Zeige Vorwarnung für Phase %s",
	count		= "Zeige Warnung für $spell:%s",
	stack		= "Verkünde $spell:%s Stapel"
}

-- Auto-generated Special Warning Localizations
DBM_CORE_AUTO_SPEC_WARN_OPTIONS = {
	spell 		= "Zeige Spezialwarnung für $spell:%s",
	dispel 		= "Zeige Spezialwarnung zum Reinigen/Rauben von $spell:%s",
	interrupt	= "Zeige Spezialwarnung zum Unterbrechen von $spell:%s",
	you 		= "Zeige Spezialwarnung, wenn du von $spell:%s betroffen bist",
	target 		= "Zeige Spezialwarnung, wenn jemand von $spell:%s betroffen ist",
	close 		= "Zeige Spezialwarnung, wenn jemand in deiner Nähe von\n$spell:%s betroffen ist",
	move 		= "Zeige Spezialwarnung, wenn du von $spell:%s betroffen bist",
	run 		= "Zeige Spezialwarnung zum Weglaufen vor $spell:%s",
	cast 		= "Zeige Spezialwarnung zum Zauberstopp bei $spell:%s",
	stack 		= "Zeige Spezialwarnung für >=%d Stapel von $spell:%s",
	switch 		= "Zeige Spezialwarnung für Zielwechsel auf $spell:%s"
}

DBM_CORE_AUTO_SPEC_WARN_TEXTS = {
	spell = "%s!",
	dispel = "%s auf %%s - jetzt reinigen",
	interrupt = "%s - unterbreche %%s!",
	you = "%s auf dir",
	target = "%s auf %%s",
	close = "%s auf %%s in deiner Nähe",
	move = "%s - geh weg",
	run = "%s - lauf weg",
	cast = "%s - stoppe Zauber",
	stack = "%s (%%d)",
	switch = "%s - Ziel wechseln"
}


DBM_CORE_AUTO_ICONS_OPTION_TEXT			= "Setze Zeichen auf Ziele von $spell:%s"
DBM_CORE_AUTO_SOUND_OPTION_TEXT			= "Spiele \"Lauf weg!\"-Sound für $spell:%s"
DBM_CORE_AUTO_COUNTDOWN_OPTION_TEXT		= "Spiele Countdown-Sound für $spell:%s"
DBM_CORE_AUTO_COUNTOUT_OPTION_TEXT		= "Spiele Countout-Sound für Dauer von $spell:%s"
DBM_CORE_AUTO_YELL_OPTION_TEXT			= "Schreie, wenn du von $spell:%s betroffen bist"
DBM_CORE_AUTO_YELL_ANNOUNCE_TEXT		= "%s auf mir!"


-- New special warnings
DBM_CORE_MOVE_SPECIAL_WARNING_BAR	= "bewegbare Spezialwarnung"
DBM_CORE_MOVE_SPECIAL_WARNING_TEXT	= "Spezialwarnung"


DBM_CORE_RANGE_CHECK_ZONE_UNSUPPORTED	= "Eine %d Meter Abstandsprüfung wird in dieser Zone nicht unterstützt.\nUnterstützte Reichweiten sind 10, 11, 15 und 28 Meter."

DBM_ARROW_MOVABLE					= "Pfeil (bewegbar)"
DBM_ARROW_NO_RAIDGROUP				= "Diese Funktion steht nur in Schlachtzügen und innerhalb von Instanzen zu Verfügung." 
DBM_ARROW_ERROR_USAGE	= {
	"Benutzung des DBM-Pfeils:",
	"/dbm arrow <x> <y>  erzeugt einen Pfeil, der auf bestimmte Koordinaten zeigt (0 < x/y < 100)",
	"/dbm arrow <player>  erzeugt einen Pfeil, der auf einen bestimmten Spieler in deiner Gruppe oder deinem Schlachtzug zeigt",
	"/dbm arrow hide  versteckt den Pfeil",
	"/dbm arrow move  macht den Pfeil beweglich",
}

DBM_SPEED_KILL_TIMER_TEXT	= "Speed Kill"
DBM_SPEED_KILL_TIMER_OPTION	= "Zeige einen Timer zur Verbesserung deines schnellsten Siegs"


DBM_REQ_INSTANCE_ID_PERMISSION		= "%s möchte deine aktuellen Instanzsperren (IDs) einsehen.\n Möchtest Du diese Informationen an %s senden? Dieser Spieler wird in der Lage sein, diese Informationen während deiner aktuellen Sitzung abzufragen (also bis du dich neu einloggst)."
DBM_ERROR_NO_RAID					= "Du musst dich in einem Schlachtzug befinden um dieses Feature nutzen zu können."
DBM_INSTANCE_INFO_REQUESTED			= "Frage den gesamten Schlachtzug nach Instanzsperren (IDs) ab.\nBitte beachte, dass die Spieler nach ihrer Erlaubnis gefragt werden, bevor die Daten an dich gesendet werden. Bis zum Erhalt aller Antworten kann also einige Zeit vergehen."
DBM_INSTANCE_INFO_STATUS_UPDATE		= "Antworten von %d Spielern von %d DBM-Nutzern erhalten: %d sendeten Daten, %d haben die Anfrage abgelehnt. Warte %d weitere Sekunden auf Antworten..."
DBM_INSTANCE_INFO_ALL_RESPONSES		= "Antworten von allen Mitgliedern des Schlachtzuges erhalten"
DBM_INSTANCE_INFO_DETAIL_DEBUG		= "Sender: %s ResultType: %s InstanceName: %s InstanceID: %s Difficulty: %d Size: %d Progress: %s"  -- debug message not translated by intention
DBM_INSTANCE_INFO_DETAIL_HEADER		= "%s (%d), Schwierigkeitsgrad %d:"
DBM_INSTANCE_INFO_DETAIL_INSTANCE	= "    ID %s, Fortschritt %d: %s"
DBM_INSTANCE_INFO_STATS_DENIED		= "Anfrage abgelehnt: %s"
DBM_INSTANCE_INFO_STATS_AWAY		= "Abwesend: %s"
DBM_INSTANCE_INFO_STATS_NO_RESPONSE	= "Keine aktuelle DBM-Version installiert: %s"
DBM_INSTANCE_INFO_RESULTS			= "Ergebnis des Instanzsperren-Scans (IDs). Bitte beachte, dass Instanzen mehrmals angezeigt werden, wenn sich Spieler mit anderssprachigen WoW-Klienten im Schlachtzug befinden."
DBM_INSTANCE_INFO_SHOW_RESULTS		= "Spieler die noch nicht geantwortet haben: %s\n|HDBM:showRaidIdResults|h|cff3588ff[Ergebnisse jetzt anzeigen]|r|h"
