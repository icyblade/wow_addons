if (GetLocale() ~= "ruRU") then
	return;
end
-- Class Names
-- @EXACT = false
VUHDO_I18N_WARRIORS="Воины"
VUHDO_I18N_ROGUES = "Разбойники";
VUHDO_I18N_HUNTERS = "Охотники";
VUHDO_I18N_PALADINS = "Паладины";
VUHDO_I18N_MAGES = "Маги";
VUHDO_I18N_WARLOCKS = "Чернокнижники";
VUHDO_I18N_SHAMANS = "Шаманы";
VUHDO_I18N_DRUIDS = "Друиды";
VUHDO_I18N_PRIESTS = "Жрецы";
VUHDO_I18N_DEATH_KNIGHT = "Рыцари Смерти";


-- Group Model Names
-- @EXACT = false
VUHDO_I18N_GROUP = "Группа";
VUHDO_I18N_OWN_GROUP = "Ваша\nгруппа";


-- Special Model Names
-- @EXACT = false
VUHDO_I18N_PETS = "Питомцы";
VUHDO_I18N_MAINTANKS = "Главные\nтанки";
VUHDO_I18N_PRIVATE_TANKS = "Личные\nтанки";



-- General Labels
-- @EXACT = false
VUHDO_I18N_OKAY = "ОК";
VUHDO_I18N_CLASS = "Класс";
VUHDO_I18N_UNDEFINED = "<n/a>";
VUHDO_I18N_PLAYER = "Игрок";


-- VuhDoTooltip.lua
-- @EXACT = false
VUHDO_I18N_TT_POSITION = "|cffffb233Позиция:|r";
VUHDO_I18N_TT_GHOST = "<ПРИЗРАК>";
VUHDO_I18N_TT_DEAD = "<МЁРТВ>";
VUHDO_I18N_TT_AFK = "<AFK>";
VUHDO_I18N_TT_DND = "<DND>";
VUHDO_I18N_TT_LIFE = "|cffffb233Здоровье:|r ";
VUHDO_I18N_TT_MANA = "|cffffb233Мана:|r ";
VUHDO_I18N_TT_LEVEL = "Уровень ";


-- VuhDoPanel.lua
-- @EXACT = false
VUHDO_I18N_CHOOSE = "Выбрать";
VUHDO_I18N_DRAG = "Перетащи";
VUHDO_I18N_REMOVE = "Удалить";
VUHDO_I18N_ME = "меня!";
VUHDO_I18N_TYPE = "Тип";
VUHDO_I18N_VALUE = "Значение";
VUHDO_I18N_SPECIAL = "Особый";
VUHDO_I18N_BUFF_ALL = "Все";
VUHDO_I18N_SHOW_BUFF_WATCH = "Отслеживание баффов.";

-- @EXACT = true
--
VUHDO_I18N_RANK = "Уровень";


-- Chat messages
-- @EXACT = false
VUHDO_I18N_COMMAND_LIST = "\n|cffffe566 - [ Команды VuhDo ] -|r";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566opt|r[ions] - настройки VuhDo";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566res|r[et] - сбросить позицию панелей";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566lock|r - вкл./выкл. закрепление панелей";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566mm, map, minimap|r - вкл./выкл. иконку у миникарты";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566show, hide, toggle|r - включить/выключить панели";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566load|r - [Skin],[Arrangement],[Key Layout]";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§[broad]|cffffe566cast, mt|r[s] - передать список главных танков рейду";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566role|r - сбросить роли игроков";
VUHDO_I18N_COMMAND_LIST = VUHDO_I18N_COMMAND_LIST .. "§|cffffe566help,?|r - список данных команд\n";

