local L = LibStub("AceLocale-3.0"):NewLocale("Spy", "ptBR")
if not L then return end


-- Addon information
L["Spy"] = "Spy"
L["Version"] = "Versão"
L["LoadDescription"] = "|cff9933ffSpy foi carregado. Digite |cffffffff/spy|cff9933ff para opções."
L["SpyEnabled"] = "|cff9933ffSpy addon ativado."
L["SpyDisabled"] = "|cff9933ffSpy addon desativado. Digite |cffffffff/spy show|cff9933ff para ativar."
L["UpgradeAvailable"] = "|cff9933ffA nova versão do Spy está disponivel. Baixe-o em:\n|cffffffffhttp://wow.curse.com/downloads/wow-addons/details/spy.aspx"

-- Configuration strings
L["Profiles"] = "Perfis"

L["GeneralSettings"] = "Configurações Gerais"
L["SpyDescription1"] = [[
Spy é um addon que vai alerta-lo da presença de jogadores inimigos nas proximidades.
]]
L["SpyDescription2"] = [[

|cffffd000Lista de Proximidades|cffffffff
A lista de Proximidades mostra qualquer inimigo detectado nas proximidades. Clicando na lista você irá mirar no jogador, mas isso só funciona fora de combate. Jogadores são removidos da lista se não forem mais detectados após um certo período de tempo.

O botão limpar na barra de titulo é usado para limpar a lista, e segurando Ctrl enquanto limpa a lista permite a você rapidamente ativar/desativar o Spy.

|cffffd000Lista da Última Hora|cffffffff
A Lista da Última Hora mostra todos os inimigos detectados na ultima hora.

|cffffd000Lista de Ignorados|cffffffff
Jogadores que são adicionados à lista de Ignorados não serão reportados pelo Spy. Você pode adicionar ou remover jogadores dessa lista usando o menu de contexto ou segurando Ctrl enquanto clicando no botão.

|cffffd000Lista Negra|cffffffff
Jogadores que são adicionados à Lista Negra são reportados pelo Spy através de um alarme sonoro.  Você pode adicionar ou remover jogadores dessa lista usando o menu de contexto ou segurando Shift enquanto clica no botão.

O menu de contexto também permite que você justifique as razões que o levou a colocar determinada pessoa na Lista Negra. Se quiser colocar uma motivo especifico que não tenha na lista, em seguida, use "Digite seu próprio motivo..." em Outra lista..


|cffffd000Autor: http://www.curse.com/users/slipjack |cffffffff

]]
L["EnableSpy"] = "Ativar Spy"
L["EnableSpyDescription"] = "Ativa ou desativa o Spy."
L["EnabledInBattlegrounds"] = "Ativar Spy em CB"
L["EnabledInBattlegroundsDescription"] = "Ativa ou desativa o Spy em Campos de Batalha."
L["EnabledInArenas"] = "Ativar Spy em Arenas"
L["EnabledInArenasDescription"] = "Ativa ou desativa o Spy em Arenas."
L["EnabledInWintergrasp"] = "Ativar Spy em Zonas de Combate"
L["EnabledInWintergraspDescription"] = "Ativa ou desativa o Spy em locais como Invérnia."
L["DisableWhenPVPUnflagged"] = "Desativar Spy quando PVP estiver desativado"
L["DisableWhenPVPUnflaggedDescription"] = "Ativa ou desativa o Spy dependendo se o seu status de PVP estiver ativado ou desativado."

L["DisplayOptions"] = "Exibição"
L["DisplayOptionsDescription"] = [[
Spy pode ser mostrado e escondido automaticamente.
]]
L["ShowOnDetection"] = "Mostrar Spy quando um inimigo for detectado"
L["ShowOnDetectionDescription"] = "Marque isso para que o Spy mostre a lista de Proximidades quando um inimigo for detectado."
L["HideSpy"] = "Esconder Spy quando nenhum inimigo for detectado"
L["HideSpyDescription"] = "Marque isso para que o Spy seja escondido quando a lista de Proximidades estiver sendo mostrada e ficar vazia. Spy não será escondido se você limpar a lista manualmente."
L["LockSpy"] = "Travar a janela do Spy"
L["LockSpyDescription"] = "Trava a janela para que ela não possa ser movida."
L["InvertSpy"] = "Inverter a janela de Spy"
L["InvertSpyDescription"] = "Inverte a janela de Spy de cabeça para baixo."
L["ResizeSpy"] = "Redimensionar janela do Spy automaticamente"
L["ResizeSpyDescription"] = "Marque isso para que a janela do Spy seja redimensionada a medida que novos jogadores são adicionados ou removidos."
L["TooltipDisplayWinLoss"] = "Mostar estastica de Vitória/Derrota nas dicas"
L["TooltipDisplayWinLossDescription"] = "Marque isso para que seja mostrado na dicas do jogador, as estasticas de Vitória/Derrota daquele um jogador."
L["TooltipDisplayKOSReason"] = "Mostrar motivos da Lista Negra nas dicas"
L["TooltipDisplayKOSReasonDescription"] = "Marque isso para que seja mostrado na dicas do jogador os motivos da Lista Negra daquele jogador."
L["TooltipDisplayLastSeen"] = "Mostrar detalhes da ultima vez visto nas dicas"
L["TooltipDisplayLastSeenDescription"] = "Marque isso para que seja mostrado nas dicas de jogador o ultimo local e hora em que aquele jogador foi visto."

L["AlertOptions"] = "Alertas"
L["AlertOptionsDescription"] = [[
Você pode anunciar em qualquer canal do chat os detalhes de um encontro e controlar como o Spy te alerta quando um inimigo é detectado.
]]
L["Announce"] = "Anunciar Para:"
L["None"] = "Ninguem"
L["NoneDescription"] = "Não anunciar quando jogadores inimigos forem detectados."
L["Self"] = "Você"
L["SelfDescription"] = "Anunciar para si mesmo quando jogadores inimigos forem detectados"
L["Party"] = "Grupo"
L["PartyDescription"] = "Anunciar para o grupo quando jogadores inimigos forem detectados."
L["Guild"] = "Guilda"
L["GuildDescription"] = "Anunciar para a guilda quando jogadores inimigos forem detectados."
L["Raid"] = "Raide"
L["RaidDescription"] = "Anunciar para a raide quando jogadores inimigos forem detectados."
L["LocalDefense"] = "Defesa Local"
L["LocalDefenseDescription"] = "Anunciar para a Defesa Local quando jogadores inimigos forem detectados."
L["OnlyAnnounceKoS"] = "Anunciar inimigos da Lista Negra"
L["OnlyAnnounceKoSDescription"] = "Marque isso para anunciar apenas inimigos que estejam na Lista Negra."
L["WarnOnStealth"] = "Alertar ao detectar invisibilidade"
L["WarnOnStealthDescription"] = "Marque isso para alertar com texto e som quando um inimigo ficar invisivel."
L["WarnOnKOS"] = "Alertar ao detectar inimigos da Lista Negra"
L["WarnOnKOSDescription"] = "Marque isso para alertar com texto e som quando um inimigo da Lista Negra for detectado."
L["WarnOnKOSGuild"] = "Alertar ao detectar Guildie de Lista Negra"
L["WarnOnKOSGuildDescription"] = "Marque isso para alertar com texto e som quando for detectado um integrante da guilda de alguem que esteja na Lista Negra."
L["DisplayWarningsInErrorsFrame"] = "Mostrar alertas no campo de erros"
L["DisplayWarningsInErrorsFrameDescription"] = "Marque isso para usar o campo de erros para mostrar alertas ao invés de usar os popups graficos."
L["EnableSound"] = "Ativar alertas sonoros"
L["EnableSoundDescription"] = "marque isso para ativar alertas sonoros quando um inimigo for detectado. Os sons são diferentes para Lista Negra e inimigos que ficam invisiveis."

L["ListOptions"] = "Lista de Proximidades"
L["ListOptionsDescription"] = [[
Você pode configurar como o Spy adiciona e remove inimigos da lista de Proximidades.
]]
L["RemoveUndetected"] = "Remover jogadores não detectados da lista de Proximidades após:"
L["1Min"] = "1 minuto"
L["1MinDescription"] = "Remove jogadores que não forem mais detectados após 1 minuto."
L["2Min"] = "2 minutos"
L["2MinDescription"] = "Remove jogadores que não forem mais detectados após 2 minutos."
L["5Min"] = "5 minutos"
L["5MinDescription"] = "Remove jogadores que não forem mais detectados após 5 minutos."
L["10Min"] = "10 minutos"
L["10MinDescription"] = "Remove jogadores que não forem mais detectados após 10 minutos."
L["15Min"] = "15 minutos"
L["15MinDescription"] = "Remove jogadores que não forem mais detectados após 15 minutos."
L["Never"] = "Nunca Remover"
L["NeverDescription"] = "Nunca remover jogadores inimigos. A lista de Proximidades ainda pode ser limpa manualmente."
L["ShowNearbyList"] = "Trocar para a lista de Proximidades ao detectar jogador inimigo"
L["ShowNearbyListDescription"] = "Marque isso para que ao detectar jogadores inimigos, seja mostrada a lista de Proximidades se já não estiver sendo mostrada."
L["PrioritiseKoS"] = "Piorizar inimigos da Lista Negra na lista de Proximidades"
L["PrioritiseKoSDescription"] = "Marque isso para sempre motrar primeiro inimigos da Lista Negra na lista de Proximidades."

L["MinimapOptions"] = "Mapa"
L["MinimapOptionsDescription"] = [[
Para jogadores que podem rastrear humanóides o minimapa pode ser utilizado para fornecer recursos adicionais.

Jogadores que podem rastrear humanóides incluem caçadores, druidas e aqueles que recebem a habilidade por outros meios como por exemplo comendo Filé de Worg Esturricado.
]]
L["MinimapTracking"] = "Ativar rastreamento no minimapa"
L["MinimapTrackingDescription"] = "Marque isso para ativar rastreamento e detecção no minimapa. Jogadores inimigos detectados no minimapa serão adicionados à lista de Proximidades."
L["MinimapDetails"] = "Mostrar detalhes de level/classe nas dicas"
L["MinimapDetailsDescription"] = "Marque isso para atualizar as dicas do mapa para que o level e a classe sejam mostrados juntamente com o nome dos inimigos."
L["DisplayOnMap"] = "Mostrar localização do inimigo no mapa"
L["DisplayOnMapDescription"] = "Marque isso para que seja mostrado no mapa-múndi e no minimapa a localização dos inimigos detectados por outros usuários do Spy em seu grupo, raide e guilda."
L["MapDisplayLimit"] = "Limitar icones mostrados no mapa para:"
L["LimitNone"] = "Todos os lugares"
L["LimitNoneDescription"] = "Mostrar no mapa todos os inimigos detectados independente da sua atual localização."
L["LimitSameZone"] = "Mesma Zona"
L["LimitSameZoneDescription"] = "Mostrar no mapa somente inimigos que estejam na mesma zona que você."
L["LimitSameContinent"] = "Mesmo Continente"
L["LimitSameContinentDescription"] = "Mostrar no mapa somente inimigos que estejam no mesmo continente que você."

L["DataOptions"] = "Gerenciamento de Dados"
L["DataOptionsDescription"] = [[
Você pode configurar como o Spy coleta e mantem os dados.
]]
L["PurgeData"] = "Limpar dados de inimigos não detectados após:"
L["OneDay"] = "1 dia"
L["OneDayDescription"] = "Limpa os dados de inimigos que não foram detectados a mais de 1 dia."
L["FiveDays"] = "5 dias"
L["FiveDaysDescription"] = "Limpa os dados de inimigos que não foram detectados a mais de 5 dias dias."
L["TenDays"] = "10 dias"
L["TenDaysDescription"] = "Limpa os dados de inimigos que não foram detectados a mais de 10 dias."
L["ThirtyDays"] = "30 dias"
L["ThirtyDaysDescription"] = "Limpa os dados de inimigos que não foram detectados a mais de 30 dias."
L["SixtyDays"] = "60 dias"
L["SixtyDaysDescription"] = "Limpa os dados de inimigos que não foram detectados a mais de 60 dias."
L["NinetyDays"] = "90 dias"
L["NinetyDaysDescription"] = "Limpa os dados de inimigos que não foram detectados a mais de 90 dis."
L["ShareData"] = "Compartilhar dados com outros usuários do Spy"
L["ShareDataDescription"] = "Marque isso para compartilhar os dados dos inimigos encontrados com outros usuários do Spy em seu grupo, raide e guilda."
L["UseData"] = "Usar dados de outros usuários do Spy"
L["UseDataDescription"] = [[Marque isso para usar dados coletados por outros usuários do Spy em seu grupo, raide e guilda.

Se outro usuário do Spy detectar um jogador inimigo ele será adicionado a sua lista de Proximidades se ela não estiver cheia
]]
L["ShareKOSBetweenCharacters"] = "Compartilhar Lista Negra entre todos os seus personagens"
L["ShareKOSBetweenCharactersDescription"] = "Marque isso para que a Lista Negra seja compartilhada entre todos os seus personagens do mesmo reino e facção."

L["SlashCommand"] = "Slash Command"
L["SpySlashDescription"] = "Esses botões executam as mesmas funções que aquelas vistas no slash command /spy"
L["Enable"] = "Enable"
L["EnableDescription"] = "Permite que o Spy e mostra a janela principal."
L["Reset"] = "Reset"
L["ResetDescription"] = "Reseta a posição e aparencia da janela principal."
L["Config"] = "Config"
L["ConfigDescription"] = "Abre a janela de configuração do Spy."
L["KOS"] = "KOS"
L["KOSDescription"] = "Adicionar/remover jogadores na Lista Negra."
L["Ignore"] = "Ignore"
L["IgnoreDescription"] = "Adicionar/remover um jogador de/para a lista de ignorados."

-- Lists
L["Nearby"] = "Proximidades"
L["LastHour"] = "Ultima Hora"
L["Ignore"] = "Ignorados"
L["KillOnSight"] = "Lista Negra"

--++ Class descriptions
L["DEATHKNIGHT"] = "Cavaleiro da Morte"
L["DRUID"] = "Druida"
L["HUNTER"] = "Caçador"
L["MAGE"] = "Mago"
L["MONK"] = "Monge"
L["PALADIN"] = "Paladino"
L["PRIEST"] = "Sacerdote"
L["ROGUE"] = "Ladino"
L["SHAMAN"] = "Xamã"
L["WARLOCK"] = "Bruxo"
L["WARRIOR"] = "Guerreiro"
L["UNKNOWN"] = "Desconhecido"

-- Stealth abilities
L["Stealth"] = "Furtividade"
L["Prowl"] = "Espreitar"

-- Channel names
L["LocalDefenseChannelName"] = "DefesaLocal"

--++ Minimap color codes
L["MinimapClassTextDEATHKNIGHT"] = "|cffc41e3a"
L["MinimapClassTextDRUID"] = "|cffff7c0a"
L["MinimapClassTextHUNTER"] = "|cffaad372"
L["MinimapClassTextMAGE"] = "|cff68ccef"
L["MinimapClassTextMONK"] = "|cff00ff96"
L["MinimapClassTextPALADIN"] = "|cfff48cba"
L["MinimapClassTextPRIEST"] = "|cffffffff"
L["MinimapClassTextROGUE"] = "|cfffff468"
L["MinimapClassTextSHAMAN"] = "|cff2359ff"
L["MinimapClassTextWARLOCK"] = "|cff9382c9"
L["MinimapClassTextWARRIOR"] = "|cffc69b6d"
L["MinimapClassTextUNKNOWN"] = "|cff191919"
L["MinimapGuildText"] = "|cffffffff"

