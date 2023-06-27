--------------------------------------------------------------------------
-- ptBR.lua 
--------------------------------------------------------------------------
--[[
GTFO Brazilian Portuguese Localization
Translator: Phalk, Omukeka

Change Log:
	v4.9.5
		- Added Brazilian Portuguese localization
	v4.12
		- Added untranslated strings
		
]]--

if (GetLocale() == "ptBR") then

GTFOLocal = 
{
	Active_Off = "Addon suspenso",
	Active_On = "Addon retomado",
	AlertType_Fail = "Falha",
	AlertType_FriendlyFire = "Fogo Amigo",
	AlertType_High = "Alto",
	AlertType_Low = "Baixo",
	ClosePopup_Message = "Você pode configurar seu GTFO depois digitando: %s",
	Group_None = "Nenhum",
	Group_NotInGroup = "Você não está em um grupo ou raide.",
	Group_PartyMembers = "%d de %d membros do grupo usam esse addon.",
	Group_RaidMembers = "%d de %d membros da raide usam este addon.",
	Help_Intro = "v%s (|cFFFFFFFFLista de Comandos|r)",
	Help_Options = "Mostrar Opções",
	Help_Suspend = "Suspender/Retomar addon",
	Help_Suspended = "O addon está atualmente suspenso.",
	Help_TestFail = "Testar um som (alerta de falha)",
	Help_TestFriendlyFire = "Tocar um som de teste (fogo amigo)",
	Help_TestHigh = "Tocar um som de teste (dano alto)",
	Help_TestLow = "Tocar um som de teste (dano baixo)",
	Help_Version = "Mostrar outros membros da raide usando este addon",
	LoadingPopup_Message = "Suas configurações para o GTFO foram redefinidas ao padrão. Você quer reconfigurar agora?",
	Loading_Loaded = "v%s carregado.",
	Loading_LoadedSuspended = "v%s carregado. (|cFFFF1111Suspenso|r)",
	Loading_LoadedWithPowerAuras = "v%s carregado junto do Power Auras.",
	Loading_NewDatabase = "v%s: Novo banco de dados detectado, redefinindo aos padrões.",
	Loading_OutOfDate = "v%s está disponível para download! |cFFFFFFFFAtualize por favor.|r",
	Loading_PowerAurasOutOfDate = "A versão do seu |cFFFFFFFFPower Auras Classic|r está desatualizada! A integração do GTFO e Power Auras não pôde ser carregada.",
	Recount_Environmental = "Ambientais",
	Recount_Name = "Alertas do GTFO",
	Skada_AlertList = "Tipos de Alerta do GTFO",
	Skada_Category = "Alertas",
	Skada_SpellList = "Magias do GTFO",
	TestSound_Fail = "Reproduzindo teste de som (alerta de falha).",
	TestSound_FailMuted = "Reproduzindo teste de som (alerta de falha). [|cFFFF4444MUDO|r]",
	TestSound_FriendlyFire = "Som de teste (fogo amigo) sendo tocado.",
	TestSound_FriendlyFireMuted = "Som de teste (fogo amigo) sendo tocado. [|cFFFF4444MUDO|r]",
	TestSound_High = "Reproduzindo teste de som (dano alto).",
	TestSound_HighMuted = "Reproduzindo teste de som (dano alto). [|cFFFF4444MUDO|r]",
	TestSound_Low = "Reproduzindo teste de som (dano baixo).",
	TestSound_LowMuted = "Reproduzindo teste de som (dano baixo). [|cFFFF4444MUDO|r]",
	UI_Enabled = "Habilitado",
	UI_EnabledDescription = "Habilitar o addon GTFO.",
	UI_Fail = "Sons de Alerta para Falhas",
	UI_FailDescription = "Habilitar os sons de alerta do GTFO para quando você tiver que se mover -- talvez da próxima vez você aprenda!",
	UI_FriendlyFire = "Sons para Fogo Amigo",
	UI_FriendlyFireDescription = "Ativar os alertas do GTFO para quando amigos estiverem explodindo -- é melhor um de vocês se mover!",
	UI_HighDamage = "Sons para Dano Alto/Raide",
	UI_HighDamageDescription = "Ativar os sons de corneta do GTFO para ambientes perigosos em que você deva se mover imediatamente.",
	UI_LowDamage = "Sons para JcJ/Ambiente/Dano Baixo.",
	UI_LowDamageDescription = "Ativar os bipes do GTFO -- use sua discrição para se mover ou não destas situações de dano baixo",
	UI_Test = "Teste",
	UI_TestDescription = "Testar o som.",
	UI_TestMode = "Modo Beta/Experimental",
	UI_TestModeDescription = "Testar alertas não verificados/não testados (Beta/PTR)",
	UI_TestModeDescription2 = "Por favor reporte qualquer problema para |cFF44FFFF%s@%s.%s|r",
	UI_Trivial = "Alertas para conteúdos triviais",
	UI_TrivialDescription = "Ativar alertas para encontros de baixo nível que seriam considerados triviais para o level atual do seu personagem.",
	UI_Unmute = "Tocar sons quando mudo",
	UI_UnmuteDescription = "Se você tiver o controle de som mestre mudo, o GTFO irá momentaneamente ligá-lo para tocar os sons do GTFO.",
	UI_UnmuteDescription2 = "Isso requer que o controle mestre de volume esteja maior que 0%.",
	UI_Volume = "Volume do GTFO",
	UI_VolumeDescription = "Definir o volume dos sons tocados.",
	UI_VolumeLoud = "4: Alto",
	UI_VolumeLouder = "5: Alto",
	UI_VolumeMax = "Max",
	UI_VolumeMin = "Min",
	UI_VolumeNormal = "3: Normal (Recomendado)",
	UI_VolumeQuiet = "1: Silêncio",
	UI_VolumeSoft = "2: Suave",
	-- 4.12
	UI_SpecialAlerts = "Special Alerts",
	UI_SpecialAlertsHeader = "Activate Special Alerts",	
	-- 4.12.3
	Version_On = "Version reminders on",
	Version_Off = "Version reminders off",
}


end