VUHDO_I18N_BAD_COMMAND = "Некорректный аргумент! Введите '/vuhdo help' или '/vd ?' для получения списка команд.";
VUHDO_I18N_CHAT_SHOWN = "|cffffe566shown|r.";
VUHDO_I18N_CHAT_HIDDEN = "|cffffe566hidden|r.";
VUHDO_I18N_MM_ICON = "Иконка у миникарты: ";
VUHDO_I18N_MTS_BROADCASTED = "Основные танки переданы в рейд";
VUHDO_I18N_PANELS_SHOWN = "Панель исцеления: |cffffe566shown|r.";
VUHDO_I18N_PANELS_HIDDEN = "Панель исцеления: |cffffe566hidden|r.";
VUHDO_I18N_LOCK_PANELS_PRE = "Позиция панели: ";
VUHDO_I18N_LOCK_PANELS_LOCKED = "|cffffe566locked|r.";
VUHDO_I18N_LOCK_PANELS_UNLOCKED = "|cffffe566unlocked|r.";
VUHDO_I18N_PANELS_RESET = "Позиция панели сброшена.";


-- Config Pop-Up
-- @EXACT = false
VUHDO_I18N_ROLE = "Роль";
VUHDO_I18N_PRIVATE_TANK = "Личный танк";
VUHDO_I18N_SET_BUFF = "Назначьте баф";


-- Minimap
-- @EXACT = false
VUHDO_I18N_VUHDO_OPTIONS = "Настройки VuhDo";
VUHDO_I18N_PANEL_SETUP = "Настройки";
VUHDO_I18N_MM_TOOLTIP = "ЛКМ: Настройки панели\nПКМ: Меню";
VUHDO_I18N_TOGGLES = "Переключает";
VUHDO_I18N_LOCK_PANELS = "Закрепить\nпанель";
VUHDO_I18N_SHOW_PANELS = "Показать панели";
VUHDO_I18N_MM_BUTTON = "Кнопка у мини-карты";
VUHDO_I18N_CLOSE = "Закрыть";
VUHDO_I18N_BROADCAST_MTS = "Передать Главных Танков";


-- Buff categories
-- @EXACT = false
-- Priest
-- Shaman
VUHDO_I18N_BUFFC_FIRE_TOTEM = "01Тотем огня";
VUHDO_I18N_BUFFC_AIR_TOTEM = "02Тотем воздуха";
VUHDO_I18N_BUFFC_EARTH_TOTEM = "03Тотем земли";
VUHDO_I18N_BUFFC_WATER_TOTEM = "04Тотем воды";
VUHDO_I18N_BUFFC_WEAPON_ENCHANT = "08Зачарование оружия";
VUHDO_I18N_BUFFC_WEAPON_ENCHANT_2 = "13Зачарование оружия 2";
VUHDO_I18N_BUFFC_SHIELDS = "09Щиты";
-- Paladin
VUHDO_I18N_BUFFC_BLESSING = "01Благословение";
VUHDO_I18N_BUFFC_AURA = "02Аура";
VUHDO_I18N_BUFFC_SEAL = "03Печать";
-- Druids
-- Warlock
VUHDO_I18N_BUFFC_SKIN = "01Шкура";
-- Mage
VUHDO_I18N_BUFFC_ARMOR_MAGE = "03Доспех";
-- Death Knight
VUHDO_BUFFC_PRESENCE    = "03Власть";
-- Warrior
VUHDO_I18N_BUFFC_SHOUT = "01Крик";
-- Hunter
VUHDO_I18N_BUFFC_ASPECT = "02Дух";
-- Key Binding Headers/Names
-- @EXACT = false
BINDING_HEADER_VUHDO_TITLE = "VuhDo";
BINDING_NAME_VUHDO_KEY_ASSIGN_1 = "Заклинание 1";
BINDING_NAME_VUHDO_KEY_ASSIGN_2 = "Заклинание 2";
BINDING_NAME_VUHDO_KEY_ASSIGN_3 = "Заклинание 3";
BINDING_NAME_VUHDO_KEY_ASSIGN_4 = "Заклинание 4";
BINDING_NAME_VUHDO_KEY_ASSIGN_5 = "Заклинание 5";
BINDING_NAME_VUHDO_KEY_ASSIGN_6 = "Заклинание 6";
BINDING_NAME_VUHDO_KEY_ASSIGN_7 = "Заклинание 7";
BINDING_NAME_VUHDO_KEY_ASSIGN_8 = "Заклинание 8";
BINDING_NAME_VUHDO_KEY_ASSIGN_9 = "Заклинание 9";
BINDING_NAME_VUHDO_KEY_ASSIGN_10 = "Заклинание 10";
BINDING_NAME_VUHDO_KEY_ASSIGN_11 = "Заклинание 11";
BINDING_NAME_VUHDO_KEY_ASSIGN_12 = "Заклинание 12";
BINDING_NAME_VUHDO_KEY_ASSIGN_13 = "Заклинание 13";
BINDING_NAME_VUHDO_KEY_ASSIGN_14 = "Заклинание 14";
BINDING_NAME_VUHDO_KEY_ASSIGN_15 = "Заклинание 15";
BINDING_NAME_VUHDO_KEY_ASSIGN_16 = "Заклинание 16";

