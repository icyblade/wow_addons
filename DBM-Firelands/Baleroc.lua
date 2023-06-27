local mod	= DBM:NewMod(196, "DBM-Firelands", nil, 78)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 7607 $"):sub(12, -3))
mod:SetCreatureID(53494)
mod:SetModelID(38621)
mod:SetZone()
mod:SetUsedIcons(8, 7, 6, 5, 4, 3, 2, 1)
mod:SetModelSound("Sound\\Creature\\BALEROC\\VO_FL_BALEROC_AGGRO.wav", "Sound\\Creature\\BALEROC\\VO_FL_BALEROC_KILL_02.wav")
--Long: You are forbidden from entering my masters domain mortals.
--Short: You have been judged

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REFRESH",
	"SPELL_AURA_REMOVED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"SPELL_CAST_START"
)

local warnDecimationBlade	= mod:NewSpellAnnounce(99352, 4, nil, mod:IsTank() or mod:IsHealer())
local warnStrike			= mod:NewAnnounce("warnStrike", 4, 99353, mod:IsTank() or mod:IsHealer())
local warnInfernoBlade		= mod:NewSpellAnnounce(99350, 3, nil, mod:IsTank())
local warnShardsTorment		= mod:NewCountAnnounce(99259, 3)
local warnTormented			= mod:NewSpellAnnounce(99402, 3)--Self only warning.
local warnCountdown			= mod:NewTargetAnnounce(99516, 4)
local yellCountdown			= mod:NewYell(99516)

local specWarnShardsTorment	= mod:NewSpecialWarningSpell(99259, nil, nil, nil, true)
local specWarnCountdown		= mod:NewSpecialWarningYou(99516)
local specWarnTormented		= mod:NewSpecialWarningYou(99402, mod:IsHealer())
local specWarnDecimation	= mod:NewSpecialWarningSpell(99352, mod:IsTank())

local timerBladeActive		= mod:NewTimer(15, "TimerBladeActive", 99352)
local timerBladeNext		= mod:NewTimer(30, "TimerBladeNext", 99350, mod:IsTank() or mod:IsHealer())	-- either Decimation Blade or Inferno Blade
local timerStrikeCD			= mod:NewTimer(5, "timerStrike", 99353, mod:IsTank() or mod:IsHealer())--5 or 2.5 sec. Variations are noted but can be auto corrected after first timer since game follows correction.
local timerShardsTorment	= mod:NewNextCountTimer(34, 99259)
local timerCountdown		= mod:NewBuffFadesTimer(8, 99516)
local timerCountdownCD		= mod:NewNextTimer(45, 99516)
local timerVitalFlame		= mod:NewBuffFadesTimer(15, 99263)
local timerTormented		= mod:NewBuffFadesTimer(40, 99402)

local countdownShards		= mod:NewCountdown(34, 99259, false)

local berserkTimer			= mod:NewBerserkTimer(360)

mod:AddBoolOption("ResetShardsinThrees", true, "announce")
mod:AddBoolOption("RangeFrame")
mod:AddBoolOption("InfoFrame", mod:IsHealer())
mod:AddBoolOption("SetIconOnCountdown")
mod:AddBoolOption("SetIconOnTorment")
mod:AddBoolOption("ArrowOnCountdown")

local bladesName = nil
local lastStrike = 0--Custom, no prototype
local currentStrike = 0--^^
local lastStrikeDiff = 0--^^
local strikeCount = 0
local shardCount = 0
local tormentIcon = 8
local countdownIcon = 2
local countdownTargets = {}
local tormentDebuff = GetSpellInfo(99257)

local function showCountdownWarning()
	warnCountdown:Show(table.concat(countdownTargets, "<, >"))
	table.wipe(countdownTargets)
	countdownIcon = 2
end

local tormentDebuffFilter
do
	tormentDebuffFilter = function(uId)
		return UnitDebuff(uId, tormentDebuff)
	end
end

