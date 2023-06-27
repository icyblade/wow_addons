--------------------------------------------------------------------------
-- deDE.lua 
--------------------------------------------------------------------------
--[[
GTFO German Localization
Translator: Freydis88, GusBackus, Zaephyr81

Change Log:
	v2.8.1
		- Added German localization
	v3.1
		- Updated German localization for 3.0
	v3.2.2
		- Added untranslated strings
	v3.5.1
		- Updated German localization
	v4.7
		- Fixed localization issues
	v4.8.6
		- Updated German localization
	v4.12
		- Added untranslated strings
		
]]--

if (GetLocale() == "deDE") then

GTFOLocal = 
{
	Active_Off = "AddOn pausiert", -- Needs review
	Active_On = "AddOn wird fortgesetzt", -- Needs review
	AlertType_Fail = "Versagt", -- Needs review
	AlertType_FriendlyFire = "Friendly Fire", -- Requires localization
	AlertType_High = "Hoch", -- Needs review
	AlertType_Low = "Niedrig", -- Needs review
	ClosePopup_Message = "Mit %s kannst du deine GTFO Einstellungen später ändern.",
	Group_None = "Keine",
	Group_NotInGroup = "Du bist weder in einer Gruppe, noch in einem Schlachtzug",
	Group_PartyMembers = "%d von %d Gruppenmitgliedern verwenden dieses Add-On",
	Group_RaidMembers = "%d von %d Schlachtzugmitgliedern verwenden dieses AddOn", -- Needs review
	Help_Intro = "v%s (|cFFFFFFFFBefehlsliste|r)",
	Help_Options = "Optionen anzeigen",
	Help_Suspend = "AddOn pausieren/fortsetzen", -- Needs review
	Help_Suspended = "Derzeit pausiert das AddOn.", -- Needs review
	Help_TestFail = "Tonsignal zum Testen abspielen (Warnsignal für Fehlschläge)",
	Help_TestFriendlyFire = "Tonsignal zum Testen abspielen (Friendly Fire)",
	Help_TestHigh = "Tonsignal zum Testen abspielen (hoher Schaden)",
	Help_TestLow = "Tonsignal zum Testen abspielen (niedriger Schaden)",
	Help_Version = "Andere Schlachtzugmitglieder anzeigen, die dieses AddOn aktiviert haben.", -- Needs review
	LoadingPopup_Message = "GTFO Einstellungen wurden zurückgesetzt. Jetzt neu konfigurieren?",
	Loading_Loaded = "v%s wurde geladen.",
	Loading_LoadedSuspended = "v%s wurde geladen. (|cFFFF1111Pausiert|r)",
	Loading_LoadedWithPowerAuras = "v%s mit Power Auras wurde geladen.",
	Loading_NewDatabase = "v%s: Eine neue Version der Datenbank wurde gefunden; es wird auf die Standardeinstellungen zurückgesetzt.",
	Loading_OutOfDate = "v%s ist nun zum Herunterladen verfügbar!  |cFFFFFFFFBitte aktualisieren.|r",
	Loading_PowerAurasOutOfDate = "Deine Version von |cFFFFFFFFPower Auras Classic|r ist veraltet!  GTFO & Power-Auras-Integration konnte nicht geladen werden.",
	Recount_Environmental = "Umgebung ", -- Needs review
	Recount_Name = "GTFO Alarme", -- Needs review
	Skada_AlertList = "GTFO  Alarmtypen", -- Needs review
	Skada_Category = "Warnungen", -- Needs review
	Skada_SpellList = "GTFO Zauber", -- Needs review
	TestSound_Fail = "Tonsignal zum Testen (Warnsignal für Fehlschläge) wird abgespielt.",
	TestSound_FailMuted = "Tonsignal zum Testen (Warnsignal für Fehlschläge) wird abgespielt. [|cFFFF4444VERSTUMMT|r]",
	TestSound_FriendlyFire = "Tonsignal zum Testen (Friendly Fire) wird abgespielt.",
	TestSound_FriendlyFireMuted = "Tonsignal zum Testen (Friendly Fire) wird abgespielt. [|cFFFF4444VERSTUMMT|r]",
	TestSound_High = "Tonsignal zum Testen (hoher Schaden) wird abgespielt.",
	TestSound_HighMuted = "Tonsignal zum Testen (hoher Schaden) wird abgespielt. [|cFFFF4444VERSTUMMT|r]",
	TestSound_Low = "Tonsignal zum Testen (niedriger Schaden) wird abgespielt.",
	TestSound_LowMuted = "Tonsignal zum Testen (niedriger Schaden) wird abgespielt. [|cFFFF4444VERSTUMMT|r]",
	UI_Enabled = "Aktiviert",
	UI_EnabledDescription = "GTFO-Add-On aktivieren",
	UI_Fail = "Warnsignale für Fehlschläge",
	UI_FailDescription = "GTFO-Warnsignale für den Fall, dass du dich nicht wegbewegt hast, aktivieren -- hoffentlich lernst du es für das nächste Mal!",
	UI_FriendlyFire = "Friendly Fire Tonsignale",
	UI_FriendlyFireDescription = "GTFO Alarmsignale für den Fall, dass Gruppenmitglieder wandelnde Bomben sind, aktivieren -- einer von euch sollte sich bewegen!",
	UI_HighDamage = "Tonsignale für Schlachtzug/hoher Schaden",
	UI_HighDamageDescription = "GTFO-Summer-Tonsignale für gefährliche Umgebungen, aus denen du sofort verschwinden solltest, aktivieren.",
	UI_LowDamage = "Tonsignale für PvP/Umgebung/niedriger Schaden",
	UI_LowDamageDescription = "GTFO-Deppen-Tonsignale aktivieren -- entscheide nach deinem Ermessen, ob du aus diesen Umgebungen mit niedrigem Schaden verschwindest oder nicht.",
	UI_Test = "Test",
	UI_TestDescription = "Tonsignale testen.",
	UI_TestMode = "Experimenteller/Beta Modus",
	UI_TestModeDescription = "Aktiviert ungetestete/ungeprüfte Warnungen. (Beta/PTR)",
	UI_TestModeDescription2 = "Meldet Probleme bitte an |cFF44FFFF%s@%s.%s|r",
	UI_Trivial = "Warnsignale für belanglose Begegnungen",
	UI_TrivialDescription = "Aktiviert Tonsignale für niedrigstufige Gegner, welche dir auf deinem Level nicht ernsthaft schaden.",
	UI_Unmute = "Tonsignale abspielen, wenn stummgeschaltet",
	UI_UnmuteDescription = "Falls Du die allgemeine Tonausgabe oder die Sound-Effekte stummgeschaltet haben solltest, aktiviert GTFO vorübergehend die Audiosignale, um ausschließlich jene von GTFO abzuspielen.", -- Needs review
	UI_UnmuteDescription2 = "Lautstärkeregler dürfen nicht auf 0% stehen.", -- Needs review
	UI_Volume = "GTFO-Lautstärke",
	UI_VolumeDescription = "Audiolautstärke einstellen.",
	UI_VolumeLoud = "4: Laut",
	UI_VolumeLouder = "5: Laut",
	UI_VolumeMax = "Max. ",
	UI_VolumeMin = "Min. ",
	UI_VolumeNormal = "3: Normal (wird empfohlen)",
	UI_VolumeQuiet = "1: Still",
	UI_VolumeSoft = "2: Leise",
	-- 4.12
	UI_SpecialAlerts = "Special Alerts",
	UI_SpecialAlertsHeader = "Activate Special Alerts",	
	-- 4.12.3
	Version_On = "Version reminders on",
	Version_Off = "Version reminders off",
}


end