BINDING_NAME_VUHDO_KEY_ASSIGN_SMART_BUFF = "Умный бафф";

VUHDO_I18N_MOUSE_OVER_BINDING = "Применить заклинание";
VUHDO_I18N_UNASSIGNED = "(не назначено)";


-- #+V1.89
VUHDO_I18N_YES = "Да";
VUHDO_I18N_NO = "Нет";
VUHDO_I18N_UP = "Вверх";
VUHDO_I18N_DOWN = "Вниз";
VUHDO_I18N_VEHICLES = "Транспорт";


-- #+v1.94
VUHDO_I18N_DEFAULT_RES_ANNOUNCE = "vuhdo, вернись к жизни, вагон!";

-- #v+1.151
VUHDO_I18N_MAIN_ASSISTS = "Наводчики";

-- #v+1.169
VUHDO_I18N_O_REALLY = "Точно?";


-- #+v1.184
VUHDO_I18N_BW_CD = "CD";
VUHDO_I18N_BW_GO = "GO!";
VUHDO_I18N_BW_LOW = "LOW";
VUHDO_I18N_BW_N_A = "|cffff0000N/A|r";
VUHDO_I18N_BW_RNG_RED = "|cffff0000RNG|r";
VUHDO_I18N_BW_OK = "OK";
VUHDO_I18N_BW_RNG_YELLOW = "|cffffff00RNG|r";

