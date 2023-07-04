-- -------------------------------------------------------------------------- --
-- BattlegroundTargets Localized Race Names                                   --
-- Please make sure to save this file as UTF-8. ¶                             --
-- -------------------------------------------------------------------------- --
local HORDE = 0
local ALLIANCE = 1
local locale = GetLocale()
if locale == "deDE" then
	BattlegroundTargets_RaceNames = { -- 15 | data from Patch 4.3.0.15050 (LIVE)
		["Blutelf"] = HORDE,
		["Zwerg"] = ALLIANCE,
		["Worgen"] = ALLIANCE,
		["Goblin"] = HORDE,
		["Orc"] = HORDE,
		["Nachtelf"] = ALLIANCE,
		["Gnom"] = ALLIANCE,
		["Troll"] = HORDE,
		["Blutelfe"] = HORDE,
		["Untoter"] = HORDE,
		["Draenei"] = ALLIANCE,
		["Mensch"] = ALLIANCE,
		["Tauren"] = HORDE,
		["Nachtelfe"] = ALLIANCE,
		["Untote"] = HORDE,
	}
elseif locale == "esES" then
	BattlegroundTargets_RaceNames = { -- 17 | data from Patch 4.3.0.15050 (LIVE)
		["Trol"] = HORDE,
		["Humano"] = ALLIANCE,
		["Elfo de sangre"] = HORDE,
		["Orco"] = HORDE,
		["Gnoma"] = ALLIANCE,
		["Draenei"] = ALLIANCE,
		["Elfa de la noche"] = ALLIANCE,
		["Enano"] = ALLIANCE,
		["Humana"] = ALLIANCE,
		["Elfa de sangre"] = HORDE,
		["Tauren"] = HORDE,
		["No-muerto"] = HORDE,
		["Gnomo"] = ALLIANCE,
		["Elfo de la noche"] = ALLIANCE,
		["Huargen"] = ALLIANCE,
		["No-muerta"] = HORDE,
		["Goblin"] = HORDE,
	}
elseif locale == "esMX" then
	BattlegroundTargets_RaceNames = { -- 17 | data from Patch 4.3.2.15201 (PTR)
		["Trol"] = HORDE,
		["Goblin"] = HORDE,
		["Elfa de la noche"] = ALLIANCE,
		["Enano"] = ALLIANCE,
		["Elfo de la noche"] = ALLIANCE,
		["Humano"] = ALLIANCE,
		["Draenei"] = ALLIANCE,
		["Elfo de sangre"] = HORDE,
		["Elfa de sangre"] = HORDE,
		["Tauren"] = HORDE,
		["No-muerta"] = HORDE,
		["Gnoma"] = ALLIANCE,
		["Gnomo"] = ALLIANCE,
		["Orco"] = HORDE,
		["Huargen"] = ALLIANCE,
		["No-muerto"] = HORDE,
		["Humana"] = ALLIANCE,
	}
elseif locale == "frFR" then
	BattlegroundTargets_RaceNames = { -- 18 | data from Patch 4.3.0.15050 (LIVE)
		["Orc"] = HORDE,
		["Mort-vivant"] = HORDE,
		["Troll"] = HORDE,
		["Humaine"] = ALLIANCE,
		["Draeneï"] = ALLIANCE,
		["Humain"] = ALLIANCE,
		["Orque"] = HORDE,
		["Worgen"] = ALLIANCE,
		["Gnome"] = ALLIANCE,
		["Taurène"] = HORDE,
		["Elfe de sang"] = HORDE,
		["Tauren"] = HORDE,
		["Nain"] = ALLIANCE,
		["Elfe de la nuit"] = ALLIANCE,
		["Trollesse"] = HORDE,
		["Morte-vivante"] = HORDE,
		["Gobelin"] = HORDE,
		["Gobeline"] = HORDE,
	}
