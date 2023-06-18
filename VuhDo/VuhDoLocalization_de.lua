
if (GetLocale() ~= "deDE") then
	return;
end
-- @EXACT = true: Translation has to be the exact(!) match in the clients language,
--                beacause it carries technical semantics
-- @EXACT = false: Translation can be done freely, because text is only descriptive
-- Class Names
-- @EXACT = false
VUHDO_I18N_WARRIORS="Krieger"
VUHDO_I18N_ROGUES = "Schurken";
VUHDO_I18N_HUNTERS = "Jäger";
VUHDO_I18N_PALADINS = "Paladine";
VUHDO_I18N_MAGES = "Magier";
VUHDO_I18N_WARLOCKS = "Hexenmeister";
VUHDO_I18N_SHAMANS = "Schamanen";
VUHDO_I18N_DRUIDS = "Druiden";
VUHDO_I18N_PRIESTS = "Priester";
VUHDO_I18N_DEATH_KNIGHT = "Todesritter";
VUHDO_I18N_MONKS = "Mönche";
-- Group Model Names
-- @EXACT = false
VUHDO_I18N_GROUP = "Gruppe";
VUHDO_I18N_OWN_GROUP = "Eigene Grp.";
-- Special Model Names
-- @EXACT = false
VUHDO_I18N_PETS = "Begleiter";
VUHDO_I18N_MAINTANKS = "Main Tanks";
VUHDO_I18N_PRIVATE_TANKS = "Privat-Tanks";
-- General Labels
-- @EXACT = false
VUHDO_I18N_OKAY = "Okay";
VUHDO_I18N_CLASS = "Klasse";
VUHDO_I18N_PLAYER = "Spieler";
-- VuhDoTooltip.lua
-- @EXACT = false
VUHDO_I18N_TT_POSITION = "|cffffb233Position:|r";
VUHDO_I18N_TT_GHOST = "<GEIST>";
VUHDO_I18N_TT_DEAD = "<TOT>";
VUHDO_I18N_TT_AFK = "<AFK>";
VUHDO_I18N_TT_DND = "<DND>";
VUHDO_I18N_TT_LIFE = "|cffffb233Leben:|r ";
VUHDO_I18N_TT_MANA = "|cffffb233Mana:|r ";
VUHDO_I18N_TT_LEVEL = "Level ";
-- VuhDoPanel.lua
-- @EXACT = false
VUHDO_I18N_CHOOSE = "Auswahl";
VUHDO_I18N_DRAG = "Zieh";
VUHDO_I18N_REMOVE = "Entfernen";
VUHDO_I18N_ME = "mich!";
VUHDO_I18N_TYPE = "Typ";
VUHDO_I18N_VALUE = "Wert";
VUHDO_I18N_SPECIAL = "Spezial";
VUHDO_I18N_BUFF_ALL = "alle";
VUHDO_I18N_SHOW_BUFF_WATCH = "Buff Watch anzeigen";
-- Chat messages
-- @EXACT = false
VUHDO_I18N_COMMAND_LIST = "\n|cffffe566 - [ VuhDo Kommandos ] -|r";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566opt|r[ions] - VuhDo Optionen";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566res|r[et] - Panel Positionen zurücksetzen";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566lock|r - Panelpositionen sperren/freigeben";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566mm, map, minimap|r - Minimap Icon an/aus";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566show, hide, toggle|r - Panels anzeigen/verbergen";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566load|r - [Profile],[Key Layout]";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§[broad]|cffffe566cast, mt|r[s] - Main Tanks übertragen";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566role|r - Spielerrollen zuruecksetzen";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566help,?|r - Diese Befehlsliste\n";
VUHDO_I18N_BAD_COMMAND = "Ungültiges Argument! '/vuhdo help' oder '/vd ?' für eine Liste der Kommandos.";
VUHDO_I18N_CHAT_SHOWN = "|cffffe566sichtbar|r.";
VUHDO_I18N_CHAT_HIDDEN = "|cffffe566versteckt|r.";
VUHDO_I18N_MM_ICON = "Das Minimap-Symbol ist jetzt ";
VUHDO_I18N_MTS_BROADCASTED = "Die Main-Tanks wurden dem Raid übertragen";
VUHDO_I18N_PANELS_SHOWN = "Die Heil-Panels werden jetzt |cffffe566angezeigt|r.";
VUHDO_I18N_PANELS_HIDDEN = "Die Heil-Panels werden jetzt |cffffe566versteckt|r.";
VUHDO_I18N_LOCK_PANELS_PRE = "Die Panel-Positionen sind jetzt ";
VUHDO_I18N_LOCK_PANELS_LOCKED = "|cffffe566gesperrt|r.";
VUHDO_I18N_LOCK_PANELS_UNLOCKED = "|cffffe566freigegeben|r.";
VUHDO_I18N_PANELS_RESET = "Die Panel-Positionen wurden zurückgesetzt.";
-- Config Pop-Up
-- @EXACT = false
VUHDO_I18N_ROLE = "Rolle";
VUHDO_I18N_PRIVATE_TANK = "Privat-Tank";
VUHDO_I18N_SET_BUFF = "Setze Buff";
-- Minimap
-- @EXACT = false
VUHDO_I18N_VUHDO_OPTIONS = "VuhDo Optionen";
VUHDO_I18N_PANEL_SETUP = "Optionen";
VUHDO_I18N_MM_TOOLTIP = "Linksklick: Panel-Einstellungen\nRechtsklick: Menü";
VUHDO_I18N_TOGGLES = "Schalter";
VUHDO_I18N_LOCK_PANELS = "Panels sperren";
VUHDO_I18N_SHOW_PANELS = "Panels anzeigen";
VUHDO_I18N_MM_BUTTON = "Minimap-Symbol";
VUHDO_I18N_CLOSE = "Schließen";
VUHDO_I18N_BROADCAST_MTS = "MTs übertragen";
-- Buff categories
-- @EXACT = false
-- Priest
-- Shaman
VUHDO_I18N_BUFFC_FIRE_TOTEM = "Feuertotem";
VUHDO_I18N_BUFFC_AIR_TOTEM = "Lufttotem";
VUHDO_I18N_BUFFC_EARTH_TOTEM = "Erdtotem";
VUHDO_I18N_BUFFC_WATER_TOTEM = "Wassertotem";
VUHDO_I18N_BUFFC_WEAPON_ENCHANT = "Waffenverzauberung";
VUHDO_I18N_BUFFC_WEAPON_ENCHANT_2 = "Waffenverzauberung 2";
VUHDO_I18N_BUFFC_SHIELDS = "Schilde";
-- Paladin
VUHDO_I18N_BUFFC_BLESSING = "Segen";
VUHDO_I18N_BUFFC_SEAL = "Siegel";
-- Druids
-- Warlock
VUHDO_I18N_BUFFC_SKIN = "Rüstung";
-- Mage
VUHDO_I18N_BUFFC_ARMOR_MAGE = "Rüstung";
-- Death Knight
VUHDO_BUFFC_PRESENCE = "Präsenz";
-- Warrior
VUHDO_I18N_BUFFC_SHOUT = "Ruf";
-- Hunter
VUHDO_I18N_BUFFC_ASPECT = "Aspekt";
-- Monk
VUHDO_I18N_BUFFC_STANCE = "Haltung";
-- Key Binding Headers/Names
-- @EXACT = false
BINDING_HEADER_VUHDO_TITLE = "{ VuhDo - |cffffe566Raid Frames|r }";
BINDING_NAME_VUHDO_KEY_ASSIGN_1 = "Mouse-Over Spruch 1";
BINDING_NAME_VUHDO_KEY_ASSIGN_2 = "Mouse-Over Spruch 2";
BINDING_NAME_VUHDO_KEY_ASSIGN_3 = "Mouse-Over Spruch 3";
BINDING_NAME_VUHDO_KEY_ASSIGN_4 = "Mouse-Over Spruch 4";
BINDING_NAME_VUHDO_KEY_ASSIGN_5 = "Mouse-Over Spruch 5";
BINDING_NAME_VUHDO_KEY_ASSIGN_6 = "Mouse-Over Spruch 6";
BINDING_NAME_VUHDO_KEY_ASSIGN_7 = "Mouse-Over Spruch 7";
BINDING_NAME_VUHDO_KEY_ASSIGN_8 = "Mouse-Over Spruch 8";
BINDING_NAME_VUHDO_KEY_ASSIGN_9 = "Mouse-Over Spruch 9";
BINDING_NAME_VUHDO_KEY_ASSIGN_10 = "Mouse-Over Spruch 10";
BINDING_NAME_VUHDO_KEY_ASSIGN_11 = "Mouse-Over Spruch 11";
BINDING_NAME_VUHDO_KEY_ASSIGN_12 = "Mouse-Over Spruch 12";
BINDING_NAME_VUHDO_KEY_ASSIGN_13 = "Mouse-Over Spruch 13";
BINDING_NAME_VUHDO_KEY_ASSIGN_14 = "Mouse-Over Spruch 14";
BINDING_NAME_VUHDO_KEY_ASSIGN_15 = "Mouse-Over Spruch 15";
BINDING_NAME_VUHDO_KEY_ASSIGN_16 = "Mouse-Over Spruch 16";
BINDING_NAME_VUHDO_KEY_ASSIGN_SMART_BUFF = "Smart Buff";
VUHDO_I18N_MOUSE_OVER_BINDING = "Tastenspruch";
VUHDO_I18N_UNASSIGNED = "(nicht zugewiesen)";
-- #+V1.89
VUHDO_I18N_NO = "Nein";
VUHDO_I18N_UP = "auf";
VUHDO_I18N_VEHICLES = "Vehikel";
-- #+v1.94
VUHDO_I18N_DEFAULT_RES_ANNOUNCE = "vuhdo, steh auf, Du Pappe!";
-- #v+1.151
VUHDO_I18N_MAIN_ASSISTS = "Assistenten";
-- #+v1.184
VUHDO_I18N_BW_CD = "CD";
VUHDO_I18N_BW_GO = "GO!";
VUHDO_I18N_BW_LOW = "LOW";
VUHDO_I18N_BW_N_A = "|cffff0000N/A|r";
VUHDO_I18N_BW_RNG_RED = "|cffff0000RNG|r";
VUHDO_I18N_BW_OK = "OK";
VUHDO_I18N_BW_RNG_YELLOW = "|cffffff00RNG|r";
VUHDO_I18N_PROMOTE_RAID_LEADER = "Zum Raid-Leiter befördern";
VUHDO_I18N_PROMOTE_ASSISTANT = "Zum Assistenten befördern";
VUHDO_I18N_DEMOTE_ASSISTANT = "Assistent degradieren";
VUHDO_I18N_PROMOTE_MASTER_LOOTER = "Zum Loot-Master ernennen";
VUHDO_I18N_MT_NUMBER = "MT #";
VUHDO_I18N_ROLE_OVERRIDE = "Rolle überschreiben";
VUHDO_I18N_MELEE_TANK = "Melee - Tank";
VUHDO_I18N_MELEE_DPS = "Melee - DPS";
VUHDO_I18N_RANGED_DPS = "Ranged - DPS";
VUHDO_I18N_RANGED_HEALERS = "Ranged - Heiler";
VUHDO_I18N_AUTO_DETECT = "<automatisch>";
VUHDO_I18N_PROMOTE_ASSIST_MSG_1 = "|cffffe566";
VUHDO_I18N_PROMOTE_ASSIST_MSG_2 = "|r wurde zum Assistenten ernannt.";
VUHDO_I18N_DEMOTE_ASSIST_MSG_1 = "|cffffe566";
VUHDO_I18N_DEMOTE_ASSIST_MSG_2 = "|r wurde aus den Assistenten entfernt.";
VUHDO_I18N_RESET_ROLES = "Rollen zurücksetzen";
VUHDO_I18N_LOAD_KEY_SETUP = "Spruchbelegung";
VUHDO_I18N_BUFF_ASSIGN_1 = "Buff |cffffe566";
VUHDO_I18N_BUFF_ASSIGN_2 = "|r wurde |cffffe566";
VUHDO_I18N_BUFF_ASSIGN_3 = "|r zugewiesen.";
VUHDO_I18N_MACRO_KEY_ERR_1 = "FEHLER: Die max.Größe für Tastatur-Makros wurde überschritten für: ";
VUHDO_I18N_MACRO_KEY_ERR_2 = "/256 Characters). Bitte die \"Automatisch-Zünden\"-Optionen reduzieren!";
VUHDO_I18N_MACRO_NUM_ERR = "Maximale Anzahl Makros überschritten! Kann Makro NICHT anlegen für: ";
VUHDO_I18N_SMARTBUFF_ERR_1 = "VuhDo: Smart-Cast nur außerhalb des Kampfes!";
VUHDO_I18N_SMARTBUFF_ERR_2 = "VuhDo: Keine Spieler verfügbar für: ";
VUHDO_I18N_SMARTBUFF_ERR_3 = " Spieler nicht in Reichweite für ";
VUHDO_I18N_SMARTBUFF_ERR_4 = "VuhDo: Es gibt nichts zu tun.";
VUHDO_I18N_SMARTBUFF_OKAY_1 = "VuhDo: Buffe |cffffffff";
VUHDO_I18N_SMARTBUFF_OKAY_2 = "|r auf ";
-- #+v1.189
VUHDO_I18N_UNKNOWN = "unbekannt";
VUHDO_I18N_SELF = "Selbst";
VUHDO_I18N_MELEES = "Nahkampf";
VUHDO_I18N_RANGED = "Fernkampf";
-- #+1.196
VUHDO_I18N_OPTIONS_NOT_LOADED = ">>> VuhDo-Optionen PlugIn nicht geladen! <<<";
VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST_1 = "Fehler: Spell-Layout \"";
VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST_2 = "\" existiert nicht.";
VUHDO_I18N_AUTO_ARRANG_1 = "Gruppengröße ist auf ";
VUHDO_I18N_AUTO_ARRANG_2 = " gewechselt. Lade Profil: \"";
-- #+1.209
VUHDO_I18N_OWN_GROUP_LONG = "Eigene Gruppe";
VUHDO_I18N_TRACK_BUFFS_FOR = "Buff prüfen für ...";
VUHDO_I18N_NO_FOCUS = "[kein focus]";
VUHDO_I18N_NOT_AVAILABLE = "[ N/V ]";
-- #+1.237
VUHDO_I18N_TT_DISTANCE = "|cffffb233Distanz:|r";
VUHDO_I18N_TT_OF = " von ";
VUHDO_I18N_YARDS = "Meter";
-- #+1.252
VUHDO_I18N_PANEL = "Fenster";
VUHDO_I18N_BOUQUET_AGGRO = "Flag: Aggro";
VUHDO_I18N_BOUQUET_OUT_OF_RANGE = "Flag: Reichweite, ausser";
VUHDO_I18N_BOUQUET_IN_RANGE = "Flag: Reichweite, in";
VUHDO_I18N_BOUQUET_IN_YARDS = "Flag: Entfernung < Meter";
VUHDO_I18N_BOUQUET_OTHER_HOTS = "Flag: HoTs anderer Spieler";
VUHDO_I18N_BOUQUET_DEBUFF_MAGIC = "Flag: Debuff Magie";
VUHDO_I18N_BOUQUET_DEBUFF_DISEASE = "Flag: Debuff Krankheit";
VUHDO_I18N_BOUQUET_DEBUFF_POISON = "Flag: Debuff Gift";
VUHDO_I18N_BOUQUET_DEBUFF_CURSE = "Flag: Debuff Fluch";
VUHDO_I18N_BOUQUET_CHARMED = "Flag: Übernommen";
VUHDO_I18N_BOUQUET_DEAD = "Flag: Tot";
VUHDO_I18N_BOUQUET_DISCONNECTED = "Flag: Disconnect";
VUHDO_I18N_BOUQUET_AFK = "Flag: AFK";
VUHDO_I18N_BOUQUET_PLAYER_TARGET = "Flag: Spielerziel";
VUHDO_I18N_BOUQUET_MOUSEOVER_TARGET = "Flag: Mouseover Einzeln";
VUHDO_I18N_BOUQUET_MOUSEOVER_GROUP = "Flag: Mouseover Gruppe";
VUHDO_I18N_BOUQUET_HEALTH_BELOW = "Flag: Leben < %";
VUHDO_I18N_BOUQUET_MANA_BELOW = "Flag: Mana < %";
VUHDO_I18N_BOUQUET_THREAT_ABOVE = "Flag: Bedrohung > %";
VUHDO_I18N_BOUQUET_NUM_IN_CLUSTER = "Flag: Cluster >= Spieler";
VUHDO_I18N_BOUQUET_CLASS_COLOR = "Flag: Immer Klassenfarbe";
VUHDO_I18N_BOUQUET_ALWAYS = "Flag: Immer einfarbig";
VUHDO_I18N_SWIFTMEND_POSSIBLE = "Flag: Rasche Heilung möglich";
VUHDO_I18N_BOUQUET_MOUSEOVER_CLUSTER = "Flag: Cluster, Mouseover";
VUHDO_I18N_THREAT_LEVEL_MEDIUM = "Flag: Bedrohung, Hoch";
VUHDO_I18N_THREAT_LEVEL_HIGH = "Flag: Bedrohung, Overnuke";
VUHDO_I18N_BOUQUET_STATUS_HEALTH = "Statusbar: Leben %";
VUHDO_I18N_BOUQUET_STATUS_MANA = "Statusbar: Mana %";
VUHDO_I18N_BOUQUET_STATUS_OTHER_POWERS = "Statusbar: Nicht-Mana %";
VUHDO_I18N_BOUQUET_STATUS_INCOMING = "Statusbar: Eingehende Heilung %";
VUHDO_I18N_BOUQUET_STATUS_THREAT = "Statusbar: Bedrohung %";
VUHDO_I18N_BOUQUET_NEW_ITEM_NAME = "-- (de)buff hier eingeben  --";
VUHDO_I18N_DEF_BOUQUET_TANK_COOLDOWNS = "Tank-Cooldowns";
VUHDO_I18N_DEF_BOUQUET_PW_S_WEAKENED_SOUL = "Schild & Geschwächte Seele";
VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI_AGGRO = "Rahmen: Multi + Aggro";
VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI = "Rahmen: Multi";
VUHDO_I18N_DEF_BOUQUET_BORDER_SIMPLE = "Rahmen: Einfach";
VUHDO_I18N_DEF_BOUQUET_SWIFTMENDABLE = "Rasche Heilung möglich";
VUHDO_I18N_DEF_BOUQUET_MOUSEOVER_SINGLE = "Mouseover: Einzeln";
VUHDO_I18N_DEF_BOUQUET_MOUSEOVER_MULTI = "Mouseover: Multi";
VUHDO_I18N_DEF_BOUQUET_AGGRO_INDICATOR = "Aggro-Indikator";
VUHDO_I18N_DEF_BOUQUET_CLUSTER_MOUSE_HOVER = "Cluster: Mouse Hover";
VUHDO_I18N_DEF_BOUQUET_THREAT_MARKS = "Bedrohung: Marken";
VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ALL = "Manabars: Alle Energien";
VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ONLY = "Manabars: Nur Mana";
VUHDO_I18N_DEF_BOUQUET_BAR_THREAT = "Bedrohung: Statusbalken";
VUHDO_I18N_CUSTOM_ICON_NONE = "- Kein / Default -";
VUHDO_I18N_CUSTOM_ICON_GLOSSY = "Glänzend";
VUHDO_I18N_CUSTOM_ICON_MOSAIC = "Mosaik";
VUHDO_I18N_CUSTOM_ICON_CLUSTER = "Cluster";
VUHDO_I18N_CUSTOM_ICON_FLAT = "Flach";
VUHDO_I18N_CUSTOM_ICON_SPOT = "Spot";
VUHDO_I18N_CUSTOM_ICON_CIRCLE = "Kreis";
VUHDO_I18N_CUSTOM_ICON_SKETCHED = "Rechteck";
VUHDO_I18N_CUSTOM_ICON_RHOMB = "Karo";
VUHDO_I18N_ERROR_NO_PROFILE = "Fehler: Kein Profil mit Namen: ";
VUHDO_I18N_PROFILE_LOADED = "Profil geladen: ";
VUHDO_I18N_PROFILE_SAVED = "Profil gespeichert: ";
VUHDO_I18N_PROFILE_OVERWRITE_1 = "Profil";
VUHDO_I18N_PROFILE_OVERWRITE_2 = "gehört derzeit zu \neinem anderen Char";
VUHDO_I18N_PROFILE_OVERWRITE_3 = "\n- Überschreiben: Überschreibt bestehendes Profil.\n- Copy: Erzeugt eine Kopie. Bestehendes Profil bleibt erhalten.";
VUHDO_I18N_COPY = "Kopieren";
VUHDO_I18N_OVERWRITE = "Überschreiben";
VUHDO_I18N_DISCARD = "Verwerfen";
-- 2.0, alpha #2
VUHDO_I18N_DEF_BAR_BACKGROUND_SOLID = "Hintergrund: Einfarbig";
VUHDO_I18N_DEF_BAR_BACKGROUND_CLASS_COLOR = "Hintergrund: Klassenfarbe";
-- 2.0 alpha #9
VUHDO_I18N_BOUQUET_DEBUFF_BAR_COLOR = "Flag: Debuff, konfiguriert";
-- 2.0 alpha #11
VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH = "Lebensbalken: (auto)";
VUHDO_I18N_UPDATE_RAID_TARGET = "Farbe: Schlachtzugsymbol";
VUHDO_I18N_BOUQUET_OVERHEAL_HIGHLIGHT = "Farbe: Overheal Aufheller";
VUHDO_I18N_BOUQUET_EMERGENCY_COLOR = "Farbe: Notfall";
VUHDO_I18N_BOUQUET_HEALTH_ABOVE = "Flag: Leben > %";
VUHDO_I18N_BOUQUET_RESURRECTION = "Flag: Wiederbelebung";
VUHDO_I18N_BOUQUET_STACKS_COLOR = "Farbe: #Stacks";
-- 2.1
VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_SOLID = "Leben: (auto, einfarbig)";
VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_CLASS_COLOR = "Leben: (auto, Klassenfarben)";
-- 2.9
VUHDO_I18N_NO_TARGET = "[kein Ziel]";
VUHDO_I18N_TT_LEFT = " Links: ";
VUHDO_I18N_TT_RIGHT = " Rechts: ";
VUHDO_I18N_TT_MIDDLE = " Mitte: ";
VUHDO_I18N_TT_BTN_4 = " Taste 4: ";
VUHDO_I18N_TT_BTN_5 = " Taste 5: ";
VUHDO_I18N_TT_WHEEL_UP = " Rad hoch: ";
VUHDO_I18N_TT_WHEEL_DOWN = " Rad runter: ";
-- 2.13
VUHDO_I18N_BOUQUET_CLASS_ICON = "Icon: Klasse";
VUHDO_I18N_BOUQUET_RAID_ICON = "Icon: Schlachtzugsymbol";
VUHDO_I18N_BOUQUET_ROLE_ICON = "Icon: Rolle";
-- 2.18
VUHDO_I18N_LOAD_PROFILE = "Profil laden";
-- 2.20
VUHDO_I18N_DC_SHIELD_NO_MACROS = "Keine Makro-Plätze frei... d/c-Schild abgeschaltet.";
VUHDO_I18N_BROKER_TOOLTIP_1 = "|cffffff00Linksklick|r für Optionen";
VUHDO_I18N_BROKER_TOOLTIP_2 = "|cffffff00Rechtsklick|r für Popup-Menü";
-- 2.54
VUHDO_I18N_HOURS = "Std.";
VUHDO_I18N_MINS = "Min.";
VUHDO_I18N_SECS = "Sek.";
-- 2.65
VUHDO_I18N_BOUQUET_CUSTOM_DEBUFF = "Icon: Eigener Debuff";
-- 2.66
VUHDO_I18N_OFF = "aus";
VUHDO_I18N_GHOST = "Geist";
VUHDO_I18N_RIP = "tot";
VUHDO_I18N_DC = "d/c";
VUHDO_I18N_FOC = "Fok";
VUHDO_I18N_TAR = "Ziel";
VUHDO_I18N_VEHICLE = "O-O";
VUHDO_I18N_BOUQUET_PLAYER_FOCUS = "Flag: Spielerfokus";
-- 2.67
VUHDO_I18N_BUFF_WATCH = "BuffWatch";
VUHDO_I18N_HOTS = "HoTs";
VUHDO_I18N_DEBUFFS = "Debuffs";
VUHDO_I18N_BOUQUET_PLAYER_FOCUS = "Flag: Player Focus";
-- 2.69
VUHDO_I18N_SIDE_BAR_LEFT = "Seite Links";
VUHDO_I18N_SIDE_BAR_RIGHT = "Seite Rechts";
VUHDO_I18N_OWN_PET = "Eigenes Pet";
-- 2.72
VUHDO_I18N_SPELL = "Zauber";
VUHDO_I18N_COMMAND = "Kommando";
VUHDO_I18N_MACRO = "Makro";
VUHDO_I18N_ITEM = "Item";
-- 2.75
VUHDO_I18N_ERR_NO_BOUQUET = "\"%s\" ist dem nicht existierenden Bouquet \"%s\" zugeordnet!";