function mod:OnCombatStart(delay)
	bladesName = nil
	lastStrike = 0
	currentStrike = 0
	lastStrikeDiff = 0
	strikeCount = 0
	shardCount = 0
	timerBladeNext:Start(-delay)
	table.wipe(countdownTargets)
	berserkTimer:Start(-delay)
	if self:IsDifficulty("heroic10", "heroic25") then
		timerCountdownCD:Start(-delay)
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(5, tormentDebuffFilter)--Show only people who have tormented debuff.
		end
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(L.VitalSpark)
		DBM.InfoFrame:Show(5, "playerbuffstacks", 99262, 99263, 1)
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(99516) then
		countdownTargets[#countdownTargets + 1] = args.destName
		timerCountdown:Start()
		timerCountdownCD:Start()
		if self.Options.SetIconOnCountdown then
			self:SetIcon(args.destName, countdownIcon, 8)
			countdownIcon = countdownIcon - 1
		end
		if args:IsPlayer() then
			specWarnCountdown:Show()
			yellCountdown:Yell()
		end
		if self.Options.ArrowOnCountdown and #countdownTargets == 2 then
			if countdownTargets[1] == UnitName("player") then
				DBM.Arrow:ShowRunTo(countdownTargets[2])
			elseif countdownTargets[2] == UnitName("player") then
				DBM.Arrow:ShowRunTo(countdownTargets[1])
			end
		end
		self:Unschedule(showCountdownWarning)
		self:Schedule(0.5, showCountdownWarning)
	elseif args:IsSpellID(99256, 100230, 100231, 100232) then--Torment
		if self.Options.SetIconOnTorment then
			self:SetIcon(args.destName, tormentIcon)
			tormentIcon = tormentIcon - 1
		end
	elseif args:IsSpellID(99263) and args:IsPlayer() then
		timerVitalFlame:Start()
	elseif args:IsSpellID(99352, 99405) then--Decimation Blades
		bladesName = GetSpellInfo(99353)
		lastStrike = GetTime()--Set last strike here too
		strikeCount = 0--Reset count.
		if self:IsDifficulty("normal25", "heroic25") then--The very first timer is subject to inaccuracis do to variation. But they are minor, usually within 0.5sec
			timerStrikeCD:Start(3, bladesName)
		else
			timerStrikeCD:Start(6, bladesName)--6 seconds on 10 man
		end
	elseif args:IsSpellID(99350) then--Inferno Blades
		bladesName = GetSpellInfo(101002)
		lastStrike = GetTime()--Set last strike here too
		strikeCount = 0--Reset count.
		timerStrikeCD:Start(2.5, bladesName)
	elseif args:IsSpellID(99257, 99402, 99403, 99404) then--Tormented
		if args:IsPlayer() then
			warnTormented:Show()
			specWarnTormented:Show()
			if self:IsDifficulty("normal10") then--The very first timer is subject to inaccuracis do to variation. But they are minor, usually within 0.5sec
				timerTormented:Start(20)
			elseif self:IsDifficulty("heroic10") then
				timerTormented:Start(40)
			elseif self:IsDifficulty("normal25") then
				timerTormented:Start(30)
			elseif self:IsDifficulty("heroic25") then
				timerTormented:Start(60)
			end
			if self.Options.RangeFrame and self:IsDifficulty("heroic10", "heroic25") and self:IsInCombat() then
				DBM.RangeCheck:Show(5, nil)--Show everyone, cause you're debuff person and need to stay away from people.
			end
		end
	end
end

function mod:SPELL_AURA_REFRESH(args)
	if args:IsSpellID(99257, 99402, 99403, 99404) then--Tormented
		if args:IsPlayer() then
			if self:IsDifficulty("normal10") then--The very first timer is subject to inaccuracis do to variation. But they are minor, usually within 0.5sec
				timerTormented:Start(20)
			elseif self:IsDifficulty("heroic10") then
				timerTormented:Start(40)
			elseif self:IsDifficulty("normal25") then
				timerTormented:Start(30)
			elseif self:IsDifficulty("heroic25") then
				timerTormented:Start(60)
			end
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(99352, 99405) or args:IsSpellID(99350) then--Decimation Blade/Inferno blade
		timerBladeNext:Start()--30 seconds after last blades FADED
		timerStrikeCD:Cancel()
	elseif args:IsSpellID(99256, 100230, 100231, 100232) then--Torment
		if self.Options.SetIconOnTorment then
			self:SetIcon(args.destName, 0)
		end
	elseif args:IsSpellID(99257, 99402, 99403, 99404) then--Tormented
		if args:IsPlayer() then
			timerTormented:Cancel()
			if self.Options.RangeFrame and self:IsDifficulty("heroic10", "heroic25") and self:IsInCombat() then
				DBM.RangeCheck:Show(5, tormentDebuffFilter)--Show only debuffed poeple again.
			end
		end
	end
end

function mod:SPELL_DAMAGE(sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName)
	if spellId == 99353 then--Decimation Strike
		strikeCount = strikeCount + 1
		warnStrike:Show(spellName, strikeCount)
		if strikeCount == 5 and self:IsDifficulty("normal25", "heroic25") or strikeCount == 2 and self:IsDifficulty("normal10", "heroic10") then return end--Don't do anything if it's 6th/3rd strike
		currentStrike = GetTime()--Get time of current strike stamped.
		lastStrikeDiff = currentStrike - lastStrike--Find out time difference between last strike and current strike.
		if self:IsDifficulty("normal25", "heroic25") then--The very first timer is subject to inaccuracis do to variation. But they are minor, usually within 0.5sec
			if lastStrikeDiff > 3 then--We got a late cast since it took longer then 3
				lastStrikeDiff = lastStrikeDiff - 3--Subtracked expected result (3) from diff to get what's remaining so we know how much of CD to remove from next cast.
				timerStrikeCD:Start(3-lastStrikeDiff, spellName)--Next strike is gonna come early since previous one was > 3. Subtract this diff from the timer.
			elseif lastStrikeDiff < 3 then--We got an early cast.
				lastStrikeDiff = 3 - lastStrikeDiff--Subtracked last strike difference from expected result to figure out how much time to add to next timer.
				timerStrikeCD:Start(3+lastStrikeDiff, spellName)--Next strike is gonna come late since previous one was early.
			end
		else--Do same thing as above only with 10 man timing.
			if lastStrikeDiff > 6 then
				lastStrikeDiff = lastStrikeDiff - 6
				timerStrikeCD:Start(6-lastStrikeDiff, spellName)
			elseif lastStrikeDiff < 6 then
				lastDiff = 6 - lastStrikeDiff
				timerStrikeCD:Start(6+lastStrikeDiff, spellName)
			end
		end
		lastStrike = GetTime()--Update last strike timing to this one after function fires.
	elseif spellId == 99351 or spellId == 101000 or spellId == 101001 or spellId == 101002 then--Inferno Strike
		strikeCount = strikeCount + 1
		warnStrike:Show(spellName, strikeCount)
		if strikeCount == 7 then return end--Don't do anything if it's 6th/3rd strike
		currentStrike = GetTime()--Get time of current strike stamped.
		lastStrikeDiff = currentStrike - lastStrike--Find out time difference between last strike and current strike.
		if lastStrikeDiff > 2.5 then--We got a late cast since it took longer then 2.5
			lastStrikeDiff = lastStrikeDiff - 2.5--Subtracked expected result (2.5) from diff to get what's remaining so we know how much of CD to remove from next cast.
			timerStrikeCD:Start(2.5-lastStrikeDiff, spellName)--Next strike is gonna come early since previous one was > 2.5. Subtract this diff from the timer.
		elseif lastStrikeDiff < 2.5 then--We got an early cast.
			lastStrikeDiff = 2.5 - lastStrikeDiff--Subtracked last strike difference from expected result to figure out how much time to add to next timer.
			timerStrikeCD:Start(2.5+lastStrikeDiff, spellName)--Next strike is gonna come late since previous one was early.
		end
		lastStrike = GetTime()--Update last strike timing to this one after function fires.
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE--Dodge/parried decimation strikes show as SPELL_MISSED

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(99352, 99405) then
		warnDecimationBlade:Show()
		specWarnDecimation:Show()
		timerBladeActive:Start(args.spellName)
	elseif args:IsSpellID(99350) then
		warnInfernoBlade:Show()
		timerBladeActive:Start(args.spellName)
	elseif args:IsSpellID(99259) then
		shardCount = shardCount + 1
		tormentIcon = 8
		warnShardsTorment:Show(shardCount)
		specWarnShardsTorment:Schedule(1.5)
		countdownShards:Start(34)
		if self.Options.ResetShardsinThrees and (self:IsDifficulty("normal25", "heroic25") and shardCount == 3 or self:IsDifficulty("normal10", "heroic10") and shardCount == 2) then
			shardCount = 0
			timerShardsTorment:Start(34, 1)
		else
			timerShardsTorment:Start(34, shardCount+1)
		end
	end
end