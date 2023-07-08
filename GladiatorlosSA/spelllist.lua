function GladiatorlosSA:GetSpellList () 
	return {
		auraApplied ={					-- aura applied [spellid] = ".mp3 file name",
			--general
			--druid
			[61336] = "survivalInstincts", -- 求生本能
			[29166] = "innervate", -- 啟動
			[22812] = "barkskin", -- 樹皮術
			[17116] = "naturesSwiftness", -- 自然迅捷
			[16689] = "naturesGrasp", -- 自然之握
			[22842] = "frenziedRegeneration", -- 狂暴恢復
			[5229] = "enrage", -- 狂怒
			[1850] = "dash", -- 疾奔
			[50334] = "berserk", -- 狂暴
			[69369] = "predatorSwiftness", -- PredatorSwiftness 猛獸迅捷
			--paladin
			[31821] = "auraMastery", -- 光環精通
			[1022] = "handOfProtection", -- 保護
			[1044] = "handOfFreedom", -- 自由
			[642] = "divineShield", -- 無敵
			[6940] = "sacrifice", -- 犧牲祝福
			[54428] = "divinePlea", -- 神性祈求
			[85696] = "zealotry", -- 狂熱精神
			[31884] = "avengingWrath",
			--rogue
			[51713] = "shadowDance", -- 暗影之舞
			[2983] = "sprint", -- 疾跑
			[31224] = "cloakOfShadows", -- 斗篷
			[13750] = "adrenalineRush", -- 衝動
			[5277] = "evasion", -- 閃避
			[74001] = "combatReadiness", -- 戰鬥就緒
			--warrior
			[55694] = "enragedRegeneration", -- 狂怒恢復
			[871] = "shieldWall", --盾墻
			[18499] = "berserkerRage", -- 狂暴之怒
			[20230] = "retaliation", -- 反擊風暴
			[23920] = "spellReflection", -- 盾反
			[12328] = "sweepingStrikes", -- 橫掃攻擊
			[46924] = "bladestorm", -- 劍刃風暴
			[85730] = "deadlyCalm", -- 沉著殺機
			[12292] = "deathWish", -- 死亡之願
			[1719] = "recklessness", -- 魯莽
			--preist
			[33206] = "painSuppression", -- 痛苦壓制
			[37274] = "powerInfusion", -- 能量灌注
			[6346] = "fearWard", -- 反恐
			[47585] = "dispersion", -- 消散
			[89485] = "innerFocus", -- 心靈專注
			[87153] = "darkArchangel",
			[87152] = "archangel",
			[47788] = "guardianSpirit",
			--shaman
			[52127] = "waterShield", -- 水盾
			[30823] = "shamanisticRage", -- 薩滿之怒
			[974] = "earthShield", -- 大地之盾
			[16188] = "naturesSwiftness2", -- 自然迅捷
			[79206] = "spiritwalkersGrace",
			[16166] = "elementalMastery",
			--mage
			[45438] = "iceBlock", -- 寒冰屏障
			[12042] = "arcanePower", -- 秘法強化
			[12472] = "icyVeins", --冰脈
			--dk
			[49039] = "lichborne", -- 巫妖之軀
			[48792] = "iceboundFortitude", -- 冰固
			[55233] = "vampiricBlood", -- 血族之裔
			[49016] = "unholyFrenzy", -- 邪惡狂熱
			[51271] = "pillarofFrost",
			[48707] = "antiMagicShell",
			--hunter
			[34471] = "theBeastWithin", -- 獸心
			[19263] = "deterrence", -- 威懾
			[3045] = "rapidFire",
			[54216] = "mastersCall",
		},
		auraRemoved = {					-- aura removed [spellid] = ".mp3 file name",
			[642] = "bubbleDown", -- 無敵結束
			[47585] = "dispersionDown", -- 消散結束
			[1022] = "protectionDown", -- 保護結束
			[31224] = "cloakDown", -- 斗篷結束
			[74001] = "combatReadinessDown", -- 戰鬥就緒結束
			[871] = "shieldWallDown", -- 盾墻結束
			[33206] = "PSDown", -- 壓制結束
			[5277] = "evasionDown", -- 閃避結束
			[45438] = "iceBlockDown", -- 冰箱結束
			[49039] = "lichborneDown", -- 巫妖之軀結束
			[48792] = "iceboundFortitudeDown", -- 冰固結束 
			--[34471] = "theBeastWithinDown", -- 獸心結束
			[19263] = "deterrenceDown", -- 威懾結束
		},
		castStart = {					-- cast start [spellid] = ".mp3 file name",
			--general
			[2060] = "bigHeal",
			[82326] = "bigHeal",
			[77472] = "bigHeal",
			[5185] = "bigHeal", -- 強效治療術 神光術 強效治療波 治療之觸
			[2006] = "resurrection",
			[7328] = "resurrection",
			[2008] = "resurrection",
			[50769] = "resurrection", -- 復活術 救贖 先祖之魂 復活
			--hunter
			[982] = "revivePet", -- 復活寵物
			--druid
			[2637] = "hibernate", -- 休眠
			[33786] = "cyclone", -- 吹風
			--paladin
			--rogue
			--warrior
			--preist		
			[8129] = "manaBurn", -- 法力燃燒
			[9484] = "shackleUndead", -- 束縛亡靈
			[605] = "mindControl", -- 精神控制
			--shaman
			[51514] = "hex", -- 妖術
			[76780] = "bindElemental", -- 元素束縛
			--maga
			[118] = "polymorph",
			[28272] = "polymorph",
			[61305] = "polymorph",
			[61721] = "polymorph",
			[61025] = "polymorph",
			[61780] = "polymorph",
			[28271] = "polymorph", -- 變形術 羊豬貓兔蛇雞龜
			--dk
			[49203] = "hungeringCold", -- 噬溫酷寒
			--hunter
			[1513] = "scareBeast", -- 恐嚇野獸
			--warlock
			[710] = "banish", -- 放逐術
			[5782] = "fear", -- 恐懼
			[5484] = "fear2", -- 恐懼嚎叫
			[691] = "summonDemon",
			[712] = "summonDemon",
			[697] = "summonDemon",
			[688] = "summonDemon",
		},
		castSuccess = {					--cast success [spellid] = ".mp3 file name",
			--general
			[58984] = "shadowmeld", -- 影遁			
			[20594] = "stoneform", -- 石像形態
			[7744] = "willOfTheForsaken", -- 亡靈意志
			[42292] = "trinket",
			[59752] = "trinket", -- 徽章
			--druid
			[80964] = "skullBash",
			[80965] = "skullBash", -- 碎顱猛擊
			[740] = "tranquility", 
			[78675] = "solarBeam", -- 太陽光束
			--paladin
			[96231] = "rebuke", -- 責難
			[20066] = "repentance", -- 懺悔
			[853] = "hammerofjustice", -- 制裁
			--rogue
			[51722] = "disarm2", -- 拆卸
			[2094] = "blind", -- 致盲
			[1766] = "kick", -- 腳踢
			[14185] = "preparation", -- 準備就緒
			[1856] = "vanish", -- 消失
			[76577] = "smokeBomb", -- 煙霧彈
			[14177] = "coldblood", -- 冷血
			[73981] = "redirect",
			[79140] = "vendetta",
			--warrior
			[97462] = "rallyingCry", -- 集結怒吼
			[676] = "disarm", -- 繳械
			[5246] = "fear3", -- 破膽怒吼
			[6552] = "pummel", -- 拳擊
			--[72] = "shieldBash", -- 盾擊
			[85388] = "throwdown", -- 撂倒
			[2457] = "battlestance", -- 戰鬥姿態
			[71] = "defensestance", -- 防禦姿態
			[2458] = "berserkerstance", -- 狂暴姿態
			--priest
			[8122] = "fear4", -- 心靈尖嘯
			[34433] = "shadowFiend", -- 暗影惡魔
			[64044] = "disarm3", -- 心靈驚駭
			[15487] = "silence", -- 沉默
			[64843] = "divineHymn",
			[19236] = "desperatePrayer",
			--shaman
			[8177] = "grounding", -- 根基圖騰
			[16190] = "manaTide", -- 法力之潮
			[8143] = "tremorTotem", -- 戰慄圖騰
			[98008] = "spiritlinktotem", -- 靈魂鏈接圖騰
			--mage
			[11958] = "coldSnap", -- 急速冷卻
			[44572] = "deepFreeze", -- 深結
			[2139] = "counterspell", -- 法術反制
			[66] = "invisibility", -- 隐形术
			[82676] = "ringOfFrost", -- 霜之環
			[12051] = "evocation",
			--dk
			[47528] = "mindFreeze", -- 心智冰封
			[47476] = "strangulate", -- 絞殺
			[47568] = "runeWeapon", -- 強力符文武器
			[49206] = "gargoyle", -- 召喚石像鬼
			[77606] = "darkSimulacrum", -- 黑暗幻象
			--hunter
			[19386] = "wyvernSting", -- 翼龍釘刺
			[23989] = "readiness", -- 準備就緒
			--[51755] = "camouflage", -- 偽裝
			[19503] = "scattershot", -- 驅散射擊
			[34490] = "silencingshot", -- 沉默射擊
			[1499] = "freezingTrap",
			[60192] = "freezingTrap2",
			--warlock
			[6789] = "deathCoil", -- Death Coil 死亡纏繞
			[5484] = "fear2", -- 恐懼嚎叫
			[19647] = "spellLock", -- 法術封鎖
			[48020] = "demonicCircleTeleport", -- 惡魔法陣:傳送
			[77801] = "demonSoul",
		},
		friendlyInterrupt = {			--friendly interrupt [spellid] = ".mp3 file name",
			[19647] = "lockout", -- Spell Lock
			[2139] = "lockout", -- Counter Spell
			[1766] = "lockout", -- Kick
			[6552] = "lockout", -- Pummel
			[47528] = "lockout", -- Mind Freeze
			[96231] = "lockout", -- Rebuke
			[93985] = "lockout", -- Skull Bash
			[97547] = "lockout", -- Solar Beam
		},
	}
end

