﻿-- Simplified Chinese by Diablohu(diablohudream@gmail.com) & yleaf(yaroot@gmail.com)
-- Last update: 1/14/2012

if GetLocale() ~= "zhCN" then return end

local L

--------------------------
--  General BG Options  --
--------------------------
L = DBM:GetModLocalization("Battlegrounds")

L:SetGeneralLocalization({
	name = "常规设置"
})

L:SetTimerLocalization({
	TimerInvite = "%s"
})

L:SetOptionLocalization({
	ColorByClass	= "得分板上玩家按职业着色",
	ShowInviteTimer	= "显示加入计时",
	AutoSpirit	= "自动释放灵魂",
	HideBossEmoteFrame	= "隐藏团队首领表情框体"
})

L:SetMiscLocalization({
	ArenaInvite	= "竞技场邀请"
})

--------------
--  Arenas  --
--------------
L = DBM:GetModLocalization("Arenas")

L:SetGeneralLocalization({
	name = "竞技场"
})

L:SetTimerLocalization({
	TimerShadow	= "暗影之眼"
})

L:SetOptionLocalization({
	TimerShadow 	= "显示暗影水晶计时"
})

L:SetMiscLocalization({
	Start15 = "竞技场战斗将在十五秒后开始！"
})

----------------------
--  Alterac Valley  --
----------------------
L = DBM:GetModLocalization("AlteracValley")

L:SetGeneralLocalization({
	name = "奥特兰克山谷"
})

L:SetTimerLocalization({
	TimerStart = "战斗即将开始", 
	TimerTower = "%s",
	TimerGY = "%s",
})

L:SetMiscLocalization({
	BgStart60 = "奥特兰克山谷的战斗将在1分钟之后开始。",
	BgStart30 = "奥特兰克山谷的战斗将在30秒之后开始。"
})

L:SetOptionLocalization({
	TimerStart  = "显示开始计时",
	TimerTower = "显示哨塔占领计时",
	TimerGY = "显示墓地占领计时",
	AutoTurnIn = "自动递交任务物品"
})

--------------------
--  Arathi Basin  --
--------------------
L = DBM:GetModLocalization("ArathiBasin")

L:SetGeneralLocalization({
	name = "阿拉希盆地"
})

L:SetMiscLocalization({
	BgStart60 = "阿拉希盆地的战斗将在1分钟后开始。",
	BgStart30 = "阿拉希盆地的战斗将在30秒后开始。",
	ScoreExpr = "(%d+)/1600",
	Alliance = "联盟",
	Horde = "部落",
	WinBarText = "%s 获胜",
	BasesToWin = "胜利需要占领资源: %d",
	Flag = "旗帜"
})

L:SetTimerLocalization({
	TimerStart = "战斗即将开始", 
	TimerCap = "%s",
})

L:SetOptionLocalization({
	TimerStart  = "显示开始计时",
	TimerWin = "显示获胜计时",
	TimerCap = "显示占领计时",
	ShowAbEstimatedPoints = "显示战斗结束时双方资源统计",
	ShowAbBasesToWin = "显示获胜需要占领的资源点"
})

------------------------
--  Eye of the Storm  --
------------------------
L = DBM:GetModLocalization("EyeoftheStorm")

L:SetGeneralLocalization({
	name = "风暴之眼"
})

L:SetMiscLocalization({
	BgStart60 = "战斗将在1分钟后开始！",
	BgStart30 = "战斗将在30秒后开始！",
	ZoneName = "风暴之眼",
	ScoreExpr = "(%d+)/1600",
	Alliance = "联盟",
	Horde = "部落",
	WinBarText = "%s 获胜",
	FlagReset = "旗帜被重新放置了。!",
	FlagTaken = "(.+)夺走了旗帜！",
	FlagCaptured = "(.+)夺得了旗帜！",
	FlagDropped = "旗帜被扔掉了！",

})

L:SetTimerLocalization({
	TimerStart = "战斗即将开始", 
	TimerFlag = "旗帜重置",
})

L:SetOptionLocalization({
	TimerStart  = "显示开始计时",
	TimerWin = "显示获胜计时",
	TimerFlag = "显示旗帜重置计时",
	ShowPointFrame = "显示旗帜携带着和获胜计时",
})

---------------------
--  Warsong Gulch  --
---------------------
L = DBM:GetModLocalization("WarsongGulch")

L:SetGeneralLocalization({
	name = "战歌峡谷"
})

L:SetMiscLocalization({
	BgStart60 = "战歌峡谷战斗将在1分钟内开始。",
	BgStart30 = "战歌峡谷战斗将在30秒钟内开始。做好准备！",
	Alliance = "联盟",
	Horde = "部落",	
	InfoErrorText = "携带旗帜者目标功能会在你脱离战斗后恢复。",
	ExprFlagPickUp = "(.+)的旗帜被(.+)拔起了！",
	ExprFlagCaptured = "(.+)夺取了(.+)的旗帜！",
	ExprFlagReturn = "(.+)的旗帜被(.+)还到了它的基地中！",
	FlagAlliance = "联盟: ",
	FlagHorde = "部落: ",
	FlagBase = "基地",
})

