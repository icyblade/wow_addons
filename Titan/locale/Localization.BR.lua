local L = LibStub("AceLocale-3.0"):NewLocale("Titan","ptBR")
if not L then return end

L["TITAN_PANEL"] = "Painel Titan";
local TITAN_PANEL = "Painel Titan";
L["TITAN_DEBUG"] = "<Titan>";
L["TITAN_PRINT"] = "Titan";

L["TITAN_NA"] = "N/A";
L["TITAN_SECONDS"] = "segundos";
L["TITAN_MINUTES"] = "minutos";
L["TITAN_HOURS"] = "horas";
L["TITAN_DAYS"] = "dias";
L["TITAN_SECONDS_ABBR"] = "s";
L["TITAN_MINUTES_ABBR"] = "min";
L["TITAN_HOURS_ABBR"] = "h";
L["TITAN_DAYS_ABBR"] = "d";
L["TITAN_MILLISECOND"] = "ms";
L["TITAN_KILOBYTES_PER_SECOND"] = "kB/s";
L["TITAN_KILOBITS_PER_SECOND"] = "kbps"
L["TITAN_MEGABYTE"] = "MB";
L["TITAN_NONE"] = "Nenhum";
L["TITAN_USE_COMMA"] = "Use vírgula";
L["TITAN_USE_PERIOD"] = "Use ponto";

L["TITAN_PANEL_ERROR_PROF_DELCURRENT"] = "Você não pode apagar seu perfil atual.";
local TITAN_PANEL_WARNING = GREEN_FONT_COLOR_CODE.."Atenção : "..FONT_COLOR_CODE_CLOSE
local TITAN_PANEL_RELOAD_TEXT = "Se você deseja continuar com esta operação, aperte 'Aceitar' (sua IU irá recarregar), de outra forma aperte 'Cancelar'ou a tecla 'Esc'."
L["TITAN_PANEL_RESET_WARNING"] = TITAN_PANEL_WARNING
	.."Esta configuração irá resetar sua(s) barra(s) e configurações do "..TITAN_PANEL.." para valores padrão e irá recriar seu perfil. "
	..TITAN_PANEL_RELOAD_TEXT
L["TITAN_PANEL_RELOAD"] = TITAN_PANEL_WARNING
	.."This will reload "..TITAN_PANEL..". "
	..TITAN_PANEL_RELOAD_TEXT
L["TITAN_PANEL_ATTEMPTS"] = TITAN_PANEL.." Tentativas"
L["TITAN_PANEL_ATTEMPTS_SHORT"] = "Tentativas"
L["TITAN_PANEL_ATTEMPTS_DESC"] = "O plugin abaixo requisitou ser registrado com o "..TITAN_PANEL..".\n"
	.. "Por favor mande quaisquer problemas para o autor do plugin."
L["TITAN_PANEL_ATTEMPTS_TYPE"] = "Tipo"
L["TITAN_PANEL_ATTEMPTS_CATEGORY"] = "Categoria"
L["TITAN_PANEL_ATTEMPTS_BUTTON"] = "Nome do Botão"
L["TITAN_PANEL_ATTEMPTS_STATUS"] = "Status"
L["TITAN_PANEL_ATTEMPTS_ISSUE"] = "Problema"
L["TITAN_PANEL_EXTRAS"] = "Extras do " .. TITAN_PANEL
L["TITAN_PANEL_ATTEMPTS_NOTES"] = "Notas"
L["TITAN_PANEL_ATTEMPTS_TABLE"] = "Índice de tabela"
L["TITAN_PANEL_EXTRAS_SHORT"] = "Extras"
L["TITAN_PANEL_EXTRAS_DESC"] = "Esss plugins não estão com dados de configuração carregados no momento.\n"
	.. "Esses são seguros para excluir."
L["TITAN_PANEL_EXTRAS_DELETE_BUTTON"] = "Apagar dados de configuração"
L["TITAN_PANEL_EXTRAS_DELETE_MSG"] = "Entrada de configuração foi removida."
L["TITAN_PANEL_CHARS"] = "Personagens"
L["TITAN_PANEL_CHARS_DESC"] = "Estes são os personagens com dados de configuração."
L["TITAN_PANEL_REGISTER_START"] = "Registrando plugins do " .. TITAN_PANEL;
L["TITAN_PANEL_REGISTER_END"] = "Processo de registro feito."