VUHDO_I18N_BOUQUET_HEALTH_BELOW_ABS = "Flag: Leben < k";
VUHDO_I18N_BOUQUET_HEALTH_ABOVE_ABS = "Flag: Leben > k";
VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST = "Spruch-Layout \"%s\" existiert nicht.";

--VUHDO_I18N_ADDON_WARNING = "WARNUNG: Das möglicherweise problematische Addon |cffffffff\"%s\"|r ist mit VuhDo aktiv. Grund: %s";
--VUHDO_I18N_MAY_CAUSE_LAGS = "Kann zu erheblichen Lags führen.";

VUHDO_I18N_DISABLE_BY_VERSION = "!!! VUHDO IS DISABLED !!! This version is for client versions %d and above only !!!"

VUHDO_I18N_BOUQUET_STATUS_ALTERNATE_POWERS = "Statusbar: Alt. Energie %"
VUHDO_I18N_BOUQUET_ALTERNATE_POWERS_ABOVE = "Flag: Alt. Ernergie > %";
VUHDO_I18N_DEF_ALTERNATE_POWERS = "Alternative Energie";
VUHDO_I18N_DEF_TANK_CDS_EXTENDED = "Tank-Cooldowns erw";
VUHDO_I18N_BOUQUET_HOLY_POWER_EQUALS = "Flag: Eigene Heilige Macht ==";
VUHDO_I18N_DEF_PLAYER_HOLY_POWER = "Heilige Macht Spieler";
VUHDO_I18N_CUSTOM_ICON_ONE_THIRD = "Drittel: Eins";
VUHDO_I18N_CUSTOM_ICON_TWO_THIRDS = "Drittel: Zwei";
VUHDO_I18N_CUSTOM_ICON_THREE_THIRDS = "Drittel: Drei";
VUHDO_I18N_DEF_ROLE_ICON = "Rollen-Icon";
VUHDO_I18N_DEF_BOUQUET_TARGET_HEALTH = "Leben: (auto, Ziele)";
VUHDO_I18N_TAPPED_COLOR = "Flag: Getappt";
VUHDO_I18N_ENEMY_STATE_COLOR = "Farbe: Freund/Feind";
VUHDO_I18N_BOUQUET_STATUS_ALWAYS_FULL = "Statusbar: Immer voll";
VUHDO_I18N_BOUQUET_STATUS_FULL_IF_ACTIVE = "Statusbar: voll wenn aktiv";
VUHDO_I18N_AOE_ADVICE = "Icon: Gruppenheilung";
VUHDO_I18N_DEF_AOE_ADVICE = "Hinweis Gruppenheilung";

