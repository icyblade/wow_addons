 local lib = LibStub and LibStub("LibRetail", true)
if not lib then return end

-- Backport variables
local SHORTDATENOYEAR_EU = "%1$d/%2$d/%3$02d"

-- Set to false in some locale specific files.
local TIME_UTIL_WHITE_SPACE_STRIPPABLE = true;

local SECONDS_PER_MIN = 60;
local SECONDS_PER_HOUR = 60 * SECONDS_PER_MIN;
local SECONDS_PER_DAY = 24 * SECONDS_PER_HOUR;
local SECONDS_PER_MONTH = 30 * SECONDS_PER_DAY;
local SECONDS_PER_YEAR = 12 * SECONDS_PER_MONTH;

function lib.SecondsToMinutes(seconds)
	return seconds / SECONDS_PER_MIN;
end

function lib.MinutesToSeconds(minutes)
	return minutes * SECONDS_PER_MIN;
end

function lib.HasTimePassed(testTime, amountOfTime)
	return ((time() - testTime) >= amountOfTime);
end

lib.SecondsFormatter = {};
lib.SecondsFormatter.Abbreviation =
{
	None = 1, -- seconds, minutes, hours...
	Truncate = 2, -- sec, min, hr...
	OneLetter = 3, -- s, m, h...
}

lib.SecondsFormatter.Interval = {
	Seconds = 1,
	Minutes = 2,
	Hours = 3,
	Days = 4,
}

lib.SecondsFormatter.IntervalDescription = {
	[lib.SecondsFormatter.Interval.Seconds] = {seconds = 1, formatString = { D_SECONDS, SECONDS_ABBR, SECOND_ONELETTER_ABBR}},
	[lib.SecondsFormatter.Interval.Minutes] = {seconds = SECONDS_PER_MIN, formatString = {D_MINUTES, MINUTES_ABBR, MINUTE_ONELETTER_ABBR}},
	[lib.SecondsFormatter.Interval.Hours] = {seconds = SECONDS_PER_HOUR, formatString = {D_HOURS, HOURS_ABBR, HOUR_ONELETTER_ABBR}},
	[lib.SecondsFormatter.Interval.Days] = {seconds = SECONDS_PER_DAY, formatString = {D_DAYS, DAYS_ABBR, DAY_ONELETTER_ABBR}},
}