-- Output messages
L["AlertStealthTitle"] = "Jogador invisivel detectado!"
L["AlertKOSTitle"] = "Jogador na Lista Negra detectado!"
L["AlertKOSGuildTitle"] = "Guildie de Lista Negra detectado!"
L["AlertTitle_kosaway"] = "Jogador na Lista Negra localizado por "
L["AlertTitle_kosguildaway"] = "Guildie de Lista Negra localizado por "
L["StealthWarning"] = "|cff9933ffJogador invisivel detectado: |cffffffff"
L["KOSWarning"] = "|cffff0000Jogador na Lista Negra detectado: |cffffffff"
L["KOSGuildWarning"] = "|cffff0000Guildie de Lista Negra detectado: |cffffffff"
L["SpySignatureColored"] = "|cff9933ff[Spy] "
L["PlayerDetectedColored"] = "Jogador detectado: |cffffffff"
L["PlayersDetectedColored"] = "Jogadores detectados: |cffffffff"
L["KillOnSightDetectedColored"] = "Jogador na Lista Negra detectado: |cffffffff"
L["PlayerAddedToIgnoreColored"] = "Jogador adicionado à lista de Ignorados: |cffffffff"
L["PlayerRemovedFromIgnoreColored"] = "Jogador removido da lista de Ignorados: |cffffffff"
L["PlayerAddedToKOSColored"] = "Jogador adicionado à Lista Negra: |cffffffff"
L["PlayerRemovedFromKOSColored"] = "Jogador removido da Lista Negra: |cffffffff"
L["PlayerDetected"] = "[Spy] Jogador Detectado: "
L["KillOnSightDetected"] = "[Spy] Jogador na Lista Negra detectado: "
L["Level"] = "Level"
L["LastSeen"] = "Visto há"
L["LessThanOneMinuteAgo"] = "menos de um minuto"
L["MinutesAgo"] = "alguns minutos atrás"
L["HoursAgo"] = "hóras atrás"
L["DaysAgo"] = "dias atrás"
L["Close"] = "Fechar"
L["CloseDescription"] = "|cffffffffEsconde a janela do Spy. Por defeito ela irá ser mostrada novamante quando um jogador inimigo for detectado."
L["Left/Right"] = "Direita/Esquerda"
L["Left/RightDescription"] = "|cffffffffNavega entre as listas de Proximidades, Ultima Hora, Ignorados e Lista Negra."
L["Clear"] = "Limpar"
L["ClearDescription"] = "|cffffffffLimpa a lista de inimigos detectados. Ctrl e click Ativa/Desativa o Spy."
L["NearbyCount"] = "Contador de Inimigos"
L["NearbyCountDescription"] = "|cffffffffMostra no chat o contatdor de inimigos nas proximidades."
L["AddToIgnoreList"] = "Adicionar à lista de Ignorados"
L["AddToKOSList"] = "Adicionar à Lista Negra"
L["RemoveFromIgnoreList"] = "Remover da lista de Ignorados"
L["RemoveFromKOSList"] = "Remover da Lista Negra"
L["AnnounceDropDownMenu"] = "Anunciar"
L["KOSReasonDropDownMenu"] = "Determinar motivo de estar na Lista Negra"
L["PartyDropDownMenu"] = "Grupo"
L["RaidDropDownMenu"] = "Raide"
L["GuildDropDownMenu"] = "Guilda"
L["LocalDefenseDropDownMenu"] = "Defesa Local"
L["Player"] = " (Jogador)"
L["KOSReason"] = "Lista Negra"
L["KOSReasonIndent"] = "    "
L["KOSReasonOther"] = "Digite seu próprio motivo..."
L["KOSReasonClear"] = "Limpar"
L["StatsWins"] = "|cff40ff00Vitórias: "
L["StatsSeparator"] = "  "
L["StatsLoses"] = "|cff0070ddDerrotas: "
L["Located"] = "localizado:"
L["Yards"] = "jardas"

