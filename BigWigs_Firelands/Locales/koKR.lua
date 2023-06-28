local L = BigWigs:NewBossLocale("Beth'tilac", "koKR")
if not L then return end
if L then
	L.flare_desc = "화염 광역에 대한 타이머 바를 표시합니다."
	
	L.devastate_message = "그을리는 유린 #%d"
	L.drone_bar = "잿그물 수거미"
	L.drone_message = "수거미 등장!"
	L.kiss_message = "입맞춤"
	L.spinner_warn = "실거미 #%d"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "koKR")
if L then
	L.armor = "흑요석 갑옷"
	L.armor_desc = "라이올라스의 흑요석 갑옷에 대한 중첩 & 사라짐을 알립니다."
	L.armor_message = "흑요석 갑옷 - %d%%"
	L.armor_gone_message = "흑요석 갑옷 사라짐!"

	L.adds_header = "쫄 추가"
	L.big_add_message = "큰 쫄 등장!"
	L.small_adds_message = "작은 쫄 등장!"

	L.phase2_warning = "곧 2 단계!"

	L.molten_message = "보스 공격 증가 x%d !"

	L.stomp_message = "진탕 발길! 발구르기! 발구르기!"
	L.stomp = "발구르기"
end

L = BigWigs:NewBossLocale("Alysrazor", "koKR")
if L then
	L.claw_message = "타오르는 발톱 x%2$d : %1$s"
	L.fullpower_soon_message = "곧 최대 힘!"
	L.halfpower_soon_message = "곧 4 단계!"
	L.encounter_restart = "다시 단계 반복..."
	L.no_stacks_message = "당신은 깃털이 없습니다. 생각을 가지세요..."
	L.moonkin_message = "헛짓은 그만~! 깃털을 주우세요!"
	L.molt_bar = "다음 털갈이"

	L.meteor = "유성"
	L.meteor_desc = "타오르는 유성 소환을 알립니다."
	L.meteor_message = "유 성!"

	L.stage_message = "%d 단계"
	L.kill_message = "바로 지금! - 그녀를 죽이세요!"
	L.engage_message = "알리스라조르 전투시작 - ~%d분 후 2 단계"

	L.worm_emote = "녹아내린 알이 부화하려고 합니다!"
	L.phase2_soon_emote = "알리스라조르가 빠른 속도로 원을 그리며 날아다닙니다!"

	L.flight = "날개 지속"
	L.flight_desc = "'화염의 날개'의 지속 타이머 바를 표시합니다. 특수 강조바와 카운트 기능을 이용한다면 더 효율적입니다."

	L.initiate = "수습생 소환"
	L.initiate_desc = "타오르는 발톱 수습생 소환에 대한 타이머 바를 표시합니다."
	L.initiate_both = "양쪽 수습생"
	L.initiate_west = "왼쪽 수습생"
	L.initiate_east = "오른쪽 수습생"
end

L = BigWigs:NewBossLocale("Shannox", "koKR")
if L then
	L.safe = "%s 안전함"
	L.wary_dog = "%s 조심!"
	L.crystal_trap = "수정 감옥 덫"

	L.traps_header = "덫"
	L.immolation = "개에게 제물의 덫"
	L.immolation_desc = "개들의 제물의 덫에 대해 알립니다."
	L.immolationyou = "당신의 아래에 제물의 덫"
	L.immolationyou_desc = "당신의 아래에 제물의 덫이 소환되는 것을 알립니다."
	L.immolationyou_message = "제물의 덫"
	L.crystal = "수정 감옥 덫"
	L.crystal_desc = "수정 감옥 덫에 대해 알립니다."
end

L = BigWigs:NewBossLocale("Baleroc", "koKR")
if L then
	L.torment = "주시 대상 고문 파편 중첩"
	L.torment_desc = "당신이 주시 대상으로 설정한 플레이어에 대한 고문의 파편 중첩을 알립니다."

	L.blade_bar = "~다음 칼날"
	L.shard_message = "고문의 파편(%d)!"
	L.focus_message = "당신의 주시 대상 - 고문 x%d !"
	L.link_message = "고리 연결"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "koKR")
if L then
	L.seed_explosion = "곧 씨앗 폭발!"
	L.seed_bar = "당신은 폭발!"
	L.adrenaline_message = "아드레날린 x%d!"
	L.leap_say = "나에게 도약!"
end

L = BigWigs:NewBossLocale("Ragnaros", "koKR")
if L then
	L.intermission_end_trigger1 = "설퍼라스로 숨통을 끊어 주마."
	L.intermission_end_trigger2 = "무릎 꿇어라, 필멸자여! 끝낼 시간이다."
	L.intermission_end_trigger3 = "여기까지! 이제 끝내주마."
	L.phase4_trigger = "너무 일러..."
	L.seed_explosion = "씨앗 폭발!"
	L.intermission_bar = "휴식"
	L.intermission_message = "휴식... 과자 있으세요?..."
	L.sons_left = "자손 %d 마리 남음"
	L.engulfing_close = "가까운 지역에 휘몰아치는 불길"
	L.engulfing_middle = "중간 지역에 휘몰아치는 불길"
	L.engulfing_far = "먼 지역에 휘몰아치는 불길"
	L.hand_bar = "넉백"
	L.ragnaros_back_message = "라그 돌아옴, 파티 정비!"

	L.wound = "불타는 상처"
	L.wound_desc = "!탱거만 경고! 불타는 상처의 지속바와 중첩 횟수를 표시합니다."
	L.wound_message = "상처 x%2$d : %1$s"
end

