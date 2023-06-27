--------------------------------------------------------------------------
-- esMX.lua 
--------------------------------------------------------------------------
--[[
GTFO Spanish Localization
Translator: Pablous (Copied from esES)

Change Log:
	v4.2.2
		- Added Latin American Spanish localization
	v4.7
		- Fixed localization issues
	v4.9
		- Fixed localization issues
	v4.12
		- Added untranslated strings
		
]]--

if (GetLocale() == "esMX") then

GTFOLocal = 
{
	Active_Off = "Addon desactivado",
	Active_On = "Addon activado",
	AlertType_Fail = "Fallo",
	AlertType_FriendlyFire = "Fuego Amigo",
	AlertType_High = "Alto",
	AlertType_Low = "Bajo",
	ClosePopup_Message = "Puedes configurar el GTFO mas tarde, escribiendo: %s",
	Group_None = "Nadie",
	Group_NotInGroup = "No estas en un grupo o raid.",
	Group_PartyMembers = "%d def %d personas del grupo utilizan este addon.",
	Group_RaidMembers = "%d de %d personas de la raid utilizan este addon.",
	Help_Intro = "v%s (|cFFFFFFFFCommand List|r)",
	Help_Options = "Opciones de visualizacion",
	Help_Suspend = "Desactivar/Activar addon",
	Help_Suspended = "El addon se encuentra desactivado.",
	Help_TestFail = "Reproducir un sonido de prueba (alerta de fallo)",
	Help_TestFriendlyFire = "Reproduce un sonido de prueba (fuego amigo)",
	Help_TestHigh = "Reproducir un sonido de prueba (daño alto)",
	Help_TestLow = "Reproducir un sonido de prueba (daño bajo)",
	Help_Version = "Mostrar otras personas que tengan este addon",
	LoadingPopup_Message = "Tu configuracion del GTFO se ha restablecido. ¿Deseas configurarlo ahora?",
	Loading_Loaded = "v%s cargado.",
	Loading_LoadedSuspended = "v%s cargado. (|cFFFF1111Suspended|r)",
	Loading_LoadedWithPowerAuras = "v%s cargado con Power Auras.",
	Loading_NewDatabase = "v%s: Nueva base de datos detectada, restableciendo por defecto.",
	Loading_OutOfDate = "¡v%s esta disponible para descargar!  |cFFFFFFFFPlease update.|r",
	Loading_PowerAurasOutOfDate = "¡Tu version de |cFFFFFFFFPower Auras Classic|r es antigua!  La integracion de GTFO & Power Auras no puede ser cargada.",
	Recount_Environmental = "Zona",
	Recount_Name = "Alertas del GTFO",
	Skada_AlertList = "GTFO Alert Types", -- Requires localization
	Skada_Category = "Alerts", -- Requires localization
	Skada_SpellList = "GTFO Spells", -- Requires localization
	TestSound_Fail = "Reproduciendo sonido de prueba (alerta de fallo)",
	TestSound_FailMuted = "Reproduciendo sonido de prueba (alerta de fallo). [|cFFFF4444MUTED|r]",
	TestSound_FriendlyFire = "Reproduciendo sonido de prueba (fuego amigo).",
	TestSound_FriendlyFireMuted = "Reproduciendo sonido de prueba (fuego amigo). [|cFFFF4444MUTED|r]",
	TestSound_High = "Reproduciendo sonido de prueba (daño alto).",
	TestSound_HighMuted = "Reproduciendo sonido de prueba (daño alto). [|cFFFF4444MUTED|r]",
	TestSound_Low = "Reproduciendo sonido de prueba (daño bajo).",
	TestSound_LowMuted = "Reproduciendo sonido de prueba (daño bajo). [|cFFFF4444MUTED|r]",
	UI_Enabled = "Activado",
	UI_EnabledDescription = "Activa el addon GTFO",
	UI_Fail = "Sonido de Alerta de Fallo",
	UI_FailDescription = "Activa el sonido de alerta de GTFO cuando se SUPONIA que debias moverte -- ¡Espero que lo hayas aprendido para la proxima!",
	UI_FriendlyFire = "Sonidos de Fuego Amigo",
	UI_FriendlyFireDescription = "Activa el sonido de alerta de GTFO cuando un compañero te daña -- ¡Que alguien se aleje!",
	UI_HighDamage = "Sonido de Raid/Daño Alto",
	UI_HighDamageDescription = "Activa el sonido del GTFO para zonas peligrosas donde deberias moverte inmediatamente.",
	UI_LowDamage = "Sonidos de JcJ/Zona/Daño Bajo",
	UI_LowDamageDescription = "Activa el sonido del GTFO -- Muevete con discrecion de la zona de poco daño.",
	UI_Test = "Prueba",
	UI_TestDescription = "Prueba el sonido.",
	UI_TestMode = "Modo Beta/Experimental",
	UI_TestModeDescription = "Activar alertas sin probar/verificar (Beta/PTR)",
	UI_TestModeDescription2 = "Por favor informa de cualquier problema a |cFF44FFFF%s@%s.%s|r",
	UI_Trivial = "Alertas de contenido trivial",
	UI_TrivialDescription = "Activa alertas para encuentros de bajo nivel que podrian ser triviales para un personaje de tu nivel.",
	UI_Unmute = "Reproducir sonidos cuando esta en silencio",
	UI_UnmuteDescription = "Si has silenciado todos los sonidos, o los efectos de sonido, GTFO activará temporalmente los sonidos para reproducir las alertas.", -- Needs review
	UI_UnmuteDescription2 = "Requiere que las barras de volumen esten a mas del 0%", -- Needs review
	UI_Volume = "Volumen del GTFO",
	UI_VolumeDescription = "Configura el volumen de los sonidos.",
	UI_VolumeLoud = "4: Alto",
	UI_VolumeLouder = "5: Alto",
	UI_VolumeMax = "Maximo",
	UI_VolumeMin = "Minimo",
	UI_VolumeNormal = "3: Normal (Recomendado)",
	UI_VolumeQuiet = "1: Silencio",
	UI_VolumeSoft = "2: Bajo",
	-- 4.12
	UI_SpecialAlerts = "Special Alerts",
	UI_SpecialAlertsHeader = "Activate Special Alerts",	
	-- 4.12.3
	Version_On = "Version reminders on",
	Version_Off = "Version reminders off",
}


end