VUHDO_I18N_PROMOTE_RAID_LEADER = "Назначить лидером рейда";
VUHDO_I18N_PROMOTE_ASSISTANT = "Назначить помощником";
VUHDO_I18N_DEMOTE_ASSISTANT = "Разжаловать из помощников";
VUHDO_I18N_PROMOTE_MASTER_LOOTER = "Назначить ответственным за добычу";
VUHDO_I18N_MT_NUMBER = "Главный Танк #";
VUHDO_I18N_ROLE_OVERRIDE = "Исполняемая роль";
VUHDO_I18N_MELEE_TANK = "Ближний бой - Танк";
VUHDO_I18N_MELEE_DPS = "Ближний бой - ДД";
VUHDO_I18N_RANGED_DPS = "Дальний бой - ДД";
VUHDO_I18N_RANGED_HEALERS = "Дальний бой - Лекарь";
VUHDO_I18N_AUTO_DETECT = "<автообнаружение>";
VUHDO_I18N_PROMOTE_ASSIST_MSG_1 = "Произведён |cffffe566";
VUHDO_I18N_PROMOTE_ASSIST_MSG_2 = "|r в помощники.";
VUHDO_I18N_DEMOTE_ASSIST_MSG_1 = "Разжалует |cffffe566";
VUHDO_I18N_DEMOTE_ASSIST_MSG_2 = "|r из помощников.";
VUHDO_I18N_RESET_ROLES = "Сбросить роли";
VUHDO_I18N_LOAD_KEY_SETUP = "Загрузить набор клавиш";
VUHDO_I18N_BUFF_ASSIGN_1 = "Бафф |cffffe566";
VUHDO_I18N_BUFF_ASSIGN_2 = "|r был назначен на |cffffe566";
VUHDO_I18N_BUFF_ASSIGN_3 = "|r";
VUHDO_I18N_MACRO_KEY_ERR_1 = "ОШИБКА: размер макроса, назначенного на клавишу превышает ограничение: ";
VUHDO_I18N_MACRO_KEY_ERR_2 = "/256 символов). Попробуйте уменьшить автоиспользование!";
VUHDO_I18N_MACRO_NUM_ERR = "Превышено максимальное количество макросов для персонажа! Не удается создать макрос для: ";
VUHDO_I18N_SMARTBUFF_ERR_1 = "VuhDo: Нельзя применять умный бафф в бою!";
VUHDO_I18N_SMARTBUFF_ERR_2 = "VuhDo: Нет доступных целей для ";
VUHDO_I18N_SMARTBUFF_ERR_3 = " игроков вне зоны действия для ";
VUHDO_I18N_SMARTBUFF_ERR_4 = "VuhDo: Нечего применять.";
VUHDO_I18N_SMARTBUFF_OKAY_1 = "VuhDo: Накладываю |cffffffff";
VUHDO_I18N_SMARTBUFF_OKAY_2 = "|r на ";
VUHDO_I18N_SET_BUFF_TARGET_1 = "Установка цели баффа для ";
VUHDO_I18N_SET_BUFF_TARGET_2 = " до ";


-- #+v1.189
VUHDO_I18N_UNKNOWN = "Неизвестно";
VUHDO_I18N_SELF = "Вы";
VUHDO_I18N_MELEES = "Ближний бой";
VUHDO_I18N_RANGED = "Дальний бой";

-- #+1.196
VUHDO_I18N_OPTIONS_NOT_LOADED = ">>> Модуль настроек VuhDo не загружен! <<<";
VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST_1 = "Ошибка: Размещение заклинания \"";
VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST_2 = "\" не существует.";
VUHDO_I18N_AUTO_ARRANG_1 = "Количество участников группы изменено на: ";
VUHDO_I18N_AUTO_ARRANG_2 = ". Автоприменение расположения: \"";

-- #+1.209
VUHDO_I18N_OWN_GROUP_LONG = "Свою группу";
VUHDO_I18N_TRACK_BUFFS_FOR = "Слежение баффа для ...";

VUHDO_I18N_NO_FOCUS = "[нет фокуса]";
VUHDO_I18N_NOT_AVAILABLE = "[ N/A ]";
VUHDO_I18N_SHIELD_ABSORPTION = "Статус щита";


-- #+1.237
VUHDO_I18N_TT_DISTANCE = "|cffffb233Расстояние:|r";
VUHDO_I18N_TT_OF = " - ";
VUHDO_I18N_YARDS = "метров";


-- #+1.252
VUHDO_I18N_PANEL = "Панель";