--[[ Seconds formatter to standardize representations of seconds. When adding a new formatter
please consider if a prexisting formatter suits your needs, otherwise, before adding a new formatter,
consider adding it to a file appropriate to it's intended use. For example, "WorldQuestsSecondsFormatter"
could be added to QuestUtil.h so it's immediately apparent the scenarios the formatter is appropriate.]]

lib.SecondsFormatterMixin = {}
-- defaultAbbreviation: the default abbreviation for the format. Can be overrridden in SecondsFormatterMixin:Format()
-- approximationSeconds: threshold for representing the seconds as an approximation (ex. "< 2 hours").
-- roundUpLastUnit: determines if the last unit in the output format string is ceiled (floored by default).
-- convertToLower: converts the format string to lowercase.
function lib.SecondsFormatterMixin:Init(approximationSeconds, defaultAbbreviation, roundUpLastUnit, convertToLower)
	lib.SecondsFormatterMixin.approximationSeconds = approximationSeconds or 0;
	lib.SecondsFormatterMixin.defaultAbbreviation = defaultAbbreviation or lib.SecondsFormatter.Abbreviation.None;
	lib.SecondsFormatterMixin.roundUpLastUnit = roundUpLastUnit or false;
	lib.SecondsFormatterMixin.stripIntervalWhitespace = false;
	lib.SecondsFormatterMixin.convertToLower = convertToLower or false;
end

function lib.SecondsFormatterMixin:SetStripIntervalWhitespace(strip)
	lib.SecondsFormatterMixin.stripIntervalWhitespace = strip;
end

function lib.SecondsFormatterMixin:GetStripIntervalWhitespace()
	return lib.SecondsFormatterMixin.stripIntervalWhitespace;
end

function lib.SecondsFormatterMixin:GetMaxInterval()
	return #lib.SecondsFormatter.IntervalDescription;
end

function lib.SecondsFormatterMixin:GetIntervalDescription(interval)
	return lib.SecondsFormatter.IntervalDescription[interval];
end

function lib.SecondsFormatterMixin:GetIntervalSeconds(interval)
	local intervalDescription = lib.SecondsFormatterMixin:GetIntervalDescription(interval);
	return intervalDescription and intervalDescription.seconds or nil;
end

function lib.SecondsFormatterMixin:CanApproximate(seconds)
	return (seconds > 0 and seconds < lib.SecondsFormatterMixin:GetApproximationSeconds());
end

function lib.SecondsFormatterMixin:GetDefaultAbbreviation()
	return lib.SecondsFormatterMixin.defaultAbbreviation;
end

function lib.SecondsFormatterMixin:GetApproximationSeconds()
	return lib.SecondsFormatterMixin.approximationSeconds;
end

function lib.SecondsFormatterMixin:CanRoundUpLastUnit()
	return lib.SecondsFormatterMixin.roundUpLastUnit;
end

function lib.SecondsFormatterMixin:GetDesiredUnitCount(seconds)
	return 2;
end

function lib.SecondsFormatterMixin:GetMinInterval(seconds)
	return lib.SecondsFormatter.Interval.Seconds;
end

function lib.SecondsFormatterMixin:GetFormatString(interval, abbreviation, convertToLower)
	local intervalDescription = lib.SecondsFormatterMixin:GetIntervalDescription(interval);
	local formatString = intervalDescription.formatString[abbreviation];
	if convertToLower then
		formatString = formatString:lower();
	end
	local strip = TIME_UTIL_WHITE_SPACE_STRIPPABLE and lib.SecondsFormatterMixin:GetStripIntervalWhitespace();
	return strip and formatString:gsub(" ", "") or formatString;
end

function lib.SecondsFormatterMixin:FormatZero(abbreviation, toLower)
	local minInterval = lib.SecondsFormatterMixin:GetMinInterval(seconds);
	local formatString = lib.SecondsFormatterMixin:GetFormatString(minInterval, abbreviation);
	return formatString:format(0);
end

function lib.SecondsFormatterMixin:FormatMillseconds(millseconds, abbreviation)
	return lib.SecondsFormatterMixin:Format(millseconds/1000, abbreviation);
end

function lib.SecondsFormatterMixin:Format(seconds, abbreviation)
	if (seconds == nil) then
		return "";
	end

	seconds = math.ceil(seconds);
	abbreviation = abbreviation or lib.SecondsFormatterMixin:GetDefaultAbbreviation();

	if (seconds <= 0) then
		return lib.SecondsFormatterMixin:FormatZero(abbreviation);
	end

	local minInterval = lib.SecondsFormatterMixin:GetMinInterval(seconds);
	local maxInterval = lib.SecondsFormatterMixin:GetMaxInterval();

	if (lib.SecondsFormatterMixin:CanApproximate(seconds)) then
		local interval = math.max(minInterval, lib.SecondsFormatter.Interval.Minutes);
		while (interval < maxInterval) do
			local nextInterval = interval + 1;
			if (seconds > lib.SecondsFormatterMixin:GetIntervalSeconds(nextInterval)) then
				interval = nextInterval;
			else
				break;
			end
		end

		local formatString = lib.SecondsFormatterMixin:GetFormatString(interval, abbreviation, lib.SecondsFormatterMixin.convertToLower);
		local unit = formatString:format(math.ceil(seconds / lib.SecondsFormatterMixin:GetIntervalSeconds(interval)));
		return string.format(LESS_THAN_OPERAND, unit);
	end

	local output = "";
	local appendedCount = 0;
	local desiredCount = lib.SecondsFormatterMixin:GetDesiredUnitCount(seconds);
	local convertToLower = lib.SecondsFormatterMixin.convertToLower;

	local currentInterval = maxInterval;
	while ((appendedCount < desiredCount) and (currentInterval >= minInterval)) do
		local intervalDescription = lib.SecondsFormatterMixin:GetIntervalDescription(currentInterval);
		local intervalSeconds = intervalDescription.seconds;
		if (seconds >= intervalSeconds) then
			appendedCount = appendedCount + 1;
			if (output ~= "") then
				output = output..TIME_UNIT_DELIMITER;
			end

			local formatString = lib.SecondsFormatterMixin:GetFormatString(currentInterval, abbreviation, convertToLower);
			local quotient = seconds / intervalSeconds;
			if (quotient > 0) then
				if (lib.SecondsFormatterMixin:CanRoundUpLastUnit() and ((minInterval == currentInterval) or (appendedCount == desiredCount))) then
					output = output..formatString:format(math.ceil(quotient));
				else
					output = output..formatString:format(math.floor(quotient));
				end
			else
				break;
			end

			seconds = math.fmod(seconds, intervalSeconds);
		end

		currentInterval = currentInterval - 1;
	end

	-- Return the zero format if an acceptable representation couldn't be formed.
	if (output == "") then
		return lib.SecondsFormatterMixin:FormatZero(abbreviation);
	end

	return output;
end

function lib.SecondsToClock(seconds, displayZeroHours)
	seconds = math.max(seconds, 0);
	local hours = math.floor(seconds / 3600);
	seconds = seconds - (hours * 3600);
	local minutes = math.floor(seconds / 60);
	seconds = seconds % 60;
	if hours > 0 or displayZeroHours then
		return format(HOURS_MINUTES_SECONDS, hours, minutes, seconds);
	else
		return format(MINUTES_SECONDS, minutes, seconds);
	end
end

function lib.MinutesToTime(mins, hideDays)
	local time = "";
	local count = 0;
	local tempTime;
	-- only show days if hideDays is false
	if ( mins > 1440 and not hideDays ) then
		tempTime = floor(mins / 1440);
		time = TIME_UNIT_DELIMITER .. format(DAYS_ABBR, tempTime);
		mins = mod(mins, 1440);
		count = count + 1;
	end
	if ( mins > 60  ) then
		tempTime = floor(mins / 60);
		time = time .. TIME_UNIT_DELIMITER .. format(HOURS_ABBR, tempTime);
		mins = mod(mins, 60);
		count = count + 1;
	end
	if ( count < 2 ) then
		tempTime = mins;
		time = time .. TIME_UNIT_DELIMITER .. format(MINUTES_ABBR, tempTime);
		count = count + 1;
	end
	return time;
end

function lib.FormatShortDate(day, month, year)
	if (year) then
		if (LOCALE_enGB) then
			return SHORTDATE_EU:format(day, month, year);
		else
			return SHORTDATE:format(day, month, year);
		end
	else
		if (LOCALE_enGB) then
			return SHORTDATENOYEAR_EU:format(day, month);
		else
			return SHORTDATENOYEAR:format(day, month);
		end
	end
end
