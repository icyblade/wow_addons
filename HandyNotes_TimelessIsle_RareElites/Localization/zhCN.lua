if GetLocale() ~= 'zhCN' then return end
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
local L = HandyNotes.Locals

L.OptionsDescription = "永恒岛稀有精英位置显示"
L.OptionsArgsDescription = "调整图标外观"
L.OptionsIconScaleName = "图标大小"
L.OptionsIconScaleDescription = "图标的大小"
L.OptionsIconAlphaName = "图标透明度"
L.OptionsIconAlphaDescription = "图标的透明度"

L.EmeralGander = "翠羽公鹤"
L.EmeralGanderDrop = "风翎鹤羽"
L.EmeralGanderInfo = "在天神庭院周围有许多刷新点。"

L.IronfurSteelhorn = "铁鬃铜角牛"
L.IronfurSteelhornDrop = "一簇牦牛毛"

L.ImperialPython = "帝王巨蟒"
L.ImperialPythonDrop = "致死小蝰蛇"

L.GreatTurtleFuryshell = "怒壳巨龟"
L.GreatTurtleFuryshellDrop = "硬化之壳"
L.GreatTurtleFuryshellInfo = "在西海岸巡逻。"

L.GuchiSwarmbringer = "虫群先锋古赤"
L.GuchiSwarmbringerDrop = "古赤的蚕宝宝"
L.GuchiSwarmbringerInfo = "在老酒湾附近刷新。"

L.Zesqua = "泽泉"
L.ZesquaDrop = "降雨之石"
L.ZesquaInfo = "在老酒湾的海岸东边。"

L.ZhuGonSour = "泛酸的筑汞"
L.ZhuGonSourDrop = "酒灵臭臭"
L.ZhuGonSourInfo = "在老酒湾刷新的稀有事件，完成后可看见稀有精英泛酸的筑汞。"

L.Karkanos = "卡卡诺斯"
L.KarkanosDrop = "一大包永恒铸币"
L.KarkanosInfo = "码头会刷新钓手，与之对话可召唤卡卡诺斯。"

L.Chelon = "蛰龙"
L.ChelonDrop = "硬化之壳"
L.ChelonInfo = "蛰龙刷新时为龟壳，点击后即可召唤出蛰龙。"

L.Spelurk = "斯普鲁克"
L.SpelurkDrop = "被诅咒的护身符"
L.SpelurkInfo = "秘密巢穴洞口被塌方覆盖，进入的玩家需要点击左边石头旁的巨锤以砸开塌方，同时斯普鲁克刷新。法师可以闪现进去用里面的巨锤砸开塌方。"

L.Cranegnasher = "噬鹤者"
L.CranegnasherDrop = "新鲜的追猎者之皮"
L.CranegnasherInfo = "需要召唤。 地上出现可调查的嗜鱼鹤尸体时，从南边拉一只嗜鱼鹤过来它就会跳下来。"

L.Rattleskew = "响骨"
L.RattleskewDrop = "扎维兹坦船长的断腿"
L.RattleskewInfo = "沉船会刷新触发事件：藤壶号之战，在水下帮助npc击败几波幽灵海盗后，响骨会刷新。"

L.MonstrousSpineclaw = "凶暴钳爪蟹"
L.MonstrousSpineclawDrop = "钳爪小螃蟹"
L.MonstrousSpineclawInfo = "海边所有可能的钳爪蟹刷新点。"

L.SpiritJadefire = "玉火之灵"
L.SpiritJadefireDrop = "发光的绿色灰烬"
L.SpiritJadefireDrop2 = "玉火炎灵"
L.SpiritJadefireInfo = "孤魂岩洞内刷新。"

L.Leafmender = "剪叶者"
L.LeafmenderDrop = "灰叶小林精"
L.LeafmenderInfo = "永恒岛下方蹈火者上方精英野牛人区。"

L.Bufo = "布佛"
L.BufoDrop = "幼年巨口娃"
L.BufoInfo = "在有很多巨口娃的区域刷新。"

L.Garnia = "加尼亚"
L.GarniaDrop = "红玉小水滴"
L.GarniaInfo = "在红玉湖刷新，只能坐信天翁上去。"

L.Tsavoka = "查沃卡"
L.TsavokaDrop = "新鲜的追踪者之皮"
L.TsavokaInfo = "在查沃卡巢穴中刷新。"

L.Stinkbraid = "斯汀克布莱德"
L.StinkbraidInfo = "右下海面上的海盗船上。"

L.RockMoss = "石苔"
L.RockMossDrop = "金苔藓"
L.RockMossInfo = "孤魂岩洞深处。"

L.WatcherOsu = "斥候奥苏"
L.WatcherOsuDrop = "灰烬之石"
L.WatcherOsuInfo = "蹈火者小径。"

L.JakurOrdon = "神战士迦库尔"
L.JakurOrdonDrop = "警告标志"
L.JakurOrdonInfo = "蹈火者废墟悬崖边缘处。"

L.ChampionBlackFlame = "黑火勇士"
L.ChampionBlackFlameDrop = "黑火匕首"
L.ChampionBlackFlameDrop2 = "一大袋草药"
L.ChampionBlackFlameInfo = "蹈火者小径，不停的沿着道路巡逻。黑火勇士是3个一组的野牛人。"

L.Cinderfall = "落烬"
L.CinderfallDrop = "坠焰"
L.CinderfallInfo = "断桥处。"

L.UrdurCauterizer = "烙印者乌都尔"
L.UrdurCauterizerDrop = "日落之石"
L.UrdurCauterizerInfo = "斡耳朵神殿外围墙边。"

L.FlintlordGairan = "燧石领主铠兰"
L.FlintlordGairanDrop = "斡耳朵死亡之钟"
L.FlintlordGairanInfo = "斡耳朵神殿周围有很多刷新点。"

L.Huolon = "惑龙"
L.HuolonDrop = "雷霆玛瑙云端祥龙的缰绳"
L.HuolonInfo = "在蹈火者之径附近的天空中飞翔。"

L.Golganarr = "高戈纳尔"
L.GolganarrDrop = "古怪的抛光石"
L.GolganarrDrop2 = "一堆闪亮的石头"
L.GolganarrInfo = "就在这附近刷新。"

L.Evermaw = "吞天"
L.EvermawDrop = "雾气缭绕的幽魂灯笼"
L.EvermawInfo = "此标记不是确切的位置，因为这货沿着海岸一直在游。"

L.DreadShipVazuvius = "幽灵船瓦组维斯号"
L.DreadShipVazuviusDrop = "迷时水手结晶"
L.DreadShipVazuviusInfo = "需要在海边的墓碑处使用击杀稀有吞天后获得的物品雾气缭绕的幽魂灯笼才会出现。"

L.ArchiereusFlame = "烈焰祭司阿克鲁斯"
L.ArchiereusFlameDrop = "远古知识药剂"
L.ArchiereusFlameInfo = "在斡耳朵圣殿内刷新，所以没有橙色披风的玩家只能在挑战者之石处使用挑战卷轴。"

L.Rattleskew ="响骨 - 扎维兹坦船长"
L.RattleskewDrop ="扎维兹坦船长遗失的小腿"
L.RattleskewDrop2 ="工艺图:骷髅雕文"
L.RattleskewInfo ="随机事件“藤壶号之战”：东南部半艘沉船(60.6, 87.2)的甲板上出现扎维兹坦船长及其手下剑客时，击败围攻它们的亡灵水手后刷新。"


HandyNotes.Locals = L