VUHDO_I18N_BOUQUET_AGGRO = "Флаг: Агро";
VUHDO_I18N_BOUQUET_OUT_OF_RANGE = "Флаг: дальность, вне";
VUHDO_I18N_BOUQUET_IN_RANGE = "Флаг: дальность, в";
VUHDO_I18N_BOUQUET_IN_YARDS = "Флаг: Расстояние < ярдов";
VUHDO_I18N_BOUQUET_OTHER_HOTS = "Флаг: HoT'ы других игроков";
VUHDO_I18N_BOUQUET_DEBUFF_DISPELLABLE = "Флаг: Дебафф, рассеиваемый";
VUHDO_I18N_BOUQUET_DEBUFF_MAGIC = "Флаг: Дебафф - магия";
VUHDO_I18N_BOUQUET_DEBUFF_DISEASE = "Флаг: Дебаф - болезнь";
VUHDO_I18N_BOUQUET_DEBUFF_POISON = "Флаг: Дебаф - яд";
VUHDO_I18N_BOUQUET_DEBUFF_CURSE = "Флаг: Дебаф - проклятие";
VUHDO_I18N_BOUQUET_CHARMED = "Флаг: Подчинение";
VUHDO_I18N_BOUQUET_DEAD = "Флаг: Труп";
VUHDO_I18N_BOUQUET_DISCONNECTED = "Флаг: Не в сети";
VUHDO_I18N_BOUQUET_AFK = "Флаг: Отошел";
VUHDO_I18N_BOUQUET_PLAYER_TARGET = "Флаг: Цель игрока";
VUHDO_I18N_BOUQUET_MOUSEOVER_TARGET = "Флаг: Курсор над целью";
VUHDO_I18N_BOUQUET_MOUSEOVER_GROUP = "Флаг: Курсор над группой";
VUHDO_I18N_BOUQUET_HEALTH_BELOW = "Флаг: Здоровье < %";
VUHDO_I18N_BOUQUET_MANA_BELOW = "Флаг: Мана < %";
VUHDO_I18N_BOUQUET_THREAT_ABOVE = "Флаг: Угроза > %";
VUHDO_I18N_BOUQUET_NUM_IN_CLUSTER = "Флаг: Кластер >= игроков";
VUHDO_I18N_BOUQUET_CLASS_COLOR = "Флаг: Цвет класса";
VUHDO_I18N_BOUQUET_ALWAYS = "Флаг: Фиксированный цвет";
VUHDO_I18N_SWIFTMEND_POSSIBLE = "Флаг: Быстрое восстановление";
VUHDO_I18N_BOUQUET_MOUSEOVER_CLUSTER = "Флаг: Курсор над кластером";
VUHDO_I18N_THREAT_LEVEL_MEDIUM = "Флаг: Угроза, высокая";
VUHDO_I18N_THREAT_LEVEL_HIGH = "Флаг: Угроза, критическая";
VUHDO_I18N_BOUQUET_STATUS_HEALTH = "Статус: Здоровье %";
VUHDO_I18N_BOUQUET_STATUS_MANA = "Статус: Мана %";
VUHDO_I18N_BOUQUET_STATUS_OTHER_POWERS = "Статус: Энергия %";
VUHDO_I18N_BOUQUET_STATUS_INCOMING = "Статус: Вход. Исцеление %";
VUHDO_I18N_BOUQUET_STATUS_THREAT = "Статус: Угроза %";
VUHDO_I18N_BOUQUET_NEW_ITEM_NAME = "-- введите сюда (де)баф --";


VUHDO_I18N_DEF_BOUQUET_TANK_COOLDOWNS = "Откаты танка";
VUHDO_I18N_DEF_BOUQUET_PW_S_WEAKENED_SOUL = "СС:Щ и Ослабленная душа";
VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI_AGGRO = "Границы: Комплексная + угроза";
VUHDO_I18N_DEF_BOUQUET_BORDER_MULTI = "Границы: Комплексная";
VUHDO_I18N_DEF_BOUQUET_BORDER_SIMPLE = "Границы: Простая";
VUHDO_I18N_DEF_BOUQUET_SWIFTMENDABLE = "Доступен для Быстрого Восстановления";
VUHDO_I18N_DEF_BOUQUET_MOUSEOVER_SINGLE = "Наведение мыши: Цель";
VUHDO_I18N_DEF_BOUQUET_MOUSEOVER_MULTI = "Наведение мыши: Группа";
VUHDO_I18N_DEF_BOUQUET_AGGRO_INDICATOR = "Индикатор Агро";
VUHDO_I18N_DEF_BOUQUET_CLUSTER_MOUSE_HOVER = "Кластер: Наведение мыши";
VUHDO_I18N_DEF_BOUQUET_THREAT_MARKS = "Угроза: Метки";
VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ALL = "Полоса маны: Все виды энергии";
VUHDO_I18N_DEF_BOUQUET_BAR_MANA_ONLY = "Полоса маны: Мана";
VUHDO_I18N_DEF_BOUQUET_BAR_THREAT = "Угроза: Статус";


