﻿if not ACP then return end

--@non-debug@

if (GetLocale() == "koKR") then
	ACP:UpdateLocale(

{
	["*** Enabling <%s> %s your UI ***"] = "*** 애드온 <%s> %s 사용 ***",
	["*** Unknown Addon <%s> Required ***"] = "*** 알 수 없는 애드온 <%s>|1을;를; 요청 ***",
	["ACP: Some protected addons aren't loaded. Reload now?"] = "ACP: 몇몇 보호된 애드온이 로드되지 않습니다. 지금 재로드할까요?",
	["Active Embeds"] = "내장 애드온 활성화",
	["Add to current selection"] = "현재 선택된 것에 추가",
	AddOns = "애드온",
	["Addon <%s> not valid"] = "<%s> 애드온이 유효하지 않습니다.",
	["Addons [%s] Loaded."] = "애드온 [%s]|1을;를; 불러들입니다.",
	["Addons [%s] Saved."] = "애드온 [%s]|1을;를; 저장합니다.",
	["Addons [%s] Unloaded."] = "애드온 [%s]|1을;를; 불러들이지 않습니다.",
	["Addons [%s] renamed to [%s]."] = "애드온 [%s]|1을;를; [%s]|1으로;로; 이름을 변경합니다.",
	Author = "제작자",
	Blizzard_AchievementUI = "Blizzard: 업적",
	Blizzard_AuctionUI = "Blizzard: 경매장",
	Blizzard_BarbershopUI = "Blizzard: 이발소",
	Blizzard_BattlefieldMinimap = "Blizzard: 전장 미니맵",
	Blizzard_BindingUI = "Blizzard: 단축키",
	Blizzard_Calendar = "Blizzard: 달력",
	Blizzard_CombatLog = "Blizzard: 전투로그",
	Blizzard_CombatText = "Blizzard: 전투메시지",
	Blizzard_FeedbackUI = "Blizzard: 피드백",
	Blizzard_GMSurveyUI = "Blizzard: GM 요청",
	Blizzard_GlyphUI = "Blizzard: 문양",
	Blizzard_GuildBankUI = "Blizzard: 길드 은행",
	Blizzard_InspectUI = "Blizzard: 살펴보기",
	Blizzard_ItemSocketingUI = "Blizzard: 보석세공",
	Blizzard_MacroUI = "Blizzard: 매크로",
	Blizzard_RaidUI = "Blizzard: 공격대",
	Blizzard_TalentUI = "Blizzard: 특성",
	Blizzard_TimeManager = "Blizzard: 시계",
	Blizzard_TokenUI = "Blizzard: 토큰",
	Blizzard_TradeSkillUI = "Blizzard: 전문기술",
	Blizzard_TrainerUI = "Blizzard: 기술숙련",
	Blizzard_VehicleUI = "Blizzard: 탈 것",
	["Click to enable protect mode. Protected addons will not be disabled"] = "클릭하면 보호모드가 활성화 됩니다. 보호된 애드온은 비활성화할 수 없습니다.",
	Close = "닫기",
	Default = "기본값",
	Dependencies = "의존 애드온",
	["Disable All"] = "모두 미사용",
	["Disabled on reloadUI"] = "UI 재시작시 사용안함",
	Embeds = "내장 애드온",
	["Enable All"] = "모두 사용",
	["Enter the new name for [%s]:"] = "[%s]의 새로운 이름 입력:",
	["LoD Child Enable is now %s"] = "요청시 불러오기 사용이 %s",
	Load = "불러오기",
	["Loadable OnDemand"] = "요청시 불러올 수 있음",
	Loaded = "불러들임",
	["Loaded on demand."] = "요청시 불러들임",
	["Memory Usage"] = "메모리 사용량",
	["No information available."] = "알려진 정보가 없습니다.",
	Recursive = "반복",
	["Recursive Enable is now %s"] = "반복 사용이 %s",
	Reload = "재실행",
	["Reload your User Interface?"] = "당신의 사용자 인터페이스를 재시작 하시겠습니까?",
	ReloadUI = "UI 재시작", -- Needs review
	["Remove from current selection"] = "현재 선택된 것에서 삭제",
	Rename = "이름바꾸기",
	Save = "저장하기",
	["Save the current addon list to [%s]?"] = "현재 애드온 목록을 [%s]|1으로;로; 저장 하시겠습니까?",
	["Set "] = "세트 ",
	Sets = "세트",
	Status = "상태",
	["Use SHIFT to override the current enabling of dependancies behaviour."] = "현재 사용 중인 의존 애드온의 동작을 무시하려면 SHIFT키를 사용하십시요.",
	Version = "버전",
	["when performing a reloadui."] = "ReloadUI를 했을 때",
}


    )
end

--@end-non-debug@
