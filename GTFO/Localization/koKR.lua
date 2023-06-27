--------------------------------------------------------------------------
-- koKR.lua 
--------------------------------------------------------------------------
--[[
GTFO Korean Localization
Translator: Sunyruru

Change Log:
	v3.5.1
		- Added Korean localization
	v3.5.2
		- Updated Korean localization
	v4.3
		- Updated Korean localization
	v4.7
		- Fixed localization issues	
	v4.9.4
		- Updated Korean localization
	v4.12
		- Added untranslated strings
		
]]--

if (GetLocale() == "koKR") then

GTFOLocal = 
{
	Active_Off = "애드온 중지",
	Active_On = "애드온 시작",
	AlertType_Fail = "피해",
	AlertType_FriendlyFire = "약한 불",
	AlertType_High = "높은 피해",
	AlertType_Low = "낮은 피해",
	ClosePopup_Message = "다음 명령을 입력해 GTFO 애드온을 설정할 수 있습니다: %s",
	Group_None = "그룹 없음",
	Group_NotInGroup = "파티나 레이드에 참가중이 아닙니다.",
	Group_PartyMembers = "파티원 중 %d/%d 명이 이 애드온을 사용중입니다.",
	Group_RaidMembers = "레이드 구성원 중 %d/%d 명이 이 애드온을 사용중입니다.",
	Help_Intro = "v%s (|cFFFFFFFF명령어 목록|r)",
	Help_Options = "옵션 표시",
	Help_Suspend = "애드온 시작/중지",
	Help_Suspended = "애드온이 현재 중지중입니다.",
	Help_TestFail = "테스트 소리 재생 (피해 알림)",
	Help_TestFriendlyFire = "테스트 음향 재생 (약한 불)",
	Help_TestHigh = "테스트 소리 재생 (높은 데미지)",
	Help_TestLow = "테스트 소리 재생 (낮은 데미지)",
	Help_Version = "이 애드온을 실행중인 레이드 구성원 표시.",
	LoadingPopup_Message = "GTFO 설정을 초기값으로 설정합니다. 설정을 지금 하시겠습니까?",
	Loading_Loaded = "v%s 로드 됨.",
	Loading_LoadedSuspended = "v%s 로드 됨. (|cFFFF1111중지중|r)",
	Loading_LoadedWithPowerAuras = "v%s & Power Auras 애드온과 함께 로드 됨.",
	Loading_NewDatabase = "v%s: 새로운 버전의 데이터베이스 발견, 세팅을 초기화 함.",
	Loading_OutOfDate = "v%s 을 새로 다운받을 수 있습니다.  |cFFFFFFFF업데이트 해주세요.|r",
	Loading_PowerAurasOutOfDate = "당신의 |cFFFFFFFFPower Auras Classic|r 버전은 옛날거에요! GTFO 와 Power Auras 애드온이 호환되지 않네요. ㅠㅅㅠ",
	Recount_Environmental = "주변환경 피해",
	Recount_Name = "GTFO 경고",
	Skada_AlertList = "GTFO 경고 방식",
	Skada_Category = "경고",
	Skada_SpellList = "GTFO 기술",
	TestSound_Fail = "테스트 소리(피해 알림) 재생중.",
	TestSound_FailMuted = "테스트 소리(피해 알림) 재생중. [|cFFFF4444소리 끄기|r]",
	TestSound_FriendlyFire = "테스트 음향(약한 불) 재생중.",
	TestSound_FriendlyFireMuted = "테스트 음향(약한 불) 재생중. [|cFFFF4444소리 꺼짐|r]",
	TestSound_High = "테스트 소리(높은 데미지) 재생중.",
	TestSound_HighMuted = "테스트 소리(높은 데미지) 재생중. [|cFFFF4444소리 끄기|r]",
	TestSound_Low = "테스트 소리(낮은 데미지) 재생중.",
	TestSound_LowMuted = "테스트 소리(낮은 데미지) 재생중. [|cFFFF4444소리 끄기|r]",
	UI_Enabled = "활성화",
	UI_EnabledDescription = "GTFO 애드온을 활성화 합니다.",
	UI_Fail = "피해 알림 소리",
	UI_FailDescription = "이동 실패에 대한 GTFO 알림 활성화 -- 다음에는 배워서 피하기를!",
	UI_FriendlyFire = "약한 불 음향",
	UI_FriendlyFireDescription = "GTFO 사용시 아군이 불위를 걸어갈 때 경고음을 재생합니다. -- 누군가는 움직이는게 좋겠죠?",
	UI_HighDamage = "레이드:높은 데미지 소리",
	UI_HighDamageDescription = "GTFO 사용시 즉시 다른 곳으로 움직여야 할 때 소리 재생됩니다.",
	UI_LowDamage = "PVP 또는 평소: 낮은 데미지 소리",
	UI_LowDamageDescription = "GTFO 사용시 움직이던 말던 상관없는 낮은 데미지에 소리가 재생됩니다.",
	UI_Test = "테스트",
	UI_TestDescription = "테스트 소리",
	UI_TestMode = "시험(베타) 모드",
	UI_TestModeDescription = "테스트되지 않고 검증되지 않은 경고 모드를 활성화합니다. (베타)",
	UI_TestModeDescription2 = "어떠한 문제점이 발견되면 꼭!  |cFF44FFFF%s@%s.%s|r 으로 내용을 보내주세요!",
	UI_Trivial = "무시해도 되는 경고",
	UI_TrivialDescription = "현재 레벨의 당신의 캐릭터에게 무시해도 되는 낮은 수준의 경고를 활성화합니다.",
	UI_Unmute = "소리가 꺼졌을 때에도 소리 재생",
	UI_UnmuteDescription = "주 음향과 음향효과를 껐을 때에도, GTFO 애드온이 잠시 소리를 켭니다.",
	UI_UnmuteDescription2 = "이 설정은 볼륨 슬라이드 바가 0보다 커야 작동합니다.",
	UI_Volume = "GTFO 소리",
	UI_VolumeDescription = "음향을 재생할 소리 크기",
	UI_VolumeLoud = "4: 크게",
	UI_VolumeLouder = "5: 시끄럽게",
	UI_VolumeMax = "최대",
	UI_VolumeMin = "최소",
	UI_VolumeNormal = "3: 보통 (권장)",
	UI_VolumeQuiet = "1:조용히",
	UI_VolumeSoft = "2:작게",
	-- 4.12
	UI_SpecialAlerts = "Special Alerts",
	UI_SpecialAlertsHeader = "Activate Special Alerts",	
	-- 4.12.3
	Version_On = "Version reminders on",
	Version_Off = "Version reminders off",
}


end