-- slash command help
L["TITAN_PANEL_SLASH_RESET_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."Uso: |cffffffff/titan {reset | reseta tipfont/tipalpha/panelscale/spacing}";
L["TITAN_PANEL_SLASH_RESET_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset: |cffffffffReseta o "..TITAN_PANEL.." para os valores/posições padrão.";
L["TITAN_PANEL_SLASH_RESET_2"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset tipfont: |cffffffffReseta a escala de fonte de dica do "..TITAN_PANEL.." para o padrão.";
L["TITAN_PANEL_SLASH_RESET_3"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset tipalpha: |cffffffffReseta a transparência de dica do "..TITAN_PANEL.." para o padrão.";
L["TITAN_PANEL_SLASH_RESET_4"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset panelscale: |cffffffffReseta a escala do "..TITAN_PANEL.." para o padrão.";
L["TITAN_PANEL_SLASH_RESET_5"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset spacing: |cffffffffReseta o espaçamento do botão do "..TITAN_PANEL.." para o padrão.";
L["TITAN_PANEL_SLASH_GUI_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."Usage: |cffffffff/titan {gui control/trans/skin}";
L["TITAN_PANEL_SLASH_GUI_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."gui control: |cffffffffAbre a janela de controle do "..TITAN_PANEL.."";
L["TITAN_PANEL_SLASH_GUI_2"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."gui trans: |cffffffffAbre a janela de controle de transparência";
L["TITAN_PANEL_SLASH_GUI_3"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."gui skin: |cffffffffAbre a janela de controle de Pele";
L["TITAN_PANEL_SLASH_PROFILE_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."Usage: |cffffffff/titan {profile use <profile>}";
L["TITAN_PANEL_SLASH_PROFILE_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."profile use <name> <server>: |cffffffffConfigura o perfil para o perfil salvo requisitado.";
L["TITAN_PANEL_SLASH_PROFILE_2"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."<name>: |cffffffffpode ser tanto o nome do personagem quanto o nome do perfil personalizado."
L["TITAN_PANEL_SLASH_PROFILE_3"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."<server>: |cffffffffpode ser tanto o nome do servidor quanto 'TitanCustomProfile'."
L["TITAN_PANEL_SLASH_SILENT_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."Uso: |cffffffff/titan {silent}";
L["TITAN_PANEL_SLASH_SILENT_1"] = LIGHTYELLOW_FONT_COLOR_CODE.."silent: |cffffffffAlterna o "..TITAN_PANEL.." para carregar silencioamente.";
L["TITAN_PANEL_SLASH_HELP_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."Uso: |cffffffff/titan {help | help <topic>}";
L["TITAN_PANEL_SLASH_HELP_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."<topic>: reset/gui/profile/silent/help ";
L["TITAN_PANEL_SLASH_ALL_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."Usage: |cffffffff/titan <topic>";
L["TITAN_PANEL_SLASH_ALL_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."<topic>: |cffffffffreset/gui/profile/silent/help ";

-- slash command responses
L["TITAN_PANEL_SLASH_RESP1"] = LIGHTYELLOW_FONT_COLOR_CODE..TITAN_PANEL.." escala de fonte de dica resetada.";
L["TITAN_PANEL_SLASH_RESP2"] = LIGHTYELLOW_FONT_COLOR_CODE..TITAN_PANEL.." transparência de dica resetada.";
L["TITAN_PANEL_SLASH_RESP3"] = LIGHTYELLOW_FONT_COLOR_CODE..TITAN_PANEL.." escala resetada.";
L["TITAN_PANEL_SLASH_RESP4"] = LIGHTYELLOW_FONT_COLOR_CODE..TITAN_PANEL.." espaçamento de botão resetado.";

-- global profile locale
L["TITAN_PANEL_GLOBAL"] = "Global";
L["TITAN_PANEL_GLOBAL_PROFILE"] = "Perfil Global";
L["TITAN_PANEL_GLOBAL_USE"] = "Usar Perfil Global";
L["TITAN_PANEL_GLOBAL_USE_AS"] = "Usar como Perfil Global";
L["TITAN_PANEL_GLOBAL_USE_DESC"] = "Usar um perfil global para todos os personagens";
L["TITAN_PANEL_GLOBAL_RESET_PART"] = "resetando opções";
L["TITAN_PANEL_GLOBAL_ERR_1"] = "Você não pode carregar um perfil quando um perfil global está em uso";
-- general panel locale
L["TITAN_PANEL_VERSION_INFO"] = "|cffffd700 pelo Time de Desenvolvimento do |cffff8c00"..TITAN_PANEL;
L["TITAN_PANEL_MENU_TITLE"] = TITAN_PANEL;
L["TITAN_PANEL_MENU_HIDE"] = "Ocultar ";
L["TITAN_PANEL_MENU_IN_COMBAT_LOCKDOWN"] = "(Em Combate)";
L["TITAN_PANEL_MENU_RELOADUI"] = "(Recarregar IU)";
L["TITAN_PANEL_MENU_SHOW_COLORED_TEXT"] = "Exibir Texto Colorido";
L["TITAN_PANEL_MENU_SHOW_ICON"] = "Exibir Ícone";
L["TITAN_PANEL_MENU_SHOW_LABEL_TEXT"] = "Exibir Texto de Rótulo";
L["TITAN_PANEL_MENU_AUTOHIDE"] = "Ocultar Automaticamente";
L["TITAN_PANEL_MENU_CENTER_TEXT"] = "Centralizar Texto";
L["TITAN_PANEL_MENU_DISPLAY_BAR"] = "Exibir Barra";
L["TITAN_PANEL_MENU_DISABLE_PUSH"] = "Desativar Ajuste de Tela";
L["TITAN_PANEL_MENU_DISABLE_MINIMAP_PUSH"] = "Desativar Ajuste de Mini-mapa";
L["TITAN_PANEL_MENU_DISABLE_LOGS"] = "Ajuste Automático de Log";
L["TITAN_PANEL_MENU_DISABLE_BAGS"] = "Ajuste Automático de Mochila";
L["TITAN_PANEL_MENU_DISABLE_TICKET"] = "Ajuste Automático do Quadro de Ticket";
L["TITAN_PANEL_MENU_PROFILES"] = "Perfis";
L["TITAN_PANEL_MENU_PROFILE"] = "Perfil ";
L["TITAN_PANEL_MENU_PROFILE_CUSTOM"] = "Personalizado";
L["TITAN_PANEL_MENU_PROFILE_DELETED"] = " foi apagado.";
L["TITAN_PANEL_MENU_PROFILE_SERVERS"] = "Reino";
L["TITAN_PANEL_MENU_PROFILE_CHARS"] = "Personagem";


L["TITAN_PANEL_MENU_PROFILE_RELOADUI"] = "Sua UI será recarregada quando o botão 'Ok' for apertado, permitindo que seu perfil personalizado seja salvo.";
L["TITAN_PANEL_MENU_PROFILE_SAVE_CUSTOM_TITLE"] = "Digite um nome para seu perfil personalizado:\n(máximo 20 caracteres, espaços não são permitidos, maíusculas e minúsculas)";
L["TITAN_PANEL_MENU_PROFILE_SAVE_PENDING"] = "Configurações atuais serão salvas no perfil de nome: ";
L["TITAN_PANEL_MENU_PROFILE_ALREADY_EXISTS"] = "O nome de perfil digitado já existe. Você tem certeza que quer sobrescrevê-lo? Aperte 'Aceitar' se sim, de outra maneira aperte 'Cancelar' ou a tecla 'Esc'.";
L["TITAN_PANEL_MENU_MANAGE_SETTINGS"] = "Gerenciar";
L["TITAN_PANEL_MENU_LOAD_SETTINGS"] = "Carregar";
L["TITAN_PANEL_MENU_DELETE_SETTINGS"] = "Apagar";
L["TITAN_PANEL_MENU_SAVE_SETTINGS"] = "Salvar";
L["TITAN_PANEL_MENU_CONFIGURATION"] = "Configuração";
L["TITAN_PANEL_OPTIONS"] = "Opções";
L["TITAN_PANEL_MENU_TOP"] = "Superior"
L["TITAN_PANEL_MENU_TOP2"] = "Superior 2"
L["TITAN_PANEL_MENU_BOTTOM"] = "Inferior"
L["TITAN_PANEL_MENU_BOTTOM2"] = "Interior 2"
L["TITAN_PANEL_MENU_OPTIONS"] = "Dicas e Quadros do " .. TITAN_PANEL .."";
L["TITAN_PANEL_MENU_OPTIONS_SHORT"] = "Dicas e Quadros";
L["TITAN_PANEL_MENU_TOP_BARS"] = "Barras Superiores"
L["TITAN_PANEL_MENU_BOTTOM_BARS"] = "Barras Inferiores"
L["TITAN_PANEL_MENU_OPTIONS_BARS"] = "Barras"
L["TITAN_PANEL_MENU_OPTIONS_MAIN_BARS"] = "Barras Superiores do " .. TITAN_PANEL;
L["TITAN_PANEL_MENU_OPTIONS_AUX_BARS"] = "Barras Inferiores do " .. TITAN_PANEL;
L["TITAN_PANEL_MENU_OPTIONS_TOOLTIPS"] = "Dicas";
L["TITAN_PANEL_MENU_OPTIONS_FRAMES"] = "Quadros";
L["TITAN_PANEL_MENU_PLUGINS"] = "Plugins";
L["TITAN_PANEL_MENU_LOCK_BUTTONS"] = "Trancar Botões";
L["TITAN_PANEL_MENU_VERSION_SHOWN"] = "Exibir Versões dos Plugins";
L["TITAN_PANEL_MENU_LDB_SIDE"] = "Plugin no Lado Direito";
L["TITAN_PANEL_MENU_LDB_FORCE_LAUNCHER"] = "Força os LDB Launchers para o Lado Direito";
L["TITAN_PANEL_MENU_CATEGORIES"] = {"Incorporados","Geral","Combate","Informação","Interface","Profissão"}
L["TITAN_PANEL_MENU_TOOLTIPS_SHOWN"] = "Exibir Dicas";
L["TITAN_PANEL_MENU_TOOLTIPS_SHOWN_IN_COMBAT"] = "Ocultar Dicas em Combate";

L["TITAN_PANEL_MENU_AUTOHIDE_IN_COMBAT"] = "Trancar auto-Ocultar barras quando em combate";
L["TITAN_PANEL_MENU_RESET"] = "Resetar o " .. TITAN_PANEL .. " para os Padrões";
L["TITAN_PANEL_MENU_TEXTURE_SETTINGS"] = "Peles";     
L["TITAN_PANEL_MENU_LSM_FONTS"] = "Painel de Fontes"
L["TITAN_PANEL_MENU_ENABLED"] = "Ativado";
L["TITAN_PANEL_MENU_DISABLED"] = "Desativado";
L["TITAN_PANEL_SHIFT_LEFT"] = "Mover a Esquerda";
L["TITAN_PANEL_SHIFT_RIGHT"] = "Mover a Direita";
L["TITAN_PANEL_MENU_SHOW_PLUGIN_TEXT"] = "Exibir Texto do Plugin";
L["TITAN_PANEL_MENU_BAR_ALWAYS"] = "Sempre Ativado";
L["TITAN_PANEL_MENU_POSITION"] = "Posição";
L["TITAN_PANEL_MENU_BAR"] = "Barra";
L["TITAN_PANEL_MENU_DISPLAY_ON_BAR"] = "Escolha em qual barra o plugin é exibido";
L["TITAN_PANEL_MENU_SHOW"] = "Exibir Plugin";
L["TITAN_PANEL_MENU_PLUGIN_RESET"] = "Atualizar Plugins";
L["TITAN_PANEL_MENU_PLUGIN_RESET_DESC"] = "Atualizar Texto e Posição do Plugin";
L["TITAN_PANEL_MENU_SILENT_LOAD"] = "Carregament Silencioso";

-- localization strings for AceConfigDialog-3.0
L["TITAN_ABOUT_VERSION"] = "Versão";
L["TITAN_ABOUT_AUTHOR"] = "Autor";
L["TITAN_ABOUT_CREDITS"] = "Créditos";
L["TITAN_ABOUT_CATEGORY"] = "Categoria";
L["TITAN_ABOUT_EMAIL"] = "E-mail";
L["TITAN_ABOUT_WEB"] = "Website";
L["TITAN_ABOUT_LICENSE"] = "Licença";
L["TITAN_PANEL_CONFIG_MAIN_LABEL"] = "Addon de barra de exibição de informações. Permite que usuários adicionem alimentação de dados ou lançadores de plugins num painel de controle colocado acima ou abaixo da tela.";
L["TITAN_TRANS_MENU_TEXT"] = "Transparência do " .. TITAN_PANEL;
L["TITAN_TRANS_MENU_TEXT_SHORT"] = "Transparência";
L["TITAN_TRANS_MENU_DESC"] = "Ajustar transparência para barras e dicas do "..TITAN_PANEL.." ";
L["TITAN_TRANS_MAIN_CONTROL_TITLE"] = "Barra Principal";
L["TITAN_TRANS_AUX_CONTROL_TITLE"] = "Barra Auxiliar";
L["TITAN_TRANS_CONTROL_TITLE_TOOLTIP"] = "Dica";
L["TITAN_TRANS_TOOLTIP_DESC"] = "Configura a transparência para as dicas de diversos plugins.";
L["TITAN_UISCALE_MENU_TEXT"] = "Escala e Fonte do " .. TITAN_PANEL;
L["TITAN_UISCALE_MENU_TEXT_SHORT"] = "Escala e Fonte";
L["TITAN_UISCALE_CONTROL_TITLE_UI"] = "Escala da IU";
L["TITAN_UISCALE_CONTROL_TITLE_PANEL"] = "Escala do " .. TITAN_PANEL;
L["TITAN_UISCALE_CONTROL_TITLE_BUTTON"] = "Espaçamento de Botões";
L["TITAN_UISCALE_CONTROL_TITLE_ICON"] = "Espaçamento de Ícones";
L["TITAN_UISCALE_CONTROL_TOOLTIP_TOOLTIPFONT"] = "Escala da Fonte de Dica";
L["TITAN_UISCALE_TOOLTIP_DISABLE_TEXT"] = "Desativar Escala da Fonte de Dica";
L["TITAN_UISCALE_MENU_DESC"] = "Controla vários aspectos da IU e "..TITAN_PANEL..".";
L["TITAN_UISCALE_SLIDER_DESC"] = "Define a escala de toda a sua IU.";
L["TITAN_UISCALE_PANEL_SLIDER_DESC"] = "Define a escala para os diversos botões e ícones do "..TITAN_PANEL.." ";
L["TITAN_UISCALE_BUTTON_SLIDER_DESC"] = "Adjusts the space between left-side plugins.";
L["TITAN_UISCALE_ICON_SLIDER_DESC"] = "Adjusts the space between right-side plugins.";
L["TITAN_UISCALE_TOOLTIP_SLIDER_DESC"] = "Adjusts the scale for the tooltip of the various plugins.";
L["TITAN_UISCALE_DISABLE_TOOLTIP_DESC"] = "Disables "..TITAN_PANEL.." Tooltip Font Scale Control.";

L["TITAN_SKINS_TITLE"] = "Skins " .. TITAN_PANEL;
L["TITAN_SKINS_OPTIONS_CUSTOM"] = "Skins - Personalizado";
L["TITAN_SKINS_TITLE_CUSTOM"] = "Skins Personalizadas do " .. TITAN_PANEL;
L["TITAN_SKINS_MAIN_DESC"] = "All custom skins are assumed to be in: \n"
			.."..\\AddOns\\Titan\\Artwork\\Custom\\<Skin Folder>\\ ".."\n"
			.."\n"..TITAN_PANEL.." and custom skins are stored under the Custom folder."
L["TITAN_SKINS_LIST_TITLE"] = "Skin List";
L["TITAN_SKINS_SET_DESC"] = "Select a skin for the "..TITAN_PANEL.." bars.";
L["TITAN_SKINS_SET_HEADER"] = "Set "..TITAN_PANEL.." Skin";
L["TITAN_SKINS_RESET_HEADER"] = "Reset "..TITAN_PANEL.." Skins";
L["TITAN_SKINS_NEW_HEADER"] = "Add New Skin";
L["TITAN_SKINS_NAME_TITLE"] = "Skin Name"
L["TITAN_SKINS_NAME_DESC"] = "Enter a name for your new skin. It will be used in the skin dropdown lists.";
L["TITAN_SKINS_PATH_TITLE"] = "<Skin Folder>"
L["TITAN_SKINS_PATH_DESC"] = "<Skin Folder> under the "..TITAN_PANEL.." install. See the example above." 
L["TITAN_SKINS_ADD_HEADER"] = "Add Skin";
L["TITAN_SKINS_ADD_DESC"] = "Adds a new skin to the list of available skins for "..TITAN_PANEL..".";
L["TITAN_SKINS_REMOVE_HEADER"] = "Remove Skin";
L["TITAN_SKINS_REMOVE_DESC"] = "Select a custom skin to remove."
L["TITAN_SKINS_REMOVE_BUTTON"] = "Remove";
L["TITAN_SKINS_REMOVE_BUTTON_DESC"] = "Removes the selected custom skin.";
L["TITAN_SKINS_REMOVE_NOTES"] = "You are responsible for removing any unwanted custom skins "
	.."from the "..TITAN_PANEL.." install folder. Addons can not add or remove files."
L["TITAN_SKINS_RESET_DEFAULTS_TITLE"] = "Reset to Defaults";
L["TITAN_SKINS_RESET_DEFAULTS_DESC"] = "Resets the skin list to the default "..TITAN_PANEL.." skins.";
L["TITAN_PANEL_MENU_LSM_FONTS_DESC"] = "Select the font type for the various plugins on the "..TITAN_PANEL.." Bars.";
L["TITAN_PANEL_MENU_FONT_SIZE"] = "Font Size";
L["TITAN_PANEL_MENU_FONT_SIZE_DESC"] = "Sets the size for the "..TITAN_PANEL.." font.";
L["TITAN_PANEL_MENU_FRAME_STRATA"] = ""..TITAN_PANEL.." Frame Strata";
L["TITAN_PANEL_MENU_FRAME_STRATA_DESC"] = "Adjusts the frame strata for the "..TITAN_PANEL.." Bar(s).";
-- /end localization strings for AceConfigDialog-3.0

L["TITAN_PANEL_MENU_ADV"] = "Avançado";
L["TITAN_PANEL_MENU_ADV_DESC"] = "Change Timers only if you experience issues with frames not adjusting.".."\n";
L["TITAN_PANEL_MENU_ADV_PEW"] = "Entering World";
L["TITAN_PANEL_MENU_ADV_PEW_DESC"] = "Change value (usually increase) if frames do not adjust when entering / leaving world or an instance.";
L["TITAN_PANEL_MENU_ADV_VEHICLE"] = "Vehicle";
L["TITAN_PANEL_MENU_ADV_VEHICLE_DESC"] = "Change value (usually increase) if frames do not adjust when entering / leaving vehicle.";

L["TITAN_AUTOHIDE_TOOLTIP"] = "Toggles " .. TITAN_PANEL .. " auto-Ocultar on/off feature";

L["TITAN_BAG_FORMAT"] = "%d/%d";
L["TITAN_BAG_BUTTON_LABEL"] = "Bolsas: ";
L["TITAN_BAG_TOOLTIP"] = "Informações de Bolsas";
L["TITAN_BAG_TOOLTIP_HINTS"] = "Dica: Clique para abrir todas as bolsas.";
L["TITAN_BAG_MENU_TEXT"] = "Bolsa";
L["TITAN_BAG_USED_SLOTS"] = "Espaços Usados";
L["TITAN_BAG_FREE_SLOTS"] = "Espaços Vazios";
L["TITAN_BAG_BACKPACK"] = "Mochila";
L["TITAN_BAG_MENU_SHOW_USED_SLOTS"] = "Exibir Espaços Usados";
L["TITAN_BAG_MENU_SHOW_AVAILABLE_SLOTS"] = "Exibir Espaços Disponíveis";
L["TITAN_BAG_MENU_SHOW_DETAILED"] = "Exibir Tooltip Detalhada";
L["TITAN_BAG_MENU_IGNORE_SLOTS"] = "Ignorar Contêineres";
L["TITAN_BAG_MENU_IGNORE_PROF_BAGS_SLOTS"] = "Ignorar Bolsas de Profissão";

L["TITAN_BAG_PROF_BAG_ENCHANTING"] = {
"Saco de Magitrama Encantado", "Bolsa de Runatrama Encantada", "Algibeira do Encantador", "Grande Bolsa de Encantamentos", "Bolsa de Fogo Místico", 
"Bolsa Misteriosa", "Bolsa Sobrenatural", "Bolsa Tarde Encantadora - Exclusividade \"Lepos'Tiche\""};
L["TITAN_BAG_PROF_BAG_ENGINEERING"] = {
"Caixa de Ferramentas Pesada", "Caixa de Ferramentas de Ferrovil", "Caixa de Ferramentas de Titânico", "Caixa de Ferramentas de Elemêntio", "Bolsa de Alta Tecnologia - Linha \"Lepos'Tiche - Maddy\""};
L["TITAN_BAG_PROF_BAG_HERBALISM"] = {
"Bolsa de Herborismo", "Bolsa de Herborismo Cenariana", "Algibeira de Cenarius", "Sacola Botânica de Mika", "Bolsa Esmeralda", "Bolsa de Expedição Hyjal",
"Bolsa de Carga de Ervas - Linha \"Lepos'Tiche Esverdeada\""};
L["TITAN_BAG_PROF_BAG_INSCRIPTION"] = {
"Algibeira do Escriba", "Pacote de Bolsos Infinitos", "Mochila Escolar - Linha \"Lepos'Tiche - Xandera\"", "Algibeira do Escriba Real", "Burnished Inscription Bag"};
L["TITAN_BAG_PROF_BAG_JEWELCRAFTING"] = {
"Bolsa de Gemas", "Saco de Joias", "Amarra Cravejada de Gemas - Exclusividade \"Lepos'Tiche\"", "Bolsa de Gemas de Seda Luxuosa"};
L["TITAN_BAG_PROF_BAG_LEATHERWORKING"] = {
"Algibeira do Coureiro", "Bolsa de Muitos Pelegos", "Mala de Viagem do Coureador", "Bolsa de Couro \"Lepos'Tiche - Miya\"", "Burnished Leather Bag"};
L["TITAN_BAG_PROF_BAG_MINING"] = {
"Saco de Mineração", "Bolsa de Mineração Reforçada", "Bolsa de Mineração de Mamute", "Bolsa de Metal Precioso \"Lepos'Tiche - Christina\"", "Bolsa de Mineração Triplamente Reforçada", "Burnished Mining Bag"};
L["TITAN_BAG_PROF_BAG_FISHING"] = {"Caixa de Pesca do Mestre Anzol"};
L["TITAN_BAG_PROF_BAG_COOKING"] = {"Portable Refrigerator", "Advanced Refrigeration Unit"};

L["TITAN_CLOCK_TOOLTIP"] = "Relógio";
L["TITAN_CLOCK_TOOLTIP_VALUE"] = "Server Offset Hour Value: ";
L["TITAN_CLOCK_TOOLTIP_LOCAL_TIME"] = "Horário Local: ";
L["TITAN_CLOCK_TOOLTIP_SERVER_TIME"] = "Horário do Servidor: ";
L["TITAN_CLOCK_TOOLTIP_SERVER_ADJUSTED_TIME"] = "Horário Ajustado do Servidor: ";
L["TITAN_CLOCK_TOOLTIP_HINT1"] = "Hint: Left-click to adjust the offset hour"
L["TITAN_CLOCK_TOOLTIP_HINT2"] = "(server time only) and the 12/24H time format.";
L["TITAN_CLOCK_TOOLTIP_HINT3"] = "Shift Left-Click to toggle the Calendar on/off.";
L["TITAN_CLOCK_CONTROL_TOOLTIP"] = "Server Hour Offset: ";
L["TITAN_CLOCK_CONTROL_TITLE"] = "Offset";
L["TITAN_CLOCK_CONTROL_HIGH"] = "+12";
L["TITAN_CLOCK_CONTROL_LOW"] = "-12";
L["TITAN_CLOCK_CHECKBUTTON"] = "24H";
L["TITAN_CLOCK_CHECKBUTTON_TOOLTIP"] = "Altera a exbição do horário entre os formatos AM/PM ou 24 horas.";
L["TITAN_CLOCK_MENU_TEXT"] = "Relógio";
L["TITAN_CLOCK_MENU_LOCAL_TIME"] = "Exibir Horário Local (L)";
L["TITAN_CLOCK_MENU_SERVER_TIME"] = "Exibir Horário do Servidor (S)";
L["TITAN_CLOCK_MENU_SERVER_ADJUSTED_TIME"] = "Exibir Horário Ajustado do Servidor (A)";
L["TITAN_CLOCK_MENU_DISPLAY_ON_RIGHT_SIDE"] = "Exibir no Lado Direito";
L["TITAN_CLOCK_MENU_HIDE_GAMETIME"] = "Ocultar Botão de Hora/Calendário";
L["TITAN_CLOCK_MENU_HIDE_MAPTIME"] = "Ocultar Botão de Hora";
L["TITAN_CLOCK_MENU_HIDE_CALENDAR"] = "Ocultar Botão do Calendário";

L["TITAN_LOCATION_FORMAT"] = "(%.d, %.d)";
L["TITAN_LOCATION_FORMAT2"] = "(%.1f, %.1f)";
L["TITAN_LOCATION_FORMAT3"] = "(%.2f, %.2f)";
L["TITAN_LOCATION_FORMAT_LABEL"] = "(xx , yy)";
L["TITAN_LOCATION_FORMAT2_LABEL"] = "(xx.x , yy.y)";
L["TITAN_LOCATION_FORMAT3_LABEL"] = "(xx.xx , yy.yy)";
L["TITAN_LOCATION_FORMAT_COORD_LABEL"] = "Formato das Coordenadas";
L["TITAN_LOCATION_BUTTON_LABEL"] = "Loc: ";
L["TITAN_LOCATION_TOOLTIP"] = "Informações de Localização";
L["TITAN_LOCATION_TOOLTIP_HINTS_1"] = "Dica: Shift + Clique para adicionar informações"
L["TITAN_LOCATION_TOOLTIP_HINTS_2"] = "de sua localização para o chat message.";
L["TITAN_LOCATION_TOOLTIP_ZONE"] = "Zona: ";
L["TITAN_LOCATION_TOOLTIP_SUBZONE"] = "Sub Zona: ";
L["TITAN_LOCATION_TOOLTIP_PVPINFO"] = "Informação JvJ: ";
L["TITAN_LOCATION_TOOLTIP_HOMELOCATION"] = "Localização da Casa";
L["TITAN_LOCATION_TOOLTIP_INN"] = "Estalagem: ";
L["TITAN_LOCATION_MENU_TEXT"] = "Localização";
L["TITAN_LOCATION_MENU_SHOW_ZONE_ON_PANEL_TEXT"] = "Exibir Zone Text";
L["TITAN_LOCATION_MENU_SHOW_COORDS_ON_MAP_TEXT"] = "Exibir Coordinates on World Map";
L["TITAN_LOCATION_MAP_CURSOR_COORDS_TEXT"] = "Cursor: %s";
L["TITAN_LOCATION_MAP_PLAYER_COORDS_TEXT"] = "Jogador: %s";
L["TITAN_LOCATION_NO_COORDS"] = "Sem Coordenadas";
L["TITAN_LOCATION_MENU_SHOW_LOC_ON_MINIMAP_TEXT"] = "Exibir Location Name Above Minimap";
L["TITAN_LOCATION_MENU_UPDATE_WORLD_MAP"] = "Update World Map When Zone Changes";

L["TITAN_FPS_FORMAT"] = "%.1f";
L["TITAN_FPS_BUTTON_LABEL"] = "QPS: ";
L["TITAN_FPS_MENU_TEXT"] = "QPS";
L["TITAN_FPS_TOOLTIP_CURRENT_FPS"] = "QPS Atual: ";
L["TITAN_FPS_TOOLTIP_AVG_FPS"] = "QPS Médio: ";
L["TITAN_FPS_TOOLTIP_MIN_FPS"] = "QPS Mínimo: ";
L["TITAN_FPS_TOOLTIP_MAX_FPS"] = "QPS Máximo: ";
L["TITAN_FPS_TOOLTIP"] = "Quadros por Segundo";

L["TITAN_LATENCY_FORMAT"] = "%d".."ms";
L["TITAN_LATENCY_BANDWIDTH_FORMAT"] = "%.3f ".."KB/s";
L["TITAN_LATENCY_BUTTON_LABEL"] = "Latência: ";
L["TITAN_LATENCY_TOOLTIP"] = "Status da Rede";
L["TITAN_LATENCY_TOOLTIP_LATENCY_HOME"] = "Latência do Reino (local): ";
L["TITAN_LATENCY_TOOLTIP_LATENCY_WORLD"] = "Latência do Jogo (global): ";
L["TITAN_LATENCY_TOOLTIP_BANDWIDTH_IN"] = "Banda de Entrada: ";
L["TITAN_LATENCY_TOOLTIP_BANDWIDTH_OUT"] = "Banda de Saída: ";
L["TITAN_LATENCY_MENU_TEXT"] = "Latência";

L["TITAN_LOOTTYPE_BUTTON_LABEL"] = "Saque: ";
L["TITAN_LOOTTYPE_FREE_FOR_ALL"] = "\"Cada Um Por Si\"";
L["TITAN_LOOTTYPE_ROUND_ROBIN"] = "\"Rodízio\"";
L["TITAN_LOOTTYPE_MASTER_LOOTER"] = "Mestre Saqueador";
L["TITAN_LOOTTYPE_GROUP_LOOT"] = "Saque em Grupo";
L["TITAN_LOOTTYPE_NEED_BEFORE_GREED"] = "Necessidade sobre Ganância";
L["TITAN_LOOTTYPE_PERSONAL"] = "Personal";
L["TITAN_LOOTTYPE_TOOLTIP"] = "Informação de Tipo de Saque";
L["TITAN_LOOTTYPE_MENU_TEXT"] = "Tipo de Saque";
L["TITAN_LOOTTYPE_RANDOM_ROLL_LABEL"] = "Jogada Aleatória";
L["TITAN_LOOTTYPE_TOOLTIP_HINT1"] = "Dica: Clique para uma jogada aleatória.";
L["TITAN_LOOTTYPE_TOOLTIP_HINT2"] = "Selecione o tipo de jogada com o menu acessível com o botão direito do mouse.";
L["TITAN_LOOTTYPE_DUNGEONDIFF_LABEL"] = "Dificuldade da Masmorra";
L["TITAN_LOOTTYPE_DUNGEONDIFF_LABEL2"] = "Dificuldade da Raide";
L["TITAN_LOOTTYPE_SHOWDUNGEONDIFF_LABEL"] = "Exibir Dificuldade da Masmorra/Raide";
L["TITAN_LOOTTYPE_SETDUNGEONDIFF_LABEL"] = "Configurar Dificuldade da Masmorra";
L["TITAN_LOOTTYPE_SETRAIDDIFF_LABEL"] = "Configurar Dificuldade da Raide";
L["TITAN_LOOTTYPE_AUTODIFF_LABEL"] = "Automático (Baseado no Grupo)";

L["TITAN_MEMORY_FORMAT"] = "%.3f".."MB";
L["TITAN_MEMORY_FORMAT_KB"] = "%d".."KB";
L["TITAN_MEMORY_RATE_FORMAT"] = "%.3f".."KB/s";
L["TITAN_MEMORY_BUTTON_LABEL"] = "Memória: ";
L["TITAN_MEMORY_TOOLTIP"] = "Uso da Memória";
L["TITAN_MEMORY_TOOLTIP_CURRENT_MEMORY"] = "Atual: ";
L["TITAN_MEMORY_TOOLTIP_INITIAL_MEMORY"] = "Inicial: ";
L["TITAN_MEMORY_TOOLTIP_INCREASING_RATE"] = "Taxa de Aumento: ";
L["TITAN_MEMORY_KBMB_LABEL"] = "KB/MB";     

L["TITAN_PERFORMANCE_TOOLTIP"] = "Informações de Performance";
L["TITAN_PERFORMANCE_MENU_TEXT"] = "Performance";
L["TITAN_PERFORMANCE_ADDONS"] = "Addon Usage";
L["TITAN_PERFORMANCE_ADDON_MEM_USAGE_LABEL"] = "Uso de Memória de Addons";
L["TITAN_PERFORMANCE_ADDON_MEM_FORMAT_LABEL"] = "Addon Memory Format";
L["TITAN_PERFORMANCE_ADDON_CPU_USAGE_LABEL"] = "Uso de CPU por Addons";
L["TITAN_PERFORMANCE_ADDON_NAME_LABEL"] = "Nome:";
L["TITAN_PERFORMANCE_ADDON_USAGE_LABEL"] = "Uso";
L["TITAN_PERFORMANCE_ADDON_RATE_LABEL"] = "Aumento";
L["TITAN_PERFORMANCE_ADDON_TOTAL_MEM_USAGE_LABEL"] = "Total de Memória de Addon:";
L["TITAN_PERFORMANCE_ADDON_TOTAL_CPU_USAGE_LABEL"] = "Tempo de CPU Total:";
L["TITAN_PERFORMANCE_MENU_SHOW_FPS"] = "Exibir QPS";
L["TITAN_PERFORMANCE_MENU_SHOW_LATENCY"] = "Exibir Latência do Reino";
L["TITAN_PERFORMANCE_MENU_SHOW_LATENCY_WORLD"] = "Exibir Latência do Jogo";
L["TITAN_PERFORMANCE_MENU_SHOW_MEMORY"] = "Exibir Memória";
L["TITAN_PERFORMANCE_MENU_SHOW_ADDONS"] = "Exibir Addon Memory Usage";
L["TITAN_PERFORMANCE_MENU_SHOW_ADDON_RATE"] = "Exibir Addon Usage Rate";
L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL"] = "CPU Profiling Mode";
L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL_ON"] = "Enable CPU Profiling Mode ";
L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL_OFF"] = "Disable CPU Profiling Mode ";
L["TITAN_PERFORMANCE_CONTROL_TOOLTIP"] = "Addons Monitorados: ";
L["TITAN_PERFORMANCE_CONTROL_TITLE"] = "Addons Monitorados";
L["TITAN_PERFORMANCE_CONTROL_HIGH"] = "40";
L["TITAN_PERFORMANCE_CONTROL_LOW"] = "1";
L["TITAN_PERFORMANCE_TOOLTIP_HINT"] = "Dica: Clique para forçar a coleção de lixo.";

L["TITAN_XP_FORMAT"] = "%s";
L["TITAN_XP_PERCENT_FORMAT"] = "(%.1f%%)";
L["TITAN_XP_BUTTON_LABEL_XPHR_LEVEL"] = "EXP/hr This Level: ";
L["TITAN_XP_BUTTON_LABEL_XPHR_SESSION"] = "EXP/hr This Session: ";
L["TITAN_XP_BUTTON_LABEL_TOLEVEL_TIME_LEVEL"] = "Time To Level: ";
L["TITAN_XP_LEVEL_COMPLETE"] = "Level Complete: ";
L["TITAN_XP_TOTAL_RESTED"] = "Rested: ";
L["TITAN_XP_XPTOLEVELUP"] = "EXP To Level: ";
L["TITAN_XP_TOOLTIP"] = "EXP Info";
L["TITAN_XP_TOOLTIP_TOTAL_TIME"] = "Total Time Played: ";
L["TITAN_XP_TOOLTIP_LEVEL_TIME"] = "Time Played This Level: ";
L["TITAN_XP_TOOLTIP_SESSION_TIME"] = "Time Played This Session: ";
L["TITAN_XP_TOOLTIP_TOTAL_XP"] = "Total XP Required This Level: ";
L["TITAN_XP_TOOLTIP_LEVEL_XP"] = "XP Gained This Level: ";
L["TITAN_XP_TOOLTIP_TOLEVEL_XP"] = "XP Needed To Level: ";
L["TITAN_XP_TOOLTIP_SESSION_XP"] = "XP Gained This Session: ";
L["TITAN_XP_TOOLTIP_XPHR_LEVEL"] = "XP/HR This Level: ";
L["TITAN_XP_TOOLTIP_XPHR_SESSION"] = "XP/HR This Session: ";     
L["TITAN_XP_TOOLTIP_TOLEVEL_LEVEL"] = "Time To Level (Level Rate): ";
L["TITAN_XP_TOOLTIP_TOLEVEL_SESSION"] = "Time To Level (Session Rate): ";
L["TITAN_XP_MENU_TEXT"] = "EXP";
L["TITAN_XP_MENU_SHOW_XPHR_THIS_LEVEL"] = "Exibir XP/HR This Level";
L["TITAN_XP_MENU_SHOW_XPHR_THIS_SESSION"] = "Exibir XP/HR This Session";
L["TITAN_XP_MENU_SHOW_RESTED_TOLEVELUP"] = "Exibir Multi-Info View";
L["TITAN_XP_MENU_SIMPLE_BUTTON_TITLE"] = "Button";
L["TITAN_XP_MENU_SIMPLE_BUTTON_RESTED"] = "Exibir Rested XP";
L["TITAN_XP_MENU_SIMPLE_BUTTON_TOLEVELUP"] = "Exibir XP To Level";
L["TITAN_XP_MENU_SIMPLE_BUTTON_KILLS"] = "Exibir Estimated Kills To Level";
L["TITAN_XP_MENU_RESET_SESSION"] = "Resetar Sessão";
L["TITAN_XP_MENU_REFRESH_PLAYED"] = "Refresh Timers";
L["TITAN_XP_UPDATE_PENDING"] = "Atualizando...";
L["TITAN_XP_KILLS_LABEL"] = "Kills To Level (at %s XP gained last): ";
L["TITAN_XP_KILLS_LABEL_SHORT"] = "Est. Kills: ";
L["TITAN_XP_BUTTON_LABEL_SESSION_TIME"] = "Session Time: ";
L["TITAN_XP_MENU_SHOW_SESSION_TIME"] = "Exibir Session Time";
L["TITAN_XP_GAIN_PATTERN"] = "(.*) dies, you gain (%d+) experience.";
L["TITAN_XP_XPGAINS_LABEL_SHORT"] = "Est. Gains: ";
L["TITAN_XP_XPGAINS_LABEL"] = "XP Gains To Level (at %s XP gained last): ";
L["TITAN_XP_MENU_SIMPLE_BUTTON_XPGAIN"] = "Exibir Estimated XP Gains To Level";

--Titan Repair
L["REPAIR_LOCALE"] = {
	menu = "Conserto",
	tooltip = "Informações de Conserto",
	button = "Durabilidade: ",
	normal = "Custo de Conserto (Normal): ",
	friendly = "Custo de Conserto (Respeitado): ",
	honored = "Custo de Conserto (Honrado): ",
	revered = "Custo de Conserto (Reverenciado): ",
	exalted = "Custo de Conserto (Exaltado): ",
	buttonNormal = "Exibir Normal",
	buttonFriendly = "Exibir Respeitado (5%)",
	buttonHonored = "Exibir Honrado (10%)",
	buttonRevered = "Exibir Reverenciado (15%)",
	buttonExalted = "Exibir Exaltado (20%)",
	percentage = "Exibir como Porcentagem",
	itemnames = "Exibir Nome dos Itens",
	mostdamaged = "Exibir o Mais Danificado",
	Exibirdurabilityframe = "Exibir Quadro de Durabilidade",
	undamaged = "Exibir Itens Não Danificados",
	discount = "Desconto",
	nothing = "Nada Danificado",
	confirmation = "Do you want to repair all items ?",
	badmerchant = "This merchant cannot repair. Displaying normal repair costs instead.",
	popup = "Exibir Popup de Conserto",
	showinventory = "Calculate Inventory Damage",
	WholeScanInProgress = "Atualizando...",
	AutoReplabel = "Auto Conserto",
	AutoRepitemlabel = "Auto Consertar Todos os Itens",
	ShowRepairCost = "Exibir Custo de Conserto",
	ignoreThrown = "Ignore Thrown",
	ShowItems = "Exibir Itens",
	ShowDiscounts = "Exibir Descontos",
	ShowCosts = "Exibir Custos",
	Items = "Itens",
	Discounts = "Descontos",
	Costs = "Custos",
	CostTotal = "Custo Total",
	CostBag = "Custo dos Itens na Bolsa",
	CostEquip = "Custo dos Itens Equipados",
	TooltipOptions = "Tooltip",
};

L["TITAN_REPAIR"] = "Titan Consertos"
L["TITAN_REPAIR_GBANK_TOTAL"] = "Guild Bank Funds :"
L["TITAN_REPAIR_GBANK_WITHDRAW"] = "Guild Bank Withdrawal Allowed :"
L["TITAN_REPAIR_GBANK_USEFUNDS"] = "Use Guild Bank Funds"
L["TITAN_REPAIR_GBANK_NOMONEY"] = "Guild Bank can't afford the repair cost, or you can't withdraw that much."
L["TITAN_REPAIR_GBANK_NORIGHTS"] = "You are either not in a guild or you don't have permission to use the guild bank to repair your items."
L["TITAN_REPAIR_CANNOT_AFFORD"] = "You cannot afford to repair, at this time."
L["TITAN_REPAIR_REPORT_COST_MENU"] = "Report Repair Cost to Chat"
L["TITAN_REPAIR_REPORT_COST_CHAT"] = "Custo de conserto foi "

L["TITAN_GOLD_TOOLTIPTEXT"] = "Total Gold on";
L["TITAN_GOLD_ITEMNAME"] = "Titan Gold";
L["TITAN_GOLD_CLEAR_DATA_TEXT"] = "Limpar Banco de Dados";
L["TITAN_GOLD_RESET_SESS_TEXT"] = "Resetar Sessão Atual";
L["TITAN_GOLD_DB_CLEARED"] = "Titan Gold - Database Cleared.";
L["TITAN_GOLD_SESSION_RESET"] = "Titan Ouro - Sessão resetada.";
L["TITAN_GOLD_MENU_TEXT"] = "Ouro";
L["TITAN_GOLD_TOOLTIP"] = "Informações de Ouro";
L["TITAN_GOLD_TOGGLE_PLAYER_TEXT"] = "Display Player Gold";
L["TITAN_GOLD_TOGGLE_ALL_TEXT"] = "Display Server Gold";
L["TITAN_GOLD_SESS_EARNED"] = "Ganho nesta Sessão";
L["TITAN_GOLD_PERHOUR_EARNED"] = "Ganho por Hora";
L["TITAN_GOLD_SESS_LOST"] = "Perda Nesta Sessão";
L["TITAN_GOLD_PERHOUR_LOST"] = "Perda por Hora";
L["TITAN_GOLD_STATS_TITLE"] = "Estatísticas da Sessão";
L["TITAN_GOLD_TTL_GOLD"] = "Ouro Total";
L["TITAN_GOLD_START_GOLD"] = "Ouro Inicial";
L["TITAN_GOLD_TOGGLE_SORT_GOLD"] = "Ordernar Tabela por Ouro";
L["TITAN_GOLD_TOGGLE_SORT_NAME"] = "Ordenar Ouro por Nome";
L["TITAN_GOLD_TOGGLE_GPH_SHOW"] = "Exibir Ouro por Hora";
L["TITAN_GOLD_TOGGLE_GPH_HIDE"] = "Ocultar Gold Per Hour";
L["TITAN_GOLD_GOLD"] = "o";
L["TITAN_GOLD_SILVER"] = "p";
L["TITAN_GOLD_COPPER"] = "c";
L["TITAN_GOLD_STATUS_PLAYER_SHOW"] = "Visível";
L["TITAN_GOLD_STATUS_PLAYER_HIDE"] = "Escondido";
L["TITAN_GOLD_DELETE_PLAYER"] = "Apagar Personagem";
L["TITAN_GOLD_SHOW_PLAYER"] = "Exibir Personagem";
L["TITAN_GOLD_FACTION_PLAYER_ALLY"] = "Aliança";
L["TITAN_GOLD_FACTION_PLAYER_HORDE"] = "Horda";
L["TITAN_GOLD_CLEAR_DATA_WARNING"] = GREEN_FONT_COLOR_CODE .. "Atenção: "
.. FONT_COLOR_CODE_CLOSE .. "This setting will wipe your Titan Gold database. "
.. "If you wish to continue with this operation, push 'Accept', otherwise push 'Cancel' or the 'Escape' key.";
L["TITAN_GOLD_COIN_NONE"] = "Exibir Nenhum Rótulo";
L["TITAN_GOLD_COIN_LABELS"] = "Exibir Rótulo de Texto";
L["TITAN_GOLD_COIN_ICONS"] = "Exibir Rótulo de Ícones";
L["TITAN_GOLD_ONLY"] = "Exibir Somente Ouro";
L["TITAN_GOLD_COLORS"] = "Exibir Gold Colors";
L["TITAN_GOLD_MERGE"] = "Merge Servers";
L["TITAN_GOLD_SEPARATE"] = "Separate Servers";

L["TITAN_VOLUME_TOOLTIP"] = "Informação de Volume";
L["TITAN_VOLUME_MASTER_TOOLTIP_VALUE"] = "Master Sound Volume: ";
L["TITAN_VOLUME_SOUND_TOOLTIP_VALUE"] = "Effects Sound Volume: ";
L["TITAN_VOLUME_AMBIENCE_TOOLTIP_VALUE"] = "Ambience Sound Volume: ";
L["TITAN_VOLUME_DIALOG_TOOLTIP_VALUE"] = "Dialog Sound Volume: ";
L["TITAN_VOLUME_MUSIC_TOOLTIP_VALUE"] = "Music Sound Volume: ";
L["TITAN_VOLUME_MICROPHONE_TOOLTIP_VALUE"] = "Microphone Sound Volume: ";
L["TITAN_VOLUME_SPEAKER_TOOLTIP_VALUE"] = "Speaker Sound Volume: ";
L["TITAN_VOLUME_TOOLTIP_HINT1"] = "Hint: Clique para ajustar o"
L["TITAN_VOLUME_TOOLTIP_HINT2"] = "volume do som.";
L["TITAN_VOLUME_CONTROL_TOOLTIP"] = "Volume Control: ";
L["TITAN_VOLUME_CONTROL_TITLE"] = "Volume Control";
L["TITAN_VOLUME_MASTER_CONTROL_TITLE"] = "Geral";
L["TITAN_VOLUME_SOUND_CONTROL_TITLE"] = "Efeitos";
L["TITAN_VOLUME_AMBIENCE_CONTROL_TITLE"] = "Ambiente";
L["TITAN_VOLUME_DIALOG_CONTROL_TITLE"] = "Dialog";
L["TITAN_VOLUME_MUSIC_CONTROL_TITLE"] = "Música";
L["TITAN_VOLUME_MICROPHONE_CONTROL_TITLE"] = "Microfone";
L["TITAN_VOLUME_SPEAKER_CONTROL_TITLE"] = "Auto-falante";
L["TITAN_VOLUME_CONTROL_HIGH"] = "Alto";
L["TITAN_VOLUME_CONTROL_LOW"] = "Baixo";
L["TITAN_VOLUME_MENU_TEXT"] = "Controle do Volume";
L["TITAN_VOLUME_MENU_AUDIO_OPTIONS_LABEL"] = "Exibir Opções de Som/Voz";
L["TITAN_VOLUME_MENU_OVERRIDE_BLIZZ_SETTINGS"] = "Ignorar Configurações de Volume da Blizzard";