VUHDO_I18N_CUSTOM_ICON_NONE = "- Нет / По умолчанию -";
VUHDO_I18N_CUSTOM_ICON_GLOSSY = "Блестящий";
VUHDO_I18N_CUSTOM_ICON_MOSAIC = "Мозаика";
VUHDO_I18N_CUSTOM_ICON_CLUSTER = "Кластер";
VUHDO_I18N_CUSTOM_ICON_FLAT = "Простой";
VUHDO_I18N_CUSTOM_ICON_SPOT = "Пятно";
VUHDO_I18N_CUSTOM_ICON_CIRCLE = "Окружность";
VUHDO_I18N_CUSTOM_ICON_SKETCHED = "Набросок";
VUHDO_I18N_CUSTOM_ICON_RHOMB = "Ромб";


VUHDO_I18N_OUTER_BORDER = "Снаружи";
VUHDO_I18N_INNER_BORDER = "Внутри";
VUHDO_I18N_SWIFTMEND_INDICATOR = "Быстр. Восст.";
VUHDO_I18N_MOUSEOVER_HIGHLIGHTER = "Наведение мыши";
VUHDO_I18N_THREAT_MARKS = "Метки угрозы";
VUHDO_I18N_THREAT_BAR = "Полоса угрозы";
VUHDO_I18N_AGGRO_LINE = "Полоса Агро";
VUHDO_I18N_MANA_BAR = "Полоска маны";
VUHDO_I18N_BORDER_WIDTH = "Ширина";

VUHDO_I18N_ERROR_NO_PROFILE = "Ошибка: Нет профиля с названием: ";
VUHDO_I18N_PROFILE_LOADED = "Профиль успешно загружен: ";
VUHDO_I18N_PROFILE_SAVED = "Профиль успешно сохранен: ";
VUHDO_I18N_PROFILE_OVERWRITE_1 = "Профиль";
VUHDO_I18N_PROFILE_OVERWRITE_2 = "закреплен за\nдругим персонажем";
VUHDO_I18N_PROFILE_OVERWRITE_3 = "\n- Перезаписать: Существующий профиль будет перезаписан.\n- Копировать: Создать и сохранить копию. Сохранив текущий профиль.";
VUHDO_I18N_COPY = "Копировать";
VUHDO_I18N_OVERWRITE = "Перезаписать";
VUHDO_I18N_DISCARD = "Отменить";

-- 2.0, alpha #2
VUHDO_I18N_DEF_BAR_BACKGROUND_SOLID = "Фон: Фиксированный";
VUHDO_I18N_DEF_BAR_BACKGROUND_CLASS_COLOR = "Фон: Цвет класса";

-- 2.0 alpha #9
VUHDO_I18N_BOUQUET_DEBUFF_BAR_COLOR = "Флаг: Дебафф, настраиваемый";
VUHDO_I18N_BACKGROUND_BAR = "Фон полосы";

-- 2.0 alpha #11
VUHDO_I18N_HEALTH_BAR = "Полоса здоровья";
VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH = "Здоровье (градиент)";
VUHDO_I18N_UPDATE_RAID_TARGET = "Флаг: Цвет цели рейда";
VUHDO_I18N_BOUQUET_OVERHEAL_HIGHLIGHT = "Цвет: подсветка переисцеления";
VUHDO_I18N_BOUQUET_EMERGENCY_COLOR = "Цвет: критическое положение";
VUHDO_I18N_BOUQUET_HEALTH_ABOVE = "Флаг: Здоровье > %";
VUHDO_I18N_BOUQUET_RESURRECTION = "Флаг: Воскрешение";
VUHDO_I18N_BOUQUET_STACKS_COLOR = "Цвет: Стаки";