VUHDO_I18N_BOUQUET_DURATION_ABOVE = "Flag: Dauer > sec";
VUHDO_I18N_BOUQUET_DURATION_BELOW = "Flag: Dauer < sec";
VUHDO_I18N_DEF_WRACK = "Sinestra: Zermürben";

VUHDO_I18N_DEF_DIRECTION_ARROW = "Richtungspfeil";
VUHDO_I18N_BOUQUET_DIRECTION_ARROW = "Richtungspfeil";
VUHDO_I18N_DEF_RAID_LEADER = "Icon: Raid-Leiter";
VUHDO_I18N_DEF_RAID_ASSIST = "Icon: Raid-Assistent";
VUHDO_I18N_DEF_MASTER_LOOTER = "Icon: Loot-Meister";
VUHDO_I18N_DEF_PVP_STATUS = "Icon: PvP-Status";

VUHDO_I18N_GRID_MOUSEOVER_SINGLE = "Grid: Mouseover Einzeln";
VUHDO_I18N_GRID_BACKGROUND_BAR = "Grid: Hintergrund";
VUHDO_I18N_DEF_BIT_O_GRID = "Bit'o'Grid";
VUHDO_I18N_DEF_VUHDO_ESQUE = "Vuhdo'esque";


VUHDO_I18N_DEF_ROLE_COLOR = "Rollen-Farbe";
VUHDO_I18N_BOUQUET_ROLE_TANK = "Flag: Rolle Tank";
VUHDO_I18N_BOUQUET_ROLE_DAMAGE = "Flag: Rolle Damage-Dealer";
VUHDO_I18N_BOUQUET_ROLE_HEALER = "Flag: Rolle Heiler";

VUHDO_I18N_BOUQUET_STACKS = "Flag: Stacks >";
VUHDO_I18N_BOUQUET_TARGET_RAID_ICON = "Icon: Ziel-Schlachtzugsymbol";
VUHDO_I18N_BOUQUET_OWN_CHI_EQUALS = "Flag: Eigenes Chi ==";
VUHDO_I18N_CUSTOM_ICON_FOUR_THIRDS = "Drittel: Vier";
VUHDO_I18N_CUSTOM_ICON_FIVE_THIRDS = "Drittel: Fünf";
VUHDO_I18N_DEF_RAID_CDS = "Raid Cooldowns";
VUHDO_I18N_BOUQUET_STATUS_CLASS_COLOR_IF_ACTIVE = "Flag: Klassenfarbe wenn aktiv";

VUHDO_I18N_DEF_PVP_FLAGS="PvP-Flaggenträger";
VUHDO_I18N_DEF_STATUS_SHIELD = "Statusbar: Schilde";
VUHDO_I18N_TARGET = "Ziel";
VUHDO_I18N_FOCUS = "Fokus";
VUHDO_I18N_DEF_STATUS_OVERSHIELDED = "Statusbar: Überschildung";
