--------------------------------------------------------------------------
-- frFR.lua 
--------------------------------------------------------------------------
--[[
GTFO French Localization
Translator: Blubibulga, TrAsHeR

Change Log:
	v3.1.1
		- Added French localization
	v3.2.2
		- Added untranslated strings
	v3.3.2
		- Added untranslated strings
	v4.2.1
		- Added untranslated strings
	v4.4.1
		- Added untranslated strings
	v4.6.1
		- Added untranslated strings
	v4.10
		- Updated French localization
	v4.12
		- Added untranslated strings
	v4.12.3
		- Updated French localization
	v4.12.4
		- Updated French localization

]]--

if (GetLocale() == "frFR") then

GTFOLocal = 
{
	Active_Off = "Addon suspendu",
	Active_On = "Addon actif",
	AlertType_Fail = "Échec",
	AlertType_FriendlyFire = "Ami enflammé",
	AlertType_High = "Haut",
	AlertType_Low = "Bas",
	ClosePopup_Message = "Vous pouvez configurer vos paramètres de GTFO plus tard en tapant : %s",
	Group_None = "Aucun",
	Group_NotInGroup = "Vous n'êtes pas dans un groupe ou un raid.",
	Group_PartyMembers = "%d des %d membres du groupe utilisent cet addon.",
	Group_RaidMembers = "%d des %d membres du raid utilisent cet addon.",
	Help_Intro = "v%s (|cFFFFFFFFListe de commande|r)",
	Help_Options = "Options d'affichages",
	Help_Suspend = "Suspendre/Activer l'addon",
	Help_Suspended = "L'addon est actuellement suspendu.",
	Help_TestFail = "Jouer un test sonore (alerte d'échec)",
	Help_TestFriendlyFire = "Jouer un test sonore (ami enflammé)",
	Help_TestHigh = "Jouer un test sonore (dommage élevé)",
	Help_TestLow = "Jouer un test sonore (dommage faible)",
	Help_Version = "Afficher les autres attaquants exécutant cet addon",
	LoadingPopup_Message = "Vos paramètres de GTFO ont été réinitialisées par défaut.  Vous voulez configurer vos paramètres maintenant ?",
	Loading_Loaded = "v%s chargé.",
	Loading_LoadedSuspended = "v%s chargé. (|cFFFF1111Suspendu|r)",
	Loading_LoadedWithPowerAuras = "v%s chargé avec Power Auras.",
	Loading_NewDatabase = "v%s: Nouvelle version de base de données détectée, réinitialiser les paramètres par défaut.",
	Loading_OutOfDate = "v%s est maintenant disponible en téléchargement !  |cFFFFFFFFVeuillez mettre à jour.|r",
	Loading_PowerAurasOutOfDate = "Votre version de |cFFFFFFFFPower Auras Classic|r est obsolète !  GTFO & l'intégration de Power Auras n'a pas pu être chargée.",
	Recount_Environmental = "Environnemental",
	Recount_Name = "Alertes GTFO",
	Skada_AlertList = "Types d'Alertes GTFO",
	Skada_Category = "Alertes",
	Skada_SpellList = "Sorts GTFO",
	TestSound_Fail = "Test sonore (alerte d'échec) joué.",
	TestSound_FailMuted = "Test sonore (alerte d'échec) joué. [|cFFFF4444MUET|r]",
	TestSound_FriendlyFire = "Test sonore (ami enflammé) joué.",
	TestSound_FriendlyFireMuted = "Test sonore (ami enflammé) joué. [|cFFFF4444MUET|r]",
	TestSound_High = "Test sonore (dommage élevé) joué.",
	TestSound_HighMuted = "Test sonore (dommage élevé) joué. [|cFFFF4444MUET|r]",
	TestSound_Low = "Test sonore (dommage faible) joué.",
	TestSound_LowMuted = "Test sonore (dommage faible) joué. [|cFFFF4444MUET|r]",
	UI_Enabled = "Activé",
	UI_EnabledDescription = "Activer l'addon GTFO.",
	UI_Fail = "Sons d'alertes d'échecs",
	UI_FailDescription = "Activer les sons d'alertes GTFO lorsque vous êtes SUPPOSÉ allez plus loin -- j'espère que vous apprendrez pour la prochaine fois !",
	UI_FriendlyFire = "Sons d'ami enflammé",
	UI_FriendlyFireDescription = "Activer les sons d'alerte de GTFO lorsque vos coéquipiers marchent dans des explosions -- un de vos meilleurs déplacement !",
	UI_HighDamage = "Sons de Raid/Haut Dommage",
	UI_HighDamageDescription = "Activer les sons du buzzer de GTFO pour les environnements dangereux que vous devez éviter d'immédiatement.",
	UI_LowDamage = "Sons de JcJ/Environnement/Faible Dommage",
	UI_LowDamageDescription = "Activer les sons de crétins de GTFO -- utiliser votre discrétion ou non pour bouger de ces environnements de dommages faible",
	UI_Test = "Test",
	UI_TestDescription = "Tester le son.",
	UI_TestMode = "Mode Expérimental/Bêta",
	UI_TestModeDescription = "Activer les alertes non testées/non vérifiées (Beta/PTR)",
	UI_TestModeDescription2 = "Veuillez signaler tout problème à |cFF44FFFF%s@%s.%s|r",
	UI_Trivial = "Alertes de contenu triviales",
	UI_TrivialDescription = "Activer les alertes pour les rencontres de bas niveau qui seraient autrement jugés triviales pour niveau actuel du votre personnage.",
	UI_Unmute = "Jouer les sons lorsque mis en sourdine",
	UI_UnmuteDescription = "Si vous avez le son principal mis en sourdine, GTFO activera temporairement le son brièvement pour jouer les sons de GTFO.",
	UI_UnmuteDescription2 = "Cela exige que le curseur du volume principal soit supérieur à 0 %.",
	UI_Volume = "Volume GTFO",
	UI_VolumeDescription = "Définissez le volume de la lecture des sons.",
	UI_VolumeLoud = "4 : Fort",
	UI_VolumeLouder = "5 : Fort",
	UI_VolumeMax = "Max",
	UI_VolumeMin = "Min",
	UI_VolumeNormal = "3 : Normal (Recommandé)",
	UI_VolumeQuiet = "1 : Calme",
	UI_VolumeSoft = "2 : Doux",
	-- 4.12
	UI_SpecialAlerts = "Alertes Spéciales",
	UI_SpecialAlertsHeader = "Activer les Alertes Spéciales",	
	-- 4.12.3
	Version_On = "Rappels de mise à jour de version Arrêt",
	Version_Off = "Rappels de mise à jour de version Marche",
}

end