-- 2.1
VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_SOLID = "Здоровье (простое)";
VUHDO_I18N_DEF_BOUQUET_BAR_HEALTH_CLASS_COLOR = "Здоровье (цвет класса)";

-- 2.9
VUHDO_I18N_NO_TARGET = "[нет цели]";
VUHDO_I18N_TT_LEFT = " ЛКМ: ";
VUHDO_I18N_TT_RIGHT = " ПКМ: ";
VUHDO_I18N_TT_MIDDLE = " СКМ: ";
VUHDO_I18N_TT_BTN_4 = " Кнопка 4: ";
VUHDO_I18N_TT_BTN_5 = " Кнопка 5: ";
VUHDO_I18N_TT_WHEEL_UP = " Колесо вверх: ";
VUHDO_I18N_TT_WHEEL_DOWN = " Колесо вниз: ";


-- 2.13
VUHDO_I18N_BOUQUET_CLASS_ICON = "Иконка: Класс";
VUHDO_I18N_BOUQUET_RAID_ICON = "Иконка: Метка рейда";
VUHDO_I18N_BOUQUET_ROLE_ICON = "Иконка: Роль";

-- 2.18
VUHDO_I18N_LOAD_PROFILE = "Загрузить профиль";

-- 2.20
VUHDO_I18N_DC_SHIELD_NO_MACROS = "Нет свободных слотов для макросов у этого персонажа... Временно отключено восстановление после разрыва связи.";
VUHDO_I18N_BROKER_TOOLTIP_1 = "|cffffff00ЛКМ|r Окно настроек";
VUHDO_I18N_BROKER_TOOLTIP_2 = "|cffffff00ПКМ|r Всплывающее меню";
-- 2.54
VUHDO_I18N_HOURS = "ч.";
VUHDO_I18N_MINS = "мин.";
VUHDO_I18N_SECS = "сек.";
-- 2.65
VUHDO_I18N_BOUQUET_CUSTOM_DEBUFF = "Иконка: Свой дебафф";
-- 2.66
VUHDO_I18N_OFF = "выкл";
VUHDO_I18N_GHOST = "призрак";
VUHDO_I18N_RIP = "мертв";
VUHDO_I18N_DC = "d/c";
VUHDO_I18N_FOC = "фок";
VUHDO_I18N_TAR = "цель";
VUHDO_I18N_VEHICLE = "O-O";
-- 2.67
VUHDO_I18N_BUFF_WATCH = "BuffWatch";
VUHDO_I18N_HOTS = "HoT'ы";
VUHDO_I18N_DEBUFFS = "Дебафф";
VUHDO_I18N_BOUQUET_PLAYER_FOCUS = "Флаг: Фокус игрока";
-- 2.69
VUHDO_I18N_SIDE_BAR_LEFT = "Левая сторона";
VUHDO_I18N_SIDE_BAR_RIGHT = "Правая сторона";
VUHDO_I18N_OWN_PET = "Ваш питомец";
-- 2.72
VUHDO_I18N_SPELL = "Spell";
VUHDO_I18N_COMMAND = "Command";
VUHDO_I18N_MACRO = "Macro";
VUHDO_I18N_ITEM = "Item";
-- 2.75
VUHDO_I18N_ERR_NO_BOUQUET = "\"%s\" tries to hook to bouquet \"%s\" which doesn't exist!";

VUHDO_I18N_BOUQUET_HEALTH_BELOW_ABS = "Flag: Health < k";
VUHDO_I18N_BOUQUET_HEALTH_ABOVE_ABS = "Flag: Health > k";
VUHDO_I18N_SPELL_LAYOUT_NOT_EXIST = "Spell layout \"%s\" doesn't exist.";

