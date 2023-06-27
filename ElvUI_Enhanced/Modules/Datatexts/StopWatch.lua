local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local EE = E:GetModule("ElvUI_Enhanced")

local _G = _G

local IsShiftKeyDown = IsShiftKeyDown
local STOPWATCH_TIME_UNIT = STOPWATCH_TIME_UNIT
local STOPWATCH_TITLE = STOPWATCH_TITLE
local NEWBIE_TOOLTIP_STOPWATCH_PLAYPAUSEBUTTON = NEWBIE_TOOLTIP_STOPWATCH_PLAYPAUSEBUTTON
local NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON = NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON
local SHOW = SHOW
local HIDE = HIDE

local SEC_TO_MINUTE_FACTOR = 1 / 60
local SEC_TO_HOUR_FACTOR = SEC_TO_MINUTE_FACTOR * SEC_TO_MINUTE_FACTOR

local function OnUpdate(self)
	local timer = StopwatchTicker.timer
	local hour = min(floor(timer * SEC_TO_HOUR_FACTOR), 99)
	local minute = mod(timer * SEC_TO_MINUTE_FACTOR, 60)
	local second = mod(timer, 60)

	self.text:SetFormattedText(STOPWATCH_TIME_UNIT..":"..STOPWATCH_TIME_UNIT..":"..STOPWATCH_TIME_UNIT, hour, minute, second)
end

local function OnClick(_, button)
	if button == "LeftButton" then
		if IsShiftKeyDown() then
			Stopwatch_Clear()
		else
			if not Stopwatch_IsPlaying() then
				Stopwatch_Play()
			else
				Stopwatch_Pause()
			end
		end
	end

	if button == "RightButton" then
		Stopwatch_Toggle()
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	DT.tooltip:ClearLines()
	DT.tooltip:AddLine(STOPWATCH_TITLE)
	DT.tooltip:AddLine(" ")

	DT.tooltip:AddDoubleLine("Left-Click:", NEWBIE_TOOLTIP_STOPWATCH_PLAYPAUSEBUTTON, 1, 1, 1)
	DT.tooltip:AddDoubleLine("Shift+Left-Click:", NEWBIE_TOOLTIP_STOPWATCH_RESETBUTTON, 1, 1, 1)
	DT.tooltip:AddDoubleLine("Right-Click:", SHOW.."/"..HIDE.." "..STOPWATCH_TITLE, 1, 1, 1)

	DT.tooltip:Show()
end

DT:RegisterDatatext("StopWatch", nil, nil, OnUpdate, OnClick, OnEnter, nil, EE:ColorizeSettingName(STOPWATCH_TITLE))