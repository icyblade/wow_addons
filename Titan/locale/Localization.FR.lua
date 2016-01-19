local L = LibStub("AceLocale-3.0"):NewLocale("Titan","frFR")
if not L then return end

L["TITAN_PANEL"] = "Titan Panel";
local TITAN_PANEL = "Titan Panel";
L["TITAN_DEBUG"] = "<Titan>";
L["TITAN_PRINT"] = "Titan";

L["TITAN_NA"] = "N/A";
L["TITAN_SECONDS"] = "secondes";
L["TITAN_MINUTES"] = "minutes";
L["TITAN_HOURS"] = "heures";
L["TITAN_DAYS"] = "jours";
L["TITAN_SECONDS_ABBR"] = "s";
L["TITAN_MINUTES_ABBR"] = "m";
L["TITAN_HOURS_ABBR"] = "h";
L["TITAN_DAYS_ABBR"] = "d";
L["TITAN_MILLISECOND"] = "ms";
L["TITAN_KILOBYTES_PER_SECOND"] = "Ko/s";
L["TITAN_KILOBITS_PER_SECOND"] = "kb/s"
L["TITAN_MEGABYTE"] = "Mo";
L["TITAN_NONE"] = "Aucun";
L["TITAN_USE_COMMA"] = "Utiliser une virgule pour le séparateur de milliers";
L["TITAN_USE_PERIOD"] = "Utiliser un point pour le séparateur de milliers";

L["TITAN_PANEL_ERROR_PROF_DELCURRENT"] = "Vous ne pouvez pas supprimer votre profil en cours.";
local TITAN_PANEL_WARNING = GREEN_FONT_COLOR_CODE.."Attention : "..FONT_COLOR_CODE_CLOSE
local TITAN_PANEL_RELOAD_TEXT = "Si vous voulez continuer cette opération, appuyez sur 'Accepter' (l'interface va se recharger), sinon appuyez sur 'Annuler' ou la touche 'Echap'."
L["TITAN_PANEL_RESET_WARNING"] = TITAN_PANEL_WARNING
	.."cela va réinitialiser la/les barres et tous les paramètres de "..TITAN_PANEL.." à leur valeur par défaut et va recréer votre profil. "
	..TITAN_PANEL_RELOAD_TEXT
L["TITAN_PANEL_RELOAD"] = TITAN_PANEL_WARNING
	.."Cela va recharger "..TITAN_PANEL..". "
	..TITAN_PANEL_RELOAD_TEXT

L["TITAN_PANEL_ATTEMPTS"] = TITAN_PANEL.." - Tentatives d'enregistrement" -- ??
L["TITAN_PANEL_ATTEMPTS_SHORT"] = "Enregistrement" -- ??
L["TITAN_PANEL_ATTEMPTS_DESC"] = "Les plugins ci-dessous ont cherché à s'enregistrer auprès de "..TITAN_PANEL..".\n"
	.."Tout problème rencontré avec ces plugins est à rapporter à l'auteur du plugin."
L["TITAN_PANEL_ATTEMPTS_TYPE"] = "Type"
L["TITAN_PANEL_ATTEMPTS_CATEGORY"] = "Catégorie"
L["TITAN_PANEL_ATTEMPTS_BUTTON"] = "Nom du bouton"
L["TITAN_PANEL_ATTEMPTS_STATUS"] = "Statut"
L["TITAN_PANEL_ATTEMPTS_ISSUE"] = "Problème"
L["TITAN_PANEL_ATTEMPTS_NOTES"] = "Notes"
L["TITAN_PANEL_ATTEMPTS_TABLE"] = "Index dans la table"

L["TITAN_PANEL_EXTRAS"] = TITAN_PANEL.." Extras"
L["TITAN_PANEL_EXTRAS_DESC"] = "Plugins non lancés ayant des données de configuration.\n"
	.."Note: Vous devez vous déconnecter pour que les suppressions soient prises en compte."
L["TITAN_PANEL_EXTRAS_DELETE_BUTTON"] = "Supprimer les données de configuration"
L["TITAN_PANEL_EXTRAS_DELETE_MSG"] = "configuration supprimée."

L["TITAN_PANEL_CHARS"] = "Personnages"
L["TITAN_PANEL_CHARS_DESC"] = "Ces personnages ont des données de configuration.\n"
	.."Note: Vous devez vous déconnecter pour que les suppressions soient prises en compte."

L["TITAN_PANEL_REGISTER_START"] = "Enregistrement des plugins "..TITAN_PANEL.."..."
L["TITAN_PANEL_REGISTER_END"] = "Enregistrement des plugins effectué."