--VUHDO_I18N_ADDON_WARNING = "WARNING: Addon |cffffffff\"%s\"|r is enabled along with VuhDo, which may be problematic. Reason: %s";
--VUHDO_I18N_MAY_CAUSE_LAGS = "May cause severe lags.";

VUHDO_I18N_DISABLE_BY_VERSION = "!!! VUHDO IS DISABLED !!! This version is for client versions %d and above only !!!"

VUHDO_I18N_BOUQUET_STATUS_ALTERNATE_POWERS = "Statusbar: Alternate Power %"
VUHDO_I18N_BOUQUET_ALTERNATE_POWERS_ABOVE = "Flag: Alternate Power > %";
VUHDO_I18N_DEF_ALTERNATE_POWERS = "Alternative Powers";
VUHDO_I18N_BOUQUET_HOLY_POWER_EQUALS = "Flag: Own Holy Power ==";
VUHDO_I18N_DEF_PLAYER_HOLY_POWER = "Player Holy Power";
VUHDO_I18N_CUSTOM_ICON_ONE_THIRD = "Thirds: One";
VUHDO_I18N_CUSTOM_ICON_TWO_THIRDS = "Thirds: Two"
VUHDO_I18N_CUSTOM_ICON_THREE_THIRDS = "Thirds: Three";
VUHDO_I18N_DEF_ROLE_ICON = "Role Icon";
VUHDO_I18N_DEF_BOUQUET_TARGET_HEALTH = "Health (generic, target)";
VUHDO_I18N_TAPPED_COLOR = "Flag: Tapped";
VUHDO_I18N_ENEMY_STATE_COLOR = "Color: Friend/Foe";
VUHDO_I18N_BOUQUET_STATUS_ALWAYS_FULL = "Statusbar: always full";
VUHDO_I18N_BOUQUET_STATUS_FULL_IF_ACTIVE = "Statusbar: full if active";
VUHDO_I18N_AOE_ADVICE = "Icon: AOE Advice";
VUHDO_I18N_DEF_AOE_ADVICE = "AOE Advice";
VUHDO_I18N_BOUQUET_DURATION_ABOVE = "Flag: Duration > sec";
VUHDO_I18N_BOUQUET_DURATION_BELOW = "Flag: Duration < sec";
VUHDO_I18N_DEF_WRACK = "Sinestra: Wrack";

VUHDO_I18N_DEF_DIRECTION_ARROW = "Direction Arrow";
VUHDO_I18N_BOUQUET_DIRECTION_ARROW = "Direction Arrow";
VUHDO_I18N_DEF_RAID_LEADER = "Icon: Raid leader";
VUHDO_I18N_DEF_RAID_ASSIST = "Icon: Raid assist";
VUHDO_I18N_DEF_MASTER_LOOTER = "Icon: Master looter";
VUHDO_I18N_DEF_PVP_STATUS = "Icon: PvP Status";

VUHDO_I18N_GRID_MOUSEOVER_SINGLE = "Grid: Mouseover Single";
VUHDO_I18N_GRID_BACKGROUND_BAR = "Grid: Background Bar";
VUHDO_I18N_DEF_BIT_O_GRID = "Bit'o'Grid";
VUHDO_I18N_DEF_VUHDO_ESQUE = "Vuhdo'esque";


VUHDO_I18N_DEF_ROLE_COLOR = "Role Color";
VUHDO_I18N_BOUQUET_ROLE_TANK = "Flag: Role Tank";
VUHDO_I18N_BOUQUET_ROLE_DAMAGE = "Flag: Role Damager";
VUHDO_I18N_BOUQUET_ROLE_HEALER = "Flag: Role Healer";
VUHDO_I18N_BOUQUET_STACKS = "Flag: Stacks >";
