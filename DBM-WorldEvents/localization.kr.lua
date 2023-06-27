﻿if GetLocale() ~= "koKR" then return end

local L

------------
--  Omen  --
------------
L = DBM:GetModLocalization("Omen")

L:SetGeneralLocalization({
	name = "오멘"
})

-----------------------
--  Apothecary Trio  --
-----------------------
L = DBM:GetModLocalization("ApothecaryTrio")

L:SetGeneralLocalization({
	name = "화학회사 삼인방"
})

L:SetTimerLocalization{
	HummelActive	= "훔멜 활성화",
	BaxterActive	= "벡스터 활성화",
	FryeActive		= "프라이 활성화"
}

L:SetOptionLocalization({
	TrioActiveTimer		= "각 보스별 활성화 바 표시"
})

L:SetMiscLocalization({
	SayCombatStart		= "저들이 내가 누군지와 왜 이 일을 하는지 말해주려고 귀찮게 하든가?"
})

-------------
--  Ahune  --
-------------
L = DBM:GetModLocalization("Ahune")

L:SetGeneralLocalization({
	name = "아훈"
})

L:SetWarningLocalization({
	Submerged		= "아훈 잠수",
	Emerged			= "아훈 등장",
	specWarnAttack	= "아훈이 약해졌습니다. - 딜링 시작!"
})

L:SetTimerLocalization{
	SubmergTimer	= "잠수",
	EmergeTimer		= "등장",
	TimerCombat		= "전투 시작"
}

L:SetOptionLocalization({
	Submerged		= "잠수 알림 보기",
	Emerged			= "등장 알림 보기",
	specWarnAttack	= "보스 약화시 특수 경보 보기",
	SubmergTimer	= "잠수 바 표시",
	EmergeTimer		= "등장 바 표시",
	TimerCombat		= "전투 시작 바 표시",
})

L:SetMiscLocalization({
	Pull			= "얼음 기둥이 녹아 내렸다!"
})

--------------------
-- Coren Direbrew --
--------------------
L = DBM:GetModLocalization("CorenDirebrew")

L:SetGeneralLocalization({
	name = "코렌 다이어브루"
})

L:SetWarningLocalization({
	specWarnBrew			= "흑맥주요정이 맥주를 다시 던지기전에 맥주를 마셔버리세요!",
	specWarnBrewStun		= "현재 맥주 소지중. 흑맥주요정이 맥주를 다시 던지기전에 마셔버리면 됩니다!"
})

L:SetOptionLocalization({
	specWarnBrew			= "$spell:47376 특수 경고 보기",
	specWarnBrewStun		= "$spell:47340 특수 경고 보기",
	YellOnBarrel			= "$spell:51413 주문의 영향을 받은 경우 대화로 알리기"
})

L:SetMiscLocalization{
	YellBarrel				= "저에게 맥주통!"
}

-------------------
-- Headless Horseman --
-------------------
L = DBM:GetModLocalization("HeadlessHorseman")

L:SetGeneralLocalization({
	name = "저주받은 기사"
})

L:SetWarningLocalization({
	WarnPhase				= "%d 단계",
	warnHorsemanSoldiers	= "고동치는 호박 생성",
	warnHorsemanHead		= "저주받은 기사의 머리 생성"
})

L:SetTimerLocalization{
	TimerCombatStart		= "전투 시작"
}

L:SetOptionLocalization({
	WarnPhase				= "단계 전환 알림 보기",
	TimerCombatStart		= "전투 시작 바 표시",
	warnHorsemanSoldiers	= "고동치는 호박 소환 알림 보기",
	warnHorsemanHead		= "저주받은 기사 머리 생성 알림 보기"
})

L:SetMiscLocalization({
	HorsemanSummon				= "기사여, 일어나라...",
	HorsemanSoldiers			= "일어나라, 병사들이여. 나가서 싸워라! 이 쇠락한 기사에게 승리를 안겨다오!"
})

------------------------------
--  The Abominable Greench  --
------------------------------
L = DBM:GetModLocalization("Greench")

L:SetGeneralLocalization({
	name = "썩은내 그린치"
})

--------------------------
--  Blastenheimer 5000  --
--------------------------
L = DBM:GetModLocalization("Cannon")

L:SetGeneralLocalization({
	name = "인간 대포알"
})

-------------
--  Gnoll  --
-------------
L = DBM:GetModLocalization("Gnoll")

L:SetGeneralLocalization({
	name = "놀 때려잡기"
})

L:SetWarningLocalization({
	warnGameOverQuest	= "게임 종료. 획득 점수 %d 점, 획득 가능한 최대 점수 : %d 점",
	warnGameOverNoQuest	= "게임 종료. 획득 가능한 최대 점수 : %d 점",
	warnGnoll			= "놀 등장",
	warnHogger			= "들창코 놀 등장",
	specWarnHogger		= "들창코 놀 등장!"
})

L:SetOptionLocalization({
	warnGameOver	= "획득 가능한 최대 점수에 대해 알림",
	warnGnoll		= "놀 등장 알림",
	warnHogger		= "들창코 놀 등장 알림",
	specWarnHogger	= "들창코 놀 득장 특수 경고 보기"
})

------------------------
--  Shooting Gallery  --
------------------------
L = DBM:GetModLocalization("Shot")

L:SetGeneralLocalization({
	name = "사격 연습장"
})

L:SetOptionLocalization({
	SetBubbles			= "$spell:101871 진행 중일때 대화 말풍선을 표시하지 않음\n(게임 종료 후 원래대로 복구됨)"
})

----------------------
--  Tonk Challenge  --
----------------------
L = DBM:GetModLocalization("Tonks")

L:SetGeneralLocalization({
	name = "통통 전차 게임"
})