-- slash command help
L["TITAN_PANEL_SLASH_RESET_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."Usage: |cffffffff/titan {reset | reset tipfont/tipalpha/panelscale/spacing}";
L["TITAN_PANEL_SLASH_RESET_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset: | cffffffffRéinitialise les valeurs et positions de "..TITAN_PANEL..".";
L["TITAN_PANEL_SLASH_RESET_2"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset tipfont: |cffffffffRéinitialise l'échelle des polices des tooltips de "..TITAN_PANEL..".";
L["TITAN_PANEL_SLASH_RESET_3"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset tipalpha: |cffffffffRéinitialise la transparence des tooltips de "..TITAN_PANEL..".";
L["TITAN_PANEL_SLASH_RESET_4"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset panelscale: |cffffffffRéinitialise l'échelle de "..TITAN_PANEL..".";
L["TITAN_PANEL_SLASH_RESET_5"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset spacing: |cffffffffRéinitialise l'espacement des boutons de "..TITAN_PANEL..".";
L["TITAN_PANEL_SLASH_GUI_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."Usage: |cffffffff/titan {gui control/trans/skin}";
L["TITAN_PANEL_SLASH_GUI_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."gui control: |cffffffffOuvre le panneau de configuration de "..TITAN_PANEL..".";
L["TITAN_PANEL_SLASH_GUI_2"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."gui trans: |cffffffffOuvre le panneau de configuration de la transparence.";
L["TITAN_PANEL_SLASH_GUI_3"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."gui skin: |cffffffffOuvre le panneau de configuration des skins.";
L["TITAN_PANEL_SLASH_PROFILE_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."Usage: |cffffffff/titan {profile use <profile>}";
L["TITAN_PANEL_SLASH_PROFILE_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."profile use <nom> <serveur>: |cffffffffcharge le profil choisi :";
L["TITAN_PANEL_SLASH_PROFILE_2"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."<nom>: |cffffffffle nom du personnage ou le profil personnalisé."
L["TITAN_PANEL_SLASH_PROFILE_3"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."<serveur>: |cffffffffle nom du serveur ou 'TitanCustomProfile'."
L["TITAN_PANEL_SLASH_SILENT_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."Usage: |cffffffff/titan {silent}";
L["TITAN_PANEL_SLASH_SILENT_1"] = LIGHTYELLOW_FONT_COLOR_CODE.."silent: |cffffffffToggles "..TITAN_PANEL.." pour charger silencieusement.";
L["TITAN_PANEL_SLASH_HELP_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."Usage: |cffffffff/titan {help | help <topic>}";
L["TITAN_PANEL_SLASH_HELP_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."<topic>: reset/gui/profile/silent/help ";
L["TITAN_PANEL_SLASH_ALL_0"] = LIGHTYELLOW_FONT_COLOR_CODE.."Usage: |cffffffff/titan <topic>";
L["TITAN_PANEL_SLASH_ALL_1"] = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."<topic>: |cffffffffreset/gui/profile/silent/help ";

-- slash command responses
L["TITAN_PANEL_SLASH_RESP1"] = LIGHTYELLOW_FONT_COLOR_CODE.."L'échelle des polices des tooltips de "..TITAN_PANEL.." a été réinitialisée.";
L["TITAN_PANEL_SLASH_RESP2"] = LIGHTYELLOW_FONT_COLOR_CODE.."La transparence des tooltips de "..TITAN_PANEL.." a été réinitialisée.";
L["TITAN_PANEL_SLASH_RESP3"] = LIGHTYELLOW_FONT_COLOR_CODE.."L'échelle de "..TITAN_PANEL.." a été réinitialisée.";
L["TITAN_PANEL_SLASH_RESP4"] = LIGHTYELLOW_FONT_COLOR_CODE.."L'espacement des boutons de "..TITAN_PANEL.." a été réinitialisé.";

-- global profile locale
L["TITAN_PANEL_GLOBAL"] = "Global";
L["TITAN_PANEL_GLOBAL_PROFILE"] = "Profil global";
L["TITAN_PANEL_GLOBAL_USE"] = "Utiliser le profil global";
L["TITAN_PANEL_GLOBAL_USE_AS"] = "Utiliser en tant que profil global";
L["TITAN_PANEL_GLOBAL_USE_DESC"] = "Utiliser un profil global pour tous les persos";
L["TITAN_PANEL_GLOBAL_RESET_PART"] = "réinitialisation des options";
L["TITAN_PANEL_GLOBAL_ERR_1"] = "Vous ne devriez pas charger un profil lorsqu'un profil global est en cours d'utilisation";

-- general panel locale
L["TITAN_PANEL_VERSION_INFO"] = "|cffffd700 par le |cffff8c00"..TITAN_PANEL.." Development Team";
L["TITAN_PANEL_MENU_TITLE"] = TITAN_PANEL;
L["TITAN_PANEL_MENU_HIDE"] = "Cacher";
L["TITAN_PANEL_MENU_IN_COMBAT_LOCKDOWN"] = "(En Combat)";
L["TITAN_PANEL_MENU_RELOADUI"] = "(Recharge l'interface)";
L["TITAN_PANEL_MENU_SHOW_COLORED_TEXT"] = "Colorer le texte";
L["TITAN_PANEL_MENU_SHOW_ICON"] = "Montrer l'icône";
L["TITAN_PANEL_MENU_SHOW_LABEL_TEXT"] = "Montrer le titre";
L["TITAN_PANEL_MENU_AUTOHIDE"] = "Cacher automatiquement";
L["TITAN_PANEL_MENU_CENTER_TEXT"] = "Centrer le texte";
L["TITAN_PANEL_MENU_DISPLAY_BAR"] = "Afficher la barre";
L["TITAN_PANEL_MENU_DISABLE_PUSH"] = "Ne pas ajuster l'écran";
L["TITAN_PANEL_MENU_DISABLE_MINIMAP_PUSH"] = "Ne pas ajuster la minicarte";
L["TITAN_PANEL_MENU_DISABLE_LOGS"] = "Ajuster automatiquement la fenêtre de discussion";
L["TITAN_PANEL_MENU_DISABLE_BAGS"] = "Ajuster automatiquement les sacs";
L["TITAN_PANEL_MENU_DISABLE_TICKET"] = "Ajuster automatiquement le ticket MJ";
L["TITAN_PANEL_MENU_PROFILES"] = "Profils";
L["TITAN_PANEL_MENU_PROFILE"] = "Profil ";
L["TITAN_PANEL_MENU_PROFILE_CUSTOM"] = "Personnalisation";
L["TITAN_PANEL_MENU_PROFILE_DELETED"] = " a été supprimé.";
L["TITAN_PANEL_MENU_PROFILE_SERVERS"] = "Serveur";
L["TITAN_PANEL_MENU_PROFILE_CHARS"] = "Personnage";
L["TITAN_PANEL_MENU_PROFILE_RELOADUI"] = "L'interface va maintenant être recharcée lorsque vous appuierez sur 'OK' pour permettre d'enregistrer votre profil perso.";
L["TITAN_PANEL_MENU_PROFILE_SAVE_CUSTOM_TITLE"] = "Entrez un nom pour votre profil perso :\n(20 lettres max, pas d'espaces)";
L["TITAN_PANEL_MENU_PROFILE_SAVE_PENDING"] = "Les paramètres actuels vont être enregistrés sous le profil : ";
L["TITAN_PANEL_MENU_PROFILE_ALREADY_EXISTS"] = "Le nom du profil existe déjà. Veuillez saisir un autre nom.";
L["TITAN_PANEL_MENU_MANAGE_SETTINGS"] = "Gestion";
L["TITAN_PANEL_MENU_LOAD_SETTINGS"] = "Chargement";
L["TITAN_PANEL_MENU_DELETE_SETTINGS"] = "Suppression";
L["TITAN_PANEL_MENU_SAVE_SETTINGS"] = "Sauvegarde";
L["TITAN_PANEL_MENU_CONFIGURATION"] = "Configuration";
L["TITAN_PANEL_OPTIONS"] = "Options";
L["TITAN_PANEL_MENU_TOP"] = "Haut 1"
L["TITAN_PANEL_MENU_TOP2"] = "Haut 2"
L["TITAN_PANEL_MENU_BOTTOM"] = "Bas 1"
L["TITAN_PANEL_MENU_BOTTOM2"] = "Bas 2"
L["TITAN_PANEL_MENU_OPTIONS"] = TITAN_PANEL.." Tooltips et Frames"; -- ??
L["TITAN_PANEL_MENU_OPTIONS_SHORT"] = "Tooltips et Frames"; -- ??
L["TITAN_PANEL_MENU_TOP_BARS"] = "Barres du haut" -- ??
L["TITAN_PANEL_MENU_BOTTOM_BARS"] = "Barres du bas" -- ??
L["TITAN_PANEL_MENU_OPTIONS_BARS"] = "Barres";
L["TITAN_PANEL_MENU_OPTIONS_MAIN_BARS"] = TITAN_PANEL.." Barres du haut";
L["TITAN_PANEL_MENU_OPTIONS_AUX_BARS"] = TITAN_PANEL.." Barres du bas";
L["TITAN_PANEL_MENU_OPTIONS_TOOLTIPS"] = "Tooltips";
L["TITAN_PANEL_MENU_OPTIONS_FRAMES"] = "Frames";
L["TITAN_PANEL_MENU_PLUGINS"] = "Plug-ins";
L["TITAN_PANEL_MENU_LOCK_BUTTONS"] = "Verrouiller les boutons";
L["TITAN_PANEL_MENU_VERSION_SHOWN"] = "Afficher les versions";
L["TITAN_PANEL_MENU_LDB_SIDE"] = "Plugin du côté droit";
L["TITAN_PANEL_MENU_LDB_FORCE_LAUNCHER"] = "Forcer les launchers du côté droit";
L["TITAN_PANEL_MENU_CATEGORIES"] = {"Interne","Généralités","Combat","Informations","Interface","Métiers"}
L["TITAN_PANEL_MENU_TOOLTIPS_SHOWN"] = "Afficher les conseils";
L["TITAN_PANEL_MENU_TOOLTIPS_SHOWN_IN_COMBAT"] = "Cacher les tooltips en combat";
L["TITAN_PANEL_MENU_AUTOHIDE_IN_COMBAT"] = "Bloquer l'affichage automatique en combat";
L["TITAN_PANEL_MENU_RESET"] = "Réinitialiser "..TITAN_PANEL;
L["TITAN_PANEL_MENU_TEXTURE_SETTINGS"] = "Paramètres du skin";
L["TITAN_PANEL_MENU_LSM_FONTS"] = "Police des panneaux"
L["TITAN_PANEL_MENU_ENABLED"] = "Activé";
L["TITAN_PANEL_MENU_DISABLED"] = "Désactivé";
L["TITAN_PANEL_SHIFT_LEFT"] = "Déplacer à gauche";
L["TITAN_PANEL_SHIFT_RIGHT"] = "Déplacer à droite";
L["TITAN_PANEL_MENU_SHOW_PLUGIN_TEXT"] = "Afficher le texte";
L["TITAN_PANEL_MENU_BAR_ALWAYS"] = "Toujours sur la barre"; --??
L["TITAN_PANEL_MENU_POSITION"] = "Position";
L["TITAN_PANEL_MENU_BAR"] = "Barre";
L["TITAN_PANEL_MENU_DISPLAY_ON_BAR"] = "Choisir la barre sur laquelle afficher le plugin :";
L["TITAN_PANEL_MENU_SHOW"] = "Afficher le plugin";
L["TITAN_PANEL_MENU_PLUGIN_RESET"] = "Rafraîchir les plugins";
L["TITAN_PANEL_MENU_PLUGIN_RESET_DESC"] = "Rafraîchit le texte et la position des plugins";
L["TITAN_PANEL_MENU_SILENT_LOAD"] = "Chargement silencieux";

-- localization strings for AceConfigDialog-3.0
L["TITAN_ABOUT_VERSION"] = "Version";
L["TITAN_ABOUT_AUTHOR"] = "Auteur";
L["TITAN_ABOUT_CREDITS"] = "Credits";
L["TITAN_ABOUT_CATEGORY"] = "Catégorie";
L["TITAN_ABOUT_EMAIL"] = "Email";
L["TITAN_ABOUT_WEB"] = "Site web";
L["TITAN_ABOUT_LICENSE"] = "Licence";
L["TITAN_PANEL_CONFIG_MAIN_LABEL"] = "Addon de barres d'informations. Permet aux utilisateurs d'ajouter des plugins sur les barres placées en haut et/ou en bas de l'écran.";
L["TITAN_TRANS_MENU_TEXT"] = TITAN_PANEL.." Transparence";
L["TITAN_TRANS_MENU_TEXT_SHORT"] = "Transparence";
L["TITAN_TRANS_MENU_DESC"] = "Ajuste la transparence pour les barres de "..TITAN_PANEL.." et les tooltips.";
L["TITAN_TRANS_MAIN_CONTROL_TITLE"] = "Barre principale";
L["TITAN_TRANS_AUX_CONTROL_TITLE"] = "Barre secondaire";
L["TITAN_TRANS_CONTROL_TITLE_TOOLTIP"] = "Tooltip";
L["TITAN_TRANS_TOOLTIP_DESC"] = "Ajuste la transparence pour les tooltips des divers plugins.";
L["TITAN_UISCALE_MENU_TEXT"] = TITAN_PANEL.." Echelle et police";
L["TITAN_UISCALE_MENU_TEXT_SHORT"] = "Echelle et police";
L["TITAN_UISCALE_CONTROL_TITLE_UI"] = "Echelle de l'interface";
L["TITAN_UISCALE_CONTROL_TITLE_PANEL"] = "Echelle de "..TITAN_PANEL;
L["TITAN_UISCALE_CONTROL_TITLE_BUTTON"] = "Espacement des boutons";
L["TITAN_UISCALE_CONTROL_TITLE_ICON"] = "Espacement des icônes";
L["TITAN_UISCALE_CONTROL_TOOLTIP_TOOLTIPFONT"] = "Echelle des polices des tooltips";
L["TITAN_UISCALE_TOOLTIP_DISABLE_TEXT"] = "Désactiver l'échelle de la police des tooltips";
L["TITAN_UISCALE_MENU_DESC"] = "Paramètre l'aspect global de l'UI et de "..TITAN_PANEL..".";
L["TITAN_UISCALE_SLIDER_DESC"] = "Ajuste l'échelle de l'interface entière.";
L["TITAN_UISCALE_PANEL_SLIDER_DESC"] = "Ajuste l'échelle pour les boutons et icônes de "..TITAN_PANEL..".";
L["TITAN_UISCALE_BUTTON_SLIDER_DESC"] = "Ajuste l'espace entre les plugins du côté gauche.";
L["TITAN_UISCALE_ICON_SLIDER_DESC"] = "Ajuste l'espace entre les plugins du côté droit.";
L["TITAN_UISCALE_TOOLTIP_SLIDER_DESC"] = "Ajuste l'échelle des tooltips des divers plugins.";
L["TITAN_UISCALE_DISABLE_TOOLTIP_DESC"] = "Désactiver la mise à l'échelle de la police des tooltips de "..TITAN_PANEL..".";

L["TITAN_SKINS_TITLE"] = TITAN_PANEL.." Skins";
L["TITAN_SKINS_OPTIONS_CUSTOM"] = "Skins persos";
L["TITAN_SKINS_TITLE_CUSTOM"] = TITAN_PANEL.." Skins personnalisés";
L["TITAN_SKINS_MAIN_DESC"] = "Tous les skins personnalisés doivent être dans : \n"
	.."..\\Interface\\AddOns\\Titan\\Artwork\\Custom\\<Mon Skin>\\ ".."\n"
	.."\nLes skins personnalisés et ceux de "..TITAN_PANEL.." sont stockés dans le dossier 'Custom'."
L["TITAN_SKINS_LIST_TITLE"] = "Liste des skins";
L["TITAN_SKINS_SET_DESC"] = "Sélectionne un skin pour les barres de "..TITAN_PANEL..".";
L["TITAN_SKINS_SET_HEADER"] = "Choix du skin";
L["TITAN_SKINS_RESET_HEADER"] = "Réinitialiser les skins de "..TITAN_PANEL;
L["TITAN_SKINS_NEW_HEADER"] = "Ajout d'un nouveau skin";
L["TITAN_SKINS_NAME_TITLE"] = "Nom du skin";
L["TITAN_SKINS_NAME_DESC"] = "Entrez un nom pour votre nouveau skin. Il sera utilisé dans la liste des skins.";
L["TITAN_SKINS_PATH_TITLE"] = "Chemin du skin";
L["TITAN_SKINS_PATH_DESC"] = "Entrez le chemin exact où se trouve votre artwork, comme montré par l'exemple."; -- et expliqué dans les 'Notes'.";
L["TITAN_SKINS_ADD_HEADER"] = "Ajouter le skin";
L["TITAN_SKINS_ADD_DESC"] = "Ajouter un nouveau skin à la liste des skins disponibles.";
L["TITAN_SKINS_REMOVE_HEADER"] = "Suppression d'un skin";
L["TITAN_SKINS_REMOVE_DESC"] = "Supprime un skin de la liste des skins disponibles.";
L["TITAN_SKINS_REMOVE_BUTTON"] = "Supprimer le skin";
L["TITAN_SKINS_REMOVE_BUTTON_DESC"] = "Supprime le skin sélectionné de la liste des skins disponibles.";
L["TITAN_SKINS_REMOVE_NOTES"] = "Vous êtes responsable de la suppression des skins personnalisés que vous ne souhaitez pas "
	.."dans le dossier de "..TITAN_PANEL..". Les addons ne peuvent pas ajouter ou supprimer des fichiers."
L["TITAN_SKINS_RESET_DEFAULTS_TITLE"] = "Réinit. la liste";
L["TITAN_SKINS_RESET_DEFAULTS_DESC"] = "Réinitialise la liste de skin aux skins internes de "..TITAN_PANEL..".";
L["TITAN_PANEL_MENU_LSM_FONTS_DESC"] = "Sélectionne la police pour les divers plugins sur les barres de "..TITAN_PANEL..".";
L["TITAN_PANEL_MENU_FONT_SIZE"] = "Taille de police";
L["TITAN_PANEL_MENU_FONT_SIZE_DESC"] = "Sélectionne la taille des polices pour les divers plugins sur les barres de "..TITAN_PANEL..".";
L["TITAN_PANEL_MENU_FRAME_STRATA"] = TITAN_PANEL.." Altitude des frames";
L["TITAN_PANEL_MENU_FRAME_STRATA_DESC"] = "Ajuste l'altitude des frames pour les barres de "..TITAN_PANEL..".";
-- /end localization strings for AceConfigDialog-3.0

L["TITAN_PANEL_MENU_ADV"] = "Avancé";
L["TITAN_PANEL_MENU_ADV_DESC"] = "Changez les timers uniquement si vous avez des problèmes avec l'ajustement des frames.".."\n"; -- ??
L["TITAN_PANEL_MENU_ADV_PEW"] = "Entrée dans le monde";
L["TITAN_PANEL_MENU_ADV_PEW_DESC"] = "Utiliser (généralement en augmentant) si les frames ne s'ajustent pas lors de chargement du monde (ou d'une instance).";
L["TITAN_PANEL_MENU_ADV_VEHICLE"] = "Véhicule";
L["TITAN_PANEL_MENU_ADV_VEHICLE_DESC"] = "Utiliser (généralement en augmentant) si les frames ne s'ajustent pas lorsqu'on entre / descend d'un véhicule.";

L["TITAN_AUTOHIDE_TOOLTIP"] = "Changer l'affichage automatique du panneau on/off";

L["TITAN_BAG_FORMAT"] = "%d/%d";
L["TITAN_BAG_BUTTON_LABEL"] = "Sacs : ";
L["TITAN_BAG_TOOLTIP"] = "Utilisation des sacs";
L["TITAN_BAG_TOOLTIP_HINTS"] = "Info : clic-gauche pour ouvrir tous les sacs.";
L["TITAN_BAG_MENU_TEXT"] = "Sac";
L["TITAN_BAG_USED_SLOTS"] = "Emplacements utilisés";
L["TITAN_BAG_FREE_SLOTS"] = "Emplacements libres";
L["TITAN_BAG_BACKPACK"] = "Sac à dos";
L["TITAN_BAG_MENU_SHOW_USED_SLOTS"] = "Montrer les emplacements utilisés";
L["TITAN_BAG_MENU_SHOW_AVAILABLE_SLOTS"] = "Montrer les emplacements libres";
L["TITAN_BAG_MENU_SHOW_DETAILED"] = "Afficher les détails";
L["TITAN_BAG_MENU_IGNORE_SLOTS"] = "Ignorer les sacs de métiers";
L["TITAN_BAG_MENU_IGNORE_PROF_BAGS_SLOTS"] = "Ignorer les emplacements des sacs spécifiques aux métiers";

L["TITAN_BAG_PROF_BAG_ENCHANTING"] = {
"Bourse enchantée en tisse-mage","Sac de soirée enchanteur en exclusivité pour La Tannée","Sac enchanté en étoffe runique","Sacoche d'enchanteur","Grand sac d'enchantement","Sac du feu-sorcier","Sac mystérieux","Sac surnaturel"};
L["TITAN_BAG_PROF_BAG_ENGINEERING"] = {
"Sac de haute technologie « Maddy » par La Tannée","Lourde boîte à outils","Boîte à outils en gangrefer","Boîte à outils en titane","Boîte à outils en élémentium"};
L["TITAN_BAG_PROF_BAG_HERBALISM"] = {
"Bourse d'herbes","Sac fourre-tout d'herboriste « T vert » par La Tannée","Sac d'herbes cénarien","Sacoche de Cénarius","Sac de botanique de Mycah","Sac émeraude","Sac d'expédition d'Hyjal"};
L["TITAN_BAG_PROF_BAG_INSCRIPTION"] = {
"Sacoche d'étudiant « Xandera » par La Tannée","Sacoche de calligraphie","Sac des poches infinies", "Sac de calligraphie bruni"};
L["TITAN_BAG_PROF_BAG_JEWELCRAFTING"] = {
"Pochette brodée de gemmes en exclusivité pour La Tannée","Bourse de gemmes","Sac de joyaux"};
L["TITAN_BAG_PROF_BAG_LEATHERWORKING"] = {
"Sac en cuir « Meeya » par La Tannée","Sacoche de travailleur du cuir","Sac des nombreuses peaux","Sac de voyage de trappeur", "Sac en cuir bruni"};
L["TITAN_BAG_PROF_BAG_MINING"] = {
"Sac à métaux précieux « Christina » par La Tannée","Sac de mineur","Sac de mineur renforcé","Sac de mineur colossal", "Sac de mineur bruni"};
L["TITAN_BAG_PROF_BAG_FISHING"] = {"Boîte d'appâts du maître des leurres"};
L["TITAN_BAG_PROF_BAG_COOKING"] = {"Réfrigérateur portable", "Unité réfrigérante améliorée"};

L["TITAN_CLOCK_TOOLTIP"] = "Horloge";
L["TITAN_CLOCK_TOOLTIP_VALUE"] = "Décalage horaire : ";
L["TITAN_CLOCK_TOOLTIP_LOCAL_TIME"] = "Heure locale : ";
L["TITAN_CLOCK_TOOLTIP_SERVER_TIME"] = "Heure serveur : ";
L["TITAN_CLOCK_TOOLTIP_SERVER_ADJUSTED_TIME"] = "Heure serveur ajustée : ";
L["TITAN_CLOCK_TOOLTIP_HINT1"] = "Info : clic-gauche pour ajuster le décalage"
L["TITAN_CLOCK_TOOLTIP_HINT2"] = "horaire et le format d'heure 12/24H.";
L["TITAN_CLOCK_TOOLTIP_HINT3"] = "Shift-clic-gauche pour afficher le calendrier.";
L["TITAN_CLOCK_CONTROL_TOOLTIP"] = "Décalage horaire : ";
L["TITAN_CLOCK_CONTROL_TITLE"] = "Décalage";
L["TITAN_CLOCK_CONTROL_HIGH"] = "+12";
L["TITAN_CLOCK_CONTROL_LOW"] = "-12";
L["TITAN_CLOCK_CHECKBUTTON"] = "  24h";
L["TITAN_CLOCK_CHECKBUTTON_TOOLTIP"] = "Changer le format de l'heure : 12/24 heures";
L["TITAN_CLOCK_MENU_TEXT"] = "Horloge";
L["TITAN_CLOCK_MENU_LOCAL_TIME"] = "Afficher l'heure locale (L)";
L["TITAN_CLOCK_MENU_SERVER_TIME"] = "Afficher l'heure serveur (S)";
L["TITAN_CLOCK_MENU_SERVER_ADJUSTED_TIME"] = "Afficher l'heure serveur ajustée (A)";
L["TITAN_CLOCK_MENU_DISPLAY_ON_RIGHT_SIDE"] = "Afficher tout à droite";
L["TITAN_CLOCK_MENU_HIDE_GAMETIME"] = "Cacher le bouton du calendrier";
L["TITAN_CLOCK_MENU_HIDE_MAPTIME"] = "Cacher le bouton d'horloge";
L["TITAN_CLOCK_MENU_HIDE_CALENDAR"] = "Cacher le bouton du calendrier";

L["TITAN_LOCATION_FORMAT"] = "(%.d, %.d)";
L["TITAN_LOCATION_FORMAT2"] = "(%.1f, %.1f)";
L["TITAN_LOCATION_FORMAT3"] = "(%.2f, %.2f)";
L["TITAN_LOCATION_FORMAT_LABEL"] = "(xx , yy)";
L["TITAN_LOCATION_FORMAT2_LABEL"] = "(xx.x , yy.y)";
L["TITAN_LOCATION_FORMAT3_LABEL"] = "(xx.xx , yy.yy)";
L["TITAN_LOCATION_FORMAT_COORD_LABEL"] = "Format des coordonnées";
L["TITAN_LOCATION_BUTTON_LABEL"] = "Pos. : ";
L["TITAN_LOCATION_TOOLTIP"] = "Info de position";
L["TITAN_LOCATION_TOOLTIP_HINTS_1"] = "Astuce : shift-clic-gauche pour ajouter";
L["TITAN_LOCATION_TOOLTIP_HINTS_2"] = "l'info de position dans les dialogues.";
L["TITAN_LOCATION_TOOLTIP_ZONE"] = "Zone : ";
L["TITAN_LOCATION_TOOLTIP_SUBZONE"] = "Sous Zone : ";
L["TITAN_LOCATION_TOOLTIP_PVPINFO"] = "Info JCJ : ";
L["TITAN_LOCATION_TOOLTIP_HOMELOCATION"] = "Position du foyer";
L["TITAN_LOCATION_TOOLTIP_INN"] = "Auberge : ";
L["TITAN_LOCATION_MENU_TEXT"] = "Position";
L["TITAN_LOCATION_MENU_SHOW_ZONE_ON_PANEL_TEXT"] = "Montrer le texte de la zone";
L["TITAN_LOCATION_MENU_SHOW_COORDS_ON_MAP_TEXT"] = "Montrer les coordonnées sur la carte du monde";
L["TITAN_LOCATION_MAP_CURSOR_COORDS_TEXT"] = "Curseur : %s";
L["TITAN_LOCATION_MAP_PLAYER_COORDS_TEXT"] = "Joueur : %s";
L["TITAN_LOCATION_NO_COORDS"] = "Pas de coords";
L["TITAN_LOCATION_MENU_SHOW_LOC_ON_MINIMAP_TEXT"] = "Montrer la zone au dessus de la minicarte";
L["TITAN_LOCATION_MENU_UPDATE_WORLD_MAP"] = "Mettre à jour la carte du monde lors de changements de zone";

L["TITAN_FPS_FORMAT"] = "%.1f";
L["TITAN_FPS_BUTTON_LABEL"] = "IPS : ";
L["TITAN_FPS_MENU_TEXT"] = "IPS";
L["TITAN_FPS_TOOLTIP_CURRENT_FPS"] = "IPS actuel : ";
L["TITAN_FPS_TOOLTIP_AVG_FPS"] = "IPS moyen : ";
L["TITAN_FPS_TOOLTIP_MIN_FPS"] = "IPS minimum : ";
L["TITAN_FPS_TOOLTIP_MAX_FPS"] = "IPS maximum : ";
L["TITAN_FPS_TOOLTIP"] = "Images par seconde";

L["TITAN_LATENCY_FORMAT"] = "%d".."ms";
L["TITAN_LATENCY_BANDWIDTH_FORMAT"] = "%.3f ".."Ko/s";
L["TITAN_LATENCY_BUTTON_LABEL"] = "Latence : ";
L["TITAN_LATENCY_TOOLTIP"] = "Etat du réseau";
L["TITAN_LATENCY_TOOLTIP_LATENCY_HOME"] = "Latence du royaume (domicile) : ";
L["TITAN_LATENCY_TOOLTIP_LATENCY_WORLD"] = "Latence du jeu (monde) : ";
L["TITAN_LATENCY_TOOLTIP_BANDWIDTH_IN"] = "Bande passante sortante : ";
L["TITAN_LATENCY_TOOLTIP_BANDWIDTH_OUT"] = "Bande passante entrante : ";
L["TITAN_LATENCY_MENU_TEXT"] = "Latence";

L["TITAN_LOOTTYPE_BUTTON_LABEL"] = "Butin : ";
L["TITAN_LOOTTYPE_FREE_FOR_ALL"] = "Accès libre";
L["TITAN_LOOTTYPE_ROUND_ROBIN"] = "Chacun son tour";
L["TITAN_LOOTTYPE_MASTER_LOOTER"] = "Responsable du butin";
L["TITAN_LOOTTYPE_GROUP_LOOT"] = "Butin de groupe";
L["TITAN_LOOTTYPE_NEED_BEFORE_GREED"] = "Le Besoin avant la Cupidité";
L["TITAN_LOOTTYPE_PERSONAL"] = "Personnel";
L["TITAN_LOOTTYPE_TOOLTIP"] = "Type de butin";
L["TITAN_LOOTTYPE_MENU_TEXT"] = "Type de butin";
L["TITAN_LOOTTYPE_RANDOM_ROLL_LABEL"] = "Lancer les dés";
L["TITAN_LOOTTYPE_TOOLTIP_HINT1"] = "Astuce : clic-gauche pour un jet de dés.";
L["TITAN_LOOTTYPE_TOOLTIP_HINT2"] = "Sélectionnez la plage du lancer de dés via le clic droit.";
L["TITAN_LOOTTYPE_DUNGEONDIFF_LABEL"] = "Difficulté du donjon";
L["TITAN_LOOTTYPE_DUNGEONDIFF_LABEL2"] = "Difficulté du raid";
L["TITAN_LOOTTYPE_SHOWDUNGEONDIFF_LABEL"] = "Afficher la difficulté du donjon/raid";
L["TITAN_LOOTTYPE_SETDUNGEONDIFF_LABEL"] = "Changer la difficulté du donjon";
L["TITAN_LOOTTYPE_SETRAIDDIFF_LABEL"] = "Changer la difficulté du raid";
L["TITAN_LOOTTYPE_AUTODIFF_LABEL"] = "Auto (basé sur le groupe)";

L["TITAN_MEMORY_FORMAT"] = "%.3f".."Mo";
L["TITAN_MEMORY_FORMAT_KB"] = "%d".."Ko";
L["TITAN_MEMORY_RATE_FORMAT"] = "%.3f".."Ko/s";
L["TITAN_MEMORY_BUTTON_LABEL"] = "Mémoire : ";
L["TITAN_MEMORY_TOOLTIP"] = "Utilisation mémoire";
L["TITAN_MEMORY_TOOLTIP_CURRENT_MEMORY"] = "Actuel : ";
L["TITAN_MEMORY_TOOLTIP_INITIAL_MEMORY"] = "Initial : ";
L["TITAN_MEMORY_TOOLTIP_INCREASING_RATE"] = "Taux d'augmentation : ";
L["TITAN_MEMORY_KBMB_LABEL"] = "Ko/Mo";

L["TITAN_PERFORMANCE_TOOLTIP"] = "Performances";
L["TITAN_PERFORMANCE_MENU_TEXT"] = "Performances";
L["TITAN_PERFORMANCE_ADDONS"] = "Utilisation des addons";
L["TITAN_PERFORMANCE_ADDON_MEM_USAGE_LABEL"] = "Utilisation mémoire des addons";
L["TITAN_PERFORMANCE_ADDON_MEM_FORMAT_LABEL"] = "Format de la mémoire des addons";
L["TITAN_PERFORMANCE_ADDON_CPU_USAGE_LABEL"] = "Utilisation CPU des addons";
L["TITAN_PERFORMANCE_ADDON_NAME_LABEL"] = "Nom:";
L["TITAN_PERFORMANCE_ADDON_USAGE_LABEL"] = "Utilisation";
L["TITAN_PERFORMANCE_ADDON_RATE_LABEL"] = "Taux";
L["TITAN_PERFORMANCE_ADDON_TOTAL_MEM_USAGE_LABEL"] = "Mémoire totale des addons :";
L["TITAN_PERFORMANCE_ADDON_TOTAL_CPU_USAGE_LABEL"] = "Temps total CPU :";
L["TITAN_PERFORMANCE_MENU_SHOW_FPS"] = "Montrer les IPS";
L["TITAN_PERFORMANCE_MENU_SHOW_LATENCY"] = "Montrer la latence du royaume (domicile)";
L["TITAN_PERFORMANCE_MENU_SHOW_LATENCY_WORLD"] = "Montrer la latence du jeu (monde)";
L["TITAN_PERFORMANCE_MENU_SHOW_MEMORY"] = "Montrer la mémoire";
L["TITAN_PERFORMANCE_MENU_SHOW_ADDONS"] = "Montrer l'utilisation mémoire/CPU des addons";
L["TITAN_PERFORMANCE_MENU_SHOW_ADDON_RATE"] = "Afficher le taux d'occupation mémoire/CPU";
L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL"] = "Analyse de performances CPU ";
L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL_ON"] = "Activer l'analyse CPU ";
L["TITAN_PERFORMANCE_MENU_CPUPROF_LABEL_OFF"] = "Désactiver l'analyse CPU ";
L["TITAN_PERFORMANCE_CONTROL_TOOLTIP"] = "Addons surveillés : ";
L["TITAN_PERFORMANCE_CONTROL_TITLE"] = "Addons à surveiller";
L["TITAN_PERFORMANCE_CONTROL_HIGH"] = "40";
L["TITAN_PERFORMANCE_CONTROL_LOW"] = "1";
L["TITAN_PERFORMANCE_TOOLTIP_HINT"] = "Info : clic-gauche pour forcer un nettoyage de la mémoire.";

L["TITAN_XP_FORMAT"] = "%s";
L["TITAN_XP_PERCENT_FORMAT"] = "(%.1f%%)";
L["TITAN_XP_BUTTON_LABEL_XPHR_LEVEL"] = "XP/h pour ce niveau : ";
L["TITAN_XP_BUTTON_LABEL_XPHR_SESSION"] = "XP/h pour cette session : ";
L["TITAN_XP_BUTTON_LABEL_TOLEVEL_TIME_LEVEL"] = "Temps avant niveau : ";
L["TITAN_XP_LEVEL_COMPLETE"] = "Progression : ";
L["TITAN_XP_TOTAL_RESTED"] = "Reposé : ";
L["TITAN_XP_XPTOLEVELUP"] = "XP nécessaire : ";
L["TITAN_XP_TOOLTIP"] = "Info XP";
L["TITAN_XP_TOOLTIP_TOTAL_TIME"] = "Temps de jeu total : ";
L["TITAN_XP_TOOLTIP_LEVEL_TIME"] = "Temps joué pour ce niveau : ";
L["TITAN_XP_TOOLTIP_SESSION_TIME"] = "Temps joué pour cette session : ";
L["TITAN_XP_TOOLTIP_TOTAL_XP"] = "XP totale requise pour ce niveau : ";
L["TITAN_XP_TOOLTIP_LEVEL_XP"] = "XP gagnée pour ce niveau : ";
L["TITAN_XP_TOOLTIP_TOLEVEL_XP"] = "XP nécessaire pour ce niveau : ";
L["TITAN_XP_TOOLTIP_SESSION_XP"] = "XP gagnée pour cette session : ";
L["TITAN_XP_TOOLTIP_XPHR_LEVEL"] = "XP/h pour ce niveau : ";
L["TITAN_XP_TOOLTIP_XPHR_SESSION"] = "XP/h pour cette session : ";
L["TITAN_XP_TOOLTIP_TOLEVEL_LEVEL"] = "Temps avant niveau (taux niveau) : ";
L["TITAN_XP_TOOLTIP_TOLEVEL_SESSION"] = "Temps avant niveau (taux session) : ";
L["TITAN_XP_MENU_TEXT"] = "XP";
L["TITAN_XP_MENU_SHOW_XPHR_THIS_LEVEL"] = "Montrer XP/h pour ce niveau";
L["TITAN_XP_MENU_SHOW_XPHR_THIS_SESSION"] = "Montrer XP/h pour cette session";
L["TITAN_XP_MENU_SHOW_RESTED_TOLEVELUP"] = "Montrer la vue multi-infos";
L["TITAN_XP_MENU_SIMPLE_BUTTON_TITLE"] = "Afficher ...";
L["TITAN_XP_MENU_SIMPLE_BUTTON_RESTED"] = "XP reposée";
L["TITAN_XP_MENU_SIMPLE_BUTTON_TOLEVELUP"] = "XP nécessaire pour ce niveau";
L["TITAN_XP_MENU_SIMPLE_BUTTON_KILLS"] = "l'estimation du nombre de mobs à tuer";
L["TITAN_XP_MENU_RESET_SESSION"] = "Réinitialise la session";
L["TITAN_XP_MENU_REFRESH_PLAYED"] = "Rafraîchir les compteurs";
L["TITAN_XP_UPDATE_PENDING"] = "Mise à jour...";
L["TITAN_XP_KILLS_LABEL"] = "Mobs à tuer avant niveau (à %s XP par mob) : ";
L["TITAN_XP_KILLS_LABEL_SHORT"] = "Mobs à tuer : ";
L["TITAN_XP_BUTTON_LABEL_SESSION_TIME"] = "Temps joué pour cette session : ";
L["TITAN_XP_MENU_SHOW_SESSION_TIME"] = "Montrer le temps joué pour cette session";
L["TITAN_XP_GAIN_PATTERN"] = "(.*) meurt, vous gagnez (%d+) points d'expérience.";
L["TITAN_XP_XPGAINS_LABEL_SHORT"] = "Est. des gains : ";
L["TITAN_XP_XPGAINS_LABEL"] = "Gains d'XP pour passer de niveau (à %s XP gagné): ";
L["TITAN_XP_MENU_SIMPLE_BUTTON_XPGAIN"] = "les estimations de gains d'XP pour monter";

--Titan Repair
L["REPAIR_LOCALE"] = {
	menu = "Réparation",
	tooltip = "Infos de réparation",
	button = "Durabilité: ",
	normal = "Coût de réparation (normal) : ",
	friendly = "Coût de réparation (amical) : ",
	honored = "Coût de réparation (honoré) : ",
	revered = "Coût de réparation (révéré) : ",
	exalted = "Coût de réparation (exalté) : ",
	buttonNormal = "Afficher normal",
	buttonFriendly = "Afficher amical (5%)",
	buttonHonored = "Afficher honoré (10%)",
	buttonRevered = "Afficher révéré (15%)",
	buttonExalted = "Afficher exalté (20%)",
	percentage = "Afficher en pourcentage",
	itemnames = "Afficher le nom des objets",
	mostdamaged = "Afficher le plus endommagé",
	showdurabilityframe = "Afficher la silhouette de durabilité",
	undamaged = "Afficher les objets intacts",
	discount = "Afficher la réduction sur le bouton de la barre et les noms d'objets",
	nothing = "Aucun objet endommagé",
	confirmation = "Voulez vous réparer tous vos objets ?",
	badmerchant = "Ce marchand ne peut pas réparer. Affichage des coûts de réparation normaux.",
	popup = "Afficher la demande de réparation",
	showinventory = "Réparer aussi l'inventaire",
	WholeScanInProgress = "Mise à jour...",
	AutoReplabel = "Réparation Auto",
	AutoRepitemlabel = "Réparation automatique de tous les objets",
	ShowRepairCost = "Afficher le coût de réparation",
	ignoreThrown = "Ignorer les armes de jet",
	ShowItems = "Afficher les objets",
	ShowDiscounts = "Afficher les réductions",
	ShowCosts = "Afficher les coûts",
	Items = "Objets",
	Discounts = "Réductions",
	Costs = "Coûts",
	CostTotal = "Coût total",
	CostBag = "Coût de l'inventaire",
	CostEquip = "Coût de l'équipement",
	TooltipOptions = "Tooltip",
};
L["TITAN_REPAIR"] = "Titan Repair"
L["TITAN_REPAIR_GBANK_TOTAL"] = "Fonds de la banque de guilde :"
L["TITAN_REPAIR_GBANK_WITHDRAW"] = "Retrait autorisé :"
L["TITAN_REPAIR_GBANK_USEFUNDS"] = "Utiliser les fonds de la banque de guilde"
L["TITAN_REPAIR_GBANK_NOMONEY"] = "La banque de guilde ne peut pas payer les réparations, ou vous ne pouvez pas retirer autant."
L["TITAN_REPAIR_GBANK_NORIGHTS"] = "Vous n'êtes soit pas dans une guilde, soit vous n'avez pas le droit d'utiliser la banque de guilde pour réparer vos objets."
L["TITAN_REPAIR_CANNOT_AFFORD"] = "Vous n'avez pas assez pour payer les réparations."
L["TITAN_REPAIR_REPORT_COST_MENU"] = "Annoncer les coût de réparation sur le chat"
L["TITAN_REPAIR_REPORT_COST_CHAT"] = "Coût des réparations : "

L["TITAN_GOLD_TOOLTIPTEXT"] = "Or total sur";
L["TITAN_GOLD_ITEMNAME"] = "Titan Gold";
L["TITAN_GOLD_CLEAR_DATA_TEXT"] = "Vider la base de données";
L["TITAN_GOLD_RESET_SESS_TEXT"] = "Remise à zéro de la session";
L["TITAN_GOLD_DB_CLEARED"] = "Titan Gold - Base vidée.";
L["TITAN_GOLD_SESSION_RESET"] = "Titan Gold - Session remise à zéro.";
L["TITAN_GOLD_MENU_TEXT"] = "Gold";
L["TITAN_GOLD_TOOLTIP"] = "Infos sur les richesses";
L["TITAN_GOLD_TOGGLE_PLAYER_TEXT"] = "Afficher l'or du joueur";
L["TITAN_GOLD_TOGGLE_ALL_TEXT"] = "Afficher l'or sur le serveur";
L["TITAN_GOLD_SESS_EARNED"] = "Gagné cette session";
L["TITAN_GOLD_PERHOUR_EARNED"] = "Gagné par heure";
L["TITAN_GOLD_SESS_LOST"] = "Perdu cette session";
L["TITAN_GOLD_PERHOUR_LOST"] = "Perdu par heure";
L["TITAN_GOLD_STATS_TITLE"] = "Statistiques de la session";
L["TITAN_GOLD_TTL_GOLD"] = "Or Total";
L["TITAN_GOLD_START_GOLD"] = "Or de départ";
L["TITAN_GOLD_TOGGLE_SORT_GOLD"] = "Trier par or";
L["TITAN_GOLD_TOGGLE_SORT_NAME"] = "Trier par nom";
L["TITAN_GOLD_TOGGLE_GPH_SHOW"] = "Afficher l'or gagné par heure";
L["TITAN_GOLD_TOGGLE_GPH_HIDE"] = "Cacher l'or gagné par heure";
L["TITAN_GOLD_GOLD"] = "o";
L["TITAN_GOLD_SILVER"] = "a";
L["TITAN_GOLD_COPPER"] = "c";
L["TITAN_GOLD_STATUS_PLAYER_SHOW"] = "visible";
L["TITAN_GOLD_STATUS_PLAYER_HIDE"] = "caché";
L["TITAN_GOLD_DELETE_PLAYER"] = "Supprimer ce personnage";
L["TITAN_GOLD_SHOW_PLAYER"] = "Afficher ce personnage";
L["TITAN_GOLD_FACTION_PLAYER_ALLY"] = "Alliance";
L["TITAN_GOLD_FACTION_PLAYER_HORDE"] = "Horde";
L["TITAN_GOLD_CLEAR_DATA_WARNING"] = GREEN_FONT_COLOR_CODE.."Attention : "..FONT_COLOR_CODE_CLOSE
	.."Ceci va réinitialiser toutes les données de Titan Gold. Si vous voulez continuer, cliquez sur 'Accepter', sinon 'Annuler' ou la touche 'Echap'.";
L["TITAN_GOLD_COIN_NONE"] = "Ne rien afficher";
L["TITAN_GOLD_COIN_LABELS"] = "Afficher le texte des pièces";
L["TITAN_GOLD_COIN_ICONS"] = "Afficher les images des pièces";
L["TITAN_GOLD_ONLY"] = "Afficher uniquement les pièces d'or";
L["TITAN_GOLD_MERGE"] = "Merge Servers";
L["TITAN_GOLD_SEPARATE"] = "Separate Servers";

L["TITAN_VOLUME_TOOLTIP"] = "Contrôle du volume";
L["TITAN_VOLUME_MASTER_TOOLTIP_VALUE"] = "Volume global : ";
L["TITAN_VOLUME_SOUND_TOOLTIP_VALUE"] = "Volume des effets : ";
L["TITAN_VOLUME_AMBIENCE_TOOLTIP_VALUE"] = "Volume de l'ambiance : ";
L["TITAN_VOLUME_DIALOG_TOOLTIP_VALUE"] = "Volume des discussions : ";
L["TITAN_VOLUME_MUSIC_TOOLTIP_VALUE"] = "Volume de la musique : ";
L["TITAN_VOLUME_MICROPHONE_TOOLTIP_VALUE"] = "Volume du microphone : ";
L["TITAN_VOLUME_SPEAKER_TOOLTIP_VALUE"] = "Volume des voix : ";
L["TITAN_VOLUME_TOOLTIP_HINT1"] = "Info : clic-gauche pour ajuster"
L["TITAN_VOLUME_TOOLTIP_HINT2"] = "le volume sonore.";
L["TITAN_VOLUME_CONTROL_TOOLTIP"] = "Volume : ";
L["TITAN_VOLUME_CONTROL_TITLE"] = "Volume";
L["TITAN_VOLUME_MASTER_CONTROL_TITLE"] = "Global";
L["TITAN_VOLUME_SOUND_CONTROL_TITLE"] = "Effets";
L["TITAN_VOLUME_AMBIENCE_CONTROL_TITLE"] = "Ambiance";
L["TITAN_VOLUME_DIALOG_CONTROL_TITLE"] = "Discussion";
L["TITAN_VOLUME_MUSIC_CONTROL_TITLE"] = "Musique";
L["TITAN_VOLUME_MICROPHONE_CONTROL_TITLE"] = "Micro";
L["TITAN_VOLUME_SPEAKER_CONTROL_TITLE"] = "Voix";
L["TITAN_VOLUME_CONTROL_HIGH"] = "Haut";
L["TITAN_VOLUME_CONTROL_LOW"] = "Bas";
L["TITAN_VOLUME_MENU_TEXT"] = "Ajustement du volume";
L["TITAN_VOLUME_MENU_AUDIO_OPTIONS_LABEL"] = "Ouvrir les options Sons et Voix" ;
L["TITAN_VOLUME_MENU_OVERRIDE_BLIZZ_SETTINGS"] = "Remplacer les réglages Blizzard";