elseif locale == "koKR" then
	BattlegroundTargets_RaceNames = { -- 12 | data from Patch 4.3.2.15201 (PTR)
		["트롤"] = HORDE,
		["늑대인간"] = ALLIANCE,
		["드레나이"] = ALLIANCE,
		["고블린"] = HORDE,
		["드워프"] = ALLIANCE,
		["언데드"] = HORDE,
		["노움"] = ALLIANCE,
		["타우렌"] = HORDE,
		["오크"] = HORDE,
		["인간"] = ALLIANCE,
		["나이트 엘프"] = ALLIANCE,
		["블러드 엘프"] = HORDE,
	}
elseif locale == "ptBR" then
	BattlegroundTargets_RaceNames = { -- 24 | data from Patch 4.3.0.15050 (LIVE)
		["Morto-vivo"] = HORDE,
		["Orquisa"] = HORDE,
		["Worgenin"] = ALLIANCE,
		["Orc"] = HORDE,
		["Troll"] = HORDE,
		["Gnomida"] = ALLIANCE,
		["Taurena"] = HORDE,
		["Anão"] = ALLIANCE,
		["Draenei"] = ALLIANCE,
		["Elfa Sangrenta"] = HORDE,
		["Worgen"] = ALLIANCE,
		["Draenaia"] = ALLIANCE,
		["Anã"] = ALLIANCE,
		["Goblin"] = HORDE,
		["Trolesa"] = HORDE,
		["Elfo Noturno"] = ALLIANCE,
		["Morta-viva"] = HORDE,
		["Tauren"] = HORDE,
		["Elfo Sangrento"] = HORDE,
		["Gnomo"] = ALLIANCE,
		["Elfa Noturna"] = ALLIANCE,
		["Humano"] = ALLIANCE,
		["Goblina"] = HORDE,
		["Humana"] = ALLIANCE,
	}
elseif locale == "ruRU" then
	BattlegroundTargets_RaceNames = { -- 12 | data from Patch 4.3.2.15201 (PTR)
		["Человек"] = ALLIANCE,
		["Нежить"] = HORDE,
		["Дворф"] = ALLIANCE,
		["Эльфийка крови"] = HORDE,
		["Ночной эльф"] = ALLIANCE,
		["Орк"] = HORDE,
		["Гном"] = ALLIANCE,
		["Таурен"] = HORDE,
		["Тролль"] = HORDE,
		["Гоблин"] = HORDE,
		["Ночная эльфийка"] = ALLIANCE,
		["Ворген"] = ALLIANCE,
	}
elseif locale == "zhCN" then
	BattlegroundTargets_RaceNames = { -- 12 | data from Patch 4.3.2.15201 (PTR)
		["人类"] = ALLIANCE,
		["亡灵"] = HORDE,
		["暗夜精灵"] = ALLIANCE,
		["侏儒"] = ALLIANCE,
		["德莱尼"] = ALLIANCE,
		["兽人"] = HORDE,
		["狼人"] = ALLIANCE,
		["牛头人"] = HORDE,
		["血精灵"] = HORDE,
		["地精"] = HORDE,
		["矮人"] = ALLIANCE,
		["巨魔"] = HORDE,
	}
elseif locale == "zhTW" then
	BattlegroundTargets_RaceNames = { -- 12 | data from Patch 4.3.2.15201 (PTR)
		["德萊尼"] = ALLIANCE,
		["哥布林"] = HORDE,
		["血精靈"] = HORDE,
		["不死族"] = HORDE,
		["地精"] = ALLIANCE,
		["獸人"] = HORDE,
		["夜精靈"] = ALLIANCE,
		["狼人"] = ALLIANCE,
		["食人妖"] = HORDE,
		["人類"] = ALLIANCE,
		["矮人"] = ALLIANCE,
		["牛頭人"] = HORDE,
	}
else
	BattlegroundTargets_RaceNames = { -- 12 | data from Patch 4.3.0.15050 (LIVE)
		["Draenei"] = ALLIANCE,
		["Worgen"] = ALLIANCE,
		["Blood Elf"] = HORDE,
		["Orc"] = HORDE,
		["Gnome"] = ALLIANCE,
		["Troll"] = HORDE,
		["Tauren"] = HORDE,
		["Dwarf"] = ALLIANCE,
		["Undead"] = HORDE,
		["Human"] = ALLIANCE,
		["Night Elf"] = ALLIANCE,
		["Goblin"] = HORDE,
	}
end