L:SetTimerLocalization({
	TimerStart = "战斗即将开始", 
	TimerFlag = "旗帜重置",
})

L:SetOptionLocalization({
	TimerStart  = "显示开始计时",
	TimerFlag = "显示旗帜重置计时",
	ShowFlagCarrier = "显示旗帜携带者",
	ShowFlagCarrierErrorNote = "战斗中显示旗帜携带者错误信息",
})

------------------------
--  Isle of Conquest  --
------------------------
L = DBM:GetModLocalization("IsleofConquest")

L:SetGeneralLocalization({
	name 				= "征服之岛"
})

L:SetWarningLocalization({
	WarnSiegeEngine			= "攻城机具准备好了！",
	WarnSiegeEngineSoon		= "10秒后 攻城机具就绪"
})

L:SetTimerLocalization({
	TimerPOI			= "%s",
	TimerSiegeEngine		= "攻城机具修复"
})

L:SetOptionLocalization({
	TimerStart			= "显示开始计时", 
	TimerPOI			= "显示夺取计时",
	TimerSiegeEngine		= "为攻城机具的修复显示计时条",
	WarnSiegeEngine			= "当攻城机具准备好时显示警报",
	WarnSiegeEngineSoon		= "当攻城机具接近准备好时显示警报"
})

L:SetMiscLocalization({
	GatesHealthFrame		= "城门破损状况",
	SiegeEngine			= "攻城机具",
	GoblinStartAlliance		= "看到那些爆盐炸弹了吗?当我维修攻城机具的时候用它们来轰破大门!",
	GoblinStartHorde		= "修理攻城机具的工作就交给我，帮我看着点就够了。如果你想要轰破大门的话，尽管把那些爆盐炸弹拿去用吧!",
	GoblinHalfwayAlliance		= "我已经修好一半了!别让部落靠近。工程学院可没有教我们如何作战喔!",
	GoblinHalfwayHorde		= "我已经修好一半了!别让联盟靠近 - 我的合约里可没有作战这一条!",
	GoblinFinishedAlliance		= "我有史以来最得意的作品!这台攻城机具已经可以上场啰!",
	GoblinFinishedHorde		= "这台攻城机具已经可以上场啦!",
	GoblinBrokenAlliance		= "这么快就坏啦?!别担心，再坏的情况我都可以修得好。",
	GoblinBrokenHorde		= "又坏掉了吗?!让我来修理吧…但别指望产品的保固会帮你支付这一切。"
})

------------------
--  Twin Peaks  --
------------------
L = DBM:GetModLocalization("TwinPeaks")

L:SetGeneralLocalization({
	name = "双子峰"
})

L:SetMiscLocalization({
	BgStart60 			= "The battle begins in 1 minute.",
	BgStart30 			= "The battle begins in 30 seconds.  Prepare yourselves!",
	ZoneName 			= "双子峰",
	Alliance 			= "联盟",
	Horde 				= "部落",	
	InfoErrorText		= "携带旗帜者目标功能会在你脱离战斗后恢复。",
	ExprFlagPickUp = "(.+)的旗帜被(.+)拔起了！",
	ExprFlagCaptured = "(.+)夺取了(.+)的旗帜！",
	ExprFlagReturn = "(.+)的旗帜被(.+)还到了它的基地中！",
	FlagAlliance = "联盟: ",
	FlagHorde = "部落: ",
	FlagBase = "基地",
})

L:SetTimerLocalization({
	TimerStart = "战斗即将开始", 
	TimerFlag = "旗帜重置",
})

L:SetOptionLocalization({
	TimerStart  = "显示开始计时",
	TimerFlag = "显示旗帜重置计时",
	ShowFlagCarrier = "显示旗帜携带者",
	ShowFlagCarrierErrorNote = "战斗中显示旗帜携带者错误信息",
})

--------------------------
--  Battle for Gilneas  --
--------------------------
L = DBM:GetModLocalization("Gilneas")

L:SetGeneralLocalization({
	name = "吉尔尼斯之战"	-- translate
})

L:SetMiscLocalization({
	BgStart60 = "阿拉希盆地的战斗将在1分钟后开始。",
	BgStart30 = "阿拉希盆地的战斗将在30秒后开始。",
	ScoreExpr = "(%d+)/2000",
	Alliance = "联盟",
	Horde = "部落",
	WinBarText = "%s 获胜",
	BasesToWin = "胜利需要占领资源: %d",
	Flag = "旗帜"
})

L:SetTimerLocalization({
	TimerStart = "战斗即将开始", 
	TimerCap = "%s",
})

L:SetOptionLocalization({
	TimerStart  = "显示开始计时",
	TimerWin = "显示获胜计时",
	TimerCap = "显示占领计时",
	ShowGilneasEstimatedPoints = "显示战斗结束时双方资源统计",
	ShowGilneasBasesToWin = "显示获胜需要占领的资源点"
})