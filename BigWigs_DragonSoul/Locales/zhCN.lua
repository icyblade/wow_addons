local L = BigWigs:NewBossLocale("Morchok", "zhCN")
if not L then return end
if L then
	L.engage_trigger = "你妄想阻止雪崩。我只会埋葬你。"

	L.crush = "破甲"
	L.crush_desc = "只警报坦克。破甲堆叠计数并显示持续条。"
	L.crush_message = "%2$d层破甲：>%1$s<！"

	L.blood = "大地黑血"

	L.explosion = "爆裂水晶"
	L.crystal = "共鸣水晶"
end

L = BigWigs:NewBossLocale("Warlord Zon'ozz", "zhCN")
if L then
	L.engage_trigger = "Zzof Shuul'wah。Thoq fssh N'Zoth！"

	L.ball = "末日黑洞"
	L.ball_desc = "末日黑洞在玩家和首领之间来回弹跳时发出警报。"
	L.ball_yell = "Gul'kafh an'qov N'Zoth。"

	L.bounce = "末日黑洞弹跳"
	L.bounce_desc = "末日黑洞弹跳计数。"

	L.darkness = "触手迪斯科聚会！"
	L.darkness_desc = "当此阶段开始，末日黑洞撞击首领。"

	L.shadows = "干扰之影"
end

L = BigWigs:NewBossLocale("Yor'sahj the Unsleeping", "zhCN")
if L then
	L.engage_trigger = "Iilth qi'uothk shn'ma yeh'glu Shath'Yar！H'IWN IILTH！"

	L.bolt_desc = "只警报坦克。虚空箭堆叠计数并显示持续条。"
	L.bolt_message = "%2$d层虚空箭：>%1$s<！"

	L.blue = "|cFF0080FF蓝|r"
	L.green = "|cFF088A08绿|r"
	L.purple = "|cFF9932CD紫|r"
	L.yellow = "|cFFFFA901黄|r"
	L.black = "|cFF424242黑|r"
	L.red = "|cFFFF0404红|r"

	L.blobs = "血球"
	L.blobs_bar = "下一血球"
	L.blobs_desc = "当血球向首领移动时发出警报。"
end

L = BigWigs:NewBossLocale("Hagara the Stormbinder", "zhCN")
if L then
	L.engage_trigger = "你们竟敢挑战缚风者！我要杀光你们。"

	L.lightning_or_frost = "闪电或寒冰"
	L.ice_next = "寒冰阶段"
	L.lightning_next = "闪电阶段"

	L.assault_desc = "只警报坦克和治疗。"..select(2, EJ_GetSectionInfo(4159))

	L.nextphase = "下一阶段"
	L.nextphase_desc = "当下一阶段时发出警报。"
end

L = BigWigs:NewBossLocale("Ultraxion", "zhCN")
if L then
	L.engage_trigger = "暮光审判降临了！"

	L.warmup = "暮光审判"
	L.warmup_desc = "暮光审判计时器。"
	L.warmup_trigger = "我即是末日的开端……蔽日的阴影……毁灭的丧钟……"

	L.crystal = "增益水晶"
	L.crystal_desc = "守护巨龙召唤各种增益水晶计时器。"
	L.crystal_red = "生命赐福红水晶"
	L.crystal_green = "梦境精华绿水晶"
	L.crystal_blue = "魔力之源蓝水晶"

	L.twilight = "暮光审判"
	L.cast = "暮光审判施法条"
	L.cast_desc = "显示暮光审判5秒施法条。"

	L.lightself = "自身黯淡之光"
	L.lightself_desc = "显示自身黯淡之光爆炸剩余计时条。"
	L.lightself_bar = "<你将爆炸>"

	L.lighttank = "坦克黯淡之光"
	L.lighttank_desc = "只警报坦克。如果坦克中了黯淡之光，显示一个爆炸计时条及闪屏震动。"
	L.lighttank_bar = "<%s 爆炸>"
	L.lighttank_message = "坦克爆炸！"
end

L = BigWigs:NewBossLocale("Warmaster Blackhorn", "zhCN")
if L then
	L.warmup = "热身"
	L.warmup_desc = "首领战斗开始之前的计时器。"

	L.sunder = "破甲攻击"
	L.sunder_desc = "只警报坦克。破甲攻击堆叠计数并显示持续条。"
	L.sunder_message = "%2$d层破甲攻击：>%1$s<！"

	L.sapper_trigger = "一条幼龙俯冲下来，往甲板上投放了一个暮光工兵！"
	L.sapper = "暮光工兵"
	L.sapper_desc = "暮光工兵对天火号造成伤害。"

	L.stage2_trigger = "看来我得亲自动手了。很好！"
end

L = BigWigs:NewBossLocale("Spine of Deathwing", "zhCN")
if L then
	L.engage_trigger = "看那些装甲！他正在解体！摧毁那些装甲，我们就能给他最后一击！"

	L.about_to_roll = "感觉到玩家在他的"
	L.rolling = "%%s往[左右]+侧"
	L.not_hooked = ">你< 没有抓牢！"
	L.roll_message = "他开始滚了！滚了，滚啦！"
	L.level_trigger = "平衡"
	L.level_message = "别急，他已经平衡了！"

	L.exposed = "装甲暴露"

	L.residue = "未吸收的残渣"
	L.residue_desc = "当地面上还有剩余未吸收的残渣时发出警报，等待被吸收。"
	L.residue_message = "残渣：>%d<！"
end

L = BigWigs:NewBossLocale("Madness of Deathwing", "zhCN")
if L then
	L.engage_trigger = "你们什么都没做到。我要撕碎你们的世界。"

	-- Copy & Paste from Encounter Journal with correct health percentages (type '/dump EJ_GetSectionInfo(4103)' in the game)
	L.smalltentacles_desc = "在生命值降至70%和40%时，肢体触须会衍生出许多灼疮触须，这些触须对具有范围效果的技能免疫。"

	L.bolt_explode = "<源质箭爆炸>"
	L.parasite = "腐蚀寄生虫"
	L.blobs_soon = "%d%% - 即将凝固之血！"
end

