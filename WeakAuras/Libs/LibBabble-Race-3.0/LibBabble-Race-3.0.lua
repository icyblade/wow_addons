--[[
Name: LibBabble-Race-3.0
Revision: $Rev: 96 $
Maintainers: ckknight, nevcairiel, Ackis
Website: http://www.wowace.com/projects/libbabble-race-3-0/
Dependencies: None
License: MIT
]]

local MAJOR_VERSION = "LibBabble-Race-3.0"
local MINOR_VERSION = 90000 + tonumber(("$Rev: 96 $"):match("%d+"))

if not LibStub then error(MAJOR_VERSION .. " requires LibStub.") end
local lib = LibStub("LibBabble-3.0"):New(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end

local GAME_LOCALE = GetLocale()

lib:SetBaseTranslations {
	["Blood Elf"] = "Blood Elf",
	["Blood elves"] = "Blood elves",
	["Dark Iron Dwarf"] = "Dark Iron Dwarf",
	["Dark Iron Dwarves"] = "Dark Iron Dwarves",
	["Draenei"] = "Draenei",
	["Draenei_PL"] = "Draenei",
	["Dwarf"] = "Dwarf",
	["Dwarves"] = "Dwarves",
	["Felguard"] = "Felguard",
	["Felhunter"] = "Felhunter",
	["Gnome"] = "Gnome",
	["Gnomes"] = "Gnomes",
	["Goblin"] = "Goblin",
	["Goblins"] = "Goblins",
	["Highmountain Tauren"] = "Highmountain Tauren",
	["Highmountain Tauren_PL"] = "Highmountain Tauren",
	["Human"] = "Human",
	["Humans"] = "Humans",
	["Imp"] = "Imp",
	["Lightforged Draenei"] = "Lightforged Draenei",
	["Lightforged Draenei_PL"] = "Lightforged Draenei",
	["Night Elf"] = "Night Elf",
	["Night elves"] = "Night elves",
	["Nightborne"] = "Nightborne",
	["Nightborne_PL"] = "Nightborne",
	["Orc"] = "Orc",
	["Orcs"] = "Orcs",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandaren",
	["Succubus"] = "Succubus",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Tauren",
	["Troll"] = "Troll",
	["Trolls"] = "Trolls",
	["Undead"] = "Undead",
	["Undead_PL"] = "Undead",
	["Void Elf"] = "Void Elf",
	["Void elves"] = "Void elves",
	["Voidwalker"] = "Voidwalker",
	["Worgen"] = "Worgen",
	["Worgen_PL"] = "Worgen",
	["Zandalari Troll"] = "Zandalari Troll",
	["Zandalari Trolls"] = "Zandalari Trolls"
}

if GAME_LOCALE == "enUS" then
	lib:SetCurrentTranslations(true)

elseif GAME_LOCALE == "deDE" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Blutelf",
	["Blood elves"] = "Blutelfen",
	--Translation missing 
	-- ["Dark Iron Dwarf"] = "Dark Iron Dwarf",
	--Translation missing 
	-- ["Dark Iron Dwarves"] = "Dark Iron Dwarves",
	["Draenei"] = "Draenei",
	["Draenei_PL"] = "Draenei",
	["Dwarf"] = "Zwerg",
	["Dwarves"] = "Zwerge",
	["Felguard"] = "Teufelswache",
	["Felhunter"] = "Teufelsjäger",
	["Gnome"] = "Gnom",
	["Gnomes"] = "Gnome",
	["Goblin"] = "Goblin",
	["Goblins"] = "Goblins",
	--Translation missing 
	-- ["Highmountain Tauren"] = "Highmountain Tauren",
	--Translation missing 
	-- ["Highmountain Tauren_PL"] = "Highmountain Tauren",
	["Human"] = "Mensch",
	["Humans"] = "Menschen",
	["Imp"] = "Wichtel",
	--Translation missing 
	-- ["Lightforged Draenei"] = "Lightforged Draenei",
	--Translation missing 
	-- ["Lightforged Draenei_PL"] = "Lightforged Draenei",
	["Night Elf"] = "Nachtelf",
	["Night elves"] = "Nachtelfen",
	--Translation missing 
	-- ["Nightborne"] = "Nightborne",
	--Translation missing 
	-- ["Nightborne_PL"] = "Nightborne",
	["Orc"] = "Orc",
	["Orcs"] = "Orcs",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandaren",
	["Succubus"] = "Sukkubus",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Tauren",
	["Troll"] = "Troll",
	["Trolls"] = "Trolle",
	["Undead"] = "Untoter",
	["Undead_PL"] = "Untote",
	--Translation missing 
	-- ["Void Elf"] = "Void Elf",
	--Translation missing 
	-- ["Void elves"] = "Void elves",
	["Voidwalker"] = "Leerwandler",
	["Worgen"] = "Worgen",
	["Worgen_PL"] = "Worgen",
	--Translation missing 
	-- ["Zandalari Troll"] = "Zandalari Troll",
	--Translation missing 
	-- ["Zandalari Trolls"] = "Zandalari Trolls"
}
elseif GAME_LOCALE == "frFR" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Elfe de sang",
	["Blood elves"] = "Elfes de sang",
	--Translation missing 
	-- ["Dark Iron Dwarf"] = "Dark Iron Dwarf",
	--Translation missing 
	-- ["Dark Iron Dwarves"] = "Dark Iron Dwarves",
	["Draenei"] = "Draeneï",
	["Draenei_PL"] = "Draeneï",
	["Dwarf"] = "Nain",
	["Dwarves"] = "Nains",
	["Felguard"] = "Gangregarde",
	["Felhunter"] = "Chasseur corrompu",
	["Gnome"] = "Gnome",
	["Gnomes"] = "Gnomes",
	["Goblin"] = "Gobelin",
	["Goblins"] = "Gobelins",
	--Translation missing 
	-- ["Highmountain Tauren"] = "Highmountain Tauren",
	--Translation missing 
	-- ["Highmountain Tauren_PL"] = "Highmountain Tauren",
	["Human"] = "Humain",
	["Humans"] = "Humains",
	["Imp"] = "Diablotin",
	--Translation missing 
	-- ["Lightforged Draenei"] = "Lightforged Draenei",
	--Translation missing 
	-- ["Lightforged Draenei_PL"] = "Lightforged Draenei",
	["Night Elf"] = "Elfe de la nuit",
	["Night elves"] = "Elfes de la nuit",
	--Translation missing 
	-- ["Nightborne"] = "Nightborne",
	--Translation missing 
	-- ["Nightborne_PL"] = "Nightborne",
	["Orc"] = "Orc",
	["Orcs"] = "Orcs",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandaren",
	["Succubus"] = "Succube",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Taurens",
	["Troll"] = "Troll",
	["Trolls"] = "Trolls",
	["Undead"] = "Mort-vivant",
	["Undead_PL"] = "Morts-vivants",
	--Translation missing 
	-- ["Void Elf"] = "Void Elf",
	--Translation missing 
	-- ["Void elves"] = "Void elves",
	["Voidwalker"] = "Marcheur du Vide",
	["Worgen"] = "Worgen",
	["Worgen_PL"] = "Worgens",
	--Translation missing 
	-- ["Zandalari Troll"] = "Zandalari Troll",
	--Translation missing 
	-- ["Zandalari Trolls"] = "Zandalari Trolls"
}
elseif GAME_LOCALE == "koKR" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "블러드 엘프",
	["Blood elves"] = "블러드 엘프",
	--Translation missing 
	-- ["Dark Iron Dwarf"] = "Dark Iron Dwarf",
	--Translation missing 
	-- ["Dark Iron Dwarves"] = "Dark Iron Dwarves",
	["Draenei"] = "드레나이",
	["Draenei_PL"] = "드레나이",
	["Dwarf"] = "드워프",
	["Dwarves"] = "드워프",
	["Felguard"] = "지옥수호병",
	["Felhunter"] = "지옥사냥개",
	["Gnome"] = "노움",
	["Gnomes"] = "노움",
	["Goblin"] = "고블린",
	["Goblins"] = "고블린",
	--Translation missing 
	-- ["Highmountain Tauren"] = "Highmountain Tauren",
	--Translation missing 
	-- ["Highmountain Tauren_PL"] = "Highmountain Tauren",
	["Human"] = "인간",
	["Humans"] = "인간",
	["Imp"] = "임프",
	--Translation missing 
	-- ["Lightforged Draenei"] = "Lightforged Draenei",
	--Translation missing 
	-- ["Lightforged Draenei_PL"] = "Lightforged Draenei",
	["Night Elf"] = "나이트 엘프",
	["Night elves"] = "나이트 엘프",
	--Translation missing 
	-- ["Nightborne"] = "Nightborne",
	--Translation missing 
	-- ["Nightborne_PL"] = "Nightborne",
	["Orc"] = "오크",
	["Orcs"] = "오크",
	["Pandaren"] = "판다렌",
	["Pandaren_PL"] = "판다렌",
	["Succubus"] = "서큐버스",
	["Tauren"] = "타우렌",
	["Tauren_PL"] = "타우렌",
	["Troll"] = "트롤",
	["Trolls"] = "트롤",
	["Undead"] = "언데드",
	["Undead_PL"] = "언데드",
	--Translation missing 
	-- ["Void Elf"] = "Void Elf",
	--Translation missing 
	-- ["Void elves"] = "Void elves",
	["Voidwalker"] = "보이드워커",
	["Worgen"] = "늑대인간",
	["Worgen_PL"] = "늑대인간",
	--Translation missing 
	-- ["Zandalari Troll"] = "Zandalari Troll",
	--Translation missing 
	-- ["Zandalari Trolls"] = "Zandalari Trolls"
}
elseif GAME_LOCALE == "esES" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Elfo de sangre",
	["Blood elves"] = "Elfos de sangre",
	--Translation missing 
	-- ["Dark Iron Dwarf"] = "Dark Iron Dwarf",
	--Translation missing 
	-- ["Dark Iron Dwarves"] = "Dark Iron Dwarves",
	["Draenei"] = "Draenei",
	["Draenei_PL"] = "Draenei",
	["Dwarf"] = "Enano",
	["Dwarves"] = "Enanos",
	["Felguard"] = "Guardia vil",
	["Felhunter"] = "Manáfago",
	["Gnome"] = "Gnomo",
	["Gnomes"] = "Gnomos",
	["Goblin"] = "Goblin",
	["Goblins"] = "Goblins",
	--Translation missing 
	-- ["Highmountain Tauren"] = "Highmountain Tauren",
	--Translation missing 
	-- ["Highmountain Tauren_PL"] = "Highmountain Tauren",
	["Human"] = "Humano",
	["Humans"] = "Humanos",
	["Imp"] = "Diablillo",
	--Translation missing 
	-- ["Lightforged Draenei"] = "Lightforged Draenei",
	--Translation missing 
	-- ["Lightforged Draenei_PL"] = "Lightforged Draenei",
	["Night Elf"] = "Elfo de la noche",
	["Night elves"] = "Elfos de la noche",
	--Translation missing 
	-- ["Nightborne"] = "Nightborne",
	--Translation missing 
	-- ["Nightborne_PL"] = "Nightborne",
	["Orc"] = "Orco",
	["Orcs"] = "Orcos",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandaren",
	["Succubus"] = "Súcubo",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Tauren",
	["Troll"] = "Trol",
	["Trolls"] = "Trols",
	["Undead"] = "No-muerto",
	["Undead_PL"] = "No-muertos",
	--Translation missing 
	-- ["Void Elf"] = "Void Elf",
	--Translation missing 
	-- ["Void elves"] = "Void elves",
	["Voidwalker"] = "Abisario",
	["Worgen"] = "Huargen",
	["Worgen_PL"] = "Huargen",
	--Translation missing 
	-- ["Zandalari Troll"] = "Zandalari Troll",
	--Translation missing 
	-- ["Zandalari Trolls"] = "Zandalari Trolls"
}
elseif GAME_LOCALE == "esMX" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Elfo de Sangre",
	["Blood elves"] = "Elfos de sangre",
	--Translation missing 
	-- ["Dark Iron Dwarf"] = "Dark Iron Dwarf",
	--Translation missing 
	-- ["Dark Iron Dwarves"] = "Dark Iron Dwarves",
	["Draenei"] = "Draenei",
	["Draenei_PL"] = "Draenei",
	["Dwarf"] = "Enano",
	["Dwarves"] = "Enanos",
	["Felguard"] = "Guardia vil",
	["Felhunter"] = "Manáfago",
	["Gnome"] = "Gnomo",
	["Gnomes"] = "Gnomos",
	["Goblin"] = "Goblin",
	["Goblins"] = "Goblins",
	--Translation missing 
	-- ["Highmountain Tauren"] = "Highmountain Tauren",
	--Translation missing 
	-- ["Highmountain Tauren_PL"] = "Highmountain Tauren",
	["Human"] = "Humano",
	["Humans"] = "Humanos",
	["Imp"] = "Diablillo",
	--Translation missing 
	-- ["Lightforged Draenei"] = "Lightforged Draenei",
	--Translation missing 
	-- ["Lightforged Draenei_PL"] = "Lightforged Draenei",
	["Night Elf"] = "Elfo de la noche",
	["Night elves"] = "Elfos de la noche",
	--Translation missing 
	-- ["Nightborne"] = "Nightborne",
	--Translation missing 
	-- ["Nightborne_PL"] = "Nightborne",
	["Orc"] = "Orco",
	["Orcs"] = "Orcos",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandaren",
	["Succubus"] = "Súcubo",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Tauren",
	["Troll"] = "Trol",
	["Trolls"] = "Trols",
	["Undead"] = "No-muerto",
	["Undead_PL"] = "No-muertos",
	--Translation missing 
	-- ["Void Elf"] = "Void Elf",
	--Translation missing 
	-- ["Void elves"] = "Void elves",
	["Voidwalker"] = "Abisario",
	["Worgen"] = "Huargen",
	["Worgen_PL"] = "Huargen",
	--Translation missing 
	-- ["Zandalari Troll"] = "Zandalari Troll",
	--Translation missing 
	-- ["Zandalari Trolls"] = "Zandalari Trolls"
}
elseif GAME_LOCALE == "ptBR" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Elfo Sangrento",
	["Blood elves"] = "Elfos Sangrentos",
	--Translation missing 
	-- ["Dark Iron Dwarf"] = "Dark Iron Dwarf",
	--Translation missing 
	-- ["Dark Iron Dwarves"] = "Dark Iron Dwarves",
	["Draenei"] = "Draenei",
	["Draenei_PL"] = "Draeneis",
	["Dwarf"] = "Anão",
	["Dwarves"] = "Anões",
	["Felguard"] = "Guarda Vil",
	["Felhunter"] = "Caçador Vil",
	["Gnome"] = "Gnomo",
	["Gnomes"] = "Gnomos",
	["Goblin"] = "Goblin",
	["Goblins"] = "Goblins",
	--Translation missing 
	-- ["Highmountain Tauren"] = "Highmountain Tauren",
	--Translation missing 
	-- ["Highmountain Tauren_PL"] = "Highmountain Tauren",
	["Human"] = "Humano",
	["Humans"] = "Humanos",
	["Imp"] = "Diabrete",
	--Translation missing 
	-- ["Lightforged Draenei"] = "Lightforged Draenei",
	--Translation missing 
	-- ["Lightforged Draenei_PL"] = "Lightforged Draenei",
	["Night Elf"] = "Elfo Noturno",
	["Night elves"] = "Elfos Noturnos",
	--Translation missing 
	-- ["Nightborne"] = "Nightborne",
	--Translation missing 
	-- ["Nightborne_PL"] = "Nightborne",
	["Orc"] = "Orc",
	["Orcs"] = "Orcs",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandarens",
	["Succubus"] = "Súcubo",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Taurens",
	["Troll"] = "Troll",
	["Trolls"] = "Trolls",
	["Undead"] = "Renegado",
	["Undead_PL"] = "Renegados",
	--Translation missing 
	-- ["Void Elf"] = "Void Elf",
	--Translation missing 
	-- ["Void elves"] = "Void elves",
	["Voidwalker"] = "Emissário do Caos",
	["Worgen"] = "Worgen",
	["Worgen_PL"] = "Worgens",
	--Translation missing 
	-- ["Zandalari Troll"] = "Zandalari Troll",
	--Translation missing 
	-- ["Zandalari Trolls"] = "Zandalari Trolls"
}
elseif GAME_LOCALE == "itIT" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Elfo del Sangue",
	["Blood elves"] = "Elfi del Sangue",
	--Translation missing 
	-- ["Dark Iron Dwarf"] = "Dark Iron Dwarf",
	--Translation missing 
	-- ["Dark Iron Dwarves"] = "Dark Iron Dwarves",
	["Draenei"] = "Draenei",
	["Draenei_PL"] = "Draenei",
	["Dwarf"] = "Nano",
	["Dwarves"] = "Nani",
	["Felguard"] = "Vilguardiano",
	["Felhunter"] = "Vilsegugio",
	["Gnome"] = "Gnomo",
	["Gnomes"] = "Gnomi",
	["Goblin"] = "Goblin",
	["Goblins"] = "Goblins",
	--Translation missing 
	-- ["Highmountain Tauren"] = "Highmountain Tauren",
	--Translation missing 
	-- ["Highmountain Tauren_PL"] = "Highmountain Tauren",
	["Human"] = "Umano",
	["Humans"] = "Umani",
	["Imp"] = "Folletto",
	--Translation missing 
	-- ["Lightforged Draenei"] = "Lightforged Draenei",
	--Translation missing 
	-- ["Lightforged Draenei_PL"] = "Lightforged Draenei",
	["Night Elf"] = "Elfo della Notte",
	["Night elves"] = "Elfi della Notte",
	--Translation missing 
	-- ["Nightborne"] = "Nightborne",
	--Translation missing 
	-- ["Nightborne_PL"] = "Nightborne",
	["Orc"] = "Orco",
	["Orcs"] = "Orchi",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandaren",
	["Succubus"] = "Succube",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Tauren",
	["Troll"] = "Troll",
	["Trolls"] = "Trolls",
	["Undead"] = "Non Morto",
	["Undead_PL"] = "Non Morti",
	--Translation missing 
	-- ["Void Elf"] = "Void Elf",
	--Translation missing 
	-- ["Void elves"] = "Void elves",
	["Voidwalker"] = "Ombra del Vuoto",
	["Worgen"] = "Worgen",
	["Worgen_PL"] = "Worgens",
	--Translation missing 
	-- ["Zandalari Troll"] = "Zandalari Troll",
	--Translation missing 
	-- ["Zandalari Trolls"] = "Zandalari Trolls"
}
elseif GAME_LOCALE == "ruRU" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Эльф крови",
	["Blood elves"] = "Эльфы крови",
	--Translation missing 
	-- ["Dark Iron Dwarf"] = "Dark Iron Dwarf",
	--Translation missing 
	-- ["Dark Iron Dwarves"] = "Dark Iron Dwarves",
	["Draenei"] = "Дреней",
	["Draenei_PL"] = "Дренеи",
	["Dwarf"] = "Дворф",
	["Dwarves"] = "Дворфы",
	["Felguard"] = "Страж Скверны",
	["Felhunter"] = "Охотник Скверны",
	["Gnome"] = "Гном",
	["Gnomes"] = "Гномы",
	["Goblin"] = "Гоблин",
	["Goblins"] = "Гоблины",
	--Translation missing 
	-- ["Highmountain Tauren"] = "Highmountain Tauren",
	--Translation missing 
	-- ["Highmountain Tauren_PL"] = "Highmountain Tauren",
	["Human"] = "Человек",
	["Humans"] = "Люди",
	["Imp"] = "Бес",
	--Translation missing 
	-- ["Lightforged Draenei"] = "Lightforged Draenei",
	--Translation missing 
	-- ["Lightforged Draenei_PL"] = "Lightforged Draenei",
	["Night Elf"] = "Ночной эльф",
	["Night elves"] = "Ночные эльфы",
	--Translation missing 
	-- ["Nightborne"] = "Nightborne",
	--Translation missing 
	-- ["Nightborne_PL"] = "Nightborne",
	["Orc"] = "Орк",
	["Orcs"] = "Орки",
	["Pandaren"] = "Пандарен",
	["Pandaren_PL"] = "Пандарены",
	["Succubus"] = "Суккуб",
	["Tauren"] = "Таурен",
	["Tauren_PL"] = "Таурены",
	["Troll"] = "Тролль",
	["Trolls"] = "Тролли",
	["Undead"] = "Нежить",
	["Undead_PL"] = "Нежить",
	--Translation missing 
	-- ["Void Elf"] = "Void Elf",
	--Translation missing 
	-- ["Void elves"] = "Void elves",
	["Voidwalker"] = "Демон Бездны",
	["Worgen"] = "Ворген",
	["Worgen_PL"] = "Воргены",
	--Translation missing 
	-- ["Zandalari Troll"] = "Zandalari Troll",
	--Translation missing 
	-- ["Zandalari Trolls"] = "Zandalari Trolls"
}
elseif GAME_LOCALE == "zhCN" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "血精灵",
	["Blood elves"] = "血精灵",
	--Translation missing 
	-- ["Dark Iron Dwarf"] = "Dark Iron Dwarf",
	--Translation missing 
	-- ["Dark Iron Dwarves"] = "Dark Iron Dwarves",
	["Draenei"] = "德莱尼",
	["Draenei_PL"] = "德莱尼",
	["Dwarf"] = "矮人",
	["Dwarves"] = "矮人",
	["Felguard"] = "恶魔卫士",
	["Felhunter"] = "地狱猎犬",
	["Gnome"] = "侏儒",
	["Gnomes"] = "侏儒",
	["Goblin"] = "地精",
	["Goblins"] = "地精",
	--Translation missing 
	-- ["Highmountain Tauren"] = "Highmountain Tauren",
	--Translation missing 
	-- ["Highmountain Tauren_PL"] = "Highmountain Tauren",
	["Human"] = "人类",
	["Humans"] = "人类",
	["Imp"] = "小鬼",
	--Translation missing 
	-- ["Lightforged Draenei"] = "Lightforged Draenei",
	--Translation missing 
	-- ["Lightforged Draenei_PL"] = "Lightforged Draenei",
	["Night Elf"] = "暗夜精灵",
	["Night elves"] = "暗夜精灵",
	--Translation missing 
	-- ["Nightborne"] = "Nightborne",
	--Translation missing 
	-- ["Nightborne_PL"] = "Nightborne",
	["Orc"] = "兽人",
	["Orcs"] = "兽人",
	["Pandaren"] = "熊猫人",
	["Pandaren_PL"] = "熊猫人",
	["Succubus"] = "魅魔",
	["Tauren"] = "牛头人",
	["Tauren_PL"] = "牛头人",
	["Troll"] = "巨魔",
	["Trolls"] = "巨魔",
	["Undead"] = "亡灵",
	["Undead_PL"] = "亡灵",
	--Translation missing 
	-- ["Void Elf"] = "Void Elf",
	--Translation missing 
	-- ["Void elves"] = "Void elves",
	["Voidwalker"] = "虚空行者",
	["Worgen"] = "狼人",
	["Worgen_PL"] = "狼人",
	--Translation missing 
	-- ["Zandalari Troll"] = "Zandalari Troll",
	--Translation missing 
	-- ["Zandalari Trolls"] = "Zandalari Trolls"
}
elseif GAME_LOCALE == "zhTW" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "血精靈",
	["Blood elves"] = "血精靈",
	--Translation missing 
	-- ["Dark Iron Dwarf"] = "Dark Iron Dwarf",
	--Translation missing 
	-- ["Dark Iron Dwarves"] = "Dark Iron Dwarves",
	["Draenei"] = "德萊尼",
	["Draenei_PL"] = "德萊尼",
	["Dwarf"] = "矮人",
	["Dwarves"] = "矮人",
	["Felguard"] = "惡魔守衛",
	["Felhunter"] = "惡魔獵犬",
	["Gnome"] = "地精",
	["Gnomes"] = "地精",
	["Goblin"] = "哥布林",
	["Goblins"] = "哥布林",
	--Translation missing 
	-- ["Highmountain Tauren"] = "Highmountain Tauren",
	--Translation missing 
	-- ["Highmountain Tauren_PL"] = "Highmountain Tauren",
	["Human"] = "人類",
	["Humans"] = "人類",
	["Imp"] = "小鬼",
	--Translation missing 
	-- ["Lightforged Draenei"] = "Lightforged Draenei",
	--Translation missing 
	-- ["Lightforged Draenei_PL"] = "Lightforged Draenei",
	["Night Elf"] = "夜精靈",
	["Night elves"] = "夜精靈",
	--Translation missing 
	-- ["Nightborne"] = "Nightborne",
	--Translation missing 
	-- ["Nightborne_PL"] = "Nightborne",
	["Orc"] = "獸人",
	["Orcs"] = "獸人",
	["Pandaren"] = "熊貓人",
	["Pandaren_PL"] = "熊貓人",
	["Succubus"] = "魅魔",
	["Tauren"] = "牛頭人",
	["Tauren_PL"] = "牛頭人",
	["Troll"] = "食人妖",
	["Trolls"] = "食人妖",
	["Undead"] = "不死族",
	["Undead_PL"] = "不死族",
	--Translation missing 
	-- ["Void Elf"] = "Void Elf",
	--Translation missing 
	-- ["Void elves"] = "Void elves",
	["Voidwalker"] = "虛無行者",
	["Worgen"] = "狼人",
	["Worgen_PL"] = "狼人",
	--Translation missing 
	-- ["Zandalari Troll"] = "Zandalari Troll",
	--Translation missing 
	-- ["Zandalari Trolls"] = "Zandalari Trolls"
}
else
	error(("%s: Locale %q not supported"):format(MAJOR_VERSION, GAME_LOCALE))
end
