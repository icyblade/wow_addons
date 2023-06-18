local lib = LibStub and LibStub("LibRetail", true)
if not lib then return end

local g_updatingBars = {};

local TARGET_FRAME_PER_SEC = 120.0;
local LERP_AMOUNT = 0.25

local function Clamp(value, min, max)
  min = min or 0
	max = max or 1

	if value > max then
		return max;
	elseif value < min then
		return min;
	end

	return value;
end

local function Saturate(value)
	return Clamp(value, 0.0, 1.0);
end

local function Lerp(startValue, endValue, amount)
	return (1 - amount) * startValue + amount * endValue;
end

local function DeltaLerp(startValue, endValue, amount, timeSec)
	return Lerp(startValue, endValue, Saturate(amount * timeSec * TARGET_FRAME_PER_SEC));
end

local function FrameDeltaLerp(startValue, endValue, amount)
	return DeltaLerp(startValue, endValue, amount, 0.1);
end

local function IsCloseEnough(bar, newValue, targetValue)
	local min, max = bar:GetMinMaxValues();
	local range = max - min;
	if range > 0.0 then
		return math.abs((newValue - targetValue) / range) < .00001;
	end

	return true;
end

local function ProcessSmoothStatusBars(_, elapsed)
	for bar, targetValue in pairs(g_updatingBars) do
    local new = Lerp(bar:GetValue(), targetValue, Clamp(LERP_AMOUNT * elapsed * TARGET_FRAME_PER_SEC))

		if IsCloseEnough(bar, new, targetValue) then
			g_updatingBars[bar] = nil;
			bar:SetValue(targetValue);
		else
			bar:SetValue(new);
		end
	end
end

local frame = CreateFrame("Frame");
if not frame:GetScript("OnUpdate") then
  frame:SetScript("OnUpdate", ProcessSmoothStatusBars)
end

lib.SmoothStatusBarMixin = {};

function lib.SmoothStatusBarMixin:ResetSmoothedValue(value) --If nil, tries to set to the last target value
	local targetValue = g_updatingBars[self];
	if targetValue then
		g_updatingBars[self] = nil;
		self:SetValue(value or targetValue);
	elseif value then
		self:SetValue(value);
	end
end

function lib.SmoothStatusBarMixin:SetSmoothedValue(value)
	g_updatingBars[self] = value;
end

function lib.SmoothStatusBarMixin:SetMinMaxSmoothedValue(min, max)
	self:SetMinMaxValues(min, max);

	local targetValue = g_updatingBars[self];
	if targetValue then
		local ratio = 1;
		if max ~= 0 and self.lastSmoothedMax and self.lastSmoothedMax ~= 0 then
			ratio = max / self.lastSmoothedMax;
		end

		g_updatingBars[self] = targetValue * ratio;
	end

	self.lastSmoothedMin = min;
	self.lastSmoothedMax = max;
end