--Spy_KOSReasonListLength = 13
Spy_KOSReasonListLength = 6
Spy_KOSReasonList = {
	[1] = {
		["title"] = "Iniciou combate";
		["content"] = {
--			"Me emboscou",
--			"Ataca sempre que me vê",
			"Me atacou sem motivos",
			"Me atacou no recrutador", --++
			"Me atacou enquanto eu lutava com NPCs",
			"Me atacou enquanto eu entrava/saía de uma masmorra",
			"Me atacou quando eu estava LDT",
--			"Me atacou enquanto eu estava em uma luta de mascotes", --++
			"Me atacou enquanto eu estava montado/voando",
			"Me atacou enquanto eu tinha pouca vida/mana",
--			"Me massacrou junto de vários inimigos",
--			"Só ataca em bando",
--			"Ousou me desafiar",
		};
	},
	[2] = {
		["title"] = "Estilo de Combate";
		["content"] = {
			"Me emboscou",
			"Ataca sempre que me vê",
			"Me matou com um personagem de nível superior", 
			"Me massacrou junto de vários inimigos",
			"Só ataca em bando",
			"Sempre pede ajuda",
--			"Me empurrou de um penhasco",
--			"Usa truques de egenharia",
			"Usa muito controle de multidão",
--			"Usa a mesma habilidade várias vezes",
--			"Me obrigou a tomar dano do cenário",
--			"Me matou e fugiu dos meus amigos",
--			"Fugiu e depois me emboscou",
--			"Sempre tenta fugir",
--			"Usa itens e skills pra fugir",
--			"Procura atacar de perto",
--			"Procura kittar durante o combate",
--			"Aguenta muito dano",
--			"Cura muito",
--			"Tem o DPS muito alto",
		};
	},
--	[3] = {
--		["title"] = "Comportamento Geral";
--		["content"] = {
--			"Chato",
--			"Rude",
--			"Covarde",
--			"Arrogante",
--			"Excesso de confiança",
--			"Desleal",
--			"Usa emotes demais",
--			"Stalkeia eu/meus amigos",
--			"Se faz de bonzinho",
--			"Usou o emote 'diz claramente: NÃO'",
--			"Deu tchauzinho quando eu estava morrendo",
--			"Tentou me acalmar acenando",
--			"Fez coisas desrespeitosas com o meu cadáver",
--			"Riu de mim",
--			"Cuspiu em mim",
--		};
--	},
	[3] = {
		["title"] = "Campando";
		["content"] = {
			"Me campou",
			"Campou meu alt",
			"Campou low levels",
			"Campou ficando invisivel",
			"Campou membros da guilda",
			"Campou NPCs/Objetivos",
			"Campou Cidade/Local",
--			"Veio ajudar a me campar",
--			"Me infernizou enquanto eu upava",
--			"Me forçou a sair do jogo",
--			"Não enfrenta meu main",
		};
	},
	[4] = {
		["title"] = "Quests";
		["content"] = {
			"Me atacou enquanto eu fazia quests",
			"Me atacou depois que eu ajudei ele com uma quest",
			"Interferiu com os objetivos da quest",
			"Iniciou uma quest que eu queria fazer",
			"Matou NPCs da minha facção",
			"Matou um NPC de quest",
		};
	},
	[5] = {
		["title"] = "Ladrão de recursos";
		["content"] = {
			"Colheu erva que eu queria",
			"Minerou minério que eu queria",
			"Pegou recursos que eu queria",
--			"Extraiu gás de uma nuvem que eu queria",
			"Me matou e roubou meu alvo/raro NPC",
			"Esfolou mobs que eu matei",
			"Resgatou os mobs que eu matei",
			"Pescou na minha lagoa",
		};
	},
--[[	[7] = {
		["title"] = "Campos de Batalha";
		["content"] = {
			"Sempre saqueia corpos",
			"Corre pakas com a bandeira",
			"Da suporte à bases ou bandeiras",
			"Rouba bases ou bandeiras",
			"Me matou e roubou a bandeira",
			"Interfe com os objetivos do CB",
			"Pegou o power-up que eu queria",
			"Forçou o tank a perder aggro",
			"Causou um wipe",
			"Destrói as Máquinas de Cerco",
			"Joga bombas",
			"Disarma bombas",
			"Usa fear no bomber",
		};
	},
	[8] = {
		["title"] = "Vida real";
		["content"] = {
			"Amigo na vida real",
			"Inimigo na vida real",
			"Espalha rumores sobre mim",
			"Reclama nos foruns",
			"Espiona pela facção inimiga",
			"Traidor da minha facção",
			"Renegado ou indeciso",
			"Nub pretencioso",
			"Metidinho a sabe-tudo",
			"Maria vai com as outras",
			"Sem facção, fala merda de ambas", 
		};
	},
	[9] = {
		["title"] = "Dificuldade";
		["content"] = {
			"Impossivel de matar",
			"Me mata na maioria das vezes",
			"Pau-a-pau comigo",
			"Morre na maioria das vezes",
			"Muito divertido de matar",
			"Honra de graça",
		};
	},
	[10] = {
		["title"] = "Raça";
		["content"] = {
			"Odeio a raça dele",
			"Elfos Sangrentos são narcisistas",
			"Draeneis são lulas viscosas alienigenas",
			"Anões são suportes de porta peludos",
			"Goblins venderiam a própria mãe por um lucrinho",
			"Gnomos pertecem aos jardins",
			"Humanos são justos e intrometidos",
			"Elfos Noturnos abraçam muitas arvores",
			"Orcs são bárbaros ignorantes",
			"Pandarens são muito zen e lerdos", --++
			"Taurens deviam estar no meu hamburger",
			"Trolls não manjam do paranauê",
			"Mortos-vivos são aberrações não naturais",
			"Worgens tem muitas pulgas",
		};
	},
	[11] = {
		["title"] = "Classe";
		["content"] = {
			"Odeio a classe dele",
			"Cavaleiros da Morte são muito apelões",
			"Druidas são animais sujos",
			"Caçadores são fase bonus",
			"Magos são intelectuais iludidos",
			"Monges tem o ki fraco", --++
			"Paladinos são tolos hipócritas",
			"Sacerdotes são padres piedosos",
			"Ladinos são sem honra",
			"Xamãs falam com animais imaginários e batem tambor",
			"Bruxos são malucos necromânticos",
			"Guerreiros tem problema de raiva",
		};
	},
	[12] = {
		["title"] = "Nome";
		["content"] = {
			"Tinha o nome ridículo",
			"Nome pretencioso",
			"Nome parecido com o meu",
			"Variante ou plágio de qualquer coisa",
			"Nome tinha caracteres estranhos",
			"Nome da guilda era todo em letra maiúscula",
			"Noma da guilda era ridículo",
			"Nome da guilda afirma que odeiam minha facção",
		};
	},]]--
--	[13] = {
	[6] = {
		["title"] = "Outros";
		["content"] = {
--			"Karma",
--			"Tá vermelho é pra matar",
--			"Porque eu quero",
--			"É ruim no PVP",
			"Ta com o PVP ativado",
--			"Não quer fazer PVP",
--			"Gasta o tempo dele e o meu",
--			"É noob",
--			"Eu realmente odeio esse jogador",
--			"Não upa rápido o suficiente",
			"Me empurrou de um penhasco",
			"Usa truques de egenharia",
			"Sempre consegue escapar",
			"Usa itens e skills pra fugir",
 			"Burla as mecanicas do jogo",
--			"Suposto Hacker",
--			"Farmer",
--			"Outro...",
			"Digite seu próprio motivo...",
		};
	},
}

StaticPopupDialogs["Spy_SetKOSReasonOther"] = {
	preferredIndex=STATICPOPUPS_NUMDIALOGS,  -- http://forums.wowace.com/showthread.php?p=320956
	text = "Motivos para colocar %s na Lista Negra:",
	button1 = "Pronto",
	button2 = "Cancelar",
	timeout = 20,
	hasEditBox = 1,
	whileDead = 1,
	hideOnEscape = 1,
	OnShow = function(self)
		self.editBox:SetText("");
	end,
    	OnAccept = function(self)
		local reason = self.editBox:GetText()
--		Spy:SetKOSReason(self.playerName, "Other...", reason)		
		Spy:SetKOSReason(self.playerName, "Digite seu próprio motivo...", reason)
	end,
};

Spy_AbilityList = {

-----------------------------------------------------------
-- Allows an estimation of the race, class and level of a
-- player to be determined from what abilities are observed
-- in the combat log.
-----------------------------------------------------------

--++ Racials ++
	["Forma de Pedra"] = 		{ race = "Dwarf", level = 1, },
	["Artista da Fuga"] = 		{ race = "Gnome", level = 1, },
	["Cada Um por Si"] = 		{ race = "Human", level = 1, },
	["Fusão Sombria	"] = 		{ race = "Night Elf", level = 1, },
	["Dádiva dos Naarus"] = 	{ race = "Draenei", level = 1, },
	["Velonero"] = 				{ race = "Worgen", level = 1, },
	["Two Forms"] = 			{ race = "Worgen", level = 1, },
	["Correndo Livre"] = 		{ race = "Worgen", level = 1, },
	["Fúria Sangrenta"] = 		{ race = "Orc", level = 1, },
	["Pisada de Guerra"] = 		{ race = "Tauren", level = 1, },
	["Berserk"] = 				{ race = "Troll", level = 1, },
	["Determinação dos Renegados"] = { race = "Undead", level = 1, },
	["Canibalizar"] = 			{ race = "Undead", level = 1, },
	["Torrente Arcana"] = 		{ race = "Blood Elf", level = 1, },
	["Salto do Foguete"] = 		{ race = "Goblin", level = 1, },
	["Barragem de Foguetes"] = 	{ race = "Goblin", level = 1, },
	["Hobgoblin de Carga"] = 	{ race = "Goblin", level = 1, },
	["Palma Trêmula"] =			{ race = "Pandaren", level = 1, },

--++ Death Knight Abilities ++
	["Peste Sanguínea"] = 		{ class = "DEATHKNIGHT", level = 55, }, 
	["Golpe Sangrento"] = 		{ class = "DEATHKNIGHT", level = 55, }, 
	["Espiral da Morte"] = 		{ class = "DEATHKNIGHT", level = 55, }, 
	["Portão da Morte"] = 		{ class = "DEATHKNIGHT", level = 55, },	
	["Garra da Morte"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Febre do Gelo"] = 		{ class = "DEATHKNIGHT", level = 55, },		
	["Presença Gélida"] = 		{ class = "DEATHKNIGHT", level = 55, },  
	["Toque Gélido"] = 			{ class = "DEATHKNIGHT", level = 55, },  
	["Golpe da Peste"] = 		{ class = "DEATHKNIGHT", level = 55, },  
 	["Forjar Runas"] = 			{ class = "DEATHKNIGHT", level = 55, },  
--	["Especialização em Armadura de Placas"] = 	{ class = "DEATHKNIGHT", level = 55, },  
 	["Sangue Fervente"] = 		{ class = "DEATHKNIGHT", level = 56, }, 
	["Golpe da Morte"] = 		{ class = "DEATHKNIGHT", level = 56, },  
	["Pestilência"] = 			{ class = "DEATHKNIGHT", level = 56, },  
	["Reviver Morto"] = 		{ class = "DEATHKNIGHT", level = 56, },
 	["Presença Sanguínea"] = 	{ class = "DEATHKNIGHT", level = 57, }, 
	["Congelar Mente"] = 		{ class = "DEATHKNIGHT", level = 57, },  
	["Correntes de Gelo"] = 	{ class = "DEATHKNIGHT", level = 58, },  
	["Estrangular"] = 			{ class = "DEATHKNIGHT", level = 58, },  
	["Morte e Decomposição"] = 	{ class = "DEATHKNIGHT", level = 60, },  
	["Sobre um Cavalo Pálido"] = { class = "DEATHKNIGHT", level = 61, },  
	["Fortitude Congélida"] = 	{ class = "DEATHKNIGHT", level = 62, }, 
	["Presença Profana"] = 		{ class = "DEATHKNIGHT", level = 64, }, 
	["Berrante do Inverno"] = 	{ class = "DEATHKNIGHT", level = 65, },  
	["Caminho de Gelo"] = 		{ class = "DEATHKNIGHT", level = 66, },  
	["Carapaça Antimagia"] = 	{ class = "DEATHKNIGHT", level = 69, }, 
	["Controlar Morto-vivo"] = 	{ class = "DEATHKNIGHT", level = 69, },  
 	["Reviver Aliado"] = 		{ class = "DEATHKNIGHT", level = 72, },  
	["Energizar Arma Rúnica"] = { class = "DEATHKNIGHT", level = 76, }, 
	["Exército dos Mortos"] = 	{ class = "DEATHKNIGHT", level = 80, },	
	["Eclosão"] = 				{ class = "DEATHKNIGHT", level = 81, },  
	["Golpe Necrótico"] = 		{ class = "DEATHKNIGHT", level = 83, },  
	["Simulacro Negro"] = 		{ class = "DEATHKNIGHT", level = 85, },  
	["Runa da Brasa Glacial"] = { class = "DEATHKNIGHT", level = 55, },
	["Runa do Cruzado Caído"] = { class = "DEATHKNIGHT", level = 70, },	
	["Runa do Lich Maldito"] = 	{ class = "DEATHKNIGHT", level = 60, },
	["Runa da Gelâmina"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Runa Quebra-feitiço"] = 	{ class = "DEATHKNIGHT", level = 57, },
	["Runa Estilhaça-feitiço"] = { class = "DEATHKNIGHT", level = 57, },
	["Runa Quebra-espadas"] = 	{ class = "DEATHKNIGHT", level = 63, },
	["Runa Estilhaça-espadas"] = { class = "DEATHKNIGHT", level = 63, },
	["Runa da Carapaça Nerubiana"] = { class = "DEATHKNIGHT", level = 72, },
	["Runa da Gárgula Litopele"] = { class = "DEATHKNIGHT", level = 72, },
    --++ Glyph Abilities ++
	["Explosão de Cadáver"] = 	{ class = "DEATHKNIGHT", level = 25, },	
--++ Death Knight Specialization ++
	--++ Blood/Frost/Unholy ++
	["Ceifador de Almas"] = 	{ class = "DEATHKNIGHT", level = 87, },
	--++ Frost/Unholy ++
	["Aura Profana"] = 			{ class = "DEATHKNIGHT", level = 60, },
	--++ Blood ++
	["Ritos de Sangue"]  = 		{ class = "DEATHKNIGHT", level = 55, },	  
	["Vingança"]  = 			{ class = "DEATHKNIGHT", level = 55, },	  
	["Veterano da Terceira Guerra"] = { class = "DEATHKNIGHT", level = 55, },	  
	["Comando Sombrio"]  = 		{ class = "DEATHKNIGHT", level = 58, },	  
	["Golpe no Coração"]  = 	{ class = "DEATHKNIGHT", level = 60, },	  
	["Cheiro de Sangue"] = 		{ class = "DEATHKNIGHT", level = 62, },	  
	["Presença Sanguínea Aprimorada"] = { class = "DEATHKNIGHT", level = 64, },	  
	["Transfusão Rúnica"] = 	{ class = "DEATHKNIGHT", level = 64, },	  
	["Golpe Rúnico"] = 			{ class = "DEATHKNIGHT", level = 65, },	  
	["Parasita Sanguíneo"] = 	{ class = "DEATHKNIGHT", level = 66, },	  
	["Febre Escarlate"] = 		{ class = "DEATHKNIGHT", level = 68, },	  
	["Vontade da Necrópole"] = 	{ class = "DEATHKNIGHT", level = 70, },	  
	["Fortitude Sanguínea"] = 	{ class = "DEATHKNIGHT", level = 72, },	  
	["Arma Rúnica Dançante"] = 	{ class = "DEATHKNIGHT", level = 74, },
--	["Ripostar"] = 				{ class = "DEATHKNIGHT", level = 76, }, --Added in Patch 5.4 but not activated since Warriors also have this ability	
	["Sangue Vampírico"] = 		{ class = "DEATHKNIGHT", level = 76, },	  
	["Escudo Ósseo"] = 			{ class = "DEATHKNIGHT", level = 78, },
	["Escudo de Sangue"] = 		{ class = "DEATHKNIGHT", level = 80, },
	["Flagelo Vermelho"] = 		{ class = "DEATHKNIGHT", level = 84, },	
	--++ Frost ++ 
 	["Sangue do Norte"] =  		{ class = "DEATHKNIGHT", level = 55, },	  
	["Golpe Gélido"] = 			{ class = "DEATHKNIGHT", level = 55, },	  
	["Impacto Uivante"] = 		{ class = "DEATHKNIGHT", level = 55, },	  
	["Garras Gélidas"] = 		{ class = "DEATHKNIGHT", level = 55, },	  
	["Obliterar"] = 			{ class = "DEATHKNIGHT", level = 58, },	  
	["Máquina Assassina"] = 	{ class = "DEATHKNIGHT", level = 63, },	  
	["Presença Gélida Aprimorada"] = { class = "DEATHKNIGHT", level = 65, },	  
	["Ossos Frágeis"] = 		{ class = "DEATHKNIGHT", level = 66, },	  
	["Pilar de Gelo"] = 		{ class = "DEATHKNIGHT", level = 68, },	  
	["Geada"] = 				{ class = "DEATHKNIGHT", level = 70, },	  
	["Poder dos Ermos Gélidos"] = { class = "DEATHKNIGHT", level = 74, },	  
	["Ameaça de Thassarian"] = 	{ class = "DEATHKNIGHT", level = 74, },	  
	["Coração Congelado"] = 	{ class = "DEATHKNIGHT", level = 80, },	--conferir depois (have to check in game later)
	--++ Unholy ++  
	["Mestre dos Carniçais"] = 	{ class = "DEATHKNIGHT", level = 55, },	  
	["Ceifador"] = 				{ class = "DEATHKNIGHT", level = 55, },	  
	["Poder Profano"] = 		{ class = "DEATHKNIGHT", level = 55, },	  
	["Golpe do Flagelo"] = 		{ class = "DEATHKNIGHT", level = 58, },	  
	["Infusão Sombria"] = 		{ class = "DEATHKNIGHT", level = 60, },	  
	["Ataque Supurante"] = 		{ class = "DEATHKNIGHT", level = 62, },	  
	["Ruína Súbita"] = 			{ class = "DEATHKNIGHT", level = 64, },	  
	["Frenesi Profano"] = 		{ class = "DEATHKNIGHT", level = 66, },	  
	["Pestífero de Ébano"] = 	{ class = "DEATHKNIGHT", level = 68, },	  
	["Transformação Negra"] = 	{ class = "DEATHKNIGHT", level = 70, },	  
	["Evocar Gárgula"] = 		{ class = "DEATHKNIGHT", level = 74, },	  
	["Presença Profana Aprimorada"] = { class = "DEATHKNIGHT", level = 75, },	  
	["Terroraço"] = 			{ class = "DEATHKNIGHT", level = 80, },	 --conferir depois (have to check in game later)
--++ Death Knight Talents ++
	["Sangue Enervante"] = 		{ class = "DEATHKNIGHT", level = 56, },	
	["Sugar Peste"] = 			{ class = "DEATHKNIGHT", level = 56, },	
	["Devastação Profana"] = 	{ class = "DEATHKNIGHT", level = 56, },	  
	["Forma Decadente"] = 		{ class = "DEATHKNIGHT", level = 57, },	
	["Zona Antimagia"] = 		{ class = "DEATHKNIGHT", level = 57, },	
	["Purgatório"] = 			{ class = "DEATHKNIGHT", level = 57, },	 
	["Avanço da Morte"] = 		{ class = "DEATHKNIGHT", level = 58, },	
	["Perniose"] = 				{ class = "DEATHKNIGHT", level = 58, },	
	["Asfixiar"] = 				{ class = "DEATHKNIGHT", level = 58, },	  
	["Pacto da Morte"] = 		{ class = "DEATHKNIGHT", level = 60, },	
	["Sifão da Morte"] =	 	{ class = "DEATHKNIGHT", level = 60, },	
	["Conversão"] = 			{ class = "DEATHKNIGHT", level = 60, },	 
	["Transfusão de Sangue"] = 	{ class = "DEATHKNIGHT", level = 75, },	
	["Potencialização Rúnica"] = { class = "DEATHKNIGHT", level = 75, },	
	["Corrupção Rúnica"] = 		{ class = "DEATHKNIGHT", level = 75, },	 
	["Garra de Sanguinávido"] = { class = "DEATHKNIGHT", level = 90, },	
	["Inverno Impiedoso"] = 	{ class = "DEATHKNIGHT", level = 90, },	
	["Solo Profanado"] = 		{ class = "DEATHKNIGHT", level = 90, },	 

--++ Druid Abilities ++
	["Ira"] = 					{ class = "DRUID", level = 1, },  
	["Fogo Lunar"] = 			{ class = "DRUID", level = 3, },
	["Rejuvenescer"] = 			{ class = "DRUID", level = 4, },
	["Forma de Felino"] = 		{ class = "DRUID", level = 6, },
	["Graça Felina"] = 			{ class = "DRUID", level = 6, },
	["Destroçar"] = 			{ class = "DRUID", level = 6, },
	["Espreitar"] = 			{ class = "DRUID", level = 6, },
	["Estraçalhar"] = 			{ class = "DRUID", level = 6, },
	["Mordida Feroz"] = 		{ class = "DRUID", level = 6, },
	["Forma de Urso"] = 		{ class = "DRUID", level = 8, },
	["Rosnar"] = 				{ class = "DRUID", level = 8, },
	["Malho"] = 				{ class = "DRUID", level = 8, },
	["Abstração"] =	 			{ class = "DRUID", level = 10, }, 
	["Raízes Enredantes"] = 	{ class = "DRUID", level = 10, },
	["Reviver"] = 				{ class = "DRUID", level = 12, },
	["Teleporte: Clareira da Lua"] = { class = "DRUID", level = 14, },
	["Forma de Viagem"] = 		{ class = "DRUID", level = 16, },
	["Forma Aquática"] = 		{ class = "DRUID", level = 18, },
	["Assolar!"] = 				{ class = "DRUID", level = 22, }, 
	["Patada"] = 				{ class = "DRUID", level = 22, },
	["Arremetida"] = 			{ class = "DRUID", level = 24, },
	["Toque de Cura"] = 		{ class = "DRUID", level = 26, },
	["Fogo Feérico"] = 			{ class = "DRUID", level = 28, },
	["Surra"] = 		 		{ class = "DRUID", level = 28, }, 
	["Fúria Primeva"] = 		{ class = "DRUID", level = 30, },
	["Pulo do Gato"] = 			{ class = "DRUID", level = 32, },
	["Rastrear Humanoides"] = 	{ class = "DRUID", level = 36, },
	["Lacerar"] = 				{ class = "DRUID", level = 38, },
	["Tempestade Astral"] = 	{ class = "DRUID", level = 42, }, 
	["Furacão"] = 				{ class = "DRUID", level = 42, },
	["Pele de Árvore"] = 		{ class = "DRUID", level = 44, },
--	["Especialização em Armadura de Couro"] = { class = "DRUID", level = 50, },  
	["Enredamento"] = 			{ class = "DRUID", level = 52, },
	["Avivar"] = 				{ class = "DRUID", level = 54, },
	["Renascimento"] = 			{ class = "DRUID", level = 56, },
	["Forma Voadora"] = 		{ class = "DRUID", level = 58, },
	["Confortar"] = 			{ class = "DRUID", level = 60, },
	["Marca do Indomado"] = 	{ class = "DRUID", level = 62, },
	["Hibernar"] = 				{ class = "DRUID", level = 66, },
	["Regeneração Frenética"] = { class = "DRUID", level = 68, },
	["Forma Voadora Veloz"] = 	{ class = "DRUID", level = 70, },
	["Poder de Ursoc"] = 		{ class = "DRUID", level = 72, },
	["Tranquilidade"] = 		{ class = "DRUID", level = 74, },
	["Ciclone"] = 				{ class = "DRUID", level = 78, },
	["Mutilar"] = 				{ class = "DRUID", level = 82, },
	["Estouro da Manada"] = 	{ class = "DRUID", level = 84, },
	["Simbiose"] = 				{ class = "DRUID", level = 87, }, 
	--++ Glyph Abilities ++
	["Encantar Criatura da Floresta"] = { class = "DRUID", level = 25, },
	["Forma de Arvoroso"] = 	{ class = "DRUID", level = 25, },	
--++ Druid Specialization ++
	--++ Balance/Restoration ++
	["Percepção Natural"] = 	{ class = "DRUID", level = 10, }, 
	["Rapidez da Natureza"] = 	{ class = "DRUID", level = 30, }, --Added in Patch 5.4
	["Instinto Assassino"] = 	{ class = "DRUID", level = 34, },
	["Cogumelo Selvagem"] = 	{ class = "DRUID", level = 84, },
	--++ Balance/Feral/Guardian ++
	["Remover Corrupção"] = 	{ class = "DRUID", level = 22, },
	--++ Feral/Guardian ++
	["Rasgar"] = 				{ class = "DRUID", level = 20, },
	["Instinto Estimulante"] = 	{ class = "DRUID", level = 34, },
	["Feridas Infectadas"] = 	{ class = "DRUID", level = 40, },
	["Líder do Bando"] =		{ class = "DRUID", level = 46, },
	["Berserk"] = 				{ class = "DRUID", level = 48, },
	["Assolar"] = 				{ class = "DRUID", level = 54, },
	["Instintos de Sobrevivência"] = { class = "DRUID", level = 56, },
	["Esmagar Crânio"] = 		{ class = "DRUID", level = 64, },
	--++ Feral/Resoration ++
	["Presságio de Clareza"] = 	{ class = "DRUID", level = 38, },
	--++ Balance ++
	["Equilíbrio de Poder"] = 	{ class = "DRUID", level = 10, }, 	
--	["Eclipse"] = 				{ class = "DRUID", level = 10, }, 
	["Fogo Estelar"] = 			{ class = "DRUID", level = 10, },
	["Surto Estelar"] = 		{ class = "DRUID", level = 12, },
--	["Concentração Celestial"] = { class = "DRUID", level = 14, },
	["Forma de Luniscante"] = 	{ class = "DRUID", level = 16, },
	["Fogo Solar"] = 			{ class = "DRUID", level = 18, },
	["Comunhão Astral"] = 		{ class = "DRUID", level = 20, },
	["Estrelas Cadentes"] = 	{ class = "DRUID", level = 26, },
	["Raio Solar"] = 			{ class = "DRUID", level = 28, },
	["Euforia"] = 				{ class = "DRUID", level = 38, },
	["Frenesi Corujante"] = 	{ class = "DRUID", level = 48, },
	["Alinhamento Celestial"] = { class = "DRUID", level = 68, },
	["Chuva Estelar"] = 		{ class = "DRUID", level = 76, },
	["Eclipse Total"] = 		{ class = "DRUID", level = 80, }, 
	["Chuva Lunar"] = 			{ class = "DRUID", level = 82, },
	["Cogumelo Selvagem: Detonar"] = { class = "DRUID", level = 84, },
	--++ Feral ++
	["Fúria do Tigre"] = 		{ class = "DRUID", level = 10, },
--	["Instinto Feral"] = 		{ class = "DRUID", level = 14, },
	["Despedaçar"] = 			{ class = "DRUID", level = 16, },
	["Rugido Selvagem"] = 		{ class = "DRUID", level = 18, },
	["Velocidade Predatória"] = { class = "DRUID", level = 26, },
	["Garras de Navalha"] = 	{ class = "DRUID", level = 80, },
	--++ Guardian ++ 
	["Defesa Selvagem"] = 		{ class = "DRUID", level = 10, },
	["Vingança"] = 				{ class = "DRUID", level = 10, },
	["Pelego Grosso"] = 		{ class = "DRUID", level = 14, },
	["Abraço de Urso"] = 		{ class = "DRUID", level = 18, },
	["Unhas e Dentes"] = 		{ class = "DRUID", level = 32, }, 
	["Enfurecer"] = 			{ class = "DRUID", level = 76, },
	["Guardião da Natureza"] = 	{ class = "DRUID", level = 80, },
	--++ Restoration ++  
	["Naturalista"] = 			{ class = "DRUID", level = 10, },
	["Recomposição Rápida"] = 	{ class = "DRUID", level = 10, },
	["Nutrir"] = 				{ class = "DRUID", level = 12, },
	["Meditação"] = 			{ class = "DRUID", level = 14, },
	["Concentração da Natureza"] = { class = "DRUID", level = 16, },
	["Recrescimento"] = 		{ class = "DRUID", level = 18, },
	["Cura da Natureza"] = 		{ class = "DRUID", level = 22, },
	["Semente Viva"] = 			{ class = "DRUID", level = 28, },
	["Brotar da Vida"] = 		{ class = "DRUID", level = 36, },
	["Rejuvenescimento Veloz"] = { class = "DRUID", level = 46, },
	["Cascaferro"] = 			{ class = "DRUID", level = 64, },
	["Crescimento Silvestre"] = { class = "DRUID", level = 76, },
	["Harmonia"] = 				{ class = "DRUID", level = 80, },
	["Dádiva de Malfurion"] = 	{ class = "DRUID", level = 82, },
	["Cogumelo Selvagem: Florir"] = { class = "DRUID", level = 84, },
	["Gênese"] = 				{ class = "DRUID", level = 88, }, --Added in Patch 5.4
	--++ Druid Talents ++
	["Rapidez Felina"] = 		{ class = "DRUID", level = 15, },
	["Fera Deslocadora"] = 		{ class = "DRUID", level = 15, },
	["Investida Selvagem"] = 	{ class = "DRUID", level = 15, }, 
--	["Nature's Swiftness"] = 	{ class = "DRUID", level = 30, }, --Removed in Patch 5.4
	["Dádiva de Ysera"] = 		{ class = "DRUID", level = 30, }, --Added in Patch 5.4
	["Renovação"] = 			{ class = "DRUID", level = 30, },
	["Proteção Cenariana"] = 	{ class = "DRUID", level = 30, }, 
	["Enxame Feérico"] = 		{ class = "DRUID", level = 45, },
	["Embaraço em Massa"] = 	{ class = "DRUID", level = 45, },
	["Tufão"] = 				{ class = "DRUID", level = 45, }, 
	["Alma da Floresta"] = 		{ class = "DRUID", level = 60, },
	["Encarnação"] = 			{ class = "DRUID", level = 60, },
	["Força da Natureza"] = 	{ class = "DRUID", level = 60, },
	["Rugido Desnorteador"] = 	{ class = "DRUID", level = 75, },
	["Vórtice de Ursol"] = 		{ class = "DRUID", level = 75, },
	["Trombada Poderosa"] = 	{ class = "DRUID", level = 75, }, 
	["Coração das Selvas"] = 	{ class = "DRUID", level = 90, },
	["Sonho de Cenarius"] = 	{ class = "DRUID", level = 90, },
	["Vigília da Natureza"] = 	{ class = "DRUID", level = 90, }, 

--++ Hunter Abilities ++
	["Tiro Arcano"] = 			{ class = "HUNTER", level = 1, },
	["Tiro Automático"] = 		{ class = "HUNTER", level = 1, },
	["Chamar Ajudante 1"] = 	{ class = "HUNTER", level = 1, },
	["Reviver Ajudante"] = 		{ class = "HUNTER", level = 1, },
	["Tiro Firme"] = 			{ class = "HUNTER", level = 3, },
	["Rastreamento"] = 			{ class = "HUNTER", level = 4, },
	["Tiro de Concussão"] = 	{ class = "HUNTER", level = 8, },
	["Tradição das Feras"] = 	{ class = "HUNTER", level = 10, },
	["Dispensar Ajudante"] = 	{ class = "HUNTER", level = 10, },
	["Picada de Serpente"] = 	{ class = "HUNTER", level = 10, },
	["Domar Fera"] = 			{ class = "HUNTER", level = 10, },
	["Controlar Ajudante"] = 	{ class = "HUNTER", level = 10, },
	["Alimentar Ajudante"] = 	{ class = "HUNTER", level = 11, },
	["Aspecto do Falcão"] = 	{ class = "HUNTER", level = 12, },
	["Desvencilhar"] = 			{ class = "HUNTER", level = 14, },
	["Marca do Caçador"] = 		{ class = "HUNTER", level = 14, },
	["Tiro de Dispersão"] = 	{ class = "HUNTER", level = 15, },
	["Olho de Águia"] = 		{ class = "HUNTER", level = 16, },
	["Curar Ajudante"] = 		{ class = "HUNTER", level = 16, },
	["Chamar Ajudante 2"] = 	{ class = "HUNTER", level = 18, },
	["Tiro Retaliatório"] = 	{ class = "HUNTER", level = 22, }, --Added in Patch 5.4
	["Aspecto do Guepardo"] = 	{ class = "HUNTER", level = 24, },
	["Tiro Múltiplo"] = 		{ class = "HUNTER", level = 24, },
	["Armadilha Congelante"] = 	{ class = "HUNTER", level = 28, },
	["Fingir de Morto"] = 		{ class = "HUNTER", level = 32, },
	["Tiro Mortal"] = 			{ class = "HUNTER", level = 35, },
	["Tiro Tranquilizante"] = 	{ class = "HUNTER", level = 35, },
	["Assustar Fera"] = 		{ class = "HUNTER", level = 36, },
	["Armadilha Explosiva"] = 	{ class = "HUNTER", level = 38, },
	["Sinalizador"] = 			{ class = "HUNTER", level = 38, },
	["Aura de Tiro Certeiro"] = { class = "HUNTER", level = 39, },
	["Peçonha da Viúva"] = 		{ class = "HUNTER", level = 40, },
	["Chamar Ajudante 3"] = 	{ class = "HUNTER", level = 42, },
	["Armadilha de Gelop"] = 	{ class = "HUNTER", level = 46, },
	["Lançador de Armadilhas"] = { class = "HUNTER", level = 48, },
--	["Malha"] = 				{ class = "HUNTER", level = 50, },
	["Tiro Distrativo"] = 		{ class = "HUNTER", level = 52, },
	["Tiro Rápido"] = 			{ class = "HUNTER", level = 54, },
	["Aspecto da Matilha"] = 	{ class = "HUNTER", level = 56, },
--	["Readiness"] = 			{ class = "HUNTER", level = 60, }, --Removed in Patch 5.4
	["Chamar Ajudante 4"] = 	{ class = "HUNTER", level = 62, },
	["Armadilha de Cobra"] = 	{ class = "HUNTER", level = 66, },
	["Chamado do Mestre"] = 	{ class = "HUNTER", level = 74, },
	["Redirecionar"] = 			{ class = "HUNTER", level = 76, },
	["Coibição"] = 				{ class = "HUNTER", level = 78, },
	["Chamar Ajudante 5"] = 	{ class = "HUNTER", level = 82, },
	["Camuflagem"] = 			{ class = "HUNTER", level = 85, },
	["Sanha"] = 				{ class = "HUNTER", level = 87, }, 
	--++ Glyph Abilities ++
	["Aspecto da Fera"] = 		{ class = "HUNTER", level = 25, }, 
	["Pegar"] = 				{ class = "HUNTER", level = 25, }, 
	["Fogos de Artifício"] = 	{ class = "HUNTER", level = 25, }, 
--++ Hunter Specialization ++
	--++ Beast Mastery/Survival ++
	["Disparo da Naja"] = 		{ class = "HUNTER", level = 81, },
	--++ Beast Mastery ++
	["Comando para Matar"] = 	{ class = "HUNTER", level = 10, },
	["Mirar na Jugular"] = 		{ class = "HUNTER", level = 20, },
	["Cutilada da Fera"] = 		{ class = "HUNTER", level = 24, },
	["Frenesi"] = 				{ class = "HUNTER", level = 30, },
	["Fogo Concentrado"] = 		{ class = "HUNTER", level = 32, },
	["Ira Bestial"] = 			{ class = "HUNTER", level = 40, },
	["Golpes de Naja"] = 		{ class = "HUNTER", level = 43, },
	["A Fera Interior"] = 		{ class = "HUNTER", level = 50, },
	["Espíritos Afins"] = 		{ class = "HUNTER", level = 58, },
	["Envigorar"] = 			{ class = "HUNTER", level = 63, },
	["Feras Exóticas"] = 		{ class = "HUNTER", level = 69, },
	["Mestre das Feras"] = 		{ class = "HUNTER", level = 80, },
	--++ Marksmanship ++ 
	["Tiro Certo"] = 			{ class = "HUNTER", level = 10, },
	["Mira Cuidadosa"] = 		{ class = "HUNTER", level = 20, },
	["Disparo Silenciador"] = 	{ class = "HUNTER", level = 30, }, --Added in Patch 5.4
--	["Binding Shot"] = 			{ class = "HUNTER", level = 30, }, --Removed in Patch 5.4
	["Barragem de Concussão"] = { class = "HUNTER", level = 30, },
	["Bombardeio"] = 			{ class = "HUNTER", level = 45, },
	["Recuperação Veloz"] = 	{ class = "HUNTER", level = 54, },
	["Mestre Atirador Perito"] = { class = "HUNTER", level = 58, },
	["Tiro Quimérico"] = 		{ class = "HUNTER", level = 60, },
	["Concentração Firme"] = 	{ class = "HUNTER", level = 63, },
	["Disparos Perfurantes"] = 	{ class = "HUNTER", level = 72, },
	["Aljava Selvagem"] = 		{ class = "HUNTER", level = 80, },
	--++ Survival ++  
	["Tiro Explosivo"] = 		{ class = "HUNTER", level = 10, },
	["Largar o Dedo"] = 		{ class = "HUNTER", level = 43, },
	["Flecha Negra"] = 			{ class = "HUNTER", level = 50, },
	["Cilada"] = 				{ class = "HUNTER", level = 55, },
	["Veneno da Víbora"] = 		{ class = "HUNTER", level = 63, },
	["Proficiência em Armadilhas"] = { class = "HUNTER", level = 64, },
	["Espalhar de Serpente"] = 	{ class = "HUNTER", level = 68, },
	["Picada de Serpente Aprimorada"] = { class = "HUNTER", level = 70, },
	["Essência da Víbora"] = 	{ class = "HUNTER", level = 80, },
--++ Hunter Talents ++
	["O Quanto Antes"] = 		{ class = "HUNTER", level = 15, },
	["Fuga por Pouco"] = 		{ class = "HUNTER", level = 15, },
	["O Tigre e a Quimera"] = 	{ class = "HUNTER", level = 15, }, 
	["Disparo Aprisionador"] = 	{ class = "HUNTER", level = 30, }, --Added in Patch 5.4
--	["Silencing Shot"] = 		{ class = "HUNTER", level = 30, }, --Removed in Patch 5.4
	["Picada de Mantícora"] = 	{ class = "HUNTER", level = 30, },
	["Intimidação"] = 			{ class = "HUNTER", level = 30, }, --++
	["Exaltação"] = 			{ class = "HUNTER", level = 45, },
	["Aspecto da Águia de Ferro"] = { class = "HUNTER", level = 45, },
	["Vínculo Espiritual"] = 	{ class = "HUNTER", level = 45, }, 
	["Fervor"] = 				{ class = "HUNTER", level = 60, },
	["Fera Atroz"] = 			{ class = "HUNTER", level = 60, },
	["Calor da Caçada"] = 		{ class = "HUNTER", level = 60, }, 
	["Bando de Corvos"] = 		{ class = "HUNTER", level = 75, },
	["Ataques Lampejo"] = 		{ class = "HUNTER", level = 75, },
	["Ímpeto do Lince"] = 		{ class = "HUNTER", level = 75, }, 
	["Arremesso de Glaive"] = 	{ class = "HUNTER", level = 90, },
	["Tirambaço"] = 			{ class = "HUNTER", level = 90, },
	["Barragem"] = 				{ class = "HUNTER", level = 90, }, 

--++ Mage Abilities ++
	["Seta de Fogofrio"] = 		{ class = "MAGE", level = 1, },
	["Nova Congelante"] = 		{ class = "MAGE", level = 3, },
	["Impacto de Fogo"] = 		{ class = "MAGE", level = 5, },
	["Lampejo"] = 				{ class = "MAGE", level = 7, },
	["Contrafeitiço"] = 		{ class = "MAGE", level = 8, },
	["Polimorfia"] = 			{ class = "MAGE", level = 14, },
	["Estilhaçar"] = 			{ class = "MAGE", level = 16, },
	["Explosão Arcana"] = 		{ class = "MAGE", level = 18, },
	["Lança de Gelo"] = 		{ class = "MAGE", level = 22, },
	["Bloco de Gelo"] = 		{ class = "MAGE", level = 26, },
	["Cone de Frio"] = 			{ class = "MAGE", level = 28, },
	["Remover Maldição"] = 		{ class = "MAGE", level = 29, },
	["Queda Lenta"] = 			{ class = "MAGE", level = 32, },
	["Armadura Derretida"] = 	{ class = "MAGE", level = 34, },
	["Conjurar Refeição"] = 	{ class = "MAGE", level = 38, },
	["Evocação"] = 				{ class = "MAGE", level = 40, },
	["Golpe Flamejante"] = 		{ class = "MAGE", level = 44, },
	["Conjurar Gema de Mana"] = { class = "MAGE", level = 47, },
	["Imagem Espelhada"] = 		{ class = "MAGE", level = 49, },
	["Feitiçaria"] = 			{ class = "MAGE", level = 50, },
	["Nevasca"] = 				{ class = "MAGE", level = 52, },
	["Armadura Gélida"] = 		{ class = "MAGE", level = 54, },
	["Seta de Gelo"] = 			{ class = "MAGE", level = 54, },	--++
	["Invisibilidade"] = 		{ class = "MAGE", level = 56, },
	["Inteligência Arcana"] = 	{ class = "MAGE", level = 58, },
	["Roubar Feitiço"] = 		{ class = "MAGE", level = 64, },
	["Congelamento Profundo"] = { class = "MAGE", level = 66, },
	["Contrafeitiço Aprimorado"] = { class = "MAGE", level = 70, },
	["Conjurar Mesa de Refeição"] =	{ class = "MAGE", level = 72, },
	["Harmonização com o Éter"] = { class = "MAGE", level = 74, },
	["Bomba do Mago"] = 		{ class = "MAGE", level = 75, },
	["Inteligência de Dalaran"] = { class = "MAGE", level = 80, },
	["Armadura de Mago"] = 		{ class = "MAGE", level = 80, },
	["Alma Ardente"] = 			{ class = "MAGE", level = 82, },
	["Distorção Temporal"] = 	{ class = "MAGE", level = 84, },
	["Alterar o Tempo"] = 		{ class = "MAGE", level = 87, }, 
	["Polimorfia: Porco"] = 	{ class = "MAGE", level = 60, },
	["Polimorfia: Coelho"] = 	{ class = "MAGE", level = 60, },
	["Polimorfia: Tartaruga"] = { class = "MAGE", level = 60, },
	["Polimorfia: Gato Preto"] = { class = "MAGE", level = 60, },
	["Polymorph: Peru"] = 		{ class = "MAGE", level = 60, }, 	
	["Portal Antigo: Dalaran"] = { class = "MAGE", level = 74, },	
	["Portal: Dalaran"] = 		{ class = "MAGE", level = 74, },
	["Portal: Darnassus"] = 	{ class = "MAGE", level = 42, },
	["Portal: Exodar"] = 		{ class = "MAGE", level = 42, },
	["Portal: Altaforja"] = 	{ class = "MAGE", level = 42, },
	["Portal: Orgrimmar"] = 	{ class = "MAGE", level = 42, },
	["Portal: Shattrath"] = 	{ class = "MAGE", level = 66, },
	["Portal: Luaprata"] = 		{ class = "MAGE", level = 42, },
	["Portal: Pedregal"] = 		{ class = "MAGE", level = 52, },
	["Portal: Ventobravo"] = 	{ class = "MAGE", level = 42, },
	["Portal: Theramore"] = 	{ class = "MAGE", level = 42, },
	["Portal: Penhasco do Trovão"] = { class = "MAGE", level = 42, },
	["Portal: Tol Barad"] = 	{ class = "MAGE", level = 85, },
	["Portal: Cidade Baixa"] = 	{ class = "MAGE", level = 42, },
	["Portal: Vale das Flores Eternas"] = { class = "MAGE", level = 90, },
	["Teleporte Antigo: Dalaran"] = { class = "MAGE", level = 71, },	
	["Teleport: Dalaran"] = 	{ class = "MAGE", level = 71, },
	["Teleport: Darnassus"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Exodar"] = 		{ class = "MAGE", level = 17, },
	["Teleport: Altaforja"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Orgrimmar"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Shattrath"] = 	{ class = "MAGE", level = 62, },
	["Teleport: Luaprata"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Pedregal"] = 	{ class = "MAGE", level = 52, },
	["Teleport: Ventobravo"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Theramore"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Penhasco do Trovão"] = { class = "MAGE", level = 17, },
	["Teleport: Tol Barad"] = 	{ class = "MAGE", level = 85, },
	["Teleport: Cidade Baixa"] = { class = "MAGE", level = 17, },
	["Teleporte: Vale das Flores Eternas"] = { class = "MAGE", level = 90, },
	--++ Glyph Abilities ++
	["Conjurar Familiar"] = 	{ class = "MAGE", level = 25, },
	["Ilusão"] =   				{ class = "MAGE", level = 25, },
--++ Mage Specialization ++
	--++ Arcane ++
	["Impacto Arcano"] = 		{ class = "MAGE", level = 10, },
	["Carga Arcana"] = 			{ class = "MAGE", level = 10, },
	["Barragem Arcana"] = 		{ class = "MAGE", level = 12, },
	["Mísseis Arcanos"] = 		{ class = "MAGE", level = 24, },
	["Retardar"] = 				{ class = "MAGE", level = 36, },
	["Poder Arcano"] = 			{ class = "MAGE", level = 62, },
	["Adepto do Mana"] = 		{ class = "MAGE", level = 80, }, 
	--++ Fire ++ 
	["Ignimpacto"] = 			{ class = "MAGE", level = 10, },
	["Bola de Fogo"] = 			{ class = "MAGE", level = 12, },
	["Impacto Infernal"] = 		{ class = "MAGE", level = 24, },
	["Massa Crítica"] = 		{ class = "MAGE", level = 36, },
	["Calcinar"] = 				{ class = "MAGE", level = 48, },
	["Sopro do Dragão"] = 		{ class = "MAGE", level = 62, },
	["Combustão"] = 			{ class = "MAGE", level = 77, }, 
	["Incendiar"] = 			{ class = "MAGE", level = 80, },
	["Piromaníaco"] = 			{ class = "MAGE", level = 85, },
	--++ Frost ++ 
	["Evocar Elemental da Água"] = { class = "MAGE", level = 10, },
	["Seta de Gelo"] = 			{ class = "MAGE", level = 12, },
	["Dedos Glaciais"] = 		{ class = "MAGE", level = 24, },
	["Veias Gélidas"] = 		{ class = "MAGE", level = 36, },
	["Orbe Congelado"] = 		{ class = "MAGE", level = 62, },
	["Congelamento Cerebral"] = { class = "MAGE", level = 77, },
--	["Frostburn"] = 			{ class = "MAGE", level = 80, }, --Removed in Patch 5.4
	["Sincelo"] = 				{ class = "MAGE", level = 80, }, --Added in Patch 5.4
--++ Mage Talents ++
	["Presença de Espírito"] = 	{ class = "MAGE", level = 15, },
	["Explosão de Velocidade"] = { class = "MAGE", level = 15, },
	["Banquisas"] = 			{ class = "MAGE", level = 15, }, 
	["Escudo Temporal"] = 		{ class = "MAGE", level = 30, },
	["Brilho das Chamas"] = 	{ class = "MAGE", level = 30, },
	["Barreira de Gelo"] = 		{ class = "MAGE", level = 30, }, 
	["Anel Gélido"] = 			{ class = "MAGE", level = 45, },
	["Proteção de Gelo"] = 		{ class = "MAGE", level = 45, },
	["Necrose de Gelo"] = 		{ class = "MAGE", level = 45, }, 
	["Invisibilidade Maior"] = 	{ class = "MAGE", level = 60, },
	["Cauterizar"] = 			{ class = "MAGE", level = 60, },
	["Ruptura do Gelo"] = 		{ class = "MAGE", level = 60, }, 
	["Tempestade de Éter"] = 	{ class = "MAGE", level = 75, },
	["Bomba Viva"] = 			{ class = "MAGE", level = 75, },
	["Bomba Gélida"] = 			{ class = "MAGE", level = 75, }, 
	["Invocação"] = 			{ class = "MAGE", level = 90, },
	["Runa de Poder"] = 		{ class = "MAGE", level = 90, },
	["Proteção do Sortílego"] = { class = "MAGE", level = 90, }, 

--++ Monk Abilities ++
	["Jabe"]   = 				{ class = "MONK", level = 1, },
	["Postura do Tigre Agressivo"] = { class = "MONK", level = 1, },  
	["Caminho do Monge"]   = 	{ class = "MONK", level = 1, },  
	["Palma do Tigre"]   = 		{ class = "MONK", level = 3, },  
	["Rolamento"]   = 			{ class = "MONK", level = 5, },  
	["Chute Blecaute"]   = 		{ class = "MONK", level = 7, },  
	["Provocar"]   = 			{ class = "MONK", level = 14, },  
	["Ressuscitar"]   = 		{ class = "MONK", level = 18, },  
	["Desintoxicação"]   = 		{ class = "MONK", level = 20, },  
	["Peregrinação Zen"]   = 	{ class = "MONK", level = 20, },  
	["Legado do Imperador"] = 	{ class = "MONK", level = 22, },  
	["Toque da Morte"]   = 		{ class = "MONK", level = 22, },  
	["Reflexo Rápido"]   = 		{ class = "MONK", level = 23, }, 
	["Cerveja Fortificante"] = 	{ class = "MONK", level = 24, },  
	["Expelir o Mal"]   = 		{ class = "MONK", level = 26, },  
	["Desativar"]   = 			{ class = "MONK", level = 28, },
	["Cerveja Ligeira"]   = 	{ class = "MONK", level = 30, },
	["Peregrinação Zen: Retornar"] = { class = "MONK", level = 30, }, 
	["Golpe Mão de Lança"]   = 	{ class = "MONK", level = 32, },  
	["Paralisia"]   = 			{ class = "MONK", level = 44, },  
--	["Rushing Jade Wind"] =		{ class = "MONK", level = 46, },  --Removed in Patch 5.4  
	["Chute Giratório da Garça"] = { class = "MONK", level = 1, },  --Added in Patch 5.4	
	["Raio Jade Crepitante"]  = { class = "MONK", level = 54, },  
	["Esfera Curativa"]   = 	{ class = "MONK", level = 64, },  
--  ["Path of Blossoms"]   = 	{ class = "MONK", level = 64, },  --Removed in 5.2
	["Tomar Arma"]   = 			{ class = "MONK", level = 68, }, 
	["Meditação Zen"]   = 		{ class = "MONK", level = 82, },  
	["Transcendência"]   = 		{ class = "MONK", level = 87, },  
	["Transcendência: Transferência"] = { class = "MONK", level = 87, },
	--++ Glyph Abilities ++
	["Olho de Boi"] = 			{ class = "MONK", level = 25, },
	["Voo Zen"] =   			{ class = "MONK", level = 25, },	
--++ Monk Specialization ++
	--++ Mistweaver/Windwalker ++	
	["Golpes do Tigre"]   = 	{ class = "MONK", level = 10, },	
	--++ Brewmaster ++ 
	["Postura do Boi Resistente"] = { class = "MONK", level = 10, },  
	["Névoa Estonteante"]   = 	{ class = "MONK", level = 10, },  
 	["Vingança"]   = 			{ class = "MONK", level = 10, },  
	["Pancada de Barril"]   = 	{ class = "MONK", level = 11, },  
	["Colisão"]   = 			{ class = "MONK", level = 18, },  
	["Bafo de Onça"]   = 		{ class = "MONK", level = 18, },  
	["Guarda"]   = 				{ class = "MONK", level = 26, },  
	["Discípulo de Mestre Cervejeiro"] = { class = "MONK", level = 34, },  
	["Cerveja Elusiva"]   = 	{ class = "MONK", level = 36, },  
	["Preparando: Cerveja Elusiva"] = { class = "MONK", level = 36, },  
	["Medidas Desesperadas"] = 	{ class = "MONK", level = 45, },  
	["Evitar Ameaça"]   = 		{ class = "MONK", level = 48, },  
--	["Especialização em Armadura de Couro"] = { class = "MONK", level = 50, },  
	["Glifo do Boi"]   = 		{ class = "MONK", level = 56, },  
	["Evocar Estátua do Boi Negro"] = { class = "MONK", level = 70, },  
	["Cerveja Purificante"] = 	{ class = "MONK", level = 75, },  
	["Lutador Evasivo"]   = 	{ class = "MONK", level = 80, },
	--++ Mistweaver ++ 	
	["Postura da Serpente Sábia"] = { class = "MONK", level = 10, },  
	["Bruma Calmante"]   = 		{ class = "MONK", level = 10, },  
	["Meditação de Mana"]   = 	{ class = "MONK", level = 10, }, 
	["Bruma Envolvente"]   = 	{ class = "MONK", level = 16, }, 	
	["Remédio Inteiror"]   = 	{ class = "MONK", level = 20, },
	["Remédio Inteiror"]   = 	{ class = "MONK", level = 20, }, 	
	["Bruma Ascendente"]   = 	{ class = "MONK", level = 32, },  
 	["Ensinamentos do Monastério"] = { class = "MONK", level = 34, },  
	["Névoa Renovadora"]   = 	{ class = "MONK", level = 42, },  
	["Desmaterializar"]   = 	{ class = "MONK", level = 45, },  
	["Casulo de Vida"]   = 		{ class = "MONK", level = 50, },  
--	["Leather Specialization"] = { class = "MONK", level = 50, },  
	["Chá de Mana"]   = 		{ class = "MONK", level = 56, },  
	["Preparando: Chá de Mana"] = { class = "MONK", level = 56, },  
	["Corrente Ascendente"]   = { class = "MONK", level = 62, },  
	["Chá do Foco do Trovão"] = { class = "MONK", level = 66, },  
	["Evocar Estátua de Serpente de Jade"] = { class = "MONK", level = 70, },  
	["Reviver"]   = 			{ class = "MONK", level = 78, }, 
	["Maestria: Dádiva da Serpente"] = { class = "MONK", level = 80, }, 
	--++ Windwalker ++ 	
	["Punhos da Fúria"] = 		{ class = "MONK", level =  10, }, 
	["Quebra-combo"] = 			{ class = "MONK", level =  15, }, 
	["Chute Voador da Serpente"] = { class = "MONK", level =  18, }, 
	["Condicionamento de Combate"] = { class = "MONK", level =  20, }, 
	["Toque do Karma"] = 		{ class = "MONK", level =  22, }, 
	["Além-vida"] = 			{ class = "MONK", level =  26, }, 
	["Cerveja Energizante"] = 	{ class = "MONK", level =  36, }, 
	["Pugilato"] = 				{ class = "MONK", level =  42, }, 
	["Adaptação"] = 			{ class = "MONK", level =  45, }, 
	["Flor de Fogo Giratória"] = { class = "MONK", level =  48, }, 
--	["Especialização em Armadura de Couro"] = { class = "MONK", level =  50, }, 
	["Chute do Sol Nascente"] = { class = "MONK", level =  56, }, 
	["Cerveja Olho de Tigre"] = { class = "MONK", level =  56, }, 	
	["Preparando: Cerveja Olho de Tigre"] = { class = "MONK", level =  56, }, 
	["Tempestade, Terra e Fogo"] = { class = "MONK", level =  75, }, 
	["Fúria Engarrafada"] = 	{ class = "MONK", level = 80, },	
	["Legado do Tigre Branco"] = { class = "MONK", level =  81, }, 
--++ Monk Talents ++
	["Celeridade"]  = 			{ class = "MONK", level = 15, },  
	["Luxúria do Tigre"] =  	{ class = "MONK", level = 15, },  
	["Embalo"]  = 				{ class = "MONK", level = 15, }, 
	["Onda de Chi"]  = 			{ class = "MONK", level = 30, },  
	["Esfera Zen"]  = 			{ class = "MONK", level = 30, },  
	["Estouro de Chi"]  = 		{ class = "MONK", level = 30, }, 
	["Golpes Poderosos"]  = 	{ class = "MONK", level = 45, },  
	["Ascensão"]  = 			{ class = "MONK", level = 45, },  
	["Cerveja de Chi"]  = 		{ class = "MONK", level = 45, }, 
	["Anel da Paz"]  = 			{ class = "MONK", level = 60, },
--  ["Deadly Reach"]  = 		{ class = "MONK", level = 60, },  --Removed in Patch 5.2
	["Onda do Boi em Disparada"] = { class = "MONK", level = 60, },  
	["Rasteira"]  = 			{ class = "MONK", level = 60, }, 
	["Elixires Curativos"]  = 	{ class = "MONK", level = 75, },  
	["Atenuar Ferimento"]  = 	{ class = "MONK", level = 75, },  
	["Magia Difusa"]  = 		{ class = "MONK", level = 75, }, 
	["Vento Impetuoso de Jade"] = { class = "MONK", level = 90, },  
	["Evocar Xuen, o Tigre Branco"] = { class = "MONK", level = 90, },  
	["Torpedo de Chi"] = 		{ class = "MONK", level = 90, },  

--++ Paladin Abilities ++
	["Golpe do Cruzado"] = 		{ class = "PALADIN", level = 1, },
	["Selo da Retidão"] = 		{ class = "PALADIN", level = 3, },
	["Julgamento"] = 			{ class = "PALADIN", level = 5, },
	["Martelo da Justiça"] = 	{ class = "PALADIN", level = 7, },
	["Palavras Duras"] = 		{ class = "PALADIN", level = 9, },
	["Palavra de Glória"] = 	{ class = "PALADIN", level = 9, },
	["Fúria Íntegra"] = 		{ class = "PALADIN", level = 12, },
	["Redenção"] = 				{ class = "PALADIN", level = 13, },
	["Clarão de Luz"] = 		{ class = "PALADIN", level = 14, },
	["Ajuste de Contas"] = 		{ class = "PALADIN", level = 15, },
	["Impor as Mãos"] = 		{ class = "PALADIN", level = 16, },
	["Escudo Divino"] = 		{ class = "PALADIN", level = 18, },
	["Purificação"] = 			{ class = "PALADIN", level = 20, },
	["Selo da Verdade"] = 		{ class = "PALADIN", level = 24, },
	["Proteção Divina"] = 		{ class = "PALADIN", level = 26, },
	["Bênção dos Reis"] = 		{ class = "PALADIN", level = 30, },
	["Selo da Intuição"] = 		{ class = "PALADIN", level = 32, },
	["Súplica"] = 				{ class = "PALADIN", level = 34, },
	["Repreensão"] = 			{ class = "PALADIN", level = 36, },
	["Martelo da Ira"] = 		{ class = "PALADIN", level = 38, },
	["Selo da Retidão"] = 		{ class = "PALADIN", level = 42, },
	["Coração do Cruzado"] = 	{ class = "PALADIN", level = 44, },
	["Esconjurar o Mal"] = 		{ class = "PALADIN", level = 46, },
	["Mão da Proteção"] = 		{ class = "PALADIN", level = 48, },
	["Mão da Liberdade"] = 		{ class = "PALADIN", level = 52, },
	["Santidade de Batalha"] = 	{ class = "PALADIN", level = 58, },
	["Aura de Devoção"] = 		{ class = "PALADIN", level = 60, },
	["Mão da Salvação"] = 		{ class = "PALADIN", level = 66, },
	["Ira Vingativa"] = 		{ class = "PALADIN", level = 72, },
	["Mão do Sacrifício"] = 	{ class = "PALADIN", level = 80, },
	["Bênção do Poder"] = 		{ class = "PALADIN", level = 81, },
	["Convicção Irrestrita"] = 	{ class = "PALADIN", level = 85, },
	["Luz Ofuscante"] = 		{ class = "PALADIN", level = 87, },
	--++ Glyph Abilities ++
	["Contemplação"] = 			{ class = "PALADIN", level = 25, },
--++ Paladin Specialization ++
	--++ Protection/Retribution ++ 
	["Martelo do Íntegro"] = 	{ class = "PALADIN", level = 20, },
	--++ Holy/Protection/Retribution ++	
	["Guardião dos Reis Antigos"] = { class = "PALADIN", level = 75, },
	--++ Holy ++
	["Choque Sagrado"] = 		{ class = "PALADIN", level = 10, },
	["Percepção Sagrada"] = 	{ class = "PALADIN", level = 10, },
	["Condenar"] = 				{ class = "PALADIN", level = 20, },
	["Purificação Sagrada"] = 	{ class = "PALADIN", level = 20, },
	["Resplendor Sagrado"] = 	{ class = "PALADIN", level = 28, },
	["Luz Sagrada"] = 			{ class = "PALADIN", level = 34, },
	["Foco de Luz"] = 			{ class = "PALADIN", level = 39, },
	["Apelo Divino"] = 			{ class = "PALADIN", level = 46, },
	["Infusão de Luz"] = 		{ class = "PALADIN", level = 50, },
	["Amanhecer"] = 			{ class = "PALADIN", level = 56, },
	["Luz Divina"] = 			{ class = "PALADIN", level = 54, },
	["Favorecimento Divino"] = 	{ class = "PALADIN", level = 62, },
	["Torre do Resplendor"] = 	{ class = "PALADIN", level = 64, },
	["Luz da Aurora"] = 		{ class = "PALADIN", level = 70, },
	["Cura Iluminada"] = 		{ class = "PALADIN", level = 80, }, 
	--++ Protection ++ 
	["Escudo do Vingador"] = 	{ class = "PALADIN", level = 10, },
	["Protegido pela Luz"] = 	{ class = "PALADIN", level = 10, },
	["Vingança"] = 				{ class = "PALADIN", level = 10, },
	["Ira Sagrada"] = 			{ class = "PALADIN", level = 20, },
	["Julgamentos do Sábio"] = 	{ class = "PALADIN", level = 28, },
	["Consagração"] = 			{ class = "PALADIN", level = 34, },
	["Escudo do Íntegro"] = 	{ class = "PALADIN", level = 40, },
	["Grande Cruzado"] = 		{ class = "PALADIN", level = 50, },
	["Santuário"] = 			{ class = "PALADIN", level = 64, },
	["Defensor Ardente"] = 		{ class = "PALADIN", level = 70, },
	["Baluarte Divino"] = 		{ class = "PALADIN", level = 80, },
	--++ Retribution ++  
	["Veredito do Templário"] = { class = "PALADIN", level = 10, },
	["Espada de Luz"] = 		{ class = "PALADIN", level = 10, },
	["Julgamentos do Bravo"] = 	{ class = "PALADIN", level = 28, },
	["Tempestade Divina"] = 	{ class = "PALADIN", level = 34, },
	["Exorcismo"] = 			{ class = "PALADIN", level = 46, },
	["A Arte da Guerra"] = 		{ class = "PALADIN", level = 50, },
	["Emancipar"] = 			{ class = "PALADIN", level = 54, },
	["Selo da Justiça"] = 		{ class = "PALADIN", level = 70, },
	["Absolver"] = 				{ class = "PALADIN", level = 80, },	
	["Mão de Luz"] = 			{ class = "PALADIN", level = 80, },
	["IInquisição"] = 			{ class = "PALADIN", level = 81, }, 
--++ Paladin Talents ++
	["Velocidade da Luz"] = 	{ class = "PALADIN", level = 15, },
	["O Longo Braço da Lei"] = 	{ class = "PALADIN", level = 15, },
	["Busca de Justiça"] = 		{ class = "PALADIN", level = 15, }, 
	["Punho da Justiça"] = 		{ class = "PALADIN", level = 30, },
	["Contrição"] = 			{ class = "PALADIN", level = 30, },
--	["Burden of Guilt"] = 		{ class = "PALADIN", level = 30, }, --Removed in Patch 5.4
	["Mal é um Ponto de Vista"] = { class = "PALADIN", level = 30, }, --Added in Patch 5.4
	["Curador Abnegado"] = 		{ class = "PALADIN", level = 45, },
	["Chama Eterna"] = 			{ class = "PALADIN", level = 45, },
	["Escudo Sagrado"] = 		{ class = "PALADIN", level = 45, }, 
	["Mão da Pureza"] = 		{ class = "PALADIN", level = 60, },
	["Espírito Indestrutível"] = { class = "PALADIN", level = 60, },
	["Clemência"] = 			{ class = "PALADIN", level = 60, }, 
	["Vingador Sagrado"] = 		{ class = "PALADIN", level = 75, },
	["Ira Santificada"] = 		{ class = "PALADIN", level = 75, },
	["Desígnio Divino"] = 		{ class = "PALADIN", level = 75, }, 
	["Prisma Sagrado"] = 		{ class = "PALADIN", level = 90, },
	["Martelo da Luz"] = 		{ class = "PALADIN", level = 90, },
	["Pena de Morte"] = 		{ class = "PALADIN", level = 90, },

--++ Priest Abilities ++
	["Punição"] = 				{ class = "PRIEST", level = 1, },
	["Palavra Sombria: Dor"] = 	{ class = "PRIEST", level = 3, },
	["Palavra de Poder: Escudo"] = { class = "PRIEST", level = 5, },
	["Cura Célere"] = 			{ class = "PRIEST", level = 7, },
	["Fogo Interior"] = 		{ class = "PRIEST", level = 9, },
	["Concentração Divina"] = 	{ class = "PRIEST", level = 10, },
	["Grito Psíquico"] = 		{ class = "PRIEST", level = 12, },
	["Ressurreição"] = 			{ class = "PRIEST", level = 18, },
	["Palavra de Poder: Fortitude"] = { class = "PRIEST", level = 22, },
	["Desvanecer"] = 			{ class = "PRIEST", level = 24, },
	["Dissipar Magia"] = 		{ class = "PRIEST", level = 26, },
	["Renovar"] = 				{ class = "PRIEST", level = 26, },
	["Agrilhoar Morto-vivo"] = 	{ class = "PRIEST", level = 32, },
	["Levitar"] = 				{ class = "PRIEST", level = 34, },
	["Visão da Mente"] = 		{ class = "PRIEST", level = 42, },
	["Demônio das Sombras"] = 	{ class = "PRIEST", level = 42, },
	["Palavra Sombria: Morte"] = { class = "PRIEST", level = 46, },
	["Cura Vinculada"] = 		{ class = "PRIEST", level = 48, },
	["Misticismo"] = 			{ class = "PRIEST", level = 50, },
	["Proteção contra Medo"] = 	{ class = "PRIEST", level = 54, },
	["Hino de Esperança"] = 	{ class = "PRIEST", level = 66, },
	["Prece da Recomposição"] = { class = "PRIEST", level = 68, },
	["Dissipação em Massa"] = 	{ class = "PRIEST", level = 72, },
	["Calcinação Mental"] = 	{ class = "PRIEST", level = 76, },
	["Vontade Interior"] = 		{ class = "PRIEST", level = 80, },
	["Salto da Fé"] = 			{ class = "PRIEST", level = 84, },
	["Deslocamento Caótico"] = 	{ class = "PRIEST", level = 87, },
	--++ Glyph Abilities ++
	["Nova Sagrada"] = 			{ class = "PRIEST", level = 25, },
	["Confissão"] = 			{ class = "PRIEST", level = 25, },
--++ Priest Specialization ++
	--++ Discipline/Holy ++
	["Meditação"] = 			{ class = "PRIEST", level = 10, },
	["Cura Espiritual"] = 		{ class = "PRIEST", level = 10, }, --++
--	["Fúria Divina"] = 			{ class = "PRIEST", level = 16, },
	["Fogo Sagrado"] = 			{ class = "PRIEST", level = 18, },
	["Purificar"] = 			{ class = "PRIEST", level = 22, },
	["Cura"] = 					{ class = "PRIEST", level = 28, },
	["Vontade Férrea"] = 		{ class = "PRIEST", level = 30, }, --++
	["Cura Maior"] = 			{ class = "PRIEST", level = 34, },
	["Evangelismo"] = 			{ class = "PRIEST", level = 44, },
	["Prece de Cura"] = 		{ class = "PRIEST", level = 46, },
	--++ Discipline ++
	["Enlevo"] = 				{ class = "PRIEST", level = 10, },
	["Penitência"] = 			{ class = "PRIEST", level = 10, },
	["Égide Divina"] = 			{ class = "PRIEST", level = 24, },
	["Couraça Espiritual"] = 	{ class = "PRIEST", level = 28, },
	["Concentração Interior"] = { class = "PRIEST", level = 36, },
	["Reconciliação"] = 		{ class = "PRIEST", level = 38, },
	["Graça"] = 				{ class = "PRIEST", level = 45, },
	["Arcanjo"] = 				{ class = "PRIEST", level = 50, },
	["Força da Alma"] = 		{ class = "PRIEST", level = 52, },
	["Supressão de Dor"] = 		{ class = "PRIEST", level = 58, },
	["Ganhar Tempo"] = 			{ class = "PRIEST", level = 62, },
	["Palavra de Poder: Barreira"] = { class = "PRIEST", level = 70, },
	["Linha de Pensamento"] = 	{ class = "PRIEST", level = 78, },
	["Disciplina do Escudo"] = 	{ class = "PRIEST", level = 80, },
	--++ Holy ++
	["Palavra Sagrada: Castigar"] = { class = "PRIEST", level = 10, },
	["Espírito da Redenção"] = 	{ class = "PRIEST", level = 30, },
	["Serendipidade"] = 		{ class = "PRIEST", level = 34, },
	["Fonte de Luz"] = 			{ class = "PRIEST", level = 36, },  --Added in Patch 5.4 
	["Círculo de Cura"] = 		{ class = "PRIEST", level = 50, },
	["Chacra: Castigar"] = 		{ class = "PRIEST", level = 56, },
	["Chacra: Santuário"] = 	{ class = "PRIEST", level = 56, },
	["Chacra: Serenidade"] = 	{ class = "PRIEST", level = 56, },
	["Renovação Rápida"] = 		{ class = "PRIEST", level = 64, },
	["Espírito Guardião"] = 	{ class = "PRIEST", level = 70, },
	["Hino Divino"] = 			{ class = "PRIEST", level = 78, },
	["Eco de Luz"] = 			{ class = "PRIEST", level = 80, },
	--++ Shadow ++
	["Açoite Mental"] = 		{ class = "PRIEST", level = 10, },
	["Precisão Espiritual"] = 	{ class = "PRIEST", level = 20, },
	["Peste Devoradora"] = 		{ class = "PRIEST", level = 21, },
	["Impacto Mental"] = 		{ class = "PRIEST", level = 21, },
	["Orbes Sombrios"] = 		{ class = "PRIEST", level = 21, },
	["Forma de Sombra"] = 		{ class = "PRIEST", level = 24, },
	["Toque Vampírico"] = 		{ class = "PRIEST", level = 28, },
	["Aparições Sombrias"] = 	{ class = "PRIEST", level = 42, },
	["Aguilhão Mental"] = 		{ class = "PRIEST", level = 44, },
	["Silêncio"] = 				{ class = "PRIEST", level = 52, },
	["Dispersão"] = 			{ class = "PRIEST", level = 60, },
	["Terror Psíquico"] = 		{ class = "PRIEST", level = 74, },
	["Abraço Vampírico"] = 		{ class = "PRIEST", level = 78, },
	["Reconvocação Sombria"] = 	{ class = "PRIEST", level = 80, },
--++ Priest Talents ++
	["Tentáculos do Caos"] = 	{ class = "PRIEST", level = 15, },
	["Psicodemônio"] = 			{ class = "PRIEST", level = 15, },
	["Dominar Mente"] = 		{ class = "PRIEST", level = 15, }, 
	["Corpo e Alma"] = 			{ class = "PRIEST", level = 30, },
	["Pena Angelical"] = 		{ class = "PRIEST", level = 30, },
	["Fantasma"] = 				{ class = "PRIEST", level = 30, }, 
	["Das Trevas, a Luz"] = 	{ class = "PRIEST", level = 45, },
	["Dobramentes"] = 			{ class = "PRIEST", level = 45, },
	["Consolação e Insanidade"] = { class = "PRIEST", level = 45, },
--	["Palavra Sombria: Insanidade"] = { class = "PRIEST", level = 45, }, 
	["Prece Desesperada"] = 	{ class = "PRIEST", level = 60, },
	["Máscara Espectral"] = 	{ class = "PRIEST", level = 60, },
	["Baluarte Angelical"] = 	{ class = "PRIEST", level = 60, }, 
	["Virada do Destino"] = 	{ class = "PRIEST", level = 75, },
	["Infusão de Poder"] = 		{ class = "PRIEST", level = 75, },
	["Intuição Divina"] = 		{ class = "PRIEST", level = 75, }, 
	["Cascata"] = 				{ class = "PRIEST", level = 90, },
	["Estrela Divina"] = 		{ class = "PRIEST", level = 90, },
	["Halo"] = 					{ class = "PRIEST", level = 90, },

--++ Rogue Abilities ++
	["Golpe Sinistro"] = 		{ class = "ROGUE", level = 1, },
	["Eviscerar"] = 			{ class = "ROGUE", level = 3, },
	["Furtividade"] = 			{ class = "ROGUE", level = 5, },
	["Emboscar"] = 				{ class = "ROGUE", level = 6, },
	["Evasão"] = 				{ class = "ROGUE", level = 8, },
	["Veneno Mortal"] = 		{ class = "ROGUE", level = 10, },
	["Aturdir"] = 				{ class = "ROGUE", level = 12, },
	["Retalhar"] = 				{ class = "ROGUE", level = 14, },
	["Bater Carteira"] = 		{ class = "ROGUE", level = 15, },
	["Recobrar"] = 				{ class = "ROGUE", level = 16, },
	["Chute"] = 				{ class = "ROGUE", level = 18, },
	["Veneno Debilitante"] = 	{ class = "ROGUE", level = 20, },
	["Esfaquear"] = 			{ class = "ROGUE", level = 22, },
	["Abrir Fechadura"] = 		{ class = "ROGUE", level = 24, },
	["Disparada"] = 			{ class = "ROGUE", level = 26, },
	["Distração"] = 			{ class = "ROGUE", level = 28, },
	["Veneno Entorpecente"] = 	{ class = "ROGUE", level = 28, },
	["Golpe Baixo"] = 			{ class = "ROGUE", level = 30, },
	["Veneno Ferino"] = 		{ class = "ROGUE", level = 30, },
	["Astúcia da Lâmina Célere"] = { class = "ROGUE", level = 30, },
	["Sumir"] = 				{ class = "ROGUE", level = 34, },
	["Expor Armadura"] = 		{ class = "ROGUE", level = 36, },
	["Cegar"] = 				{ class = "ROGUE", level = 38, },
	["Golpe no Rim"] = 			{ class = "ROGUE", level = 40, },
	["Detectar Armadilhas"] = 	{ class = "ROGUE", level = 42, },
	["Finta"] = 				{ class = "ROGUE", level = 44, },
	["Ruptura"] = 				{ class = "ROGUE", level = 46, },
	["Garrote"] = 				{ class = "ROGUE", level = 48, },
	["Queda Segura"] = 			{ class = "ROGUE", level = 48, },
--	["Especialização em Armadura de Couro"] = { class = "ROGUE", level = 50, },
	["Desmantelar"] = 			{ class = "ROGUE", level = 52, },
	["Golpes Implacáveis"] = 	{ class = "ROGUE", level = 54, },
	["Desarmar Armadilha"] = 	{ class = "ROGUE", level = 56, },
	["Manto das Sombras"] = 	{ class = "ROGUE", level = 58, },
	["Pé de Vento"] = 			{ class = "ROGUE", level = 62, },
	["Mestre Envenenador"] = 	{ class = "ROGUE", level = 64, },
	["Leque de Facas"] = 		{ class = "ROGUE", level = 66, },
	["Preparação"] = 			{ class = "ROGUE", level = 68, },
	["Andar Sombrio"] = 		{ class = "ROGUE", level = 72, },
	["Estocada"] = 				{ class = "ROGUE", level = 74, },
	["Mortalha da Ocultação"] = { class = "ROGUE", level = 76, },
	["Truques do Ofício"] = 	{ class = "ROGUE", level = 78, },
	["Redirecionar"] = 			{ class = "ROGUE", level = 81, },
	["Tempestade Carmesim"] = 	{ class = "ROGUE", level = 83, },
	["Bomba de Fumaça"] = 		{ class = "ROGUE", level = 85, },
	["Lâminas Sombrias"] = 		{ class = "ROGUE", level = 87, },
	--++ Glyph Abilities ++
	["Detecção"] = 				{ class = "ROGUE", level = 25, },	
--++ Rogue Specialization ++
	--++ Assassination ++  
	["Determinação do Assassino"] = { class = "ROGUE", level = 10, },
	["Venenos Aprimorados"] = 	{ class = "ROGUE", level = 10, },
	["Mutilar"] = 				{ class = "ROGUE", level = 10, },
	["Envenenar"] = 			{ class = "ROGUE", level = 20, },
	["Selar o Destino"] = 		{ class = "ROGUE", level = 30, },
	["Liquidar"] = 				{ class = "ROGUE", level = 40, },
	["Feridas Envenenadas"] = 	{ class = "ROGUE", level = 50, },
	["Ir ao Ponto"] = 			{ class = "ROGUE", level = 60, },
	["Ponto Cego"] = 			{ class = "ROGUE", level = 70, },
	["Vendeta"] = 				{ class = "ROGUE", level = 80, },
	["Venenos Potentes"] = 		{ class = "ROGUE", level = 80, },
	--++ Combat ++  
	["Ambidestria"] = 			{ class = "ROGUE", level = 10, },
	["Vitalidade"] = 			{ class = "ROGUE", level = 10, },
	["Rajada de Lâminas"] = 	{ class = "ROGUE", level = 10, },
	["Golpe Revelador"] = 		{ class = "ROGUE", level = 20, },
	["Vigor em Combate"] = 		{ class = "ROGUE", level = 30, },
	["Malevolência"] = 			{ class = "ROGUE", level = 32, }, -- Added in Patch 5.4
	["Adrenalina"] = 			{ class = "ROGUE", level = 40, },
	["Lâminas Inquietas"] = 	{ class = "ROGUE", level = 50, },
	["Logro do Bandido"] = 		{ class = "ROGUE", level = 60, },
	["Matança"] = 				{ class = "ROGUE", level = 80, },
	["Adaga de Bloqueio"] = 	{ class = "ROGUE", level = 80, },
	--++ Subtlety ++
	["Hemorragia"] = 			{ class = "ROGUE", level = 10, },
	["Mestre do Subterfúgio"] = { class = "ROGUE", level = 10, },
	["Chamado Sinistro"] = 		{ class = "ROGUE", level = 10, },
	["Achar Ponto Fraco"] = 	{ class = "ROGUE", level = 20, },
	["Premeditação"] = 			{ class = "ROGUE", level = 30, },
	["Punhalada pelas Costas"] = { class = "ROGUE", level = 40, },
	["Honra Entre Ladrões"] = 	{ class = "ROGUE", level = 50, },
	["Veia Sanguinária"] = 		{ class = "ROGUE", level = 60, },
	["Recuperação Energética"] = { class = "ROGUE", level = 70, },
	["Dança das Sombras"] = 	{ class = "ROGUE", level = 80, },
	["Carrasco"] = 				{ class = "ROGUE", level = 80, }, 
--++ Rogue Talents ++
	["Espreitanoite"] = 		{ class = "ROGUE", level = 15, },
	["Subterfúgio"] = 			{ class = "ROGUE", level = 15, },
	["Concentração Sombria"] = 	{ class = "ROGUE", level = 15, },
	["Arremesso Mortal"] = 		{ class = "ROGUE", level = 30, },
	["Golpe no Nervo"] = 		{ class = "ROGUE", level = 30, },
	["Prontidão de Combate"] = 	{ class = "ROGUE", level = 30, }, 
	["Escapar da Morte"] = 		{ class = "ROGUE", level = 45, },
	["Veneno Sorvedouro"] = 	{ class = "ROGUE", level = 45, },
	["Escorregadio"] = 			{ class = "ROGUE", level = 45, }, 
	["Passo Furtivo"] = 		{ class = "ROGUE", level = 60, },
	["Estouro de Velocidade"] = { class = "ROGUE", level = 60, }, 
	["Capa e Espada"] = 		{ class = "ROGUE", level = 60, }, 
	["Oprimir os Fracos"] = 	{ class = "ROGUE", level = 75, },
	["Veneno Paralisante"] = 	{ class = "ROGUE", level = 75, },
	["Truques Sujos"] = 		{ class = "ROGUE", level = 75, }, 
	["Lançar Shuriken"] = 		{ class = "ROGUE", level = 90, },
--  ["Versatility"] = 			{ class = "ROGUE", level = 90, }, --Removed in Patch 5.2
	["Marcado para Morrer"] =	{ class = "ROGUE", level = 90, },
	["Antecipação"] = 			{ class = "ROGUE", level = 90, },

--++ Shaman Abilities ++
	["Raio"] = 					{ class = "SHAMAN", level = 1, },
	["Golpe Primevo"] = 		{ class = "SHAMAN", level = 3, },
	["Choque Terreno"] = 		{ class = "SHAMAN", level = 6, },
	["Maré Curativa"] = 		{ class = "SHAMAN", level = 7, },
	["Escudo de Raios"] = 		{ class = "SHAMAN", level = 8, },
	["Arma de Labaredas"] = 	{ class = "SHAMAN", level = 10, },
	["Choque Flamejante"] = 	{ class = "SHAMAN", level = 12, },
	["Expurgar"] = 				{ class = "SHAMAN", level = 12, },
	["Espírito Ancestral"] = 	{ class = "SHAMAN", level = 14, },
	["Lobo Fantasma"] = 		{ class = "SHAMAN", level = 15, },
	["Totem Calcinante"] = 		{ class = "SHAMAN", level = 16, },
	["Rajada de Vento"] = 		{ class = "SHAMAN", level = 16, },
	["Purificar Espírito"] = 	{ class = "SHAMAN", level = 18, },
	["Escudo de Água"] = 		{ class = "SHAMAN", level = 20, },
	["Choque Gélido"] = 		{ class = "SHAMAN", level = 22, },
	["Andar sobre a Água"] = 	{ class = "SHAMAN", level = 24, },
	["Totem de Prisão Terrena"] = { class = "SHAMAN", level = 26, },
	["Cadeia de Raios"] = 		{ class = "SHAMAN", level = 28, },
	["Totem de Torrente Curativa"] = { class = "SHAMAN", level = 30, }, --Removed in Patch 5.4
--	["Rushing Streams"] = 		{ class = "SHAMAN", level = 30, }, --Added in Patch 5.4 ??
	["Revocação Totêmica"] = 	{ class = "SHAMAN", level = 30, },
	["Reencarnação"] = 			{ class = "SHAMAN", level = 32, },
	["Revocação Astral"] = 		{ class = "SHAMAN", level = 34, },
	["Visão Distante"] = 		{ class = "SHAMAN", level = 36, },
	["Totem de Magma"] = 		{ class = "SHAMAN", level = 36, },
	["Totem de Aterramento"] = 	{ class = "SHAMAN", level = 38, },
	["Ira Flamejante"] = 		{ class = "SHAMAN", level = 40, },
	["Cura Encadeada"] = 		{ class = "SHAMAN", level = 44, },
	["Arma da Marca Gélida"] = 	{ class = "SHAMAN", level = 46, },
--	["Especialização em Armadura de Malha"] = { class = "SHAMAN", level = 50, },
	["Totem Sísmico"] = 		{ class = "SHAMAN", level = 54, },
	["Totem de Elemental da Terra"] = { class = "SHAMAN", level = 58, },
	["Chuva Curativa"] = 		{ class = "SHAMAN", level = 60, },
	["Totem Capacitor"] = 		{ class = "SHAMAN", level = 63, },
	["HTotem de Maré Curativa"] = { class = "SHAMAN", level = 65, }, --++
	["Totem de Elemental do Fogo"] = { class = "SHAMAN", level = 66, },
	["Heroísmo"] = 				{ class = "SHAMAN", level = 70, },
	["Sede de Sangue"] = 		{ class = "SHAMAN", level = 70, },
	["Grilhão Elemental"] = 	{ class = "SHAMAN", level = 72, },
	["Bagata"] = 				{ class = "SHAMAN", level = 75, },
	["Arma Trinca-pedra"] = 	{ class = "SHAMAN", level = 75, },
	["Totem de Açoite Trovejante"] = { class = "SHAMAN", level = 78, },
	["Graça do Ar"] = 			{ class = "SHAMAN", level = 80, },
	["Liberar Elementos"] = 	{ class = "SHAMAN", level = 81, },
	["Graça do Andarilho Espiritual"] = { class = "SHAMAN", level = 85, },
	["Ascendência"] = 			{ class = "SHAMAN", level = 87, },
--++ Shaman Specialization ++
	--++ Elemental/Restoration ++ 
	["Iluminação Espiritual"] = { class = "SHAMAN", level = 10, },
	["Estouro de Lava"] = 		{ class = "SHAMAN", level = 34, },
	--++ Elemental/Enhancement ++
	["Fúria Xamanística"] = 	{ class = "SHAMAN", level = 65, },
	--++ Elemental ++ 
	["Fúria Elemental"] = 		{ class = "SHAMAN", level = 10, },
	["Precisão Elemental"] = 	{ class = "SHAMAN", level = 10, },
	["Alcance Elemental"] = 	{ class = "SHAMAN", level = 10, },
	["Xamanismo"] = 			{ class = "SHAMAN", level = 10, },
	["Tempestade Relampejante"] = { class = "SHAMAN", level = 10, },
	["Eco Ribombante"] = 		{ class = "SHAMAN", level = 20, },
	["Fulminação"] = 			{ class = "SHAMAN", level = 20, },
	["Concentração Elemental"] = { class = "SHAMAN", level = 40, },
	["Torrente de Lava"] = 		{ class = "SHAMAN", level = 50, },
	["Juramento Elemental"] = 	{ class = "SHAMAN", level = 55, },
	["Terremoto"] = 			{ class = "SHAMAN", level = 60, },
	["Sobrecarga Elemental"] = 	{ class = "SHAMAN", level = 80, },
	--++ Enhancement ++
	["Açoite de Lava"] = 		{ class = "SHAMAN", level = 10, },
	["Rapidez Mental"] = 		{ class = "SHAMAN", level = 10, },
	["Sabedoria Primeva"] = 	{ class = "SHAMAN", level = 10, }, 
	["Ímpeto"] = 				{ class = "SHAMAN", level = 20, },
	["Ataque da Tempestade"] = 	{ class = "SHAMAN", level = 26, },
	["Arma de Fúria dos Ventos"] = { class = "SHAMAN", level = 30, },
	["Chamas Calcinantes"] = 	{ class = "SHAMAN", level = 34, },
	["Choque Estático"] = 		{ class = "SHAMAN", level = 40, },
	["Nova de Fogo"] = 			{ class = "SHAMAN", level = 44, },
	["Arma da Voragem"] = 		{ class = "SHAMAN", level = 50, },
	["Raiva Incontida"] = 		{ class = "SHAMAN", level = 55, },
	["Espírito Feral"] = 		{ class = "SHAMAN", level = 60, },
	["Andar Espiritual"] = 		{ class = "SHAMAN", level = 60, },
	["Elementos Melhorados"] = 	{ class = "SHAMAN", level = 80, },
	--++ Restoration ++
	["Meditação"] = 			{ class = "SHAMAN", level = 10, },
	["Purificação"] = 			{ class = "SHAMAN", level = 10, },
	["Contracorrente"] = 		{ class = "SHAMAN", level = 10, },
	["Purificar o Espírito"] = 	{ class = "SHAMAN", level = 18, },	
	["Onda Curativa"] = 		{ class = "SHAMAN", level = 20, },
	["Escudo da Terra"] = 		{ class = "SHAMAN", level = 26, },
	["Arma Terraviva"] = 		{ class = "SHAMAN", level = 30, },
	["Despertar Ancestral"] = 	{ class = "SHAMAN", level = 34, },
	["Ressurgência"] = 			{ class = "SHAMAN", level = 40, },
	["Mar Revolto"] = 			{ class = "SHAMAN", level = 50, },
	["Totem de Vagalhão de Mana"] = { class = "SHAMAN", level = 56, },
	["Onda Curativa Maior"] = 	{ class = "SHAMAN", level = 60, },
	["Totem do Vínculo do Espírito"] = { class = "SHAMAN", level = 70, },
	["Cura Profunda"] = 		{ class = "SHAMAN", level = 80, }, 
--++ Shaman Talents ++
	["Guardião da Natureza"] = 	{ class = "SHAMAN", level = 15, },
	["Totem de Baluarte Pétreo"] = { class = "SHAMAN", level = 15, },
	["Transição Astral"] = 		{ class = "SHAMAN", level = 15, }, 
	["Poder Congelado"] = 		{ class = "SHAMAN", level = 30, },
	["Totem Agarraterra"] = 	{ class = "SHAMAN", level = 30, },
	["Totem Andavento"] = 		{ class = "SHAMAN", level = 30, }, 
	["Chamado dos Elementos"] = { class = "SHAMAN", level = 45, },
--	["Totemic Restoration"] = 	{ class = "SHAMAN", level = 45, }, --Removed in Patch 5.4
	["Persistência Totêmica"] = { class = "SHAMAN", level = 45, }, --Added in Patch 5.4
	["Projeção Totêmica"] = 	{ class = "SHAMAN", level = 45, }, 
	["Mestre dos Elementos"] = 	{ class = "SHAMAN", level = 60, },
	["Rapidez Ancestral"] = 	{ class = "SHAMAN", level = 60, },
	["Eco dos Elementos"] = 	{ class = "SHAMAN", level = 60, }, 
	["Fluxo Contínuo"] = 		{ class = "SHAMAN", level = 75, },
	["Conselho dos Ancestrais"] = { class = "SHAMAN", level = 75, },
	["Condutividade"] = 		{ class = "SHAMAN", level = 75, }, 
	["Fúria Liberada"] = 		{ class = "SHAMAN", level = 90, },
	["Elementalista Primevo"] = { class = "SHAMAN", level = 90, },
	["Impacto Elemental"] = 	{ class = "SHAMAN", level = 90, },

--++ Warlock Abilities ++
	["Seta Sombria"] = 			{ class = "WARLOCK", level = 1, },
	["Talho Demoníaco"] = 		{ class = "WARLOCK", level = 1, }, -- Dark Apotheosis Ability
	["Sifão de Vida"] = 		{ class = "WARLOCK", level = 1, }, --++
	["Evocar Diabrete"] = 		{ class = "WARLOCK", level = 1, },
	["Corrupção"] = 			{ class = "WARLOCK", level = 3, },
	["Drenar Vida"] = 			{ class = "WARLOCK", level = 7, },
	["Evocar Emissário do Caos"] = { class = "WARLOCK", level = 8, },
	["Criar Pedra de Vida"] = 	{ class = "WARLOCK", level = 9, },
	["Controlar Demônio"] = 	{ class = "WARLOCK", level = 10, },
	["Funil de Vida"] = 		{ class = "WARLOCK", level = 11, },
	["Medo"] = 					{ class = "WARLOCK", level = 14, },
	["Sono"] = 					{ class = "WARLOCK", level = 14, }, -- Dark Apotheosis Ability
	["Conversão de Vida"] = 	{ class = "WARLOCK", level = 16, },
	["Maldição de Enfraquecimento"] = { class = "WARLOCK", level = 17, },
	["Pedra da Alma"] = 		{ class = "WARLOCK", level = 18, },
	["Evocar Súcubo"] = 		{ class = "WARLOCK", level = 20, },
	["Olho de Kilrogg"] = 		{ class = "WARLOCK", level = 22, },
	["Fôlego Interminável"] = 	{ class = "WARLOCK", level = 24, },
	["Colheita de Almas"] = 	{ class = "WARLOCK", level = 27, },
	["Evocar Caçador Vil"] = 	{ class = "WARLOCK", level = 29, },
	["Uivo do Terror"] = 		{ class = "WARLOCK", level = 30, }, --Added in Patch 5.4 
	["Escravizar Demônio"] = 	{ class = "WARLOCK", level = 31, },
	["Banir"] = 				{ class = "WARLOCK", level = 32, },
	["Proteção do Crepúsculo"] = { class = "WARLOCK", level = 34, },
	["Proteção da Fúria"] = 	{ class = "WARLOCK", level = 34, }, -- Dark Apotheosis Ability
	["Armadura Vil"] = 			{ class = "WARLOCK", level = 38, },
	["Ritual de Evocação"] = 	{ class = "WARLOCK", level = 42, },
	["Evocar Infernal"] = 		{ class = "WARLOCK", level = 49, },
	["Etermancia"] = 			{ class = "WARLOCK", level = 50, },
	["Maldição dos Elementos"] = { class = "WARLOCK", level = 51, },
	["Comandar Demônio"] = 		{ class = "WARLOCK", level = 56, },
	["Evocar Demonarca"] = 		{ class = "WARLOCK", level = 58, },
	["Determinação Interminável"] = { class = "WARLOCK", level = 64, },
	["Abalo Anímico"] = 		{ class = "WARLOCK", level = 66, },
	["Provocação"] = 			{ class = "WARLOCK", level = 66, }, -- Dark Apotheosis Ability
	["Criar Poço das Almas"] = 	{ class = "WARLOCK", level = 68, },
	["Círculo Demoníaco: Evocação"] = { class = "WARLOCK", level = 76, },
	["Círculo Demoníaco: Teleporte"] = { class = "WARLOCK", level = 76, },
	["Chama Vil"] = 			{ class = "WARLOCK", level = 77, },
	["Intenção Sombria"] = 		{ class = "WARLOCK", level = 82, },
	["Portal Demoníaco"] = 		{ class = "WARLOCK", level = 87, },
	["Pandemia"] = 				{ class = "WARLOCK", level = 90, }, 
	--++ Glyph Abilities ++
	["Apoteose Negra"] = 		{ class = "WARLOCK", level = 25, },
	["Enxame de Diabretes"] = 	{ class = "WARLOCK", level = 25, },
--++ Warlock Specialization ++
	--++ Affliction/Destruction ++
	["Chuva de Fogo"] = 		{ class = "WARLOCK", level = 21, },
	--++ Affliction ++
	["Agonia Instável"] = 		{ class = "WARLOCK", level = 10, },
	["Drenar Alma"] = 			{ class = "WARLOCK", level = 19, },
	["Queimadura Anímica"] = 	{ class = "WARLOCK", level = 19, },
	["Queimadura Anímica: Funil de Vida"] = { class = "WARLOCK", level = 27, },
	["Maldição da Exaustão"] = 	{ class = "WARLOCK", level = 32, },
	["Agonia"] = 				{ class = "WARLOCK", level = 36, },
	["Garra Maléfica"] = 		{ class = "WARLOCK", level = 42, },
	["Martelo do Ocaso"] = 		{ class = "WARLOCK", level = 54, },
	["Semente da Corrupção"] = 	{ class = "WARLOCK", level = 60, },
	["Possessão"] = 			{ class = "WARLOCK", level = 62, },
	["Queimadura Anímica: Semente da Corrupção"] = { class = "WARLOCK", level = 62, },
	["Medo Aprimorado"] = 		{ class = "WARLOCK", level = 69, },
	["Queimadura Anímica: Maldição"] = { class = "WARLOCK", level = 73, },
	["Trocar Almas"] = 			{ class = "WARLOCK", level = 79, },
	["Queimadura Anímica: Trocar Almas"] = { class = "WARLOCK", level = 79, },	
	["Suplícios Potentes"] = 	{ class = "WARLOCK", level = 80, },
	["Alma Negra: Padecimento"] = { class = "WARLOCK", level = 84, },
	["Queimadura Anímica: Círculo Demoníaco: Teleporte"] = { class = "WARLOCK", level = 86, },
	--++ Demonology ++
	["Fúria Demoníaca"] = 		{ class = "WARLOCK", level = 10, },
	["Metamorfose"] = 			{ class = "WARLOCK", level = 10, },
	["Salto Demoníaco"] = 		{ class = "WARLOCK", level = 12, },
	["Fogo d'Alma"] = 			{ class = "WARLOCK", level = 13, },
	["Mão de Gul'dan"] = 		{ class = "WARLOCK", level = 19, },
	["Fogo do Inferno"] = 		{ class = "WARLOCK", level = 22, },
	["Metamorfose: Toque do Caos"] = { class = "WARLOCK", level = 25, },
	["Placa de Éter"] = 		{ class = "WARLOCK", level = 27, },
	["Diabretes Selvagens"] = 	{ class = "WARLOCK", level = 32, },
	["Metamorfose: Ruína"] = 	{ class = "WARLOCK", level = 36, },
	["Evocar Guarda Vil"] = 	{ class = "WARLOCK", level = 42, },
	["Enxame Carniceiro"] = 	{ class = "WARLOCK", level = 47, },
	["Renascimento Demoníaco"] = { class = "WARLOCK", level = 54, },
	["Metamorfose: Aura de Imolação"] = { class = "WARLOCK", level = 62, },
	["Metamorfose: Auras Malditas"] = { class = "WARLOCK", level = 67, },
	["Núcleo Derretido"] = 		{ class = "WARLOCK", level = 69, },
	["Dizimação"] = 			{ class = "WARLOCK", level = 73, },
	["Metamorfose: Onda de Caos"] = { class = "WARLOCK", level = 79, },
	["Mestre Demonologista"] = 	{ class = "WARLOCK", level = 80, },
	["Alma Negra: Conhecimento"] = { class = "WARLOCK", level = 84, },
	["Metamorfose: Raio do Caos"] = { class = "WARLOCK", level = 85, },
	--++ Destruction ++
	["Energia Caótica"] = 		{ class = "WARLOCK", level = 10, },
	["Conflagrar"] = 			{ class = "WARLOCK", level = 10, },
	["Incinerar"] = 			{ class = "WARLOCK", level = 10, },
	["Imolação"] = 				{ class = "WARLOCK", level = 12, },
	["Reação"] = 				{ class = "WARLOCK", level = 32, },
	["Devastação"] = 			{ class = "WARLOCK", level = 36, },
	["Seta do Caos"] = 			{ class = "WARLOCK", level = 42, },
	["Transfusão de Brasas"] = 	{ class = "WARLOCK", level = 42, },
	["Brasas Ardentes"] = 		{ class = "WARLOCK", level = 42, },
	["Sombra Ardente"] = 		{ class = "WARLOCK", level = 47, },
	["Fogo e Enxofre"] = 		{ class = "WARLOCK", level = 54, },
	["Consequência"] = 			{ class = "WARLOCK", level = 54, },
	["Ignição Explosiva"] = 	{ class = "WARLOCK", level = 69, },
	["Chamas de Xoroth"] = 		{ class = "WARLOCK", level = 79, },
	["Tempestade Incandescente"] = { class = "WARLOCK", level = 80, },
	["Alma Negra: Instabilidade"] = { class = "WARLOCK", level = 84, },
	["Piroclasma"] = 			{ class = "WARLOCK", level = 86, },
--++ Warlock Talents ++
	["Regeneração Sombria"] = 	{ class = "WARLOCK", level = 15, },
	["Colher Vida"] = 			{ class = "WARLOCK", level = 15, },
	["Sorvo de Alma"] = 		{ class = "WARLOCK", level = 15, }, 
--	["Howl of Terror"] = 		{ class = "WARLOCK", level = 30, }, --Removed in Patch 5.4
	["Sopro Demoníaco"] = 		{ class = "WARLOCK", level = 30, }, --Added in Patch 5.4
	["Espiral da Morte"] = 		{ class = "WARLOCK", level = 30, },
	["Fúria Sombria"] = 		{ class = "WARLOCK", level = 30, }, 
	["Vínculo Anímico"] = 		{ class = "WARLOCK", level = 45, },
	["Pacto Sacrificial"] = 	{ class = "WARLOCK", level = 45, },
	["Barganha Sombria"] = 		{ class = "WARLOCK", level = 45, }, 
	["Terror de Sangue"] = 		{ class = "WARLOCK", level = 60, },
	["Impulso Ardente"] = 		{ class = "WARLOCK", level = 60, },
	["Livre Vontade"] = 		{ class = "WARLOCK", level = 60, }, 
	["Grimório de Supremacia"] = { class = "WARLOCK", level = 75, },
	["Grimório do Serviço"] = 	{ class = "WARLOCK", level = 75, },
	["Grimório de Sacrificar"] = { class = "WARLOCK", level = 75, }, 
--	["Archimonde's Vengeance"] = { class = "WARLOCK", level = 90, }, --Removed in Patch 5.4
	["Trevas de Arquimonde"] = 	{ class = "WARLOCK", level = 90, }, --Removed in Patch 5.4
	["Astúcia de Kil’jaeden"] = { class = "WARLOCK", level = 90, },
	["Fúria de Mannoroth"] = 	{ class = "WARLOCK", level = 90, }, 

--++ Warrior Abilities ++
	["Postura de Batalha"] = 	{ class = "WARRIOR", level = 1, },
	["Golpe Heroico"] = 		{ class = "WARRIOR", level = 1, },
	["Investida"] = 			{ class = "WARRIOR", level = 3, },
	["Ímpeto da Vitória"] = 	{ class = "WARRIOR", level = 5, },
	["Executar"] = 				{ class = "WARRIOR", level = 7, },
	["Postura de Defesa"] = 	{ class = "WARRIOR", level = 9, },
	["Provocar"] = 				{ class = "WARRIOR", level = 12, },
	["Enfurecer"] = 			{ class = "WARRIOR", level = 14, },
	["Fender Armadura"] = 		{ class = "WARRIOR", level = 16, },
	["Trovoada"] = 				{ class = "WARRIOR", level = 20, },
	["Arremesso Heroico"] = 	{ class = "WARRIOR", level = 22, },
	["Murro"] = 				{ class = "WARRIOR", level = 24, },
	["Desarmar"] = 				{ class = "WARRIOR", level = 28, },
	["Feridas Profundas"] = 	{ class = "WARRIOR", level = 32, },
	["Postura de Berserker"] = 	{ class = "WARRIOR", level = 34, },
	["Cortar Tendão"] = 		{ class = "WARRIOR", level = 36, },
	["Brado de Batalha"] = 		{ class = "WARRIOR", level = 42, },
	["Cutilada"] = 				{ class = "WARRIOR", level = 44, },
	["Muralha de Escudos"] = 	{ class = "WARRIOR", level = 48, },
--	["Especialização em Armadura de Placas"] = 	{ class = "WARRIOR", level = 50, },
	["Brado Intimidador"] = 	{ class = "WARRIOR", level = 52, },
	["Raiva Incontrolada"] = 	{ class = "WARRIOR", level = 54, },
	["Temeridade"] = 			{ class = "WARRIOR", level = 62, },
--	["Deadly Calm"] = 			{ class = "WARRIOR", level = 62, },
	["Reflexão de Feitiço"] = 	{ class = "WARRIOR", level = 66, },
	["Brado de Comando"] = 		{ class = "WARRIOR", level = 68, },
	["Comprar Briga"] = 		{ class = "WARRIOR", level = 72, },
	["Arremesso Estilhaçante"] = { class = "WARRIOR", level = 74, },
--	["Ripsote"] = 				{ class = "WARRIOR", level = 76, }, --Added in Patch 5.4 but not activated since Death Knights also have this ability
	["Brado de Convocação"] = 	{ class = "WARRIOR", level = 83, },
	["Salto Heroico"] = 		{ class = "WARRIOR", level = 85, },
	["Estandarte Desmoralizante"] = { class = "WARRIOR", level = 87, },
	["Estandarte Zombeteiro"] = { class = "WARRIOR", level = 87, },
	["Estandarte da Caveira"] = { class = "WARRIOR", level = 87, },
--	["Estandarte de Guerra"] = 	{ class = "WARRIOR", level = 87, },
--++ Warrior Specialization ++
	--++ Arms/Fury ++
	["Redemoinho"] = 			{ class = "WARRIOR", level = 26, },
	["Morte pela Espada"] = 	{ class = "WARRIOR", level = 56, },
	["Ira Descontrolada"] = 	{ class = "WARRIOR", level = 56, }, 
	["Golpe Colossal"] = 		{ class = "WARRIOR", level = 81, },
	--++ Arms/Protection ++	
	["Sangue e Trovão"] = 		{ class = "WARRIOR", level = 46, },
	--++ Arms ++
	["Golpe Mortal"] = 			{ class = "WARRIOR", level = 10, },
	["Veterano de Guerra"] = 	{ class = "WARRIOR", level = 10, },
	["Batida"] = 				{ class = "WARRIOR", level = 18, },
	["Subjugar"] = 				{ class = "WARRIOR", level = 30, },
	["Apetite por Sangue"] = 	{ class = "WARRIOR", level = 30, },
	["Golpes a Esmo"] = 		{ class = "WARRIOR", level = 60, },
	["Golpes da Oportunidade"] = { class = "WARRIOR", level = 80, },
	["Morte Súbita"] = 			{ class = "WARRIOR", level = 81, },
	--++ Fury ++
	["Sede de Sangue"] = 		{ class = "WARRIOR", level = 10, },
	["Berserker Enlouquecido"] = { class = "WARRIOR", level = 10, },
	["Golpe Selvagem"] = 		{ class = "WARRIOR", level = 18, },
	["Golpe Furioso"] = 		{ class = "WARRIOR", level = 30, },
	["Punhos de Titã"] = 		{ class = "WARRIOR", level = 38, },
	["Fúria Obcecada"] = 		{ class = "WARRIOR", level = 38, },
	["Onda de Sangue"] = 		{ class = "WARRIOR", level = 50, },
	["Cutelo de Carne"] = 		{ class = "WARRIOR", level = 58, },
	["Ímpeto"] = 				{ class = "WARRIOR", level = 60, },
	["Fúria Desagrilhoada"] = 	{ class = "WARRIOR", level = 80, },
	--++ Protection ++  
	["Escudada"] = 				{ class = "WARRIOR", level = 10, },
	["Sentinela Resoluta"] = 	{ class = "WARRIOR", level = 10, },
	["Vingança"] = 				{ class = "WARRIOR", level = 10, },
	["Levantar Escudo"] = 		{ class = "WARRIOR", level = 18, },
	["Devastar"] = 				{ class = "WARRIOR", level = 26, },
	["Revanche"] = 				{ class = "WARRIOR", level = 30, },
	["Último Recurso"] = 		{ class = "WARRIOR", level = 38, },
--	["Especialização em Armadura de Placas"] = { class = "WARRIOR", level = 50, },
	["Espada e Escudo"] = 		{ class = "WARRIOR", level = 50, },
	["Brado Desmoralizador"] = 	{ class = "WARRIOR", level = 56, },
	["Ultimato"] = 				{ class = "WARRIOR", level = 58, },
	["Bastião da Defesa"] = 	{ class = "WARRIOR", level = 60, },
	["Bloqueio Crítico"] = 		{ class = "WARRIOR", level = 80, },
	["Barreira de Escudos"] = 	{ class = "WARRIOR", level = 81, },
	--++ Warrior Talents ++
	["Implacável"] = 			{ class = "WARRIOR", level = 15, },
	["Dose Dupla"] = 			{ class = "WARRIOR", level = 15, },
	["Armipotente"] = 			{ class = "WARRIOR", level = 15, }, 
	["Regeneração Enfurecida"] = { class = "WARRIOR", level = 30, },
	["Fôlego Renovado"] = 		{ class = "WARRIOR", level = 30, },
	["Vitória Iminente"] = 		{ class = "WARRIOR", level = 30, }, 
	["Brado Estarrecedor"] = 	{ class = "WARRIOR", level = 45, },
	["Uivo Perfurante"] = 		{ class = "WARRIOR", level = 45, },
	["Brado Interruptivo"] = 	{ class = "WARRIOR", level = 45, },
	["Tornado de Aço"] = 		{ class = "WARRIOR", level = 60, },
	["Onda de Choque"] = 		{ class = "WARRIOR", level = 60, },
	["Rugido do Dragão"] = 		{ class = "WARRIOR", level = 60, }, 
	["Reflexão de Feitiço em Massa"] = { class = "WARRIOR", level = 75, },
	["Salvaguarda"] = 			{ class = "WARRIOR", level = 75, },
	["Vigilância"] = 			{ class = "WARRIOR", level = 75, }, 
	["Avatar"] = 				{ class = "WARRIOR", level = 90, },
	["Banho de Sangue"] = 		{ class = "WARRIOR", level = 90, },
	["Seta Tempestuosa"] = 		{ class = "WARRIOR", level = 90, }, 
};
